# ToDo
# ----
#
# - Obtain Quest
#
#
#

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
        } catch {
            Add-Content -Path "$ENV:userprofile\My Drive\GitHub\PS-BCDD\error.log" -value "Error saving attempt #$($retry) $($_.Exception.Message)" # leave in
            if ($retry -lt $maxRetries) {
                Add-Content -Path "$ENV:userprofile\My Drive\GitHub\PS-BCDD\error.log" -value "Retrying in $($retryDelaySeconds)s" # leave in
                Start-Sleep -Seconds $retryDelaySeconds # leave in
            } else {
            }
        }
    }
}



#
# game introduction
#
Function Game_Introduction {
    Clear-Host
    Write-Color "Welcome to the Business Card Dungeon Delve PowerShell Edition!" -Color Green
    Write-Color "This is a text-based adventure game inspired by the original card game designed by Melv Lee." -Color DarkGray
    Write-Color "The game is played through the console and uses a JSON file to store your character's progress." -Color DarkGray
    Write-Color "The game will automatically save after certain actions, but you can also save manually at any time by typing ","save" -Color DarkGray,Green
    Write-Color "and pressing Enter." -Color DarkGray
    Write-Color "`r`nThe game uses the PSWriteColor module to provide colored text output for a better gaming experience." -Color DarkGray
    Write-Color "If you don't have the module installed, the game will prompt you to install it before you can play." -Color DarkGray
    Write-Color "`r`nThe game is still in development, so expect some bugs and incomplete features." -Color DarkGray
    Write-Color "Feel free to report any issues or suggest improvements on the GitHub repository." -Color DarkGray
    Write-Color "`r`nHave fun playing and delving into the dungeon!" -Color Green
}



