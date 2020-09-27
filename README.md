# x11docker/deepin

Run [deepin desktop](https://www.deepin.org) in a Docker container. 
Use [x11docker](https://github.com/mviereck/x11docker) to run image. 

Run desktop with:
```
x11docker --desktop --gpu --init=systemd --cap-default --hostipc -- --cap-add=SYS_RESOURCE --cap-add=IPC_LOCK --cap-add=SYS_ADMIN -- x11docker/deepin
```
Note that the setup to run deepin desktop includes several options degrading container isolation. The worst one is `--cap-add=SYS_ADMIN`. 
Do not use if security is a concern. Evil applications might be able to manipulate the host system.

Run single application:
```
x11docker x11docker/deepin deepin-terminal
```

# Options:
 - Persistent home folder stored on host with   `--home`
 - Shared host file or folder with              `--share PATH`
 - Hardware acceleration with option            `--gpu`
 - Clipboard sharing with option                `--clipboard`
 - Language locale setting with                 `--lang [=$LANG]`
 - Sound support with                           `--pulseaudio`
 - Printer support with                         `--printer`
 - Webcam support with                          `--webcam`

See `x11docker --help` for further options.

# Extend base image
To add your desired applications, create your own Dockerfile with this image as a base. Example:
```
FROM x11docker/deepin
RUN apt-get update
RUN apt-get install -y firefox
```
 
# Screenshot

![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-deepin.png "deepin desktop running in weston Xwayland window using x11docker")
