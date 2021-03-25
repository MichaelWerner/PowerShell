$boottime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
$up = (Get-Date) - $boottime
$runtime = "{0:d2}:{1:d2}:{2:d2}" -f $up.Hours,$up.Minutes,$up.Seconds
$info = "Booted at: {0}`nUptime: {1}" -f $boottime,$runtime
$info