#
# roll random D6
#
Function Roll_D6_Dice {
    $Random_Dice_Roll_Random_Seconds = Get-Random -Minimum 4 -Maximum 10
    for ($i = 0; $i -lt $Random_Dice_Roll_Random_Seconds; $i++) {
        do {
            $Script:Random_Dice_Roll = Get-Random -Minimum 1 -Maximum 7
        } until ($Random_Dice_Roll -ne $Last_Dice_Roll)
        # Clear-Host
        for ($Position = 32; $Position -lt 36; $Position++) {
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,$Position;$Host.UI.Write("");" "*140
        }
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,33;$Host.UI.Write("")
        # "`r`nRolling D6 Dice...`r`n"
        $Script:Last_Dice_Roll = $Random_Dice_Roll
        $host.UI.RawUI.ForegroundColor = "White"
        switch ($Random_Dice_Roll) {
            1 {
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,27;$Host.UI.Write("+-------+")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,28;$Host.UI.Write("|       |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,29;$Host.UI.Write("|   o   |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,30;$Host.UI.Write("|       |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,31;$Host.UI.Write("+-------+")
                # Write-Color "      +-------+"
                # Write-Color "      |       |"
                # Write-Color "      |   o   |"
                # Write-Color "      |       |"
                # Write-Color "      +-------+"
                break
            }
            2 {
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,27;$Host.UI.Write("+-------+")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,28;$Host.UI.Write("| o     |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,29;$Host.UI.Write("|       |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,30;$Host.UI.Write("|     o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,31;$Host.UI.Write("+-------+")
                # Write-Color "      +-------+"
                # Write-Color "      | o     |"
                # Write-Color "      |       |"
                # Write-Color "      |     o |"
                # Write-Color "      +-------+"
                break
            }
            3 {
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,27;$Host.UI.Write("+-------+")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,28;$Host.UI.Write("| o     |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,29;$Host.UI.Write("|   o   |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,30;$Host.UI.Write("|     o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,31;$Host.UI.Write("+-------+")
                # Write-Color "      +-------+"
                # Write-Color "      | o     |"
                # Write-Color "      |   o   |"
                # Write-Color "      |     o |"
                # Write-Color "      +-------+"
                break
            }
            4 {
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,27;$Host.UI.Write("+-------+")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,28;$Host.UI.Write("| o   o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,29;$Host.UI.Write("|       |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,30;$Host.UI.Write("| o   o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,31;$Host.UI.Write("+-------+")
                # Write-Color "      +-------+"
                # Write-Color "      | o   o |"
                # Write-Color "      |       |"
                # Write-Color "      | o   o |"
                # Write-Color "      +-------+"
                break
            }
            5 {
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,27;$Host.UI.Write("+-------+")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,28;$Host.UI.Write("| o   o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,29;$Host.UI.Write("|   o   |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,30;$Host.UI.Write("| o   o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,31;$Host.UI.Write("+-------+")
                # Write-Color "      +-------+"
                # Write-Color "      | o   o |"
                # Write-Color "      |   o   |"
                # Write-Color "      | o   o |"
                # Write-Color "      +-------+"
                break
            }
            6 {
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,27;$Host.UI.Write("+-------+")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,28;$Host.UI.Write("| o   o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,29;$Host.UI.Write("| o   o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,30;$Host.UI.Write("| o   o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 25,31;$Host.UI.Write("+-------+")
                # Write-Color "      +-------+"
                # Write-Color "      | o   o |"
                # Write-Color "      | o   o |"
                # Write-Color "      | o   o |"
                # Write-Color "      +-------+"
                break
            }
            Default {}
        }
        $Random_Milliseconds = Get-Random -Minimum 200 -Maximum 1000
        Start-Sleep -Milliseconds $Random_Milliseconds
    }
    $host.UI.RawUI.ForegroundColor = "DarkGray" # set the foreground color back to original colour
}



#
# player window and stats
#
Function Draw_Player_Window_and_Stats {
    $host.UI.RawUI.ForegroundColor = "DarkGray"
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,0;$Host.UI.Write( "+---------------------------+---------------------+-------------------------+-------------------+")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,1;$Host.UI.Write( "| Adventurer                | Enemy               | Quest :                 | Potions      of 3 |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,2;$Host.UI.Write( "+---------------------------+---------------------+-------------------------+ Healing       :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,3;$Host.UI.Write( "| Name      :               | Name   : Skeleton   | Wilderness : Campsite   | Invisibility  :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,4;$Host.UI.Write( "| Health    :    of         | HP     :            | Journeys                | Accelerate    :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,5;$Host.UI.Write( "| STR       :               | Attack :            |     of                  | Strength      :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,6;$Host.UI.Write( "| DEX       :               | Loot   :            |                         | Invincibility :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,7;$Host.UI.Write( "| INT       :               |                     |                         | Rock Skin     :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,8;$Host.UI.Write( "| Location  :               +---------------------+-------------------------+-------------------+")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,9;$Host.UI.Write( "| Gold      :               | Test : Poison Darts | Dungeon    : Passage    | Spells       of 3 |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,10;$Host.UI.Write("| Total XP  :               | Stat :              | Rooms                   | Healing Hands :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,11;$Host.UI.Write("| Equipment :               | Pass :              |     of                  | Fire Ball     :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,12;$Host.UI.Write("| Weapon    :               | Fail :              |                         | Light         :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,13;$Host.UI.Write("| Rations   :               |                     |                         | Lightning     :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,14;$Host.UI.Write("| Torches   :               |                     |                         | Morphing      :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,15;$Host.UI.Write("|           : v             |                     |                         | Teleport      :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,16;$Host.UI.Write("+---------------------------+---------------------+-------------------------+-------------------+")
    $host.UI.RawUI.ForegroundColor = "Magenta"
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 2,15;$Host.UI.Write("PS-BCDD")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 16,15;$Host.UI.Write($PSBCDD_Version)
    $host.UI.RawUI.ForegroundColor = "White"
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 14,3;$Host.UI.Write($Character_Name)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 14,5;$Host.UI.Write($Character_STR)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 14,6;$Host.UI.Write($Character_DEX)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 14,7;$Host.UI.Write($Character_INT)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 14,8;$Host.UI.Write($Current_Location)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 14,9;$Host.UI.Write($Gold)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 14,10;$Host.UI.Write($Total_XP)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 14,11;$Host.UI.Write($Equipment)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 14,12;$Host.UI.Write($Weapon)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 14,13;$Host.UI.Write($Rations)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 14,14;$Host.UI.Write($Torches)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 40,3;$Host.UI.Write($Mob_Name)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 40,4;$Host.UI.Write($Mob_HP)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 40,5;$Host.UI.Write($Mob_Attack)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 40,6;$Host.UI.Write($Mob_Loot)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 37,9;$Host.UI.Write($Test_Name)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 37,10;$Host.UI.Write($Test_Stat)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 37,11;$Host.UI.Write($Test_Pass)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 37,12;$Host.UI.Write($Test_Fail)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 60,1;$Host.UI.Write($Quest)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 59,5;$Host.UI.Write($Wilderness_Journeys_Total)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 54,5;$Host.UI.Write($Wilderness_Journeys_Current)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 66,3;$Host.UI.Write($Wilderness_Journey_Name_1)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 66,4;$Host.UI.Write($Wilderness_Journey_Name_2)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 66,5;$Host.UI.Write($Wilderness_Journey_Name_3)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 66,6;$Host.UI.Write($Wilderness_Journey_Name_4)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 66,7;$Host.UI.Write($Wilderness_Journey_Name_5)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 75,3;$Host.UI.Write($Wilderness_Journey_Complete_1)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 75,4;$Host.UI.Write($Wilderness_Journey_Complete_2)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 75,5;$Host.UI.Write($Wilderness_Journey_Complete_3)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 75,6;$Host.UI.Write($Wilderness_Journey_Complete_4)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 75,7;$Host.UI.Write($Wilderness_Journey_Complete_5)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 59,11;$Host.UI.Write($Dungeon_Room_Total)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 54,11;$Host.UI.Write($Dungeon_Room_Current)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 66,9;$Host.UI.Write($Dungeon_Room_Name_1)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 66,10;$Host.UI.Write($Dungeon_Room_Name_2)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 66,11;$Host.UI.Write($Dungeon_Room_Name_3)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 66,12;$Host.UI.Write($Dungeon_Room_Name_4)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 66,13;$Host.UI.Write($Dungeon_Room_Name_5)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 75,10;$Host.UI.Write($Dungeon_Room_Complete_1)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 75,11;$Host.UI.Write($Dungeon_Room_Complete_2)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 75,12;$Host.UI.Write($Dungeon_Room_Complete_3)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 75,13;$Host.UI.Write($Dungeon_Room_Complete_4)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 75,14;$Host.UI.Write($Dungeon_Room_Complete_5)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 89,1;$Host.UI.Write($Potions_Total)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 94,2;$Host.UI.Write($Potions_Quantity_1)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 94,3;$Host.UI.Write($Potions_Quantity_2)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 94,4;$Host.UI.Write($Potions_Quantity_3)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 94,5;$Host.UI.Write($Potions_Quantity_4)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 94,6;$Host.UI.Write($Potions_Quantity_5)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 94,7;$Host.UI.Write($Potions_Quantity_6)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 89,9;$Host.UI.Write($Spells_Total)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 94,10;$Host.UI.Write($Spells_Quantity_1)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 94,11;$Host.UI.Write($Spells_Quantity_2)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 94,12;$Host.UI.Write($Spells_Quantity_3)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 94,13;$Host.UI.Write($Spells_Quantity_4)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 94,14;$Host.UI.Write($Spells_Quantity_5)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 94,15;$Host.UI.Write($Spells_Quantity_6)
    $host.UI.RawUI.ForegroundColor = "Green"
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 14,4;$Host.UI.Write("$Character_HealthCurrent")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 21,4;$Host.UI.Write("$Character_HealthMax")
    $host.UI.RawUI.ForegroundColor = "DarkGray" # set the foreground color back to original colour
    # $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,11;$Host.UI.Write("")
}


#
# draw info banner
#
Function Draw_Info_Banner {
    $Info_Banner_Padding = " "*(105-3-($Info_Banner | Measure-Object -Character).Characters)
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,17;$Host.UI.Write("")
    Write-Color "| ","$Info_Banner","$Info_Banner_Padding|" -Color DarkGray,White,DarkGray
    Write-Color "+-------------------------------------------------------------------------------------------------------+" -Color DarkGray
}



#
# clear the bottom of the screen for new text output
#
Function Clear_Bottom_Half_of_Screen {
    for ($Position = 19; $Position -lt 37; $Position++) {
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,$Position;$Host.UI.Write("");" "*140
    }
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,19;$Host.UI.Write("")
}



#
# create character
#
Function Create_Character {
    #
    # character name
    #
    Copy-Item -Path .\PS-BCDD_new_game.json -Destination .\PS-BCDD.json
    Import_JSON
    do {
        # $Character_Name = $false
        $Character_Name_Valid = $false
        $Character_Name_Confirm = $false
        # character name loop
        do {
            # $Character_Name = $false
            $Character_Name_Valid = $false
            $Character_Name_Confirm = $false
            $Character_Name_Random_Confirm = $false
            do {
                do {
                    Clear-Host
                    Draw_Player_Window_and_Stats
                    $Script:Info_Banner = "Adventurer Name"
                    Draw_Info_Banner
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,19
                    if ($($Character_Name | Measure-Object -Character).Characters -gt 10) {
                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25
                        Write-Color "  *Your name is too long, your name must be 10 characters or less*" -Color Red
                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,19
                    }
                    if ($Random_Character_Name_Count -eq 0) {
                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25
                        Write-Color "  *All random names have been suggested*" -Color Red
                    }
                    Write-Color "  Choose your character name" -Color DarkGray
                    Write-Color "  If you cannot think of a name, try searching for one online or enter ","R ","for some random name suggestions." -Color DarkGray,Green,DarkGray
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
                    Write-Color -NoNewLine "  Enter a name (max 10 characters) or ","R","andom ","[R]" -Color DarkYellow,Green,DarkYellow,Green
                    $Character_Name_Valid = $false # set to false to prevent a character name of " " nothing after entering a name with more than 10 characters
                    $Character_Name = Read-Host " "
                    $Character_Name = $Character_Name.Trim()
                    if (-not($null -eq $Character_Name -or $Character_Name -eq " " -or $Character_Name -eq "")) {
                        $Character_Name_Valid = $true
                    }
                } until ($($Character_Name | Measure-Object -Character).Characters -le 10)
                if ($Character_Name -ieq 'r') {
                    $Random_Character_Name_Count = 0
                    [System.Collections.ArrayList]$Random_Character_Names = ('Igert','Cyne','Aened','Alchred','Altes','Reyny','Wine','Eonild','Conga','Burgiua','Wene','Belia','Ryellia','Ellet','Wyna','Kamin','Bori','Ukhlar','Bifur','Nainan','Akad','Sanzagh','Zuri','Dwoinarv','Azan','Ukras','Ilmin','Banain','Zaghim','Gwali','Zuri','Kada','Urul','Duri','Geda','Throdore','Galdore','Finrandan','Celodhil','Aldon','Endingond','Ebrir','Edhrorod','Findore','Elerwen','Enen','Anelyel','Arwerdas','Findalye','Minerde','Mithrielye','Ilarel','Neladrie','Nerwende')
                    do {
                        if ($Random_Character_Names.Count -eq 0) { # if all random names have been suggested, reset array and break out of loop to ask question again
                            $Random_Character_Name_Count = 0
                            [System.Collections.ArrayList]$Random_Character_Names = ('Igert','Cyne','Aened','Alchred','Altes','Reyny','Wine','Eonild','Conga','Burgiua','Wene','Belia','Ryellia','Ellet','Wyna','Kamin','Bori','Ukhlar','Bifur','Nainan','Akad','Sanzagh','Zuri','Dwoinarv','Azan','Ukras','Ilmin','Banain','Zaghim','Gwali','Zuri','Kada','Urul','Duri','Geda','Throdore','Galdore','Finrandan','Celodhil','Aldon','Endingond','Ebrir','Edhrorod','Findore','Elerwen','Enen','Anelyel','Arwerdas','Findalye','Minerde','Mithrielye','Ilarel','Neladrie','Nerwende')
                            $Character_Name_Random_Confirm = $true
                            Break
                        }
                        $Random_Character_Name = Get-Random -Input $Random_Character_Names
                        do {
                            for ($Position = 19; $Position -lt 30; $Position++) {
                                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,$Position;$Host.UI.Write("");" "*140
                            }
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,19;$Host.UI.Write("")
                            if ($Gandalf_Joke -ieq "  Gandalf the Gray") {
                                Write-Color "  Oh wait. That name has more than 10 characters. You'll have to pick another name, sorry about that =|" -Color DarkGray
                                Write-Color "  Where were we..." -Color DarkGray
                            }
                            if ($Character_Name_Random -ieq "n") {
                                $Random_Character_Name_Count += 1
                                switch ($Random_Character_Name_Count) {
                                    1  { Write-Color "  What about ", "$Random_Character_Name ", "for your Character's name?" -Color DarkGray,Blue,DarkGray}
                                    2  { Write-Color "  How about ", "$Random_Character_Name ", "for your Character's name instead?" -Color DarkGray,Blue,DarkGray}
                                    3  { Write-Color "  Okay, how about ", "$Random_Character_Name ", "then?" -Color DarkGray,Blue,DarkGray }
                                    4  { Write-Color "  Didn't like that one huh? What about ", "$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    5  { Write-Color "  Didn't like that one either? ", "$Random_Character_Name ", "then?" -Color DarkGray,Blue,DarkGray }
                                    6  { Write-Color "  $Random_Character_Name", "?" -Color Blue,DarkGray }
                                    7  { Write-Color "  $Random_Character_Name", "?" -Color Blue,DarkGray }
                                    8  { Write-Color "  $Random_Character_Name", "?" -Color Blue,DarkGray }
                                    9  { Write-Color "  You're getting picky now. Let's go with ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    10 { Write-Color "  You're getting really picky now. Why don't you choose ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    11 { Write-Color "  Or ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    12 { Write-Color "  I'm running out of names now. ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    13 { Write-Color "  If you don't pick this one, i'm choose for you. ","$Random_Character_Name", "." -Color DarkGray,Blue,DarkGray }
                                    14 { Write-Color "  WoW, you really didn't like THAT one??? ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    15 { Write-Color "  Still deciding? ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    16 { Write-Color "  Can't make up your mind can you? ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    17 { Write-Color "  This is getting boring. ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    18 { Write-Color "  *Yawn* ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    19 {
                                        Write-Color "  Gandalf the Gray", "?" -Color Blue,DarkGray
                                        $Random_Character_Name = "Gandalf the Gray"
                                    }
                                    20 {
                                        if ($Gandalf_Joke -ieq "Gandalf the Gray") {
                                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,19;$Host.UI.Write("");" "*140
                                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,20;$Host.UI.Write("");" "*140
                                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,21;$Host.UI.Write("");" "*140
                                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,19;$Host.UI.Write("")
                                            Write-Color "  Sorry about the ","Gandalf ","joke, that wasn't very funny." -Color DarkGray,Blue,DarkGray
                                            Write-Color "  If you like, i'll let you have ","Gandalf",". ","How about that?" -Color DarkGray,Blue,DarkGray
                                            $Random_Character_Name = "Gandalf"
                                            $Gandalf_Joke = "Gandalf"
                                        } else {
                                            Write-Color "  Here is another name... ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray
                                        }
                                    }
                                    Default {
                                        Write-Color "  $Random_Character_Name", "?" -Color Blue,DarkGray
                                    }
                                }
                                $Random_Character_Names.Remove($Random_Character_Name)
                            } else {
                                Write-Color "  How about ", "$Random_Character_Name ", "for your Character's name? " -Color DarkGray,Blue,DarkGray
                            }
                            $Character_Name = $Random_Character_Name
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
                            Write-Color -NoNewLine "  Choose this name? ","[Y/N]" -Color DarkYellow,Green
                            $Character_Name_Random = Read-Host " "
                        } until ($Character_Name_Random -ieq "y" -or $Character_Name_Random -ieq "n")
                        if ($Character_Name_Random -ieq "y") {
                            # $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
                            Write-Color -NoNewLine "  You have chosen ", "$Character_Name ", "for your Character name, is this correct? ", "[Y/N]" -Color DarkYellow,Blue,DarkYellow,Green
                            $Character_Name_Random = Read-Host " "
                            if ($Character_Name_Random -ieq "y") {
                                $Character_Name_Random_Confirm = $true
                                $Character_Name_Confirm = $true
                                if ($Character_Name -ieq "Gandalf the Gray") {
                                    $Character_Name_Random_Confirm = $false
                                    $Gandalf_Joke = "Gandalf the Gray"
                                }
                            }
                        }
                        if ($Character_Name_Random -ieq "n") {
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,19;$Host.UI.Write("")
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,19;$Host.UI.Write("");" "*140
                        }
                    } until ($Character_Name_Random_Confirm -eq $true)
                }
            } until ($Character_Name_Valid -eq $true)
            if ($Character_Name_Random_Confirm -ieq $false) {
                do {
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
                    Write-Color -NoNewLine "  You have chosen ", "$Character_Name ", "for your Character name, is this correct? ", "[Y/N/E]" -Color DarkYellow,Blue,DarkYellow,Green
                    $Character_Name_Confirm = Read-Host " "
                } until ($Character_Name_Confirm -ieq "y" -or $Character_Name_Confirm -ieq "n" -or $Character_Name_Confirm -ieq "e")
                if ($Character_Name_Confirm -ieq "y") {
                    $Character_Name_Confirm = $true
                } else {
                    if ($Character_Name_Confirm -ieq "e") {Exit}
                }
            }
        } until ($Character_Name_Confirm -eq $true)
        $Import_JSON.Character.Name = $Character_Name
        Update_Variables
        Draw_Player_Window_and_Stats
        #
        # character stats
        #
        Function Press_Continue {
            Update_Variables
            Draw_Player_Window_and_Stats
            Save_JSON
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
            Write-Color -NoNewLine "  Press Enter to continue..." -Color DarkYellow
            $Host.UI.ReadLine()
        }
        do {
            $Info_Banner = "Health, Rations and Torches"
            Draw_Info_Banner
            for ($Position = 19; $Position -lt 35; $Position++) {
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,$Position;$Host.UI.Write("");" "*140
            }
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,19;$Host.UI.Write("")
            Write-Color "  Now that you have chosen a name, let's work on some stats." -Color DarkGray
            Press_Continue
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,21;$Host.UI.Write("")
            Write-Color "  Your max ","Health"," can only ever be ","12",", so you will start with that." -Color DarkGray,Green,DarkGray,Green,DarkGray
            Write-Color "  You can't go over this amount, no matter how many ","potions"," you quaff." -Color DarkGray,Blue,DarkGray
            $Import_JSON.Character.Stats.HealthCurrent = 12
            $Import_JSON.Character.Stats.HealthMax     = 12
            Press_Continue
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,24;$Host.UI.Write("")
            Write-Color "  You will also start with ","6"," Rations",", and ","6"," Torches." -Color DarkGray,White,Blue,DarkGray,White,Blue
            Write-Color "  Rations"," are used when travelling between locations, and ","Torches"," are used when exploring dungeons." -Color Blue,DarkGray,Blue,DarkGray
            $Import_JSON.Character.Rations = 6
            $Import_JSON.Character.Torches = 6
            Press_Continue
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,27;$Host.UI.Write("")
            Write-Color "  You use ","1"," Ration"," per journey." -Color DarkGray,White,Blue,DarkGray
            Write-Color "  If you run out of ","Rations",", you will lose ","1"," Health"," each time you travel between locations." -Color DarkGray,Blue,DarkGray,White,Green,DarkGray
            Write-Color "  When your character's ","Health ","reaches ","0",", it's game over and you will have to re-roll another character." -Color DarkGray,Green,DarkGray,Red,DarkGray
            Press_Continue
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,31;$Host.UI.Write("")
            Write-Color "  You use ","1"," Torch"," per dungeon room you visit." -Color DarkGray,White,Blue,DarkGray
            Write-Color "  If you use up all your ","Torches",", you'll be lost in the dungeon forever and unable to escape!" -Color DarkGray,Blue,DarkGray
            Write-Color "  If this happens, you will have to re-roll another character and start your Adventure again." -Color DarkGray
            Press_Continue
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,35;$Host.UI.Write("")
            Write-Color "  Rations"," and ","Torches"," can sometimes be found in enemy loot, but can also bought from the Settlement shop." -Color Blue,DarkGray,Blue,DarkGray
            Press_Continue
            # Clear-Host
            Clear_Bottom_Half_of_Screen
            $Info_Banner = "Stats - STR, DEX and INT"
            Draw_Info_Banner
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,19;$Host.UI.Write("")
            Write-Color "  Your other stats, ","STR",", ","DEX"," and ","INT",", will start at ","0"," for now," -Color DarkGray,White,DarkGray,White,DarkGray,White,DarkGray,White,DarkGray
            Write-Color "  but you'll get the chance to increase these when you gain some XP from killing enemies." -Color DarkGray
            $Import_JSON.Character.Stats.STR = 0
            $Import_JSON.Character.Stats.DEX = 0
            $Import_JSON.Character.Stats.INT = 0
            Press_Continue
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,22;$Host.UI.Write("")
            Write-Color "  STR"," (Strength), ","DEX"," (Dexterity) and ","INT"," (Intelligence), are used to determine ","Pass"," and ","Fail" -Color White,DarkGray,White,DarkGray,White,DarkGray,Green,DarkGray,Red
            Write-Color "  results against certain tests from events suchs as Encounters, Hazards and NPC interactions." -Color DarkGray
            Press_Continue
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("")
            Write-Color "  STR"," and ","DEX"," are also used in combat to determine attack and defence results against enemies." -Color White,DarkGray,White,DarkGray
            Press_Continue
            # Clear-Host
            #
            # potion and spells
            #
            Clear_Bottom_Half_of_Screen
            $Info_Banner = "Potions and Spells"
            Draw_Info_Banner
            Write-Color "`r`n  Potions"," and ","Spells"," are items that can be used at any time that can heal you, cause damage to enemies," -Color Blue,DarkGray,Blue,DarkGray
            Write-Color "  raise your stats temporally and even teleport you back to the Settlement." -Color DarkGray
            Write-Color "  You can also find them in loot from enemies, or buy them from the shop in the Settlement." -Color DarkGray
            Write-Color "`r`n  You start with a free ","Potion"," and ","Spell","." -Color DarkGray,Blue,DarkGray,Blue,DarkGray
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
            Write-Color -NoNewLine "  Press Enter to continue..." -Color DarkYellow
            $Host.UI.ReadLine()
            #
            # roll for potion
            #
            Clear_Bottom_Half_of_Screen
            $Info_Banner = "Free Potion"
            Draw_Info_Banner
            Write-Color ""
            foreach ($item in $Import_JSON.Potions.PSObject.Properties) {
                "  $($item.Name) - $($item.Value.Name) ($($item.Value.Info))"
            }
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
            Write-Color -NoNewLine "  Roll a D6 to determine which Potion you receive. Press Enter to continue..." -Color DarkYellow
            $Host.UI.ReadLine()
            # Clear-Host
            Roll_D6_Dice
            # $Random_Dice_Roll = 1
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,34;$Host.UI.Write("")
            Write-Color "  You rolled a ","$Random_Dice_Roll", ". You gain a ","$($Import_JSON.Potions.$Random_Dice_Roll.Name)"," Potion","." -Color DarkGray,White,DarkGray,White,Blue,DarkGray
            $Import_JSON.Character.PotionsTotal += 1
            $Import_JSON.Potions.$Random_Dice_Roll.Quantity += 1
            Update_Variables
            Draw_Player_Window_and_Stats
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
            Write-Color -NoNewLine "  Press Enter to continue..." -Color DarkYellow
            $Host.UI.ReadLine()
            #
            # roll for spell
            #
            Clear_Bottom_Half_of_Screen
            $Info_Banner = "Free Spell"
            Draw_Info_Banner
            Write-Color ""
            foreach ($item in $Import_JSON.Spells.PSObject.Properties) {
                "  $($item.Name) - $($item.Value.Name) ($($item.Value.Info))"
            }
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
            Write-Color -NoNewLine "  Now roll another D6 to determine which Spell you receive. Press Enter to continue..." -Color DarkYellow
            $Host.UI.ReadLine()
            # Clear-Host
            Roll_D6_Dice
            # $Random_Dice_Roll = 2
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,34;$Host.UI.Write("")
            Write-Color "  You rolled a ","$Random_Dice_Roll", ". You gain a ","$($Import_JSON.Spells.$Random_Dice_Roll.Name)"," Spell","." -Color DarkGray,White,DarkGray,White,Blue,DarkGray
            $Import_JSON.Character.SpellsTotal += 1
            $Import_JSON.Spells.$Random_Dice_Roll.Quantity += 1
            Update_Variables
            Draw_Player_Window_and_Stats
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
            Write-Color -NoNewLine "  Press Enter to continue..." -Color DarkYellow
            $Host.UI.ReadLine()
            Clear-Host
            #
            # roll for gold
            #
            Write-Color "You have a small pouch to carry some Gold coins which can be used to purchase items from the shop in Settlement." -Color DarkGray,Green,DarkGray
            Read-Host "  Press Enter to roll a D6 to determine how much Gold you will start with... "
            # Clear-Host
            Roll_D6_Dice
            # $Random_Dice_Roll = 13
            Write-Color ""
            Write-Color "  You start with ","$Random_Dice_Roll", " Gold","." -Color DarkGray,White,DarkYellow,DarkGray
            $Import_JSON.Character.Gold = $Random_Dice_Roll
            Update_Variables
            Save_JSON
            Read-Host "  Press Enter to continue..."
            #
            # purchase items from shop
            #
            Clear-Host
            Write-Color "`r`n  The Settlement has a shop where you can buy items before heading out on your adventure." -Color DarkGray
            Write-Color ""
            $All_Settlement_Items_Array = New-Object System.Collections.Generic.List[System.Object]
            foreach ($item in $Import_JSON.Settlement.PSObject.Properties) {
                $All_Settlement_Items_Array.Add("$($item.Name)")
                "$($item.Name) - $($item.Value.Description) ($($item.Value.Cost))"
            }
            do {
                # if only 1 gold, unable to buy any items
                if ($Import_JSON.Character.Gold -eq 1) {
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
                    Write-Color "  You only have 1 Gold, so you can't buy any items from the shop just yet." -Color DarkGray,Green,DarkGray,Blue
                    Read-Host "  Press Enter to continue..."
                } else {
                    # choose to purchase items from shop
                    # do {
                        do {
                            # for ($Position = 19; $Position -lt 22; $Position++) {
                            #     $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,$Position;$Host.UI.Write("");" "*140
                            # }
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
                            if ($Gold -lt 2) {
                                Write-Color "  You have ","$($Import_JSON.Character.Gold) Gold",", so you can't afford to buy any Potions from the shop." -Color DarkGray,DarkYellow,DarkGray,Blue
                                Read-Host "  Press Enter to continue..."
                                $Purchase_Item_Choice = "l"
                            } else {
                                # select an item to purchase from shop
                                Write-Color -NoNewLine "  You have ","$($Import_JSON.Character.Gold) Gold",". Select the item number you would like to purchase, or ","L","eave." -Color DarkGray,DarkYellow,DarkGray,Green,DarkGray
                                $Purchase_Item_Choice = Read-Host " "
                                $Purchase_Item_Choice = $Purchase_Item_Choice.Trim()
                            }
                        } until ($Purchase_Item_Choice -ieq "l" -or $Purchase_Item_Choice -in $All_Settlement_Items_Array)
                        if ($Purchase_Item_Choice -ne "l"){
                            if ($Import_JSON.Settlement.$Purchase_Item_Choice.Cost -gt $Gold) {
                                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("");" "*140
                                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("")
                                Write-Color "  $($Import_JSON.Settlement.$Purchase_Item_Choice.Description)"," costs ","$($Import_JSON.Settlement.$Purchase_Item_Choice.Cost) Gold"," and you only have ","$($Import_JSON.Character.Gold) Gold","." -Color Blue,DarkGray,DarkYellow,DarkGray,DarkYellow,DarkGray
                            } else {
                                switch ($Purchase_Item_Choice) {
                                    1 { # +2 Rations
                                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("");" "*140
                                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("")
                                        Write-Color "  You purchase ","+2 Rations"," for ","6 Gold","." -Color DarkGray,Blue,DarkGray,DarkYellow,DarkGray
                                        $Import_JSON.Character.Gold -= $Import_JSON.Settlement.$Purchase_Item_Choice.Cost
                                        $Import_JSON.Character.Rations += 2
                                    }
                                    2 { # +2 Torches
                                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("");" "*140
                                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("")
                                        Write-Color "  You purchase ","+2 Torches"," for ","6 Gold","." -Color DarkGray,Blue,DarkGray,DarkYellow,DarkGray
                                        $Import_JSON.Character.Gold -= $Import_JSON.Settlement.$Purchase_Item_Choice.Cost
                                        $Import_JSON.Character.Torches += 2
                                    }
                                    3 { # Restore 1 HP
                                        if ($Import_JSON.Character.Stats.HealthCurrent -eq $Import_JSON.Character.Stats.HealthMax) {
                                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("");" "*140
                                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("")
                                            Write-Color "  Your Health is already full at ","$($Import_JSON.Character.Stats.HealthCurrent) / $($Import_JSON.Character.Stats.HealthMax) HP",". You don't need to buy this item right now." -Color Blue,DarkGray,DarkYellow,DarkGray
                                        } else {
                                            $Import_JSON.Character.Stats.HealthCurrent += 1
                                            $Import_JSON.Character.Gold -= $Import_JSON.Settlement.$Purchase_Item_Choice.Cost
                                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("");" "*140
                                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("")
                                            Write-Color "  Your Health has incresed by +1 and is now ","$($Import_JSON.Character.Stats.HealthCurrent) / $($Import_JSON.Character.Stats.HealthMax) HP","." -Color Blue,DarkGray,DarkYellow,DarkGray
                                        }
                                    }
                                    4 { # +1 Potion
                                        $Potion_Purchased = $false
                                        do {
                                            if ($Potion_purchased -eq $false) {
                                                Clear-Host
                                                Write-Color "`r`n  The Settlement Potions (6 Gold each)" -Color DarkGray
                                                Write-Color ""
                                                $All_Settlement_Potions_Array = New-Object System.Collections.Generic.List[System.Object]
                                                foreach ($item in $Import_JSON.Potions.PSObject.Properties) {
                                                    $All_Settlement_Potions_Array.Add($item.Name)
                                                    "$($item.Name) - $($item.Value.Name) ($($item.Value.Info))"
                                                }
                                            }
                                            do {
                                                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
                                                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
                                                Write-Color -NoNewLine "  Each Potion costs ", "6 Gold",". You have ","$($Import_JSON.Character.Gold)", " Gold",". Select the item number you would like to purchase, or [L]eave." -Color DarkGray,DarkYellow,DarkGray,DarkYellow,DarkGray
                                                $Potion_Purchase_Choice = Read-Host " "
                                            } until ($Potion_Purchase_Choice -ieq "l" -or $Potion_Purchase_Choice -in $All_Settlement_Potions_Array)
                                            if ($Potion_Purchase_Choice -ine "l"){
                                                $Potion_Purchased = $true
                                                for ($Position = 19; $Position -lt 25; $Position++) {
                                                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,$Position;$Host.UI.Write("");" "*140
                                                }
                                                # $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("");" "*140
                                                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("")
                                                switch ($Potion_Purchase_Choice) {
                                                    1 { # Healing (1d6)
                                                        Write-Color "  You have purchased a ","$($Import_JSON.Potions.$Potion_Purchase_Choice.Name)"," Potion"," for 6 Gold.", "`r`nThis potion can be used at any time to restore your Health by 3 HP." -Color DarkGray,Blue,DarkGray,Blue,DarkGray
                                                    }
                                                    2 { # Invisibility (Sneak pass location)
                                                        Write-Color "  You have purchased an ","$($Import_JSON.Potions.$Potion_Purchase_Choice.Name)"," Potion"," for 6 Gold.", "`r`nThis potion can be used at any time to sneak past a location hazard or enemy encounter without having to go through the challenge." -Color DarkGray,Blue,DarkGray,Blue,DarkGray
                                                    }
                                                    3 { # Accelerate -3 or +3 journeys or dungeons
                                                        Write-Color "  *** TODO -3 or +3 journeys or dungeons??????????????????????" -Color DarkGray
                                                        Write-Color "  -3 or +3 journeys or dungeons. Add 3 extra journeys or dungeons to your next adventure." -Color DarkGray,Blue,DarkGray,Blue,DarkGray
                                                    }
                                                    4 { # Strength (+2 STR or +2 ATK against next test or monster)
                                                        Write-Color "  *** TODO -3 or +3 journeys or dungeons??????????????????????" -Color DarkGray
                                                        Write-Color "  +2 STR or +2 ATK against next test or monster. +2, or give you +2 ATK against the next monster you fight or test you take." -Color DarkGray,Blue,DarkGray,Blue,DarkGray
                                                    }
                                                    5 { # Invincibility (auto pass a test)
                                                        Write-Color "  You have purchased an Invincibility Potion which will allow you to automatically pass a test.`r`nThis potion can be used when a test is encountered." -Color DarkGray,Blue,DarkGray,Blue,DarkGray
                                                    }
                                                    6 { # Rock Skin (+2 DEF for next fight)
                                                        Write-Color "  You have purchased a Rock Skin Potion which gives you +2 DEF for the next fight." -Color DarkGray,Blue,DarkGray,Blue,DarkGray
                                                    }
                                                    Default {
                                                    }
                                                }
                                                # reduce gold by 6, add potion to inventory, add 1 to potions total
                                                $Import_JSON.Character.Gold -= 6
                                                $Import_JSON.Character.PotionsTotal += 1
                                                $Import_JSON.Potions.$Potion_Purchase_Choice.Quantity += 1
                                            }
                                        } until ($Potion_Purchase_Choice -ieq "l" -or $Gold -lt 6)
                                        Clear-Host
                                        Write-Color "`r`n  The Settlement has a shop where you can buy items before heading out on your adventure." -Color DarkGray
                                        Write-Color ""
                                        foreach ($item in $Import_JSON.Settlement.PSObject.Properties) {
                                            $All_Settlement_Items_Array.Add("$($item.Name)")
                                            "$($item.Name) - $($item.Value.Description) ($($item.Value.Cost))"
                                        }
                                    }
                                    5 { # spells
                                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("");" "*140
                                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("")
                                        Write-Color -NoNewLine "  Spells cost ","15 Gold",", so you can't afford to buy any from the shop just yet." -Color DarkGray,DarkYellow,DarkGray
                                    }
                                    6 { # Training (+5 XP)
                                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("");" "*140
                                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("")
                                        Write-Color -NoNewLine "  Training costs ","25 Gold",", so you can't afford to buy it from the shop just yet." -Color DarkGray,DarkYellow,DarkGray
                                    }
                                    7 { # Reurrection (return to life at the Settelement when at zero HP)
                                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("");" "*140
                                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("")
                                        Write-Color -NoNewLine "  Reurrection costs ","30 Gold",", so you can't afford to buy it from the shop just yet." -Color DarkGray,DarkYellow,DarkGray
                                    }
                                    Default {}
                                }
                                Save_JSON
                                Update_Variables
                            }
                        }
                    # } until ($Purchase_Item_Choice -ieq "l");
                }
            } until ($Import_JSON.Character.Gold -lt 2 -or $Purchase_Item_Choice -ieq "l");
            #
            # Obtain Quest
            #
            Clear-Host
            Write-Color "`r`n  Before you can head out on your adventure, select a quest which will earn you some XP and Gold." -Color DarkGray
            Write-Color "`r`n  You need to return back to the ","Settlement"," to gain the rewards, you don't gain them during your adventure." -Color DarkGray,White,DarkGray
            Write-Color "`r`n  Only one quest can be embarked on at once." -Color DarkGray,White,DarkGray
            Write-Color ""
            foreach ($item in $Import_JSON.Quests.PSObject.Properties) {
                $All_Settlement_Items_Array.Add("$($item.Name)")
                Write-Color "$($item.Name) - $($item.Value.Short_Description) - ($($item.Value.Gold_Reward) Gold & $($item.Value.XP_Reward) XP)" -Color Blue,DarkGray,DarkYellow,DarkGray,DarkYellow,DarkGray
            }
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
            Write-Color -NoNewLine "  Now roll a D6 to determine which Quest you will embark on. Press Enter to continue..." -Color DarkYellow
            Read-Host " "
            # Clear-Host
            Roll_D6_Dice
            # $Random_Dice_Quest = 1
            Write-Color -NoNewLine "`r`n  You rolled a ","$Random_Dice_Roll", ". You obtain the ","$($Import_JSON.Quests.$Random_Dice_Roll.Name)"," Quest ","and must ","$($Import_JSON.Quests.$Random_Dice_Roll.Long_Description)",". Press Enter to continue." -Color DarkGray,White,DarkGray,White,Blue,DarkGray,White,DarkGray
            $Import_JSON.Quests.$Random_Dice_Roll.Active = $true
            Read-Host " "
            Clear-Host
            #
            # roll for journeys and wilderness encounters
            #
            Clear-Host
            Write-Color "`r`n  You're ready to embark on your adventure." -Color DarkGray
            Write-Color "`r`n  The first steps you take will be into the Wilderness before you reach a Dungeon." -Color DarkGray,White,DarkGray
            Write-Color ""
            Write-Color "  Wilderness Journeys" -Color DarkGray
            Write-Color ""
            Write-Color "   d6 roll ","|"," Journeys" -Color DarkGray,White,DarkGray
            Write-Color "   ---------+-----------" -Color White
            Write-Color "      1-2   ","|"," 1 Journey" -Color DarkGray,White,DarkGray
            Write-Color "      3-4   ","|"," 2 Journeys" -Color DarkGray,White,DarkGray
            Write-Color "      5-6   ","|"," 3 Journeys" -Color DarkGray,White,DarkGray
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
            Write-Color -NoNewLine "  Roll a d6 to see how many Wilderness Journeys you will encounter. Press Enter to continue..." -Color DarkYellow
            Read-Host " "
            Roll_D6_Dice
            # $Random_Dice_Roll = 5
            if ($Random_Dice_Roll -eq 1 -or $Random_Dice_Roll -eq 2) { $Wilderness_Journeys = 1 }
            if ($Random_Dice_Roll -eq 3 -or $Random_Dice_Roll -eq 4) { $Wilderness_Journeys = 2 }
            if ($Random_Dice_Roll -eq 5 -or $Random_Dice_Roll -eq 6) { $Wilderness_Journeys = 3 }
            Write-Color -NoNewLine "`r`n  You rolled a ","$Random_Dice_Roll", ". You will encounter ","$Wilderness_Journeys", " Wilderness Journeys on your way to the Dungeon." -Color DarkGray,White,DarkGray,White,DarkGray
            $Import_JSON.Character.Wilderness_Journeys = $Wilderness_Journeys
            Update_Variables
            Write-Color "`r`n  Your ","$Wilderness_Journeys", " Wilderness Journeys are:" -Color DarkGray,White,DarkGray
            #
            # Wilderness Journeys (Encounters)
            #
            for ($i = 1; $i -lt $Wilderness_Journeys+1; $i++) {
                # $i
                Write-Color -NoNewLine "`r`n  Journey #","$i" -Color DarkGray,White

            }
            Read-Host " "

            # roll xd6 (3, 4 or 5 as per roll above) for each journey (wilderness encounters)
            # Wilderness encounters (tests)
            # - Wilderness list - 1d6 (test, fail, success)
            #   - 1 = Plains (none, Encounter only)
            #   - 2 = Forest - INT 3, -1 Rations, +2 Rations
            #   - 3 = River - DEX 3, -1 HP, +1 Gold
            #   - 4 = Campsite - STR 3, -2 Gold, +2 HP or +2 Torch
            #   - 5 = Hill - DEX 4, -2 Rations, +2 XP
            #   - 6 = Swamp - STR 5, -2 HP, +5 Gold








            # confirm all character choices
            Clear-Host
            $Update_Character_JSON = $false
            $Update_Character_JSON_Valid = $false
            $Update_Character_JSON_Confirm = $false
            do {
                Write-Color -NoNewLine "  Are all your Character details correct? ", "[Y/N/E]" -Color DarkYellow,Green
                $Update_Character_JSON = Read-Host " "
                $Update_Character_JSON = $Update_Character_JSON.Trim()
                if (-not($null -eq $Update_Character_JSON -or $Update_Character_JSON -eq " " -or $Update_Character_JSON -eq "")) {
                    $Update_Character_JSON_Valid = $true
                }
            } until ($Update_Character_JSON_Valid -eq $true)
            if ($Update_Character_JSON -ieq "y") {
                $Update_Character_JSON_Confirm = $true
            } else {
                if ($Update_Character_JSON -ieq "e") {Exit}
            }
            
        } until ($Update_Character_JSON_Confirm -eq $true)
        #
        # set JSON character stats
        #
        $Import_JSON.Character_Creation = $true
        Save_JSON
        Import_JSON
        Update_Variables
        Clear-Host
        # Draw_Player_Window_and_Stats
    
    } until ($Update_Character_JSON_Confirm -eq $true)
}

#
# sets variables
#
Function Update_Variables {
    $Script:Character_Name              = $Import_JSON.Character.Name
    $Script:Character_HealthCurrent     = $Import_JSON.Character.Stats.HealthCurrent
    $Script:Character_HealthMax         = $Import_JSON.Character.Stats.HealthMax
    $Script:Character_STR               = $Import_JSON.Character.Stats.STR
    $Script:Character_DEX               = $Import_JSON.Character.Stats.DEX
    $Script:Character_INT               = $Import_JSON.Character.Stats.INT
    $Script:Rations                     = $Import_JSON.Character.Rations
    $Script:Torches                     = $Import_JSON.Character.Torches
    $Script:SpellsTotal                 = $Import_JSON.Character.SpellsTotal
    $Script:PotionsTotal                = $Import_JSON.Character.PotionsTotal
    $Script:Gold                        = $Import_JSON.Character.Gold
    $Script:Total_XP                    = $Import_JSON.Character.Total_XP
    $Script:Wilderness_Journeys         = $Import_JSON.Character.Wilderness_Journeys
    $Script:Current_Location            = $Import_JSON.Character.Current_Location
    $Script:Equipment                   = $Import_JSON.Character.Equipment
    $Script:Weapon                      = $Import_JSON.Character.Weapon
    $Script:Quest                       = $Import_JSON.Character.Quest
    $Script:Wilderness_Journeys_Total   = $Import_JSON.Character.Wilderness_Journeys_Total
    $Script:Wilderness_Journeys_Current = $Import_JSON.Character.Wilderness_Journeys_Current
    $Script:Dungeon_Room_Total          = $Import_JSON.Character.Dungeon_Room_Total
    $Script:Dungeon_Room_Current        = $Import_JSON.Character.Dungeon_Room_Current
    $Script:Potions_Total               = $Import_JSON.Character.PotionsTotal
    $Script:Potions_Quantity_1          = $Import_JSON.Potions."1".Quantity
    $Script:Potions_Quantity_2          = $Import_JSON.Potions."2".Quantity
    $Script:Potions_Quantity_3          = $Import_JSON.Potions."3".Quantity
    $Script:Potions_Quantity_4          = $Import_JSON.Potions."4".Quantity
    $Script:Potions_Quantity_5          = $Import_JSON.Potions."5".Quantity
    $Script:Potions_Quantity_6          = $Import_JSON.Potions."6".Quantity
    $Script:Spells_Total                = $Import_JSON.Character.SpellsTotal
    $Script:Spells_Quantity_1           = $Import_JSON.Spells."1".Quantity
    $Script:Spells_Quantity_2           = $Import_JSON.Spells."2".Quantity
    $Script:Spells_Quantity_3           = $Import_JSON.Spells."3".Quantity
    $Script:Spells_Quantity_4           = $Import_JSON.Spells."4".Quantity
    $Script:Spells_Quantity_5           = $Import_JSON.Spells."5".Quantity
    $Script:Spells_Quantity_6           = $Import_JSON.Spells."6".Quantity


    # sets current Location
    $All_Locations                  = $Import_JSON.Locations.PSObject.Properties.Name
    foreach ($Single_Location in $All_Locations) {
        if ($Import_JSON.Locations.$Single_Location.Current_Location -ieq "true") {
            $Script:Current_Location = $Single_Location
        }
    }
}
















#
# PLACE FUNCTIONS ABOVE HERE
#

Clear-Host

#
# write any errors out to error.log file
#
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
    Write-Color "`r`nAs previously mentioned, the PSWriteColor PowerShell module written by Przemyslaw Klys is required, which," -Color DarkGray
    Write-Color "if you are seeing this message then it has installed and imported successfully." -Color DarkGray
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
# double check module is still installed if JSON file has previously been created, just in case the module has been removed.
#
if (Test-Path -Path .\PS-BCDD.json) {
    $PSWriteColor_Installed = Get-Module -Name "PSWriteColor" -ListAvailable
    if ($PSWriteColor_Installed) {
        Import-Module -Name "PSWriteColor"
    } else {
        Install_PSWriteColor
    }
}

#
# check for JSON save file
#
# if the save file has the Character_Creation flag set to false, deletes JSON file (i.e. if character creation was cancelled or not fully completed - safe to delete file)
if (Test-Path -Path .\PS-BCDD.json) {
    Import_JSON
    if ($Import_JSON.Character_Creation -eq $false) {
        Remove-Item -Path .\PS-BCDD.json
    }
}

#
# loads save file and validate JSON file is on PowerShell Core edition
#
if (Test-Path -Path .\PS-BCDD.json) {
    # check for powershell core or desktop then validate json data file
    if ($PSVersionTable.PSEdition -ieq "Desktop") { # unable to validata JSON file in PowerShell Desktop edition
        Write-Color -LinesBefore 1 "Unable to validate JSON file because ","PS-BCDD.ps1 ","is running under PowerShell 'Desktop' edition." -Color DarkYellow,Magenta,DarkYellow
        Write-Color "Continuing." -Color DarkYellow
        Start-Sleep -Seconds 6 # leave in
    }
    if ($PSVersionTable.PSEdition -ieq "Core") { # check if JSON file is valid under PowerShell Core edition
        $JSON_File_Valid = Test-Json -Path .\PS-BCDD.json
        if ($JSON_File_Valid -eq $false) {
            Write-Color -LinesBefore 1 "Invalid ","PS-BCDD.json"," file. Please download JSON file again from ","https://github.com/RPGash/PS-BCDD ","Exiting." -Color Red,Magenta,Red,Magenta,Red,DarkCyan
            Write-Color "Exiting ","PS-BCDD.ps1" -Color Red,Magenta
            Exit
        } else {
            Write-Color "PS-BCDD.json"," file is ","valid." -Color Magenta,DarkYellow,Green
            # Start-Sleep -Seconds 1 # pause to show valid JSON message
        }
    }
    do {
        Clear-Host
        # display current saved file info
        Import_JSON
        # Update_Variables
        # Draw_Player_Window_and_Stats
        # Draw_Inventory
        # Draw_Introduction_Tasks
        do {
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("");" "*140
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
            Write-Color -NoNewLine "PS-BCDD.json ","save data found. Load saved data?"," [Y/N/E]" -Color Magenta,DarkYellow,Green
            $Load_Save_Data_Choice = Read-Host " "
            $Load_Save_Data_Choice = $Load_Save_Data_Choice.Trim()
        } until ($Load_Save_Data_Choice -ieq "y" -or $Load_Save_Data_Choice -ieq "n" -or $Load_Save_Data_Choice -ieq "e")
        if ($Load_Save_Data_Choice -ieq "e") {
            Write-Color -NoNewLine "Exiting ","PS-BCDD","." -Color DarkYellow,Magenta,DarkYellow
            Exit
        }
        if ($Load_Save_Data_Choice -ieq "y") {
            # Import_JSON
            # Update_Variables
            Clear-Host
            # Draw_Player_Window_and_Stats
        }
        if ($Load_Save_Data_Choice -ieq "n") {
            do {
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("");" "*140
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
                Write-Color -NoNewLine "Start a new game?"," [Y/N/E]" -Color Magenta,Green
                $Start_A_New_Game = Read-Host " "
                $Start_A_New_Game = $Start_A_New_Game.Trim()
            } until ($Start_A_New_Game -ieq "y" -or $Start_A_New_Game -ieq "n" -or $Start_A_New_Game -ieq "e")
            if ($Start_A_New_Game -ieq "y") {
                # new game
                Game_Introduction
                Create_Character
            }
        }
    } until ($Load_Save_Data_Choice -ieq "y" -or $Start_A_New_Game -ieq "y" -or $Start_A_New_Game -ieq "e")
} else {
    # no JSON file found
    Game_Introduction
    Create_Character
}
if ($Load_Save_Data_Choice -ieq "e" -or $Start_A_New_Game -ieq "e") {
    Write-Color -NoNewLine "Quitting ","PS-BCDD","." -Color DarkYellow,Magenta,DarkYellow
    Exit
}

#
# first thing after character creation / loading saved data
#
# main loop







