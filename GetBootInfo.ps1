$boottime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
$up = (Get-Date) - $boottime
$runtime = $up.Hours,$up.Minutes,$up.Seconds -join ":"
$info = "Booted at: {0}`nUptime: {1}" -f $boottime,$runtime
$info
