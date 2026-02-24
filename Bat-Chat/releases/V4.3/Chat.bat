@echo off
:load
title Command Prompt Chat loading
if not exist config.sav goto createtxtconfig
if not exist users goto creatediruser
< config.sav (
  set /p color=
)
mode con: cols=70 lines=15
color %color%


:login
color %color%
title Command Prompt Chat LogIn
mode con: cols=70 lines=15
cls
echo 			------------------
echo 			Log-In to Bat-Chat
echo.
echo.
echo.
echo        Please type your username and press enter.
echo      [To Create an Account, type 1 and Press Enter]
echo          [For Settings, type 2 (STILL IN BETA)]
echo.
set /p username=Username:
if %username% == 1 goto create_account
if %username% == 2 goto configeditor
if %username% == /ladmin goto ccs
cls

echo 			------------------
echo 			Log-In to Bat-Chat
echo.
echo.
echo.
echo      Please type your password and press enter.
echo Info: Wile you type, your password will be invisible.
echo.
setlocal
set /P "=_" < NUL > "Enter password"
findstr /A:07 /V "*" "Enter password" NUL > CON
del "Enter password"
set /P "password="
cls


if exist ".\users\%username%.dll" goto password_check
:incorrect_credentials
cls
echo I'm sorry, but those credentials were not found. Please try again.
timeout /t 3 >nul
goto login


:password_check
set /p password_file=<".\users\%username%.dll"
if %password_file%==%password% goto correct_credentials
goto incorrect_credentials

:create_account
cls
echo 			_________________
echo 			Create an Account
echo 			-----------------
echo.
echo.
echo 		Please enter your desired Username.
echo.
set /p new_username=Username:
goto usr_check

:usr_check
if exist ".\users\%new_username%.dll" (goto usr_error) else (goto usr_password)

:usr_error
cls
echo Sorry. This username is taken, pick another one!
timeout /t 3 >nul
goto create_account

:usr_password
cls
echo 			_________________
echo 			Create an Account
echo 			-----------------
echo.
echo.
echo 		  Please enter your desired Password.
echo.
set /p new_password=Password:
echo %new_password% >".\users\%new_username%.dll"
echo.
echo Account Successfully Created!
timeout /t 2 >nul
goto login



:correct_credentials
start cmd /c ".\PBMD.cmd"
timeout /t 3
title Chatting as %username%
echo. >>.\chat
echo System: %username% joined the room at %time% >>chat
echo. >>.\chat
goto messages_sender


:ccs
cls
echo ---------------------
echo Secret Session Log-in
echo.
echo.
echo.
echo Please type your username and press enter.
echo.
set /p username=Username:
cls
goto cco


:cco
start cmd /c ".\PBMD.cmd"
timeout /t 3
title Chatting as %username%
goto messages_sender


:messages_sender
color 1F

cls
mode con: cols=54 lines=4
set /p input=Message:
if "%input%"=="" goto messages_sender
if "%input%"=="/exit" goto exit
if "%input%"=="/cls" goto cls
if "%input%"=="/cls -admin" goto cls_admin
if "%input%"=="/cls -admin -s" goto cls_admin_s
if "%input%"=="/logout" goto logout
if "%input%"=="/dcu" goto dcu
if "%input%"=="/help" goto help
if "%input%"=="/rp" goto passreset
if "%input%"=="/md" start MD.cmd


echo %username%: %input% >>chat
echo %username%: %input% >>hpchat.lock
set input=
goto messages_sender


:exit
taskkill /f /fi "windowtitle eq Incoming Messages" >nul 2>&1
echo. >>.\chat
echo System: %username% left the room  at %time%>>chat
echo System: %username% left the room at %time%>>hpchat.lock
echo. >>.\chat
exit


:cls
del chat
timeout /t 2
echo. >>.\chat
echo System: %username% cleared the screen>>chat
echo System: %username% cleared the screen at %time%>>hpchat.lock
echo. >>.\chat
goto messages_sender


:cls_admin
del chat
timeout /t 2
echo. >>.\chat
echo System: An admin cleared the screen >>chat
echo. >>.\chat
goto messages_sender


:cls_admin_s
del chat
goto messages_sender


:logout
taskkill /f /fi "windowtitle eq Incoming Messages" >nul 2>&1
echo. >>.\chat
echo System: %username% left the room at %time%>>chat
echo. >>.\chat
goto login


:help
start help.cmd
goto messages_sender


:creatediruser
md users
goto load


:createtxtconfig
(
  echo 07
) > config.sav
goto load


:dcu
taskkill /f /fi "windowtitle eq Incoming Messages" >nul 2>&1
del ".\users\%username%.dll"
echo. >>.\chat
echo System: %username% deleted his account >>chat
echo. >>.\chat
goto login


:reload_settings
title Command Prompt Chat reloading
< config.sav (
  set /p color=
::  set /p size=
::  set /p size1=
)
mode con: cols=70 lines=15
color "%color%"
goto messages_sender


:passreset
mode con: cols=54 lines=15
color 07
cls
set /p new_reset_password=New password:
break>".\users\%username%.dll"
echo %new_reset_password% >".\users\%username%.dll"
cls
echo New Password set!
timeout /t 2 >nul
goto messages_sender


:configeditor
cls
echo  Start by typing the new color code:
echo   [Type /help for color code help]
echo    [Press enter to apply changes]
echo      Predefined value: 07 or 03
set /p newc=Type now: 
if "%newc%"=="/help" GOTO hc
fart.exe config.sav %color% %newc%
echo Setting saved!
timeout /t 2 >nul
::------------------------------------Non working zone--------------------------------------------
::cls
::echo Now type the new window size (cols):
::echo    [Press enter to apply changes]
::echo         Predefined value: 70
::set /p news=Type now: 
::fart.exe config.sav "cols=%size%" "cols=%news%"
::echo Setting saved!
::timeout /t 2 >nul
::cls
::echo Now type the new window size (lines):
::echo     [Press enter to apply changes]
::echo         Predefined value: 15
::set /p news=Type now: 
::fart.exe config.sav lines=%size% lines=%news%
::echo Setting saved!
::timeout /t 2 >nul
::-------------------------------------------------------------------------------------------------
goto load


:hc
start HC.cmd
goto configeditor