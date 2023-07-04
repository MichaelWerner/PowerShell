Get-WmiObject  -Query "select * from Win32_LogicalDisk where drivetype=3" -ComputerName localhost  |
						Select-Object SystemName,DeviceId, @{Name="Size";Expression={[math]::Round($_.Size/1GB,2)}}`
                                                    ,@{Name="FreeSpace";Expression={[math]::Round($_.FreeSpace/1GB,2)}} `
                                                    ,@{Name="Occupied"; Expression= {[math]::Round(100 - ( [double]$_.FreeSpace / [double]$_.Size ) * 100)}} |
								Export-Csv disk_space.csv -NoTypeInformation
				
Get-WmiObject  -Query "select * from Win32_LogicalDisk" -ComputerName localhost  |
						Select-Object SystemName,DeviceId, @{Name="Size";Expression={[math]::Round($_.Size/1GB,2)}}`
                                                    ,@{Name="FreeSpace";Expression={[math]::Round($_.FreeSpace/1GB,2)}} `
                                                    ,@{Name="Occupied"; Expression= {[math]::Round(100 - ( [double]$_.FreeSpace / [double]$_.Size ) * 100)}}
				
