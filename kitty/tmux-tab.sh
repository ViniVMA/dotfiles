#!/bin/zsh
# tmux-tab.sh — give each kitty tab its OWN tmux session.
#
# Session name = basename of the tab's working directory (or $1 if passed).
# - A *detached* session of that name is reattached  -> persistence across reopen.
# - A session already *attached* in another tab gets a -2 / -3 ... suffix
#   -> two tabs never mirror each other.
# tmux still owns panes / copy-mode / resize+move modes / persistence inside a tab.

tmux=/opt/homebrew/bin/tmux
# Resolve kitty even when not on PATH (this runs as a non-interactive shell).
kitty=$(command -v kitty || echo /Applications/kitty.app/Contents/MacOS/kitty)

dir="${1:-$(pwd)}"
base=$(basename "$dir")
# Home/scratch tabs use "home" (not "main", which is your real workspace).
[ "$dir" = "$HOME" ] && base=home
base=${base//[^A-Za-z0-9_-]/_}

name=$base
i=2
while "$tmux" has-session -t "=$name" 2>/dev/null && \
      [ "$("$tmux" display -p -t "=$name" '#{session_attached}')" != "0" ]; do
  name="${base}-${i}"
  i=$((i + 1))
done

# Tag this kitty tab with its session name as a user var, so the sessionizer
# can find/focus it (matched by var, independent of the live folder title).
if [ -n "$KITTY_WINDOW_ID" ]; then
  "$kitty" @ --to "${KITTY_LISTEN_ON:-unix:/tmp/kitty}" set-user-vars \
    --match id:"$KITTY_WINDOW_ID" "project=$name" 2>/dev/null
fi

exec "$tmux" new-session -A -s "$name" -c "$dir"
