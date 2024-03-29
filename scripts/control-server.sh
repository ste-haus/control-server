#!/bin/bash

## echo "on" | nc cube-3186 4444

PORT=4444
CUBE_URL="http://cube#touch"

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
if [ -f $SCRIPT_DIR/.env ]; then
  . $SCRIPT_DIR/.env
fi

for key in "${!CUBE_AREA_@}"; do
  area="${key##*_}"
  group=(${!key})
  url_key="CUBE_URL_${area}"
  area_url="${!url_key}"

  for cube in "${group[@]}"; do
    if [ "$(hostname)" == "$cube" ]; then
      set CUBE_URL="$area_url"
    fi
  done
done

echo "Cube listening for commands on port $PORT..."

function runCommand {
  if [ "$1" == 'reboot' ]; then
    sudo reboot
  elif [ "$1" == "on" ]; then
    DISPLAY=:0 xdotool mousemove 10 10 && DISPLAY=:0 xdotool mousemove 0 0 && DISPLAY=:0 xdotool click 1
  elif [ "$1" == "off" ]; then
    xset -display :0 dpms force off
  elif [ "$1" == "start" ]; then
    export DISPLAY=:0.0 && env MOZ_USE_XINPUT2=1 firefox --kiosk "$CUBE_URL" &
    sleep 10
    runCommand on
  elif [ "$1" == "stop" ]; then
    killall firefox
  elif [ "$1" == "restart" ]; then
    runCommand stop
    runCommand start
  elif [ "$1" == "maintenance" ]; then
    runCommand stop
    export DISPLAY=:0.0 && env MOZ_USE_XINPUT2=1 firefox -url "$CUBE_URL" &
  fi
}

echo "Cube listening for commands on port $PORT..."

while read line; do
  echo "Received '$line' command..."
  runCommand "$line"
done < <(nc -k -l $PORT)

