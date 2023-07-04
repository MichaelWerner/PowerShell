cls
Get-Process | Sort-Object CPU -descending | Select-Object -First 10
Write-Host " "
Get-Process | Sort-Object Memory -descending | Select-Object -First 10

get-process -Name "*powershell*" | select "Path"

Get-Process | Where-Object {$_.CPU -ge 100}