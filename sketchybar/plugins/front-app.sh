#!/bin/bash

ICON_COLOR=0xffff7f17

case $INFO in
  "Arc")
    ICON_PADDING_RIGHT=5
    ICON=󰞍
    ;;
  "Code")
    ICON_PADDING_RIGHT=2
    ICON_COLOR=0xff22a1f0
    ICON=󰨞
    ;;
  "Calendar")
    ICON=
    ;;
  "Discord")
    ICON_COLOR=0xff5b5bf5
    ICON=󰙯
    ;;
  "FaceTime")
    ICON=
    ;;
  "Finder")
    ICON_COLOR=0xff40b9ff
    ICON=󰀶
    ;;
  "Firefox")
    ICON=󰈹
    ;;
  "Google Chrome")
    ICON=
    ;;
  "IINA")
    ICON=󰕼
    ;;
  "kitty")
    ICON=󰄛
    ;;
  "Messages")
    ICON=󰍦
    ;;
  "Notion")
    ICON_COLOR=0xff000000
    ICON=󰈄
    ;;
  "Preview")
    ICON_COLOR=0xff137DF8
    ICON=
    ;;
  "PS Remote Play")
    ICON=
    ;;
  "Spotify")
    ICON_COLOR=0xff24D44E
    ICON=
    ;;
  "TextEdit")
    ICON=
    ;;
  "Transmission")
    ICON=󰶘
    ;;
  *)
    ICON_COLOR=0xffff94c6
    ICON=󰘔
    ;;
esac

sketchybar --set $NAME \
  icon=$ICON icon.color=$ICON_COLOR \
  label="$INFO"

# Restore bar if it was hidden by menu activation
sketchybar --bar hidden=off
