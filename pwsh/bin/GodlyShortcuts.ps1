# Script made by Adrian Chmiel (chmieladr)
# Lets you easily create shortcuts to either hidden
# or unnecessarily difficult to access Windows features.

# Desktop path
$desktop = "$env:USERPROFILE\Desktop"
$godModeShellKey = "shell:::{ED7BA470-8E54-465E-825C-99712043E01C}"

function Create-Shortcut {
    param (
        [string]$path,
        [string]$target,
        [string]$arguments,
        [string]$name = "New", 
        [string]$workingDirectory = "C:\Windows\System32"
    )

    # Check if the shortcut already exists
    if (Test-Path $path) {
        Write-Host "$path: Shortcut already exists!"
        return
    }

    # Create a new Component Object Model (COM) object
    $WScriptShell = New-Object -ComObject WScript.Shell

    # Create a new shortcut
    $Shortcut = $WScriptShell.CreateShortcut($path)

    # Set the shortcut properties
    $Shortcut.TargetPath = $target
    $Shortcut.Arguments = $arguments
    $Shortcut.WorkingDirectory = $workingDirectory
    $Shortcut.Save()

    Write-Host "$name shortcut has been created on the desktop!"
}

function Shortcut-GodMode {
    Create-Shortcut -path "$desktop\God Mode.lnk" -target "C:\Windows\explorer.exe" -arguments "$godModeShellKey" -name "God Mode"
}

function Shortcut-AllApps {
    Create-Shortcut -path "$desktop\All Applications.lnk" -target "C:\Windows\explorer.exe" -arguments "shell:AppsFolder" -name "All Applications"
}

function Shortcut-AdvancedGraphics {
    Create-Shortcut -path "ms-settings:display-advancedgraphics" -name "Advanced Graphics"
}

function Create-AllShortcuts {
    Shortcut-GodMode
    Shortcut-AllApps
    Shortcut-AdvancedGraphics
    Write-Host "All available shortcuts have been created on the desktop!"
}

function Introduction {
    Write-Host ""
    Write-Host "Usage: GodlyShortcuts.ps1 [options]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "-h   -> Display this help message"
    Write-Host "-god -> Create a shortcut to God Mode"
    Write-Host "-app -> Create a shortcut to All Applications"
    Write-Host "-gpu -> Create a shortcut to Advanced Graphics Menu"
    Write-Host "-all -> Create all shortcuts"
    Write-Host ""
    Write-Host "Note: Multiple arguments in one go are allowed!"
    Write-Host ""
}

# Main start of the script
if ($args.Length -eq 0 -or $args -contains '-h') {
    Introduction
    exit
}

if ($args -contains '-all') {
    Create-AllShortcuts
    exit
}

foreach ($arg in $args) {
    switch ($arg) {
        '-god' { Shortcut-GodMode }
        '-app' { Shortcut-AllApps }
        '-gpu' { Shortcut-AdvancedGraphics }
        '-all' { Create-AllShortcuts }
        default { Write-Host "Unknown option: $arg" }
    }
}

Write-Host ""
Write-Host "GodlyShortcuts script has created all the requested shortcuts!"
Write-Host ""