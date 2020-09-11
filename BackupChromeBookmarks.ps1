#A nested function to enumerate bookmark folders
Function Get-BookmarkFolder {
[cmdletbinding()]
Param(
[Parameter(Position=0,ValueFromPipeline=$True)]
$Node
)

Process {



 foreach ($child in $node.children) {
   #get parent folder name
   $parent = $node.Name

   if ($child.type -eq ‘Folder’) {
     #write to file
     $line = '<DT><H3>' + $child.Name + '</H3>
              <DL><p>'
    
     Out-File -FilePath $BackupFile -InputObject $line -Append -Force -Encoding utf8
     Get-BookmarkFolder $child
   }
   else {
        #write to file
        $date_added = [math]::Round([double]$child.date_added / 1000000)
        $line = '<DT><A HREF="' + $child.url + '" ADD_DATE="' + $date_added + '">' + $child.name + '</A>'
        Out-File -FilePath $BackupFile -InputObject $line -Append -Force -Encoding utf8

  } #else url
 } #foreach


    #write to file
   $line = '</DL><p>'
    
    Out-File -FilePath $BackupFile -InputObject $line -Append -Force -Encoding utf8

 } #process
} #end function


#convert Google Chrome Bookmark file from JSON
$BookmarkFile = "$env:localappdata\Google\Chrome\User Data\Default\Bookmarks"
$data = Get-Content $BookmarkFile | Out-String | ConvertFrom-Json
$RootEntries = $data.roots.PSObject.Properties | select -ExpandProperty name



$Header = '<!DOCTYPE NETSCAPE-Bookmark-file-1>
<!-- This is an automatically generated file.
     It will be read and overwritten.
     DO NOT EDIT! -->
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>'

$today      = Get-Date -format yyyyMMdd
$BackupFile = "F:\bookmarks-$today.html"
Out-File -FilePath $BackupFile -InputObject $Header -Force -Encoding utf8

foreach($entry in $RootEntries){
    if($data.roots.$entry.children.Count -gt 0) {
        $data.roots.$entry | Get-BookmarkFolder
    }
}

#write to file
$line = '</DL><p>'
    
Out-File -FilePath $BackupFile -InputObject $line -Append -Force -Encoding utf8

#keep the last 5 files only
$toDelete = "f:\bookmarks-*.html"
$keep = 5

$files = Get-ChildItem -Path $toDelete

if ($files.Count -gt $keep) {
    $files | Sort-Object -Property CreationTime | Select-Object -First ($files.Count -$keep) | Remove-Item
    }
