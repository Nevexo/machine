# WinGet-powered package installer
# Ensures winget is present & then installs packages automatically from
# winget.json.

Param (
  [Parameter( HelpMessage = "WinGet manifest File" )]
  [String] $Manifest = "winget.json"
)

if (-Not (Get-Command 'winget' -ErrorAction SilentlyContinue)) {
  $installWingetPath = Join-Path -Path $(Get-Location) -ChildPath $(Join-Path -Path "winget" -ChildPath "install-winget.ps1")
  Write-Host -BackgroundColor Yellow -ForegroundColor Black "Attempting to install WinGet"

  if (-Not $(Test-Path -Path $installWingetPath)) {throw "install-winget.ps1 not found, cannot continue."}

  . $installWingetPath
}

$exportPath = Join-Path -Path $(Get-Location) -ChildPath $(Join-Path -Path "winget" -ChildPath $Manifest)
if (-Not $(Test-Path -Path $exportPath)) {throw "winget.json export file not found."}

Write-Host -BackgroundColor Yellow -ForegroundColor Black "Attempting to deploy packages with WinGet, UAC prompts may appear.`r`n"

winget import $exportPath