# x11docker/deepin
# 
# Run deepin desktop in a Docker container. 
# Use x11docker to run image: 
#   https://github.com/mviereck/x11docker 
#
# Run deepin desktop with:
#   x11docker --desktop --init=systemd -- --cap-add=IPC_LOCK -- x11docker/deepin
#
# Run single application:
#   x11docker x11docker/deepin deepin-terminal
#
# Options:
# Persistent home folder stored on host with   --home
# Share host file or folder with option        --share PATH
# Hardware acceleration with option            --gpu
# Clipboard sharing with option                --clipboard
# Language locale setting with option          --lang [=$LANG]
# Sound support with option                    --pulseaudio
# Printer support with option                  --printer
# Webcam support with option                   --webcam
#
# See x11docker --help for further options.

#### stage 0: debian, debootstrap ####
FROM debian:buster

# Choose a deepin mirror close to your location.
# Many further mirrors are listed at: https://www.deepin.org/en/mirrors/packages/
#ENV DEEPIN_MIRROR=http://packages.deepin.com/deepin/
#ENV DEEPIN_MIRROR=http://mirrors.ustc.edu.cn/deepin/
ENV DEEPIN_MIRROR=http://mirrors.kernel.org/deepin/
#ENV DEEPIN_MIRROR=http://ftp.fau.de/deepin/

ENV DEEPIN_RELEASE=apricot

# prepare sources and keys
RUN apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
        debootstrap \
        gnupg && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 425956BB3E31DF51 && \
    mkdir -p /rootfs/etc/apt && \
    cp /etc/apt/trusted.gpg /rootfs/etc/apt/trusted.gpg && \
    echo "deb $DEEPIN_MIRROR $DEEPIN_RELEASE main non-free contrib" > /rootfs/etc/apt/sources.list

# cleanup script for use after apt-get
RUN echo '#! /bin/sh\n\
env DEBIAN_FRONTEND=noninteractive apt-get autoremove -y\n\
apt-get clean\n\
find /var/lib/apt/lists -type f -delete\n\
find /var/cache -type f -delete\n\
find /var/log -type f -delete\n\
exit 0\n\
' > /rootfs/cleanup && chmod +x /rootfs/cleanup

# debootstrap script
RUN mkdir -p /usr/share/debootstrap/scripts && \
    echo "mirror_style release\n\
download_style apt\n\
finddebs_style from-indices\n\
variants - buildd fakechroot minbase\n\
keyring /usr/share/keyrings/deepin-archive-camel-keyring.gpg\n\
. /usr/share/debootstrap/scripts/debian-common \n\
" > /usr/share/debootstrap/scripts/$DEEPIN_RELEASE

RUN debootstrap --variant=minbase --arch=amd64 $DEEPIN_RELEASE /rootfs $DEEPIN_MIRROR && \
    chroot ./rootfs apt-get update && \
    chroot ./rootfs env DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
    chroot ./rootfs /cleanup

#### stage 1: deepin ####
FROM scratch
COPY --from=0 /rootfs /

ENV SHELL=/bin/bash
ENV LANG=en_US.UTF-8

# basics
RUN apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        dbus-x11 \
        deepin-keyring \
        gnupg \
        libcups2 \
        libpulse0 \
        libxv1 \
        locales-all \
        mesa-utils \
        mesa-utils-extra \
        procps \
        psmisc \
        xdg-utils \
        x11-xkb-utils \
        x11-xserver-utils && \
    /cleanup

# deepin desktop

# Dependencies taken from 'apt show dde'
# (excluded: dde-session-ui deepin-manual eject plymouth-theme-deepin-logo dde-printer deepin-screensaver)
RUN apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        dde-control-center \
        dde-clipboard \
        dde-desktop \
        dde-dock \
        dde-file-manager \
        dde-kwin \
        dde-launcher \
        dde-qt5integration \
        deepin-artwork \
        deepin-default-settings \
        deepin-desktop-base \
        deepin-wallpapers \
        fonts-noto \
        startdde && \
    /cleanup

# additional applications
RUN apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        dde-calendar \
        deepin-album \
        deepin-calculator \
        deepin-draw \
        deepin-editor \
        deepin-image-viewer \
        deepin-movie \
        deepin-music \
        deepin-screenshot \
        deepin-system-monitor \
        deepin-terminal \
        deepin-voice-note \
        oneko \
        sudo && \
    /cleanup
    
# fcitx: Chinese input support
ENV XMODIFIERS=@im=fcitx QT4_IM_MODULE=fcitx QT_IM_MODULE=fcitx GTK_IM_MODULE=fcitx
RUN apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
        fcitx-sunpinyin fcitx-ui-classic && \
    mkdir -p /etc/xdg/autostart && \
    echo "[Desktop Entry]\n\
Encoding=UTF-8\n\
Version=0.9.4\n\
Type=Application\n\
Name=fcitx\n\
Comment=\n\
Exec=fcitx\n\
StartupNotify=false\n\
Terminal=false\n\
Hidden=true\n\
" > /etc/xdg/autostart/fcitx.desktop && \
    /cleanup

CMD ["startdde"]
