# x11docker/deepin
# 
# Run deepin desktop in docker. 
# Use x11docker to run image. 
# Get x11docker from github: 
#   https://github.com/mviereck/x11docker 
#
# Run deepin desktop with:
#   x11docker --desktop --gpu --init=systemd --cap-default --hostipc -- --cap-add=SYS_RESOURCE --cap-add=IPC_LOCK -- x11docker/deepin
# Note that the setup to run deepin desktop includes several option degrading container isolation. Do not use if security is a concern.
#
# Run single application:
#   x11docker x11docker/deepin deepin-terminal
#
# Options:

# Persistent home folder stored on host with   --home
# Shared host folder with                      --sharedir DIR
# Hardware acceleration with option            --gpu
# Clipboard sharing with option                --clipboard
# Change desired language locale setting with  --lang $LANG
# Sound support with option                    --pulseaudio
#
# See x11docker --help for further options.

FROM bestwu/deepin:panda

ENV LANG en_US.utf8
ENV PATH /usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/games:/usr/games

# choose a mirror
#RUN echo "deb http://packages.deepin.com/deepin/ panda main non-free contrib" > /etc/apt/sources.list
RUN echo "deb http://mirrors.kernel.org/deepin/  panda main non-free contrib" > /etc/apt/sources.list
#RUN echo "deb http://ftp.fau.de/deepin/  panda main non-free contrib" > /etc/apt/sources.list

# basics
RUN rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    apt-get update && \
    apt-mark hold iptables && \
    apt-get dist-upgrade -y && \
    apt-get -y autoremove && \
    apt-get clean && \
env DEBIAN_FRONTEND=noninteractive apt-get install -y \
    dbus-x11 \
    libxv1 \
    locales-all \
    mesa-utils \
    mesa-utils-extra \
    procps \
    psmisc

# deepin desktop
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    dde \
    at-spi2-core \
    dconf-cli \
    dconf-editor \
    gnome-themes-standard \
    gtk2-engines-murrine \
    gtk2-engines-pixbuf \
    pciutils

# additional applications
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y \
    deepin-calculator \
    deepin-image-viewer \
    deepin-screenshot \
    deepin-system-monitor \
    deepin-terminal \
    deepin-movie \
    gedit \
    oneko \
    sudo \
    synaptic

# chinese fonts
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y \
    fonts-arphic-uming

CMD ["startdde"]
