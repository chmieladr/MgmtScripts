# Script made by ~
# Features a couple tweaks restoring Windows 10 features on Windows 11
# using only the registry (no third-party tools required)

# Global variables
$explorerRestartRequired = $false
$contextMenuRegPath = 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}'
$explorerRelatedRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$taskbarRegPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Shell\Update\Packages"
$searchboxRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
$noTaskGroupingRegPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"

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

# Functions for enabling/disabling Windows 10 features
function Apply-LegacyContextMenu {
    if (Test-LegacyTaskbar) {
        Write-Host "You can't change context menu settings when legacy taskbar is enabled!"
        return
    }

    if (Test-LegacyContextMenu) {
        Write-Host "Windows 10 legacy context menu is already enabled!"
        return
    }

    if (-not (Test-Path $contextMenuRegPath)) {
	  New-Item -Path "$contextMenuRegPath" -Force | Out-Null
        New-Item -Path "$contextMenuRegPath\InprocServer32" -Force | Out-Null
    }
 
    New-ItemProperty -Path "$contextMenuRegPath\InprocServer32" -Name '(Default)' -Value '' -Force | Out-Null
    $explorerRestartRequired = $true

    Write-Host "Windows 10 legacy context menu has been enabled!"
}
 
function Test-LegacyContextMenu {
    if (Test-LegacyTaskbar) {
        return $true  # it's forcefully enabled when using legacy taskbar
    }
    return Test-Path "$contextMenuRegPath\InprocServer32"
}
 
function Revert-LegacyContextMenu {
    if (Test-LegacyTaskbar) {
        Write-Host "You can't change context menu settings when legacy taskbar is enabled!"
        return
    }

    if (-not (Test-LegacyContextMenu)) {
        Write-Host "Windows 10 legacy context menu is already disabled!"
        return
    }

    Remove-Item -Path $contextMenuRegPath -Recurse -Force
    $explorerRestartRequired = $true

    Write-Host "Windows 10 legacy context menu has been disabled!"
}
 
function Apply-LegacyTaskbar {
    if (Test-LegacyTaskbar) {
        Write-Host "Windows 10 legacy taskbar is already enabled!"
        return
    }
    
    if (-not (Test-Path "$taskbarRegPath")) {
        New-Item -Path "$taskbarRegPath" -Force | Out-Null
    }
 
    New-ItemProperty -Path "$taskbarRegPath" -Name "UndockingDisabled" -Value 1 -Force | Out-Null
 
    # Additional subkey that hides the search box (that doesn't work anyways)
    New-ItemProperty -Path "$searchboxRegPath" -Name "SearchboxTaskbarMode" -Value 0 -Force | Out-Null
 
    # Additional subkey that disables task grouping (why would you want that?)
    New-ItemProperty -Path "$noTaskGroupingRegPath" -Name "NoTaskGrouping" -Value 1 -Force | Out-Null

    $explorerRestartRequired = $true
    Write-Host "Windows 10 legacy taskbar has been enabled!"
}
 
function Test-LegacyTaskbar {
    $value = Get-ItemProperty -Path $taskbarRegPath -Name "UndockingDisabled" -ErrorAction SilentlyContinue
    return $value.UndockingDisabled -eq 1
}
 
function Revert-LegacyTaskbar {
    if (-not (Test-LegacyTaskbar)) {
        Write-Host "Windows 10 legacy taskbar is already disabled!"
        return
    }

    New-ItemProperty -Path "$taskbarRegPath" -Name "UndockingDisabled" -Value 0 -Force | Out-Null
    $explorerRestartRequired = $true

    Write-Host "Windows 10 legacy taskbar has been disabled!"
}
 
function Apply-SmallIcons {
    if (-not (Test-LegacyTaskbar)) {
        Write-Host "Small taskbar icons can be enabled only with Windows 10 legacy taskbar!"
        return
    }

    New-ItemProperty -Path "$explorerRelatedRegPath" -Name "TaskbarSmallIcons" -Value 1 -Force | Out-Null
    $explorerRestartRequired = $true

    Write-Host "Small taskbar icons have been enabled!"
}
 
