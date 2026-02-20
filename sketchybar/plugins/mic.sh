#!/bin/bash

MIC_IN_USE=$(osascript -e 'do shell script "ioreg -l | grep -c AppleHDAEngineInput.*IOAudioEngineState.*1" ' 2>/dev/null)
CAM_IN_USE=$(osascript -e 'do shell script "lsof -n 2>/dev/null | grep -c AppleCamera"' 2>/dev/null)

if [[ "$CAM_IN_USE" -gt 0 && "$MIC_IN_USE" -gt 0 ]]; then
  ICON=󰭹
  sketchybar --set $NAME icon=$ICON icon.color=0xffed8796 drawing=on
elif [[ "$CAM_IN_USE" -gt 0 ]]; then
  ICON=
  sketchybar --set $NAME icon=$ICON icon.color=0xffed8796 drawing=on
elif [[ "$MIC_IN_USE" -gt 0 ]]; then
  ICON=󰍬
  sketchybar --set $NAME icon=$ICON icon.color=0xffed8796 drawing=on
else
  sketchybar --set $NAME drawing=off
fi
