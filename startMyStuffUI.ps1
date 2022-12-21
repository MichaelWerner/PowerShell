#from: https://lazyadmin.nl/powershell/powershell-gui-howto-get-started/

function cleanUp{

    #Clean the temp folder
    $temp = $env:TEMP
    $DeleteOlderThan = (Get-Date).AddDays(-2)

    #Delete all files older than a given day
    Get-ChildItem $temp -Recurse | Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $DeleteOlderThan } | Remove-Item 

    # Delete any empty directories left behind after deleting the old files.
    Get-ChildItem -Path $temp -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Recurse

    #Clean the downloads folder
    $downloads = $env:userprofile + "\downloads "
    $DeleteOlderThan = (Get-Date).AddDays(-10).ToShortDateString()

    #Delete all files older than a given day
    Get-ChildItem $downloads -Recurse | Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $DeleteOlderThan } | Remove-Item

    # Delete any empty directories left behind after deleting the old files.
    Get-ChildItem -Path $downloads -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Recurse

}

function mapDrives{

    net use u: /d /y
    net use m: \\172.16.1.116\fileshares
    net use o: "\\172.33.1.38\Quality Control"
    net use r: \\w8srsftppd02\SFTP
    
    net use y: \\172.16.1.3\lit /user:mwerner
    #This works because it uses the same credentials
    #Providing the credentials results in system error 1219
    net use z: \\172.16.1.3\excel

}

function checkAll{
    $chkOutlook.Checked = $true
    $chkNpp.Checked = $true
    $chkChrome.Checked = $true
    $chkSlack.Checked = $true
    $chkKeepass.Checked = $true
    $chkExcel.Checked = $true
    $chkOneNote.Checked = $true
    $chkAHK.Checked = $true
    $chkZoom.Checked = $true
    $chkRDI.Checked = $true
    $chkRDIbkp.Checked = $true
    $chkIBM.Checked = $true
    $chkClean.Checked = $true
    $chkMap.Checked = $true
}

function uncheckAll{
    $chkOutlook.Checked = $false
    $chkNpp.Checked = $false
    $chkChrome.Checked = $false
    $chkSlack.Checked = $false
    $chkKeepass.Checked = $false
    $chkExcel.Checked = $false
    $chkOneNote.Checked = $false
    $chkAHK.Checked = $false
    $chkZoom.Checked = $false
    $chkRDI.Checked = $false
    $chkRDIbkp.Checked = $false
    $chkIBM.Checked = $false
    $chkClean.Checked = $false
    $chkMap.Checked = $false
}

function checkOthers{
    $chkOutlook.Checked = !($chkOutlook.Checked)
    $chkNpp.Checked = !($chkNpp.Checked)
    $chkChrome.Checked = !($chkChrome.Checked)
    $chkSlack.Checked = !($chkSlack.Checked)
    $chkKeepass.Checked = !($chkKeepass.Checked)
    $chkExcel.Checked = !($chkExcel.Checked)
    $chkOneNote.Checked = !($chkOneNote.Checked)
    $chkAHK.Checked = !($chkAHK.Checked)
    $chkZoom.Checked = !($chkZoom.Checked)
    $chkRDI.Checked = !($chkRDI.Checked)
    $chkRDIbkp.Checked = !($chkRDIbkp.Checked)
    $chkIBM.Checked = !($chkIBM.Checked)
    $chkClean.Checked = !($chkClean.Checked)
    $chkMap.Checked = !($chkMap.Checked)
}

#some basics
$checkboxFont = 'SegoeUI, 10'
$checkboxLeft = 40
$checkboxLeft2 = 200
$checkboxTopInit = 60
$checkboxSpacer = 20

# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create a new form
$StuffForm                    = New-Object system.Windows.Forms.Form
# Define the size, title and background color
$StuffForm.ClientSize         = '400,350'
$StuffForm.text               = "Start My stuff"
$StuffForm.BackColor          = "#5e98bf"


# Create a Title for our form. We will use a label for it.
$Titel                           = New-Object system.Windows.Forms.Label
# The content of the label
$Titel.text                      = "What do you want to start?"
# Make sure the label is sized the height and length of the content
$Titel.AutoSize                  = $true
# Define the minial width and height (not nessary with autosize true)
$Titel.width                     = 25
$Titel.height                    = 10
# Position the element (first value = distance from the left, second value = distance from the top in pixel)
$Titel.location                  = New-Object System.Drawing.Point(20,20)
# Define the font type and size
$Titel.Font                      = 'Microsoft Sans Serif,13'


