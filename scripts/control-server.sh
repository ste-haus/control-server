function runCommand {
    if [ "$1" == 'reboot' ]; then
        sudo reboot
    elif [ "$1" == "on" ]; then
        DISPLAY=:0 xdotool mousemove 10 10 && DISPLAY=:0 xdotool mousemove 0 0 && DISPLAY=:0 xdotool click 1
    elif [ "$1" == "off" ]; then
        xset -display :0 dpms force off
    elif [ "$1" == "start" ]; then
        export DISPLAY=:0.0 && firefox --kiosk "$CUBE_URL" &
        sleep 10
        runCommand on
    elif [ "$1" == "stop" ]; then
        killall chrome
    elif [ "$1" == "restart" ]; then
        killall chrome
        runCommand start
    elif [ "$1" == "maintenance" ]; then
        killall chrome
        export DISPLAY=:0.0 && firefox -url "$CUBE_URL" &
    fi
}

echo "Cube listening for commands on port $PORT..."

while read line; do
    echo "Received '$line' command..."
    runCommand "$line"
done < <(nc -k -l $PORT)
