# https://www.nerdfonts.com

Write-Host "Install Nerdfonts"
Write-Host "Step 1-Download CascadiaCode.zip to $env:temp"
Invoke-WebRequest -URI "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"  -OutFile "$env:temp\CascadiaCode.zip"

Write-Host "Step 2-Extract Archive $env:temp\CascadiaCode.zip"
Expand-Archive -Path "$env:temp\CascadiaCode.zip"  -Force -DestinationPath "$env:temp\CascadiaCode\" 

Write-Host "Step 3-Installing Fonts"
$ShellApp = New-Object -ComObject Shell.Application
$WinFontFolder = $ShellApp.NameSpace( 0x14 )
Get-ChildItem  "$env:temp\CascadiaCode\" | ForEach-Object {
    Write-Host "        - Installing Font " Split-Path $_.Name
    
    $WinFontFolder.CopyHere($_.FullName, 0x20)
}

Write-Host "Step 4-Clean (remove temp folder and font package)"
Remove-Item -Path  "$env:temp\CascadiaCode" -Recurse -Force
Remove-Item -Path "$env:temp\CascadiaCode.zip" -Force

Write-Host "Install Nerdfonts Done"