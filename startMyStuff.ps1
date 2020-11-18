#run only between 8 am and 5 pm Monday to Friday
if ((get-date).DayOfWeek -ne "Saturday" -and (Get-Date).DayOfWeek -ne "Sunday" -and (Get-Date).Hour -ge 8 -and (Get-Date).Hour -le 17) 
{
    start outlook
    start chrome
    #start whatever else you want to start    

    if ((get-date).DayOfWeek -eq "Thursday")
    {
        #start 
    }




    #assume this has been run already earlier this day so a clean-up is not necessary
    if ((Get-Date).Hour -le 9)
    { 
        #Clean the temp folder
        $temp = $env:TEMP
        $DeleteOlderThan = (Get-Date).AddDays(-2)

        #Delete all files older than a given day
        Get-ChildItem $temp -Recurse | Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $DeleteOlderThan } | Remove-Item 

        # Delete any empty directories left behind after deleting the old files.
        Get-ChildItem -Path $temp -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Recurse

        #rename all email archives
        $ProjectFolder="whereever the projects are"
        $today = '_' + (Get-Date -UFormat "%Y%m%d") + '.pst.' 
        Get-ChildItem $ProjectFolder\emails.pst -Recurse | Rename-Item -NewName {$_.Name -replace '.pst', $today}

        #delete all email archives older than a week
        #$DeleteOlderThan = (Get-Date).AddDays(-5)
        #Get-ChildItem $ProjectFolder\emails_*.pst -Recurse | Where-Object { $_.LastWriteTime -lt $DeleteOlderThan } | Remove-Item 
        
        #keep the last 3 email archives
        $keep = 3
        $files = Get-ChildItem $ProjectFolder\emails_*.pst -Recurse 
        if($files.Count -gt $keep)
        {
            $files | Sort-Object CreationTime | Select-Object -First ($files.Count - $keep) | Remove-Item 
        }
    }
}

