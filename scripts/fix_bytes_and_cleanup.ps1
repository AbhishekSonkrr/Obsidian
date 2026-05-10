param(
    [ValidateSet('dsa','all')]
    [string]$Scope = 'dsa'
)

function Replace-Bytes($bytes, $pattern, $replacement) {
    $changed = $false
    $out = New-Object System.Collections.Generic.List[Byte]
    $i = 0
    while ($i -lt $bytes.Length) {
        if ($i -le $bytes.Length - $pattern.Length) {
            $match = $true
            for ($j=0; $j -lt $pattern.Length; $j++) { if ($bytes[$i+$j] -ne $pattern[$j]) { $match = $false; break } }
            if ($match) {
                $out.AddRange($replacement)
                $i += $pattern.Length
                $changed = $true
                continue
            }
        }
        $out.Add($bytes[$i])
        $i++
    }
    return ,@($changed, $out.ToArray())
}

$root = Get-Location
$modified = @()
$skipDirs = '.git','node_modules','.venv','venv','__pycache__','.obsidian'

$files = Get-ChildItem -Path $root -Recurse -Filter *.md -File -ErrorAction SilentlyContinue
foreach ($f in $files) {
    $rel = $f.FullName.Substring($root.Path.Length + 1) -replace '\\','/'
    if ($Scope -eq 'dsa' -and -not ($rel -like 'DSA/*' -or $rel -eq 'DSA')) { continue }
    $parts = $rel -split '/'
    if ($parts | Where-Object { $skipDirs -contains $_ }) { continue }

    $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
    $origBytes = $bytes

    $pattern = [byte[]](0x5C,0x72,0x5C,0x6E) # \r\n
    $replacement = [byte[]](0x0D,0x0A) # CR LF
    $res = Replace-Bytes $bytes $pattern $replacement
    $changed = $res[0]
    $bytes = $res[1]

    # also replace literal \n (0x5C 0x6E) with LF
    $pattern2 = [byte[]](0x5C,0x6E)
    $replacement2 = [byte[]](0x0A)
    $res2 = Replace-Bytes $bytes $pattern2 $replacement2
    if ($res2[0]) { $changed = $true; $bytes = $res2[1] }

    if ($changed) {
        [System.IO.File]::WriteAllBytes($f.FullName, $bytes)
        # now run textual cleanup to remove leading checkbox lines
        $content = Get-Content -Raw -Encoding UTF8 -Path $f.FullName
        $orig = $content
        $content = [regex]::Replace($content, '^(---\r?\n.*?\r?\n---\r?\n)\s*(?:- \[ \] Type:.*\r?\n)+', '$1', [System.Text.RegularExpressions.RegexOptions]::Singleline)
        $content = [regex]::Replace($content, '^(?:\s*- \[ \] Type:.*\r?\n)+', '', [System.Text.RegularExpressions.RegexOptions]::Multiline)
        if ($content -ne $orig) { Set-Content -Encoding UTF8 -Path $f.FullName -Value $content }

        Write-Output $rel
        $modified += $rel
    }
}
Write-Output "--DONE-- fixed bytes and cleaned $($modified.Count) files"
