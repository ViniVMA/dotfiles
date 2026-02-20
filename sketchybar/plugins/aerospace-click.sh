#!/bin/bash

HELPER_DIR="$HOME/.config/sketchybar/helpers"
BINARY="$HELPER_DIR/aerospace-menu"
SOURCE="$HELPER_DIR/aerospace-menu.swift"

# Auto-compile if binary missing or source changed
if [ ! -f "$BINARY" ] || [ "$SOURCE" -nt "$BINARY" ]; then
  swiftc -o "$BINARY" "$SOURCE" -framework AppKit 2>/dev/null
fi

[ ! -f "$BINARY" ] && exit 1

FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)

# Build workspace data and pipe to native menu
SELECTED=$(
  for ws in $(aerospace list-workspaces --all); do
    apps=$(aerospace list-windows --workspace "$ws" 2>/dev/null | cut -d'|' -f2 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | grep -v '^$' | sort -u | paste -sd ', ' -)
    label="$ws"
    if [ -n "$apps" ]; then
      label="$ws – $apps"
    fi
    flag=""
    if [ "$ws" = "$FOCUSED" ]; then
      flag="focused"
    fi
    printf '%s\t%s\t%s\n' "$ws" "$label" "$flag"
  done | "$BINARY"
)

case "$SELECTED" in
  "__reload__")
    aerospace reload-config
    ;;
  "")
    # Dismissed without selection
    ;;
  *)
    aerospace workspace "$SELECTED"
    ;;
esac
