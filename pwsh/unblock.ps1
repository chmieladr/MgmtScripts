#!/usr/bin/pwsh
# Script made by Adrian Chmiel (chmieladr)
# Unblocks all of the downloaded PowerShell scripts

# Run only once!
# Do not use outside of this directory!
# (might potentially unblock other unsafe files on your computer)

# Get the list of all files
$files = Get-ChildItem -File -Recurse

# Unblock them
foreach ($file in $files) {
    Unblock-File $file.FullName
}

# Confirmation message
Write-Host "All of the scripts have been unlocked!"