$modified = 0
Get-ChildItem -Recurse -Filter *.md | ForEach-Object {
    $path = $_.FullName
    try {
        $t = Get-Content -Raw -LiteralPath $path -ErrorAction Stop
    } catch {
        return
    }
    if ($null -eq $t) { $t = '' }
    $new = [Regex]::Replace($t, '\[([^\]]+)\]\((?:[^)]+)\)', '$1')
    if ($new -ne $t) {
        Set-Content -LiteralPath $path -Value $new -Encoding UTF8
        Write-Output $path
        $modified++
    }
}
Write-Output ("--DONE-- Modified {0} files" -f $modified)
