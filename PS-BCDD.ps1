# Business Card Dungeon Delve designed by Melv Lee - PowerShell edition
# https://melvinli.itch.io/business-card-dungeon-delve

#
# install / import PSWriteColor module (if not installed)
#
Function Install_PSWriteColor {
    if (-not(Get-Module -Name "PSWriteColor" -ListAvailable)) {
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
    } else {
        Write-Host "PSWriteColor module is already installed." -ForegroundColor Green
        $PSWriteColor_Installed = Get-Module -Name "PSWriteColor" -ListAvailable
        $PSWriteColor_Installed_Version = Get-Module -Name "PSWriteColor" -ListAvailable
        Import-Module -Name "PSWriteColor"
        Write-Host "PSWriteColor module version $($PSWriteColor_Installed_Version.Version) imported." -ForegroundColor Green
    }
}

#
# import JSON game data
#
Function Import_JSON {
    $Script:Import_JSON = (Get-Content ".\PS-BCDD.json" -Raw | ConvertFrom-Json)
}

#
# save data back to JSON file
#
Function Save_JSON {
    if (-not(Test-Path -Path "$ENV:userprofile\My Drive\GitHub\PS-BCDD\error.log")) {
        New-Item -Path "$ENV:userprofile\My Drive\GitHub\PS-BCDD\error.log" -ItemType File -Force | Out-Null
    }
    $maxRetries = 5
    $retryDelaySeconds = 1
    for ($retry = 1; $retry -le $maxRetries; $retry++) {
        try {
            ($Script:Import_JSON | ConvertTo-Json -depth 32) | Set-Content ".\PS-BCDD.json" -ErrorAction Stop
            # Add-Content -Path "$ENV:userprofile\My Drive\GitHub\PS-BCDD\error.log" -value "Success attempt #$($retry)" # leave in
            Break
        } catch {
            Add-Content -Path "$ENV:userprofile\My Drive\GitHub\PS-BCDD\error.log" -value "Error saving attempt #$($retry) $($_.Exception.Message)" # leave in
            if ($retry -lt $maxRetries) {
                Add-Content -Path "$ENV:userprofile\My Drive\GitHub\PS-BCDD\error.log" -value "Retrying in $($retryDelaySeconds)s" # leave in
                Start-Sleep -Seconds $retryDelaySeconds # leave in
            } else {
                Add-Content -Path "$ENV:userprofile\My Drive\GitHub\PS-BCDD\error.log" -value "Failed $($maxRetries) attempts" # leave in
            }
        }
    }
}


#
# PLACE FUNCTIONS ABOVE HERE
#

Clear-Host

# write any errors out to error.log file
Trap {
    $Time = Get-Date -Format "HH:mm:ss"
    Add-Content -Path .\error.log -value "-Trap Error $Time ----------------------------------" # leave in
    Add-Content -Path .\error.log -value "$PSItem" # leave in
    Add-Content -Path .\error.log -value "------------------------------------------------------" # leave in
}

#
# Pre-requisite checks (install / import / update PSWriteColor module)
#

