#!/bin/bash
# Sessionizer for tmux — fzf+zoxide fuzzy session switcher.
# Mirrors zellij sessionizer behavior, swapping zellij commands for tmux.

selected=$(zoxide query -l | fzf --height 40% --reverse --prompt "  " --no-info)

if [ -z "$selected" ]; then
    exit 0
fi

session_name=$(basename "$selected" | tr ' .' '-')

if ! tmux has-session -t="$session_name" 2>/dev/null; then
    tmux new-session -ds "$session_name" -c "$selected"
fi

if [ -z "$TMUX" ]; then
    tmux attach-session -t "$session_name"
else
    tmux switch-client -t "$session_name"
fi
