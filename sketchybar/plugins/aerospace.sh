#!/usr/bin/env bash

# Get focused workspace
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

# Map workspace ID to display name
get_display_name() {
  case "$1" in
    *rowsing) echo "Browsing" ;;
    *ommunication) echo "Communication" ;;
    *evelopment) echo "Development" ;;
    *xtra) echo "Extra" ;;
    *ile_Management) echo "File Mgmt" ;;
    *aming) echo "Gaming" ;;
    *usic) echo "Music" ;;
    *ther) echo "Other" ;;
    *lanning) echo "Planning" ;;
    *esearch) echo "Research" ;;
    *ystem_Administration) echo "Sys Admin" ;;
    *riting) echo "Writing" ;;
    *ooling) echo "Tooling" ;;
    *VM | *M) echo "VM" ;;
    *ject_𝟷*) echo "Project 1" ;;
    *ject_𝟸*) echo "Project 2" ;;
    *ject_𝟹*) echo "Project 3" ;;
    *ject_𝟺*) echo "Project 4" ;;
    *) echo "$1" ;;
  esac
}

# Map workspace to icon
get_workspace_icon() {
  case "$1" in
    *rowsing) echo "󰖟" ;;
    *ommunication) echo "󰭹" ;;
    *evelopment) echo "" ;;
    *xtra) echo "" ;;
    *ile_Management) echo "󰉋" ;;
    *aming) echo "󰊗" ;;
    *usic) echo "󰎆" ;;
    *ther) echo "" ;;
    *lanning) echo "󰃭" ;;
    *esearch) echo "" ;;
    *ystem_Administration) echo "" ;;
    *riting) echo "󰏫" ;;
    *ooling) echo "" ;;
    *VM | *M) echo "" ;;
    *ject_𝟷*) echo "󰬺" ;;   # nf-md-numeric_1
    *ject_𝟸*) echo "󰬻" ;;   # nf-md-numeric_2
    *ject_𝟹*) echo "󰬼" ;;   # nf-md-numeric_3
    *ject_𝟺*) echo "󰬽" ;;   # nf-md-numeric_4
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

# Use larger icon for project workspaces (bare numbers are small)
case "$FOCUSED" in
  *ject_*) ICON_FONT_SIZE=28 ; DISPLAY_NAME="" ;;
  *) ICON_FONT_SIZE=16 ;;
esac

sketchybar --set aerospace \
  label="$DISPLAY_NAME" \
  icon="$MAIN_ICON" \
  icon.color="$ICON_COLOR" \
  label.color="$LABEL_COLOR" \
  icon.font.size="$ICON_FONT_SIZE"
