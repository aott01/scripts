# add-persistent-routes.ps1

# see https://learn.microsoft.com/en-us/powershell/module/nettcpip/new-netroute?view=windowsserver2022-ps
# and https://learn.microsoft.com/en-us/powershell/module/nettcpip/remove-netroute?view=windowsserver2022-ps

# -0- Theory of operation and documentation
# GOVT network is primary, RADIO network is secondary; both give you DHCP IP and route
# mangle routing table as folllows with metrics: leave default to GOVT, add specific RADIO prefixes with its gateway, then backup default to RADIO

# -1- check interface numbers "InterfaceIndex" (old style 'route print' or PS 'Get-NetIPConfiguration -All')
Get-NetIPConfiguration -All
Get-NetRoute | Format-List -Property *

# -2- clear existing routes (ignore if not present, but it will remove the DHCP default route on the RADIO network, also get rid of wrong metrics)
Try { #delete route command
} Catch [System.IO.IOException] {
   Write-Host "Something went wrong"
} 

# -3- add new routes
New-NetRoute -DestinationPrefix "10.240.0.0/20" -InterfaceIndex "__73__" -NextHop "10.248.6.1" -RouteMetric 3 -Persistent
New-NetRoute -DestinationPrefix "10.232.0.0/21" -InterfaceIndex "__73__" -NextHop "10.248.6.1" -RouteMetric 3 -Persistent
New-NetRoute -DestinationPrefix "10.232.0.0/21" -InterfaceIndex "__73__" -NextHop "10.248.6.1" -RouteMetric 3 -Persistent
New-NetRoute -DestinationPrefix "0.0.0.0" -InterfaceIndex "__73__" -NextHop "10.248.6.1" -RouteMetric 1000 -Persistent


#end-of-script
