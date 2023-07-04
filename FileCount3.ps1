$StartDir = 'M:\Music'
$ExportFile = 'c:\users\micha\MusicList.csv'

$List = Get-ChildItem -Recurse -Directory $StartDir

$Info = "Folder`tFolders`tFiles"
echo $Info > $ExportFile

ForEach($Folder in $List)
{
   $FolderName = $Folder.FullName  
   $CountDir = (Get-ChildItem -Directory $FolderName).Count
   $CountFile = (Get-ChildItem -File $FolderName).Count
   $Info = "$FolderName`t$CountDir`t$CountFile"
   echo $Info >> $ExportFile
}