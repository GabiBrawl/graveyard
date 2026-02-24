@echo off
title Checking for Permissions
mode con: cols=70 lines=9
:chk_admin
cls
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"


:clr_spool
title Clearing Printer Spooler
cls
echo ---------Detected Admin privileges---------
echo.
echo Stopping Printer Services
net stop spooler >nul
cd %systemroot%\system32\spool\PRINTERS\
echo Deleting Temporary Printer Files
::del /f /s *.SHD >nul
::del /f /s *.SPL >nul
del /f /s /q *.* >nul
echo Starting Printer Services
net start spooler >nul
echo.
echo Done! Printer Spooler was Successfully Reset! Press any key to exit...
::timeout /t 3 >nul | set /p "=Done! Printer Spooler was Successfully Reset!"
pause > nul
::pause > nul | set /p "=Done! Press any key to exit..."
exit
