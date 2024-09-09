#!/usr/bin/pwsh
# Script made by Adrian Chmiel (chmieladr)

# Launches all the links provided in 'links.txt' file
# Replace the links in the file provided as an example with your own ones!
# 'links.txt' file needs to be in the same directory as the script!

# Read all links from the 'links.txt' file
$links = Get-Content -Path "./links.txt"

# Open them all in the default web browser
foreach ($link in $links) {
    Start-Process $link
	Write-Host "Lauching $link"
}

# Confirmation message
Write-Host "All of the links have been opened!"