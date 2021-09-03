Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
Install-Module posh-git -Scope CurrentUser -Force
Install-Module oh-my-posh -Scope CurrentUser -Force

@"
Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt ys
"@ | Out-File -FilePath $PROFILE 

Write-Host "OK"
