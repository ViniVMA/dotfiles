#!/bin/bash
# Sessionizer for Zellij — mirrors WezTerm sessionizer behavior
# Uses zoxide for directory ranking and fzf for fuzzy selection

selected=$(zoxide query -l | fzf --height 40% --reverse --prompt "  " --no-info)

if [ -z "$selected" ]; then
    exit 0
fi

session_name=$(basename "$selected" | tr ' .' '-')

if zellij list-sessions 2>/dev/null | grep -q "^$session_name"; then
    zellij attach "$session_name"
else
    cd "$selected" && zellij attach --create "$session_name"
fi
