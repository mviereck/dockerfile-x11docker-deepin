# x11docker/deepin

Run [deepin desktop](https://www.deepin.org) in a Docker container. 
Use [x11docker](https://github.com/mviereck/x11docker) to run image. 

Run desktop with:
```
x11docker --desktop --init=systemd -- --cap-add=IPC_LOCK -- x11docker/deepin
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
 - With x11docker default X server option `--xephyr` the desktop window size is too large, deepin does some odd resizing. Try `--nxagent`, `--xpra` or `--weston-xwayland` instead.
   These options allow to resize the window.
 - The logout button does not respond. To terminate the session either close the X server window or type `systemctl poweroff`.
 - Configuring the Chinese input method with `fcitx` does not work.

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
They are still available in a [community repository](https://www.deepin.org/en/2020/11/19/statements/).
To replace the deepin repository with the community repository, build a new image with:
```
FROM x11docker/deepin

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1C30362C0A53D5BB && \
    echo "deb [by-hash=force] https://community-packages.deepin.com/deepin/ apricot main contrib non-free"  > /etc/apt/sources.list && \
    echo "deb https://community-store-packages.deepin.com/appstore eagle appstore" > /etc/apt/sources.list.d/appstore.list && \
    apt-get update
```
Another community repository outside of China is [located in Spain](https://deepinenespañol.org/en/improve-the-speed-of-the-deepin-20-beta-repository/).

To install e.g. WeChat add this line:
```
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y com.qq.weixin.deepin && apt-get clean
```
WeChat can be started in container with: `/opt/apps/com.qq.weixin.deepin/files/run.sh`. To let it appear in the application menu, add:
```
RUN cp /opt/apps/com.qq.weixin.deepin/entries/applications/com.qq.weixin.deepin.desktop /usr/share/applications/
```

# Screenshot

![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-deepin.png "deepin desktop running in Weston+Xwayland window using x11docker")
