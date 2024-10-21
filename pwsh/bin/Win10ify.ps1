# Script made by Adrian Chmiel (chmieladr)
# Handles different tweaks restoring Windows 10 features
 
# Function that checks if the script is running with elevated privileges
function CheckElevation {
    $wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $prp = New-Object System.Security.Principal.WindowsPrincipal($wid)
    $adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
    if (-not $prp.IsInRole($adm)) {
        Write-Host "Please run the script as an administrator!"
        exit 1
    }
}
 
# Global variables 
$contextMenuRegPath = 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}'
$explorerSettingsRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
$taskbarRegPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Shell\Update\Packages"
$searchboxRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
$noTaskGroupingRegPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
 
function RestartExplorer {
    Stop-Process -Name explorer -Force
}
 
function Apply-LegacyContextMenu {
    if (-not (Test-Path $contextMenuRegPath)) {
	  New-Item -Path "$contextMenuRegPath"
        New-Item -Path "$contextMenuRegPath\InprocServer32"
    }
 
    New-ItemProperty -Path "$contextMenuRegPath\InprocServer32" -Name '(Default)' -Value '' -Force
    Write-Host "Windows 10 legacy context menu has been enabled!"
}

function Test-LegacyContextMenu {
    return Test-Path "$contextMenuRegPath\InprocServer32"
}

function Revert-LegacyContextMenu {
    Remove-Item -Path $contextMenuRegPath -Recurse -Force
    Write-Host "Windows 10 legacy context menu has been disabled!"
}

function Apply-LegacyTaskbar {
    # Create the registry key for taskbar if it doesn"t exist
    if (-not (Test-Path "$taskbarRegPath")) {
        New-Item -Path "$taskbarRegPath" -Force | Out-Null
    }
 
    Set-ItemProperty -Path "$taskbarRegPath" -Name "UndockingDisabled" -Value 1 -Force
 
    # Additional subkey that hides the search box (that doesn't work anyways)
    Set-ItemProperty -Path "$searchboxRegPath" -Name "SearchboxTaskbarMode" -Value 0 -Force
 
    # Additional subkey that disables task grouping (why would you want that?)
    Set-ItemProperty -Path "$noTaskGroupingRegPath" -Name "NoTaskGrouping" -Value 1 -Force
 
    Start-Process -FilePath explorer.exe -ArgumentList '$legacyTrayIconsMenuCmd'
 
    Write-Host "Windows 10 legacy taskbar has been enabled!"
    Write-Host "Note! The entire taskbar tweak is very buggy due to the nature of the system and may cause issues :/"
}

function Test-LegacyTaskbar {
    $undockingDisabled = Get-ItemProperty -Path $taskbarRegPath -Name "UndockingDisabled" -ErrorAction SilentlyContinue
    return $undockingDisabled.UndockingDisabled -eq 1
}

function Revert-LegacyTaskbar {
    Set-ItemProperty -Path "$taskbarRegPath" -Name "UndockingDisabled" -Value 0 -Force
    Write-Host "Windows 10 legacy taskbar has been disabled!"
}

function Apply-SmallIcons {
    Set-ItemProperty -Path "$explorerSettingsRegPath\Advanced" -Name "TaskbarSmallIcons" -Value 1 -Force
    Write-Host "Small taskbar icons have been enabled!"
}

function Test-SmallIcons {
    $value = Get-ItemProperty -Path "$explorerSettingsRegPath\Advanced" -Name "TaskbarSmallIcons" -ErrorAction SilentlyContinue
    return $value.TaskbarSmallIcons -eq 1
}

function Revert-SmallIcons {
    Set-ItemProperty -Path "$explorerSettingsRegPath\Advanced" -Name "TaskbarSmallIcons" -Value 0 -Force
    Write-Host "Small taskbar icons have been disabled!"
}

function CreateHiddenTrayIconsMenuShortcut {
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

function Introduction {
    Write-Host ""
    Write-Host "Win10ify - Script that restores Windows 10 features"
    Write-Host "Made by -"
    Write-Host ""
    Write-Host "Usage: Win10ify.ps1 [options]"
    Write-Host "Options:"
    Write-Host "  -h -> Show this help message"
    Write-Host ""
    Write-Host "Windows 10 legacy context menu"
    Write-Host "  -C -> Enable | -c -> Disable"
    Write-Host ""
    Write-Host "Windows 10 legacy taskbar"
    Write-Host "  -B -> Enable | -b -> Disable"
    Write-Host ""
    Write-Host "Small taskbar icons"
    Write-Host "  -S -> Enable | -s -> Disable"
    Write-Host ""
    Write-Host "Legacy taskbar tray icons menu shortcut on Desktop"
    Write-Host "  -D -> Create"
    Write-Host ""
}

# Main start of the script
if ($args.Length -eq 0 -or $args -contains '-h') {
    Introduction
    CheckElevation
    exit
}

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

RestartExplorer
Write-Host "Win10ify script has finished!"