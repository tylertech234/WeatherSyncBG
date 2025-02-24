# Define Task Name
$taskName = "WeatherSyncBG Update Wallpaper"

# Get script path
$scriptPath = (Get-Item -Path "$PSScriptRoot\Set-WeatherWallpaper.ps1").FullName

# Check if task already exists
$existingTask = Get-ScheduledTask | Where-Object {$_.TaskName -eq $taskName}
if ($existingTask) {
    Write-Output "Task '$taskName' already exists. Deleting and recreating..."
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

# Create Scheduled Task
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Hours 1) -RepetitionDuration (New-TimeSpan -Days 365)
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -LogonType Interactive
$task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Description "Updates wallpaper based on current weather"

Register-ScheduledTask -TaskName $taskName -InputObject $task

Write-Output "Scheduled task '$taskName' created successfully."
