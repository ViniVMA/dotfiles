# Tmux Migration Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace zellij with tmux as the terminal multiplexer while preserving Alt-prefixed muscle memory and reusing existing helper scripts.

**Architecture:** Build a parallel `dotfiles/tmux/` setup that can be tested alongside zellij, then cut over by changing `wezterm/behavior.lua` and the zsh chpwd hook. Uses TPM for plugin management, Catppuccin Macchiato for theming, and `vim-tmux-navigator` for seamless nvim split navigation. Helper scripts (`sysinfo.sh`, `cpu.sh`, `ram.sh`, `weather.sh`) are copied verbatim from `zellij/scripts/`. Sessionizer is ported to use tmux's session model.

**Tech Stack:** tmux 3.6a, TPM (tmux plugin manager), bash scripts, zsh chpwd hooks, Lua (wezterm).

**Reference:** Design doc — `docs/plans/2026-04-29-tmux-migration-design.md` (committed on `master` at `15cf509`).

**Out of scope:** rewriting `nvim/lua/plugins/ai/zellij-claude.lua` for tmux. That integration breaks during burn-in and gets a separate follow-up.

---

## Conventions for this Plan

- "Verify" for config files means: run `tmux kill-server`, then start `tmux`, then test the binding manually. No automated test suite.
- All paths are relative to the **worktree root** `/Users/vini/dev/dotfiles/.worktrees/tmux-migration` unless noted.
- The symlink `~/.config/tmux` should point at the **main repo** (`~/dev/dotfiles/tmux`), not the worktree, after the migration is merged. **During Phase 1 (burn-in), point it at the worktree** so changes take effect immediately.
- Commit after every task. Use conventional-commit style (`feat(tmux): ...`, `chore(tmux): ...`) matching repo history.

---

## Phase 1: Build Alongside (zellij untouched)

### Task 1: Create tmux directory skeleton and symlink

**Files:**
- Create: `tmux/tmux.conf` (empty placeholder)
- Create: `tmux/scripts/.gitkeep` (empty)

**Step 1: Create directory structure**

```bash
mkdir -p /Users/vini/dev/dotfiles/.worktrees/tmux-migration/tmux/scripts
touch /Users/vini/dev/dotfiles/.worktrees/tmux-migration/tmux/tmux.conf
touch /Users/vini/dev/dotfiles/.worktrees/tmux-migration/tmux/scripts/.gitkeep
```

**Step 2: Symlink ~/.config/tmux to the worktree (temporary, until merge)**

If `~/.config/tmux` already exists as a directory (TPM may have created it), back it up first.

```bash
[ -e ~/.config/tmux ] && [ ! -L ~/.config/tmux ] && mv ~/.config/tmux ~/.config/tmux.bak
ln -snf /Users/vini/dev/dotfiles/.worktrees/tmux-migration/tmux ~/.config/tmux
ls -la ~/.config/tmux
```

Expected: symlink pointing at the worktree's `tmux/` directory.

**Step 3: Commit**

```bash
git add tmux/
git commit -m "feat(tmux): scaffold tmux config directory"
```

---

### Task 2: Install TPM

**Files:** None in repo (TPM lives at `~/.config/tmux/plugins/tpm` which is gitignored via the worktree symlink).

**Step 1: Clone TPM**

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

**Step 2: Verify**

```bash
ls ~/.config/tmux/plugins/tpm/tpm
```

Expected: file exists.

**Step 3: Add `plugins/` to a tmux-local gitignore** (so the symlinked worktree never tracks installed plugins)

Create `tmux/.gitignore`:

```
plugins/
```

**Step 4: Commit**

```bash
git add tmux/.gitignore
git commit -m "chore(tmux): ignore plugins/ directory"
```

---

### Task 3: Write minimal tmux.conf (core options + leader)

**Files:**
- Modify: `tmux/tmux.conf`

**Step 1: Write the base config**

Replace `tmux/tmux.conf` contents with:

