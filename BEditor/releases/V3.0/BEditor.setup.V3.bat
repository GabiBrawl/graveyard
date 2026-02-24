@echo off
::by GabiBrawl
title Setup BEditor
color 07
set wm=Normal
set BEditorS=BEditor.bat


:set_editor
if %wm%==Normal (mode con: cols=52 lines=15) else (if not %wm%==Project (mode con: cols=54 lines=15) else (mode con: cols=53 lines=15))
set editor=
cls
echo  Working mode: %wm%; for detailed info type "-wm"
echo.
echo.
::by GabiBrawl
echo  Available text editing apps:
echo   1) Notepad        2) Sublime Text
echo   3) Notepad ++     4) Other app
echo.
echo  Other options:
echo   a) Toggle Working Mode
echo   b) Help           c) About
echo.
echo  Input the value that corresponds to your choice
set /p editor=^>^>
if not defined editor (goto blank)
if "%editor%"=="1" (set app=notepad.exe && if %wm%==Normal (goto check_wm1) else (if not %wm%==Project (goto check_wm2) else (goto notepad_wm_error)))
if "%editor%"=="2" (set app=C:\Program Files\Sublime Text 3\sublime_text.exe && if %wm%==Normal (goto check_wm1) else (if not %wm%==Project (goto check_wm2) else (goto check_wm3)))
if "%editor%"=="3" (set app=C:\Program Files\Notepad++\notepad++.exe && if %wm%==Normal (goto check_wm1) else (if not %wm%==Project (goto check_wm2) else (goto check_wm3)))
if "%editor%"=="4" (goto other_app)
if "%editor%"=="a" (if %wm%==Normal (set wm=Shortcut&& goto set_editor) else (if %wm%==Project (set wm=Normal&& goto set_editor) else (set wm=Project&& goto set_editor)))
if "%editor%"=="b" (goto help)
if "%editor%"=="c" (set goto1=set_editor && goto about)
if "%editor%"=="help" (goto help)
if "%editor%"=="-wm" (goto set_working_mode)
echo  The value you entered is invalid. Try again!
timeout /t 2 >nul
goto set_editor
:blank
echo  You can't leave this field blank. Try again!
timeout /t 2 >nul
goto set_editor


:set_working_mode
mode con: cols=51 lines=13
set editor=
cls
echo.
echo  Available working modes:
::by GabiBrawl
echo   1) Normal mode
echo   2) Shortcut mode
echo   3) Project mode
echo.
echo  Other options:
echo   a) Help
echo.
echo  Input the value that corresponds to your choice.
set /p editor=^>^>
if "%editor%"=="1" (set wm=Normal&& goto set_editor)
if "%editor%"=="2" (set wm=Shortcut&& goto set_editor)
if "%editor%"=="3" (set wm=Project&& goto set_editor)
if "%editor%"=="a" (goto help_wm)
echo  The value you entered is invalid. Try again!
timeout /t 3 >nul
goto set_working_mode


:other_app
set app=
mode con: cols=50 lines=7
cls
echo.
echo  Input the location of the text editing app
echo  NOTE: DONT USE QUOTATION MARKS
echo  To go back, use "-b"
::by GabiBrawl
set /p app=^>^>
if "%app%"=="-b" (goto set_editor)
if not defined app (
	echo  No app has been inputted. Try again.
	timeout /t 2 >nul
	goto other_app
) else (
	if exist "%app%" (
		if %wm%==Normal (
			goto check_wm1
		) else (
			if not %wm%==Project (
				goto check_wm2
			) else (
				goto check_wm3
			)
		)
	) else (
		mode con: cols=65 lines=5
		cls
		echo The app you chose is not available, or not accessible by BEditor.
		echo Please try another location.
		timeout /t 5 >nul
		goto other_app
	)
)


