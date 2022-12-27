param ([bool]$SendEmail = $False)

Function writeLogFile([string] $text)
{
   Add-content $Logfile -value $text
}

$baseDir = "\\1.2.3.4\someshare\somefolder\"
$target = $baseDir + "copy_here\"
$archive = $target + "\archive_here"
$Logfile = $baseDir + "logfiles\zip_and_email_files.log"
$csvFiles = $target + "*.csv"
$xlFiles = $target + "*.xl*"
$lError = $false
$lSend = $SendEmail

#to count the letters
$pdfs = $source + "*.pdf"


#email settings
$MailServer = "IP or name of the mail server"
$eMailSender = 'its_me@somedomain'
[string[]]$Recipients = "recipient1@somedomain,recipient2@somedomain.com"
$Subject = "Your files are available"
$BodyBase = "Hello,`n`nattached are the files`n"

#to count the letters
$pdfs = $target + "*.pdf"

#zip files can not be bigger than this
$iMaxSizeMB = 14

$i = 0
$j = 0

$zipFileBaseName = "requested_files." + (Get-Date -UFormat "%Y%m%d")

#how many zip files do we need
$NumZips = [math]::ceiling(([math]::ceiling((Get-ChildItem $pdfs  | Measure-Object Length -sum).sum) / 1MB) / $iMaxSizeMB)


$filesToCopy = Get-ChildItem $pdfs
$iFilesFound = $filesToCopy.Count
$newArchive = ''

