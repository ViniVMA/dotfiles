#!/bin/bash

BT_STATUS=$(defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState 2>/dev/null)

if [[ "$BT_STATUS" -eq 1 ]]; then
  ICON=󰂯
  ICON_COLOR=0xff89b4fa
else
  ICON=󰂲
  ICON_COLOR=0xffee99a0
fi

case "$SENDER" in
  "mouse.clicked")
    open "x-apple.systempreferences:com.apple.BluetoothSettings"
    ;;
  "mouse.entered")
    if [[ "$BT_STATUS" -eq 1 ]]; then
      CONNECTED=$(system_profiler SPBluetoothDataType 2>/dev/null | grep -A2 "Connected: Yes" | grep "Name:" | sed 's/.*Name: //' | head -3 | paste -sd ", " -)
      if [[ -n "$CONNECTED" ]]; then
        sketchybar --set $NAME label="$CONNECTED"
      else
        sketchybar --set $NAME label="No devices"
      fi
    else
      sketchybar --set $NAME label="Off"
    fi
    ;;
  "mouse.exited")
    sketchybar --set $NAME label=""
    ;;
  *)
    sketchybar --set $NAME \
      icon=$ICON icon.color=$ICON_COLOR \
      label=""
    ;;
esac
