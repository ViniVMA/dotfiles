#!/bin/bash
# Sessionizer — fzf+zoxide project picker that opens (or focuses) a kitty TAB
# bound to a per-project tmux session. Replaces the old switch-client behavior
# now that kitty owns the tab layer.
#
# Works whether launched from a kitty overlay (Cmd+P) or a tmux popup: it talks
# to kitty over the fixed control socket configured by `listen_on` in kitty.conf.

selected=$(zoxide query -l | fzf --height 40% --reverse --prompt "  " --no-info)
[ -z "$selected" ] && exit 0

name=$(basename "$selected" | tr ' .' '-')
sock="${KITTY_LISTEN_ON:-unix:/tmp/kitty}"
tmux=/opt/homebrew/bin/tmux
# Resolve kitty even when not on PATH (popup/overlay may not source your rc).
kitty=$(command -v kitty || echo /Applications/kitty.app/Contents/MacOS/kitty)

# Make sure the tmux session exists (detached) so attaching is instant.
"$tmux" has-session -t="$name" 2>/dev/null || \
  "$tmux" new-session -ds "$name" -c "$selected"

# Focus an existing kitty tab for this project (matched by a stable user var,
# since tab titles now track the live folder); otherwise open a new tab.
"$kitty" @ --to "$sock" focus-tab --match "var:project=${name}" 2>/dev/null || \
  "$kitty" @ --to "$sock" launch --type=tab --var "project=${name}" --tab-title "$name" \
    "$tmux" new-session -A -s "$name" -c "$selected"
