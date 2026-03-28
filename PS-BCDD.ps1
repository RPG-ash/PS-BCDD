# Business Card Dungeon Delve designed by Melv Lee - PowerShell edition
# https://melvinli.itch.io/business-card-dungeon-delve

#
# install / import PSWriteColor module (if not installed)
#
Function Install_PSWriteColor {
    $PSWriteColor_Online_Version = Find-Module -Name "PSWriteColor"
    Write-Host "PSWriteColor module is not installed." -ForegroundColor Red
    Write-Output "`r`nThis game requires a PowerShell module called PSWriteColor to be installed."
    Write-Output "It allows the game to use coloured console output text for a better experience."
    Write-Output "The module will install as the Current User Scope and does NOT require Admin credentials."
    Write-Output "`r`nMore info about the module can be found from the below links if you"
    Write-Output "wish to research it before deciding to install it on your system."
    Write-Output "`r`nAuthor              - Przemyslaw Klys"
    Write-Output "PowerShell Gallery  - https://www.powershellgallery.com/packages/PSWriteColor/$($PSWriteColor_Online_Version.Version)"
    Write-Output "GitHub project site - https://github.com/EvotecIT/PSWriteColor"
    Write-Output "More info           - https://evotec.xyz/hub/scripts/pswritecolor/"
    $Install_Module_Check = Read-Host "`r`nDo you want to allow the PSWriteColor module to be installed? [Y/N]"
    if (-not($Install_Module_Check -ieq "y")) {
        Write-Host "`r`nThe PSWriteColor module was NOT installed." -ForegroundColor Red
        Write-Host "Run the script again if you change your mind."
        Write-Host ""
        Exit
    }
    Write-Host "Installing PSWriteColor module version $($PSWriteColor_Online_Version.Version)"
    Write-Output "Install path will be $ENV:USERPROFILE\Documents\WindowsPowerShell\Modules\"
    Install-Module -Name "PSWriteColor" -Scope CurrentUser -Confirm:$false -Force
    $PSWriteColor_Installed = Get-Module -Name "PSWriteColor" -ListAvailable
    if ($PSWriteColor_Installed) {
        Write-Host "PSWriteColor module is installed." -ForegroundColor Green
        $PSWriteColor_Installed
        Write-Output "`r`nImporting PSWriteColor module."
        Import-Module -Name "PSWriteColor"
        $PSWriteColor_Installed_Version = Get-Module -Name "PSWriteColor" -ListAvailable
        if ($PSWriteColor_Installed_Version) {
            Write-Host "PSWriteColor module version $($PSWriteColor_Installed_Version.Version) imported." -ForegroundColor Green
        } else {
            Write-Host "PSWriteColor module not imported." -ForegroundColor Red
            Break
        }
    } else {
        Write-Host "`r`nPSWriteColor module did not install correctly." -ForegroundColor Red
        Break
    }
}