if($iFilesFound -gt 0)
{
    #copy the files to separate folders
    while ($iFilesFound -gt 0)
    {
        $i++
        $filesToCopy = Get-ChildItem $pdfs
        $iFilesFound = $filesToCopy.Count

        #create a folder for the documents
        $newFolder = $zipFileBaseName + "(" + $i +")"

        $newArchive = $archive + "\" + $newFolder
      
        if(!(test-path $newArchive))
        {
            New-Item -Path $archive -Name $newFolder -ItemType "directory"
        }


        $log = "==========  Start archiving " + $filesToCopy.Count +" files ========== " + (Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p") + " ==========`n" 
        writeLogFile $log

        $iSizeMB = 0
        $j = 0
        while($iSizeMB -lt $iMaxSizeMB -and $iFilesFound -gt 0)
        {

            try
            {
                #without -ErrorAction Stop the try catch thing doesn't work
                #https://stackoverflow.com/questions/3097785/powershell-ioexception-try-catch-isnt-working
                $iSizeMB += $filesToCopy[$j].Length / 1MB
                if($iSizeMB -le $iMaxSizeMB -and $iFilesFound -gt 0)
                {
                    move-Item $filesToCopy[$j].FullName $newArchive -ErrorAction Stop
                    $j++
                    $log = "Moved " + $filesToCopy[$j].FullName + " to " + $newArchive
                    writeLogFile $log
                }

            }#try
            catch
            {
                $log = $filesToCopy[$j].FullName + " not archived!" + $_.Exception.Message
                writeLogFile $log
                $lError = $true 
            
            }#catch
            $iFilesFound--
        }#while($iSizeMB
    }#while ($iFilesFound

    #now add the csv and excel files
    try{
        #add the csv files
        move-Item $csvFiles $newArchive -ErrorAction Stop
        $log = "csv files added to the zip file"
        writeLogFile $log
    }#try
    catch
    {
        $log = "csv files not added!" + $_.Exception.Message
        writeLogFile $log
        $lError = $true
            
    }#catch

    try{
        #add the Excel files
        move-Item $xlFiles $newArchive -ErrorAction Stop
        $log = "Excel files added to the zip file"
        writeLogFile $log
    }#try
    catch
    {
        $log = "Excel files not added!" + $_.Exception.Message
        writeLogFile $log
        $lError = $true
            
    }#catch

    #all files added to folders, now zip them

    $zipFiles = $archive + "\" + $zipFileBaseName + "*"
    $NumZips = (Get-ChildItem $zipFiles).count

    for($i = 1; $i -le $NumZips; $i++)
    {

        $newArchive = $archive + "\" + $zipFileBaseName + "(" + $i + ")"
        $compress = $newArchive + "\*"

        if(test-path ($newArchive + ".zip"))
        {
            $log = "==========  Start zipping the folder ==========" + (Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p") + " ==========`n"  
            writeLogFile $log
            $log = "==========  !!! The zip file existed already !!! ========== Created _WHY.zip ==========`n"  
            writeLogFile $log

            #zip the folder
            Compress-Archive -Path $compress -DestinationPath ($newArchive + "_WHY.zip") -CompressionLevel Optimal
            $lError = $true
        }#if test-path
        else
        {
            #zip the folder
            $log = "==========  Start zipping the folder ==========" + (Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p") + " ==========`n" 
            writeLogFile $log
            Compress-Archive -Path $compress -DestinationPath ($newArchive + ".zip") -CompressionLevel Optimal
            
        }#else
    
        if( -not $lError)
        {
            $log = "==========  Testing the zip file ==========" + (Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p") + " ==========`n"
            writeLogFile $log

            #unzip so we know the zip is valid
            Expand-Archive -Path ($newArchive + ".zip") -DestinationPath ($archive + "\_ziptest" + $i)


            if ((Get-ChildItem $newArchive).count -eq (Get-ChildItem ($archive + "\_ziptest" + $i)).count)
            {

                $log = "==========  Archive complete ========== " + (Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p") + " ==========`n" 
                writeLogFile $log

                $log = "==========  Start clean-up ========== " + (Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p") + " ==========`n" 
                writeLogFile $log

                #clean-up
                Remove-Item ($newArchive + "\*.*")
                Remove-Item $newArchive
                Remove-item ($archive + "\_ziptest" + $i + "\*.*") -Recurse
                Remove-Item ($archive + "\_ziptest" + $i ) -Recurse
                $log = "==========  Clean-up complete ========== " + (Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p") + " ==========`n" 
                writeLogFile $log


            }#if $filesToCopy.count
            else
            {
                $log = "========== !!!  Error zipping files !!! ========== " + (Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p") + " ==========`n" 
                writeLogFile $log
            }#else
        } #if -not $lError

    }#for

    #check if there is only 1 zip and rename the file
    if($NumZips -eq 1)
    {
        $old = $newArchive + ".zip"
        $new = $archive + "\" + $zipFileBaseName + ".zip"
        Rename-Item -Path $old -NewName $new
        $log = "One zip only. Renamed " + $old + " to " + $new + "."
        writeLogFile $log
    }

    #Finally, send the emails
    if(-not $lError -and $lSend)
    {
        #now send emails
        $log = "==========  Sending email now ========== " + (Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p") + " ==========`n" 
        writeLogFile $log

        $i = 0
        foreach($zip in Get-ChildItem($zipFiles))
        {

            $i++
            $Body = $BodyBase + "This is email " + $i + " of " + $NumZips + ". (" + $zip.Name + ")"

            #Send-MailMessage -SmtpServer $MailServer -from $eMailSender -To $RecipientPNC -cc $RecipientIT -Subject $Subject -Body $Body -Attachments $zip.Fullname
            Send-MailMessage -SmtpServer $MailServer -from $eMailSender -To $RecipientPNC -Subject $Subject -Body $Body -Attachments $zip.Fullname
        }
    }#if -not $lError
    else
    {

        if($lError)
        {
            $log = "==========  !!! ERROR !!! email not sent ========== " + (Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p") + " ==========`n" 
            $Body = "Error processing files. Please check the log file."
        }
        else
        {
            $log = "==========  !!! lSend is $lSend !!! send email manually ========== " + (Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p") + " ==========`n" 
            $Body = "Send is $lSend ! Send email manually"
        }
        writeLogFile $log
        Send-MailMessage -SmtpServer $MailServer -from $eMailSender -To $RecipientIT -Subject $Subject -Body $Body 
    }
}#if($iFilesFound -gt 0)
else
{
    $log = "==========  No files to process ========== " + (Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p") + " ==========`n" 
    writeLogFile $log
}