@echo off
REM temp path
set tmpPath=-P "temp:%~dp0.\tmp"
REM thumbnail path
set thumPath=-P "thumbnail:Thumbnails"
REM metadata path
set metaPath=-P "infojson:Metadata"
REM subtitles path
set subtPath=-P "subtitle:Subtitles"
REM link path
set linkPath=-P "link:Links"
REM combine all %xPath%
set allPath=%pPath% %tmpPath% %thumPath% %metaPath% %subtPath% %linkPath%
REM video file path
set vidPath=-o "%%(title)s.%%(ext)s" -P "%~dp0.\Video Output"
REM audio file path
set audPath=-o "%%(title)s.%%(ext)s" -P "%~dp0.\Audio Output"
REM default arguments for yt-dlp
set defaultArgs=--external-downloader=aria2c --external-downloader-args "-j 16 -x 16 -s 16 -k 1M" --no-warnings --progress --sponsorblock-remove default --throttled-rate 100K --write-link -c %allPath% -a "%~dp0.\URLs.txt"
REM default values for thumbnail writing/embedding/converting, and metadata writing/embedding
set yesExtra=--write-thumbnail --write-info-json --convert-thumbnails png --write-subs
set noExtra=--no-write-thumbnail --no-write-info-json

:Start
REM check if required files exist, if not, download them
if not exist "%~dp0\yt-dlp.exe" goto dlYTDLP
if not exist "%~dp0\aria2c.exe" goto dlARIA2C
if not exist "%~dp0\ffmpeg.exe" goto dlFFMPEG
if not exist "%~dp0\ffprobe.exe" goto dlFFMPEG
ECHO.
REM update yt-dlp
yt-dlp -U
REM Restart point, avoids yt-dlp update and required file check
:Restart
ECHO. > debug.log
CLS
ECHO yt-dlp-cmdui 2.0
REM prompt for media type
ECHO What do you want to download?
ECHO.
ECHO.
ECHO Press 1 for Audio [Custom/MP3]
ECHO Press 2 for Audio [96kbps/Yes Overwrites/Yes Archive/MP3]
ECHO Press 3 for Video [Custom/MP4]
ECHO Press 4 for Video [1080p/Yes Overwrites/Yes Archive/MP4]
ECHO Press 5 for General File Downloads [For downloading anything else at high speeds]
ECHO.
CHOICE /c 12345 /n
IF ERRORLEVEL 5 GOTO generalDownloader
IF ERRORLEVEL 4 GOTO vDL_defHD
IF ERRORLEVEL 3 GOTO vDL
IF ERRORLEVEL 2 GOTO aDL_defHD
IF ERRORLEVEL 1 GOTO aDL

:aDL
CALL :Options
CALL :exOptions
REM prompt for video max/preferred resolution
ECHO Choose your Preferred Bitrate
ECHO.
ECHO Press 1 for 256kbps (Very High Quality, pretty rare)
ECHO Press 2 for 128kbps (High Quality, uncommon)
ECHO Press 3 for 96kbps  (Standard Quality, Most common)
ECHO Press 4 for 64kbps  (Best used for talk/radio)
CHOICE /c 1234 /n
IF %ERRORLEVEL% EQU 4 set abr=64
IF %ERRORLEVEL% EQU 3 set abr=96
IF %ERRORLEVEL% EQU 2 set abr=128
IF %ERRORLEVEL% EQU 1 set abr=256
ECHO abr = %abr% >> debug.log
CLS
REM download command
ECHO Starting downloads, this might take a while
yt-dlp %audPath% -f "ba[abr<=%abr%]" --extract-audio --audio-format mp3 --audio-quality 0 %arc% %overwrite% %yesExtra% %defaultArgs% 2>> debug.log
GOTO Complete

:aDL_defHD
CALL :Options
REM download command
ECHO Starting downloads, this might take a while
yt-dlp %audPath% -f ba --extract-audio --audio-format mp3 --audio-quality 0 --force-overwrites --download-archive "archive.txt" %yesExtra% %defaultArgs% 2>> debug.log
GOTO Complete

:vDL
CALL :Options
CALL :exOptions
REM prompt for video max/preferred resolution
ECHO Choose your Preferred Resolution
ECHO.
ECHO Press 1 for 4K
ECHO Press 2 for 1440p
ECHO Press 3 for 1080p
ECHO Press 4 for 720p
ECHO Press 5 for 480p
CHOICE /c 12345 /n
IF %ERRORLEVEL% EQU 5 set vW=720 && set vH=480
IF %ERRORLEVEL% EQU 4 set vW=1280 && set vH=720
IF %ERRORLEVEL% EQU 3 set vW=1920 && set vH=1080
IF %ERRORLEVEL% EQU 2 set vW=2560&& set vH=1440
IF %ERRORLEVEL% EQU 1 set vW=3840 && set vH=2160
ECHO vW = %vW% >> debug.log
ECHO vH = %vH% >> debug.log
CLS
REM download command
ECHO Starting downloads, this might take a while
yt-dlp %vidPath% -f "bv[width<=%vW%][height<=%vH%]+ba/b" --merge-output-format mp4 %arc% %overwrite% %thME% %defaultArgs% 2>> debug.log
GOTO Complete

