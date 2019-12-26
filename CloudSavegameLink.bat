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
if not exist "!clouddir!" goto err_clouddir_not_found

echo savedir: !savedir!
echo clouddir: !clouddir!

echo [-] importing extra files from existing savedir...
robocopy /E /XC /XO /XN "!savedir!\\" "!clouddir!\\"

echo [-] removing savedir...

rem remove existing savedir symlink
if exist "!savedir!" (
  rmdir "!savedir!"
)
rem remove exisitng savedir with contents
if exist "!savedir!" (
  rmdir /S/Q "!savedir!"
)

echo [-] creating symlink...
mklink /D "!savedir!" "!clouddir!"

goto success

:err_config_not_found
echo config not found: !config!
goto end

:err_savedir_not_found
echo savedir not found or variable savedir not set: !savedir!
goto end

:err_clouddir_not_found
echo clouddir not found: !clouddir!
goto end

:err_usage
echo usage: %~nx0 "<clouddir>"
echo Replaces a savegame directory with a cloud directory location.
echo Note: The cloud directory needs to contain a config.bat which is expected to set the savedir variable to the 
echo       savegame direction of a game.
goto end

:success
goto end

:end
