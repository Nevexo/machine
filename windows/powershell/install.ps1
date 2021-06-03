$cwd = Get-Location

# Shell Theme (prompt)
$script = Join-Path -Path $cwd -ChildPath $(Join-Path -Path "powershell" -ChildPath "install-prompt-theme.ps1")
. $script
