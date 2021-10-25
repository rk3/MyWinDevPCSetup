# https://www.nerdfonts.com

. $PSScriptRoot\InstallFont.ps1

Write-Host "Install Nerdfonts"
Write-Host "Step 1-Download CascadiaCode.zip to $env:temp"
Invoke-WebRequest -URI "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"  -OutFile "$env:temp\CascadiaCode.zip"

Write-Host "Step 2-Extract Archive $env:temp\CascadiaCode.zip"
Expand-Archive -Path "$env:temp\CascadiaCode.zip"  -Force -DestinationPath "$env:temp\CascadiaCode\" 

Write-Host "Step 3-Installing Fonts"

# Variation 1

Get-ChildItem  "$env:temp\CascadiaCode\" | ForEach-Object {

    Write-Host "akt dir $PSScriptRoot" 
    #    InstallFont.ps1 -FontFileName $_
    InstallFont -FontFileName "$_"
}



# Variation 2
<#
Get-ChildItem  "$env:temp\CascadiaCode\" | ForEach-Object {


    #    Start-Process  "powershell " $PSScriptRoot "\InstallFont.ps1"  -Argument " -FontFileName `"$_`"  "  -Wait -NoNewWindow 
    $arguments = "-file $PSScriptRoot\InstallFont.ps1 -FontFileName ""$_""  "
    #  $arguments = $arguments.Replace(" ", "' ")

    Write-Host "        - Installing Font ``$_`` path  $PSScriptRoot\InstallFont.ps1"
    Write-Host "$PSScriptRoot\InstallFont.ps1 -FontFileName ""$_""  "
    Write-Host "args: " $arguments

    Start-Process  "pwsh " -ArgumentList  $arguments  -Wait -NoNewWindow -UseNewEnvironment 

}
#>

# Variation 3
<#
$processInfo = New-Object System.Diagnostics.ProcessStartInfo
$processInfo.FileName = "powershell.exe"
$processInfo.RedirectStandardOutput = $true
$processInfo.UseShellExecute = $false
$processInfo.CreateNoWindow = $true
$processInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden

$process = New-Object System.Diagnostics.Process
$process.StartInfo = $processInfo 

Get-ChildItem  "$env:temp\CascadiaCode\" | ForEach-Object {
    $arguments = "-file $PSScriptRoot\InstallFont.ps1 -FontFileName ""$_""  "
    $processInfo.Arguments = $arguments

    $process.Start()  
    $standardOut = $process.StandardOutput.ReadToEnd()

    $process.WaitForExit();
    $standardOut

}
#>

Write-Host "Step 4-Clean (remove temp folder and font package)"
#Remove-Item -Path  "$env:temp\CascadiaCode" -Recurse -Force
#Remove-Item -Path "$env:temp\CascadiaCode.zip" -Force

Write-Host "Install Nerdfonts Done"