#!/bin/bash

#unamestr=`uname -a`

while [ : ]
do
#    clear
#    tput cup 5 5
#    date
#    tput cup 6 5
    echo "$(hostname) $(uname -a)"
    sleep 15s
done