#!/bin/bash

# Battery is here because the ICON_COLOR doesn't play well with all background colors

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case ${PERCENTAGE} in
  [8-9][0-9] | 100)
    ICON=""
    ICON_COLOR=0xffa6da95
    ;;
  7[0-9])
    ICON=""
    ICON_COLOR=0xffeed49f
    ;;
  [4-6][0-9])
    ICON=""
    ICON_COLOR=0xfff5a97f
    ;;
  [1-3][0-9])
    ICON=""
    ICON_COLOR=0xffee99a0
    ;;
  [0-9])
    ICON=""
    ICON_COLOR=0xffed8796
    ;;
esac

if [[ $CHARGING != "" ]]; then
  ICON=""
  ICON_COLOR=0xffeed49f
fi

# Show time remaining on hover
case "$SENDER" in
  "mouse.entered")
    RAW_TIME=$(pmset -g batt | grep -Eo '\d+:\d+' | head -1)
    if [[ -n "$RAW_TIME" ]]; then
      HOURS=${RAW_TIME%%:*}
      MINS=${RAW_TIME##*:}
      if [[ "$HOURS" -gt 0 ]]; then
        TIME_LEFT="${HOURS}h${MINS}m"
      else
        TIME_LEFT="${MINS}m"
      fi
      if [[ $CHARGING != "" ]]; then
        sketchybar --set $NAME label="${TIME_LEFT} to full"
      else
        sketchybar --set $NAME label="${TIME_LEFT} left"
      fi
    else
      sketchybar --set $NAME label="Calculating..."
    fi
    ;;
  "mouse.exited")
    sketchybar --set $NAME label="${PERCENTAGE}%"
    ;;
  *)
    sketchybar --set $NAME \
      icon=$ICON \
      label="${PERCENTAGE}%" \
      icon.color=${ICON_COLOR}
    ;;
esac
