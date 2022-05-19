# yt-dlp-cmdui
Simple CMD based yt-dlp script
Made by The-Saus

## Features
- Simple, No GUI batch script made for Windows 10
- Download either Audio or Video
- Choice of overwriting existing files
- Optional "Archive File" usage
- A decent selection of resolution options when downloading video
  - 480p
  - 720p
  - 1080p
  - 1440p
  - 4k
  - "BEST", as in the highest available resolution for the video(s)
- Audio downloads at BEST Quality available
- Embeds a few things into downloaded files, if available;
  - Metadata
  - Subtitles
  - Thumbnail
- Uses aria2c for downloads
  - Uses 16 Concurrent Connections to download files much faster
- Sponsorblock Integration removes unwanted portions of videos, including but not limited to;
  - Intros
  - Outros
  - Sponsors
  - Self Promotions
  - Previews

## Installation and Requirements
### Requirements
- The ability to read
- Windows 10
- Powershell 5 (preinstalled with Windows 10)
- ~230MB Available Disk Space for the script + dependencies
  - You will need more space to download videos

### Installation
- Just download the script.bat file and run it, it should be in it's own folder to contain the logs and files it downloads
- On first run, the script will download all of it's dependencies;
  - yt-dlp.exe [Source](https://github.com/yt-dlp/yt-dlp)
  - aria2c.exe [Source](https://github.com/aria2/aria2)
  - ffmpeg.exe [Source](https://github.com/BtbN/FFmpeg-Builds)
  - ffprobe.exe [Same as ffmpeg]
