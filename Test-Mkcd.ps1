$ErrorActionPreference = 'Stop'
$projectDirectory = $PSScriptRoot
$originalLocation = Get-Location
$testRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('windows-mkcd-' + [guid]::NewGuid())
$testProfile = Join-Path $testRoot 'profile.ps1'
$testDirectory = Join-Path $testRoot 'directory with spaces'

try {
    New-Item -ItemType Directory -Path $testRoot | Out-Null
    Set-Content -LiteralPath $testProfile -Value "`$global:ExistingProfileContent = 'preserved'" -Encoding UTF8

    & (Join-Path $projectDirectory 'Install-Mkcd.ps1') -ProfilePath $testProfile
    & (Join-Path $projectDirectory 'Install-Mkcd.ps1') -ProfilePath $testProfile

    $profileContent = [System.IO.File]::ReadAllText($testProfile)
    if (([regex]::Matches($profileContent, [regex]::Escape('# >>> windows-mkcd >>>'))).Count -ne 1) {
        throw 'The installer is not idempotent.'
    }

    . $testProfile
    mkcd $testDirectory
    if ((Get-Location).Path -ne $testDirectory -or -not (Test-Path -LiteralPath $testDirectory -PathType Container)) {
        throw 'mkcd did not create and enter the requested directory.'
    }
    if ($global:ExistingProfileContent -ne 'preserved') {
        throw 'Existing profile content was not preserved.'
    }

    Set-Location $testRoot
    & (Join-Path $projectDirectory 'Uninstall-Mkcd.ps1') -ProfilePath $testProfile
    $profileContent = [System.IO.File]::ReadAllText($testProfile)
    if ($profileContent.Contains('# >>> windows-mkcd >>>') -or -not $profileContent.Contains('ExistingProfileContent')) {
        throw 'The uninstaller did not cleanly preserve existing profile content.'
    }

    Write-Host 'All windows-mkcd tests passed.' -ForegroundColor Green
}
finally {
    Set-Location ([System.IO.Path]::GetTempPath())
    Remove-Item -LiteralPath $testRoot -Recurse -Force -ErrorAction SilentlyContinue
    Set-Location $originalLocation
    Remove-Variable ExistingProfileContent -Scope Global -ErrorAction SilentlyContinue
}
