#!/bin/bash
# herdr-last.sh — attach to the most recently active herdr session.
#
# For "I closed the terminal by mistake". The herdr servers are daemons (PPID 1),
# so closing the terminal only kills the client — the sessions keep running and
# this reattaches to whichever one you were last in.
#
# "Most recent" = newest session.json mtime. herdr rewrites that file on layout
# changes (its persist.save event), so mtime tracks real activity rather than
# creation order. State lives in two shapes, and both are considered:
#   ~/.config/herdr/session.json                  -> the default (unnamed) session
#   ~/.config/herdr/sessions/<name>/session.json  -> named sessions
#
# A stopped session wins too if it is the newest; herdr starts it back up and
# restores the layout from that same session.json, which is the wanted behavior.

herdr=/opt/homebrew/bin/herdr
root="$HOME/.config/herdr"

newest=$(ls -t "$root"/session.json "$root"/sessions/*/session.json 2>/dev/null | head -1)

if [ -z "$newest" ]; then
  echo "herdr-last: no saved sessions found under $root" >&2
  exit 1
fi

dir=$(dirname "$newest")
if [ "$dir" = "$root" ]; then
  exec "$herdr"
else
  exec "$herdr" --session "$(basename "$dir")"
fi
