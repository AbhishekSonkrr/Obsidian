param(
    [ValidateSet('dsa','all')]
    [string]$Scope = 'dsa'
)

$root = Get-Location
$modified = @()
$skipDirs = '.git','node_modules','.venv','venv','__pycache__','.obsidian'

$files = Get-ChildItem -Path $root -Recurse -Filter *.md -File -ErrorAction SilentlyContinue
foreach ($f in $files) {
    $rel = $f.FullName.Substring($root.Path.Length + 1) -replace '\\','/'
    if ($Scope -eq 'dsa' -and -not ($rel -like 'DSA/*' -or $rel -eq 'DSA')) {
        continue
    }
    $parts = $rel -split '/'
    if ($parts | Where-Object { $skipDirs -contains $_ }) { continue }

    $lines = Get-Content -Encoding UTF8 -Path $f.FullName -ErrorAction SilentlyContinue
    if (-not $lines) { continue }
    $orig = $lines -join "`n"

    $limit = [Math]::Min(50, $lines.Count)
    $changed = $false
    for ($i=0; $i -lt $limit; $i++) {
        if ($lines[$i] -match '^\s*- \[ \] Type:.*$') {
            $lines = $lines[0..($i-1)] + $lines[($i+1)..($lines.Count-1)]
            $changed = $true
            break
        }
        if ($lines[$i] -match '^Tags:\s*$') {
            # remove following lines that look like '- [ ]' or '- '
            $j = $i+1
            while ($j -lt $lines.Count -and $lines[$j] -match '^\s*-') {
                $lines = $lines[0..($j-1)] + $lines[($j+1)..($lines.Count-1)]
                $changed = $true
                # do not increment j because array shrank
            }
            break
        }
    }

    if ($changed) {
        $new = $lines -join "`r`n"
        Set-Content -Encoding UTF8 -Path $f.FullName -Value $new
        Write-Output $rel
        $modified += $rel
    }
}
Write-Output "--DONE-- removed top type lines from $($modified.Count) files"