#a check box
$checkboxTop = $checkboxTopInit
$chkOutlook = New-Object System.Windows.Forms.CheckBox
$chkOutlook.TabIndex = 1
$chkOutlook.Text = "Outlook"
$chkOutlook.Font = $checkboxFont
$chkOutlook.Checked = $true
$chkOutlook.AutoSize = $true
$chkOutlook.Location = New-Object System.Drawing.Point($checkboxLeft,$checkboxTop)

$checkboxTop += $checkboxSpacer
#a check box
$chkNpp = New-Object System.Windows.Forms.CheckBox
$chkNpp.TabIndex = 1
$chkNpp.Text = "Notepad++"
$chkNpp.Font = $checkboxFont
$chkNpp.Checked = $true
$chkNpp.AutoSize = $true
$chkNpp.Location = New-Object System.Drawing.Point($checkboxLeft,$checkboxTop)

#a check box
$checkboxTop += $checkboxSpacer
$chkChrome = New-Object System.Windows.Forms.CheckBox
$chkChrome.TabIndex = 1
$chkChrome.Text = "Chrome"
$chkChrome.Font = $checkboxFont
$chkChrome.Checked = $true
$chkChrome.AutoSize = $true
$chkChrome.Location = New-Object System.Drawing.Point($checkboxLeft,$checkboxTop)

#a check box
$checkboxTop += $checkboxSpacer
$chkSlack = New-Object System.Windows.Forms.CheckBox
$chkSlack.TabIndex = 1
$chkSlack.Text = "Slack"
$chkSlack.Font = $checkboxFont
$chkSlack.Checked = $true
$chkSlack.AutoSize = $true
$chkSlack.Location = New-Object System.Drawing.Point($checkboxLeft,$checkboxTop)

#a check box
$checkboxTop += $checkboxSpacer
$chkKeepass = New-Object System.Windows.Forms.CheckBox
$chkKeepass.TabIndex = 1
$chkKeepass.Text = "Keepass"
$chkKeepass.Font = $checkboxFont
$chkKeepass.Checked = $true
$chkKeepass.AutoSize = $true
$chkKeepass.Location = New-Object System.Drawing.Point($checkboxLeft,$checkboxTop)

#a check box
$checkboxTop += $checkboxSpacer
$chkExcel = New-Object System.Windows.Forms.CheckBox
$chkExcel.TabIndex = 1
$chkExcel.Text = "Excel"
$chkExcel.Font = $checkboxFont
$chkExcel.Checked = $true
$chkExcel.AutoSize = $true
$chkExcel.Location = New-Object System.Drawing.Point($checkboxLeft,$checkboxTop)

#a check box
$checkboxTop += $checkboxSpacer
$chkOneNote = New-Object System.Windows.Forms.CheckBox
$chkOneNote.TabIndex = 1
$chkOneNote.Text = "OneNote"
$chkOneNote.Font = $checkboxFont
$chkOneNote.Checked = $true
$chkOneNote.AutoSize = $true
$chkOneNote.Location = New-Object System.Drawing.Point($checkboxLeft,$checkboxTop)

#a check box
$checkboxTop += $checkboxSpacer
$chkAHK = New-Object System.Windows.Forms.CheckBox
$chkAHK.TabIndex = 1
$chkAHK.Text = "AHK"
$chkAHK.Font = $checkboxFont
$chkAHK.Checked = $true
$chkAHK.AutoSize = $true
$chkAHK.Location = New-Object System.Drawing.Point($checkboxLeft,$checkboxTop)

#a check box
#$checkboxTop = $checkboxTopInit
#$chkWebEx = New-Object System.Windows.Forms.CheckBox
#$chkWebEx.TabIndex = 1
#$chkWebEx.Text = "WebEx"
#$chkWebEx.Font = $checkboxFont
#$chkWebEx.Checked = $false
#$chkWebEx.AutoSize = $true
#$chkWebEx.Location = New-Object System.Drawing.Point($checkboxLeft2,$checkboxTop)

#a check box
$checkboxTop = $checkboxTopInit
$chkZoom = New-Object System.Windows.Forms.CheckBox
$chkZoom.TabIndex = 1
$chkZoom.Text = "Zoom"
$chkZoom.Font = $checkboxFont
$chkZoom.Checked = $false
$chkZoom.AutoSize = $true
$chkZoom.Location = New-Object System.Drawing.Point($checkboxLeft2,$checkboxTop)

#a check box
$checkboxTop += $checkboxSpacer
$chkIBM = New-Object System.Windows.Forms.CheckBox
$chkIBM.TabIndex = 1
$chkIBM.Text = "Client Access"
$chkIBM.Font = $checkboxFont
$chkIBM.Checked = $false
$chkIBM.AutoSize = $true
$chkIBM.Location = New-Object System.Drawing.Point($checkboxLeft2,$checkboxTop)

