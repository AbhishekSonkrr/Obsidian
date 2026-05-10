param(
    [ValidateSet('dsa','all')]
    [string]$Scope = 'dsa'
)

function Normalize-Tag($t) {
    if (-not $t) { return '' }
    $t = $t.Trim().ToLower()
    $t = $t -replace '\s+','_'    # replace spaces with underscore
    $t = $t -replace '[^a-z0-9_\-]',''  # remove other chars, keep underscore and hyphen
    return $t
}

$root = Get-Location
$skipDirs = '.git','node_modules','.venv','venv','__pycache__','.obsidian'
$modified = @()

$files = Get-ChildItem -Path $root -Recurse -Filter *.md -File -ErrorAction SilentlyContinue
foreach ($f in $files) {
    $rel = $f.FullName.Substring($root.Path.Length + 1) -replace '\\','/'
    if ($Scope -eq 'dsa' -and -not ($rel -like 'DSA/*' -or $rel -eq 'DSA')) { continue }
    $parts = $rel -split '/'
    if ($parts | Where-Object { $skipDirs -contains $_ }) { continue }

    $text = Get-Content -Raw -Encoding UTF8 -Path $f.FullName
    if (-not $text) { continue }

    # remove leftover checkbox lines at top
    $text = [regex]::Replace($text, '^(?:\s*- \[ \] Type:.*\r?\n)+', '', [System.Text.RegularExpressions.RegexOptions]::Multiline)

    $fmStart = $null; $fmEnd = $null
    if ($text -match '^(---)\r?\n') {
        $fmStart = 0
        $m = [regex]::Match($text, '^(---\r?\n.*?\r?\n---\r?\n)', [System.Text.RegularExpressions.RegexOptions]::Singleline)
        if ($m.Success) { $fmEnd = $m.Length }
    }

    $front = ''
    $body = $text
    if ($fmEnd -ne $null -and $fmEnd -gt 0) {
        $front = $text.Substring(0, $fmEnd)
        $body = $text.Substring($fmEnd)
    }

    # parse existing front for link and tags
    $linkVal = ''
    $tagsArr = @()

    if ($front) {
        $lines = $front -split "\r?\n"
        foreach ($ln in $lines) {
            if ($ln -match '^link\s*:\s*(.*)$') {
                $raw = $Matches[1].Trim()
                # strip optional quotes
                $raw = $raw -replace '^["'']','' -replace '["'']$',''
                $linkVal = $raw
            }
            if ($ln -match '^tags\s*:\s*$') {
                # collect following '- ' lines
                # we'll parse later from front as block
            }
        }
        # try to parse block style tags
        $mTags = [regex]::Matches($front, '^-\s*(.+)$', [System.Text.RegularExpressions.RegexOptions]::Multiline)
        foreach ($mt in $mTags) { $tagsArr += $mt.Groups[1].Value.Trim() }
        # try inline tags like tags: [a, b]
        if ($tagsArr.Count -eq 0) {
            $mInline = [regex]::Match($front, 'tags\s*:\s*\[(.*?)\]', [System.Text.RegularExpressions.RegexOptions]::Singleline)
            if ($mInline.Success) {
                $vals = $mInline.Groups[1].Value.Split(',') | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
                $tagsArr += $vals
            }
        }
    }

    # force tags from parent folder (topic) and normalize to lowercase_with_underscores
    $parent = Split-Path -Parent $f.FullName | Split-Path -Leaf
    if ([string]::IsNullOrWhiteSpace($parent)) { $parent = 'root' }
    $normTags = @(Normalize-Tag $parent)

    # preserve link URL if found in front or body
    if (-not $linkVal) {
        $mLinkInBody = [regex]::Match($body, '\[.*?\]\((https?://[^)]+)\)')
        if ($mLinkInBody.Success) { $linkVal = $mLinkInBody.Groups[1].Value }
    } else {
        # if linkVal is in markdown '[text](url)', extract url
        $mLinkMd = [regex]::Match($linkVal, '\[.*?\]\((https?://[^)]+)\)')
        if ($mLinkMd.Success) { $linkVal = $mLinkMd.Groups[1].Value }
    }

    # compute alias from filename (lowercase_with_underscores)
    $basename = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
    $alias = Normalize-Tag $basename

    # build new, minimal frontmatter: link, tags, alias, checkbox
    $sb = New-Object System.Text.StringBuilder
    $sb.AppendLine('---') | Out-Null
    $sb.AppendLine(("link: '{0}'" -f ($linkVal -replace "'","''"))) | Out-Null
    $sb.AppendLine('tags:') | Out-Null
    foreach ($t in $normTags) { $sb.AppendLine(("  - {0}" -f $t)) | Out-Null }
    $sb.AppendLine(("alias: '{0}'" -f ($alias -replace "'","''"))) | Out-Null
    $sb.AppendLine('checkbox: false') | Out-Null
    $sb.AppendLine('---') | Out-Null
    $sb.AppendLine('') | Out-Null

    $newText = $sb.ToString() + $body.TrimStart("`r","`n")

    if ($newText -ne $text) {
        Set-Content -Encoding UTF8 -Path $f.FullName -Value $newText
        Write-Output $rel
        $modified += $rel
    }
}

Write-Output "--DONE-- normalized $($modified.Count) files"
