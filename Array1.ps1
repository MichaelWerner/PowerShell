cls
$array = 200,343,4,23,42,3,42,99,100
[int]$middle = $array.length / 2 
[int]$remainder = $array.length % 2  # is zero if the lenght is a even number
$middle = $middle + $remainder - 1   # need to subtract 1 because the array index starts with zero

#sort the array
$array = $array | Sort-Object

#second smallest number in in index 1
Write-Output "2nd smallest number is: " $array[1]

#second biggest number in in index length - 2 (because index starts at 0)
Write-Output "2nd biggest number is: " $array[$array.Length - 2]

#show the middle number
Write-Output "middle number is: " $array[$middle]

