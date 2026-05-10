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
    # skip if in skipDirs
    $parts = $rel -split '/'
    if ($parts | Where-Object { $skipDirs -contains $_ }) { continue }

    $content = Get-Content -Raw -Encoding UTF8 -Path $f.FullName
    if ($content -match '^\s*-\s*\[\s*\]\s*(Type:)?\s*.+' -or $content -match '^Tags:\s*$') {
        continue
    }
    $parent = Split-Path -Parent $f.FullName | Split-Path -Leaf
    if ([string]::IsNullOrEmpty($parent)) { $parent = 'root' }
    $tag = "- [ ] Type: $parent`r`n`r`n"

    if ($content -like '---*') {
        # find end of YAML frontmatter
        $yamlEnd = [regex]::Match($content, '^(---\s*\n.*?\n---\s*\n)', [System.Text.RegularExpressions.RegexOptions]::Singleline)
        if ($yamlEnd.Success) {
            $new = $yamlEnd.Groups[1].Value + $tag + $content.Substring($yamlEnd.Length)
        } else {
            $new = $tag + $content
        }
    } else {
        $new = $tag + $content
    }
    Set-Content -Encoding UTF8 -Path $f.FullName -Value $new
    Write-Output $rel
    $modified += $rel
}
Write-Output "--DONE-- modified $($modified.Count) files"
