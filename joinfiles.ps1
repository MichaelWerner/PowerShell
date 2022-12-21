$resultfile = C:\users\mwerner\Documents\all_meta_files.txt
$metafiles = Get-ChildItem Z:\GOLDMAN-OUT\archive\2021\metadata*.txt -Recurse

if(Test-Path $resultfile){
    Remove-Item $resultfile
}

New-Item -Name $resultfile -ItemType "file"

foreach($file in $metafiles){
    Add-content $resultfile -value $file.FullName
    get-content $file.FullName | Out-File $resultfile -append
}