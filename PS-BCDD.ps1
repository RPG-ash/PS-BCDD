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

    
Function Roll_D6_Dice {
    # Clear-Host
    $Random_Dice_Roll_Random_Seconds = Get-Random -Minimum 4 -Maximum 10
    for ($i = 0; $i -lt $Random_Dice_Roll_Random_Seconds; $i++) {
        do {
            $Script:Random_Dice_Roll = Get-Random -Minimum 1 -Maximum 7
        } until ($Random_Dice_Roll -ne $Last_Dice_Roll)
        Clear-Host
        "`r`nRolling D6 Dice...`r`n"
        $Script:Last_Dice_Roll = $Random_Dice_Roll
        switch ($Random_Dice_Roll) {
            1 {
                Write-Color "      +-------+"
                Write-Color "      |       |"
                Write-Color "      |   o   |"
                Write-Color "      |       |"
                Write-Color "      +-------+"
                break
            }
            2 {
                Write-Color "      +-------+"
                Write-Color "      | o     |"
                Write-Color "      |       |"
                Write-Color "      |     o |"
                Write-Color "      +-------+"
                break
            }
            3 {
                Write-Color "      +-------+"
                Write-Color "      | o     |"
                Write-Color "      |   o   |"
                Write-Color "      |     o |"
                Write-Color "      +-------+"
                break
            }
            4 {
                Write-Color "      +-------+"
                Write-Color "      | o   o |"
                Write-Color "      |       |"
                Write-Color "      | o   o |"
                Write-Color "      +-------+"
                break
            }
            5 {
                Write-Color "      +-------+"
                Write-Color "      | o   o |"
                Write-Color "      |   o   |"
                Write-Color "      | o   o |"
                Write-Color "      +-------+"
                break
            }
            6 {
                Write-Color "      +-------+"
                Write-Color "      | o   o |"
                Write-Color "      | o   o |"
                Write-Color "      | o   o |"
                Write-Color "      +-------+"
                break
            }
            Default {}
        }
        $Random_Milliseconds = Get-Random -Minimum 200 -Maximum 1000
        Start-Sleep -Milliseconds $Random_Milliseconds
    }
}



