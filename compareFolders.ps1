$source = get-childitem -Recurse -Path H:\OneDrive
$target = Get-ChildItem -Recurse -Path Z:\OneDrive


<#
SideIndicator
=> file is missing in the ReferenceObject ($source)
<= file is missing in the DifferenceObject ($target)
#>

Compare-Object -ReferenceObject $source -DifferenceObject $target
