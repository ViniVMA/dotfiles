#!/bin/bash

DEFAULT_NAME="spotify"

PLAYING_COLOR=0xffa6da95
PAUSED_COLOR=0xffffa217

MAIN_PLAYING_ICON=󱑽
MAIN_PAUSED_ICON=󰐎

PLAYER_PLAYING_ICON=󰏤
PLAYER_PAUSED_ICON=

update_playpause_icon() {
  case "$PLAYER_STATE" in
    "playing"|"Playing")
      ICON=$PLAYER_PLAYING_ICON
      ;;
    *)
      ICON=$PLAYER_PAUSED_ICON
      ;;
  esac

  sketchybar --set "$DEFAULT_NAME.playpause" icon=$ICON
}

update_track() {
  # Spotify JSON / $INFO comes in malformed, line below sanitizes it
  SPOTIFY_JSON="$INFO"

  if [[ ! -z $SPOTIFY_JSON ]]; then
    PLAYER_STATE=$(echo "$SPOTIFY_JSON" | jq -r '.["Player State"]')
    update_playpause_icon

    if [ $PLAYER_STATE = "Playing" ]; then
      TRACK="$(echo "$SPOTIFY_JSON" | jq -r .Name)"
      ARTIST="$(echo "$SPOTIFY_JSON" | jq -r .Artist)"

      sketchybar --set $NAME \
        label="${ARTIST} - ${TRACK}" \
        icon=$MAIN_PLAYING_ICON icon.color=$PLAYING_COLOR \
        label.width=dynamic icon.width=dynamic \
        background.drawing=on
    else
      sketchybar --set $NAME \
        label="" icon="" \
        label.width=0 icon.width=0 \
        background.drawing=off
    fi
  else
    sketchybar --set $NAME \
      label="" icon="" \
      label.width=0 icon.width=0 \
      background.drawing=off
  fi
}

mouse_clicked() {
  case "$NAME" in
    "$DEFAULT_NAME")
      osascript -e 'tell application "Spotify" to playpause'
      ;;
    "$DEFAULT_NAME.next")
      osascript -e 'tell application "Spotify" to play next track'
      ;;
    "$DEFAULT_NAME.playpause")
      osascript -e 'tell application "Spotify" to playpause'

      PLAYER_STATE=$(osascript -e 'tell application "Spotify" to player state')
      update_playpause_icon
      ;;
    "$DEFAULT_NAME.back")
      osascript -e 'tell application "Spotify" to play previous track'
      ;;
  esac
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  *)
    if [[ "$NAME" = "$DEFAULT_NAME" ]]; then
      update_track
    fi
    ;;
esac
