# Optional Claude Code PreToolUse guard for new Markdown/text meta-artifacts.
# Install this into the user's global Claude hooks only when the user chooses enforcement.

$inputJson = [Console]::In.ReadToEnd() | ConvertFrom-Json
$filePath = $inputJson.tool_input.file_path

if (-not $filePath) { exit 0 }

$name = [System.IO.Path]::GetFileName($filePath)
$extension = [System.IO.Path]::GetExtension($filePath).ToLowerInvariant()
$isNew = -not (Test-Path -LiteralPath $filePath)

$junkNamePattern = '(?i)' + (
    'context[-_ ]?package|' +
    'handoff|' +
    'completion[-_ ]?summary|' +
    'implementation[-_ ]?summary|' +
    'session[-_ ]?notes|' +
    'work[-_ ]?log|' +
    'artifact[-_ ]?manifest|' +
    'analysis[-_ ]?report|' +
    'status[-_ ]?report|' +
    'progress[-_ ]?report'
)

if ($isNew -and $name -match $junkNamePattern -and $extension -in @('.md', '.txt')) {
    @{
        hookSpecificOutput = @{
            hookEventName = 'PreToolUse'
            permissionDecision = 'deny'
            permissionDecisionReason = 'Meta-artifact creation is blocked. Put transient information in the conversation unless the user explicitly requested a file.'
        }
    } | ConvertTo-Json -Depth 5 -Compress
    exit 0
}

if ($isNew -and $extension -eq '.md') {
    @{
        hookSpecificOutput = @{
            hookEventName = 'PreToolUse'
            permissionDecision = 'ask'
            permissionDecisionReason = 'Claude is attempting to create a new Markdown file. Approve only if it is a requested deliverable, established project artifact, or implementation-required file.'
        }
    } | ConvertTo-Json -Depth 5 -Compress
    exit 0
}

exit 0
