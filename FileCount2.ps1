$StartDir = 'M:\Music'
$ExportFile = 'c:\users\micha\MusicList.csv'

rm $ExportFile

$List = Get-ChildItem -Recurse -Directory $StartDir
ForEach($Folder in $List)
{
   $FolderName = $Folder.FullName  
   $CountDir = (Get-ChildItem -Directory $FolderName).Count
   $CountFile = (Get-ChildItem -File $FolderName).Count
   $Info = New-Object -TypeName PsObject -Property @{Folder=$FolderName;Folders=$CountDir;Files=$CountFile}
   $Info | Select-Object Folder,Folders,Files | Export-Csv -Path $ExportFile -Append -UseCulture -NoTypeInformation
}
