# WinGet auto installer - shouldn't be necessary with a fully updated box.
# Adapted from https://github.com/microsoft/winget-pkgs/blob/master/Tools/SandboxTest.ps1

$apiLatestUrl = 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$WebClient = New-Object System.Net.WebClient

function Get-LatestUrl {
  # Get the latest download URL from the gh/microsoft/winget-cli repo.
  ((Invoke-WebRequest $apiLatestUrl -UseBasicParsing | ConvertFrom-Json).assets | Where-Object { $_.name -match '^Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle$' }).browser_download_url
}

$tempDirectory = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "WingetDeploy"
New-Item $tempDirectory -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

# Download URLs and definitions for required files
$vclibsPreference = @{
  fileName = 'Microsoft.VCLibs.x64.14.00.Desktop.appx'
  url = 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'
}

$wingetPreference = @{
  fileName = 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle'
  url = $(Get-LatestUrl)
}

$files = @($vclibsPreference, $wingetPreference)

Write-Host "Downloading required files..."
foreach ($file in $files) {
  $file.fullPath = Join-Path -Path $tempDirectory -ChildPath $file.fileName

  if (-Not $(Test-Path -Path $file.fullPath)) {
    Write-Host " --> Downloading: '$($file.url)' to '$($file.fullPath)'"

    try {
      $WebClient.DownloadFile($file.url, $file.fullPath)
    }
    catch {
      throw "Error downloading $($file.url) - aborting."
    }
  }
}

Write-Host "Done, deploying WinGet..."

Add-AppxPackage `
  -Path $(Join-Path -Path $tempDirectory -ChildPath $wingetPreference.fileName) `
  -DependencyPath $(Join-Path -Path $tempDirectory -ChildPath $vclibsPreference.fileName) `

Write-Host "WinGet deployed."