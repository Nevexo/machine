$cwd = Get-Location

# Shell Theme (prompt)
Write-Host "Installing Shell Theme..."
$script = Join-Path -Path $cwd -ChildPath "install-prompt-theme.ps1"
. $script
