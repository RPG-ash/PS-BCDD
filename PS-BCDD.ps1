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
# first thing after character creation / loading saved data
#
# main loop

Install_PSWriteColor

"importing JSON..."
Import_JSON

"saving JSON..."
Save_JSON