:check_wm1
set goto=check_wm1
if exist %BEditorS% goto multiple
:coder
cls
echo Working on it...
echo @echo off >>.\%BEditorS%
echo set "ScriptName=%%~nx0">>.\%BEditorS%
echo title Drag and Drop a Batch file over "%%ScriptName%%">>.\%BEditorS%
echo if "%%~1"^=^="" goto error>>.\%BEditorS%
echo start "" "%app%" "%%~1">>.\%BEditorS%
echo Exit /B>>.\%BEditorS%
echo.>>.\%BEditorS%
echo.>>.\%BEditorS%
echo :Error>>.\%BEditorS%
echo Mode 61,5 ^& color 4e>>.\%BEditorS%
echo echo^( ^& echo^(>>.\%BEditorS%
echo echo   You should drag and drop a batch file over "%%ScriptName%%">>.\%BEditorS%
echo echo   Or run in command line using this syntax:>>.\%BEditorS%
echo echo   "%%~nx0" [Path to your folder/file]>>.\%BEditorS%
echo Timeout /T 10 /nobreak^>nul ^&^& exit /b>>.\%BEditorS%
goto done



:check_wm2
set goto=check_wm2
if exist %BEditorS% goto multiple
:coder_wm2
cls
echo Working on it...
echo @echo off >>.\%BEditorS%
echo set "ScriptName=%%~nx0">>.\%BEditorS%
echo title Drag and Drop a Batch file over "%%ScriptName%%">>.\%BEditorS%
echo if "%%~1"^=^="" goto run_shortcut>>.\%BEditorS%
echo start "" "%app%" "%%~1">>.\%BEditorS%
echo Exit /B>>.\%BEditorS%
echo.>>.\%BEditorS%
echo.>>.\%BEditorS%
echo :run_shortcut>>.\%BEditorS%
echo start "" "%app%">>.\%BEditorS%
goto done


:check_wm3
set goto=check_wm3
if exist %BEditorS% goto multiple
:coder_wm3
cls
echo Working on it...
echo @echo off >>.\%BEditorS%
echo set "ScriptName=%%~nx0">>.\%BEditorS%
echo if "%%~1"^=^="" goto run_folder_as_project>>.\%BEditorS%
echo start "" "%app%" "%%~1">>.\%BEditorS%
echo Exit /B>>.\%BEditorS%
echo.>>.\%BEditorS%
echo.>>.\%BEditorS%
echo :run_folder_as_project>>.\%BEditorS%
echo start "" ^"%app%^" "%%cd%%">>.\%BEditorS%
goto done


:notepad_wm_error
cls
echo.
echo  Notepad can't run folders as projects.
echo  You gotta chose another working mode for it.
echo.
echo  Press any key to go back...
pause>nul
goto set_editor


:done
cls
echo  File successfully created!
echo  -by GabiBrawl
timeout /t 10 /nobreak>nul && exit /b


:multiple
mode con: cols=31 lines=4
cls
echo            -ERROR-
echo  "%BEditorS%" already exists.
echo      Overwrite? (y/n/ren)
set /p o=
if %o%==y (del %BEditorS% && goto %goto%)
if %o%==n (goto end)
if %o%==r (goto overwrite)
if %o%==ren (goto overwrite)
cls
echo The value you entered is invalid. Try again!
timeout /t 3 >nul
goto multiple



:end
cls
echo  Sorry but file creation failed.
echo  -by GabiBrawl
timeout /t 5 /nobreak>nul && exit /b


:overwrite
mode con: cols=44 lines=5
cls
echo  Input now the name you want for your file.
set /p BEditorS1= $
set BEditorS=%BEditorS1%.bat
echo  The value you entered is now set.
timeout /t 3 >nul
goto %goto%


:help
mode con: cols=59 lines=15
cls
echo.
echo                         -HELP file-
echo.
echo.
echo   This script creates another script that will simplify
echo  the opening of your files in various apps! Just be sure
echo  that the app you chose is compatible with file opening
echo  command.
echo.
echo   Simply chose an predefined option, or enter the location
echo  to your own app!
echo.
echo  Press any key to go back... && pause >nul && goto set_editor



:help_wm
mode con: cols=58 lines=13
cls
echo.
echo                  -WorkingMode HELP file-
echo.
echo   -Normal mode will make BEditor simply run on drag and
echo  drop of a file over BEditor.
echo   -Shorcut mode will make BEditor work as a shortcut too.
echo  Just double click it, and it will run the app you had
echo  defined earlier!
echo   -Project mode will make BEditor open the current
echo  folder as a project in the app you had defined earlier.
echo.
echo   Press any key to go back... && pause >nul && goto set_working_mode


:about
mode con: cols=102 lines=13
cls
echo                                           ---About---
echo.
echo  BEditor, as an initial project, was a simple batch file to help me open my text editor more easily.
echo  I started thinking about publishing it, BUT I wouldn't publish a simple file with 5 lines of code...
echo  That would seem a dull project. SO, I've decided to create a simple setup. That "simple" setup
echo  turned to be a somehow complex setup... I guess it will complexify yet more in the near future! (:
echo  And here we are!
echo.
echo                                      Welcome to BEditor V3!
echo  by GabiBrawl, 21st march 2022
echo.
echo  Press any key to go back...
pause>nul
goto %goto1%