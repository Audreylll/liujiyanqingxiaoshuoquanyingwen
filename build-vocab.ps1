$ErrorActionPreference = 'Stop'
$sourcePath = 'D:\微信\WeChat Files\wxid_2ubu75pe8v6p22\FileStorage\File\2026-10\大学英语六级词汇.md'
$targetPath = Join-Path $PSScriptRoot 'vocab-data.js'
$items = [System.Collections.Generic.List[object]]::new()

Get-Content -LiteralPath $sourcePath -Encoding UTF8 | ForEach-Object {
    if ($_ -match '^\|\s*\d+\s*\|\s*\*\*(.+?)\*\*\s*\|\s*(.+?)\s*\|\s*(.+?)\s*\|\s*$') {
        $items.Add([ordered]@{
            word = $Matches[1].Trim()
            phonetic = $Matches[2].Trim()
            meaning = $Matches[3].Trim()
        })
    }
}

$json = $items | ConvertTo-Json -Depth 3 -Compress
[System.IO.File]::WriteAllText($targetPath, "window.CET6_VOCAB=$json;", [System.Text.UTF8Encoding]::new($false))
Write-Host "Generated $($items.Count) vocabulary entries at $targetPath"
