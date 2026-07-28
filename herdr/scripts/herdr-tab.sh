#!/bin/zsh
# herdr-tab.sh — give each kitty tab its OWN herdr session. (Replaces tmux-tab.sh.)
#
# Session name = basename of the tab's working directory (or $1 if passed).
#
# BEHAVIOR CHANGE vs tmux: herdr sessions are server-backed and persist. tmux's
# `destroy-unattached on` has NO herdr equivalent, so closing a kitty tab leaves
# the session — and anything running in it, e.g. a stray claude — alive. Reopening
# a tab in the same folder REATTACHES to it instead of starting fresh.
#   List:  herdr session list
#   Kill:  herdr session stop <name>
#
# Unlike tmux-tab.sh there is no -2/-3 suffix logic: herdr's API exposes no
# attached-client count, so "is this session already attached elsewhere?" can't
# be answered. Two tabs opened by hand in the same folder will mirror. The
# sessionizer avoids this by focusing the existing tab (matched on the kitty
# user var set below) instead of opening a second one.

herdr=/opt/homebrew/bin/herdr
# Resolve kitty even when not on PATH (this runs as a non-interactive shell).
kitty=$(command -v kitty || echo /Applications/kitty.app/Contents/MacOS/kitty)

dir="${1:-$(pwd)}"
base=$(basename "$dir")
# Home/scratch tabs use "home" (not "main", which is your real workspace).
[ "$dir" = "$HOME" ] && base=home
base=${base//[^A-Za-z0-9_-]/_}

# Tag this kitty tab with its session name as a user var, so the sessionizer
# can find/focus it (matched by var, independent of the live folder title).
if [ -n "$KITTY_WINDOW_ID" ]; then
  "$kitty" @ --to "${KITTY_LISTEN_ON:-unix:/tmp/kitty}" set-user-vars \
    --match id:"$KITTY_WINDOW_ID" "project=$base" 2>/dev/null
fi

# herdr has no `-c <dir>` equivalent; it inherits the process cwd.
cd "$dir" || exit 1
exec "$herdr" --session "$base"
