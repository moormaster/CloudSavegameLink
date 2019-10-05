# CloudSavegameLink

A simple set of batch scripts for replacing save games directories of games with symlinks to cloud synced directories

## Usage

1. Place the script in any directory
2. Optionally create a _global-config.bat_ file in the same directory

        + C:\..\ScriptDir  
        |-- CloudSavegameLink.bat     core script
        |-- global-config.bat         optional script where additional global variables can be set

2. For each game ...
    1. find out the savegame location ( i.e. by looking it up on https://pcgamingwiki.com/wiki/Home )
    2. create a folder with a config.bat containing one line:

            set savedir=C:\Savegame\Path\Of\Game

    3. execute cmd.exe **with administrator rights** _(needed for creating symlinks to directories)_

            C:\..\ScriptDir\CloudSavegameLink.bat "C:\..\CloudSyncedDir\Savegames\MyFavoriteGame"

## Example

You have created a _global-config.bat_ like this:

        + C:\Scripts
        |-- global-config.bat
            set steamdir=C:\Games\Steam\SteamApps\common
            set origindir=C:\Games\Origin Games

Your cloud synced directory could look like

        + C:\Dropbox
        |-+ Savegames
        | |-+ MyFavoriteGame
        | | |-- config.bat:
                    set savedir=C:\Savegame\Path\Of\MyFavoriteGame 
        | |-+ SteamGame
        | | |-- config.bat:
                    set savedir=%steamdir%\SteamGame\saves
        | |-+ OriginGame
        | | |-- config.bat:
                    set savedir=%origindir%\OriginGame\saves
        | |-+ OtherGame
        | | |-- config.bat:
                    set savedir=C:\Some\Other\Game\saves

To replace the original savegame locations of each game you ran the following commands in cmd.exe

        C:\Scripts\CloudSavegameLink.bat "C:\Dropbox\Savegames\MyFavoriteGame"
        C:\Scripts\CloudSavegameLink.bat "C:\Dropbox\Savegames\SteamGame"
        C:\Scripts\CloudSavegameLink.bat "C:\Dropbox\Savegames\OriginGame"
        C:\Scripts\CloudSavegameLink.bat "C:\Dropbox\Savegames\OtherGame"

The savegame directories of your games are now linked to the dropbox location

        C:\Savegame\Path\Of\MyFavoriteGame              <==> C:\Dropbox\Savegames\MyFavoriteGame
        C:\Games\Steam\SteamApps\common\SteamGame\saves <==> C:\Dropbox\Savegames\SteamGame
        C:\Games\Origin Games\OriginGame\saves          <==> C:\Dropbox\Savegames\OriginGame
        C:\Some\Other\Game\saves                        <==> C:\Dropbox\Savegames\OtherGame
