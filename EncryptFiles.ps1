Function writeLogFile([string] $text)
{
   Add-content $Logfile -value $text
}

$baseDir = "\\server\share\folder\"

#$source = $baseDir + "goldman-out\"
$source = $baseDir + "subfolder1\subfolder2\"

$Logfile = $basedir + "subfolder\logfiles\encrypt.log"


$letters = $source + "*.pdf"
$metafile = $source + "*.txt"
$EncryptError = $false


#email settings
$MailServer = "IP or name of the mail server"
$eMailSender = 'its_me@somedomain'
[string[]]$Recipients = "recipient1@somedomain,recipient2@somedomain.com"
$SubjectBase = "Your files are available"



$log = "========== Start encrypting the files ========== " + (Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p") + " ==========" 
writeLogFile $log

foreach($file in Get-ChildItem $letters){
    try
    {
       $target = $file.FullName + ".pgp"
       $target
       gpg --encrypt --recipient <PGP-Key(s)> --output $target $file.FullName

       $log = "Encrypted file " + $file.FullName + " to " + $target
       writeLogFile $log
    }
    catch
    {
        $log = $file.FullName + " not encrypted!" + $_.Exception.Message
        writeLogFile $log
        $EncryptError = $true    
    }
}

$log = "==========  Encryption complete ========== " + (Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p") + " ==========`n" 
writeLogFile $log

if($EncryptError){
    #send email that encryption was not done completely
    $Subject = $SubjectBase + " - encryption not complete"
    $Body = "Hello,`n`nNot all files could be encrypted sucessfully.`nPlease see the logfile for details."
}else{
    #send email that encryption was not completely
    $Subject = $SubjectBase + " - letters are encrypted"
    $Body = "Hello,`n`nall letters have been encrypted."
}
    Send-MailMessage -SmtpServer $MailServer -from $Sender -to $RecipientDP -Cc $RecipientIT -Subject $Subject -Body $Body    

