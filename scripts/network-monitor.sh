#!/bin/bash

FREQUENCY=1
LOG=/var/log/network-availibility.log
IP=`route -n | grep 'UG[ \t]' | awk '{print $2}'`

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
