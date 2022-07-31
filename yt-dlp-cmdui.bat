@echo off
set "version=v3.0.1"
title yt-dlp-cmdui %version%, Made by The-Saus
REM Config for yt-dlp-cmdui, made by The-Saus
REM %~dp0 means 'directory of script' i.e. where the script.bat file is

REM Path for temp files
set tmpPath=-P "temp:%~dp0.\tmp"

REM Path for video files
set vidPath=-o "%%(title)s\%%(title)s.%%(ext)s" -P "%~dp0.\Video Output"

REM Path for audio files
set audPath=-o "%%(title)s\%%(title)s.%%(ext)s" -P "%~dp0.\Audio Output"

REM Default Arguments for yt-dlp
set defaultArgs=--external-downloader=aria2c --external-downloader-args "-j 16 -x 16 -s 16 -k 1M" --no-warnings --progress --progress-template "download-title:%%(info.id)s-%%(progress.eta)s"--sponsorblock-remove default --throttled-rate 100K --write-link --embed-subs --embed-metadata --embed-thumbnail -c %tmpPath% -a "%~dp0.\URLs.txt"
echo:> debug.log
echo:defaultArgs = %defaultArgs% >> debug.log
SET >> debug.log
set debugMode=0 & REM 1 to enable, 0 to disable
IF %debugMode% EQU 1 GOTO dbug 2> nul
REM for debugging and testing purposes, to use type :dbug at any point and the script will start there instead of :Start
:Start
if not exist "%~dp0\aria2c.exe" goto dlARIA2C
if not exist "%~dp0\yt-dlp.exe" goto dlYTDLP
if not exist "%~dp0\ffmpeg.exe" goto dlFFMPEG
if not exist "%~dp0\ffprobe.exe" goto dlFFMPEG
echo: Checking for yt-dlp.exe updates...
yt-dlp -U
FOR /F "tokens=*" %%a in ('aria2c --dry-run  https://github.com/TheSaus/yt-dlp-cmdui/releases/latest ^| findstr -i -r -c:"Download complete.*/v.*"') do set "str=%%a"
set "result=%str:/=" & set "result=%"
:mainMenu
CLS
echo:
echo:      yt-dlp-cmdui %version%                
if %version% LSS %result% echo       Update Available!
echo: _______________________________________________________________________________
echo:
echo:      Download Media:
echo:      Preset       ^| Quality/Bitrate   ^| Overwrites     ^| Archive Usage ^| Container
echo: -------------------------------------------------------------------------------
echo:  [1] Audio Custom ^| Choose Bitrate    ^| You Choose     ^| You Choose    ^| MP3
echo:  [2] Audio Preset ^| 96kbps Bitrate    ^| Forced         ^| Yes           ^| MP3
echo:  [3] Video Custom ^| Choose Resolution ^| You Choose     ^| You Choose    ^| MP4
echo:  [4] Video Preset ^| 1080p Resolution  ^| Forced         ^| Yes           ^| MP4
echo: _______________________________________________________________________________
echo:
echo:      Download Files:
echo:      Downloader ^| Supported Download Type(s)              
echo: -------------------------------------------------------------------------------
echo:  [5] aria2c     ^| HTTP(S), BitTorrent, FTP, SFTP, Metalink
echo: _______________________________________________________________________________
echo:
echo:      Other Options:
echo: -------------------------------------------------------------------------------
echo:  [6] Clean the Script Directory [Deletes Output folders, tmp folder and logs]
echo:  [u] Update yt-dlp-cmdui
echo:
echo:  Awaiting keyboard input...
CHOICE /c 123456u /n
IF %ERRORLEVEL% EQU 7 GOTO update
IF %ERRORLEVEL% EQU 6 GOTO cleaner
IF %ERRORLEVEL% EQU 5 GOTO fileDL
IF %ERRORLEVEL% EQU 4 set res=1080 & set "pre=Preset" & set overwrite=--force-overwrites & set arc=--download-archive "archive.txt" & CALL :Options & GOTO vDLp
IF %ERRORLEVEL% EQU 3 GOTO vDL & set "pre=Custom"
IF %ERRORLEVEL% EQU 2 set abr=96K & set "pre=Preset" & set overwrite=--force-overwrites & set arc=--download-archive "archive.txt" & CALL :Options & GOTO aDLp
IF %ERRORLEVEL% EQU 1 GOTO aDL & set "pre=Custom"

