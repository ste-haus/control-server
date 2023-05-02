#!/bin/bash

## echo "on" | nc cube-3186 4444

PORT=4444
CUBE_URL="http://cube#touch"

echo "Cube listening for commands on port $PORT..."

while read line; do
    echo "Received '$line' command..."

    if [ "$line" == 'reboot' ]; then
        sudo reboot
    elif [ "$line" == "on" ]; then
        DISPLAY=:0 xdotool mousemove 10 10 && DISPLAY=:0 xdotool mousemove 0 0 && DISPLAY=:0 xdotool click 1
    elif [ "$line" == "off" ]; then
        xset -display :0 dpms force off
    elif [ "$line" == "start" ]; then
        export DISPLAY=:0.0 && firefox --kiosk "$CUBE_URL" &
    elif [ "$line" == "stop" ]; then
        killall firefox
    elif [ "$line" == "restart" ]; then
        killall firefox
        export DISPLAY=:0.0 && firefox --kiosk "$CUBE_URL" &
    elif [ "$line" == "maintenance" ]; then
        killall firefox
        export DISPLAY=:0.0 && firefox -url "$CUBE_URL" &
    fi
done < <(nc -k -l $PORT)