:vDL_defHD
CALL :Options
ECHO Starting downloads, this might take a while
yt-dlp %vidPath% -f "bv[width<=1920][height<=1080]+ba/b" --merge-output-format mp4 --force-overwrites %thME% --download-archive "archive.txt" %defaultArgs% 2>> debug.log
GOTO Complete

:generalDownloader
CLS
ECHO Input download link, only 1
set /p url=
aria2c -d "%~dp0.\General File Output" -x 16 -s 16 -j 16 -k 1M "%url%"
GOTO Complete

REM end of script
:Complete
CLS
ECHO.
ECHO End of script
ECHO.
ECHO Restart from beginning?
CHOICE
IF ERRORLEVEL 2 EXIT
IF ERRORLEVEL 1 GOTO Restart

:dlYTDLP
ECHO yt-dlp.exe is required, but missing
ECHO Would you like to download it?
CHOICE
IF ERRORLEVEL 2 GOTO End
IF ERRORLEVEL 1 ECHO Downloading...
powershell -command "Invoke-WebRequest -OutFile yt-dlp.exe -Uri https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
if not exist "%~dp0\yt-dlp.exe" goto dlYTDLP
ECHO yt-dlp has been downloaded
ECHO.
GOTO Start

:dlARIA2C
ECHO aria2c.exe is required, but missing
ECHO Would you like to download it?
CHOICE
IF ERRORLEVEL 2 GOTO End
IF ERRORLEVEL 1 ECHO Downloading...
powershell -command "Invoke-WebRequest -OutFile aria2c.zip -Uri https://github.com/aria2/aria2/releases/download/release-1.36.0/aria2-1.36.0-win-64bit-build1.zip"
powershell -command "Expand-Archive aria2c.zip -Force"
FOR /F "tokens=*" %%a in ('Where /R %~dp0\ aria2c.exe') do SET arialocat=%%a
move %arialocat% %~dp0\ 2> nul
del "%~dp0\aria2c.zip" 2> nul
rd /Q /S %~dp0\aria2c 2> nul
if not exist "%~dp0\aria2c.exe" goto dlARIA2C
ECHO aria2c has been downloaded
ECHO.
GOTO Start

:dlFFMPEG
ECHO ffmpeg.exe and/or ffprobe.exe are required, but missing
ECHO Would you like to download it?
CHOICE
IF ERRORLEVEL 2 GOTO End
IF ERRORLEVEL 1 ECHO Downloading...
powershell -command "Invoke-WebRequest -OutFile ffmpeg.zip -Uri https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"
powershell -command "Expand-Archive ffmpeg.zip -Force"
FOR /F "tokens=*" %%a in ('Where /R %~dp0\ ffmpeg.exe') do SET ffmpeg=%%a
FOR /F "tokens=*" %%a in ('Where /R %~dp0\ ffprobe.exe') do SET ffprobe=%%a
move %ffmpeg% %~dp0\ 2> nul
move %ffprobe% %~dp0\ 2> nul
del "%~dp0\ffmpeg.zip" 2> nul
rd /Q /S %~dp0\ffmpeg 2> nul
if not exist "%~dp0\ffprobe.exe" GOTO dlFFMPEG
if not exist "%~dp0\ffmpeg.exe" GOTO dlFFMPEG
ECHO ffmpeg and ffprobe have downloaded
ECHO.
GOTO Start

:Options
CLS
REM Tell user to fill in URLs.txt
ECHO #Type or Paste all URLs you want downloaded, then save and exit. One URL per line > "%~dp0.\URLs.txt"
start "" /B /WAIT notepad.exe "%~dp0.\URLs.txt"
CLS
ECHO.
ECHO Download Thumbnails, Subtitles and Metadata as separate files?
ECHO They will be embedded into the file either way
CHOICE
IF %ERRORLEVEL% EQU 2 set thME=--no-write-subs --no-write-thumbnail --no-write-info-json
IF %ERRORLEVEL% EQU 1 set thME=--write-subs --write-thumbnail --write-info-json --convert-thumbnails png
CLS
EXIT /B

:exOptions
REM prompt for overwrites
ECHO Should overwrites be allowed?
ECHO.
CHOICE
IF %ERRORLEVEL% EQU 2 set overwrite=--no-force-overwrites
IF %ERRORLEVEL% EQU 1 set overwrite=--force-overwrites
ECHO overwrite = %overwrite% >> debug.log
CLS
REM prompt for archive use
ECHO Should the archive file be used?
ECHO The archive file prevents already-downloaded files from being re-downloaded
ECHO.
CHOICE
IF %ERRORLEVEL% EQU 2 set arc=--no-download-archive
IF %ERRORLEVEL% EQU 1 set arc=--download-archive "archive.txt"
ECHO arc = %arc% >> debug.log
CLS
EXIT /B