```tmux
# ============================================================================
# Core options
# ============================================================================

# Leader: C-a (with double-tap to send literal C-a to underlying shell)
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# True color + italics support (matches wezterm)
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",xterm-256color:RGB,xterm-ghostty:RGB,*:Tc"

# Sane defaults
set -g escape-time 10            # nvim happiness
set -g history-limit 50000
set -g focus-events on
set -g mouse on
set -g renumber-windows on       # close window 2, window 3 becomes 2
set -g base-index 1              # windows start at 1, not 0
setw -g pane-base-index 1        # panes start at 1, not 0
set -g status-interval 10        # match zellij sysinfo refresh
set -g set-clipboard on          # native macOS clipboard

# Reload config
bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded"

# Splits open in current pane's directory (more zellij-like)
bind '\' split-window -h -c "#{pane_current_path}"
bind '-' split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %

# ============================================================================
# Plugins (TPM)
# ============================================================================

set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'catppuccin/tmux'

# Continuum auto-restore on tmux start
set -g @continuum-restore 'on'
set -g @continuum-save-interval '15'

# Keep TPM init at the very bottom
run '~/.config/tmux/plugins/tpm/tpm'
```

**Step 2: Verify config syntax**

```bash
tmux -f ~/.config/tmux/tmux.conf start-server \; kill-server 2>&1
```

