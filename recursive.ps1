$b = 1
function getValue($a)
{
Write-Host $b $a
    if($a / 1024 -ge 1 -and $b -lt 4)
    {
        $a /= 1024
        $b++
        getValue $a
    }
    else
    {
        switch($b)
        {
            1 {$c = 'Byte'}
            2 {$c = 'KB'}
            3 {$c = 'MB'}
            4 {$c = 'GB'}
            default {$c = 'unknown'}
        }

        $x = $a,$c
        return $x
    }
}

$a = [math]::pow(1024,3)
$c = getValue $a

Write-Host "Result is: $c"