#Get list of namespaces available
gwmi -Namespace "root" -Class "__Namespace" | select name

#get list of classes in namespace
gwmi -Namespace "root\cimv2" -List | Out-GridView

#get properties of a class
gwmi -Class 'win32_logicaldisk' | select deviceID, volumename, freespace

#select using wql
gwmi -Query "select * from win32_computersystem"
gwmi -Query "select * from win32_physicalmemory"