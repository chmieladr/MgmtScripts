#!/usr/bin/pwsh
# Script made by Adrian Chmiel (chmieladr)

# Launches all the links provided in 'links.txt' file
# Replace the links in the file provided as an example with your own ones!
# 'links.txt' file needs to be in the same directory as the script!

# Determine the file
if ($args.Count -eq 0) {
    # Use default 'links.txt' file
    $txt = "links.txt"
}
elseif ($args.Count -eq 1) {
    # Show help message
    if ($args[0] -eq "-?" -or $args[0] -eq "-h") {
        Write-Host "Usage: $($MyInvocation.MyCommand.Name) [file]"
        Write-Host "If no file is provided, the script will look for 'links.txt' in the current directory."
        Write-Host "Additional arguments will be ignored."
        exit 0
    }

    # Check if the file exists
    if (-not (Test-Path $args[0])) {
        Write-Host "File not found!"
        exit 1
    }

    $txt = $args[0]
}
else {
    # Ignore additional arguments
    $txt = $args[0]
    Write-Host "More than one argument provided! Using the first one: $txt"
}

# Open them all in the default web browser
foreach ($link in $links) {
    Start-Process $link
	Write-Host "Lauching $link"
}

# Confirmation message
Write-Host "All links have been opened!"