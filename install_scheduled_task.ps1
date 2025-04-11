$taskName = "DisableWakeTimersOnBoot"
$scriptPath = "$PSScriptRoot\disable_wakeup_2.ps1"

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest
$description = "Disables wake timers, device wake, and power plan triggers on system boot."

try {
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Description $description -Force
    Write-Output "✅ Scheduled task '$taskName' created successfully."
} catch {
    Write-Error "❌ Failed to create task: $($_.Exception.Message)"
}