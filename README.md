# x11docker/deepin

Run [deepin desktop](https://www.deepin.org) in docker. 
 - Use x11docker to run image. 
 - Get x11docker from github: https://github.com/mviereck/x11docker 

Run desktop with:
```
x11docker --desktop --systemd --gpu x11docker/deepin

# alternativly:
x11docker --desktop --dbus-system --pulseaudio --gpu x11docker/deepin
```
Run single application:
```
x11docker x11docker/deepin deepin-terminal
```

# Options:
 - Persistent home folder stored on host with   `--home`
 - Shared host folder with                      `--sharedir DIR`
 - Hardware acceleration with option            `--gpu`
 - Clipboard sharing with option                `--clipboard`
 - Language locale setting with                 `--lang $LANG`
 - Sound support with                           `--pulseaudio`

See `x11docker --help` for further options.

# Extend base image
To add your desired applications, create your own Dockerfile with this image as a base. Example:
```
FROM x11docker/deepin
RUN apt-get update
RUN apt-get install -y midori
```
 
# Screenshot

![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-deepin.png "deepin desktop running in weston Xwayland window using x11docker")
