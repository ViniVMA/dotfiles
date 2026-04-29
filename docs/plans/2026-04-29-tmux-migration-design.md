# Tmux Migration Design

Date: 2026-04-29

## Goal

Replace zellij with tmux as the terminal multiplexer. Reuse existing helper scripts (sysinfo, sessionizer logic), preserve daily muscle memory (Alt-prefixed launchers and pane navigation), and adopt tmux conventions where they're stronger (leader-key for less-frequent commands, plugin ecosystem).

Out of scope: rewriting `nvim/lua/plugins/ai/zellij-claude.lua` for tmux. That integration breaks during migration and gets its own pass after the rest is stable.

## Keybindings

Leader: `C-a` (with `bind C-a send-prefix` so double-tap sends literal `C-a` to the underlying shell).

### Direct Alt-binds (no leader)

| Action | Bind | Notes |
|---|---|---|
| Pane focus h/j/k/l | `Alt h/j/k/l` | via `vim-tmux-navigator` — works across nvim splits + tmux panes |
| Prev/next window | `Alt H` / `Alt L` | uppercase, mirrors zellij |
| Goto window 1-9 | `Alt 1`…`Alt 9` | |
| Split right | `Alt \` | |
| Split down | `Alt -` | |
| Close pane | `Alt q` | |
| Zoom pane | `Alt z` | `resize-pane -Z` |
| Toggle popup | `Alt x` | `display-popup -E` (≈ zellij floating panes) |
| New window | `Alt t` | |
| Edit scrollback | `Alt i` | popup running `$EDITOR` over `capture-pane` output |
| Sessionizer | `Alt p` | popup running `sessionizer.sh` |
| Claude launcher | `Alt c` | split-window -h `claude --dangerously-skip-permissions` |
| Lazydocker | `Alt d` | popup |
| Nvim | `Alt e` | new window |
| Lazygit | `Alt g` | popup |

### Leader-prefixed (`C-a` then key)

| Action | Bind |
|---|---|
| Detach | `C-a d` |
| Reload config | `C-a r` |
| Rename window | `C-a ,` |
| Move window left/right | `C-a [` / `C-a ]` |
| Copy mode | `C-a v` |
| Search in buffer | `C-a /` |

### Dropped from zellij

- Modal `resize` / `move` / `scroll` / `search` / `session` modes — tmux's resize is `prefix` then arrow-keys held; copy-mode covers scroll/search; sessionizer + detach covers session.

## Statusbar + Theme

- Plugin: `catppuccin/tmux` with Macchiato flavor — colors already match the hard-coded palette in zellij's `default.kdl`.
- Layout:
  - **Left:** `● {session_name} {window_list}` — sapphire dot + bold session, blue/peach window tabs.
  - **Center:** empty.
  - **Right:** `#(bash ~/.config/tmux/scripts/sysinfo.sh) 󰃭 #(date "+%a, %b %d  %H:%M")` with `status-interval 10`.
- Mode indicator: tmux only has copy-mode → show `[COPY]` (yellow) when active, nothing otherwise.
- Drop `themes/koda.kdl` entirely — only used for borders and base fg/bg, both handled by Catppuccin.

## Window Naming

Replace zsh hook `_zellij_tab_name` with `_tmux_window_name`:

```bash
function _tmux_window_name() {
    if [[ -n "$TMUX" ]]; then
        local name=$(basename "$PWD" | tr '.' '-')
        command tmux rename-window "$name"
    fi
}
chpwd_functions+=(_tmux_window_name)
_tmux_window_name
```

## Sessionizer

```bash
#!/bin/bash
selected=$(zoxide query -l | fzf --height 40% --reverse --prompt "  " --no-info)
[ -z "$selected" ] && exit 0

session_name=$(basename "$selected" | tr ' .' '-')

if ! tmux has-session -t="$session_name" 2>/dev/null; then
    tmux new-session -ds "$session_name" -c "$selected"
fi

if [ -z "$TMUX" ]; then
    tmux attach-session -t "$session_name"
else
    tmux switch-client -t "$session_name"
fi
```

Bound to `Alt p` via `display-popup -E`. Difference from zellij version: detects nesting and uses `switch-client` when already inside tmux.

## Wezterm

`wezterm/behavior.lua`:
```lua
default_prog = { "/opt/homebrew/bin/tmux", "new-session", "-A", "-s", "main" }
```

`-A` attaches to "main" if it exists, creates otherwise. New wezterm windows share one tmux server with one default session; sessionizer creates/switches project sessions.

`wezterm/keys.lua`: update comment from "Multiplexing is handled by Zellij" → "by tmux". No keybind changes.

## Plugins (TPM)

| Plugin | Purpose |
|---|---|
| `tmux-plugins/tpm` | Plugin manager |
| `tmux-plugins/tmux-sensible` | Sane defaults (escape time, history limit) |
| `christoomey/vim-tmux-navigator` | Seamless `Alt h/j/k/l` across nvim + tmux |
| `tmux-plugins/tmux-resurrect` | Manual save/restore (`prefix C-s` / `prefix C-r`) |
| `tmux-plugins/tmux-continuum` | Auto-save 15min, auto-restore on start |
| `catppuccin/tmux` | Theme + statusbar |

Skipped: `tmux-yank` (macOS clipboard works natively in tmux 3.x), `tmux-prefix-highlight` (no need for visual cue).

## File Layout

```
dotfiles/tmux/
├── tmux.conf
└── scripts/
    ├── sessionizer.sh    # ported from zellij version
    ├── sysinfo.sh        # copied as-is
    ├── cpu.sh            # copied as-is
    ├── ram.sh            # copied as-is
    └── weather.sh        # copied as-is
```

Symlinked to `~/.config/tmux/`. TPM and plugins live under `~/.config/tmux/plugins/` (gitignored).

## Rollout Phases

1. **Build alongside.** Create `dotfiles/tmux/`, symlink to `~/.config/tmux/`, install TPM, run `prefix + I`. Test by manually launching `tmux` from wezterm. Zellij untouched.
2. **Burn-in.** Run tmux in parallel for a few days; fix friction (missing binds, color tweaks).
3. **Cutover.** Flip `wezterm/behavior.lua` `default_prog`. Replace zsh `_zellij_tab_name` with `_tmux_window_name`.
4. **Remove zellij.** Delete `dotfiles/zellij/`, `brew uninstall zellij`, `rm -rf ~/.config/zellij`.
5. **Follow-up (out of scope here).** Rewrite `zellij-claude.lua` as `tmux-claude.lua` so the nvim Claude integration works again.

## Estimate

- Phase 1: ~2-4 hours
- Phase 2: ~1 day burn-in
- Phase 3: ~30 minutes
- Phase 4: ~10 minutes
- Phase 5: separate task
