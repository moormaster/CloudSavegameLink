@echo off
setlocal enableextensions enabledelayedexpansion

rem remove " from cloud target dir
set clouddir="%~f1"
set clouddir=!clouddir:"=!

if "!clouddir!" == "" goto err_usage

rem remove trailing backslash from cloud target dir
set clouddir="!clouddir!"
if "%clouddir:~-2,-1%" == "\" (
  set clouddir="%clouddir:~1,-2%"
)
set clouddir=!clouddir:"=!

if "!clouddir!" == "" goto err_usage

rem read global-config.bat
if exist "%~dp0global-config.bat" call "%~dp0global-config.bat"

rem read cloud target dir specific config.bat
set config=!clouddir!\config.bat
if not exist "!config!" goto err_config_not_found
call "!config!"

rem sanity checks
if not exist "!savedir!" goto err_savedir_not_found
if not !savefiles! == "" (
  for %%f in (!savefiles!) do (
    rem remove quotes from filename
    set filename=%%f
    set filename=!filename:"=!

    if not exist "!savedir!\\!filename!" goto err_savefiles_not_found
  )
)
if not exist "!clouddir!" goto err_clouddir_not_found

echo savedir: !savedir!
if not "!savefiles!" == "" ( echo savefiles: !savefiles! )
echo clouddir: !clouddir!

echo [-] importing extra files from existing savedir...
if "!savefiles" == "" (
  robocopy /E /XC /XO /XN "!savedir!\\" "!clouddir!\\"
) else (
  for %%f in (!savefiles!) do (
    rem remove quotes from filename
    set filename=%%f
    set filename=!filename:"=!

    if not exist "!clouddir!\\!filename!" (
      copy "!savedir!\\!filename!" "!clouddir!\\"
    )
  )
)

if "!savefiles!" == "" (
  echo [-] removing savedir...
  rem remove existing savedir symlink
  if exist "!savedir!" (
    rmdir "!savedir!"
  )
  rem remove exisitng savedir with contents
  if exist "!savedir!" (
    rmdir /S/Q "!savedir!"
  )
) else (
  echo [-] removing savefiles...
  rem remove existing symlinks to savefiles
  for %%f in (!savefiles!) do (
    rem remove quotes from filename
    set filename=%%f
    set filename=!filename:"=!

    del /F/Q "!savedir!\\!filename!"
  )
)

if "!savefiles!" == "" (
  echo [-] creating symlink to savedir...
  mklink /D "!savedir!" "!clouddir!"
) else (
  echo [-] creating symlinks to savefiles...
  for %%f in (!savefiles!) do (
    rem remove quotes from filename
    set filename=%%f
    set filename=!filename:"=!

    mklink "!savedir!\\!filename!" "!clouddir!\\!filename!"
  )
)

goto success

:err_config_not_found
echo config not found: !config!
goto end

:err_savedir_not_found
echo savedir not found or variable savedir not set: !savedir!
goto end

:err_savefiles_not_found
echo one or more of the save files could not be found: !savefiles!
goto end

:err_clouddir_not_found
echo clouddir not found: !clouddir!
goto end

:err_usage
echo usage: %~nx0 "<clouddir>"
echo Replaces a savegame directory or a set of savegame files with a cloud directory location.
echo Note: The cloud directory needs to contain a config.bat containing either:
echo       a) if the game has a savegame directory:
echo           set savedir=C:\Path\To\Game\SavegameDirectory
echo ^ 
echo       or b) if the game stores savegames in separate files within the game directory
echo           set savedir=C:\Path\To\Game
echo           set savefiles=savefile1.sav savefile2.sav
goto end

:success
goto end

:end
