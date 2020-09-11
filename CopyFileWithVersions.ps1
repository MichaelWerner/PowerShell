Add-Type -Assembly System.Windows.Forms

$source="C:\Users\mwerner\Downloads\jira-export.zip"
$today = Get-Date -format yyyyMMdd
$target="F:\Jira_Backups\"
$Leave=$FALSE

while (!(Test-Path $source) -and !$Leave) {

    $ButtonType = [System.Windows.Forms.MessageBoxButtons]::OKCancel
    $MessageIcon = [System.Windows.Forms.MessageBoxIcon]::Information
    $MessageBody = "Backup file not found.`n`nPlease download and click OK`nor click Cancel to exit."
    $MessageTitle = "Copy Jira Backup"

    $Result = [System.Windows.Forms.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)

    if ($Result -eq 'Cancel') {
        $Leave = $TRUE
    }
}

if (!$Leave){
    Move-Item -Path $source -Destination (Join-Path -Path $target -ChildPath "jira-$today.zip")

    #keep the last 10 files only
    $toDelete = (Join-Path -Path $target -ChildPath "jira-*.zip")
    $keep = 10
    $files = Get-ChildItem -Path $toDelete

    if ($files.Count -gt $keep) {
        $files | Sort-Object -Property CreationTime | Select-Object -First ($files.Count -$keep) | Remove-Item
        }
}else{
    $ButtonType = [System.Windows.Forms.MessageBoxButtons]::OK
    $MessageIcon = [System.Windows.Forms.MessageBoxIcon]::Warning
    $MessageBody = "Backup file not copied!`n`nYou need to run the script again or copy the file manually!"
    $MessageTitle = "Copy Jira Backup"

    $Result = [System.Windows.Forms.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
}
