# ToDo
# ----
#
# - TODO : one of the Pass tests has a choice of two rewards which is not taken into account.
#          updated displaying table but still need to work on when reward is actually granted at the end of the quest.
# - after spending all gold at the shop during adventurer creation, say you have no gold left before continuing
# - add <this> in...
#     You rolled a 6 and obtain the Retrieve Quest.
#     Your objective is to find and retrieve 3 Tomes. <"you will gain x XP and x Gold">
# - You roll a 2 and Fail the test. You lose 2 Gold.
#     gold can currently go into negative
#
# BUGS
# ----
# - 
# - 


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
    Write-Color ""
    Write-Color "  Welcome to the Business Card Dungeon Delve (PowerShell Edition)!" -Color Green
    Write-Color "`r`n  This is a text-based adventure game written in PowerShell inspired by the original game designed by Melv Lee." -Color DarkGray
    Write-Color "  This game follows the original rules and is `'A One card Overland Journey and Dungeon Dive game`'." -Color DarkGray
    Write-Color "`r`n  In this game, your Adventurer will take on Quests, go on Journeys, encounter NPCs, fight Monsters," -Color DarkGray
    Write-Color "  take Stat tests, learn Spells, chuck Potions, set off Traps, Earn gold, and Level up." -Color DarkGray
    Write-Color "`r`n  The game is played through the console and uses a JSON file to save your character's progress." -Color DarkGray
    Write-Color "  The game will automatically save as you play, but try not to close the console window or save data may be lost." -Color DarkGray
    Write-Color "`r`n  The game uses the PSWriteColor module to provide coloured text output for a better gaming experience." -Color DarkGray
    Write-Color "  If you don't have the module installed, the game will prompt you to install it before you can play." -Color DarkGray
    Write-Color "`r`n  The game is still in development, so expect some bugs and incomplete features." -Color DarkGray
    Write-Color "  Feel free to report any issues or suggest improvements on the GitHub repository." -Color DarkGray
    Write-Color "`r`n  Have fun playing and delving into the dungeon!" -Color Green
    Write-Color ""
    Write-Color -NoNewLine "  Press Enter to continue..." -Color DarkYellow
    $Host.UI.ReadLine() | Out-Null
}



