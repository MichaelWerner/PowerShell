$BasePath='\\1.2.3.4\someshare\somefolder'
$AcctNoFile='_accounts.txt'
$SourcePath = $BasePath + '\_missedStatements'
$TargetPath = $BasePath + '\un encrypted pdfs'
$SearchPatternStart='files start with this text.*.'
$SearchPatternEnd='.*.PGP'
$NoStatementFile = $SourcePath + "\_noStatements.txt"
$LogFile=$SourcePath + "\_movelog.txt"

$AcctNos=get-content($SourcePath + '\' + $AcctNoFile)

$AcctNos.Length
$i=0
(Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p") > $LogFile
"No statements found for these accounts:" > $NoStatementFile

for($i = 0; $i -le $AcctNos.Length - 1; $i++)
{
    $SearchPattern = $SourcePath + '\' + $SearchPatternStart + $AcctNos[$i] + $SearchPatternEnd
    $NumFiles=(get-childitem $SearchPattern).count

    $logEntry = "Counter:" + $i + " - Account:" + $AcctNos[$i] + " - statements found: " + $NumFiles
    $logEntry >> $LogFile

    if($NumFiles -eq 0)
    {
        $AcctNos[$i] >> $NoStatementFile
    }
    else
    {
        get-childitem $SearchPattern | move-item -Destination $TargetPath
    }

    $i
}

(Get-Date -UFormat "%m/%d/%Y %I:%M:%S %p") >> $LogFile