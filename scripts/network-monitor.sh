#!/bin/bash

IP=192.168.0.1
FREQUENCY=1
LOG=/var/log/network-availibility.log

while true; do
    if ping -c 1 $IP &> /dev/null; then
        :
    else
        echo "network not available"
        echo `date` >> $LOG
        sudo service network-manager restart
    fi

    sleep $FREQUENCY
done
