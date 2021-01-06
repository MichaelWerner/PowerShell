#Get IPv4 and IPv6 address
(Get-NetIPAddress -InterfaceIndex (Get-NetIPInterface -ConnectionState Connected -InterfaceAlias "Ethernet*").ifIndex).IPAddress

#Get IPv4 address only
(Get-NetIPAddress -InterfaceIndex (Get-NetIPInterface -ConnectionState Connected -InterfaceAlias "Ethernet*").ifIndex).IPv4Address

#Get IPv6 address only
(Get-NetIPAddress -InterfaceIndex (Get-NetIPInterface -ConnectionState Connected -InterfaceAlias "Ethernet*").ifIndex).IPv6Address
