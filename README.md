# x11docker/deepin

Run [deepin desktop](https://www.deepin.org) in docker. 
 - Use x11docker to run image. 
 - Get x11docker from github: https://github.com/mviereck/x11docker 

Run desktop with:
```
x11docker --desktop --systemd --pulseaudio x11docker/deepin
```
Run single application:
```
x11docker x11docker/deepin deepin-terminal
```
Options:
- You can add hardware acceleration with option `--gpu`
- You can create a persistent home folder with option `--home`
- See `x11docker --help` for further options.

![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-deepin.png "deepin desktop running in weston Xwayland window using x11docker")
