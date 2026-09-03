[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path,

    [Parameter(Mandatory = $false)]
    [string]$OutputPath,

    [Parameter(Mandatory = $false)]
    [switch]$IncludeFileName
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function New-Result {
    param([string]$ResolvedPath, [string]$SourceType)
    [ordered]@{
        schema_report_version = 1
        generated_at_utc = (Get-Date).ToUniversalTime().ToString('o')
        source_type = $SourceType
        source_file = $(if ($IncludeFileName) { [System.IO.Path]::GetFileName($ResolvedPath) } else { $null })
        privacy_note = 'This report intentionally omits row values. Schema and internal terminology can still be sensitive; review before sharing.'
        structures = @()
        warnings = @()
    }
}

function Get-CsvSchema {
    param([string]$ResolvedPath, [string]$Delimiter, [string]$SourceType)

    $result = New-Result -ResolvedPath $ResolvedPath -SourceType $SourceType
    Add-Type -AssemblyName Microsoft.VisualBasic
    $parser = New-Object Microsoft.VisualBasic.FileIO.TextFieldParser($ResolvedPath)
    try {
        $parser.TextFieldType = [Microsoft.VisualBasic.FileIO.FieldType]::Delimited
        $parser.SetDelimiters($Delimiter)
        $parser.HasFieldsEnclosedInQuotes = $true
        $parser.TrimWhiteSpace = $false
        if ($parser.EndOfData) { throw 'The file is empty.' }
        $headers = @($parser.ReadFields())
    }
    finally {
        $parser.Close()
    }

    $result.structures += [ordered]@{
        name = [System.IO.Path]::GetFileName($ResolvedPath)
        kind = 'delimited_file'
        columns = @($headers | ForEach-Object {
            [ordered]@{ name = $_; declared_type = 'unknown' }
        })
    }
    return $result
}

function Get-XlsxSharedStrings {
    param($Archive)

    $map = @()
    $entry = $Archive.GetEntry('xl/sharedStrings.xml')
    if ($null -eq $entry) { return $map }

    $stream = $entry.Open()
    $reader = $null
    try {
        $reader = New-Object System.IO.StreamReader($stream)
        [xml]$xml = $reader.ReadToEnd()
    }
    finally {
        if ($reader) { $reader.Dispose() }
        $stream.Dispose()
    }

    $ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
    $ns.AddNamespace('x', 'http://schemas.openxmlformats.org/spreadsheetml/2006/main')
    foreach ($si in $xml.SelectNodes('//x:si', $ns)) {
        $parts = @($si.SelectNodes('.//x:t', $ns) | ForEach-Object { $_.'#text' })
        $map += ($parts -join '')
    }
    return $map
}

function Get-XlsxCellText {
    param($Cell, [string[]]$SharedStrings, $NamespaceManager)

    $cellType = $Cell.GetAttribute('t')
    if ($cellType -eq 'inlineStr') {
        $parts = @($Cell.SelectNodes('.//x:t', $NamespaceManager) | ForEach-Object { $_.'#text' })
        return ($parts -join '')
    }

    $valueNode = $Cell.SelectSingleNode('./x:v', $NamespaceManager)
    if ($null -eq $valueNode) { return '' }
    $raw = [string]$valueNode.InnerText

    if ($cellType -eq 's') {
        $index = 0
        if ([int]::TryParse($raw, [ref]$index) -and $index -ge 0 -and $index -lt $SharedStrings.Count) {
            return [string]$SharedStrings[$index]
        }
    }
    return $raw
}

function Get-XlsxSchema {
    param([string]$ResolvedPath)

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $result = New-Result -ResolvedPath $ResolvedPath -SourceType 'xlsx'
    $archive = [System.IO.Compression.ZipFile]::OpenRead($ResolvedPath)
    try {
        $sharedStrings = @(Get-XlsxSharedStrings -Archive $archive)

        $workbookEntry = $archive.GetEntry('xl/workbook.xml')
        $relsEntry = $archive.GetEntry('xl/_rels/workbook.xml.rels')
        if ($null -eq $workbookEntry -or $null -eq $relsEntry) {
            throw 'The XLSX file is missing required workbook metadata.'
        }

        $wbStream = $workbookEntry.Open()
        $relsStream = $relsEntry.Open()
        $wbReader = $null
        $relsReader = $null
        try {
            $wbReader = New-Object System.IO.StreamReader($wbStream)
            $relsReader = New-Object System.IO.StreamReader($relsStream)
            [xml]$workbook = $wbReader.ReadToEnd()
            [xml]$rels = $relsReader.ReadToEnd()
        }
        finally {
            if ($wbReader) { $wbReader.Dispose() }
            if ($relsReader) { $relsReader.Dispose() }
            $wbStream.Dispose()
            $relsStream.Dispose()
        }

        $wbNs = New-Object System.Xml.XmlNamespaceManager($workbook.NameTable)
        $wbNs.AddNamespace('x', 'http://schemas.openxmlformats.org/spreadsheetml/2006/main')
        $wbNs.AddNamespace('r', 'http://schemas.openxmlformats.org/officeDocument/2006/relationships')

        $relMap = @{}
        foreach ($rel in $rels.Relationships.Relationship) {
            $relMap[[string]$rel.Id] = [string]$rel.Target
        }

        foreach ($sheet in $workbook.SelectNodes('//x:sheets/x:sheet', $wbNs)) {
            $sheetName = [string]$sheet.GetAttribute('name')
            $relationshipId = [string]$sheet.GetAttribute('id', 'http://schemas.openxmlformats.org/officeDocument/2006/relationships')
            if (-not $relMap.ContainsKey($relationshipId)) { continue }

            $target = $relMap[$relationshipId].Replace('\', '/')
            if ($target.StartsWith('/')) {
                $entryPath = $target.TrimStart('/')
            }
            elseif ($target.StartsWith('xl/')) {
                $entryPath = $target
            }
            else {
                $entryPath = 'xl/' + $target.TrimStart('./')
            }

            $sheetEntry = $archive.GetEntry($entryPath)
            if ($null -eq $sheetEntry) {
                $result.warnings += "Could not inspect worksheet '$sheetName' ($entryPath)."
                continue
            }

            $sheetStream = $sheetEntry.Open()
            $sheetReader = $null
            try {
                $sheetReader = New-Object System.IO.StreamReader($sheetStream)
                [xml]$sheetXml = $sheetReader.ReadToEnd()
            }
            finally {
                if ($sheetReader) { $sheetReader.Dispose() }
                $sheetStream.Dispose()
            }

            $sheetNs = New-Object System.Xml.XmlNamespaceManager($sheetXml.NameTable)
            $sheetNs.AddNamespace('x', 'http://schemas.openxmlformats.org/spreadsheetml/2006/main')

            $headerRow = $null
            foreach ($rowNode in $sheetXml.SelectNodes('//x:sheetData/x:row', $sheetNs)) {
                if ($rowNode.SelectNodes('./x:c', $sheetNs).Count -gt 0) {
                    $headerRow = $rowNode
                    break
                }
            }

            $headers = @()
            if ($null -ne $headerRow) {
                foreach ($cell in $headerRow.SelectNodes('./x:c', $sheetNs)) {
                    $text = Get-XlsxCellText -Cell $cell -SharedStrings $sharedStrings -NamespaceManager $sheetNs
                    if ([string]::IsNullOrWhiteSpace($text)) {
                        $headers += '<blank-header>'
                    }
                    else {
                        $headers += $text
                    }
                }
            }

            $result.structures += [ordered]@{
                name = $sheetName
                kind = 'worksheet'
                header_row = $(if ($null -ne $headerRow) { [int]$headerRow.GetAttribute('r') } else { $null })
                columns = @($headers | ForEach-Object {
                    [ordered]@{ name = $_; declared_type = 'unknown' }
                })
            }
        }

        foreach ($tableEntry in @($archive.Entries | Where-Object { $_.FullName -like 'xl/tables/*.xml' })) {
            $tableStream = $tableEntry.Open()
            $tableReader = $null
            try {
                $tableReader = New-Object System.IO.StreamReader($tableStream)
                [xml]$tableXml = $tableReader.ReadToEnd()
            }
            finally {
                if ($tableReader) { $tableReader.Dispose() }
                $tableStream.Dispose()
            }

            $tableNs = New-Object System.Xml.XmlNamespaceManager($tableXml.NameTable)
            $tableNs.AddNamespace('x', 'http://schemas.openxmlformats.org/spreadsheetml/2006/main')
            $tableNode = $tableXml.SelectSingleNode('/x:table', $tableNs)
            if ($null -eq $tableNode) { continue }

            $tableName = [string]$tableNode.GetAttribute('displayName')
            if ([string]::IsNullOrWhiteSpace($tableName)) {
                $tableName = [string]$tableNode.GetAttribute('name')
            }
            $tableColumns = @($tableXml.SelectNodes('//x:tableColumns/x:tableColumn', $tableNs) | ForEach-Object {
                [ordered]@{ name = [string]$_.GetAttribute('name'); declared_type = 'unknown' }
            })

            $result.structures += [ordered]@{
                name = $tableName
                kind = 'excel_table'
                columns = $tableColumns
            }
        }
    }
    finally {
        $archive.Dispose()
    }
    return $result
}

function Invoke-SqliteJson {
    param([string]$ResolvedPath, [string]$Sql)

    $sqlite = Get-Command sqlite3 -ErrorAction SilentlyContinue
    if ($null -eq $sqlite) {
        throw 'SQLite inspection requires sqlite3.exe on PATH. Install SQLite CLI locally or use a scrubbed schema description instead.'
    }

    $output = & $sqlite.Source -json $ResolvedPath $Sql
    if ($LASTEXITCODE -ne 0) {
        throw 'sqlite3 failed while inspecting schema.'
    }
    if ([string]::IsNullOrWhiteSpace(($output -join "`n"))) { return @() }
    return @(($output -join "`n") | ConvertFrom-Json)
}

function Get-SqliteSchema {
    param([string]$ResolvedPath)

    $result = New-Result -ResolvedPath $ResolvedPath -SourceType 'sqlite'
    $objects = @(Invoke-SqliteJson -ResolvedPath $ResolvedPath -Sql "SELECT name, type FROM sqlite_master WHERE type IN ('table','view') AND name NOT LIKE 'sqlite_%' ORDER BY type,name;")

    foreach ($obj in $objects) {
        $name = [string]$obj.name
        $safeName = $name.Replace("'", "''")
        $columns = @(Invoke-SqliteJson -ResolvedPath $ResolvedPath -Sql "PRAGMA table_info('$safeName');")
        $result.structures += [ordered]@{
            name = $name
            kind = [string]$obj.type
            columns = @($columns | ForEach-Object {
                [ordered]@{
                    name = [string]$_.name
                    declared_type = [string]$_.type
                    not_null = ([int]$_.notnull -eq 1)
                    primary_key_order = [int]$_.pk
                }
            })
        }
    }
    return $result
}

$resolvedPath = (Resolve-Path -LiteralPath $Path).Path
if (-not (Test-Path -LiteralPath $resolvedPath -PathType Leaf)) {
    throw 'Path must refer to a file.'
}

$extension = [System.IO.Path]::GetExtension($resolvedPath).ToLowerInvariant()
switch ($extension) {
    '.csv' { $result = Get-CsvSchema -ResolvedPath $resolvedPath -Delimiter ',' -SourceType 'csv' }
    '.tsv' { $result = Get-CsvSchema -ResolvedPath $resolvedPath -Delimiter "`t" -SourceType 'tsv' }
    '.xlsx' { $result = Get-XlsxSchema -ResolvedPath $resolvedPath }
    '.xlsm' { $result = Get-XlsxSchema -ResolvedPath $resolvedPath }
    '.sqlite' { $result = Get-SqliteSchema -ResolvedPath $resolvedPath }
    '.sqlite3' { $result = Get-SqliteSchema -ResolvedPath $resolvedPath }
    '.db' { $result = Get-SqliteSchema -ResolvedPath $resolvedPath }
    default { throw "Unsupported source type '$extension'. Supported: .csv, .tsv, .xlsx, .xlsm, .sqlite, .sqlite3, .db" }
}

$json = $result | ConvertTo-Json -Depth 12
if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $json
}
else {
    $target = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
    $parent = Split-Path -Parent $target
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    [System.IO.File]::WriteAllText($target, $json, [System.Text.UTF8Encoding]::new($false))
    Write-Host "Schema report written to: $target"
    Write-Host 'Review the JSON before sharing it. Schema and internal terminology can still be sensitive.'
}