#a check box
$checkboxTop += $checkboxSpacer
$chkRDI = New-Object System.Windows.Forms.CheckBox
$chkRDI.TabIndex = 1
$chkRDI.Text = "RDI"
$chkRDI.Font = $checkboxFont
$chkRDI.Checked = $false
$chkRDI.AutoSize = $true
$chkRDI.Location = New-Object System.Drawing.Point($checkboxLeft2,$checkboxTop)

#a check box
#$checkboxTop += $checkboxSpacer
$chkRDIbkp = New-Object System.Windows.Forms.CheckBox
$chkRDIbkp.TabIndex = 1
$chkRDIbkp.Text = "Backup before start?"
$chkRDIbkp.Font = $checkboxFont
$chkRDIbkp.Checked = $false
$chkRDIbkp.AutoSize = $true
$chkRDIbkp.Location = New-Object System.Drawing.Point(($checkboxLeft2 + 60),$checkboxTop)


#a check box
$checkboxTop += $checkboxSpacer
$chkClean = New-Object System.Windows.Forms.CheckBox
$chkClean.TabIndex = 1
$chkClean.Text = "Clean up"
$chkClean.Font = $checkboxFont
$chkClean.Checked = $true
$chkClean.AutoSize = $true
$chkClean.Location = New-Object System.Drawing.Point($checkboxLeft2,$checkboxTop)

#a check box
$checkboxTop += $checkboxSpacer
$chkMap = New-Object System.Windows.Forms.CheckBox
$chkMap.TabIndex = 1
$chkMap.Text = "Drive mapping"
$chkMap.Font = $checkboxFont
$chkMap.Checked = $true
$chkMap.AutoSize = $true
$chkMap.Location = New-Object System.Drawing.Point($checkboxLeft2,$checkboxTop)

#OK button
$btnOK = New-Object System.Windows.Forms.Button
$btnOK.Text = "OK"
$btnOK.Width = 90
$btnOK.Height = 30
$btnOK.Font = $checkboxFont
$btnOK.BackColor = "#5eb7bf"
$btnOK.ForeColor = "#ffffff"
$btnOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
$btnOK.Location = New-Object System.Drawing.Point($checkboxLeft,300)

#Cancel button
$btnCancel = New-Object System.Windows.Forms.Button
$btnCancel.Text = "Cancel"
$btnCancel.Width = 90
$btnCancel.Height = 30
$btnCancel.Font = $checkboxFont
$btnCancel.BackColor = "#e37d34"
$btnCancel.ForeColor = "#000"
$btnCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$btnCancel.Location = New-Object System.Drawing.Point($checkboxLeft2,300)


#check all button
$btnChkAll = New-Object System.Windows.Forms.Button
$btnChkAll.Text = "Check all"
$btnChkAll.Width = 90
$btnChkAll.Height = 30
$btnChkAll.Font = $checkboxFont
$btnChkAll.BackColor = "#ede215"
$btnChkAll.ForeColor = "#000"
$btnChkAll.Add_click({checkAll})
$btnChkAll.Location = New-Object System.Drawing.Point(40,255)

#uncheck all button
$btnUnChkAll = New-Object System.Windows.Forms.Button
$btnUnChkAll.Text = "Uncheck all"
$btnUnChkAll.Width = 90
$btnUnChkAll.Height = 30
$btnUnChkAll.Font = $checkboxFont
$btnUnChkAll.BackColor = "#ede215"
$btnUnChkAll.ForeColor = "#000"
$btnUnChkAll.Add_click({uncheckAll})
$btnUnChkAll.Location = New-Object System.Drawing.Point(140,255)

#checkOthers button
$btnChkOthers = New-Object System.Windows.Forms.Button
$btnChkOthers.Text = "Check others"
$btnChkOthers.Width = 120
$btnChkOthers.Height = 30
$btnChkOthers.Font = $checkboxFont
$btnChkOthers.BackColor = "#ede215"
$btnChkOthers.ForeColor = "#000"
$btnChkOthers.Add_click({checkOthers})
$btnChkOthers.Location = New-Object System.Drawing.Point(240,255)


$StuffForm.CancelButton = $btnCancel

#add title and check boxes
$StuffForm.controls.AddRange(@($Titel,$chkOutlook,$chkNpp,$chkChrome,$chkSlack,$chkKeepass,$chkExcel,$chkOneNote,$chkAHK,$chkZoom,$chkRDI,$chkRDIbkp,$chkIBM,$chkClean,$chkMap))

#add buttons
$StuffForm.controls.AddRange(@($btnChkAll,$btnUnChkAll,$btnChkOthers,$btnOK,$btnCancel))

# Display the form
$result = $StuffForm.ShowDialog()


