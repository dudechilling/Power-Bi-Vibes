[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Inspector = Join-Path $PSScriptRoot 'inspect-source.ps1'
$TempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("pbv-inspect-source-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $TempRoot -Force | Out-Null

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw "ASSERTION FAILED: $Message" }
}

function Get-ColumnName {
    param([int]$Index)
    $name = ''
    $n = $Index
    while ($n -gt 0) {
        $n--
        $name = [char](65 + ($n % 26)) + $name
        $n = [math]::Floor($n / 26)
    }
    return $name
}

function Add-ZipText {
    param($Archive, [string]$EntryName, [string]$Text)
    $entry = $Archive.CreateEntry($EntryName)
    $stream = $entry.Open()
    $writer = New-Object System.IO.StreamWriter($stream, [System.Text.UTF8Encoding]::new($false))
    try { $writer.Write($Text) }
    finally {
        $writer.Dispose()
        $stream.Dispose()
    }
}

function New-TestXlsx {
    param(
        [string]$Path,
        [object[]]$Rows,
        [string]$MergeRef
    )

    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $stream = [System.IO.File]::Open($Path, [System.IO.FileMode]::Create)
    $archive = New-Object System.IO.Compression.ZipArchive($stream, [System.IO.Compression.ZipArchiveMode]::Create, $false)
    try {
        Add-ZipText $archive '[Content_Types].xml' '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/><Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/></Types>'
        Add-ZipText $archive '_rels/.rels' '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/></Relationships>'
        Add-ZipText $archive 'xl/workbook.xml' '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><sheets><sheet name="Sheet1" sheetId="1" r:id="rId1"/></sheets></workbook>'
        Add-ZipText $archive 'xl/_rels/workbook.xml.rels' '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/></Relationships>'

        $rowXml = New-Object System.Text.StringBuilder
        foreach ($rowSpec in $Rows) {
            $rowNumber = [int]$rowSpec.Row
            [void]$rowXml.Append("<row r=\"$rowNumber\">")
            $values = @($rowSpec.Values)
            for ($i = 0; $i -lt $values.Count; $i++) {
                if ($null -eq $values[$i]) { continue }
                $cellRef = "$(Get-ColumnName ($i + 1))$rowNumber"
                $escaped = [System.Security.SecurityElement]::Escape([string]$values[$i])
                [void]$rowXml.Append("<c r=\"$cellRef\" t=\"inlineStr\"><is><t>$escaped</t></is></c>")
            }
            [void]$rowXml.Append('</row>')
        }

        $mergeXml = ''
        if (-not [string]::IsNullOrWhiteSpace($MergeRef)) {
            $mergeXml = "<mergeCells count=\"1\"><mergeCell ref=\"$MergeRef\"/></mergeCells>"
        }

        $sheetXml = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><worksheet xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\"><sheetData>$($rowXml.ToString())</sheetData>$mergeXml</worksheet>"
        Add-ZipText $archive 'xl/worksheets/sheet1.xml' $sheetXml
    }
    finally {
        $archive.Dispose()
        $stream.Dispose()
    }
}

function Invoke-InspectorJson {
    param([object[]]$Arguments)
    $raw = & $Inspector @Arguments | Out-String
    return $raw | ConvertFrom-Json
}

