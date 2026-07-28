#!/bin/bash
# Project picker (fzf + zoxide). Bound to `C-a p` inside herdr and Cmd+P in kitty.
#
# Picking a project opens it as a WORKSPACE in the herdr session you are already
# in, rather than spawning another kitty tab with its own herdr session. Only when
# there is no session to add to does it fall back to opening a tab.
#
# Three cases, in order:
#   1. Running inside a herdr pane  -> $HERDR_SOCKET_PATH targets this session.
#   2. Running as a kitty overlay over a herdr tab -> herdr-tab.sh tagged that tab
#      with `project=<session>`, so the socket path is derivable.
#   3. Neither (a plain shell tab)  -> open/focus a kitty tab running a session.
#
# In cases 1 and 2 an existing workspace for the project is focused instead of
# duplicated, matching on the label with any "[N] " jump-key prefix stripped (the
# herdr-automatic-rename plugin adds those).

set -u

herdr=/opt/homebrew/bin/herdr
sock_root="$HOME/.config/herdr"
# Resolve kitty even when not on PATH (popup/overlay may not source your rc).
kitty=$(command -v kitty || echo /Applications/kitty.app/Contents/MacOS/kitty)
ksock="${KITTY_LISTEN_ON:-unix:/tmp/kitty}"

selected=$(zoxide query -l | fzf --height 40% --reverse --prompt "  " --no-info)
[ -z "$selected" ] && exit 0
name=$(basename "$selected" | tr ' .' '-')

# Focus the project's workspace on $1 (a session socket), creating it if absent.
open_workspace() {
    local sock=$1 wid
    wid=$(HERDR_SOCKET_PATH="$sock" "$herdr" workspace list 2>/dev/null | /usr/bin/python3 -c "
import json, re, sys
want = sys.argv[1]
try:
    ws = json.load(sys.stdin)['result']['workspaces']
except Exception:
    sys.exit(0)
for w in ws:
    base = re.sub(r'^\[[0-9]+\]\s*', '', w.get('label') or '')
    if base == want:
        print(w['workspace_id'])
        break
" "$name")

    if [ -n "$wid" ]; then
        HERDR_SOCKET_PATH="$sock" "$herdr" workspace focus "$wid" >/dev/null 2>&1
    else
        HERDR_SOCKET_PATH="$sock" "$herdr" workspace create \
            --cwd "$selected" --label "$name" --focus >/dev/null 2>&1
    fi
}

# 1. Inside a herdr pane.
if [ -n "${HERDR_SOCKET_PATH:-}" ]; then
    open_workspace "$HERDR_SOCKET_PATH"
    exit 0
fi

# 2. A kitty overlay sitting over a herdr tab. herdr-tab.sh sets project=<session>;
#    "default" lives at the config root, named sessions under sessions/<name>/.
session=$("$kitty" @ --to "$ksock" ls 2>/dev/null | /usr/bin/python3 -c "
import json, sys
try:
    osws = json.load(sys.stdin)
except Exception:
    sys.exit(0)
for osw in osws:
    for tab in osw.get('tabs', []):
        if not tab.get('is_focused'):
            continue
        for w in tab.get('windows', []):
            p = (w.get('user_vars') or {}).get('project')
            if p:
                print(p)
                sys.exit(0)
")
if [ -n "$session" ]; then
    if [ "$session" = "default" ]; then
        sock="$sock_root/herdr.sock"
    else
        sock="$sock_root/sessions/$session/herdr.sock"
    fi
    if [ -S "$sock" ]; then
        open_workspace "$sock"
        exit 0
    fi
fi

# 3. No session to add to: open or focus a kitty tab running one.
"$kitty" @ --to "$ksock" focus-tab --match "var:project=${name}" 2>/dev/null ||
    "$kitty" @ --to "$ksock" launch --type=tab --var "project=${name}" \
        --tab-title "$name" --cwd "$selected" "$herdr" --session "$name"
