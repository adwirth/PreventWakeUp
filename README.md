# 🔧 Disable Wake Timers on Windows (10 & 11)

This repository provides a secure and robust method to **disable all wake-up triggers** that can cause your Windows machine to wake from sleep or hibernation unexpectedly — particularly during the night.

The solution works reliably on both **Windows 10** and **Windows 11**, using a combination of PowerShell automation and optional persistent configuration via Task Scheduler.

---

## ⚙️ Features

- ✅ Disables all `WakeToRun` tasks (where permitted)
- ✅ Disables wake-enabled devices (e.g., mouse, NIC, USB hubs)
- ✅ Disables system wake timers in the active power plan
- ✅ Compatible with both **Windows 10** and **Windows 11**
- ✅ Optionally installs a **scheduled task** to re-apply the fix at boot
- ✅ Uses [`NanaRun/mINsUDO.exe`](https://github.com/M2Team/NanaRun) to gain **TrustedInstaller** privileges when necessary

---

## 📦 Contents

| File | Description |
|------|-------------|
| `disable_wakeup_2.ps1` | The core PowerShell script that performs all actions (safe, non-destructive) |
| `install_scheduled_task.ps1` | Installs a persistent fix as a SYSTEM-level scheduled task |
| `run_disable_wakeup_TI.bat` | Entry point to run the fix manually or install the scheduled task, auto-elevated via `mINsUDO.exe` |
| `mINsUDO.exe` | **⚠️ Not included** — must be downloaded separately to enable TrustedInstaller context |

---

## 📥 Dependencies

### Required:

- PowerShell 5.1+ (default on Windows 10 and 11)
- `mINsUDO.exe` (download manually)

> 🔗 Download `mINsUDO.exe` from:  
> [https://github.com/M2Team/NanaRun/releases](https://github.com/M2Team/NanaRun/releases)

Place `mINsUDO.exe` in the same folder as the other scripts.

---

## 🚀 Usage

### 🔹 One-Time Execution (disable wake triggers now)

1. Download or clone this repo
2. Place `mINsUDO.exe` in the same folder
3. Run `run_disable_wakeup_TI.bat`
4. Select option `[1]` to disable wake timers now

> The script logs output to a `.log` file and opens it in Notepad at the end.

---

### 🔸 Persistent Setup (apply fix at every boot)

1. Follow steps 1–3 above
2. Select option `[2]` to install the scheduled task

This creates a task named `DisableWakeTimersOnBoot`, running as `SYSTEM` at every startup. It re-applies all protections automatically.

#### ✅ To uninstall:
```powershell
Unregister-ScheduledTask -TaskName "DisableWakeTimersOnBoot" -Confirm:$false
```

## 🛡 Security and Stability Notes
- The script does not modify ACLs or deny permissions — unlike some older methods that use icacls to block UpdateOrchestrator tasks (which can break update processes).
- Using mINsUDO.exe -TI ensures the script runs with TrustedInstaller privileges, needed to disable some protected tasks.
- The script skips tasks or devices it cannot modify and logs all actions, including failures.

## 📓 License

MIT License. Use at your own risk.