if (-not(Test-Path -Path .\PS-BCDD.json)) {
    # adjust window size
    do {
        Clear-Host
        Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" -ForegroundColor DarkYellow
        for ($index = 0; $index -lt 36; $index++) {
            Write-Host "+                                                                                                                                                              +" -ForegroundColor DarkYellow
        }
        Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" -ForegroundColor DarkYellow
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 20,10;$Host.UI.Write( "Using the CTRL + mouse scroll wheel forward and back,")
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 20,11;$Host.UI.Write( "adjust the font size to make sure the yellow box fits within the screen.")
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 2,36;$Host.UI.Write("")
        Write-Host -NoNewline "Adjust font size with CTRL + mouse scroll wheel, then confirm with 'go' and Enter"
        $Adjust_Font_Size = Read-Host " "
        $Adjust_Font_Size = $Adjust_Font_Size.Trim()
    } until ($Adjust_Font_Size -ieq "go")
    Clear-Host
    Write-Host "Pre-requisite checks" -ForegroundColor Red
    Write-Host "--------------------" -ForegroundColor Red
    Write-Output "`r`nChecking if PSWriteColor module is installed."
    $PSWriteColor_Installed = Get-Module -Name "PSWriteColor" -ListAvailable
    # PSWriteColor is installed so import it
    if ($PSWriteColor_Installed) {
        Write-Host "PSWriteColor module is installed." -ForegroundColor Green
        $PSWriteColor_Installed
        $PSWriteColor_Installed_Version = $PSWriteColor_Installed.Version
        Write-Output "`r`nChecing if there is a new version of PSWriteColor."
        # check for new module and update on prompt
        $PSWriteColor_Online_Version = Find-Module -Name "PSWriteColor"
        if ($PSWriteColor_Installed_Version -lt $PSWriteColor_Online_Version.Version) {
            Write-Host "Version available: $($PSWriteColor_Online_Version.Version)" -ForegroundColor Green
            Write-Host "Version installed: $($PSWriteColor_Installed_Version)"
            do {
                Write-Host -NoNewline "`r`nDo you want to update to version $($PSWriteColor_Online_Version.Version)? [Y/N]"
                $Update_PSWriteColor_Choice = Read-Host " "
                $Update_PSWriteColor_Choice = $Update_PSWriteColor_Choice.Trim()
            } until ($Update_PSWriteColor_Choice -ieq "y" -or $Update_PSWriteColor_Choice -ieq "n")
            if ($Update_PSWriteColor_Choice -ieq "y") {
                Write-Output "Updating PSWriteColor module."
                Write-Output "Install path will be $ENV:USERPROFILE\Documents\WindowsPowerShell\Modules\"
                Write-Host "Uninstalling PSWriteColor module Version $PSWriteColor_Installed_Version"
                Uninstall-Module -Name "PSWriteColor" # no confirmation prompt
                Write-Host "Installing PSWriteColor module version $($PSWriteColor_Online_Version.Version)"
                Install-Module -Name "PSWriteColor" -Scope CurrentUser -Confirm:$false -Force
                $Install_PSWrite_Color_ExitCode = $?
                if ($Install_PSWrite_Color_ExitCode -eq $true) {
                    $PSWriteColor_Installed = Get-Module -Name "PSWriteColor" -ListAvailable
                    if ($PSWriteColor_Installed.Version -eq $PSWriteColor_Online_Version.Version) {
                        $PSWriteColor_Installed = Get-Module -Name PSWriteColor -ListAvailable
                        Write-Host "PSWriteColor module version $($PSWriteColor_Installed.Version) installed." -ForegroundColor Green
                        $PSWriteColor_Installed | Format-Table
                    } else {
                        Write-Host "`r`nNo PSWriteColor module installed. Please re-run PS-BCDD.ps1" -ForegroundColor Red
                        Exit
                    }
                } else {
                    Write-Host "PSWriteColor module version $($PSWriteColor_Online_Version.Version) FAILED to install. Please re-run PS-BCDD.ps1" -ForegroundColor Red
                    Exit
                }
            }
            if ($Update_PSWriteColor_Choice -ieq "n") {
                Write-Output "Not updating PSWriteColor module."
            }
        } else {
            Write-Output "`r`nPSWriteColor module is up-to-date."
        }
        Write-Output "`r`nImporting PSWriteColor module."
        Import-Module -Name "PSWriteColor"
        $PSWriteColor_Installed_Version = Get-Module -Name "PSWriteColor" -ListAvailable
        if ($PSWriteColor_Installed_Version) {
            Write-Host "PSWriteColor module version $($PSWriteColor_Installed_Version.Version) imported." -ForegroundColor Green
        } else {
            Write-Host "PSWriteColor module not imported." -ForegroundColor Red
            Break
        }
        Start-Sleep -Seconds 3 # leave in
    } else { # otherwise ask for module to be installed
        Install_PSWriteColor
    }
    #
    # game info
    #
    Write-Host -NoNewLine "`r`nPress any key to continue."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Clear-Host
    Write-Color "`r`nInfo" -Color Green
    Write-Color "----" -Color Green
    Write-Color "`r`nWelcome to ", "PS-BCDD", ", my 2nd RPG text adventure written in PowerShell." -Color DarkGray,Magenta,DarkGray
    Write-Color "`r`nBusiness Card Dungeon Delve is a solo RPG that was designed by ","Melv Lee","." -Color DarkGray,Magenta,DarkGray
    Write-Color "You can download the original PDF game from itch.io: https://melvinli.itch.io/business-card-dungeon-delve" -Color DarkGray,Magenta,DarkGray
    Write-Color "`r`nAs previously mentioned, the PSWriteColor PowerShell module written by Przemyslaw Klys is required," -Color DarkGray
    Write-Color "which, if you are seeing this message then it has installed and imported successfully." -Color DarkGray
    Write-Color "`r`nAbsolutely ", "NO ", "info, personal or otherwise, is collected or sent anywhere or to anybody. " -Color DarkGray,Red,DarkGray
    Write-Color "`r`nAll the ", "PS-BCDD ", "games files are stored your ", "$PSScriptRoot"," folder which is where you have run the game from." -Color DarkGray,Magenta,DarkGray,Cyan,DarkGray
    Write-Color "`rThey include:" -Color DarkGray,Magenta,DarkGray,Cyan,DarkGray
    Write-Color "The main PowerShell script            : ", "PS-BCDD.ps1" -Color DarkGray,Cyan
    Write-Color "ASCII art for death messages          : ", "ASCII.txt" -Color DarkGray,Cyan
    Write-Color "A JSON file that stores all game info : ", "PS-BCDD.json ", "(Locations, Mobs, NPCs and Character Stats etc.)" -Color DarkGray,Cyan,DarkGray
    Write-Color "`r`nPlayer input options appear in ","Green ", "e.g. ", "[Y/N/E/I] ", "would be ", "yes/no/exit/inventory", "." -Color DarkGray,Green,DarkGray,Green,DarkGray,Green,DarkGray
    Write-Color "Enter the single character then hit `'Enter`' to confirm the choice." -Color DarkGray
    Write-Color "`r`nWARNING - Quitting the game unexpectedly may cause lose of data." -Color Cyan
    Write-Color "`r`nYou are now ready to play", " PS-BCDD", "." -Color DarkGray,Magenta,DarkGray
    do {
        do {
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
            Write-Color -NoNewLine "No save file found. Are you ready to start playing ", "PS-BCDD", "?"," [Y/N/E]" -Color DarkYellow,Magenta,DarkYellow,Green
            $Ready_To_Play_PSRPG = Read-Host " "
            $Ready_To_Play_PSRPG = $Ready_To_Play_PSRPG.Trim()
        } until ($Ready_To_Play_PSRPG -ieq "y" -or $Ready_To_Play_PSRPG -ieq "n" -or $Ready_To_Play_PSRPG -ieq "e")
        if ($Ready_To_Play_PSRPG -ieq "n" -or $Ready_To_Play_PSRPG -ieq "e") {
            do {
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("");" "*105
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
                Write-Color -NoNewLine "Do you want to quit ", "PS-BCDD", "?"," [Y/N]" -Color DarkYellow,Magenta,DarkYellow,Green
                $Quit_Game = Read-Host " "
                $Quit_Game = $Quit_Game.Trim()
            } until ($Quit_Game -ieq "y" -or $Quit_Game -ieq "n")
            if ($Quit_Game -ieq "y") {
                Write-Color -NoNewLine "Exiting ","PS-BCDD","." -Color DarkYellow,Magenta,DarkYellow
                Exit
            }
        }
    } until ($Ready_To_Play_PSRPG -ieq "y")
}






#
# first thing after character creation / loading saved data
#
# main loop



"importing JSON..."
Import_JSON

"saving JSON..."
Save_JSON





