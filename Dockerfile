# x11docker/deepin
# 
# Run deepin desktop in docker. 
# Use x11docker to run image. 
# Get x11docker from github: 
#   https://github.com/mviereck/x11docker 
#
# Run desktop with:
#   x11docker --desktop --dbus-daemon --pulseaudio x11docker/deepin
#
# Run single application:
#   x11docker x11docker/deepin deepin-terminal
#
# You can add hardware acceleration with option       --gpu
# You can create a persistent home folder with option --home
# You can share clipboard with host with option       --clipboard
# See x11docker --help for further options.
#
FROM deepin/deepin-core
ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF8

RUN echo "deb http://mirrors.kernel.org/deepin/ panda main non-free contrib" > /etc/apt/sources.list
RUN apt-get update && apt-get install -y apt-utils && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends dde

# missing dependencies, dconf, locales, mesa
RUN apt-get install -y --no-install-recommends at-spi2-core dbus-x11 dconf-cli dconf-editor \
    gnome-themes-standard gtk2-engines-murrine gtk2-engines-pixbuf locales-all \
    mesa-utils mesa-utils-extra

# additional applications
RUN apt-get install -y deepin-calculator deepin-image-viewer deepin-screenshot \
    deepin-system-monitor deepin-terminal deepin-movie deepin-music \
    gedit sudo synaptic oneko

# chinese fonts
RUN apt-get install -y fonts-arphic-uming

# Mask failing units
RUN systemctl mask bluetooth iptables.service systemd-hostnamed systemd-tmpfiles-setup.service

# masking units not needed (does not seem to work for all of them)
RUN systemctl mask udisk2 upower bamfdaemon rtkit-daemon \
    lastore-daemon lastore-update-metadata-info NetworkManager \
    plymouth-start plymouth-read-write

ENV DEBIAN_FRONTEND newt
ENV PATH /usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/games:/usr/games

RUN cd /usr/share/dbus-1/services && rm \
    com.deepin.daemon.Audio.service \
    com.deepin.daemon.Bluetooth.service \
    com.deepin.daemon.InputDevices.service \
    com.deepin.daemon.Network.service \
    com.deepin.daemon.Power.service \
    com.deepin.daemon.SessionWatcher.service \
    org.gnome.keyring.* \
    org.gtk.vfs.*

RUN cd /usr/share/dbus-1/system-services && rm \
    com.deepin.daemon.Grub2.service \
    com.deepin.daemon.helper.Backlight.service \
    com.deepin.lastore.service \ 
    com.deepin.system.Power.service \
    fi.* \
    net.* \
    org.bluez.service \
    org.freedesktop.hostname1.service \
    org.freedesktop.network1.service \
    org.freedesktop.nm_dispatcher.service \
    org.freedesktop.UDisks2.service \
    org.freedesktop.UPower.service

RUN echo '{\n\
    "last_wm": "deepin-wm"\n\
}\n\
' >/wm3d.json

# create startscript 
RUN echo '#! /bin/sh\n\
[ -e "$HOME/.config" ] || cp -R /etc/skel/. $HOME/ \n\
[ -e /dev/dri/card0 ] && { \n\
  mkdir -p $HOME/.config/deepin/deepin-wm-switcher \n\
  cp -n /wm3d.json $HOME/.config/deepin/deepin-wm-switcher/config.json \n\
} \n\
dconf write /com/deepin/dde/daemon/network false \n\
dconf write /com/deepin/dde/daemon/bluetooth false \n\
dconf write /com/deepin/dde/watchdog/dde-polkit-agent false \n\
dconf write /com/deepin/dde/daemon/power false \n\
exec startdde \n\
' > /usr/bin/start 
RUN chmod +x /usr/bin/start 

CMD start