#
# create character
#
Function Create_Character {
    Copy-Item -Path .\PS-BCDD_new_game.json -Destination .\PS-BCDD.json
    Import_JSON
    do {
        $Character_Name = $false
        $Character_Name_Valid = $false
        $Character_Name_Confirm = $false
        # character name loop
        do {
            $Character_Name = $false
            $Character_Name_Valid = $false
            $Character_Name_Confirm = $false
            $Character_Name_Random_Confirm = $false
            do {
                do {
                    Clear-Host
                    if ($($Character_Name | Measure-Object -Character).Characters -gt 10) {
                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,9
                        Write-Color "*Your name is too long, your name must be 10 characters or less*" -Color Red
                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,0
                    }
                    if ($Random_Character_Name_Count -eq 0) {
                        Write-Color "*All random names have been suggested*" -Color Red
                    }
                    Write-Color "What will be your character name?" -Color DarkGray
                    Write-Color "If you cannot think of a name, try searching for one online or enter ","R ","for some random name suggestions." -Color DarkGray,Green,DarkGray
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,8;$Host.UI.Write("")
                    Write-Color -NoNewLine "Enter a name (max 10 characters) or ","R","andom ","[R]" -Color DarkYellow,Green,DarkYellow,Green
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
                            for ($Position = 0; $Position -lt 10; $Position++) {
                                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,$Position;$Host.UI.Write("");" "*105
                            }
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,0;$Host.UI.Write("")
                            if ($Gandalf_Joke -ieq "Gandalf the Gray") {
                                Write-Color "Oh wait. That name has more than 10 characters. You'll have to pick another name, sorry about that =|" -Color DarkGray
                                Write-Color "Where were we..." -Color DarkGray
                            }
                            if ($Character_Name_Random -ieq "n") {
                                $Random_Character_Name_Count += 1
                                "$Random_Character_Name_Count"
                                switch ($Random_Character_Name_Count) {
                                    1 { Write-Color "What about ", "$Random_Character_Name ", "for your Character's name?" -Color DarkGray,Blue,DarkGray}
                                    2 { Write-Color "How about ", "$Random_Character_Name ", "for your Character's name instead?" -Color DarkGray,Blue,DarkGray}
                                    3 { Write-Color "Okay, how about ", "$Random_Character_Name ", "then?" -Color DarkGray,Blue,DarkGray }
                                    4 { Write-Color "Didn't like that one huh? What about ", "$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    5 { Write-Color "Didn't like that one either? ", "$Random_Character_Name ", "then?" -Color DarkGray,Blue,DarkGray }
                                    6 { Write-Color "$Random_Character_Name", "?" -Color Blue,DarkGray }
                                    7 { Write-Color "$Random_Character_Name", "?" -Color Blue,DarkGray }
                                    8 { Write-Color "$Random_Character_Name", "?" -Color Blue,DarkGray }
                                    9 { Write-Color "You're getting picky now. Let's go with ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    10 { Write-Color "You're getting really picky now. Why don't you choose ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    11 { Write-Color "Or ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    12 { Write-Color "I'm running out of names now. ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    13 { Write-Color "If you don't pick this one, i'm choose for you. ","$Random_Character_Name", "." -Color DarkGray,Blue,DarkGray }
                                    14 { Write-Color "WoW, you really didn't like THAT one??? ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    15 { Write-Color "Still deciding? ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    16 { Write-Color "Can't make up your mind can you? ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    17 { Write-Color "This is getting boring. ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    18 { Write-Color "*Yawn* ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray }
                                    19 {
                                        Write-Color "Gandalf the Gray", "?" -Color Blue,DarkGray
                                        $Random_Character_Name = "Gandalf the Gray"
                                    }
                                    20 {
                                        if ($Gandalf_Joke -ieq "Gandalf the Gray") {
                                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,0;$Host.UI.Write("");" "*105
                                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,1;$Host.UI.Write("");" "*105
                                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,2;$Host.UI.Write("");" "*105
                                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,0;$Host.UI.Write("")
                                            Write-Color "Sorry about the ","Gandalf ","joke, that wasn't very funny." -Color DarkGray,Blue,DarkGray
                                            Write-Color "If you like, i'll let you have ","Gandalf",". ","How about that?" -Color DarkGray,Blue,DarkGray
                                            $Random_Character_Name = "Gandalf"
                                            $Gandalf_Joke = "Gandalf"
                                        } else {
                                            Write-Color "Here is another name... ","$Random_Character_Name", "?" -Color DarkGray,Blue,DarkGray
                                        }
                                    }
                                    Default {
                                        Write-Color "$Random_Character_Name", "?" -Color Blue,DarkGray
                                    }
                                }
                                $Random_Character_Names.Remove($Random_Character_Name)
                            } else {
                                Write-Color "How about ", "$Random_Character_Name ", "for your Character's name? " -Color DarkGray,Blue,DarkGray
                            }
                            $Character_Name = $Random_Character_Name
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,8;$Host.UI.Write("")
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,8;$Host.UI.Write("");" "*105
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,8;$Host.UI.Write("")
                            Write-Color -NoNewLine "Choose this name? ","[Y/N]" -Color DarkYellow,Green
                            $Character_Name_Random = Read-Host " "
                        } until ($Character_Name_Random -ieq "y" -or $Character_Name_Random -ieq "n")
                        if ($Character_Name_Random -ieq "y") {
                            Write-Color -NoNewLine "You have chosen ", "$Character_Name ", "for your Character name, is this correct? ", "[Y/N]" -Color DarkYellow,Blue,DarkYellow,Green
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
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,9;$Host.UI.Write("")
                            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,9;$Host.UI.Write("");" "*105
                        }
                    } until ($Character_Name_Random_Confirm -eq $true)
                }
            } until ($Character_Name_Valid -eq $true)
            if ($Character_Name_Random_Confirm -ieq $false) {
                do {
                    Write-Color -NoNewLine "You have chosen ", "$Character_Name ", "for your Character name, is this correct? ", "[Y/N/E]" -Color DarkYellow,Blue,DarkYellow,Green
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
        do {
            for ($Position = 0; $Position -lt 10; $Position++) {
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,$Position;$Host.UI.Write("");" "*105
            }
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,0;$Host.UI.Write("")
            Write-Color "Now that you have chosen a name, let's work on some stats." -Color DarkGray
            Write-Color ""
            Write-Color "Your max ","Health"," can only ever be ","12",", so you will start with that. You can't go over this amount, no matter how many ","potions"," you quaff." -Color DarkGray,Green,DarkGray,Green,DarkGray,Blue,DarkGray
            Write-Color ""
            Write-Color "You will also start with ","6"," Rations",", and ","6"," Torches." -Color DarkGray,White,Blue,DarkGray,White,Blue
            Write-Color "Rations"," are used when travelling between locations, and ","Torches"," are used when exploring dungeons." -Color Blue,DarkGray,Blue,DarkGray
            Write-Color ""
            Write-Color "You use ","1"," Ration"," per journey. If you run out of ","Rations",", you will lose ","1"," Health"," each time you travel between locations." -Color DarkGray,White,Blue,DarkGray,Blue,DarkGray,White,Green,DarkGray
            Write-Color "When your character's Health reaches ","0",", it's game over and you will have to re-roll another character." -Color DarkGray,Red,DarkGray
            Write-Color ""
            Write-Color "You use ","1"," Torch"," per dungeon room. If you use up all your torches before leaving a dungeon, you'll be lost in dungeon forever unable to escape and will have to re-roll another character." -Color DarkGray,White,Blue,DarkGray,DarkGray,White,Blue,DarkGray
            Write-Color ""
            Write-Color "Both ","Rations"," and ","Torches"," can sometimes be found in enemy loot, but also bought from the shop in Settelment." -Color DarkGray,Blue,DarkGray,Blue,DarkGray
            Write-Color ""
            # save stats to JSON and variables
            $Import_JSON.Character.Stats.HealthCurrent = 12
            $Import_JSON.Character.Stats.HealthMax     = 12
            $Import_JSON.Character.Rations       = 6
            $Import_JSON.Character.Torches       = 6
            $Script:Character_HealthCurrent      = $Import_JSON.Character.Stats.HealthCurrent
            $Script:Character_HealthMax          = $Import_JSON.Character.Stats.HealthMax
            $Script:Rations                      = $Import_JSON.Character.Rations
            $Script:Torches                      = $Import_JSON.Character.Torches
            Read-Host "Press Enter to continue... "
            Clear-Host
            for ($Position = 0; $Position -lt 16; $Position++) {
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,$Position;$Host.UI.Write("");" "*105
            }
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,0;$Host.UI.Write("")
            Write-Color "Your other stats, ","STR",", ","DEX"," and ","INT",", will start at ","0"," for now, but you'll get the chance to increase these when you gain some XP from killing enemies." -Color DarkGray,White,DarkGray,White,DarkGray,White,DarkGray,White,DarkGray
            Write-Color ""
            Write-Color "STR"," (Strength), ","DEX"," (Dexterity) and ","INT"," (Intelligence), are used to determine ","Pass"," and ","Fail"," results against certain tests from events suchs as Encounters, Hazards and NPC interactions." -Color White,DarkGray,White,DarkGray,White,DarkGray,Green,DarkGray,Red,DarkGray
            Write-Color ""
            Write-Color "STR"," and ","DEX"," are also used in combat to determine attack and defence results against enemies." -Color White,DarkGray,White,DarkGray
            Read-Host "Press Enter to continue... "
            Clear-Host
            # potion and spells
            Write-Color "Potions and Spells"
            Write-Color "=================="
            Write-Color "`r`nPotions and Spells are items that can be used at any time that can heal you, cause damage to enemies," -Color DarkGray
            Write-Color "raise your stats temporally and even teleport you back to the Settlement." -Color DarkGray
            Write-Color "You can also find them in loot from enemies, or buy them from the shop in the Settlement." -Color DarkGray
            Write-Color "`r`nYou start with a free Potion and Spell." -Color DarkGray
            Write-Color ""
            foreach ($item in $Import_JSON.Potions.PSObject.Properties) {
                "$($item.Name) - $($item.Value.Name) ($($item.Value.Info))"
            }
            # roll for potion
            Write-Color "`r`nRoll a D6 now to determine which Potion you receive." -Color DarkGray
            Read-Host "`r`nPress Enter to continue... "
            Clear-Host
            Roll_D6_Dice
            Write-Color "`r`nYou rolled a ","$Random_Dice_Roll", ". You gain a ","$($Import_JSON.Potions.$Random_Dice_Roll.Name)"," Potion","." -Color DarkGray,White,DarkGray,White,Blue,DarkGray
            $Import_JSON.Character.PotionsTotal += 1
            $Script:PotionsTotal = $Import_JSON.Character.PotionsTotal
            $Import_JSON.Potions.$Random_Dice_Roll.Quantity += 1
            Write-Color ""
            # roll for spell
            Write-Color "`r`nNow roll another D6 to determine which Spell you receive." -Color DarkGray
            Read-Host "Press Enter to continue... "
            Clear-Host
            Roll_D6_Dice
            Write-Color "`r`nYou rolled a ","$Random_Dice_Roll", ". You gain a ","$($Import_JSON.Spells.$Random_Dice_Roll.Name)"," Spell","." -Color DarkGray,White,DarkGray,White,Blue,DarkGray
            $Import_JSON.Character.SpellsTotal += 1
            $Script:SpellsTotal = $Import_JSON.Character.SpellsTotal
            $Import_JSON.Spells.$Random_Dice_Roll.Quantity += 1
            Write-Color ""
            
            
            
            
            
            
            
            
            
            
            
            Read-Host "Press Enter to continue... "
            Clear-Host
            # roll for gold
            Write-Color "You have a small pouch to carry some Gold coins which can be used to purchase items from the shop in Settlement." -Color DarkGray,Green,DarkGray
            Write-Color ""
            Read-Host "Press a key to roll a D6 to determine how much Gold you will start with... "
            Clear-Host
            Roll_D6_Dice
            Write-Color ""
            Write-Color "You start with ","$Random_Dice_Roll", " Gold","." -Color DarkGray,White,DarkYellow,DarkGray
            # set gold in JSON and variable
            $Import_JSON.Character.Gold = $Random_Dice_Roll
            $Script:Gold                = $Import_JSON.Character.Gold
            
            Read-Host "Press Enter to continue... "
            Write-Color ""

            Write-Color ""













            # confirm all character choices
            Clear-Host
            $Update_Character_JSON = $false
            $Update_Character_JSON_Valid = $false
            $Update_Character_JSON_Confirm = $false
            do {
                Write-Color -NoNewLine "Are all your Character details correct? ", "[Y/N/E]" -Color DarkYellow,Green
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
    "`r`nupdating variables..."
    $Script:Character_Name          = $Import_JSON.Character.Name
    $Script:Character_HealthCurrent = $Import_JSON.Character.Stats.HealthCurrent
    $Script:Character_HealthMax     = $Import_JSON.Character.Stats.HealthMax
    $Script:Character_Strength      = $Import_JSON.Character.Stats.Strength
    $Script:Character_Dexterity     = $Import_JSON.Character.Stats.Dexterity
    $Script:Character_Intelligence  = $Import_JSON.Character.Stats.Intelligence
    $Script:Rations                 = $Import_JSON.Character.Rations
    $Script:Torches                 = $Import_JSON.Character.Torches
    $Script:SpellsTotal             = $Import_JSON.Character.SpellsTotal
    $Script:PotionsTotal            = $Import_JSON.Character.PotionsTotal
    $Script:Gold                    = $Import_JSON.Character.Gold
    $Script:Total_XP                = $Import_JSON.Character.Total_XP
    $Script:XP_TNL                  = $Import_JSON.Character.XP_TNL
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
#     Write-Color "`r`nAs previously mentioned, the PSWriteColor PowerShell module written by Przemyslaw Klys is required," -Color DarkGray
#     Write-Color "which, if you are seeing this message then it has installed and imported successfully." -Color DarkGray
#     Write-Color "`r`nAbsolutely ", "NO ", "info, personal or otherwise, is collected or sent anywhere or to anybody. " -Color DarkGray,Red,DarkGray
#     Write-Color "`r`nAll the ", "PS-BCDD ", "games files are stored your ", "$PSScriptRoot"," folder which is where you have run the game from." -Color DarkGray,Magenta,DarkGray,Cyan,DarkGray
#     Write-Color "`rThey include:" -Color DarkGray,Magenta,DarkGray,Cyan,DarkGray
#     Write-Color "The main PowerShell script            : ", "PS-BCDD.ps1" -Color DarkGray,Cyan
#     Write-Color "ASCII art for death messages          : ", "ASCII.txt" -Color DarkGray,Cyan
#     Write-Color "A JSON file that stores all game info : ", "PS-BCDD.json ", "(Locations, Mobs, NPCs and Character Stats etc.)" -Color DarkGray,Cyan,DarkGray
#     Write-Color "`r`nPlayer input options appear in ","Green ", "e.g. ", "[Y/N/E/I] ", "would be ", "yes/no/exit/inventory", "." -Color DarkGray,Green,DarkGray,Green,DarkGray,Green,DarkGray
#     Write-Color "Enter the single character then hit `'Enter`' to confirm the choice." -Color DarkGray
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

# double check module is still installed if JSON file has previously been created, just in case the module has been removed.
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

# loads save file and validate JSON file is on PowerShell Core edition
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
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("");" "*105
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
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("");" "*105
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0,36;$Host.UI.Write("")
                Write-Color -NoNewLine "Start a new game?"," [Y/N/E]" -Color Magenta,Green
                $Start_A_New_Game = Read-Host " "
                $Start_A_New_Game = $Start_A_New_Game.Trim()
            } until ($Start_A_New_Game -ieq "y" -or $Start_A_New_Game -ieq "n" -or $Start_A_New_Game -ieq "e")
            if ($Start_A_New_Game -ieq "y") {
                # new game
                Create_Character
            }
        }
    } until ($Load_Save_Data_Choice -ieq "y" -or $Start_A_New_Game -ieq "y" -or $Start_A_New_Game -ieq "e")
} else {
    # no JSON file found
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




"`r`nJSON Variables"
$Import_JSON.Character.Stats.HealthCurrent
$Import_JSON.Character.Stats.HealthMax
$Import_JSON.Character.Stats.Strength
$Import_JSON.Character.Stats.Dexterity
$Import_JSON.Character.Stats.Intelligence
$Import_JSON.Character.Rations
$Import_JSON.Character.Torches
$Import_JSON.Character.SpellsTotal
$Import_JSON.Character.PotionsTotal
$Import_JSON.Character.Gold
$Import_JSON.Character.Total_XP
$Import_JSON.Character.XP_TNL


"`r`nInternal variables"
"$Character_Name"
"$Character_HealthCurrent"
"$Character_HealthMax"
"$Character_Strength"
"$Character_Dexterity"
"$Character_Intelligence"
"$Rations"
"$Torches"
"$SpellsTotal"
"$PotionsTotal"
"$Gold"
"$Total_XP"
"$XP_TNL"