:aDL
CALL :Options
CALL :exOptions
REM prompt for video max/preferred resolution
echo: 
echo:      Download Media -^> Audio %pre%
echo:      Select your preferred maximum Audio Bitrate
echo:      Bitrate ^| Notes
echo: -------------------------------------------------------------------------------
echo:  [1] 256kbps ^| Very High Quality, default for Apple Music
echo:  [2] 128kbps ^| High Quality, default for Youtube Music
echo:  [3] 96kbps  ^| Standard/Average Quality, default for Spotify
echo:  [4] 64kbps  ^| Low Quality, Best used for Talk Radio
echo:  [0] Return to Main Menu
echo:
echo:  Awaiting keyboard input...
CHOICE /c 12340 /n
IF %ERRORLEVEL% EQU 5 goto mainMenu
IF %ERRORLEVEL% EQU 4 set abr=64K
IF %ERRORLEVEL% EQU 3 set abr=96K
IF %ERRORLEVEL% EQU 2 set abr=128K
IF %ERRORLEVEL% EQU 1 set abr=256K
set abr >> debug.log
CLS
echo: 
echo:      Download Media -^> Audio %pre%-^> %abr%bps
echo: -------------------------------------------------------------------------------
echo:      Do you want to supply Custom Arguments for yt-dlp?
echo:      [Y] Yes  [N] No
choice /n
IF %ERRORLEVEL% EQU 2 goto aDLp
IF %ERRORLEVEL% EQU 1 break
echo:Input custom yt-dlp arguments, then press enter
set /p customArgs=
set customArgs >> debug.log
:aDLp
CLS
echo: 
echo:      Download Media -^> Audio %pre%-^> %abr%bps -^> Downloading
echo: -------------------------------------------------------------------------------
echo:      Starting Download(s), this might take a while...
yt-dlp %audPath% -f ba --extract-audio --audio-format mp3 --audio-quality %abr% %arc% %overwrite% %tsm% %defaultArgs% %customArgs%
timeout /t 5 2> nul
GOTO complete

:vDL
CALL :Options
CALL :exOptions
echo: 
echo:      Download Media -^> Video %pre%
echo:      Select your preferred maximum Video Resolution
echo:      Resolution ^| Common Nicknames
echo: -------------------------------------------------------------------------------
echo:  [1] 2160p      ^| UHD, Ultra High Definition, 4K
echo:  [2] 1440p      ^| QHD, Quad High Definition, 2K
echo:  [3] 1080p      ^| FHD, Full High Definition
echo:  [4] 720p       ^| HD, High Definition
echo:  [5] 480p       ^| SD, Standard Definition
echo:  [0] Return to Main Menu
echo:
echo:  Awaiting keyboard input...
CHOICE /c 123450 /n
IF %ERRORLEVEL% EQU 0 goto mainMenu
IF %ERRORLEVEL% EQU 5 set res=480
IF %ERRORLEVEL% EQU 4 set res=720
IF %ERRORLEVEL% EQU 3 set res=1080
IF %ERRORLEVEL% EQU 2 set res=1440
IF %ERRORLEVEL% EQU 1 set res=2160
echo:res = %res% >> debug.log
CLS
echo: 
echo:      Download Media -^> Video %pre%-^> %res%p
echo: -------------------------------------------------------------------------------
echo:      Do you want to supply Custom Arguments for yt-dlp?
echo:      [Y] Yes  [N] No
choice /n
IF %ERRORLEVEL% EQU 2 goto vDLp
IF %ERRORLEVEL% EQU 1 break
echo:Input custom yt-dlp arguments, then press enter
set /p customArgs=
set customArgs >> debug.log
:vDLp
CLS
echo: 
echo:      Download Media -^> Video %pre%-^> %res%p -^> Downloading
echo: -------------------------------------------------------------------------------
echo:      Starting Download(s), this might take a while...
yt-dlp %vidPath% -S "res:%res%,tbr" --merge-output-format mp4 --recode-video mp4 %arc% %overwrite% %tsm% %defaultArgs% %customArgs%
timeout /t 5 2> nul
GOTO complete

:fileDL
CLS
echo:
echo:      Download Files -^> aria2c
echo: -------------------------------------------------------------------------------
echo:
type URLs.txt > oldURLs.txt
echo:#Type or Paste all URLs you want downloaded, then save and exit. One URL per line > "%~dp0.\URLs.txt"
start "" /B /WAIT notepad.exe "%~dp0.\URLs.txt"
CLS
echo:
echo:      Download Files -^> aria2c -^> Downloading
echo: -------------------------------------------------------------------------------
echo:
aria2c -d "%~dp0.\File Output" -x 16 -s 16 -j 16 -k 1M --seed-time=0 --referer=* --seed-ratio=0.1 --file-allocation=prealloc --max-download-limit=0 --bt-max-peers=0 -i URLs.txt
timeout /t 5 2> nul
GOTO complete

:cleaner
CLS
rd /Q /S "%~dp0.\tmp" 2> nul
rd /Q /S "%~dp0.\Video Output" 2> nul
rd /Q /S "%~dp0.\Audio Output" 2> nul
rd /Q /S "%~dp0.\File Output" 2> nul
del "%~dp0.\debug.log" 2> nul
echo:Finished cleaning up
timeout /t 2 2> nul
GOTO complete

:complete
CLS
echo:
echo:      End of script
echo:
echo:      Return to Main Menu?
echo:      [Y] Yes  [N] No
choice /n
IF %ERRORLEVEL% EQU 2 EXIT
IF %ERRORLEVEL% EQU 1 GOTO mainMenu

