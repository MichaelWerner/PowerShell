$StartDir = 'M:\Music'
$ExportFile = 'c:\users\micha\MusicList.csv'

$List = Get-ChildItem -Recurse -Directory $StartDir

$Info = "`tFolder`tSong"
echo $Info > $ExportFile

ForEach($Folder in $List)
{
   $FolderName = $Folder.FullName
   $Parent = $Folder.Name
   $Songs = Get-ChildItem -File -Path $FolderName
   foreach($Song in $Songs)
   {
     $Info = "$FolderName`t$Parent`t$Song"
     echo $Info >> $ExportFile
   }
}