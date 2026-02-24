@echo off
:load
cls
title Settings loading
if exist config.sav (
call config.sav
set MSG=Configuration Loaded.
) else (goto CS)
mode con: cols=33 lines=23
if exist config.sav (
call config.sav
set MSG=Configuration Loaded.
) else (if not exist config.sav goto CS)
color %color%


:choice
title Bat-Chat settings
mode con: cols=33 lines=23
cls
echo            ________
echo            Settings
echo              BETA
echo.
echo Type 1 for screen color setting
echo        Type 2 for [none]
echo        Type 3 for [none]
echo         Type 4 to exit.
echo.
choice /c 1234 /n >nul
if %ERRORLEVEL%==1 goto C1
if %ERRORLEVEL%==2 (
   goto C2
   )
if %ERRORLEVEL%==3 C3
if %ERRORLEVEL%==4 exit
set /p SChoice=Choice:
if %SChoice% == 1 goto C1
if %SChoice% == 2 goto C2
if %SChoice% == 3 goto C3


:C1
mode con: cols=40 lines=23
cls
echo A color code is formed by 2 digits. The
echo  first one is the one of the bacground.
echo     The second one is for the text.
echo                  [XX]
echo    0 = Black       8 = Gray
echo    1 = Blue        9 = Light Blue
echo    2 = Green       A = Light Green
echo    3 = Aqua        B = Light Aqua
echo    4 = Red         C = Light Red
echo    5 = Purple      D = Light Purple
echo    6 = Yellow      E = Light Yellow
echo    7 = White       F = Bright White
echo.
set /p color=Enter color code:

goto setS1



:C2
pause


:C3
pause


:CS
cls
(
echo set color=%color%
::echo set STMM=%STMM%
::echo set LVL=%LVL%
) > config.sav
goto load


:setS1
fart.exe config.sav %color% %newc%