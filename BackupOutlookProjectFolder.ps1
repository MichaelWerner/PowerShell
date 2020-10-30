Function writeLogFile([string] $text)
{
   Add-content $strLogfile -value $text
}

function backupFolder($Folder){

    #Replace the email address with the base path
    $strBackupPath = $Folder.FolderPath.Replace("$strOutlookBasePath", $strBackupBasePath)
    $strBackupFile = $strBackupPath + "\emails.pst"  

    If (!(test-path $strBackupBasePath))
    {
        md $strBackupBasePath
    }

    if(Test-Path $strBackupFile)
    {
        #Must do this because I can copy all only
        Remove-Item $strBackupFile
    }

    #add the backup file to outlook
    $mapi.AddStore($strBackupFile)
    $BackupFolder = $mapi.Folders.GetLast()

    #copy the emails
    #$Folder.CopyTo($BackupFolder)

    $log = "Backup done: " + $Folder.FolderPath + " to: " + $strBackupFile + " " + $Folder.Items.Count + " emails."
    writeLogFile $log

    #remove the backup file from outlook
    $mapi.RemoveStore($BackupFolder)


}

function getFolders($BaseFolder)
{
    $NumFolders = [int]$BaseFolder.Folders.Count

    [int]$i = 1
    
    If($NumFolders -gt 0)
    {
        For($i = 1; $i -le $NumFolders; $i++)
        {   
            $SubFolder = $BaseFolder.Folders.Item($i)
            
            If($SubFolder.Folders.Count -gt 0)
            {
                getFolders $SubFolder
            }
            Else
            {
                backupFolder $SubFolder
            }
        }
    }

}

#========== main block ==========================
#It starts here. Powershell requires that functions are written before they are used

$strLogfile = "c:\logs\outlook_backup.txt"
$strOutlookProjectFolder = "Projects"
$strOutlookBasePath = "\\email@address.com\" + $strOutlookProjectFolder

#The path to the backup folder
$strBackupBasePath = "D:\Backup\Projects"
    
#===== No changes should be needed below this line ===================================


# Instantiate a new Outlook object
$ol = new-object -comobject "Outlook.Application";

# Map to the MAPI namespace
$mapi = $ol.getnamespace("mapi");

# Get the project folder
# GetDefaultFolder(6) is the inbox, my projects are not in the inbox so I go to the parent 
# and get the project folder
$ProjectFolder = $mapi.GetDefaultFolder(6).parent.folders($strOutlookProjectFolder)

$LogTime = Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p"
$log = "========== Backup started ========== " + $LogTime + " ==========" 
writeLogFile $log

#get all folders underneath he project folder and copy the emails to a pst
getFolders $ProjectFolder

$LogTime = Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p"
$log = "========== Backup completed ========== " + $LogTime + " ==========" 
writeLogFile $log
writeLogFile " "

