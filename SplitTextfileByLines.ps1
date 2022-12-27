$BasePath='\\172.33.1.38\DataProcess\DataProcess\Data Processing\Amex\Placement & Maintenance files received'
$AcctNoFile='accounts.txt'
$SourceFile = $BasePath + '\_multipleaccounts\_multiple.txt'
$TargetFile = $BasePath + '\_multipleaccounts\in\_xmultiple'

for($i = 0; $i -le 9; $i++)
{
    $j = $i * 1000
    $k = $j + 999

    $numbers = (Get-Content $SourceFile)[$j..$k]
    if($i -lt 10)
    {
        $OutFile = $TargetFile + '00' + $i + '.txt'
    }
    
    if($i -ge 10 -and $i -lt 100)
    {
        $OutFile = $TargetFile + '0' + $i + '.txt'
    }
    
    if($i -ge 100)
    {
        $OutFile = $TargetFile + $i + '.txt'
    }

    $numbers > $OutFile

}

write-host "Done"