#
# roll random D6
#
Function Roll_D6_Dice {
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
    Write-Color "  Rolling a D6 dice." -Color DarkYellow
    $Random_Dice_Roll_Random_Seconds = Get-Random -Minimum 4 -Maximum 10 # display rolling of dice for 5-10 seconds
    for ($i = 0; $i -lt $Random_Dice_Roll_Random_Seconds; $i++) {
        do {
            $Script:Random_Dice_Roll = Get-Random -Minimum 1 -Maximum 7
        } until ($Random_Dice_Roll -ne $Last_Dice_Roll) # do this to not roll the same number twice in a row, otherwise the dice doesn't update on screen
        for ($Position = 35; $Position -lt 36; $Position++) {
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,$Position;$Host.UI.Write("");" "*140
        }
        $Script:Last_Dice_Roll = $Random_Dice_Roll
        $host.UI.RawUI.ForegroundColor = "White"
        switch ($Random_Dice_Roll) {
            1 {
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,30;$Host.UI.Write("+-------+")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,31;$Host.UI.Write("|       |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,32;$Host.UI.Write("|   o   |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,33;$Host.UI.Write("|       |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,34;$Host.UI.Write("+-------+")
                break
            }
            2 {
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,30;$Host.UI.Write("+-------+")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,31;$Host.UI.Write("| o     |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,32;$Host.UI.Write("|       |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,33;$Host.UI.Write("|     o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,34;$Host.UI.Write("+-------+")
                break
            }
            3 {
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,30;$Host.UI.Write("+-------+")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,31;$Host.UI.Write("| o     |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,32;$Host.UI.Write("|   o   |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,33;$Host.UI.Write("|     o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,34;$Host.UI.Write("+-------+")
                break
            }
            4 {
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,30;$Host.UI.Write("+-------+")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,31;$Host.UI.Write("| o   o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,32;$Host.UI.Write("|       |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,33;$Host.UI.Write("| o   o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,34;$Host.UI.Write("+-------+")
                break
            }
            5 {
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,30;$Host.UI.Write("+-------+")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,31;$Host.UI.Write("| o   o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,32;$Host.UI.Write("|   o   |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,33;$Host.UI.Write("| o   o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,34;$Host.UI.Write("+-------+")
                break
            }
            6 {
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,30;$Host.UI.Write("+-------+")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,31;$Host.UI.Write("| o   o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,32;$Host.UI.Write("| o   o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,33;$Host.UI.Write("| o   o |")
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 52,34;$Host.UI.Write("+-------+")
                break
            }
            Default {
            }
        }
        # $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38
        Write-Output "`e[?25l" # hides blinking cursor
        # Start-Sleep -Seconds 2
        $Random_Milliseconds = Get-Random -Minimum 200 -Maximum 1000
        Start-Sleep -Milliseconds $Random_Milliseconds
    }
    $host.UI.RawUI.ForegroundColor = "DarkGray" # set the foreground color back to original colour
    Write-Output "`e[?25h" # shows blinking cursor
}



#
# player window and stats
#
Function Draw_Player_Window_and_Stats {
    $host.UI.RawUI.ForegroundColor = "DarkGray"
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,0;$Host.UI.Write( "+---------------------------+---------------------+--------------------------+-------------------+")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,1;$Host.UI.Write( "| Adventurer                | Enemy               | Quest :                  | Potions    0 of 3 |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,2;$Host.UI.Write( "+ ----------                + -----               | Objective :              | Healing       :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,3;$Host.UI.Write( "| Name      :               | Name   : Skeleton   | 0 of 4 rations collected | Invisibility  :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,4;$Host.UI.Write( "| Health    :    of         | HP     :            +--------------------------+ Accelerate    :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,5;$Host.UI.Write( "| STR       :               | Attack :            | Wilderness :             | Strength      :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,6;$Host.UI.Write( "| DEX       :               | Loot   :            | Journeys                 | Invincibility :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,7;$Host.UI.Write( "| INT       :               |                     |     of                   | Rock Skin     :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,8;$Host.UI.Write( "| Location  :               +---------------------+                          +-------------------+")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,9;$Host.UI.Write( "| Gold      :               | Tests               |                          | Spells     0 of 3 |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,10;$Host.UI.Write("| Total XP  :               | -----               +--------------------------+ Healing Hands :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,11;$Host.UI.Write("| Equipment :               | Test : Poison Darts | Dungeon    : Passage     | Fire Ball     :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,12;$Host.UI.Write("| Weapon    :               | Stat :              | Rooms                    | Light         :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,13;$Host.UI.Write("| Rations   :               | Pass :              |     of                   | Lightning     :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,14;$Host.UI.Write("| Torches   :               | Fail :              |                          | Morphing      :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,15;$Host.UI.Write("|           : v             |                     |                          | Teleport      :   |")
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 0,16;$Host.UI.Write("+---------------------------+---------------------+--------------------------+-------------------+")
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
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 60,3;$Host.UI.Write($Quest_Objective)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 60,3;$Host.UI.Write($Quest_Objective_Complete)

    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 59,7;$Host.UI.Write($Wilderness_Journeys_Total)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 54,7;$Host.UI.Write($Wilderness_Journeys_Current_Number)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 65,5;$Host.UI.Write($Wilderness_Journeys_History_Name_1)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 65,6;$Host.UI.Write($Wilderness_Journeys_History_Name_2)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 65,7;$Host.UI.Write($Wilderness_Journeys_History_Name_3)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 65,8;$Host.UI.Write($Wilderness_Journeys_History_Name_4)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 65,9;$Host.UI.Write($Wilderness_Journeys_History_Name_5)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 74,5;$Host.UI.Write($Wilderness_Journeys_History_Name_Complete_1)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 74,6;$Host.UI.Write($Wilderness_Journeys_History_Name_Complete_2)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 74,7;$Host.UI.Write($Wilderness_Journeys_History_Name_Complete_3)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 74,8;$Host.UI.Write($Wilderness_Journeys_History_Name_Complete_4)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 74,9;$Host.UI.Write($Wilderness_Journeys_History_Name_Complete_5)

    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 59,13;$Host.UI.Write($Dungeon_Room_Total)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 54,13;$Host.UI.Write($Dungeon_Room_Current)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 65,11;$Host.UI.Write($Dungeon_Room_Name_1)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 65,12;$Host.UI.Write($Dungeon_Room_Name_2)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 65,13;$Host.UI.Write($Dungeon_Room_Name_3)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 65,14;$Host.UI.Write($Dungeon_Room_Name_4)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 65,15;$Host.UI.Write($Dungeon_Room_Name_5)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 74,11;$Host.UI.Write($Dungeon_Room_Complete_1)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 74,12;$Host.UI.Write($Dungeon_Room_Complete_2)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 74,13;$Host.UI.Write($Dungeon_Room_Complete_3)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 74,14;$Host.UI.Write($Dungeon_Room_Complete_4)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 74,15;$Host.UI.Write($Dungeon_Room_Complete_5)

    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 90,1;$Host.UI.Write($Potions_Total)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 95,2;$Host.UI.Write($Potions_Quantity_1)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 95,3;$Host.UI.Write($Potions_Quantity_2)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 95,4;$Host.UI.Write($Potions_Quantity_3)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 95,5;$Host.UI.Write($Potions_Quantity_4)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 95,6;$Host.UI.Write($Potions_Quantity_5)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 95,7;$Host.UI.Write($Potions_Quantity_6)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 90,9;$Host.UI.Write($Spells_Total)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 95,10;$Host.UI.Write($Spells_Quantity_1)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 95,11;$Host.UI.Write($Spells_Quantity_2)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 95,12;$Host.UI.Write($Spells_Quantity_3)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 95,13;$Host.UI.Write($Spells_Quantity_4)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 95,14;$Host.UI.Write($Spells_Quantity_5)
    $Host.UI.RawUI.CursorPosition  = New-Object System.Management.Automation.Host.Coordinates 95,15;$Host.UI.Write($Spells_Quantity_6)
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
    $Info_Banner_Padding = " "*(97-3-($Info_Banner | Measure-Object -Character).Characters)
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,17;$Host.UI.Write("")
    Write-Color "| ","$Info_Banner","$Info_Banner_Padding|" -Color DarkGray,White,DarkGray
    Write-Color "+-----------------------------------------------------------------------------------------------+" -Color DarkGray
}



#
# clear the bottom of the screen for new text output
#
Function Clear_Bottom_Half_of_Screen {
    for ($Position = 19; $Position -lt 38; $Position++) {
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,$Position;$Host.UI.Write("");" "*140
    }
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,19;$Host.UI.Write("")
}



#
# create Adventurer
#
Function Create_Adventurer {
    #
    # Adventurer name
    #
    Copy-Item -Path .\PS-BCDD_new_game.json -Destination .\PS-BCDD.json
    Import_JSON
    # $Character_Name = $false
    # $Character_Name_Valid = $false
    # $Character_Name_Confirm = $false
    # Adventurer name loop
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
                if ($($Character_Name | Measure-Object -Character).Characters -gt 12) {
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25
                    Write-Color "  *Your name is too long, your name must be 12 characters or less*" -Color Red
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,19
                }
                if ($Random_Character_Name_Count -eq 0) {
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25
                    Write-Color "  *All random names have been suggested*" -Color Red
                }
                Write-Color ""
                Write-Color "  Choose your Adventurer name" -Color DarkGray
                Write-Color "  If you cannot think of a name, try searching for one online or enter ","R ","for some random name suggestions." -Color DarkGray,Green,DarkGray
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
                Write-Color -NoNewLine "  Enter a name (max 12 characters) or ","R","andom ","[R]" -Color DarkYellow,Green,DarkYellow,Green
                $Character_Name_Valid = $false # set to false to prevent a Adventurername of " " nothing after entering a name with more than 10 characters
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
                        if ($Gandalf_Joke -ieq "Gandalf the Gray") {
                            Write-Color "  Oh wait. That name has more than 10 characters. You'll have to pick another name, sorry about that =|" -Color DarkGray
                            Write-Color "  Where were we..." -Color DarkGray
                        }
                        if ($Character_Name_Random -ieq "n") {
                            $Random_Character_Name_Count += 1
                            Write-Color ""
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
                            Write-Color ""
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
                        Write-Color -NoNewLine "  You have chosen ", "$Character_Name ", "for your Adventurers name, is this correct? ", "[Y/N]" -Color DarkYellow,Blue,DarkYellow,Green
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
                Write-Color -NoNewLine "  You have chosen ", "$Character_Name ", "for your Adventurer name, is this correct? ", "[Y/N/E]" -Color DarkYellow,Blue,DarkYellow,Green
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
    $Import_JSON.Character.Current_Location = "Settlement"
    Update_Variables
    Draw_Player_Window_and_Stats
    #
    # Adventurer stats
    #
    Function Press_Continue {
        Update_Variables
        Draw_Player_Window_and_Stats
        Save_JSON
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,39;$Host.UI.Write("");" "*140
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
        Write-Color -NoNewLine "  Press Enter to continue..." -Color DarkYellow
        $Host.UI.ReadLine() | Out-Null
    }
    $Info_Banner = "Health, Rations and Torches"
    Draw_Info_Banner
    for ($Position = 19; $Position -lt 35; $Position++) {
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,$Position;$Host.UI.Write("");" "*140
    }
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,19;$Host.UI.Write("")
    Write-Color ""
    Write-Color "  Now that you have chosen a name, let's work on some stats." -Color DarkGray
    Press_Continue
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,22;$Host.UI.Write("")
    Write-Color "  Your max ","Health"," can only ever be ","12",", so you will start with that." -Color DarkGray,Green,DarkGray,Green,DarkGray
    Write-Color "  You can't go over this amount, no matter how many ","potions"," you quaff." -Color DarkGray,Blue,DarkGray
    $Import_JSON.Character.Stats.HealthCurrent = 12
    $Import_JSON.Character.Stats.HealthMax     = 12
    Press_Continue
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,25;$Host.UI.Write("")
    Write-Color "  You will also start with ","6"," Rations",", and ","6"," Torches." -Color DarkGray,White,Blue,DarkGray,White,Blue
    Write-Color "  Rations"," are used when travelling between locations, and ","Torches"," are used when exploring dungeons." -Color Blue,DarkGray,Blue,DarkGray
    $Import_JSON.Character.Rations = 6
    $Import_JSON.Character.Torches = 6
    Press_Continue
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,28;$Host.UI.Write("")
    Write-Color "  You use ","1"," Ration"," per journey." -Color DarkGray,White,Blue,DarkGray
    Write-Color "  If you run out of ","Rations",", you will lose ","1"," Health"," each time you travel between locations." -Color DarkGray,Blue,DarkGray,White,Green,DarkGray
    Write-Color "  When your character's ","Health ","reaches ","0",", it's game over and you will have to re-roll another character." -Color DarkGray,Green,DarkGray,Red,DarkGray
    Press_Continue
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,32;$Host.UI.Write("")
    Write-Color "  You use ","1"," Torch"," per dungeon room you visit." -Color DarkGray,White,Blue,DarkGray
    Write-Color "  If you use up all your ","Torches",", you'll be lost in the dungeon forever and unable to escape!" -Color DarkGray,Blue,DarkGray
    Write-Color "  If this happens, you will have to re-roll another Adventurer and start your Adventure again." -Color DarkGray
    Press_Continue
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
    Write-Color "  Rations"," and ","Torches"," can sometimes be found in enemy loot, but can also bought from the Settlement shop." -Color Blue,DarkGray,Blue,DarkGray
    Press_Continue
    Clear_Bottom_Half_of_Screen
    $Info_Banner = "Stats - STR, DEX and INT"
    Draw_Info_Banner
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,19;$Host.UI.Write("")
    Write-Color ""
    Write-Color "  Your other stats, ","STR",", ","DEX"," and ","INT",", will start at ","0"," for now," -Color DarkGray,White,DarkGray,White,DarkGray,White,DarkGray,White,DarkGray
    Write-Color "  but you'll get the chance to increase these when you gain some XP from killing enemies." -Color DarkGray
    $Import_JSON.Character.Stats.STR = 0
    $Import_JSON.Character.Stats.DEX = 0
    $Import_JSON.Character.Stats.INT = 0
    Press_Continue
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,23;$Host.UI.Write("")
    Write-Color "  STR"," (Strength), ","DEX"," (Dexterity) and ","INT"," (Intelligence), are used to determine ","Pass"," and ","Fail" -Color White,DarkGray,White,DarkGray,White,DarkGray,Green,DarkGray,Red
    Write-Color "  results against certain tests from events suchs as Encounters, Hazards and NPC interactions." -Color DarkGray
    Press_Continue
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,26;$Host.UI.Write("")
    Write-Color "  STR"," and ","DEX"," are also used in combat to determine attack and defence results against enemies." -Color White,DarkGray,White,DarkGray
    Press_Continue
    #
    # potion and spells
    #
    Clear_Bottom_Half_of_Screen
    $Info_Banner = "Potions and Spells"
    Draw_Info_Banner
    Write-Color "`r`n  Potions"," and ","Spells"," are items that can be used at any time that can heal you, cause damage to enemies," -Color Blue,DarkGray,Blue,DarkGray
    Write-Color "  raise your stats temporally and even teleport you back to the Settlement." -Color DarkGray
    Press_Continue
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,22;$Host.UI.Write("")
    Write-Color "`r`n  You can also find them in loot from enemies, or buy them from the shop in the Settlement." -Color DarkGray
    Press_Continue
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,24;$Host.UI.Write("")
    Write-Color "`r`n  You start with a free ","Potion"," and ","Spell","." -Color DarkGray,Blue,DarkGray,Blue,DarkGray
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
    Write-Color -NoNewLine "  Press Enter to continue..." -Color DarkYellow
    $Host.UI.ReadLine() | Out-Null
    #
    # roll for potion
    #
    Clear_Bottom_Half_of_Screen
    $Info_Banner = "Free Potion"
    Draw_Info_Banner
    Draw_Potion_Spells_Shop_Table -Value "Potions"
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
    Write-Color -NoNewLine "  Roll a D6 to determine which ","Potion ","you receive. Press Enter to continue..." -Color DarkYellow,White,DarkYellow
    $Host.UI.ReadLine() | Out-Null
    Roll_D6_Dice
    # $Random_Dice_Roll = 1
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
    Write-Color "  You rolled a ","$Random_Dice_Roll", ". You gain a ","$($Import_JSON.Potions.$Random_Dice_Roll.Name)"," Potion","." -Color DarkGray,White,DarkGray,Blue,White,DarkGray
    $Import_JSON.Character.PotionsTotal += 1
    $Import_JSON.Potions.$Random_Dice_Roll.Quantity += 1
    Update_Variables
    Draw_Player_Window_and_Stats
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
    Write-Color -NoNewLine "  Press Enter to continue..." -Color DarkYellow
    $Host.UI.ReadLine() | Out-Null
    #
    # roll for spell
    #
    Clear_Bottom_Half_of_Screen
    $Info_Banner = "Free Spell"
    Draw_Info_Banner
    Draw_Potion_Spells_Shop_Table -Value "Spells"
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
    Write-Color -NoNewLine "  Now roll another D6 to determine which ","Spell ","you receive. Press Enter to continue..." -Color DarkYellow,White,DarkYellow
    $Host.UI.ReadLine() | Out-Null
    Roll_D6_Dice
    # $Random_Dice_Roll = 2
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
    Write-Color "  You rolled a ","$Random_Dice_Roll ", "and gain a ","$($Import_JSON.Spells.$Random_Dice_Roll.Name)"," Spell","." -Color DarkGray,White,DarkGray,Blue,White,DarkGray
    $Import_JSON.Character.SpellsTotal += 1
    $Import_JSON.Spells.$Random_Dice_Roll.Quantity += 1
    Update_Variables
    Draw_Player_Window_and_Stats
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
    Write-Color -NoNewLine "  Press Enter to continue..." -Color DarkYellow
    $Host.UI.ReadLine() | Out-Null
    #
    # roll for gold
    #
    Clear_Bottom_Half_of_Screen
    $Info_Banner = "Gold"
    Draw_Info_Banner
    Write-Color ""
    Write-Color "  You have a small pouch to carry some ","Gold ","coins." -Color DarkGray,DarkYellow,DarkGray
    Write-Color "  These can be used to purchase items from the Settlement shop." -Color DarkGray,DarkYellow,DarkGray
    Press_Continue
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,22;$Host.UI.Write("")
    Write-Color "`r`n  As per the original game by Melv Lee, the main goal of the game is to collect ","120 Gold","," -Color DarkGray,DarkYellow,DarkGray
    Write-Color "  enough to buy a piece of farmland to retire from the risky Adventurer's life." -Color DarkGray
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
    Write-Color -NoNewLine "  Roll a D6 to determine how much ","Gold ","you will start with. Press Enter to continue..." -Color DarkYellow,White,DarkYellow
    $Host.UI.ReadLine() | Out-Null
    Roll_D6_Dice
    # $Random_Dice_Roll = 1
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,35;$Host.UI.Write("")
    Write-Color "  You start with ","$Random_Dice_Roll", " Gold","." -Color DarkGray,White,DarkYellow,DarkGray
    if ($Random_Dice_Roll -ne 1) {
        Write-Color "  You can now visit the shop and purchase some items." -Color DarkGray
    }
    $Import_JSON.Character.Gold = $Random_Dice_Roll
    Update_Variables
    Draw_Player_Window_and_Stats
    Save_JSON
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
    Write-Color -NoNewLine "  Press Enter to continue..." -Color DarkYellow
    $Host.UI.ReadLine() | Out-Null
    #
    # purchase items from settlement shop
    #
    do {
        Clear_Bottom_Half_of_Screen
        $Info_Banner = "Shop"
        Draw_Info_Banner
        Draw_Potion_Spells_Shop_Table -Value "Settlement"
        # basic items table (not being used. instead using overengineered auto adjusting table window read from JSON data)
        # $All_Settlement_Items_Array = New-Object System.Collections.Generic.List[System.Object]
        #     foreach ($item in $Import_JSON.Settlement.PSObject.Properties) {
        #         $All_Settlement_Items_Array.Add("$($item.Name)")
        #         Write-Color "  $($item.Name)"," - ","$($item.Value.Description)"," (","$($item.Value.Cost) Gold",")" -Color White,DarkGray,Blue,DarkGray,DarkYellow,DarkGray
        #     }
        # if only 1 gold, unable to buy any items
        if ($Import_JSON.Character.Gold -eq 1) {
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
            Write-Color "  You only have ","1 Gold",", so you can't buy any items from the shop just yet." -Color DarkGray,DarkYellow,DarkGray
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
            Write-Color -NoNewLine "  Press Enter to continue..." -Color DarkYellow
            $Host.UI.ReadLine() | Out-Null
        } else { # otherwise choose to purchase items from shop
            do {
                # select an item to purchase from shop
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
                Write-Color -NoNewLine "  You have ","$Gold Gold",". Select the ","item number ","you would like to purchase, or ","L","eave." -Color DarkYellow,White,DarkYellow,White,DarkYellow,Green,DarkYellow
                $Purchase_Item_Choice = Read-Host " "
                $Purchase_Item_Choice = $Purchase_Item_Choice.Trim()
            } until ($Purchase_Item_Choice -ieq "l" -or $Purchase_Item_Choice -in $All_Settlement_Items_Array)
            if ($Purchase_Item_Choice -ne "l"){
                if ($Import_JSON.Settlement.$Purchase_Item_Choice.Cost -gt $Gold) {
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("");" "*140
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
                    Write-Color "  $($Import_JSON.Settlement.$Purchase_Item_Choice.Description)"," costs ","$($Import_JSON.Settlement.$Purchase_Item_Choice.Cost) Gold"," but you only have ","$($Import_JSON.Character.Gold) Gold","." -Color Blue,DarkGray,DarkYellow,DarkGray,DarkYellow,DarkGray
                } else {
                    switch ($Purchase_Item_Choice) {
                        1 { # +2 Rations
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("");" "*140
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
                            Write-Color "  You purchase ","+2 Rations"," for ","2 Gold","." -Color DarkGray,Blue,DarkGray,DarkYellow,DarkGray
                            $Import_JSON.Character.Gold -= $Import_JSON.Settlement.$Purchase_Item_Choice.Cost
                            $Import_JSON.Character.Rations += 2
                            Update_Variables
                            Draw_Player_Window_and_Stats
                            Save_JSON
                        }
                        2 { # +2 Torches
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("");" "*140
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
                            Write-Color "  You purchase ","+2 Torches"," for ","2 Gold","." -Color DarkGray,Blue,DarkGray,DarkYellow,DarkGray
                            $Import_JSON.Character.Gold -= $Import_JSON.Settlement.$Purchase_Item_Choice.Cost
                            $Import_JSON.Character.Torches += 2
                            Update_Variables
                            Draw_Player_Window_and_Stats
                            Save_JSON
                        }
                        3 { # Restore 1 HP
                            if ($Import_JSON.Character.Stats.HealthCurrent -eq $Import_JSON.Character.Stats.HealthMax) {
                                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("");" "*140
                                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
                                Write-Color "  Your Health is already full at ","$($Import_JSON.Character.Stats.HealthCurrent) ","of ","$($Import_JSON.Character.Stats.HealthMax) ","HP",". You don't need to buy this item right now." -Color DarkGray,White,DarkGray,White,DarkGray
                            } else {
                                $Import_JSON.Character.Stats.HealthCurrent += 1
                                $Import_JSON.Character.Gold -= $Import_JSON.Settlement.$Purchase_Item_Choice.Cost
                                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("");" "*140
                                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
                                Write-Color "  Your Health has incresed by +1 and is now ","$($Import_JSON.Character.Stats.HealthCurrent) / $($Import_JSON.Character.Stats.HealthMax) HP","." -Color Blue,DarkGray,DarkYellow,DarkGray
                                Update_Variables
                                Draw_Player_Window_and_Stats
                                Save_JSON
                            }
                        }
                        4 { # +1 Potion
                            $Potion_Purchased = $false
                            do {
                                if ($Potion_purchased -eq $false) {
                                    Clear_Bottom_Half_of_Screen
                                    $Info_Banner = "Shop - Potions"
                                    Draw_Info_Banner
                                    Write-Color ""
                                    Write-Color "  Settlement Shop Potions" -Color DarkGray
                                    Write-Color ""
                                    $All_Settlement_Potions_Array = New-Object System.Collections.Generic.List[System.Object]
                                    foreach ($item in $Import_JSON.Potions.PSObject.Properties) {
                                        $All_Settlement_Potions_Array.Add($item.Name)
                                        Write-Color "  $($item.Name)"," - ","$($item.Value.Name)"," ($($item.Value.Info))" -Color White,DarkGray,Blue,DarkGray
                                    }
                                }
                                do {
                                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("");" "*140
                                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
                                    Write-Color "  Each Potion costs ", "6 Gold","." -Color DarkGray,DarkYellow,DarkGray
                                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
                                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
                                    Write-Color -NoNewLine "  Select the ","item number ","you would like to purchase, or ","L","eave." -Color DarkYellow,White,DarkYellow,Green,DarkYellow
                                    $Potion_Purchase_Choice = Read-Host " "
                                } until ($Potion_Purchase_Choice -ieq "l" -or $Potion_Purchase_Choice -in $All_Settlement_Potions_Array)
                                if ($Potion_Purchase_Choice -ine "l"){
                                    $Potion_Purchased = $true
                                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,35;$Host.UI.Write("");" "*140
                                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("");" "*140
                                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,35;$Host.UI.Write("")
                                    switch ($Potion_Purchase_Choice) {
                                        1 { # Healing (1d6)
                                            Write-Color "  You have purchased a ","$($Import_JSON.Potions.$Potion_Purchase_Choice.Name)"," Potion"," for ","6 Gold","." -Color DarkGray,White,Blue,DarkGray,DarkYellow,DarkGray
                                            Write-Color "  This ","Potion ","can be used at any time to restore your ","Health ","by ","3 HP","." -Color DarkGray,Blue,DarkGray,Green,DarkGray,Green,DarkGray
                                        }
                                        2 { # Invisibility (Sneak past location)
                                            Write-Color "  You have purchased an ","$($Import_JSON.Potions.$Potion_Purchase_Choice.Name)"," Potion"," for ","6 Gold","." -Color DarkGray,White,Blue,DarkGray,DarkYellow,DarkGray
                                            Write-Color "  This ","Potion ","can be used to sneak past a hazard or enemy without having to pass the challenge." -Color DarkGray,Blue,DarkGray
                                        }
                                        3 { # Accelerate -3 or +3 journeys or dungeons
                                            Write-Color "  *** TODO -3 or +3 journeys or dungeons??????????????????????" -Color Magenta
                                            Write-Color "  -3 or +3 journeys or dungeons. Add 3 extra journeys or dungeons to your next adventure." -Color Magenta
                                        }
                                        4 { # Strength (+2 STR or +2 ATK against next test or monster)
                                            Write-Color "  *** TODO -3 or +3 journeys or dungeons??????????????????????" -Color Magenta
                                            Write-Color "  +2 STR or +2 ATK against next test or monster. +2, or give you +2 ATK against the next monster you fight or test you take." -Color Magenta
                                        }
                                        5 { # Invincibility (auto pass a test)
                                            Write-Color "  You have purchased an ","Invincibility ","Potion ","which will allow you to automatically pass a test." -Color DarkGray,White,Blue,DarkGray
                                            Write-Color "  This ","Potion ","can be used when a test is encountered." -Color DarkGray,Blue,DarkGray
                                        }
                                        6 { # Rock Skin (+2 DEF for next fight)
                                            Write-Color "  You have purchased a ","Rock Skin ","Potion ","which gives you ","+2 DEF ","for the next fight." -Color DarkGray,White,Blue,DarkGray,White,DarkGray
                                        }
                                        Default {
                                        }
                                    }
                                    # reduce gold by 6, add potion to inventory, add 1 to potions total
                                    $Import_JSON.Character.Gold -= 6
                                    $Import_JSON.Character.PotionsTotal += 1
                                    $Import_JSON.Potions.$Potion_Purchase_Choice.Quantity += 1
                                    Update_Variables
                                    Draw_Player_Window_and_Stats
                                    Save_JSON
                                }
                            } until ($Potion_Purchase_Choice -ieq "l" -or $Gold -lt 6)
                        }
                        5 { # spells
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("");" "*140
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
                            Write-Color "  Spells cost ","15 Gold",", so you can't afford to buy any from the shop just yet." -Color DarkGray,DarkYellow,DarkGray
                        }
                        6 { # Training (+5 XP)
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("");" "*140
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
                            Write-Color "  Training costs ","25 Gold",", so you can't afford to buy it from the shop just yet." -Color DarkGray,DarkYellow,DarkGray
                        }
                        7 { # Reurrection (return to life at the Settelement when at zero HP)
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("");" "*140
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
                            Write-Color "  Reurrection costs ","30 Gold",", so you can't afford to buy it from the shop just yet." -Color DarkGray,DarkYellow,DarkGray
                        }
                        Default {}
                    }
                    Save_JSON
                    Update_Variables
                }
                if ($Gold -lt 2) {
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,37;$Host.UI.Write("");" "*140
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,37;$Host.UI.Write("")
                    Write-Color -NoNewLine "  You have ","$Gold Gold ","so youu are unable to purchase anything else." -Color DarkYellow,White,DarkYellow
                }
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
                Write-Color -NoNewLine "  Press Enter to continue..." -Color DarkYellow
                $Host.UI.ReadLine() | Out-Null
            }
        }
    } until ($Import_JSON.Character.Gold -lt 2 -or $Purchase_Item_Choice -ieq "l");
    #
    # Obtain Quest
    #
    Clear_Bottom_Half_of_Screen
    $Info_Banner = "Quests"
    Draw_Info_Banner
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,20;$Host.UI.Write("")
    Write-Color "  Before you can head out on your Adventure, you need a ","Quest","." -Color DarkGray,White
    Press_Continue
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,22;$Host.UI.Write("")
    Write-Color "  Quests ","will earn you some ","XP ","and ","Gold","." -Color White,DarkGray,White,DarkGray,DarkYellow,DarkGray
    Press_Continue
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,24;$Host.UI.Write("")
    Write-Color "  You must return back to the ","Settlement"," to gain the rewards, you don't gain them during your Adventure." -Color DarkGray,White,DarkGray
    Press_Continue
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,26;$Host.UI.Write("")
    Write-Color "  Only one quest can be embarked on at once." -Color DarkGray
    Press_Continue
    Clear_Bottom_Half_of_Screen
    $Info_Banner = "Quests"
    Draw_Info_Banner
    # Draw_Potion_Spells_Shop_Table -Value "Quests"

    Draw_Quests_Table -Value "Quests"

    # foreach ($item in $Import_JSON.Quests.PSObject.Properties) {
    #     $All_Settlement_Items_Array.Add("$($item.Name)")
    #     Write-Color "  $($item.Name) ","- ","$($item.Value.Name) ","- ","($($item.Value.Short_Objective)) ","(","$($item.Value.Gold_Reward) Gold ","& ","$($item.Value.XP_Reward) XP",")" -Color White,DarkGray,Blue,DarkGray,Blue,DarkGray,DarkYellow,DarkGray,White,DarkGray
    # }
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
    Write-Color -NoNewLine "  Now roll a D6 to determine which ","Quest ","you will embark on. Press Enter to continue..." -Color DarkYellow,White,DarkYellow
    $Host.UI.ReadLine() | Out-Null
    Roll_D6_Dice
    # $Random_Dice_Roll = 1
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,35;$Host.UI.Write("");" "*140
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("");" "*140
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,35;$Host.UI.Write("")
    Write-Color "  You rolled a ","$Random_Dice_Roll", " and obtain the ","$($Import_JSON.Quests.$Random_Dice_Roll.Name) ","Quest","." -Color DarkGray,White,DarkGray,Blue,White,DarkGray
    Write-Color "  Your objective is to ","$($Import_JSON.Quests.$Random_Dice_Roll.Long_Objective)","." -Color DarkGray,White,DarkGray
    $Import_JSON.Quests.$Random_Dice_Roll.Active = $true
    $Import_JSON.Character.Quest = $Import_JSON.Quests.$Random_Dice_Roll.Name
    Update_Variables
    Draw_Player_Window_and_Stats
    Save_JSON
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
    Write-Color -NoNewLine "  Press Enter to continue..." -Color DarkYellow
    $Host.UI.ReadLine() | Out-Null
    #
    # roll for journeys and wilderness encounters
    #
    Clear_Bottom_Half_of_Screen
    $Info_Banner = "Wilderness Journeys"
    Draw_Info_Banner
    Write-Color ""
    Write-Color "  You're now finally ready to embark on your Adventure." -Color DarkGray
    Press_Continue
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,22;$Host.UI.Write("")
    Write-Color "  The first steps you take will be into the ","Wilderness ", "before you reach a ","Dungeon","." -Color DarkGray,White,DarkGray,White,DarkGray
    Press_Continue
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,24;$Host.UI.Write("")
    Write-Color "  Most ","Wilderness Journeys ","require a ","STAT ","test to be completed." -Color DarkGray,White,DarkGray,White,DarkGray
    Write-Color "  You must roll higher than the value of that ","STAT ","test to ","Pass." -Color DarkGray,White,DarkGray,Green
    Write-Color "  You will receive a reward if you ","Pass ","a test, and a penalty if you ","Fail","." -Color DarkGray,Green,DarkGray,Red
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,27;$Host.UI.Write("")
    Draw_Wilderness_Journeys_Table -Value "Wilderness_Journeys"

    # $All_Wilderness_Journeys_Array = New-Object System.Collections.Generic.List[System.Object]
    # foreach ($item in $Import_JSON.Wilderness_Journeys.PSObject.Properties) {
    #     $All_Wilderness_Journeys_Array.Add("$($item.Name)")
    #     $Fail_Properties = $($item.Value.Reward.Fail.PSObject.Properties)
    #     $Pass_Properties = $($item.Value.Reward.Pass.PSObject.Properties)
    #     Write-Color "  $($item.Name) ","- ","$($item.Value.Name) (Test $($item.Value.Test_Type) $($item.Value.Test_Difficulty)) (Fail -$($Fail_Properties.Name) $($Fail_Properties.Value)) (Pass +$($Pass_Properties.Name) $($Pass_Properties.Value))" -Color White,DarkGray,Blue
    # }


    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
    Write-Color -NoNewLine "  Roll a D6 to determine how many ","Wilderness Journeys ","you will encounter. Press Enter to continue..." -Color DarkYellow,White,DarkYellow
    $Host.UI.ReadLine() | Out-Null
    Clear_Bottom_Half_of_Screen
    $Info_Banner = "Wilderness Journeys"
    Draw_Info_Banner
    # Write-Color ""
    # Draw_Potion_Spells_Shop_Table -Value "Wilderness_Journeys"
    # foreach ($item in $Import_JSON.Wilderness_Journeys.PSObject.Properties) {
    #     $All_Wilderness_Journeys_Array.Add("$($item.Name)")
    #     $Fail_Properties = $($item.Value.Reward.Fail.PSObject.Properties)
    #     $Pass_Properties = $($item.Value.Reward.Pass.PSObject.Properties)
    #     Write-Color "  $($item.Name) ","- ","$($item.Value.Name) (Test $($item.Value.Test_Type) $($item.Value.Test_Difficulty)) (Fail -$($Fail_Properties.Name) $($Fail_Properties.Value)) (Pass +$($Pass_Properties.Name) $($Pass_Properties.Value))" -Color White,DarkGray,Blue
    # }
    # Write-Color ""
    Draw_Wilderness_Journeys_Table -Value "Wilderness_Journeys"
    Write-Color "   d6 roll ","|"," Journeys" -Color DarkGray,White,DarkGray
    Write-Color "  ---------+------------" -Color White
    Write-Color "     1-2   ","|"," 1 Journey" -Color DarkGray,White,DarkGray
    Write-Color "     3-4   ","|"," 2 Journeys" -Color DarkGray,White,DarkGray
    Write-Color "     5-6   ","|"," 3 Journeys" -Color DarkGray,White,DarkGray
    Roll_D6_Dice
    # $Random_Dice_Roll = 5
    if ($Random_Dice_Roll -eq 1 -or $Random_Dice_Roll -eq 2) { $Wilderness_Journeys_Total = 1 }
    if ($Random_Dice_Roll -eq 3 -or $Random_Dice_Roll -eq 4) { $Wilderness_Journeys_Total = 2 }
    if ($Random_Dice_Roll -eq 5 -or $Random_Dice_Roll -eq 6) { $Wilderness_Journeys_Total = 3 }
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,35;$Host.UI.Write("")
    Write-Color "  You rolled a ","$Random_Dice_Roll","." -Color DarkGray,White,DarkGray
    if ($Random_Dice_Roll -lt 2) {
        $Journeys_Word = "Journey"
    } else {
        $Journeys_Word = "Journeys"
    }
    Write-Color "  You will encounter ","$Wilderness_Journeys_Total Wilderness $Journeys_Word ", "on your way to the Dungeon." -Color DarkGray,White,DarkGray
    $Import_JSON.Character.Wilderness_Journeys_Total = $Wilderness_Journeys_Total
    $Import_JSON.Character.Wilderness_Journeys_Current_Number = 0
    Update_Variables
    Draw_Player_Window_and_Stats
    Save_JSON
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
    Write-Color -NoNewLine "  Roll a d6 to find out which ","Wilderness Journey ","you will encounter. Press Enter to continue..." -Color DarkYellow,White,DarkYellow
    $Host.UI.ReadLine() | Out-Null
    Clear_Bottom_Half_of_Screen
    $Info_Banner = "Wilderness Journeys"
    Draw_Info_Banner
    Write-Color ""
    # Adventurer creation complete
    $Import_JSON.Character_Creation = $true
    Save_JSON
    Import_JSON
    Update_Variables
}



#
# draw potions, spells and shop table info
#
# potions and spells  = name, description
# settlement / shop   = name, gold cost
function Draw_Potion_Spells_Shop_Table {
    param ([string]$Value)
    if ($Value -ieq "potions" -or $Value -ieq "spells") {
        $Name_or_Description = "Name"
        $Info_or_Cost        = "Info"
    } elseif ($Value -ieq "settlement") {
        $Name_or_Description = "Description"
        $Info_or_Cost        = "Cost"
    }
    $Script:All_Settlement_Items_Array     = New-Object System.Collections.Generic.List[System.Object]
    $Table_Items_Name_or_Description_Array = New-Object System.Collections.Generic.List[System.Object]
    $Table_Items_Info_or_Cost_Array        = New-Object System.Collections.Generic.List[System.Object]
    $Script:Table_Item_Numbers             = $Import_JSON.$Value.PSObject.Properties.Name | Sort-Object # .Name gets the property
    foreach ($Table_Item_Number in $Table_Item_Numbers) {
        $All_Settlement_Items_Array.Add("$($Table_Item_Number)")
        $Table_Items_Name_or_Description_Array.Add(($Import_JSON.$Value.$Table_Item_Number.$Name_or_Description | Measure-Object -Character).Characters)
        $Table_Items_Info_or_Cost_Array.Add(($Import_JSON.$Value.$Table_Item_Number.$Info_or_Cost | Measure-Object -Character).Characters)
    }
    $Table_Items_Name_or_Description_Array_Max_Length        = ($Table_Items_Name_or_Description_Array | Measure-Object -Maximum).Maximum
    $Table_Box_Name_or_Description_Width_Top_Bottom          = "-"*($Table_Items_Name_or_Description_Array_Max_Length + 2)
    $Table_Box_Name_or_Description_Width_Padding             = " "*($Table_Items_Name_or_Description_Array_Max_Length - 3)
    $Table_Items_Info_or_Cost_Array_Max_Length = ($Table_Items_Info_or_Cost_Array | Measure-Object -Maximum).Maximum
    if ($Table_Items_Info_or_Cost_Array_Max_Length - $Info_or_Cost.Length + 1 -lt 0) {
        $Table_Box_Item_or_Cost_Width_Padding = " "
        $Table_Box_Info_or_Cost_Width_Top_Bottom     = "------"
    } else {
        $Table_Box_Info_or_Cost_Width_Top_Bottom     = "-"*($Table_Items_Info_or_Cost_Array_Max_Length + 2)
        $Table_Box_Item_or_Cost_Width_Padding = " "*($Table_Items_Info_or_Cost_Array_Max_Length - $Info_or_Cost.Length + 1)
    }
    Write-Color "  +----+$Table_Box_Name_or_Description_Width_Top_Bottom+$Table_Box_Info_or_Cost_Width_Top_Bottom+" -Color DarkGray
    Write-Color "  |"," D6 ","| ","Name$Table_Box_Name_or_Description_Width_Padding","|"," $Info_or_Cost$Table_Box_Item_or_Cost_Width_Padding","|" -Color DarkGray,White,DarkGray,White,DarkGray,White,DarkGray
    Write-Color "  +----+$Table_Box_Name_or_Description_Width_Top_Bottom+$Table_Box_Info_or_Cost_Width_Top_Bottom+" -Color DarkGray
    foreach ($Table_Item_Number in $Table_Item_Numbers) {
        if ($Import_JSON.$Value.$Table_Item_Number.$Name_or_Description.Length -le 9) {
            if ($Table_Items_Name_or_Description_Array_Max_Length -ge 9) {
                $Name_or_Description_Right_Padding = " "*($Table_Items_Name_or_Description_Array_Max_Length - $Import_JSON.$Value.$Table_Item_Number.$Name_or_Description.Length)
            } else {
                $Name_or_Description_Right_Padding = " "*(9 - $Import_JSON.$Value.$Table_Item_Number.$Name_or_Description.Length)
            }
        } elseif ($Import_JSON.$Value.$Table_Item_Number.$Name_or_Description.Length -gt 9 -and $Import_JSON.$Value.$Table_Item_Number.$Name_or_Description.Length -le $Table_Items_Name_or_Description_Array_Max_Length) {
            $Name_or_Description_Right_Padding = " "*($Table_Items_Name_or_Description_Array_Max_Length - $Import_JSON.$Value.$Table_Item_Number.$Name_or_Description.Length)
        }
        if ($Import_JSON.$Value.$Table_Item_Number.$Info_or_Cost.Length -le $Table_Items_Info_or_Cost_Array_Max_Length) {
            $Info_or_Cost_Right_Padding = " "*($Table_Items_Info_or_Cost_Array_Max_Length - $Import_JSON.$Value.$Table_Item_Number.$Info_or_Cost.Length)
            if ($Table_Items_Info_or_Cost_Array_Max_Length -le $Info_or_Cost.Length) {
                if (($Import_JSON.$Value.$Table_Item_Number.$Info_or_Cost | Measure-Object -Character).Characters -eq 1) {
                    $Info_or_Cost_Right_Padding = "   "
                } else {
                    $Info_or_Cost_Right_Padding = "  "
                }
            }
        } else {
            $Info_or_Cost_Right_Padding = ""
        }
        Write-Color "  |  $Table_Item_Number | ","$($Import_JSON.$Value.$Table_Item_Number.$Name_or_Description)$Name_or_Description_Right_Padding ","| $($Import_JSON.$Value.$Table_Item_Number.$Info_or_Cost)$Info_or_Cost_Right_Padding |" -Color DarkGray,DarkGray,DarkGray,White,DarkGray,White,DarkGray,White,DarkGray
    }
    Write-Color "  +----+$Table_Box_Name_or_Description_Width_Top_Bottom+$Table_Box_Info_or_Cost_Width_Top_Bottom+" -Color DarkGray
}



#
# draw potions, spells and shop table info
#
# quests table = name - Objective - Reward (gold + XP)
function Draw_Quests_Table {
    param ([string]$Value)
    $Table_Items_Name_Array        = New-Object System.Collections.Generic.List[System.Object]
    $Table_Items_Objective_Array   = New-Object System.Collections.Generic.List[System.Object]
    $Table_Items_Reward_Gold_Array = New-Object System.Collections.Generic.List[System.Object]
    $Table_Items_Reward_XP_Array   = New-Object System.Collections.Generic.List[System.Object]
    $Script:Table_Item_Numbers     = $Import_JSON.$Value.PSObject.Properties.Name | Sort-Object # .Name gets the property
    foreach ($Table_Item_Number in $Table_Item_Numbers) {
        $Table_Items_Name_Array.Add(($Import_JSON.$Value.$Table_Item_Number.Name | Measure-Object -Character).Characters)
        $Table_Items_Objective_Array.Add(($Import_JSON.$Value.$Table_Item_Number.Short_Objective | Measure-Object -Character).Characters)
        $Table_Items_Reward_Gold_Array.Add(($Import_JSON.$Value.$Table_Item_Number.Gold_Reward | Measure-Object -Character).Characters)
        $Table_Items_Reward_XP_Array.Add(($Import_JSON.$Value.$Table_Item_Number.XP_Reward | Measure-Object -Character).Characters)
    }
    $Table_Items_Name_Array_Max_Length         = ($Table_Items_Name_Array | Measure-Object -Maximum).Maximum
    $Table_Items_Objective_Array_Max_Length    = ($Table_Items_Objective_Array | Measure-Object -Maximum).Maximum
    $Table_Items_Reward_Gold_Array_Max_Length  = ($Table_Items_Reward_Gold_Array | Measure-Object -Maximum).Maximum
    $Table_Items_Reward_XP_Array_Max_Length    = ($Table_Items_Reward_XP_Array | Measure-Object -Maximum).Maximum
    $Table_Box_Name_Width_Top_Bottom           = "-"*($Table_Items_Name_Array_Max_Length + 2)
    $Table_Box_Name_Width_Padding              = " "*($Table_Items_Name_Array_Max_Length - 3)
    $Table_Box_Objective_Width_Top_Bottom      = "-"*($Table_Items_Objective_Array_Max_Length + 2)
    $Table_Box_Objective_Width_Padding         = " "*($Table_Items_Objective_Array_Max_Length - 8)
    $Table_Box_Reward_Gold_XP_Width_Top_Bottom = "-"*($Table_Items_Reward_XP_Array_Max_Length + $Table_Items_Reward_Gold_Array_Max_Length + 12)
    $Table_Box_Reward_Gold_Width_Padding       = " "*("Reward".Length - $Table_Items_Reward_Gold_Array_Max_Length)
    $Table_Box_Reward_XP_Width_Padding         = " "*("Reward".Length - $Table_Items_Reward_XP_Array_Max_Length)
    Write-Color "  +----+$Table_Box_Name_Width_Top_Bottom+$Table_Box_Objective_Width_Top_Bottom+$Table_Box_Reward_Gold_XP_Width_Top_Bottom+" -Color DarkGray
    Write-Color "  |"," D6 ","| ","Name$Table_Box_Name_Width_Padding","|"," Objective$Table_Box_Objective_Width_Padding","|"," Reward $Table_Box_Reward_Gold_Width_Padding$Table_Box_Reward_XP_Width_Padding","|" -Color DarkGray,White,DarkGray,White,DarkGray,White,DarkGray,White,DarkGray
    Write-Color "  +----+$Table_Box_Name_Width_Top_Bottom+$Table_Box_Objective_Width_Top_Bottom+$Table_Box_Reward_Gold_XP_Width_Top_Bottom+" -Color DarkGray
    foreach ($Table_Item_Number in $Table_Item_Numbers) {
        $Name_Right_Padding = " "*($Table_Items_Name_Array_Max_Length - $Import_JSON.$Value.$Table_Item_Number.Name.Length)
        if (($Table_Items_Objective_Array_Max_Length - $Import_JSON.$Value.$Table_Item_Number.Short_Objective.Length + 1) -le 0) {
            $Objective_Right_Padding = " "
        } else {
            $Objective_Right_Padding = " "*($Table_Items_Objective_Array_Max_Length - $Import_JSON.$Value.$Table_Item_Number.Short_Objective.Length)
        }
        $Reward_Gold_Right_Padding = " "*($Table_Items_Reward_Gold_Array_Max_Length - ($Import_JSON.$Value.$Table_Item_Number.Gold_Reward | Measure-Object -Character).Characters + 1)
        Write-Color "  |  ","$Table_Item_Number"," | ","$($Import_JSON.$Value.$Table_Item_Number.Name)$Name_Right_Padding ","| $($Import_JSON.$Value.$Table_Item_Number.Short_Objective)$Objective_Right_Padding | ","$($Import_JSON.$Value.$Table_Item_Number.Gold_Reward)$Reward_Gold_Right_Padding`Gold ","+ ","$($Import_JSON.$Value.$Table_Item_Number.XP_Reward)$Reward_XP_Right_Padding`XP ","|" -Color DarkGray,White,DarkGray,Blue,DarkGray,DarkYellow,DarkGray,Cyan,DarkGray
        # Start-Sleep -Seconds 3
    }
    Write-Color "  +----+$Table_Box_Name_Width_Top_Bottom+$Table_Box_Objective_Width_Top_Bottom+$Table_Box_Reward_Gold_XP_Width_Top_Bottom$Table_Box_Reward_XP_Width_Top_Bottom$Buffer+" -Color DarkGray
}


#
# draw potions, spells and shop table info
#
# wilderness journeys = name - test (type + difficulty) - reward (pass + fail)
function Draw_Wilderness_Journeys_Table {
    param ([string]$Value)
    $Table_Items_Name_Array            = New-Object System.Collections.Generic.List[System.Object]
    $Table_Items_Test_Type_Array       = New-Object System.Collections.Generic.List[System.Object]
    $Table_Items_Test_Difficulty_Array = New-Object System.Collections.Generic.List[System.Object]
    $Table_Items_Reward_Pass_Array     = New-Object System.Collections.Generic.List[System.Object]
    $Table_Items_Reward_Fail_Array     = New-Object System.Collections.Generic.List[System.Object]
    $Script:Table_Item_Numbers         = $Import_JSON.$Value.PSObject.Properties.Name | Sort-Object # .Name gets the property
    foreach ($Table_Item_Number in $Table_Item_Numbers) {
        $Table_Items_Name_Array.Add(($Import_JSON.$Value.$Table_Item_Number.Name | Measure-Object -Character).Characters)
        $Table_Items_Test_Type_Array.Add(($Import_JSON.$Value.$Table_Item_Number.Test_Type | Measure-Object -Character).Characters)
        $Table_Items_Test_Difficulty_Array.Add(($Import_JSON.$Value.$Table_Item_Number.Test_Difficulty | Measure-Object -Character).Characters)
        if ($Table_Item_Number -eq "4") { # this wilderness journey has two rewards for passing the test so they have to be added separately
            foreach ($Pass_Name in $Import_JSON.$Value.$Table_Item_Number.Reward.Pass.PSObject.Properties.Name) {
                $Table_Items_Reward_Pass_Array.Add(($Pass_Name | Measure-Object -Character).Characters)
            }
        }
        $Table_Items_Reward_Fail_Array.Add(($Import_JSON.$Value.$Table_Item_Number.Reward.Fail.PSObject.Properties.Name | Measure-Object -Character).Characters)
    }
    $Table_Items_Name_Array_Max_Length            = ($Table_Items_Name_Array | Measure-Object -Maximum).Maximum
    $Table_Items_Test_Type_Array_Max_Length       = ($Table_Items_Test_Type_Array | Measure-Object -Maximum).Maximum
    $Table_Items_Test_Difficulty_Array_Max_Length = ($Table_Items_Test_Difficulty_Array | Measure-Object -Maximum).Maximum
    $Table_Items_Reward_Pass_Array_Max_Length     = ($Table_Items_Reward_Pass_Array | Measure-Object -Maximum).Maximum
    $Table_Items_Reward_Fail_Array_Max_Length     = ($Table_Items_Reward_Fail_Array | Measure-Object -Maximum).Maximum

    $Table_Box_Name_Width_Top_Bottom              = "-"*($Table_Items_Name_Array_Max_Length + 2)
    $Table_Box_Name_Width_Padding                 = " "*($Table_Items_Name_Array_Max_Length - 3)

    $Table_Box_Test_Type_Width_Top_Bottom         = "-"*($Table_Items_Test_Type_Array_Max_Length + 3)
    $Table_Box_Test_Type_Width_Padding            = " "*(("Test" | Measure-Object -Character).Characters - $Table_Items_Test_Type_Array_Max_Length)

    $Table_Box_Test_Difficulty_Width_Top_Bottom   = "-"*($Table_Items_Test_Difficulty_Array_Max_Length)
    $Table_Box_Test_Difficulty_Width_Padding      = " "

    $Table_Box_Reward_Pass_Width_Top_Bottom       = "-"*($Table_Items_Reward_Pass_Array_Max_Length)
    $Table_Box_Reward_Penalty_Width_Padding       = " "*(($Table_Items_Reward_Pass_Array_Max_Length + $Table_Items_Reward_Fail_Array_Max_Length + 8) - "Reward / Penalty".Length)
    $Table_Box_Reward_Fail_Width_Top_Bottom       = "-"*($Table_Items_Reward_Fail_Array_Max_Length + 9)

    Write-Color "  +----+$Table_Box_Name_Width_Top_Bottom+$Table_Box_Test_Type_Width_Top_Bottom$Table_Box_Test_Difficulty_Width_Top_Bottom+$Table_Box_Reward_Pass_Width_Top_Bottom$Table_Box_Reward_Fail_Width_Top_Bottom+" -Color DarkGray
    Write-Color "  |"," D6 ","| ","Name$Table_Box_Name_Width_Padding","|"," Test$Table_Box_Test_Type_Width_Padding$Table_Box_Test_Difficulty_Width_Padding","|"," Reward / Penalty$Table_Box_Reward_Penalty_Width_Padding","|" -Color DarkGray,White,DarkGray,White,DarkGray,White,DarkGray,White,DarkGray
    Write-Color "  +----+$Table_Box_Name_Width_Top_Bottom+$Table_Box_Test_Type_Width_Top_Bottom$Table_Box_Test_Difficulty_Width_Top_Bottom+$Table_Box_Reward_Pass_Width_Top_Bottom$Table_Box_Reward_Fail_Width_Top_Bottom+" -Color DarkGray
    foreach ($Table_Item_Number in $Table_Item_Numbers) {
        $Name_Right_Padding = " "*($Table_Items_Name_Array_Max_Length - $Import_JSON.$Value.$Table_Item_Number.Name.Length)
        $Test_Type_Right_Padding = " "*($Table_Items_Test_Type_Array_Max_Length - $Import_JSON.$Value.$Table_Item_Number.Test_Type.Length + 1)
        $Reward_Right_Padding = " "*($Table_Items_Reward_Pass_Array_Max_Length - ($Import_JSON.$Value.$Table_Item_Number.Reward.Pass.PSObject.Properties.Name).Length)
        $Penalty_Right_Padding = " "*($Table_Items_Reward_Fail_Array_Max_Length - ($Import_JSON.$Value.$Table_Item_Number.Reward.Fail.PSObject.Properties.Name).Length)
        if ($Import_JSON.$Value.$Table_Item_Number.Name -ieq "Plains") { # no reward or penalty for plains (no output)
            Write-Color "  |  ","$Table_Item_Number"," | ","$($Import_JSON.$Value.$Table_Item_Number.Name)$Name_Right_Padding ","| $($Import_JSON.$Value.$Table_Item_Number.Test_Type)$Test_Type_Right_Padding$($Import_JSON.$Value.$Table_Item_Number.Test_Difficulty) | No ","reward ","or ","penalty  ","|" -Color DarkGray,White,DarkGray,Blue,DarkGray,Green,DarkGray,Red,DarkGray
        } elseif ($Import_JSON.$Value.$Table_Item_Number.Name -eq "Campsite") { # deals with two rewards
            $Reward_Right_Padding = " "*($Table_Items_Reward_Pass_Array_Max_Length - ($Import_JSON.$Value.$Table_Item_Number.Reward.Pass.PSObject.Properties.Name).Length)
            $Penalty_Right_Padding = " "*($Table_Items_Reward_Fail_Array_Max_Length - ($Import_JSON.$Value.$Table_Item_Number.Reward.Fail.PSObject.Properties.Name).Length)
            foreach ($item in $Import_JSON."wilderness_journeys"."4".Reward.Pass.PSObject.Properties.Name) {
                $Pass_Name_Array = New-Object System.Collections.Generic.List[System.Object]
                $Pass_Names = $Import_JSON.$Value.$Table_Item_Number.Reward.Pass.PSObject.Properties.Name
                foreach ($Pass_Name in $Pass_Names) {
                    $Pass_Name_Array.Add($Pass_Name)
                    $Pass_Name_Array.Add(" "*($Table_Items_Reward_Pass_Array_Max_Length - ($Pass_Name).Length + 1))
                }
                $Pass_Value_Array = New-Object System.Collections.Generic.List[System.Object]
                $Pass_Values = $Import_JSON.$Value.$Table_Item_Number.Reward.Pass.PSObject.Properties.Value
                foreach ($Pass_Value in $Pass_Values) {
                    $Pass_Value_Array.Add($Pass_Value)
                }
            }
            $Fail_Name  = $Import_JSON.$Value.$Table_Item_Number.Reward.Fail.PSObject.Properties.Name
            $Fail_Value = $Import_JSON.$Value.$Table_Item_Number.Reward.Fail.PSObject.Properties.Value
            Write-Color "  |  ","$Table_Item_Number"," | ","$($Import_JSON.$Value.$Table_Item_Number.Name)$Name_Right_Padding ","| $($Import_JSON.$Value.$Table_Item_Number.Test_Type)$Test_Type_Right_Padding$($Import_JSON.$Value.$Table_Item_Number.Test_Difficulty) | ","$($Pass_Value_Array[0]) $($Pass_Name_Array[0])$($Pass_Name_Array[1])","+ ","$Fail_Value $Fail_Name $Penalty_Right_Padding","|" -Color DarkGray,White,DarkGray,Blue,DarkGray,Green,DarkGray,Red,DarkGray
            Write-Color "  |  ","$Table_Item_Number"," |          | or... | ","$($Pass_Value_Array[1]) $($Pass_Name_Array[2])$($Pass_Name_Array[3])","+ ","$Fail_Value $Fail_Name $Penalty_Right_Padding","|" -Color DarkGray,White,DarkGray,Green,DarkGray,Red,DarkGray
        } else { # any other reward or penalty (all single rewards or penalties)
            $Pass_Name  = $Import_JSON.$Value.$Table_Item_Number.Reward.Pass.PSObject.Properties.Name
            $Pass_Value = $Import_JSON.$Value.$Table_Item_Number.Reward.Pass.PSObject.Properties.Value
            $Fail_Name  = $Import_JSON.$Value.$Table_Item_Number.Reward.Fail.PSObject.Properties.Name
            $Fail_Value = $Import_JSON.$Value.$Table_Item_Number.Reward.Fail.PSObject.Properties.Value
            Write-Color "  |  ","$Table_Item_Number"," | ","$($Import_JSON.$Value.$Table_Item_Number.Name)$Name_Right_Padding ","| $($Import_JSON.$Value.$Table_Item_Number.Test_Type)$Test_Type_Right_Padding$($Import_JSON.$Value.$Table_Item_Number.Test_Difficulty) | ","$Pass_Value $Pass_Name $Reward_Right_Padding","+ ","$Fail_Value $Fail_Name $Penalty_Right_Padding","|" -Color DarkGray,White,DarkGray,Blue,DarkGray,Green,DarkGray,Red,DarkGray
        }
    }
    Write-Color "  +----+$Table_Box_Name_Width_Top_Bottom+$Table_Box_Test_Type_Width_Top_Bottom$Table_Box_Test_Difficulty_Width_Top_Bottom+$Table_Box_Reward_Pass_Width_Top_Bottom$Table_Box_Reward_Fail_Width_Top_Bottom+" -Color DarkGray
}



#
# sets variables
#
Function Update_Variables {
    $Script:Character_Name                              = $Import_JSON.Character.Name
    $Script:Character_HealthCurrent                     = $Import_JSON.Character.Stats.HealthCurrent
    $Script:Character_HealthMax                         = $Import_JSON.Character.Stats.HealthMax
    $Script:Character_STR                               = $Import_JSON.Character.Stats.STR
    $Script:Character_DEX                               = $Import_JSON.Character.Stats.DEX
    $Script:Character_INT                               = $Import_JSON.Character.Stats.INT
    $Script:Rations                                     = $Import_JSON.Character.Rations
    $Script:Torches                                     = $Import_JSON.Character.Torches
    $Script:SpellsTotal                                 = $Import_JSON.Character.SpellsTotal
    $Script:PotionsTotal                                = $Import_JSON.Character.PotionsTotal
    $Script:Gold                                        = $Import_JSON.Character.Gold
    $Script:Total_XP                                    = $Import_JSON.Character.Total_XP
    $Script:Current_Location                            = $Import_JSON.Character.Current_Location
    $Script:Equipment                                   = $Import_JSON.Character.Equipment
    $Script:Weapon                                      = $Import_JSON.Character.Weapon
    $Script:Quest                                       = $Import_JSON.Character.Quest
    $Script:Wilderness_Journeys_Total                   = $Import_JSON.Character.Wilderness_Journeys_Total
    $Script:Wilderness_Journeys_Current_Number          = $Import_JSON.Character.Wilderness_Journeys_Current_Number
    $Script:Wilderness_Journeys_Current_Name            = $Import_JSON.Character.Wilderness_Journeys_Current_Name
    $Script:Wilderness_Journeys_History_Name_1          = $Import_JSON.Character.Wilderness_Journeys_History_Name_1
    $Script:Wilderness_Journeys_History_Name_2          = $Import_JSON.Character.Wilderness_Journeys_History_Name_2
    $Script:Wilderness_Journeys_History_Name_3          = $Import_JSON.Character.Wilderness_Journeys_History_Name_3
    $Script:Wilderness_Journeys_History_Name_4          = $Import_JSON.Character.Wilderness_Journeys_History_Name_4
    $Script:Wilderness_Journeys_History_Name_5          = $Import_JSON.Character.Wilderness_Journeys_History_Name_5
    $Script:Wilderness_Journeys_History_Name_Complete_1 = $Import_JSON.Character.Wilderness_Journeys_History_Name_Complete_1
    $Script:Wilderness_Journeys_History_Name_Complete_2 = $Import_JSON.Character.Wilderness_Journeys_History_Name_Complete_2
    $Script:Wilderness_Journeys_History_Name_Complete_3 = $Import_JSON.Character.Wilderness_Journeys_History_Name_Complete_3
    $Script:Wilderness_Journeys_History_Name_Complete_4 = $Import_JSON.Character.Wilderness_Journeys_History_Name_Complete_4
    $Script:Wilderness_Journeys_History_Name_Complete_5 = $Import_JSON.Character.Wilderness_Journeys_History_Name_Complete_5
    $Script:Dungeon_Room_Total                          = $Import_JSON.Character.Dungeon_Room_Total
    $Script:Dungeon_Room_Current                        = $Import_JSON.Character.Dungeon_Room_Current
    $Script:Potions_Total                               = $Import_JSON.Character.PotionsTotal
    $Script:Potions_Quantity_1                          = $Import_JSON.Potions.'1'.Quantity
    $Script:Potions_Quantity_2                          = $Import_JSON.Potions.'2'.Quantity
    $Script:Potions_Quantity_3                          = $Import_JSON.Potions.'3'.Quantity
    $Script:Potions_Quantity_4                          = $Import_JSON.Potions.'4'.Quantity
    $Script:Potions_Quantity_5                          = $Import_JSON.Potions.'5'.Quantity
    $Script:Potions_Quantity_6                          = $Import_JSON.Potions.'6'.Quantity
    $Script:Spells_Total                                = $Import_JSON.Character.SpellsTotal
    $Script:Spells_Quantity_1                           = $Import_JSON.Spells.'1'.Quantity
    $Script:Spells_Quantity_2                           = $Import_JSON.Spells.'2'.Quantity
    $Script:Spells_Quantity_3                           = $Import_JSON.Spells.'3'.Quantity
    $Script:Spells_Quantity_4                           = $Import_JSON.Spells.'4'.Quantity
    $Script:Spells_Quantity_5                           = $Import_JSON.Spells.'5'.Quantity
    $Script:Spells_Quantity_6                           = $Import_JSON.Spells.'6'.Quantity
}








#
# PLACE FUNCTIONS ABOVE HERE
#

Clear-Host
# Game_Introduction
#
# write any errors out to error.log file
#
Trap {
    $Time = Get-Date -Format "HH:mm:ss"
    Add-Content -Path .\error.log -Value "-Trap Error $Time ----------------------------------" # leave in
    Add-Content -Path .\error.log -Value "$PSItem" # leave in
    Add-Content -Path .\error.log -Value "------------------------------------------------------" # leave in
}


#
# Pre-requisite checks (install / import / update PSWriteColor module)
#
# if (-not(Test-Path -Path .\PS-BCDD.json)) {
#     # adjust window size
#     do {
#         Clear-Host
#         Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" -ForegroundColor DarkYellow
#         for ($index = 0; $index -lt 36; $index++) {
#             Write-Host "+                                                                                                                                                              +" -ForegroundColor DarkYellow
#         }
#         Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" -ForegroundColor DarkYellow
#         $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 20,10;$Host.UI.Write( "Using the CTRL + mouse scroll wheel forward and back,")
#         $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 20,11;$Host.UI.Write( "adjust the font size to make sure the yellow box fits within the screen.")
#         $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 2,36;$Host.UI.Write("")
#         Write-Host -NoNewline "Adjust font size with CTRL + mouse scroll wheel, then confirm with 'go' and Enter"
#         $Adjust_Font_Size = Read-Host " "
#         $Adjust_Font_Size = $Adjust_Font_Size.Trim()
#     } until ($Adjust_Font_Size -ieq "go")
#     Clear-Host
#     Write-Host "Pre-requisite checks" -ForegroundColor Red
#     Write-Host "--------------------" -ForegroundColor Red
#     Write-Output "`r`nChecking if PSWriteColor module is installed."
#     $PSWriteColor_Installed = Get-Module -Name "PSWriteColor" -ListAvailable
#     # PSWriteColor is installed so import it
#     if ($PSWriteColor_Installed) {
#         Write-Host "PSWriteColor module is installed." -ForegroundColor Green
#         $PSWriteColor_Installed
#         $PSWriteColor_Installed_Version = $PSWriteColor_Installed.Version
#         Write-Output "`r`nChecing if there is a new version of PSWriteColor."
#         # check for new module and update on prompt
#         $PSWriteColor_Online_Version = Find-Module -Name "PSWriteColor"
#         if ($PSWriteColor_Installed_Version -lt $PSWriteColor_Online_Version.Version) {
#             Write-Host "Version available: $($PSWriteColor_Online_Version.Version)" -ForegroundColor Green
#             Write-Host "Version installed: $($PSWriteColor_Installed_Version)"
#             do {
#                 Write-Host -NoNewline "`r`nDo you want to update to version $($PSWriteColor_Online_Version.Version)? [Y/N]"
#                 $Update_PSWriteColor_Choice = Read-Host " "
#                 $Update_PSWriteColor_Choice = $Update_PSWriteColor_Choice.Trim()
#             } until ($Update_PSWriteColor_Choice -ieq "y" -or $Update_PSWriteColor_Choice -ieq "n")
#             if ($Update_PSWriteColor_Choice -ieq "y") {
#                 Write-Output "Updating PSWriteColor module."
#                 Write-Output "Install path will be $ENV:USERPROFILE\Documents\WindowsPowerShell\Modules\"
#                 Write-Host "Uninstalling PSWriteColor module Version $PSWriteColor_Installed_Version"
#                 Uninstall-Module -Name "PSWriteColor" # no confirmation prompt
#                 Write-Host "Installing PSWriteColor module version $($PSWriteColor_Online_Version.Version)"
#                 Install-Module -Name "PSWriteColor" -Scope CurrentUser -Confirm:$false -Force
#                 $Install_PSWrite_Color_ExitCode = $?
#                 if ($Install_PSWrite_Color_ExitCode -eq $true) {
#                     $PSWriteColor_Installed = Get-Module -Name "PSWriteColor" -ListAvailable
#                     if ($PSWriteColor_Installed.Version -eq $PSWriteColor_Online_Version.Version) {
#                         $PSWriteColor_Installed = Get-Module -Name PSWriteColor -ListAvailable
#                         Write-Host "PSWriteColor module version $($PSWriteColor_Installed.Version) installed." -ForegroundColor Green
#                         $PSWriteColor_Installed | Format-Table
#                     } else {
#                         Write-Host "`r`nNo PSWriteColor module installed. Please re-run PS-BCDD.ps1" -ForegroundColor Red
#                         Exit
#                     }
#                 } else {
#                     Write-Host "PSWriteColor module version $($PSWriteColor_Online_Version.Version) FAILED to install. Please re-run PS-BCDD.ps1" -ForegroundColor Red
#                     Exit
#                 }
#             }
#             if ($Update_PSWriteColor_Choice -ieq "n") {
#                 Write-Output "Not updating PSWriteColor module."
#             }
#         } else {
#             Write-Output "`r`nPSWriteColor module is up-to-date."
#         }
#         Write-Output "`r`nImporting PSWriteColor module."
#         Import-Module -Name "PSWriteColor"
#         $PSWriteColor_Installed_Version = Get-Module -Name "PSWriteColor" -ListAvailable
#         if ($PSWriteColor_Installed_Version) {
#             Write-Host "PSWriteColor module version $($PSWriteColor_Installed_Version.Version) imported." -ForegroundColor Green
#         } else {
#             Write-Host "PSWriteColor module not imported." -ForegroundColor Red
#             Break
#         }
#         Start-Sleep -Seconds 3 # leave in
#     } else { # otherwise ask for module to be installed
#         Install_PSWriteColor
#     }
#     #
#     # game info
#     #
#     Write-Host -NoNewLine "`r`nPress any key to continue."
#     $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
#     Clear-Host
#     Write-Color "`r`nInfo" -Color Green
#     Write-Color "----" -Color Green
#     Write-Color "`r`nWelcome to ", "PS-BCDD", ", my 2nd RPG text adventure written in PowerShell." -Color DarkGray,Magenta,DarkGray
#     Write-Color "`r`nBusiness Card Dungeon Delve is a solo RPG that was designed by ","Melv Lee","." -Color DarkGray,Magenta,DarkGray
#     Write-Color "You can download the original PDF game from itch.io: https://melvinli.itch.io/business-card-dungeon-delve" -Color DarkGray,Magenta,DarkGray
#     Write-Color "`r`nAs previously mentioned, the PSWriteColor PowerShell module written by Przemyslaw Klys is required, which," -Color DarkGray
#     Write-Color "if you are seeing this message then it has installed and imported successfully." -Color DarkGray
#     Write-Color "`r`nAbsolutely ", "NO ", "info, personal or otherwise, is collected or sent anywhere or to anybody. " -Color DarkGray,Red,DarkGray
#     Write-Color "`r`nAll the ", "PS-BCDD ", "games files are stored your ", "$PSScriptRoot"," folder which is where you have run the game from." -Color DarkGray,Magenta,DarkGray,Cyan,DarkGray
#     Write-Color "`rThey include:" -Color DarkGray,Magenta,DarkGray,Cyan,DarkGray
#     Write-Color "The main PowerShell script            : ", "PS-BCDD.ps1" -Color DarkGray,Cyan
#     Write-Color "ASCII art for death messages          : ", "ASCII.txt" -Color DarkGray,Cyan
#     Write-Color "A JSON file that stores all game info : ", "PS-BCDD.json ", "(Locations, Mobs, NPCs and Adventurer Stats etc.)" -Color DarkGray,Cyan,DarkGray
#     Write-Color "`r`nPlayer input options appear in ","Green ", "e.g. ", "[Y/N/E/I] ", "would be ", "yes/no/exit/inventory", "." -Color DarkGray,Green,DarkGray,Green,DarkGray,Green,DarkGray
#     Write-Color "Enter the single Adventurer then hit `'Enter`' to confirm the choice." -Color DarkGray
#     Write-Color "`r`nWARNING - Quitting the game unexpectedly may cause lose of data." -Color Cyan
#     Write-Color "`r`nYou are now ready to play", " PS-BCDD", "." -Color DarkGray,Magenta,DarkGray
#     do {
#         do {
#             $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
#             Write-Color -NoNewLine "No save file found. Are you ready to start playing ", "PS-BCDD", "?"," [Y/N/E]" -Color DarkYellow,Magenta,DarkYellow,Green
#             $Ready_To_Play_PSRPG = Read-Host " "
#             $Ready_To_Play_PSRPG = $Ready_To_Play_PSRPG.Trim()
#         } until ($Ready_To_Play_PSRPG -ieq "y" -or $Ready_To_Play_PSRPG -ieq "n" -or $Ready_To_Play_PSRPG -ieq "e")
#         if ($Ready_To_Play_PSRPG -ieq "n" -or $Ready_To_Play_PSRPG -ieq "e") {
#             do {
#                 $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("");" "*105
#                 $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
#                 Write-Color -NoNewLine "Do you want to quit ", "PS-BCDD", "?"," [Y/N]" -Color DarkYellow,Magenta,DarkYellow,Green
#                 $Quit_Game = Read-Host " "
#                 $Quit_Game = $Quit_Game.Trim()
#             } until ($Quit_Game -ieq "y" -or $Quit_Game -ieq "n")
#             if ($Quit_Game -ieq "y") {
#                 Write-Color -NoNewLine "Exiting ","PS-BCDD","." -Color DarkYellow,Magenta,DarkYellow
#                 Exit
#             }
#         }
#     } until ($Ready_To_Play_PSRPG -ieq "y")
# }



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
# if the save file has the Character_Creation flag set to false, deletes JSON file (i.e. if Adventurer creation was cancelled or not fully completed - safe to delete file)
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
        Update_Variables
        Draw_Player_Window_and_Stats
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
            # if yes then just exit loop and continue onto main loop
            # Import_JSON
            # Update_Variables
            # Clear-Host
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
                Create_Adventurer
            }
        }
    } until ($Load_Save_Data_Choice -ieq "y" -or $Start_A_New_Game -ieq "y" -or $Start_A_New_Game -ieq "e")
} else {
    # no JSON file found
    Game_Introduction
    Create_Adventurer
}
if ($Load_Save_Data_Choice -ieq "e" -or $Start_A_New_Game -ieq "e") {
    Write-Color -NoNewLine "Quitting ","PS-BCDD","." -Color DarkYellow,Magenta,DarkYellow
    Exit
}

#
# first thing after Adventurer creation / loading saved data
#
# main wilderness loop
do {
    #
    # wilderness journey roll
    #
    Clear-Host
    Draw_Player_Window_and_Stats
    $Info_Banner = "Wilderness Journey"
    Draw_Info_Banner
    Write-Color ""
    Draw_Wilderness_Journeys_Table -Value "Wilderness_Journeys"
    Roll_D6_Dice
    # $Random_Dice_Roll = 1
    $Import_JSON.Character.Wilderness_Journeys_Current_Number += 1
    $Import_JSON.Character.Wilderness_Journeys_Current_Name = $Import_JSON.Wilderness_Journeys."$Random_Dice_Roll".Name
    $Current_Wilderness_Journey_JSON_Number = $Random_Dice_Roll
    Update_Variables
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
    switch ($Wilderness_Journeys_Current_Number) {
        1 { $Wilderness_Journey_Number_Word = "first" ; break }
        2 { $Wilderness_Journey_Number_Word = "second"; break }
        3 { $Wilderness_Journey_Number_Word = "third" ; break }
        4 { $Wilderness_Journey_Number_Word = "fourth"; break }
        5 { $Wilderness_Journey_Number_Word = "fifth" ; break }
        Default {}
    }
    if ($Random_Dice_Roll -eq "1") {
        $A_Trip_To = "the"
    } else {
        $A_Trip_To = "a"
    }
    Write-Color "  Your $Wilderness_Journey_Number_Word ","Wilderness encounter ","will be a trip to $A_Trip_To ","$($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Name)","." -Color DarkGray,White,DarkGray,White,DarkGray
    switch ($Wilderness_Journeys_Current_Number) {
        1 { $Wilderness_Journeys_History_Name_1 = "$($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Name)"; break }
        2 { $Wilderness_Journeys_History_Name_2 = "$($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Name)"; break }
        3 { $Wilderness_Journeys_History_Name_3 = "$($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Name)"; break }
        4 { $Wilderness_Journeys_History_Name_4 = "$($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Name)"; break }
        5 { $Wilderness_Journeys_History_Name_5 = "$($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Name)"; break }
        Default {}
    }
    Draw_Player_Window_and_Stats
    Save_JSON
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
    Write-Color -NoNewLine "  Press Enter to travel to $A_Trip_To ","$($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Name)","..." -Color DarkYellow,White,DarkYellow
    $Host.UI.ReadLine() | Out-Null
    #
    # wilderness encounter
    #
    $Import_JSON.Character.Current_Location = "Settlement"
    Clear_Bottom_Half_of_Screen
    $Info_Banner = "Wilderness Encounter #$Wilderness_Journeys_Current_Number - $Wilderness_Journeys_Current_Name"
    Draw_Info_Banner
    Write-Color ""
    Write-Color "  After some time travelling, you arrive at a ","$($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Name)","." -Color DarkGray,White,DarkGray
    if ($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Test_Type -ieq "n/a") {
        Write-Color "`r`n  You wonder around the ","$($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Name)"," for a while but nothing of interest happens." -Color DarkGray,White,DarkGray
        $Test_Pass_Result = "P"
    } else {
        Write-Color "`r`n  The ","$($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Name) ","has a difficulty test of ","$($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Test_Difficulty) ","against your ","$($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Test_Type) ","STAT." -Color DarkGray,White,DarkGray,White,DarkGray,White,DarkGray
        # get fail and pass properties for current wilderness journey
        foreach ($item in $Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Reward.PSObject.Properties) {
            if ($item.Name -ieq "Fail") {
                $Fail_Properties = $($item.Value.PSObject.Properties)
            }
            if ($item.Name -ieq "Pass") {
                $Pass_Properties = $($item.Value.PSObject.Properties)
                if ($Random_Dice_Roll -eq 4) {# TODO : Campsite test has a choice of two rewards which is not taken into account
                    # PSCustomObject
                    $Pass_Properties = New-Object PSObject -Property @{
                        Name  = "ToDo: Campsite name Fix me"
                        Value = "ToDo: Campsite value Fix me"
                    }
                }
            }
        }
        Write-Color "`r`n  TODO : one of the Pass tests has a choice of two rewards which is not taken into account." -Color Red
        Write-Color "`r`n  If you ","Pass",", you will gain ","$($Pass_Properties.Value) $($Pass_Properties.Name) ", "and if you ","Fail",", you will lose ","$($Fail_Properties.Value) $($Fail_Properties.Name)","." -Color DarkGray,Green,DarkGray,White,DarkGray,Red,DarkGray,White,DarkGray
        Write-Color "`r`n  Your ","$($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Test_Type) ","STAT is ","$($Import_JSON.Character.Stats.$($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Test_Type))",". Roll a ","$($($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Test_Difficulty) - $($Import_JSON.Character.Stats.$($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Test_Type)) + 1) ","or higher to ","Pass"," ($($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Test_Difficulty) - your $($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Test_Type) $($Import_JSON.Character.Stats.$($Import_JSON.Wilderness_Journeys.$Random_Dice_Roll.Test_Type)) STAT + 1)." -Color DarkGray,White,DarkGray,White,DarkGray,White,DarkGray,Green,DarkGray
        # roll higher to pass test
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
        Write-Color -NoNewLine "  Roll a d6..." -Color DarkYellow
        $Host.UI.ReadLine() | Out-Null
        Roll_D6_Dice
        # $Random_Dice_Roll = 1
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
        if ($Random_Dice_Roll -gt $($($Import_JSON.Wilderness_Journeys.$Current_Wilderness_Journey_JSON_Number.Test_Difficulty) - $($Import_JSON.Character.Stats.$($Import_JSON.Wilderness_Journeys.$Current_Wilderness_Journey_JSON_Number.Test_Type)))) {
            Write-Color "  You roll a ","$Random_Dice_Roll"," and ","Pass"," the test. You gain ","$($Pass_Properties.Value) $($Pass_Properties.Name)","." -Color DarkGray,White,DarkGray,Green,DarkGray,White,DarkGray
            $Test_Pass_Result = "P"
        } else {
            Write-Color "  You roll a ","$Random_Dice_Roll"," and ","Fail"," the test. You lose ","$($Fail_Properties.Value) $($Fail_Properties.Name)","." -Color DarkGray,White,DarkGray,Red,DarkGray,White,DarkGray
            $Test_Pass_Result = "F"
        }
        if ($Test_Pass_Result -ieq "P") { # Pass
            switch ($Pass_Properties.Name) {
                health  { $Import_JSON.Character.Stats.HealthCurrent += $($Pass_Properties.Value); break }
                gold    { $Import_JSON.Character.Gold                += $($Pass_Properties.Value); break }
                rations { $Import_JSON.Character.Rations             += $($Pass_Properties.Value); break }
                torches { $Import_JSON.Character.Torches             += $($Pass_Properties.Value); break }
                xp      { $Import_JSON.Character.Total_XP            += $($Pass_Properties.Value); break }
                Default {}
            }
        } else { # Fail
            switch ($Fail_Properties.Name) {
                health  { $Import_JSON.Character.Stats.HealthCurrent -= $($Fail_Properties.Value); break }
                gold    { $Import_JSON.Character.Gold                -= $($Fail_Properties.Value); break }
                rations { $Import_JSON.Character.Rations             -= $($Fail_Properties.Value); break }
                torches { $Import_JSON.Character.Torches             -= $($Fail_Properties.Value); break }
                xp      { $Import_JSON.Character.Total_XP            -= $($Fail_Properties.Value); break }
                Default {}
            }
        }
    }
    switch ($Wilderness_Journeys_Current_Number) {
        1 {
            $Import_JSON.Character.Wilderness_Journeys_History_Name_1          = $Import_JSON.Character.Wilderness_Journeys_Current_Name
            $Import_JSON.Character.Wilderness_Journeys_History_Name_Complete_1 = $Test_Pass_Result
        }
        2 {
            $Import_JSON.Character.Wilderness_Journeys_History_Name_2          = $Import_JSON.Character.Wilderness_Journeys_Current_Name
            $Import_JSON.Character.Wilderness_Journeys_History_Name_Complete_2 = $Test_Pass_Result
        }
        3 {
            $Import_JSON.Character.Wilderness_Journeys_History_Name_3          = $Import_JSON.Character.Wilderness_Journeys_Current_Name
            $Import_JSON.Character.Wilderness_Journeys_History_Name_Complete_3 = $Test_Pass_Result
        }
        4 {
            $Import_JSON.Character.Wilderness_Journeys_History_Name_4          = $Import_JSON.Character.Wilderness_Journeys_Current_Name
            $Import_JSON.Character.Wilderness_Journeys_History_Name_Complete_4 = $Test_Pass_Result
        }
        5 {
            $Import_JSON.Character.Wilderness_Journeys_History_Name_5          = $Import_JSON.Character.Wilderness_Journeys_Current_Name
            $Import_JSON.Character.Wilderness_Journeys_History_Name_Complete_5 = $Test_Pass_Result
        }
        Default {}
    }
    foreach ($item in $Import_JSON.Wilderness_Journeys.PSObject.Properties) {
        $Number = $item.Name # gets wilderness journey number which is needed to update correct wilderness journey complete status in JSON file
        if ($item.Value.Name -eq $Import_JSON.Character.Wilderness_Journeys_Current_Name) {
            $Import_JSON.Wilderness_Journeys.$Number.Complete = $Test_Pass_Result
        }
    }
    Update_Variables
    Draw_Player_Window_and_Stats
    Save_JSON
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("");" "*140
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,38;$Host.UI.Write("")
    Write-Color -NoNewLine "  Press Enter to continue..." -Color DarkYellow
    $Host.UI.ReadLine() | Out-Null
} until ($Wilderness_Journeys_Current_Number -eq $Wilderness_Journeys_Total)


# loop
#   wilderness journey 1
#       wilderness encounter
#           enemy / test / NPC / shop
#   wilderness journey 2
#       wilderness encounter
#           enemy / test / NPC / shop
#   dungeon
#       dungeon room 1
#           enemy / test / NPC / hazard / treasure
#       dungeon room 2
#           enemy / test / NPC / hazard / treasure
#   Settlement
#       quest reward
#       shop
#       obtain new quest
#       roll on new wilderness journeys table
#   repeat loop
#
# stat level up when?



# Write-Color "  Your ","$Wilderness_Journeys_Total", " Wilderness Journeys are:" -Color DarkGray,White,DarkGray
# for ($i = 1; $i -lt $Wilderness_Journeys_Total+1; $i++) {
#     # $i
#     Write-Color -NoNewLine "`r`n  Journey #","$i" -Color DarkGray,White
# }






