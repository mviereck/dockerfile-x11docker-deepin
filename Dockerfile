# x11docker/deepin
# 
# Run deepin desktop in docker. 
# Use x11docker to run image. 
# Get x11docker from github: 
#   https://github.com/mviereck/x11docker 
#
# Run desktop with:
#   x11docker --desktop --systemd --sys-admin --pulseaudio x11docker/deepin
#
# Run single application:
#   x11docker x11docker/deepin deepin-terminal
#
# You can add hardware acceleration with option --gpu
# You can create a persistent home folder with option --home
# See x11docker --help for further options.
#
FROM deepin/deepin-core
ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://mirrors.kernel.org/deepin/ panda main non-free contrib" > /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends dde

# missing dependencies
RUN apt-get install -y dbus-x11 at-spi2-core gtk2-engines-murrine gtk2-engines-pixbuf && apt-get clean

# OpenGL support
RUN apt-get install -y mesa-utils mesa-utils-extra && apt-get clean

# additional applications
RUN apt-get install -y deepin-calculator deepin-image-viewer deepin-screenshot deepin-system-monitor deepin-terminal deepin-movie deepin-music gedit sudo oneko && apt-get clean

# Hard way disabling bluetooth, "systemctl mask" does not work.
# Without bluetooth hardware this service eats up the CPU and spams the log.
RUN rm /lib/systemd/system/bluetooth.service /lib/systemd/system/bluetooth.target

# Mask failing units
RUN systemctl mask iptables.service systemd-tmpfiles-setup.service

# masking units not needed (does not seem to work for all of them)
RUN systemctl mask udisk2 upower NetworkManager bamfdaemon rtkit-daemon lastore-daemon.service lastore-update-metadata-info.service

ENV DEBIAN_FRONTEND newt
CMD startdde