function Test-SmallIcons {
    $value = Get-ItemProperty -Path "$explorerRelatedRegPath" -Name "TaskbarSmallIcons" -ErrorAction SilentlyContinue
    return $value.TaskbarSmallIcons -eq 1
}
 
function Revert-SmallIcons {
    if (-not (Test-SmallIcons)) {
        Write-Host "Small taskbar icons are already disabled!"
        return
    }

    New-ItemProperty -Path "$explorerRelatedRegPath" -Name "TaskbarSmallIcons" -Value 0 -Force | Out-Null
    $explorerRestartRequired = $true

    Write-Host "Small taskbar icons have been disabled!"
}
 
function CreateHiddenTrayIconsMenuShortcut {
    if (Test-Path "$env:USERPROFILE\Desktop\Tray Icons Menu (Legacy).lnk") {
        Write-Host "Hidden tray icons menu shortcut already exists!"
        return
    }
 
    $path = "$env:USERPROFILE\Desktop\Tray Icons Menu (Legacy).lnk"
    $target = "C:\Windows\explorer.exe"
    $arguments = "shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9}"
    $workingDirectory = "C:\Windows\System32"
 
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($path)
 
    $Shortcut.TargetPath = $target
    $Shortcut.Arguments = $arguments
    $Shortcut.WorkingDirectory = $workingDirectory
    $Shortcut.Save()
 
    Write-Host "Hidden tray icons menu shortcut has been created on the desktop!"
}

# Help message
function Introduction {
    Write-Host ""
    Write-Host "Win10ify - Script that restores Windows 10 features"
    Write-Host "Made by ~"
    Write-Host ""
    Write-Host "Usage: Win10ify.ps1 [options]"
    Write-Host ""
    Write-Host "Help message"
    Write-host "Note: All other arguments are ignored when used!"
    Write-Host "  -h -> Show this help message"
    Write-Host ""
    Write-Host ("Windows 10 legacy context menu (currently enabled: " + (Test-LegacyContextMenu) + ")")
    Write-Host "Note: Legacy context menu can't be disabled while using Windows 10 taskbar!"
    Write-Host "  -C -> Enable | -c -> Disable"
    Write-Host ""
    Write-Host ("Windows 10 legacy taskbar (currently enabled: " + (Test-LegacyTaskbar) + ")")
    Write-Host "Note: Not recommended (half broken)"
    Write-Host "  -B -> Enable | -b -> Disable"
    Write-Host ""
    Write-Host ("Small taskbar icons (currently enabled: " + (Test-SmallIcons) + ")")
    Write-Host "Note: Works only with Windows 10 taskbar enabled"
    Write-Host "  -S -> Enable | -s -> Disable"
    Write-Host ""
    Write-Host "Taskbar tray icons menu shortcut on Desktop"
    Write-Host "Note: Let's you partially configure the Windows 10 taskbar"
    Write-Host "  -D -> Create"
    Write-Host ""
}
 
# Main start of the script
if ($args.Length -eq 0 -or $args -contains '-h') {
    Introduction
    CheckElevation
    exit
}

CheckElevation

foreach ($arg in $args) {
    switch -CaseSensitive ($arg) {
        '-C' { Apply-LegacyContextMenu }
        '-c' { Revert-LegacyContextMenu }
        '-B' { Apply-LegacyTaskbar }
        '-b' { Revert-LegacyTaskbar }
        '-S' { Apply-SmallIcons }
        '-s' { Revert-SmallIcons }
        '-D' { CreateHiddenTrayIconsMenuShortcut }
        default { Write-Host "Unknown option: $arg" }
    }
}
 
if ($explorerRestartRequired) {
    Stop-Process -Name explorer -Force  # restarts explorer.exe to apply changes
}

Write-Host ""
Write-Host "Win10ify script has applied all the requested changes!"
Write-Host ""