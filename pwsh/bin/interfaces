#!/usr/bin/pwsh
# Script made by Adrian Chmiel (chmieladr)

# Get the interfaces
$interfaces = Get-NetAdapter

# Loop through the interfaces and display their data
foreach ($interface in $interfaces) {
     $name = $interface.Name
     $speed = $interface.Speed / 1000000
     $ipv4 = (Get-NetIPAddress -InterfaceAlias $name -AddressFamily IPv4).IPAddress 2>$null
     $ipv6 = (Get-NetIPAddress -InterfaceAlias $name -AddressFamily IPv6).IPAddress 2>$null
     Write-Output "$name `nIPv4: $ipv4 `nIPv6: $ipv6 `nSpeed: $speed Mbps`n"
}