:dlARIA2C
echo:aria2c.exe is required, but missing
echo:Would you like to download it?
CHOICE
IF %ERRORLEVEL% EQU 2 GOTO End
IF %ERRORLEVEL% EQU 1 echo Downloading...
powershell -command "Invoke-WebRequest -OutFile aria2c.zip -Uri https://github.com/aria2/aria2/releases/download/release-1.36.0/aria2-1.36.0-win-64bit-build1.zip" >> debug.log
powershell -command "Expand-Archive aria2c.zip -Force" >> debug.log
FOR /F "tokens=*" %%a in ('Where /R "%~dp0\." aria2c.exe') do SET arialocat=%%a
move "%arialocat%" "%~dp0\." >> debug.log
del "%~dp0\aria2c.zip" >> debug.log
rd /Q /S "%~dp0\aria2c" >> debug.log
if not exist "%~dp0\aria2c.exe" goto dlARIA2C && echo There appears to be an issue, retrying...
echo:aria2c has been downloaded 
echo:
GOTO Start

:dlYTDLP
echo:yt-dlp.exe is required, but missing
echo:Would you like to download it?
CHOICE
IF %ERRORLEVEL% EQU 2 GOTO End
IF %ERRORLEVEL% EQU 1 echo Downloading...
aria2c -x 16 -s 16 -j 16 -k 1M --referer=* --file-allocation=prealloc --max-download-limit=0 "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
if not exist "%~dp0\yt-dlp.exe" goto dlYTDLP && echo There appears to be an issue, retrying...
echo:yt-dlp has been downloaded
echo:
GOTO Start

:dlFFMPEG
echo:ffmpeg.exe and/or ffprobe.exe are required, but missing
echo:Would you like to download it?
CHOICE
IF %ERRORLEVEL% EQU 2 GOTO End
IF %ERRORLEVEL% EQU 1 echo Downloading...
aria2c -x 16 -s 16 -j 16 -k 1M --referer=* --file-allocation=prealloc --max-download-limit=0 -o "ffmpeg.zip" "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"
powershell -command "Expand-Archive ffmpeg.zip -Force"
FOR /F "tokens=*" %%a in ('Where /R "%~dp0\." ffmpeg.exe') do SET ffmpeg=%%a
FOR /F "tokens=*" %%a in ('Where /R "%~dp0\." ffprobe.exe') do SET ffprobe=%%a
move "%ffmpeg%" "%~dp0\." 2> nul
move "%ffprobe%" "%~dp0\." 2> nul
del "%~dp0\ffmpeg.zip" 2> nul
rd /Q /S "%~dp0\ffmpeg" 2> nul
if not exist "%~dp0\ffprobe.exe" GOTO dlFFMPEG && echo There appears to be an issue, retrying...
if not exist "%~dp0\ffmpeg.exe" GOTO dlFFMPEG && echo There appears to be an issue, retrying...
echo:ffmpeg and ffprobe have downloaded
echo:
GOTO Start

:Options
CLS
type URLs.txt > oldURLs.txt
echo:#Type or Paste all URLs you want downloaded, then save and exit. One URL per line > "%~dp0.\URLs.txt"
start "" /B /WAIT notepad.exe "%~dp0.\URLs.txt"
CLS
echo:
echo:      Download Thumbnails, Subtitles and Metadata as separate files?
echo:      [Y] Yes  [N] No
choice /n
IF %ERRORLEVEL% EQU 2 set tsm=--no-write-subs --no-write-thumbnail --no-write-info-json
IF %ERRORLEVEL% EQU 1 set tsm=--write-subs --write-thumbnail --write-info-json --convert-thumbnails png
CLS
EXIT /B

:exOptions
echo:      Should overwrites be allowed?
echo:      [Y] Yes  [N] No
choice /n
IF %ERRORLEVEL% EQU 2 set overwrite=--no-force-overwrites --no-overwrites
IF %ERRORLEVEL% EQU 1 set overwrite=--force-overwrites
set overwrite >> debug.log
CLS
echo:      Should the archive file be used?
echo:      The archive file prevents already-downloaded files from being re-downloaded
echo:      [Y] Yes  [N] No
choice /n
IF %ERRORLEVEL% EQU 2 set arc=--no-download-archive
IF %ERRORLEVEL% EQU 1 set arc=--download-archive "archive.txt"
set arc >> debug.log
CLS
EXIT /B

:update
del "%~dp0\yt-dlp-cmdui.zip"
rd /Q /S "%~dp0\yt-dlp-cmdui"
aria2c -x 16 -s 16 -j 16 -k 1M --referer=* --file-allocation=prealloc --max-download-limit=0 --allow-overwrite=true "https://github.com/TheSaus/yt-dlp-cmdui/releases/latest/download/yt-dlp-cmdui.zip"
timeout /t 1 > nul
powershell -command "Expand-Archive yt-dlp-cmdui.zip"
timeout /t 1 > nul
move /y "%~dp0\.\yt-dlp-cmdui\yt-dlp-cmdui.bat" "%~dp0\.\yt-dlp-cmdui.bat" && del "%~dp0\yt-dlp-cmdui.zip" && rd /Q /S "%~dp0\yt-dlp-cmdui" && EXIT 2> nul