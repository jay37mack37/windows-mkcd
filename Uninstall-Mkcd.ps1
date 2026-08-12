[CmdletBinding()]
param(
    [string] $ProfilePath = $PROFILE.CurrentUserCurrentHost
)

$ErrorActionPreference = 'Stop'
if (-not (Test-Path -LiteralPath $ProfilePath)) {
    Write-Host "No PowerShell profile exists at: $ProfilePath"
    return
}

$startMarker = '# >>> windows-mkcd >>>'
$endMarker = '# <<< windows-mkcd <<<'
$content = [System.IO.File]::ReadAllText($ProfilePath)
$pattern = '(?ms)^' + [regex]::Escape($startMarker) + '.*?^' + [regex]::Escape($endMarker) + '\s*'
$updatedContent = [regex]::Replace($content, $pattern, '').TrimEnd()
if ($updatedContent.Length -gt 0) {
    $updatedContent += [Environment]::NewLine
}

$utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($ProfilePath, $updatedContent, $utf8WithoutBom)

Remove-Item Function:\mkcd -ErrorAction SilentlyContinue
Write-Host "Removed mkcd from: $ProfilePath" -ForegroundColor Green
