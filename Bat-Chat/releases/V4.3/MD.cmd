@echo off
title Incoming Messages
color 4e
mode con: cols=63 lines=42
"nircmd.exe" win move ititle "Incoming Messages" 700 0


:home
if not exist .\chat goto create
cls
chgcolor 0F
echo Time: %time%                              Date: %date%
chgcolor 4e
type .\chat
echo.
timeout /t 1 >nul
goto home


:create
echo. >>.\chat.hys
echo ===============================================================>>.\chat
goto home