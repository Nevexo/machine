# Nevexo/Machine

Dotfiles and provision scripts for new Windows & Linux boxes.

## Deploying a Windows Box

1. Download a copy of this repo (Code -> Download as ZIP)
2. Extract the master.zip file
3. Open `windows` directory
4. Right-click "run with PowerShell" the `provision.ps1` file.

The test.wsb sandbox file can be used for testing this deployment script, though, it has hard-coded absolute directories
which will likely need modifying before running the wsb file.

### Deployment Operations

Default deployments with `provision.ps1` will:

- Install WinGet if it is not already installed (use `-NoWinGetPackages` to skip this)
- Install all packages found in `windows/winget/winget.json` (use `-NoWinGetPackages` to skip this)
- Install oh-my-posh and set the `paradox` theme in the PowerShell `$PROFILE` (use `-NoPwshExtensions` to skip this)
- Modify the Windows Registry so that (use `-NoRegistryChanges` to skip this)
  - The taskbar uses small icons
  - The system & app theme is dark
  - UAC is set to 'always notify' (it's best to let WinGet run before this)
  - Verbose start messages are enabled
- Reboot the computer if `-Reboot` is passed.