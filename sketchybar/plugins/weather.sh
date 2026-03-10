#!/bin/bash

# São Paulo coordinates
LAT="-23.5505"
LON="-46.6333"

WEATHER_JSON=$(curl -s --max-time 5 "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current=temperature_2m,weather_code")

if [ -z "$WEATHER_JSON" ]; then
  sketchybar --set $NAME label="N/A"
  exit 0
fi

TEMPERATURE=$(echo "$WEATHER_JSON" | jq '.current.temperature_2m | round')
CODE=$(echo "$WEATHER_JSON" | jq '.current.weather_code')

case $CODE in
  0)                    DESC="Clear sky" ;;
  1)                    DESC="Mainly clear" ;;
  2)                    DESC="Partly cloudy" ;;
  3)                    DESC="Overcast" ;;
  45|48)                DESC="Fog" ;;
  51|53|55)             DESC="Drizzle" ;;
  56|57)                DESC="Freezing drizzle" ;;
  61|63|65)             DESC="Rain" ;;
  66|67)                DESC="Freezing rain" ;;
  71|73|75|77)          DESC="Snow" ;;
  80|81|82)             DESC="Rain showers" ;;
  85|86)                DESC="Snow showers" ;;
  95|96|99)             DESC="Thunderstorm" ;;
  *)                    DESC="Unknown" ;;
esac

sketchybar --set $NAME \
  icon=󰖐 icon.color=0xff5edaff \
  label="${TEMPERATURE}°C • ${DESC}"
