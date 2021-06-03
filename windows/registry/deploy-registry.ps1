# Windows Registry Config change deployments

Param(
  [Parameter(HelpMessage = "Set the Taskbar to use Small Icons")]
  [Switch] $TaskbarSmallIcons = $false,
  [Parameter(HelpMessage = "Switch the system to Dark Theme")]
  [Switch] $SystemDarkTheme = $false,
  [Parameter(HelpMessage = "Change UAC level to highest")]
  [Switch] $HighUACLevel = $false,
  [Parameter(Helpmessage = "Enable verbose startup messages")]
  [Switch] $VerboseStartMessages = $false
)

function Set-Taskbar-SmallIcons {
  Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "taskbarSmallIcons" -Value 1
}

function Set-DarkTheme {
  Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0
  Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
}

if ($TaskbarSmallIcons) {
  Write-Host -BackgroundColor Yellow -ForegroundColor Black "Enabling small icons for taskbar - Explorer will restart shortly!"
  Set-Taskbar-SmallIcons
  taskkill /f -im explorer.exe
  explorer.exe
}

if ($SystemDarkTheme) {
  Write-Host -BackgroundColor Yellow -ForegroundColor Black "Setting system theme to dark"
  Set-DarkTheme
}

if ($HighUACLevel) {
  Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 2
  Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorUser" -Value 2
}

if ($VerboseStartMessages) {
  Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "verbosestatus" -Value 1
}