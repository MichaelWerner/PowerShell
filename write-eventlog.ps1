new-eventlog -logname 'Application' -source 'MyScript'
Write-EventLog -LogName Application -Source 'MyScript' -EntryType Information -EventId 1 -Message "Test event"

new-eventlog -logname 'MyEvents' -source 'MyScript2'
Write-EventLog -LogName 'MyEvents' -Source 'MyScript2' -EntryType Information -EventId 1 -Message "Test event"