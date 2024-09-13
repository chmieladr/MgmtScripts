# Script made by Adrian Chmiel (chmieladr)

$path = "$env:USERPROFILE\Desktop\God Mode.lnk"
$target = "C:\Windows\explorer.exe"
$arguments = "shell:::{ED7BA470-8E54-465E-825C-99712043E01C}"
$workingDirectory = "C:\Windows\System32"

# Create a new Component Object Model (COM) object
$WScriptShell = New-Object -ComObject WScript.Shell

# Create a new shortcut
$Shortcut = $WScriptShell.CreateShortcut($path)

# Set the shortcut properties
$Shortcut.TargetPath = $target
$Shortcut.Arguments = $arguments
$Shortcut.WorkingDirectory = $workingDirectory

# Save the shortcut
$Shortcut.Save()

# Confirmation message
Write-Host "God Mode shortcut has been created on the desktop!"