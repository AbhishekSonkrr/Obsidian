 $ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
 $Root = Resolve-Path "$ScriptRoot\.." | Select-Object -ExpandProperty Path
 $Src = Join-Path $Root 'Untitled.md'
 $Out = Join-Path $Root 'DSA'

 if (-not (Test-Path $Src)) {
     Write-Host "Source file not found: $Src"
     exit 1
 }

$raw = Get-Content -Path $Src -Raw -Encoding UTF8 -ErrorAction Stop
$lines = $raw -split "\r?\n"
 $in_table = $false
 $current_topic = ''
 $rows = @()

 foreach ($ln in $lines) {
     if (-not $in_table) {
         if ($ln -match 'Topics\s*\|\s*complete\s*\|\s*question') {
             $in_table = $true
         }
         continue
     }
     if ($in_table -and -not $ln.TrimStart().StartsWith('|')) {
         break
     }
     if (-not $ln.TrimStart().StartsWith('|')) { continue }
     $trimmed = $ln.Trim().Trim('|')
     $parts = $trimmed -split '\|'
     if ($parts.Count -lt 3) { continue }
     $topic_cell = $parts[0].Trim()
     $question_cell = $parts[2].Trim()
     if ($topic_cell -ne '') { $current_topic = $topic_cell }
     $m = [regex]::Match($question_cell, '\[([^\]]+)\]\(([^)]+)\)')
     if ($m.Success) {
         $qtext = $m.Groups[1].Value.Trim()
         $qurl = $m.Groups[2].Value.Trim()
         $rows += ,@($current_topic, $qtext, $qurl)
     }
 }

 if ($rows.Count -eq 0) {
     Write-Host "No questions found in the table."
     exit 0
 }

 New-Item -ItemType Directory -Path $Out -Force | Out-Null
 $created = @()

 function Sanitize-Filename([string]$name) {
     $bad = '[\\/:*?"<>|]'
     $safe = [regex]::Replace($name, $bad, '-')
     $safe = [regex]::Replace($safe, '\s+', ' ').Trim()
     return "$safe.md"
 }

 for ($i=0; $i -lt $rows.Count; $i++) {
     $topic = $rows[$i][0]
     if ([string]::IsNullOrWhiteSpace($topic)) { $topic = 'Misc' }
     $qtext = $rows[$i][1]
     $qurl = $rows[$i][2]
     $folder = Join-Path $Out $topic
     New-Item -ItemType Directory -Path $folder -Force | Out-Null
     $fname = Sanitize-Filename $qtext
     $path = Join-Path $folder $fname
     $link_value = "[$qtext]($qurl)"
     $content = "---`nlink: `"$link_value`"`n---`n`n# $qtext`n`nSource: $qurl`n"
     Set-Content -Path $path -Value $content -Encoding UTF8
     $created += $path
 }

 Write-Host "Created $($created.Count) files under $Out"
 $created[0..([math]::Min(19, $created.Count-1))] | ForEach-Object { Write-Host $_ }
 if ($created.Count -gt 20) { Write-Host '...' }
