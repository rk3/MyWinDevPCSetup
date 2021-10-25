function InstallFont {
    Param(
        [Parameter(Mandatory = $True)]
        [string]$FontFileName
    )

    $ShellApp = New-Object -ComObject Shell.Application
    $WinFontFolder = $ShellApp.NameSpace( 0x14 )
    $FileName = Split-Path $FontFileName -leaf 
    $fontObj = $WinFontFolder.ParseName($FileName.Replace(".ttf", " Regular"))

    Write-Host "    - install font $FontFileName" 
    <#
if ((($ShellApp.NameSpace(0x14 ).Items() | where Name -like "$($font.BaseName.Split('-')[0].substring(0,4))*") | measure).Count -eq 0) {
    $firstInstall = $true
}
#>

    If ($fontObj) {
        echo "ist schon installiert"
    }
    else {
        $WinFontFolder.CopyHere($FontFileName, 16 + 1024)    
    }
}