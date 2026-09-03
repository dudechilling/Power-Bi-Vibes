[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$RepositoryUrl,

    [Parameter(Mandatory = $false)]
    [switch]$TestPush
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$results = New-Object System.Collections.Generic.List[object]

function Add-Check {
    param(
        [string]$Name,
        [ValidateSet('PASS','WARN','FAIL','OPTIONAL')]
        [string]$Status,
        [string]$Detail
    )
    $results.Add([pscustomobject]@{ Check = $Name; Status = $Status; Detail = $Detail }) | Out-Null
}

function Command-Exists { param([string]$Name) return ($null -ne (Get-Command $Name -ErrorAction SilentlyContinue)) }

function Find-PowerBI {
    $candidates = @(
        "$env:ProgramFiles\Microsoft Power BI Desktop\bin\PBIDesktop.exe",
        "$env:LOCALAPPDATA\Microsoft\WindowsApps\PBIDesktop.exe"
    )
    foreach ($candidate in $candidates) { if ($candidate -and (Test-Path -LiteralPath $candidate)) { return $candidate } }
    $app = Get-Command PBIDesktop.exe -ErrorAction SilentlyContinue
    if ($app) { return $app.Source }
    return $null
}

Add-Check -Name 'PowerShell' -Status 'PASS' -Detail "$($PSVersionTable.PSEdition) $($PSVersionTable.PSVersion)"

if (Command-Exists 'git') {
    Add-Check -Name 'Git' -Status 'PASS' -Detail ((& git --version 2>$null) -join ' ')
    $userName = (& git config --global --get user.name 2>$null) -join ''
    if ([string]::IsNullOrWhiteSpace($userName)) { Add-Check -Name 'Git user.name' -Status 'FAIL' -Detail 'Not configured. Set it with: git config --global user.name "Your Name"' } else { Add-Check -Name 'Git user.name' -Status 'PASS' -Detail $userName }
    $userEmail = (& git config --global --get user.email 2>$null) -join ''
    if ([string]::IsNullOrWhiteSpace($userEmail)) { Add-Check -Name 'Git user.email' -Status 'FAIL' -Detail 'Not configured. Set it with: git config --global user.email "YOUR-GITHUB-EMAIL"' } else { Add-Check -Name 'Git user.email' -Status 'PASS' -Detail $userEmail }
    try {
        $gcmVersion = (& git credential-manager --version 2>$null) -join ' '
        if ([string]::IsNullOrWhiteSpace($gcmVersion)) { throw 'No version returned.' }
        Add-Check -Name 'Git Credential Manager' -Status 'PASS' -Detail $gcmVersion
    } catch { Add-Check -Name 'Git Credential Manager' -Status 'WARN' -Detail 'Not detected. Update Git for Windows if HTTPS browser authentication does not work.' }
} else {
    Add-Check -Name 'Git' -Status 'FAIL' -Detail 'Git is not installed or is not on PATH.'
    Add-Check -Name 'Git user.name' -Status 'FAIL' -Detail 'Cannot check until Git is available.'
    Add-Check -Name 'Git user.email' -Status 'FAIL' -Detail 'Cannot check until Git is available.'
    Add-Check -Name 'Git Credential Manager' -Status 'WARN' -Detail 'Cannot check until Git is available.'
}

$powerBI = Find-PowerBI
if ($powerBI) { Add-Check -Name 'Power BI Desktop' -Status 'PASS' -Detail $powerBI } else { Add-Check -Name 'Power BI Desktop' -Status 'FAIL' -Detail 'PBIDesktop.exe was not detected in common locations or on PATH.' }

if (Test-Path -LiteralPath 'C:\PBI' -PathType Container) { Add-Check -Name 'C:\PBI workspace' -Status 'PASS' -Detail 'Folder exists. Use it if your account can write there.' } else { Add-Check -Name 'Local workspace' -Status 'WARN' -Detail "C:\PBI does not exist yet. Create it at clone time or use $(Join-Path $env:USERPROFILE 'PBI')." }

if (Command-Exists 'sqlite3') { Add-Check -Name 'SQLite CLI' -Status 'OPTIONAL' -Detail ("Installed: " + ((& sqlite3 --version 2>$null) -join ' ')) } else { Add-Check -Name 'SQLite CLI' -Status 'OPTIONAL' -Detail 'Not installed. Required only for local SQLite schema inspection.' }

if (-not [string]::IsNullOrWhiteSpace($RepositoryUrl)) {
    if (Command-Exists 'git') {
        try {
            $output = (& git ls-remote $RepositoryUrl HEAD 2>&1) -join "`n"
            if ($LASTEXITCODE -eq 0) { Add-Check -Name 'GitHub repository read access' -Status 'PASS' -Detail $RepositoryUrl } else { Add-Check -Name 'GitHub repository read access' -Status 'FAIL' -Detail $output }
        } catch { Add-Check -Name 'GitHub repository read access' -Status 'FAIL' -Detail $_.Exception.Message }
    } else { Add-Check -Name 'GitHub repository read access' -Status 'FAIL' -Detail 'Cannot test without Git.' }
} else { Add-Check -Name 'GitHub repository read access' -Status 'WARN' -Detail 'Not tested. Rerun with -RepositoryUrl https://github.com/OWNER/PROJECT.git' }

if ($TestPush) {
    if (-not (Test-Path -LiteralPath '.git' -PathType Container)) { Add-Check -Name 'GitHub push dry-run' -Status 'FAIL' -Detail 'Run -TestPush from inside the cloned repository.' }
    elseif (-not (Command-Exists 'git')) { Add-Check -Name 'GitHub push dry-run' -Status 'FAIL' -Detail 'Cannot test without Git.' }
    else {
        try {
            $output = (& git push --dry-run origin HEAD 2>&1) -join "`n"
            if ($LASTEXITCODE -eq 0) { Add-Check -Name 'GitHub push dry-run' -Status 'PASS' -Detail 'Remote accepted the non-mutating push check.' } else { Add-Check -Name 'GitHub push dry-run' -Status 'FAIL' -Detail $output }
        } catch { Add-Check -Name 'GitHub push dry-run' -Status 'FAIL' -Detail $_.Exception.Message }
    }
}

Write-Host ''
Write-Host 'Power BI Vibes local readiness' -ForegroundColor Cyan
Write-Host ''
foreach ($result in $results) {
    $color = switch ($result.Status) { 'PASS' { 'Green' } 'WARN' { 'Yellow' } 'FAIL' { 'Red' } 'OPTIONAL' { 'DarkGray' } }
    Write-Host ("[{0}] {1}" -f $result.Status, $result.Check) -ForegroundColor $color
    Write-Host ("       {0}" -f $result.Detail)
}

$failures = @($results | Where-Object { $_.Status -eq 'FAIL' })
Write-Host ''
if ($failures.Count -eq 0) { Write-Host 'READY: required local checks passed.' -ForegroundColor Green; exit 0 }
Write-Host ("NOT READY: {0} required check(s) failed." -f $failures.Count) -ForegroundColor Red
exit 1
