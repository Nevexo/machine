Param(
  [Parameter( HelpMessage = "Don't install WinGet Packages" )]
  [switch] $NoWinGetPackages,
  [Parameter( Helpmessage = "Don't install PowerShell extensions" )]
  [switch] $NoPwshExtensions,
  [Parameter( HelpMessage = "Don't apply registry changes" )]
  [switch] $NoRegistryChanges,
  [Parameter( HelpMessage = "Reboot the machine when all operations are complete (default: no)" )]
  [switch] $Reboot = $false
)

Write-Host -BackgroundColor Yellow -ForegroundColor Black "Nevexo/Machine Windows Deployment Script`r`nParts of this process may require UAC elevation."

if (-Not $NoWinGetPackages) {
  Write-Host -BackgroundColor Green -ForegroundColor Black "`r`n`r`nDeploying packages with Winget"
  & './winget/install-packages.ps1'
  # Reload the Path after package deployment
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
}

if (-Not $NoPwshExtensions) {
  Write-Host -BackgroundColor Green -ForegroundColor Black "`r`n`r`nInstalling PowerShell extensions"

  # Use pwsh if it's available, it should be after the winget installation
  if (Get-Command 'pwsh' -ErrorAction SilentlyContinue) {
    pwsh $(Join-Path -Path $(Get-Location) -ChildPath $(Join-Path -Path "powershell" -ChildPath "install.ps1"))
  } else {
    Write-Host -BackgroundColor Yellow -ForegroundColor Black "`r`n`r`nWarn: themes will be installed into Windows PowerShell as PowerShell Core is unavailable."
    & './powershell/install.ps1'
  }
}

if (-Not $NoRegistryChanges) {
  Write-Host -BackgroundColor Green -ForegroundColor Black "`r`n`r`nApplying Registry Changes"
  Invoke-Expression "& './registry/deploy-registry.ps1' -TaskbarSmallIcons -SystemDarkTheme -HighUACLevel -VerboseStartMessages"
}

if ($Reboot) {
  Restart-Computer
}

Write-Host -BackgroundColor Yellow -ForegroundColor Black "All operations complete, strike enter to exit."
Read-Host