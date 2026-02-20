#!/bin/bash

# Hide sketchybar to reveal native menu bar
sketchybar --bar hidden=on
sleep 0.2

# Open the focused app's first menu (File/Shell/etc.)
osascript -e 'tell application "System Events" to tell (first process whose frontmost is true) to click menu bar item 3 of menu bar 1' 2>/dev/null

# Restore bar after a delay (background so script returns immediately)
(sleep 8 && sketchybar --bar hidden=off) &
