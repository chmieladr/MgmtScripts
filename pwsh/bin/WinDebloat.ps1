# Script made by Adrian Chmiel (https://github.com/chmieladr)
# Lets you easily uninstall unnecessary preinstalled Windows 11 apps.

# Elevated privileges check
function CheckElevation {
    $wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $prp = New-Object System.Security.Principal.WindowsPrincipal($wid)
    $adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
    if (-not $prp.IsInRole($adm)) {
        Write-Host "Please run the script as an administrator!"
        exit 1
    }
}

# WIP