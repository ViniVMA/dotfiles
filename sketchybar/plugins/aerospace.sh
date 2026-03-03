#!/usr/bin/env bash

# Get focused workspace
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

# Map workspace ID to display name
get_display_name() {
  case "$1" in
    Browsing) echo "Browsing" ;;
    Communication) echo "Communication" ;;
    Development) echo "Development" ;;
    Extra) echo "Extra" ;;
    File_Management) echo "File Mgmt" ;;
    Gaming) echo "Gaming" ;;
    Music) echo "Music" ;;
    Other) echo "Other" ;;
    Planning) echo "Planning" ;;
    Research) echo "Research" ;;
    System_Administration) echo "Sys Admin" ;;
    Writing) echo "Writing" ;;
    Tooling) echo "Tooling" ;;
    VM) echo "VM" ;;
    Project_1) echo "Project 1" ;;
    Project_2) echo "Project 2" ;;
    Project_3) echo "Project 3" ;;
    Project_4) echo "Project 4" ;;
    *) echo "$1" ;;
  esac
}

# Map workspace to icon
get_workspace_icon() {
  case "$1" in
    Browsing) echo "󰖟" ;;
    Communication) echo "󰭹" ;;
    Development) echo "" ;;
    Extra) echo "" ;;
    File_Management) echo "󰉋" ;;
    Gaming) echo "󰊗" ;;
    Music) echo "󰎆" ;;
    Other) echo "" ;;
    Planning) echo "󰃭" ;;
    Research) echo "" ;;
    System_Administration) echo "" ;;
    Writing) echo "󰏫" ;;
    Tooling) echo "" ;;
    VM) echo "" ;;
    Project_1) echo "󰬺" ;;   # nf-md-numeric_1
    Project_2) echo "󰬻" ;;   # nf-md-numeric_2
    Project_3) echo "󰬼" ;;   # nf-md-numeric_3
    Project_4) echo "󰬽" ;;   # nf-md-numeric_4
    *) echo "" ;;
  esac
}

# Update main bar item with focused workspace
DISPLAY_NAME=$(get_display_name "$FOCUSED")
MAIN_ICON=$(get_workspace_icon "$FOCUSED")

# Check service mode state
if [ "$(aerospace list-modes --current 2>/dev/null)" = "service" ]; then
  sketchybar --set aerospace_service drawing=on
  ICON_COLOR="0xfff5a97f"   # ORANGE
  LABEL_COLOR="0xfff5a97f"  # ORANGE
else
  sketchybar --set aerospace_service drawing=off
  ICON_COLOR="0xffc6a0f6"   # MAGENTA (default)
  LABEL_COLOR="0xffffffff"  # WHITE (default)
fi

# Split display name for hotkey highlighting
FIRST_LETTER="${DISPLAY_NAME:0:1}"
REST_NAME="${DISPLAY_NAME:1}"

# Project workspaces: icon-only, no name
case "$FOCUSED" in
  Project_*) ICON_FONT_SIZE=28 ; FIRST_LETTER="" ; REST_NAME="" ;;
  *) ICON_FONT_SIZE=16 ;;
esac

sketchybar --set aerospace \
  icon="$MAIN_ICON" \
  icon.color="$ICON_COLOR" \
  icon.font.size="$ICON_FONT_SIZE" \
  label="$FIRST_LETTER" \
  label.color="$ICON_COLOR"

sketchybar --set aerospace_name \
  label="$REST_NAME" \
  label.color="$LABEL_COLOR"
