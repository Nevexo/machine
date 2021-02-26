Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser

@"
Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt Zash
"@ | Out-File -FilePath $PROFILE 

Write-Host "OK"
