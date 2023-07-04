$com = (New-Object -ComObject Shell.Application).NameSpace('c:\')
for ($index = 1; $index -ne 400; $index++) {
    New-Object -TypeName PSCustomObject -Property @{
        IndexNumber = $Index
        Attribute = $com.GetDetailsOf($com,$index)
    } | Where-Object {$_.Attribute} | Export-Csv -Path D:\PowerShell\FileInfo.csv -Append -UseCulture -NoTypeInformation
}