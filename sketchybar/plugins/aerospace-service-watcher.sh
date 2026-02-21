#!/usr/bin/env bash

# Immediately trigger bar update (shows service mode indicator)
sketchybar --trigger aerospace_workspace_change

# Poll until service mode exits, then trigger bar update (hides indicator)
while [ "$(aerospace list-modes --current 2>/dev/null)" = "service" ]; do
  sleep 0.2
done
sketchybar --trigger aerospace_workspace_change