Expected: no output (or only TPM's "Tmux Plugin Manager not installed" if Task 2 was skipped — but we did Task 2, so silent success).

**Step 3: Install plugins**

```bash
tmux start-server
tmux new-session -d -s plugin-install
tmux send-keys -t plugin-install '' C-a I  # leader + I via TPM convention
# Better: run TPM install non-interactively
~/.config/tmux/plugins/tpm/bin/install_plugins
tmux kill-server
```

Expected: each plugin clones into `~/.config/tmux/plugins/<plugin-name>/`.

**Step 4: Manual smoke test**

Open a fresh terminal, run `tmux`, verify:
- Status line appears (Catppuccin default — we'll style it later)
- `C-a r` reloads config and shows "Config reloaded"
- `C-a |` (well, `C-a \`) splits horizontally
- `C-a -` splits vertically

**Step 5: Commit**

```bash
git add tmux/tmux.conf
git commit -m "feat(tmux): add minimal config with leader and plugins"
```

---

### Task 4: Direct Alt-binds for pane and window navigation

**Files:**
- Modify: `tmux/tmux.conf` (append)

**Step 1: Append navigation block**

Append to `tmux/tmux.conf` after the "Splits open..." block, before the `# ===== Plugins` divider:

```tmux
# ============================================================================
# Direct Alt-binds (no leader)
# ============================================================================

# Pane focus — handled by vim-tmux-navigator, but explicit fallback for tmux-only
# (vim-tmux-navigator overrides these inside nvim splits)
bind -n M-h select-pane -L
bind -n M-j select-pane -D
bind -n M-k select-pane -U
bind -n M-l select-pane -R

# Window navigation (Alt H / Alt L = Shift+Alt+h / Shift+Alt+l)
bind -n M-H previous-window
bind -n M-L next-window

# Goto window 1-9
bind -n M-1 select-window -t :=1
bind -n M-2 select-window -t :=2
bind -n M-3 select-window -t :=3
bind -n M-4 select-window -t :=4
bind -n M-5 select-window -t :=5
bind -n M-6 select-window -t :=6
bind -n M-7 select-window -t :=7
bind -n M-8 select-window -t :=8
bind -n M-9 select-window -t :=9

# Splits without leader
bind -n 'M-\' split-window -h -c "#{pane_current_path}"
bind -n M--  split-window -v -c "#{pane_current_path}"

# Pane lifecycle
bind -n M-q kill-pane
bind -n M-z resize-pane -Z
bind -n M-t new-window -c "#{pane_current_path}"
```

**Step 2: Reload and verify**

```bash
tmux source-file ~/.config/tmux/tmux.conf
```

In an existing tmux session:
- Split with `Alt \` and `Alt -`, navigate with `Alt h/j/k/l`
- Open `Alt t` for a new window
- `Alt H/L` cycles windows
- `Alt z` zooms current pane

**Step 3: Commit**

```bash
git add tmux/tmux.conf
git commit -m "feat(tmux): add direct Alt-binds for navigation and splits"
```

---

### Task 5: Port helper scripts (sysinfo/cpu/ram/weather)

**Files:**
- Create: `tmux/scripts/sysinfo.sh`
- Create: `tmux/scripts/cpu.sh`
- Create: `tmux/scripts/ram.sh`
- Create: `tmux/scripts/weather.sh`

**Step 1: Copy verbatim from zellij**

```bash
cp /Users/vini/dev/dotfiles/zellij/scripts/sysinfo.sh \
   /Users/vini/dev/dotfiles/.worktrees/tmux-migration/tmux/scripts/sysinfo.sh
cp /Users/vini/dev/dotfiles/zellij/scripts/cpu.sh \
   /Users/vini/dev/dotfiles/.worktrees/tmux-migration/tmux/scripts/cpu.sh
cp /Users/vini/dev/dotfiles/zellij/scripts/ram.sh \
   /Users/vini/dev/dotfiles/.worktrees/tmux-migration/tmux/scripts/ram.sh
cp /Users/vini/dev/dotfiles/zellij/scripts/weather.sh \
   /Users/vini/dev/dotfiles/.worktrees/tmux-migration/tmux/scripts/weather.sh
chmod +x /Users/vini/dev/dotfiles/.worktrees/tmux-migration/tmux/scripts/*.sh
```

**Step 2: Verify they run**

```bash
~/.config/tmux/scripts/sysinfo.sh
~/.config/tmux/scripts/cpu.sh
~/.config/tmux/scripts/ram.sh
~/.config/tmux/scripts/weather.sh
```

Expected: each prints a short status string.

**Step 3: Commit**

```bash
git add tmux/scripts/
git commit -m "feat(tmux): port helper scripts from zellij"
```

---

### Task 6: Catppuccin Macchiato theme + statusbar layout

**Files:**
- Modify: `tmux/tmux.conf` (append before `run '~/.config/tmux/plugins/tpm/tpm'`)

**Step 1: Add catppuccin config**

Append before the `run '~/.config/tmux/plugins/tpm/tpm'` line:

```tmux
# ============================================================================
# Catppuccin theme + statusbar
# ============================================================================

set -g @catppuccin_flavor 'macchiato'
set -g @catppuccin_window_status_style "rounded"

# Statusbar layout
set -g status-position top
set -g status-justify left
set -g status-left-length 100
set -g status-right-length 100

set -g @catppuccin_status_module_text_bg "#{@thm_bg}"
set -g @catppuccin_window_default_text " #W"
set -g @catppuccin_window_current_text " #W"

# Left: session name with sapphire dot
set -g status-left "#[fg=#7dc4e4]●#[fg=#7dc4e4,bold] #S "

# Right: sysinfo + datetime (matches zellij layout)
set -g status-right "#[fg=#a5adcb]#(bash ~/.config/tmux/scripts/sysinfo.sh)  󰃭 #(date '+%a, %b %d  %H:%M')"
```

**Step 2: Reload and verify**

```bash
tmux source-file ~/.config/tmux/tmux.conf
```

Visually check: status bar at top, session name with blue dot on left, sysinfo + date on right, window list in the middle. Colors match Macchiato.

**Step 3: Commit**

```bash
git add tmux/tmux.conf
git commit -m "feat(tmux): catppuccin macchiato theme and statusbar"
```

---

### Task 7: Launchers (Alt c/d/e/g)

**Files:**
- Modify: `tmux/tmux.conf` (append in the Alt-binds section)

**Step 1: Add launcher binds**

Append to the Alt-binds section (before `# ===== Catppuccin`):

```tmux
# Launchers
# Claude: vertical split (matches zellij "direction Right"), kills pane on exit
bind -n M-c split-window -h -c "#{pane_current_path}" "zsh -ic 'claude --dangerously-skip-permissions'"

# Lazydocker: full-screen popup
bind -n M-d display-popup -E -w 90% -h 90% -d "#{pane_current_path}" "zsh -ic lazydocker"

# Nvim: new window (zellij opened it as a pane; new window is cleaner in tmux)
bind -n M-e new-window -c "#{pane_current_path}" "zsh -ic nvim"

# Lazygit: full-screen popup
bind -n M-g display-popup -E -w 90% -h 90% -d "#{pane_current_path}" "zsh -ic lazygit"
```

**Step 2: Reload and verify**

```bash
tmux source-file ~/.config/tmux/tmux.conf
```

Test each launcher:
- `Alt c` — splits with claude (assumes `claude` is on PATH)
- `Alt d` — popup with lazydocker
- `Alt e` — new window with nvim
- `Alt g` — popup with lazygit

If any launcher errors with "command not found", the underlying tool isn't installed; that's a tooling issue, not a config issue.

**Step 3: Commit**

```bash
git add tmux/tmux.conf
git commit -m "feat(tmux): add Alt-prefixed launchers (claude/lazydocker/nvim/lazygit)"
```

---

### Task 8: Sessionizer (Alt p)

**Files:**
- Create: `tmux/scripts/sessionizer.sh`
- Modify: `tmux/tmux.conf` (append launcher bind)

**Step 1: Write the sessionizer**

Create `tmux/scripts/sessionizer.sh`:

```bash
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
```

```bash
chmod +x /Users/vini/dev/dotfiles/.worktrees/tmux-migration/tmux/scripts/sessionizer.sh
```

**Step 2: Add bind**

Append to launcher section in `tmux/tmux.conf`:

```tmux
# Sessionizer
bind -n M-p display-popup -E -w 60% -h 50% "zsh -ic '~/.config/tmux/scripts/sessionizer.sh'"
```

**Step 3: Reload and verify**

```bash
tmux source-file ~/.config/tmux/tmux.conf
```

- Press `Alt p`, type a few chars from a known project name, hit Enter.
- Verify you switch into a session named after the project basename.
- Press `Alt p` again, pick another project, verify the previous session persists (`tmux ls`).

**Step 4: Commit**

```bash
git add tmux/scripts/sessionizer.sh tmux/tmux.conf
git commit -m "feat(tmux): port sessionizer from zellij with switch-client"
```

---

### Task 9: Edit-scrollback popup (Alt i)

**Files:**
- Modify: `tmux/tmux.conf` (append in Alt-binds section)

**Step 1: Add the bind**

```tmux
# Edit scrollback in $EDITOR (matches zellij Alt+i)
bind -n M-i run-shell "tmux capture-pane -p -S -50000 > /tmp/tmux-scrollback-#{pane_id}.log && tmux display-popup -E -w 90% -h 90% '${EDITOR:-nvim} /tmp/tmux-scrollback-#{pane_id}.log'"
```

**Step 2: Reload and verify**

```bash
tmux source-file ~/.config/tmux/tmux.conf
```

- Generate some output in a pane (e.g. `ls -la /usr/bin`)
- Press `Alt i`, scrollback opens in nvim
- Quit nvim, popup closes

**Step 3: Commit**

```bash
git add tmux/tmux.conf
git commit -m "feat(tmux): edit scrollback in editor via Alt+i"
```

---

### Task 10: Leader-prefixed binds (window management, copy-mode)

**Files:**
- Modify: `tmux/tmux.conf` (append)

**Step 1: Add leader binds section**

Append after the Alt-binds section, before `# ===== Catppuccin`:

```tmux
# ============================================================================
# Leader-prefixed binds (less-frequent commands)
# ============================================================================

# Detach (zellij Alt+s d → C-a d)
bind d detach-client

# Rename window (zellij C-a , in zellij rename mode → C-a ,)
bind ',' command-prompt -I "#W" "rename-window '%%'"

# Move window left/right
bind '[' swap-window -t -1 \; previous-window
bind ']' swap-window -t +1 \; next-window

# Copy-mode (vi-style)
setw -g mode-keys vi
bind v copy-mode
bind -T copy-mode-vi 'v' send-keys -X begin-selection
bind -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel "pbcopy"

# Search in buffer
bind '/' copy-mode \; send-keys ?
```

**Step 2: Reload and verify**

```bash
tmux source-file ~/.config/tmux/tmux.conf
```

- `C-a d` detaches
- Re-attach with `tmux a`
- `C-a v` enters copy-mode, `v` selects, `y` copies to macOS clipboard, paste with Cmd+V to verify
- `C-a ,` prompts to rename
- `C-a [` / `C-a ]` reorders windows

**Step 3: Commit**

```bash
git add tmux/tmux.conf
git commit -m "feat(tmux): leader-prefixed window mgmt and vi copy-mode"
```

---

### Task 11: Update README install instructions

**Files:**
- Modify: `README.md` (Dependencies and Symlinks sections)

**Step 1: Read current README**

Read `README.md` lines 7-40 to confirm current state.

**Step 2: Update Dependencies block**

In the `brew install` line, add `tmux` and remove `zellij` (do NOT remove zellij yet — Phase 4 handles that). For now just add tmux:

```diff
-brew install neovim lazygit zoxide oh-my-posh atuin mise fzf ripgrep fd git-delta stylua zsh-vi-mode ical-buddy zellij fastfetch jq
+brew install neovim lazygit zoxide oh-my-posh atuin mise fzf ripgrep fd git-delta stylua zsh-vi-mode ical-buddy zellij tmux fastfetch jq
```

Remove the zjstatus download lines (lines ~21-23) — wait until Phase 4 to keep zellij functional during burn-in.

**Step 3: Update Symlinks block**

Add a `tmux` line:

```diff
 ln -s ~/dev/dotfiles/zellij ~/.config/zellij
+ln -s ~/dev/dotfiles/tmux ~/.config/tmux
 ln -s ~/dev/dotfiles/karabiner ~/.config/karabiner
```

Add TPM install instruction below the symlinks block:

```markdown
### TPM (tmux plugin manager)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
# Then start tmux and press: C-a I
```
```

**Step 4: Verify README still parses cleanly** (visual check)

**Step 5: Commit**

```bash
git add README.md
git commit -m "docs(readme): add tmux install and symlink instructions"
```

---

### Task 12: Phase 1 burn-in checkpoint

No code change. **Use the new tmux setup for at least one full work day.** Track friction:
- Missing keybinds → add them
- Color/contrast issues → tweak Catppuccin overrides
- Slow status refresh → adjust `status-interval`
- Lazygit/lazydocker popup size → adjust `-w` / `-h`

Resolve all friction before proceeding to Phase 3.

**Decision point:** if tmux feels worse than zellij after burn-in, abandon migration (delete worktree, no harm done).

---

## Phase 3: Cutover

### Task 13: Replace zsh chpwd hook

**Files:**
- Modify: `zsh/.zshrc:96-106`

**Step 1: Read the current hook**

Read `/Users/vini/dev/dotfiles/.worktrees/tmux-migration/zsh/.zshrc` lines 90-110.

**Step 2: Replace the function**

Change:

```zsh
# Update Zellij tab name to current directory basename
function _zellij_tab_name() {
    if [[ -n "$ZELLIJ" ]]; then
        local tab_name=$(basename "$PWD" | tr '.' '-')
        command zellij action rename-tab "$tab_name"
    fi
}
chpwd_functions+=(_zellij_tab_name)
_zellij_tab_name
```

To:

```zsh
# Update tmux window name to current directory basename
function _tmux_window_name() {
    if [[ -n "$TMUX" ]]; then
        local name=$(basename "$PWD" | tr '.' '-')
        command tmux rename-window "$name"
    fi
}
chpwd_functions+=(_tmux_window_name)
_tmux_window_name
```

**Step 3: Verify**

In a new shell inside tmux:
```bash
cd ~/dev/dotfiles
tmux display-message -p '#W'
```
Expected: `dotfiles`.

```bash
cd ~/.config
tmux display-message -p '#W'
```
Expected: `.config` (or `-config` after the `tr '.' '-'`).

**Step 4: Commit**

```bash
git add zsh/.zshrc
git commit -m "feat(zsh): rename tmux window on chpwd"
```

---

### Task 14: Update wezterm default_prog

**Files:**
- Modify: `wezterm/behavior.lua:21`

**Step 1: Read current line**

Read `/Users/vini/dev/dotfiles/.worktrees/tmux-migration/wezterm/behavior.lua` lines 18-25.

**Step 2: Replace default_prog**

Change:
```lua
default_prog = { "/opt/homebrew/bin/zellij" },
```

To:
```lua
default_prog = { "/opt/homebrew/bin/tmux", "new-session", "-A", "-s", "main" },
```

**Step 3: Verify**

Quit wezterm, reopen. Expected: lands inside a tmux session named `main`. `tmux ls` shows `main`. Re-opening another wezterm window attaches to the same `main` session.

**Step 4: Commit**

```bash
git add wezterm/behavior.lua
git commit -m "feat(wezterm): launch tmux as default_prog"
```

---

### Task 15: Update wezterm comment

**Files:**
- Modify: `wezterm/keys.lua:5`

**Step 1: Replace the comment**

Change:
```lua
-- Multiplexing is handled by Zellij.
```

To:
```lua
-- Multiplexing is handled by tmux.
```

**Step 2: Commit**

```bash
git add wezterm/keys.lua
git commit -m "chore(wezterm): update multiplexer comment"
```

---

## Phase 4: Removal

### Task 16: Delete zellij directory

**Files:**
- Delete: `zellij/` (entire directory)

**Step 1: Confirm zellij is no longer in use**

```bash
pgrep -a zellij  # should output nothing
```

If output exists, kill those processes first.

**Step 2: Remove files**

```bash
rm -rf /Users/vini/dev/dotfiles/.worktrees/tmux-migration/zellij
```

**Step 3: Remove the symlink**

```bash
rm ~/.config/zellij
```

**Step 4: Commit**

```bash
git add -A zellij
git commit -m "chore: remove zellij configuration"
```

---

### Task 17: Brew uninstall + README cleanup

**Files:**
- Modify: `README.md` (Dependencies + Symlinks sections — remove zellij refs)

**Step 1: Remove zellij from README**

In `README.md`:
- Drop `zellij` from the `brew install` line.
- Drop the `zjstatus.wasm` curl block.
- Drop the `ln -s ~/dev/dotfiles/zellij ...` line.

**Step 2: Brew uninstall**

```bash
brew uninstall zellij
```

**Step 3: Update memory note**

The `zellij_layout.md` memory note becomes obsolete. Either delete or annotate as historical.

**Step 4: Commit**

```bash
git add README.md
git commit -m "docs(readme): drop zellij references"
```

---

### Task 18: Switch ~/.config/tmux symlink to main repo

After the worktree is merged to master, the temporary `~/.config/tmux` → worktree symlink must be re-pointed at the main repo.

**Step 1: Re-symlink**

```bash
ln -snf ~/dev/dotfiles/tmux ~/.config/tmux
```

**Step 2: Verify**

```bash
ls -la ~/.config/tmux
tmux source-file ~/.config/tmux/tmux.conf
```

No commit — this is a local environment change.

---

## Follow-up (separate task, not in this plan)

Rewrite `nvim/lua/plugins/ai/zellij-claude.lua` as `tmux-claude.lua`:
- Replace `zellij action write-chars` calls with `tmux send-keys -t <target>`
- Replace pane-direction detection with tmux pane finding (`tmux list-panes -F '#{pane_id} #{pane_title}'`)
- Update keybinds in `nvim/lua/plugins/editor/review.lua` if they reference the old module

This unblocks `<leader>aS` (send review comments) and `<leader>aP` (send prompt) from nvim once tmux is the multiplexer.

---

## Verification Checklist (end of Phase 4)

- [ ] `tmux` launches via wezterm with status bar visible
- [ ] All Alt-binds from the design table work
- [ ] Sessionizer (`Alt p`) creates and switches sessions
- [ ] Window names update on `cd`
- [ ] `vim-tmux-navigator` allows seamless `Alt h/j/k/l` between nvim splits and tmux panes
- [ ] Resurrect (`C-a C-s`) saves, continuum auto-restores on startup
- [ ] No `zellij` processes running
- [ ] No `~/.config/zellij` symlink
- [ ] No `dotfiles/zellij/` directory
- [ ] Brew formula `zellij` uninstalled

---

## Estimated Effort

- Tasks 1-11 (Phase 1): ~2-4 hours
- Task 12 (burn-in): ~1 work day, hands-off coding
- Tasks 13-15 (cutover): ~30 minutes
- Tasks 16-18 (removal): ~15 minutes
- Total active: ~3-5 hours over 1-2 days
