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

    $content = Get-Content -Raw -Encoding UTF8 -Path $f.FullName
    $orig = $content

    # remove checkbox tag immediately after frontmatter
    $pattern1 = '^(---\r?\n.*?\r?\n---\r?\n)(?:\s*)(?:- \[ \] Type:.*\r?\n)+'
    $content = [regex]::Replace($content, $pattern1, '$1', [System.Text.RegularExpressions.RegexOptions]::Singleline)

    # remove checkbox tag at very top (no frontmatter)
    $pattern2 = '^((?:\s*- \[ \] Type:.*\r?\n)+)'
    $content = [regex]::Replace($content, $pattern2, '', [System.Text.RegularExpressions.RegexOptions]::Multiline)

    if ($content -ne $orig) {
        Set-Content -Encoding UTF8 -Path $f.FullName -Value $content
        Write-Output $rel
        $modified += $rel
    }
}
Write-Output "--DONE-- cleaned $($modified.Count) files"
