#PathToZips: the path to the zip files, no trailing \
#search:     the text to search for in the file name. * finds everything
param ([string]$PathToZips = "\\someserver\someshare\somefolder", [string]$search = "*")


#has only the zip files and the name of the document when a document was found in the zip file, like
# Found: somedocument.pdf in somzipfile.zip
$logfile = "C:\Users\$env:USERNAME\Downloads\FilesInZip.txt"

#has the name of the zip file regardles if a document was found in it, like
#  Zip-file: somezipfile.zip
#  Zip-file: otherzipfile.zip
#  Found: somedocument.pdf
#  Zip-file: yetanotherzipfile.zip
$logfile_detail = "C:\Users\$env:USERNAME\Downloads\FilesInZipDetail.txt"

#the name of the current zip file
$currentZip

#----------------------------------------------------
Function GetZipFileItems 
{ 
    Param([string]$zip) 

    $split = $split.Split(".")

    $shell   = New-Object -Com Shell.Application 
    $zipItem = $shell.NameSpace($zip) 
    $items   = $zipItem.Items()

    GetZipFileItemsRecursive $items
}

Function GetZipFileItemsRecursive 
{     
    Param([object]$items) 
    ForEach($item In $items) 
    {

        $item.getFolder | Out-File -FilePath $logfile -Append
        $strItem = [string]$item.Name 
        If ($strItem -Like "*$search*")
        { 
            "Found: $strItem in $currentZip" | Out-File -FilePath $logfile -Append
            "Found: $strItem" | Out-File -FilePath $logfile_detail -Append
            
        }
    }
}


if (test-path $logfile -PathType Leaf)
{
    Remove-Item $logfile -Confirm
}

if (test-path $logfile_detail -PathType Leaf)
{
    Remove-Item $logfile_detail -Confirm
}

$zipFiles = Get-ChildItem -Path $PathToZips -Recurse -Filter "*.zip" | ForEach-Object { $_.DirectoryName + "\$_" } 

ForEach ($zipFile In $zipFiles) 
{ 
    $split = $zipFile.Split("\")[-1] 
    "Zip-file: $split" | Out-File -FilePath $logfile_detail -Append
    $currentZip = $split
    GetZipFileItems $zipFile 
    
} 