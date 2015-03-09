#!/bin/bash

# Set host-name and enable-dbus
sed -i -e "s@#enable-dbus=yes@enable-dbus=no@" -e "s@#host-name=foo@host-name=$(echo $RESIN_DEVICE_UUID | cut -c1-7)@" /etc/avahi/avahi-daemon.conf

# Restart service
/etc/init.d/avahi-daemon restart

udevd &
#modprobe bcm2708_wdog
modprobe i2c-bcm2708
modprobe i2c-dev

python /app/waylaypi.py & /app/monitor.sh

