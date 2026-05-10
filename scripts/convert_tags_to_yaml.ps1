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

    # Match checkbox tag immediately after YAML frontmatter
    $fmPattern = '^(---\r?\n.*?\r?\n---\r?\n)\s*- \[ \] Type:\s*(.+?)\r?\n(\r?\n)?'
    $fmMatch = [regex]::Match($content, $fmPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    if ($fmMatch.Success) {
            $front = $fmMatch.Groups[1].Value
            $cat = $fmMatch.Groups[2].Value.Trim()
            $rest = $content.Substring($fmMatch.Length)

            $inner = $front -replace '^(---\r?\n)','' -replace '(\r?\n---\r?\n)$',''

            if ($inner -match '(?m)^\s*tags\s*:\s*$') {
                if ($inner -notmatch [regex]::Escape("- $cat")) {
                    $inner = [regex]::Replace($inner, '(?m)^\s*tags\s*:\s*\r?\n', "tags:`r`n  - $cat`r`n")
                }
            } elseif ($inner -match '(?m)^\s*tags\s*:\s*\[(.*?)\]\s*$') {
                $arr = $Matches[1].Split(',') | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
                if ($arr -notcontains $cat) { $arr += $cat }
                $block = "tags:`r`n" + ($arr | ForEach-Object { "  - $_" } ) -join "`r`n"
                $inner = [regex]::Replace($inner, '(?m)^\s*tags\s*:\s*\[.*?\]\s*\r?\n', '')
                $inner = $inner + "`r`n" + $block
            } else {
                $inner = $inner + "`r`n" + "tags:`r`n  - $cat`r`n"
            }

            $newFront = "---`r`n" + $inner.TrimEnd() + "`r`n---`r`n"
            $new = $newFront + $rest
        Set-Content -Encoding UTF8 -Path $f.FullName -Value $new
        Write-Output $rel
        $modified += $rel
        continue
    }

    # Match checkbox tag at the very top (no frontmatter)
    $topPattern = '^\s*- \[ \] Type:\s*(.+?)\r?\n(\r?\n)?'
    $topMatch = [regex]::Match($content, $topPattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)
    if ($topMatch.Success) {
        $cat = $topMatch.Groups[1].Value.Trim()
        $rest = $content.Substring($topMatch.Length)
        $newFront = "---\r\n" + "tags:\r\n  - $cat\r\n" + "---\r\n\r\n"
        $new = $newFront + $rest
        Set-Content -Encoding UTF8 -Path $f.FullName -Value $new
        Write-Output $rel
        $modified += $rel
        continue
    }

    # Also handle cases where tag was manually added as 'Tags:' block (rare)
    $tagsBlockPattern = '^(Tags:\s*\r?\n(- \[ \] .+?\r?\n)+)'
    $tagsMatch = [regex]::Match($content, $tagsBlockPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    if ($tagsMatch.Success) {
        $block = $tagsMatch.Groups[1].Value
        # extract first tag text
        $m2 = [regex]::Match($block, '- \[ \] Type:\s*(.+?)\r?\n')
        if ($m2.Success) {
            $cat = $m2.Groups[1].Value.Trim()
            $rest = $content.Substring($tagsMatch.Length)
            $newFront = "---\r\n" + "tags:\r\n  - $cat\r\n" + "---\r\n\r\n"
            $new = $newFront + $rest
            Set-Content -Encoding UTF8 -Path $f.FullName -Value $new
            Write-Output $rel
            $modified += $rel
            continue
        }
    }
}
Write-Output "--DONE-- modified $($modified.Count) files"
