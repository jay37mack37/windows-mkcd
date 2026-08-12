[CmdletBinding()]
param(
    [string] $ProfilePath = $PROFILE.CurrentUserCurrentHost
)

$ErrorActionPreference = 'Stop'
$startMarker = '# >>> windows-mkcd >>>'
$endMarker = '# <<< windows-mkcd <<<'
$functionBlock = @'
# >>> windows-mkcd >>>
function mkcd {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    New-Item -ItemType Directory -Path $Path -Force -ErrorAction Stop | Out-Null
    Set-Location -LiteralPath $Path
}
# <<< windows-mkcd <<<
'@

$profileDirectory = Split-Path -Parent $ProfilePath
if ($profileDirectory -and -not (Test-Path -LiteralPath $profileDirectory)) {
    New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null
}

$content = ''
if (Test-Path -LiteralPath $ProfilePath) {
    $content = [System.IO.File]::ReadAllText($ProfilePath)
}

$pattern = '(?ms)^' + [regex]::Escape($startMarker) + '.*?^' + [regex]::Escape($endMarker) + '\s*'
$content = [regex]::Replace($content, $pattern, '')
$content = $content.TrimEnd()
if ($content.Length -gt 0) {
    $content += [Environment]::NewLine + [Environment]::NewLine
}
$content += $functionBlock.Trim() + [Environment]::NewLine

$utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($ProfilePath, $content, $utf8WithoutBom)

. $ProfilePath
Write-Host "Installed mkcd in: $ProfilePath" -ForegroundColor Green
Write-Host 'The command is ready to use in this session and future PowerShell sessions.'
