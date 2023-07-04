$inputXML = @"
<Window x:Class="SchoolCancellation.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:SchoolCancellation"
        mc:Ignorable="d"
        Title="School Cancellation" Height="272" Width="202" Background="#FF16A4D2">
    <Grid Margin="0,0,0,91.667" HorizontalAlignment="Left" Width="301">
        <Label Content="Date" HorizontalAlignment="Left" Margin="11,18,0,0" VerticalAlignment="Top" Height="34"/>
        <Button x:Name="btnNoSchool" Content="No school" HorizontalAlignment="Left" Margin="53,65,0,0" VerticalAlignment="Top" Width="101" Height="24"/>
        <Button x:Name="btnDelay" Content="2 hours delay" HorizontalAlignment="Left" Margin="53,94,0,0" VerticalAlignment="Top" Width="101" Height="24"/>
        <Button x:Name="btnEarly" Content="Early dismissal" HorizontalAlignment="Left" Margin="53,123,0,0" VerticalAlignment="Top" Width="101" Height="24"/>
        <DatePicker x:Name="tDate" HorizontalAlignment="Left" Margin="53,18,0,0" VerticalAlignment="Top"/>

    </Grid>
</Window>


"@

$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'
 
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')



 #===========================================================================
 #Read XAML
 #===========================================================================
 [xml]$XAML = $inputXML
 
 
 $reader=(New-Object System.Xml.XmlNodeReader $xaml)
 
 try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
 catch{Write-Error "Unable to load Windows.Markup.XamlReader. Double-check syntax and ensure .net is installed."}
  
 #===========================================================================
 
#===========================================================================
# Create PowerShell variables for Form Objects
$xaml.SelectNodes("//*[@Name]") | %{ 
    Set-Variable -Name "gui_$($_.Name)" -Value $Form.FindName($_.Name) 
    }
#===========================================================================

Function Get-FormVariables{
    write-host "Here is the list of GUI variables: " -ForegroundColor Cyan
    get-variable gui_*
}

Function writeInfo($InfoType)
{
    if($gui_tDate.SelectedDate)
    {
        if($gui_tDate.SelectedDate.Month -lt 7)
        {
            $FileName = "$($gui_tDate.SelectedDate.year - 1)_$($gui_tDate.SelectedDate.year)"
        }
        else {
            $FileName = "$($gui_tDate.SelectedDate.year)_$($gui_tDate.SelectedDate.year + 1)"
        }
        $File = "C:\Users\micha\Dropbox\YouAndI\Schule+Fussball\Schulausfalltage_$FileName.txt"
        Write-Output "$($gui_tDate.SelectedDate.ToShortDateString())`t$InfoType" | Out-File $File -Append
        $Form.Close()
    }    
}

$gui_btnNoSchool.Add_Click(
    {
      writeInfo("No school")
     }

)

$gui_btnDelay.Add_Click(
    {
      writeInfo("2 hours delay")
     }

)

$gui_btnEarly.Add_Click(
    {
        writeInfo("Early dismissal")
     }

)

$gui_tDate.SelectedDate = Get-Date

  $Form.ShowDialog() | out-null
 