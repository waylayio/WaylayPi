#!/bin/bash

udevd &
#modprobe bcm2708_wdog
modprobe i2c-bcm2708
modprobe i2c-dev

python /app/waylaypi.py & /app/monitor.sh & /app/sendstats.sh
