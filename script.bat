@echo off
:Start
REM check if required files exist, if not then download them
if not exist "%~dp0\yt-dlp.exe" goto dlYTDLP
if not exist "%~dp0\aria2c.exe" goto dlARIA2C
if not exist "%~dp0\ffmpeg.exe" goto dlFFMPEG
if not exist "%~dp0\ffprobe.exe" goto dlFFMPEG
ECHO.
REM check for yt-dlp update
yt-dlp -U
:Restart
ECHO. > debug.log
CLS

REM prompt for media type
ECHO Are you downloading Audio or Video?
ECHO.
ECHO Press 1 for Audio/MP3
ECHO Press 2 for Video/MP4
ECHO.
CHOICE /c 12 /n
IF ERRORLEVEL 2 GOTO vDL
IF ERRORLEVEL 1 GOTO aDL

:aDL
CLS
REM Tell user to fill in URLs.txt
ECHO #Type or Paste all URLs you want downloaded, then save and exit. One URL per line > "%~dp0.\URLs.txt"
start "" /B /WAIT notepad.exe "%~dp0.\URLs.txt"
CLS

REM prompt for overwrites
ECHO Should overwrites be allowed?
ECHO.
CHOICE
IF %ERRORLEVEL% EQU 2 set overwrite=--no-force-overwrites
IF %ERRORLEVEL% EQU 1 set overwrite=--force-overwrites
ECHO %overwrite% >> debug.log
CLS

REM prompt for archive use
ECHO Should the archive file be used?
ECHO The archive file prevents already-downloaded files from being re-downloaded
ECHO.
CHOICE
IF %ERRORLEVEL% EQU 2 set arc=--no-download-archive
IF %ERRORLEVEL% EQU 1 set arc=--download-archive "archive.txt"
ECHO %arc% >> debug.log
CLS

REM download command
set ARGS=--external-downloader=aria2c --external-downloader-args "-j 16 -x 16 -s 16 -k 1M" --add-metadata --no-warnings --progress --sponsorblock-remove default --throttled-rate 100K --embed-thumbnail -c %arc% %overwrite% -a "%~dp0.\URLs.txt"
ECHO %ARGS% >> debug.log
ECHO Starting downloads, this might take a while
yt-dlp -o "%~dp0.\AudioOutput\%%(title)s.%%(abr)sabr" -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 %ARGS%
CLS
GOTO Complete


:vDL
CLS

REM Tell user to fill in URLs.txt
ECHO #Type or Paste all URLs you want downloaded, then save and exit. One URL per line > "%~dp0.\URLs.txt"
start "" /B /WAIT notepad.exe "%~dp0.\URLs.txt"
CLS

REM prompt for overwrites
ECHO Should overwrites be allowed?
ECHO.
CHOICE
IF %ERRORLEVEL% EQU 2 set overwrite=--no-force-overwrites
IF %ERRORLEVEL% EQU 1 set overwrite=--force-overwrites
ECHO %overwrite% >> debug.log
CLS

REM prompt for archive use
ECHO Should the archive file be used?
ECHO The archive file prevents already-downloaded files from being re-downloaded
ECHO.
CHOICE
IF %ERRORLEVEL% EQU 2 set arc=--no-download-archive
IF %ERRORLEVEL% EQU 1 set arc=--download-archive "archive.txt"
ECHO %arc% >> debug.log
CLS

REM prompt for video max/preferred resolution
ECHO Choose your Preferred Resolution
ECHO.
ECHO Press 1 for Best Quality
ECHO Press 2 for 4K
ECHO Press 3 for 1440p
ECHO Press 4 for 1080p
ECHO Press 5 for 720p
ECHO Press 6 for 480p
CHOICE /c 123456 /n
IF %ERRORLEVEL% EQU 6 set vQuality="bestvideo[width<=720][height<=480]+bestaudio/best"
IF %ERRORLEVEL% EQU 5 set vQuality="bestvideo[width<=1280][height<=720]+bestaudio/best"
IF %ERRORLEVEL% EQU 4 set vQuality="bestvideo[width<=1920][height<=1080]+bestaudio/best"
IF %ERRORLEVEL% EQU 3 set vQuality="bestvideo[width<=2560][height<=1440]+bestaudio/best"
IF %ERRORLEVEL% EQU 2 set vQuality="bestvideo[width<=3840][height<=2160]+bestaudio/best"
IF %ERRORLEVEL% EQU 1 set vQuality="bestvideo+bestaudio/best"
CLS

REM download command
set ARGS=--external-downloader=aria2c --external-downloader-args "-j 16 -x 16 -s 16 -k 1M" --add-metadata --merge-output-format mp4 --no-warnings --progress --sponsorblock-remove default --throttled-rate 100K --embed-thumbnail --embed-subs -c %arc% %overwrite% -a "%~dp0.\URLs.txt"
ECHO %ARGS% >> debug.log
ECHO Starting downloads, this might take a while
yt-dlp -o "%~dp0.\VideoOutput\%%(title)s.%%(resolution)sp%%(fps)s" -f %vQuality% %ARGS%
CLS

REM end of script
:Complete
type "%~dp0.\URLs.txt" >> "%~dp0urlHistory.log"
ECHO.
ECHO End of script
ECHO.
ECHO Restart from beginning?
CHOICE
IF ERRORLEVEL 2 GOTO End
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

:End