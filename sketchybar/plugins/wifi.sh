#!/bin/bash

SSID=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I 2>/dev/null | awk -F: '($1 ~ "^ *SSID$"){print $2}' | cut -c 2-)

if [[ -z "$SSID" ]]; then
  ICON=󰤭
  ICON_COLOR=0xffee99a0
  LABEL=""
else
  ICON=󰤨
  ICON_COLOR=0xffa6da95
  LABEL=""
fi

case "$SENDER" in
  "mouse.clicked")
    open "x-apple.systempreferences:com.apple.wifi-settings-extension"
    ;;
  "mouse.entered")
    if [[ -z "$SSID" ]]; then
      sketchybar --set $NAME label="Disconnected"
    else
      sketchybar --set $NAME label="$SSID"
    fi
    ;;
  "mouse.exited")
    sketchybar --set $NAME label=""
    ;;
  *)
    sketchybar --set $NAME \
      icon=$ICON icon.color=$ICON_COLOR \
      label="$LABEL"
    ;;
esac
