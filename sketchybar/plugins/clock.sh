#!/bin/bash

LOCAL_TIME="$(date '+%H:%M')"
UTC_TIME="$(TZ=UTC date '+%H:%M') UTC"
FULL_DATE="$(date '+%a %b %d %Y') ${LOCAL_TIME} | ${UTC_TIME}"

case "$SENDER" in
  "mouse.entered")
    sketchybar --set $NAME label="${LOCAL_TIME} | ${UTC_TIME}"
    ;;
  "mouse.exited")
    sketchybar --set $NAME label="${LOCAL_TIME}"
    ;;
  "mouse.clicked")
    echo -n "$(date '+%Y-%m-%d %H:%M')" | pbcopy
    sketchybar --set $NAME label="Copied!"
    sleep 1
    sketchybar --set $NAME label="${LOCAL_TIME}"
    ;;
  *)
    sketchybar --set $NAME \
      label="${LOCAL_TIME}" \
      icon=󰥔 icon.color=0xffff9cbe
    ;;
esac
