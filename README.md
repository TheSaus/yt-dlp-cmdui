# yt-dlp-cmdui
Simple CMD based yt-dlp/aria2c script for Windows 10
Made by The-Saus

## Features
- Download Audio, Video, or use aria2 to download other things
- Choice of overwriting existing files when downloading Video or Audio
- Optional "Archive File" usage when downloading Video or Audio
  - Read more about the Archive File on the [yt-dlp github page (look for --download-archive)](https://github.com/yt-dlp/yt-dlp#video-selection)
- All downloads use aria2c to speed things up
## Video Downloads
- When Downloading Video, you can choose between 'Video Preset' or 'Video Custom'
  - Video Preset defaults to 1080p, Yes Overwrites, Yes Archive
  - Video Custom lets you choose between 5 resolutions, as well as Overwrites and Archive File usage
    - 480p
    - 720p
    - 1080p
    - 1440p
    - 4k
  - Both Video Preset and Video Custom will ask if you want to download the Thumbnails, Subtitles, and Metadata as separate files
- Each Video File will be saved to it's own folder, along with the respective thumbnail file, subtitle file, and metadata file

## Audio Downloads
- When Downloading Audio, you can choose between 'Audio Preset' or 'Audio Custom'
  - Audio Preset defaults to 96kbps, Yes Overwrites, Yes Archive
  - Audio Custom lets you choose between 4 bitrates, as well as Overwrites and Archive File usage
    - 64kbps
    - 96kbps
    - 128kbps
    - 256kbps
  - Both Audio Preset and Audio Custom will ask if you want to download the Thumbnails, Subtitles, and Metadata as separate files
- Each Audio File will be saved to it's own folder, along with the respective thumbnail file, subtitle file, and metadata file

## General File Downloads
This script isn't just for downloading Videos or Audio, it can also download whatever aria2 supports
  - Read more about aria2 and what it supports [here](https://aria2.github.io/manual/en/html/README.html#introduction)
- The aria2c arguments in use should make downloads faster, listed below;
  - -x 16 [info](http://aria2.github.io/manual/en/html/aria2c.html#cmdoption-x)
  - -s 16 [info](http://aria2.github.io/manual/en/html/aria2c.html#cmdoption-k)
  - -j 16 [info](http://aria2.github.io/manual/en/html/aria2c.html#cmdoption-j)
  - -k 1M [info](http://aria2.github.io/manual/en/html/aria2c.html#cmdoption-s)
  - --seed-time=0 [info](http://aria2.github.io/manual/en/html/aria2c.html#cmdoption-seed-time)
  - --referer=* [info](http://aria2.github.io/manual/en/html/aria2c.html#cmdoption-referer)
  - --seed-ratio=0.1 [info](http://aria2.github.io/manual/en/html/aria2c.html#cmdoption-seed-ratio)
  - --file-allocation=prealloc [info](http://aria2.github.io/manual/en/html/aria2c.html#cmdoption-file-allocation)
  - --max-download-limit=0 [info](http://aria2.github.io/manual/en/html/aria2c.html#cmdoption-max-download-limit)
  - --bt-max-peers=0 [info](http://aria2.github.io/manual/en/html/aria2c.html#cmdoption-bt-max-peers)
## Sponsorblock Integration
- Sponsorblock removes unwanted portions of videos, including but not limited to;
  - Intros
  - Outros
  - Sponsors
  - Self Promotions
  - Previews
- You can read more about Sponsorblock Integration on the [yt-dlp github page](https://github.com/yt-dlp/yt-dlp#sponsorblock-options)

## Installation and Requirements
### Requirements
- The ability to read
- Windows 10
- Powershell 5 (preinstalled with Windows 10)
- ~230MB Available Disk Space for the script + dependencies
  - You will need more space to store downloads
- the ability to read (remix)

### Installation
1. Download the latest release from the release page
2. Extract the contents of yt-dlp-cmdui.zip, make sure to put the extracted files into their own folder
3. run yt-dlp-cmdui.bat
4. the script will download all required dependencies if you allow it, without access to said files the script will not work

Alternatively, you can download the required dependencies yourself

- Dependency Sources;
  - yt-dlp.exe [Source](https://github.com/yt-dlp/yt-dlp)
  - aria2c.exe [Source](https://github.com/aria2/aria2)
  - ffmpeg.exe [Source](https://github.com/BtbN/FFmpeg-Builds)
  - ffprobe.exe [Same as ffmpeg]
