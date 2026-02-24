@echo off
::by GabiBrawl
title Setup your batch editor program.
color 07
mode con: cols=50 lines=9


:set_editor
cls
echo Chose the text editing app bellow
::by GabiBrawl
echo 1) Notepad
echo 2) Sublime Text
echo 3) Notepad ++
echo 4) Other text editor
echo 5) Help
echo.
echo Input the number that corresponds to your choice.
set /p editor=$ 
if "%editor%"=="1" (set app=notepad.exe && goto coder)
if "%editor%"=="2" (set app=C:\Program Files\Sublime Text 3\sublime_text.exe && goto coder)
if "%editor%"=="3" (set app=C:\Program Files\Notepad++\notepad++.exe && goto coder)
if "%editor%"=="4" (goto other_app)
if "%editor%"=="5" (goto help)
if "%editor%"=="Notepad" (set app="notepad.exe" && goto coder)
if "%editor%"=="Sublime Text" (set app=C:\Program Files\Sublime Text 3\sublime_text.exe && goto coder)
if "%editor%"=="Notepad ++" (set app=C:\Program Files\Notepad++\notepad++.exe && goto coder)
if "%editor%"=="Other" (goto other_app)
if "%editor%"=="help" (goto help)
:invalid
cls
echo The value you entered is invalid. Try again!
timeout /t 3 >nul
goto set_editor


:other_app
cls
echo Input the location of the text editing app
echo DONT USE QUOTATION MARKS
::by GabiBrawl
set /p app=
goto coder


:coder
:check
if exist BEditor.bat goto fail
cls
echo Working on it...
echo @echo off >>.\BEditor.bat
echo set "ScriptName=%%~nx0">>.\BEditor.bat
echo title Drag and Drop a Batch file over "%%ScriptName%%">>.\BEditor.bat
echo if "%%~1"^=^="" goto error>>.\BEditor.bat
echo start "" "%app%" "%%~1">>.\BEditor.bat
echo Exit /B>>.\BEditor.bat
echo.>>.\BEditor.bat
echo.>>.\BEditor.bat
echo :Error>>.\BEditor.bat
echo Mode 61,5 ^& color 4e>>.\BEditor.bat
echo echo^( ^& echo^(>>.\BEditor.bat
echo echo   You should drag and drop a batch file over "%%ScriptName%%">>.\BEditor.bat
echo echo   Or run in command line using this syntax:>>.\BEditor.bat
echo echo   "%%~nx0" [Path to your Batch file]>>.\BEditor.bat
echo Timeout /T 10 /nobreak^>nul ^&^& exit /b>>.\BEditor.bat
goto done


:done
cls
echo File successfully created!
echo by GabiBrawl
timeout /t 10 /nobreak>nul && exit /b


:fail
cls
echo           -ERROR-
echo "BEditor.bat" already exists.
echo Overwrite? (y/n)
set /p o=
if %o%==y (del "BEditor.bat" && goto coder)
if %o%==n (goto end)
cls
echo The value you entered is invalid. Try again!
timeout /t 3 >nul
goto fail



:end
cls
echo Sorry but file creation failed.
echo by GabiBrawl
timeout /t 5 /nobreak>nul && exit /b


:help
cls
echo                    -HELP file-
echo This file creates a batch file that will simplify
echo the editing of your batch files for editing!
echo.
echo Simply chose an option, or enter the direction to
echo your own text editing program!
echo.
echo Press any key to go back... && pause >nul && goto set_editor