try {
    $csv = Join-Path $TempRoot 'normal.csv'
    [System.IO.File]::WriteAllText($csv, "Name,Cost,Status`r`nSECRET_ROW_VALUE,10,Open`r`n", [System.Text.UTF8Encoding]::new($false))
    $csvResult = Invoke-InspectorJson @($csv)
    Assert-True ($csvResult.structures[0].columns.Count -eq 3) 'comma CSV should expose three headers'
    Assert-True ($csvResult.structures[0].columns[0].name -eq 'Name') 'comma CSV first header should be Name'
    Assert-True (($csvResult | ConvertTo-Json -Depth 12) -notmatch 'SECRET_ROW_VALUE') 'CSV data-row values must not appear in output'

    $tsv = Join-Path $TempRoot 'normal.tsv'
    [System.IO.File]::WriteAllText($tsv, "Name`tCost`tStatus`r`nSECRET_ROW_VALUE`t10`tOpen`r`n", [System.Text.UTF8Encoding]::new($false))
    $tsvResult = Invoke-InspectorJson @($tsv)
    Assert-True ($tsvResult.structures[0].columns.Count -eq 3) 'TSV should use tab delimiter by default'

    $semi = Join-Path $TempRoot 'semicolon.csv'
    [System.IO.File]::WriteAllText($semi, "Name;Cost;Status`r`nSECRET_ROW_VALUE;10;Open`r`n", [System.Text.UTF8Encoding]::new($false))
    $semiResult = Invoke-InspectorJson @($semi, '-Delimiter', ';')
    Assert-True ($semiResult.structures[0].columns.Count -eq 3) 'delimiter override should parse semicolon CSV'
    Assert-True ($semiResult.structures[0].columns[2].name -eq 'Status') 'semicolon CSV third header should be Status'

    $normalXlsx = Join-Path $TempRoot 'normal.xlsx'
    New-TestXlsx -Path $normalXlsx -Rows @(
        [pscustomobject]@{ Row = 1; Values = @('Name', 'Cost', 'Status') },
        [pscustomobject]@{ Row = 2; Values = @('SECRET_ROW_VALUE', '10', 'Open') }
    )
    $normalXlsxResult = Invoke-InspectorJson @($normalXlsx)
    Assert-True ($normalXlsxResult.structures[0].header_row -eq 1) 'normal XLSX should auto-select row 1'
    Assert-True ($normalXlsxResult.structures[0].columns.Count -eq 3) 'normal XLSX should expose three headers'
    Assert-True (@($normalXlsxResult.warnings).Count -eq 0) 'normal XLSX should not produce a suspicious-header warning'
    Assert-True (($normalXlsxResult | ConvertTo-Json -Depth 12) -notmatch 'SECRET_ROW_VALUE') 'XLSX data-row values must not appear in output'

    $bannerXlsx = Join-Path $TempRoot 'banner.xlsx'
    New-TestXlsx -Path $bannerXlsx -Rows @(
        [pscustomobject]@{ Row = 1; Values = @('Project export') },
        [pscustomobject]@{ Row = 2; Values = @('Name', 'Cost', 'Status') },
        [pscustomobject]@{ Row = 3; Values = @('SECRET_ROW_VALUE', '10', 'Open') }
    )
    $bannerAuto = Invoke-InspectorJson @($bannerXlsx)
    Assert-True ($bannerAuto.structures[0].header_row -eq 1) 'banner workbook should retain deterministic first-populated-row auto-selection'
    Assert-True (@($bannerAuto.warnings).Count -ge 1) 'banner workbook should warn that auto-selected header looks suspicious'
    Assert-True (($bannerAuto.warnings -join ' ') -match 'Consider -HeaderRow') 'banner warning should direct user to HeaderRow override'

    $bannerOverride = Invoke-InspectorJson @($bannerXlsx, '-HeaderRow', '2')
    Assert-True ($bannerOverride.structures[0].header_row -eq 2) 'HeaderRow override should select row 2'
    Assert-True ($bannerOverride.structures[0].columns[0].name -eq 'Name') 'HeaderRow override should expose actual headers'

    $mergedXlsx = Join-Path $TempRoot 'merged-spacer.xlsx'
    New-TestXlsx -Path $mergedXlsx -Rows @(
        [pscustomobject]@{ Row = 1; Values = @('Merged report banner') },
        [pscustomobject]@{ Row = 3; Values = @('Name', 'Cost', 'Status') },
        [pscustomobject]@{ Row = 4; Values = @('SECRET_ROW_VALUE', '10', 'Open') }
    ) -MergeRef 'A1:C1'
    $mergedAuto = Invoke-InspectorJson @($mergedXlsx)
    Assert-True (@($mergedAuto.warnings).Count -ge 1) 'merged banner with spacer should warn'
    $mergedOverride = Invoke-InspectorJson @($mergedXlsx, '-HeaderRow', '3')
    Assert-True ($mergedOverride.structures[0].header_row -eq 3) 'HeaderRow should work across a blank spacer row'
    Assert-True ($mergedOverride.structures[0].columns.Count -eq 3) 'merged/spacer workbook should expose actual headers with override'

    $sqlite = Get-Command sqlite3 -ErrorAction SilentlyContinue
    if ($null -ne $sqlite) {
        $db = Join-Path $TempRoot 'fixture.sqlite'
        & $sqlite.Source $db 'CREATE TABLE sample (id INTEGER PRIMARY KEY, name TEXT NOT NULL);'
        if ($LASTEXITCODE -ne 0) { throw 'Failed to create SQLite fixture.' }
        $sqliteResult = Invoke-InspectorJson @($db)
        Assert-True ($sqliteResult.structures[0].name -eq 'sample') 'SQLite table should be discovered'
        Assert-True ($sqliteResult.structures[0].columns.Count -eq 2) 'SQLite schema should expose two columns'
        Write-Host 'SQLite fixture: PASS'
    }
    else {
        Write-Host 'SQLite fixture: SKIPPED (sqlite3.exe not available on PATH)'
    }

    Write-Host 'inspect-source Windows PowerShell fixture suite: PASS'
}
finally {
    if (Test-Path -LiteralPath $TempRoot) {
        Remove-Item -LiteralPath $TempRoot -Recurse -Force
    }
}
