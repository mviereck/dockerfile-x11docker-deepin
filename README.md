# x11docker/deepin

Run [deepin desktop](https://www.deepin.org) in a Docker container. 
Use [x11docker](https://github.com/mviereck/x11docker) to run image. 

Run desktop with:
```
x11docker --desktop --init=systemd -- --cap-add=IPC_LOCK --security-opt seccomp=unconfined -- x11docker/deepin
```

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

# Known issues
 - The logout button does not respond. To terminate the session either close the X server window or type `systemctl poweroff` in terminal.
 - Configuring the keyboard input method in deepin control center does not work. Use "Fcitx Configuration" in the application menu instead.

# Extend base image
To add your desired applications, create and build from a custom Dockerfile with this image as a base. Example with `firefox`:
```
FROM x11docker/deepin
RUN apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y firefox && \
    apt-get clean
```

## deepin community repository
Some applications has been outsourced from the official deepin repository, noteable many Windows applications running with wine.
They should be still available in a [community repository](https://www.deepin.org/en/2020/11/19/statements/).
However, the official site is no longer accessible for unknown reasons.
An inofficial community repository outside of China is [located in Spain](https://deepinenespañol.org/en/improve-the-speed-of-the-deepin-20-beta-repository/).

# Screenshot

![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-deepin.png "deepin desktop running in Weston+Xwayland window using x11docker")