if ($result –eq [System.Windows.Forms.DialogResult]::Cancel)
{
    write-output 'cancel'
}
else
{
    if($chkClean.Checked){cleanUp }
    if($chkMap.Checked){mapDrives }

    if($chkOutlook.Checked){start-process outlook }
    if($chkNpp.Checked){start-process notepad++}
    if($chkChrome.Checked){start-process chrome}
    if($chkSlack.Checked){start-process C:\Users\mwerner\AppData\Local\slack\slack.exe}
    if($chkKeepass.Checked){start-process C:\Users\mwerner\Keepass\KeePass.exe C:\Users\mwerner\Keepass\mw.kdbx}
    
    if($chkExcel.Checked)
    {
        copy C:\Users\mwerner\Documents\Team\Tickets.xlsm F:\Backups\Laptop\Documents
        copy C:\Users\mwerner\Documents\Team\CTO.xlsm F:\Backups\Laptop\Documents
        start-process excel
    }
    
    if($chkOneNote.Checked){start-process onenote}
    if($chkAHK.Checked){start-process C:\Users\mwerner\Tools\AutoHotkey\myKeys.ahk}
    #if($chkWebEx.Checked){start-process "C:\Users\mwerner\AppData\Local\Programs\Cisco Spark\CiscoCollabHost.exe"}
    if($chkZoom.Checked){start-process "C:\Users\mwerner\AppData\Roaming\Zoom\bin\Zoom.exe"}
    if($chkIBM.Checked){start-process C:\Users\mwerner\IBM\IBM_I_Access_Client_Solutions\acsbundle.jar}
    if($chkRDI.Checked)
    {
        if($chkRDIBkp.Checked)
        {
            robocopy C:\Users\mwerner\IBM\RDIWorkspace F:\Backups\Laptop\IBM\RDIWorkspace /MIR /R:3 /W:10 /log+:F:\Backups\logs\rdiWorkspace_laptop.log
        }
        
        start-process "C:\Program Files\IBM\SDP\eclipse.exe"
    }

    

}
# SIG # Begin signature block
# MIIEFQYJKoZIhvcNAQcCoIIEBjCCBAICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUO+91C5dELL6o2sCt+ARxLJkJ
# RqygggItMIICKTCCAZKgAwIBAgIQqP9iuXh/fYpGvVuudrNhWzANBgkqhkiG9w0B
# AQUFADAeMRwwGgYDVQQDExNNaWNoYWVsc0NlcnRpZmljYXRlMB4XDTIxMDEwMTA1
# MDAwMFoXDTI3MDEwMTA1MDAwMFowHjEcMBoGA1UEAxMTTWljaGFlbHNDZXJ0aWZp
# Y2F0ZTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAvj4wRW47pI/oMz16kFhv
# +VMjzTtjoHphNsLs4x3tqiLfalBgt+T6zNhZx4jgbfNnK1Q8aL15JM0Z31aDrXjb
# PG8r8RYZBlnyvReUh83K8jiOaZNKnAmgI4VyyBx9f1Qw5SJRpTybXT/kZY5o48nW
# xvpOVGH9+SlPg2IzWkP0WzUCAwEAAaNoMGYwEwYDVR0lBAwwCgYIKwYBBQUHAwMw
# TwYDVR0BBEgwRoAQ6xo+SJwDP5s9AYFXf4V4BqEgMB4xHDAaBgNVBAMTE01pY2hh
# ZWxzQ2VydGlmaWNhdGWCEKj/Yrl4f32KRr1brnazYVswDQYJKoZIhvcNAQEFBQAD
# gYEAngbC/CNaQ/JXxnLLGRc6xBxDpo27lOIo/aNKA/AAinitIJMa3IdhTq541SFy
# moUUzc8ffTp4xwDSzutd22jciOzVyyDudv2GqrGFqSyXpwMbMQ93KfmsOg65fRCQ
# 9fHXoFUe7AUUHWJnHQQebRZ/THhWmvS9UheBbOZKyMRAVrIxggFSMIIBTgIBATAy
# MB4xHDAaBgNVBAMTE01pY2hhZWxzQ2VydGlmaWNhdGUCEKj/Yrl4f32KRr1brnaz
# YVswCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZI
# hvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcC
# ARUwIwYJKoZIhvcNAQkEMRYEFDchJbzMuBKYaZbQ0ApmZl5ggYxPMA0GCSqGSIb3
# DQEBAQUABIGAeyrjr4c/xyj0B+qerhtGEVRSHOXQX+js7rHPyTth0zH1zudiSXCN
# AYav/boWqtrHRRWjRtpXgknnoSi65ovVw+zhbHwt7nNkoZToauOuWyUyjB3iyhfd
# Zsysn05PLPXUw238xwZh7U1Ryms7W0W4HepCfO6ZigwNqpmBVYWJBPg=
# SIG # End signature block
