Function Install-Font {
    <#
        .Synopsis
        Installs one or more fonts.
        .Parameter FontPath
        The path to the font to be installed or a directory containing fonts to install.
        .Parameter Recurse
        Searches for fonts to install recursively when a path to a directory is provided.
        .Notes
        There's no checking if a given font is already installed. This is problematic as an existing
        installation will trigger a GUI dialogue requesting confirmation to overwrite the installed
        font, breaking unattended and CLI-only scenarios.
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [String]$FontPath,

        [Switch]$Recurse
    )

    $ErrorActionPreference = 'Stop'
    $ShellAppFontNamespace = 0x14

    if (Test-Path -Path $FontPath) {
        $FontItem = Get-Item -Path $FontPath
        if ($FontItem -is [IO.DirectoryInfo]) {
            if ($Recurse) {
                $Fonts = Get-ChildItem -Path $FontItem -Include ('*.fon','*.otf','*.ttc','*.ttf') -Recurse
            } else {
                $Fonts = Get-ChildItem -Path "$FontItem\*" -Include ('*.fon','*.otf','*.ttc','*.ttf')
            }

            if (!$Fonts) {
                throw ('Unable to locate any fonts in provided directory: {0}' -f $FontItem.FullName)
            }
        } elseif ($FontItem -is [IO.FileInfo]) {
            if ($FontItem.Extension -notin ('.fon','.otf','.ttc','.ttf')) {
                throw ('Provided file does not appear to be a valid font: {0}' -f $FontItem.FullName)
            }

            $Fonts = $FontItem
        } else {
            throw ('Expected directory or file but received: {0}' -f $FontItem.GetType().Name)
        }
    } else {
        throw ('Provided font path does not appear to be valid: {0}' -f $FontPath)
    }

    $ShellApp = New-Object -ComObject Shell.Application
    $FontsFolder = $ShellApp.NameSpace($ShellAppFontNamespace)
    foreach ($Font in $Fonts) {
        Write-Verbose -Message ('Installing font: {0}' -f $Font.BaseName)
        $FontsFolder.CopyHere($Font.FullName, 20)
    }
}
# https://www.nerdfonts.com
Write-Host "Install Nerdfonts"
Write-Host "Step 1-Download CascadiaCode.zip to $env:temp"
Invoke-WebRequest -URI "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"  -OutFile "$env:temp\CascadiaCode.zip"

Write-Host "Step 2-Extract Archive $env:temp\CascadiaCode.zip"
Expand-Archive -Path "$env:temp\CascadiaCode.zip"  -Force -DestinationPath "$env:temp\CascadiaCode\" 


Write-Host "Step 3-Installing Fonts"
Get-ChildItem  "$env:temp\CascadiaCode\" | ForEach-Object {
    Write-Host "        - Installing Font " Split-Path $_.Name
    Install-Font( $_.FullName) 
}

Write-Host "Step 4-Clean (remove temp folder and font package)"
Remove-Item -Path  "$env:temp\CascadiaCode" -Recurse -Force
Remove-Item -Path "$env:temp\CascadiaCode.zip" -Force

Write-Host "Install Nerdfonts Done"
