$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RepoRoot = Resolve-Path "$ScriptRoot\.." | Select-Object -ExpandProperty Path
$Target = Join-Path $RepoRoot 'DSA'

if (-not (Test-Path $Target)) {
    Write-Host "DSA folder not found at: $Target"
    exit 1
}

$modified = @()
Get-ChildItem -Path $Target -Recurse -File | ForEach-Object {
    $file = $_.FullName
    $lines = Get-Content -Path $file -Encoding UTF8
    if ($lines.Count -eq 0) { return }

    $changed = $false

    # remove first heading line (first line that starts with '#')
    $firstHeadingIndex = $null
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^\s*#\s+') { $firstHeadingIndex = $i; break }
    }
    if ($firstHeadingIndex -ne $null) {
        if ($firstHeadingIndex -eq 0) {
            $lines = $lines[1..($lines.Count - 1)]
        } elseif ($firstHeadingIndex -eq ($lines.Count - 1)) {
            $lines = $lines[0..($lines.Count - 2)]
        } else {
            $lines = $lines[0..($firstHeadingIndex - 1)] + $lines[($firstHeadingIndex + 1)..($lines.Count - 1)]
        }
        $changed = $true
    }

    # remove any 'Source:' lines (case-insensitive)
    $newLines = $lines | Where-Object { -not ($_ -match '^\s*Source\s*:') }
    if ($newLines.Count -ne $lines.Count) { $changed = $true }
    if ($changed) {
        Set-Content -Path $file -Value $newLines -Encoding UTF8
        $modified += $file
    }
}

Write-Host "Modified files: $($modified.Count)"
if ($modified.Count -gt 0) { $modified[0..([math]::Min(49, $modified.Count-1))] | ForEach-Object { Write-Host $_ } }
