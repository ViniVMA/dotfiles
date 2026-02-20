#!/bin/bash

VOLUME=$(osascript -e 'output volume of (get volume settings)')
MUTED=$(osascript -e 'output muted of (get volume settings)')

# Toggle mute on click
if [[ "$SENDER" == "mouse.clicked" ]]; then
  if [[ "$MUTED" == "true" ]]; then
    osascript -e 'set volume output muted false'
    MUTED="false"
  else
    osascript -e 'set volume output muted true'
    MUTED="true"
  fi
fi

if [[ "$MUTED" == "true" || "$VOLUME" -eq 0 ]]; then
  ICON=󰝟
  ICON_COLOR=0xffee99a0
elif [[ "$VOLUME" -le 30 ]]; then
  ICON=󰕿
  ICON_COLOR=0xffcdd6f4
elif [[ "$VOLUME" -le 60 ]]; then
  ICON=󰖀
  ICON_COLOR=0xffcdd6f4
else
  ICON=󰕾
  ICON_COLOR=0xffcdd6f4
fi

sketchybar --set $NAME \
  icon=$ICON icon.color=$ICON_COLOR \
  label="${VOLUME}%"
