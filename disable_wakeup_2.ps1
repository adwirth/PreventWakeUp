# Requires elevation, ideally run as TrustedInstaller for maximum effect
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logFile = "$env:USERPROFILE\DisableWakeTimers_$timestamp.log"

function Log {
    param([string]$msg)
    $msg | Tee-Object -FilePath $logFile -Append
}

Log "== Disable Wake Timers Script Started at $timestamp =="

# --- 1. Disable WakeToRun on all scheduled tasks ---
Log "`n-- Disabling WakeToRun on Scheduled Tasks --"

Get-ScheduledTask | Where-Object {
    $_.Settings.WakeToRun -eq $true -and $_.State -ne "Disabled"
} | ForEach-Object {
    $taskName = $_.TaskName
    $taskPath = $_.TaskPath
    try {
        $_.Settings.WakeToRun = $false
        Set-ScheduledTask -TaskName $taskName -TaskPath $taskPath -Settings $_.Settings
        Log "Disabled WakeToRun: $taskPath$taskName"
    } catch {
        Log "ERROR: Could not disable WakeToRun on $taskPath$taskName - $($_.Exception.Message)"
    }
}

# --- 2. List and optionally disable wake-enabled devices ---
Log "`n-- Wake-Capable Devices --"
$wakeDevices = powercfg -devicequery wake_armed
$wakeDevices | ForEach-Object {
    Log "Wake Enabled: $_"
}

# Optional: disable wake for all devices
$disableDeviceWakes = $true  # Set to $false to skip
if ($disableDeviceWakes) {
    foreach ($device in $wakeDevices) {
        try {
            powercfg -devicedisablewake "$device"
            Log "Disabled device wake: $device"
        } catch {
            Log "ERROR: Could not disable wake for device: $device"
        }
    }
}

# --- 3. Disable system wake timers in power plan ---
Log "`n-- Disabling Wake Timers in Power Plan --"

try {
    powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP ST_WAKEFROMANY 0
    powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP ST_WAKEFROMANY 0
    powercfg -setactive SCHEME_CURRENT
    Log "Wake timers disabled for AC and DC power"
} catch {
    Log "ERROR: Could not change wake timer settings: $($_.Exception.Message)"
}

# --- 4. Check any active wake timers ---
Log "`n-- Current Wake Timers --"
try {
    $timers = powercfg -waketimers
    if ($timers) {
        $timers | ForEach-Object { Log "Active Wake Timer: $_" }
    } else {
        Log "No active wake timers."
    }
} catch {
    Log "ERROR: Could not query wake timers: $($_.Exception.Message)"
}

Log "`n== Script Completed =="
Start-Sleep -Seconds 2
notepad $logFile