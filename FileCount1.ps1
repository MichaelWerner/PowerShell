$List = Get-ChildItem -Recurse -Directory .
ForEach($Folder in $List)
{
   $Count1 = (Get-ChildItem -Directory $Folder.FullName).Count
   $Count2 = (Get-ChildItem -File $Folder.FullName).Count
   Write-Host $Folder.FullName "- $Count1 Sub-folder(s), $Count2 File(s)"
}