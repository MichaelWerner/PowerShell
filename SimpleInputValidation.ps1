cls
[validaterange(1000, 10000)][double]$p = Read-Host -Prompt "Principal ampount: "
[double]$r = Read-Host -Prompt "Interest rate: "
[validaterange(1, 5)][int]$t = Read-Host -Prompt "How many years: "

$S = ($p * $r * $t) / 100
$youpay = $p + $s
Write-Output "Interest is $S, you pay $youpay"
