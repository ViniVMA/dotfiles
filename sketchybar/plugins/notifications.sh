#!/bin/bash

DB="$HOME/Library/Group Containers/group.com.apple.usernoted/db2/db"
COUNT=$(sqlite3 "$DB" "SELECT COUNT(*) FROM record WHERE presented = 0;" 2>/dev/null)

if [[ -z "$COUNT" ]]; then
  COUNT=0
fi

if [[ "$COUNT" -gt 0 ]]; then
  sketchybar --set $NAME \
    icon=󰂚 icon.color=0xffed8796 \
    label="$COUNT" \
    drawing=on
else
  sketchybar --set $NAME drawing=off
fi
