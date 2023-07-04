$StartDir = 'M:\Music'
$ExportFile = 'c:\users\micha\MusicList.csv'
$Folders = Get-ChildItem -Path $StartDir -Directory -Recurse

echo "Gruppe`tAlbum`tLied`tJahr`tGenre`tDauer`tAblageort" > $ExportFile

foreach($Folder in $Folders)
{
    if((Get-ChildItem -File $Folder.FullName).Count -gt 0)
    {
        $com = (New-Object -ComObject "Shell.Application").Namespace($Folder.FullName)
        <#
        14 = Album
        15 = Year
        16 = Genre
        20 = Authors
        21 = Title
        27 = Length
        195 = Path
        #>
        $Properties = 20,14,21,15,16,27,195
        $com.Items() | 
        Foreach{
            $Info = ''
            foreach($i in $Properties)
            {
               $Info += $com.GetDetailsOf($_, $i) + "`t"
            }
            echo $Info >> $ExportFile
        } #foreach
    } #if (Get-ChildItem
} #foreach($Folder ...