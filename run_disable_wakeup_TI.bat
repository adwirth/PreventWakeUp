@echo off
setlocal

:: Set paths
set "MINSUDO=%~dp0mINsUDO.exe"
set "SCRIPT=%~dp0disable_wakeup_2.ps1"
set "INSTALLTASK=%~dp0install_scheduled_task.ps1"

:: Check for TrustedInstaller SID (S-1-5-18)
whoami /user | find /i "S-1-5-18" >nul
if %errorlevel% neq 0 (
    echo Relaunching as TrustedInstaller using mINsUDO...
    "%MINSUDO%" -TI "%~f0"
    exit /b
)

:: Prompt user
echo ========================================
echo Run wakeup timer disabling script:   [1]
echo Install Scheduled Task (persistent): [2]
echo Exit:                                [3]
echo ========================================
set /p choice=Enter choice [1-3]: 

if "%choice%"=="1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%"
) else if "%choice%"=="2" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%INSTALLTASK%"
) else (
    echo Exiting.
)

pause