@echo off
::by GabiBrawl
title BEditor Setup
color 07
set wm=Shortcut
set BEditorS=BEditor.bat
set version=4


:set_editor
mode con: cols=50 lines=17
set editor=
cls
echo.
echo                  BEditor Setup V%version%
echo.
echo.
::by GabiBrawl
echo  Available text editing apps:
echo   1) Notepad        2) Sublime Text
echo   3) Notepad ++     4) VS Code
echo   5) Other app
echo.
echo  Other options:
echo   a) Toggle Working Mode: %wm% mode
echo   b) Help           c) About
echo.
echo  Input the value that corresponds to your choice
set /p editor=^>^> 
if not defined editor (call :blank_input && goto set_editor)
if "%editor%"=="1" (set app=notepad.exe && if not %wm%==Project (goto check_wm) else (goto notepad_wm_error))
if "%editor%"=="2" (set app=C:\Program Files\Sublime Text 3\sublime_text.exe && goto check_wm)
if "%editor%"=="3" (set app=C:\Program Files\Notepad++\notepad++.exe && goto check_wm)
if "%editor%"=="4" (set app=C:\Program Files\Microsoft VS Code\Code.exe && goto check_wm)
if "%editor%"=="5" (goto other_app)
if "%editor%"=="a" (if %wm%==Shortcut (set wm=Project) else (set wm=Shortcut)) && goto set_editor
if "%editor%"=="b" (goto help)
if "%editor%"=="c" (goto about)
if "%editor%"=="help" (goto help)
call :invalid_input
goto set_editor
call :blank_input


:other_app
set app=
mode con: cols=50 lines=11
cls
echo.
echo             -Your Own Text Editor-
echo.
echo.
echo  Input the location of your text editing app
echo  NOTE: DONT USE QUOTATION MARKS
echo  To go back, just hit [ENTER]
::by GabiBrawl
echo.
set /p app=^>^> 
if not defined app goto set_editor
if exist "%app%" (
   goto check_wm
)
mode con: cols=67 lines=5
cls
echo.
echo   The app you chose is not available, or not accessible by BEditor.
echo  Please try another location.
timeout /t 5 >nul
goto other_app


:check_wm
if exist %BEditorS% goto multiple
:coder_wm
cls
echo Working on it...
echo @echo off >>.\%BEditorS%
echo set "ScriptName=%%~nx0">>.\%BEditorS%
echo if "%%~1"^=^="" goto run_folder_as_project>>.\%BEditorS%
echo start "" "%app%" "%%~1">>.\%BEditorS%
echo Exit /B>>.\%BEditorS%
echo :run_folder_as_project>>.\%BEditorS%
if %wm%==Project (echo start "" ^"%app%^" "%%cd%%">>.\%BEditorS%) else (echo start "" "%app%">>.\%BEditorS%)
goto done


:notepad_wm_error
cls
echo.
echo  Notepad can't run folders as projects.
echo  You gotta chose another working mode for it.
echo.
call :press_any_key
goto set_editor


:multiple
mode con: cols=32 lines=4
cls
echo             -ERROR-
echo  "%BEditorS%" already exists.
echo       Overwrite? (y/n/ren)
set /p o=^>^> 
if %o%==y (del %BEditorS% && goto coder_wm)
if %o%==n (goto end)
if %o%==r (goto overwrite)
if %o%==ren (goto overwrite)
cls
call :invalid_input
goto multiple


:overwrite
mode con: cols=44 lines=6
cls
echo.
echo  Now input the name you want for your file.
set /p BEditorS1=^>^> 
set BEditorS="%BEditorS1%.bat"
echo  The value you entered is now set.
timeout /t 3 >nul
goto check_wm


:help
mode con: cols=59 lines=20
cls
echo.
echo                         -HELP file-
echo.
echo.
echo   This script creates another script that will simplify
echo  the opening of your files in various apps! Just be sure
echo  that the app you chose is compatible with the type of
echo  files you're willing to open.
echo.
echo   Working modes:
echo    -Shortcut mode: will make the script run the app you
echo    chose, without any arguments.
echo    -Project mode: will make the script run the app you
echo    chose, with the current folder as an argument.
echo.
echo   Simply chose an predefined option, or enter the location
echo  to your own app!
echo.
call :press_any_key
goto set_editor


:about
mode con: cols=102 lines=14
cls
echo.
echo                                             ---About---
echo.
echo  BEditor, as an initial project, was a simple batch file to help me open my text editor more easily.
echo  I started thinking about publishing it, BUT I wouldn't publish a simple file with 5 lines of code...
echo  That would seem such a dull project. So, I decided to create a simple setup. That "simple" setup
echo  turned to be a somehow complex setup... I guess it will complexify yet more in the near future! (:
echo  And here we are!
echo.
echo                                        Welcome to BEditor V%version%!
echo  by GabiBrawl, 21st march 2022
echo.
call :press_any_key
goto set_editor


:done
cls
echo  File successfully created!
echo  -by GabiBrawl
timeout /t 10 /nobreak>nul
exit /b

:end
cls
echo.
echo  Sorry but file creation failed.
echo  -by GabiBrawl
timeout /t 5 /nobreak>nul
exit /b


:invalid_input
echo  The value you entered is invalid. Try again!
timeout /t 2 >nul
exit /b
:blank_input
echo  The value you entered is blank. Try again!
timeout /t 2 >nul
exit /b
:press_any_key
echo  Press any key to go back...
pause >nul
exit /b