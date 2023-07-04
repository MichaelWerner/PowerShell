cls
$files = Get-ChildItem -Path "D:\PowerShell\testfolder" -Filter "*.emp"
$outfile = "C:\temp\eligible.csv"
Write-Output "name`tempno`tstart`teligable" > $outfile

foreach($file in $files)
{
  
    $info = $File.BaseName.Split("_")
    $name=$info[0]
    $empno=$info[1]
    $start=$info[2]
    $eligible = "No" #unless proven otherwise

    #converting date from string to datetime object(Typecasting)
    $StartDate=[datetime]::ParseExact($start, "yyyy-mm-dd", $null)
    
    if($StartDate.AddYears(5) -le (Get-Date))
    {
        $eligible = "Yes"
    }

    Write-Output $name`t$empno`t$start`t$eligible >> $outfile
}