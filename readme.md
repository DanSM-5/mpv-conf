
MPV Configuration
=================

This repository is just a backup of personal preferences and configurations for mpv player.

Dependencies:
* yt-dlp

Lua Scripts:
* Sponsorblock ([more info](https://github.com/po5/mpv_sponsorblock))

Pre-configurations
* Use `yt-dlp` instead of youtube-dl
* Set max quality to 1080P

## Config locations

Known locations where mpv config can be found in different systems
### Linux/Macos
```
  ~/.config/mpv
```

### Windows
If installed from `choco`
```
  $env:APPDATA\mpv
```
If installed from `scoop`
```
  $HOME\scoop\persist\mpv\portable_config
```
Both can be linked to the same directory with a symlink
```
  New-Item -ItemType SymbolicLink -Target $env:APPDATA\mpv -Path $HOME\scoop\persist\mpv\portable_config
```
