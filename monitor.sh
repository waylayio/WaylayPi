#!/bin/bash
set -e

#log some basic info
uname -a

# needs WAYLAY_DOMAIN, WAYLAY_KEY and WAYLAY_SECRET environment variables to run properly

RESOURCE="waylaypi"

function fetchStatsAndStore {
    TOTAL=`free -t -m | grep Total`;
    TOTAL_MEM=`echo $TOTAL | awk '{ print $2}'`
    USED_MEM=`echo $TOTAL | awk '{ print $3}'`
    FREE_MEM=`echo $TOTAL | awk '{ print $4}'`

    SWAP=`free -t -m | grep Swap`
    TOTAL_SWAP=`echo $SWAP | awk '{ print $2}'`
    USED_SWAP=`echo $SWAP | awk '{ print $3}'`
    FREE_SWAP=`echo $SWAP | awk '{ print $4}'`

    DISK=`df --block-size=1 /  | grep dev`
    TOTAL_DISK=`echo $DISK | awk '{ print $2}'`
    USED_DISK=`echo $DISK | awk '{ print $3}'`
    FREE_DISK=`echo $DISK | awk '{ print $4}'`

    CPU_USAGE=`top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}'`

    JSON_BODY='{
        "cpuUsage": '$CPU_USAGE',
        "totalMemory":  '$TOTAL_MEM',
        "usedMemory" : '$USED_MEM' ,
        "freeMemory" : '$FREE_MEM' ,
        "totalSwap" :  '$TOTAL_SWAP',
        "usedSwap" : '$USED_SWAP',
        "freeSwap" : '$FREE_SWAP',
        "totalDisk" : '$TOTAL_DISK',
        "usedDisk" : '$USED_DISK',
        "freeDisk" : '$FREE_DISK' }'

    echo ${JSON_BODY}

    curl --user $WAYLAY_KEY:$WAYLAY_SECRET -H "Content-Type:application/json" -X POST -d "$JSON_BODY" https://data.waylay.io/resources/${RESOURCE}?domain=$WAYLAY_DOMAIN || true
    # the || true makes sure the command does not exit on thing like: Couldn't resolve host 'data.waylay.io'
}

function sendAndSleep {
    while [ : ]
    do
        echo "Fetching stats and sending to waylay"
        fetchStatsAndStore
        sleep 15s
    done
}

sendAndSleep