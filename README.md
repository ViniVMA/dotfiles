# dotfiles

macOS dev environment — Neovim, kitty, herdr, AeroSpace, Karabiner, SketchyBar, Zsh. Everything symlinked from `~/dev/dotfiles`.

## Installation

### Dependencies

```bash
# CLI tools
brew install neovim lazygit zoxide oh-my-posh atuin mise fzf ripgrep fd git-delta stylua zsh-vi-mode ical-buddy herdr fastfetch jq dtach

# GUI apps
brew install --cask wezterm nikitabobko/tap/aerospace karabiner-elements font-hack-nerd-font sf-symbols

# SketchyBar
brew install felixkratz/formulae/sketchybar
brew services start sketchybar
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.31/sketchybar-app-font.ttf -o ~/Library/Fonts/sketchybar-app-font.ttf

```

### Symlinks

```bash
# Config directories
ln -s ~/dev/dotfiles/nvim ~/.config/nvim
ln -s ~/dev/dotfiles/wezterm ~/.config/wezterm
ln -s ~/dev/dotfiles/tmux ~/.config/tmux
ln -s ~/dev/dotfiles/karabiner ~/.config/karabiner
ln -s ~/dev/dotfiles/sketchybar ~/.config/sketchybar

# herdr keeps sockets/logs in ~/.config/herdr, so link the file and the
# scripts dir rather than the whole directory.
ln -s ~/dev/dotfiles/herdr/config.toml ~/.config/herdr/config.toml
ln -s ~/dev/dotfiles/herdr/scripts ~/.config/herdr/scripts

# Individual files
ln -s ~/dev/dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/dev/dotfiles/aerospace/.aerospace.toml ~/.aerospace.toml
```

### TPM (tmux plugin manager)

Only needed for the legacy tmux fallback in `tmux/`; herdr has no plugin manager.

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
# Then start tmux and press: prefix + I (default prefix is C-a)
```

## Keyboard Philosophy

Everything is built around a **Hyper key** (Cmd+Alt+Ctrl+Shift) mapped to Caps Lock via Karabiner-Elements. Holding Caps Lock activates Hyper, tapping it sends Escape, and Shift+CapsLock toggles actual Caps Lock. This gives a dedicated modifier layer for AeroSpace window management without conflicting with any app shortcuts.

## AeroSpace

Tiling window manager. All main bindings use **Hyper** (Caps Lock held).

### Main Mode

| Key | Action |
|-----|--------|
| `Hyper + h/j/k/l` | Focus left / down / up / right |
| `Hyper + -` / `Hyper + =` | Resize -50 / +50 |
| `Hyper + b` | Workspace: Browsing |
| `Hyper + c` | Workspace: Communication |
| `Hyper + d` | Workspace: Development |
| `Hyper + e` | Workspace: Extra |
| `Hyper + f` | Workspace: File Management |
| `Hyper + g` | Workspace: Gaming |
| `Hyper + m` | Workspace: Music |
| `Hyper + o` | Workspace: Other |
| `Hyper + p` | Workspace: Planning |
| `Hyper + r` | Workspace: Research |
| `Hyper + s` | Workspace: System Administration |
| `Hyper + w` | Workspace: Writing |
| `Hyper + t` | Workspace: Tooling |
| `Hyper + v` | Workspace: VM |
| `Hyper + 1-4` | Workspace: Project 1–4 |
| `` Hyper + ` `` | Workspace back-and-forth |
| `Hyper + a` | Enter service mode |

### Service Mode (Hyper+a, then key)

| Key | Action |
|-----|--------|
| `h/j/k/l` | Move window left / down / up / right |
| `Shift + h/j/k/l` | Join with left / down / up / right |
| `/` | Layout: tiles |
| `,` | Layout: accordion |
| `r` | Reset (flatten) workspace |
| `f` | Toggle floating / tiling |
| `Backspace` | Close all windows but current |
| `b/c/d/e/g/m/o/p/s/t/w/v/1-4` | Move window to named workspace |
| `Shift + f` / `Shift + r` | Move to File Management / Research |
| `n` | Move workspace to next monitor |
| `Up` / `Down` | Volume up / down |
| `Shift + Down` | Mute |
| `Esc` | Reload config + exit service mode |

### Auto-Assign Rules

| App | Workspace |
|-----|-----------|
| WezTerm | Development |
| Zed, VS Code, Postman | Tooling |
| Chrome | Project 2 |
| Slack, Zoom, Notion Calendar, WhatsApp, Messages, FaceTime, Mail | Communication |
| Zen Browser, Safari | Browsing |
| Spotify, VinylPod, Apple Music, Podcasts | Music |
| Reminders, Notes, Calendar, Freeform, Todoist*, TextEdit* | Planning |
| Finder, Preview, Photos, Image Capture | File Management |
| System Settings, App Store, Activity Monitor, Disk Utility, Console, Terminal, System Information, Company Portal, Super App Store | System Administration |
| Bitwarden, Keeper, Passwords | Extra |
| Claude Island, Pieces, Dictionary, Books | Research |
| KIRA, Chess | Gaming |
| TeamViewer, Screen Sharing | VM |

## Wezterm

Terminal emulator only — multiplexing is handled by herdr (launched automatically as session `main`; kitty leaves it opt-in instead). Font: Geist Mono (15pt), with Maple Mono, Departure Mono, Commit Mono, and Monaspace fallbacks.

| Key | Action |
|-----|--------|
| `Alt + .` | Command palette |
| `Alt + Enter` | Toggle fullscreen |
| `Shift + Enter` | Send newline |
| `Ctrl + Space` | Send null character |

## herdr

Terminal multiplexer (agent-aware). **Opt-in per tab, not automatic** — plain
`Cmd+T` tabs are ordinary login shells. Start herdr with `Cmd+Shift+T` (own
session named after the directory, via `herdr/scripts/herdr-tab.sh`) or `Cmd+P`
(project picker). Wezterm still launches it as session `main` via `default_prog`.
Leader is `C-a`. Config: `herdr/config.toml`, a keybind-for-keybind port of the
old `tmux/tmux.conf`.

herdr sessions are server-backed and outlive the tab that started them, which is
why they are not auto-launched: one per tab would quietly accumulate. Inspect
with `herdr session list`, end with `herdr session stop <name>`.

Layer mapping: tmux session -> herdr session (one per kitty tab), tmux window ->
herdr tab, tmux pane -> herdr pane. herdr adds a workspace layer above tabs that
the tmux config had no equivalent for; those bindings are left on herdr defaults.

### Panes

| Key | Action |
|-----|--------|
| `C-a h/j/k/l` | Focus pane left / down / up / right |
| `C-a \` | Split right |
| `C-a -` | Split down |
| `C-a z` | Toggle pane zoom |
| `C-a q` | Close pane |
| `C-a Up/Down/Left/Right` | Resize pane (one-shot; no `-r` repeat) |
| `C-a r` | Resize mode |
| `C-a M-h/j/k/l` | Swap pane with neighbor (flattened from tmux's move mode) |
| `C-a i` | Edit current pane scrollback in Neovim |

### Tabs (tmux windows)

| Key | Action |
|-----|--------|
| `C-a t` | New tab |
| `C-a H` / `C-a L` | Previous / next tab |
| `C-a 1-9` | Jump to tab by index |
| `C-a ,` | Rename tab |
| `C-S-[` / `C-S-]` | Move tab left / right (kitty — herdr has no tab-reorder action) |

### Sessions & Copy

| Key | Action |
|-----|--------|
| `C-a p` | Project picker (zoxide + fzf) — opens/focuses a **workspace** in the current session |
| `Cmd+Shift+R` / `hl` | Reattach to the most recently active session |
| `C-a d` | Detach |
| `C-a R` | Reload config |
| `C-a v` | Enter copy mode |
| `C-a w` | Space picker |
| `C-a b` | Toggle sidebar |

### Spaces (workspaces)

herdr's layer above tabs; tmux had no equivalent.

| Key | Action |
|-----|--------|
| `C-a N` | New space |
| `C-a W` | Rename space |
| `C-a Shift+1-9` | Jump to space by index |
| `C-a S-D` | Close space |

Tab naming is handled by the
[herdr-automatic-rename](https://github.com/qu8n/herdr-automatic-rename) plugin,
which names each tab after its foreground program (`nvim`, `claude`, `bun`) and
falls back to the shell name at a bare prompt. `prompt_new_tab_name = false`, so
`C-a t` just makes a tab.

```bash
herdr plugin install qu8n/herdr-automatic-rename --yes
```

It drives herdr's own event system (`tab.created`, `tab.focused`, `pane.exited`,
`workspace.renamed`, …), so it covers panes started without a shell — `C-a c`
claude, `C-a e` nvim — which a shell hook alone cannot see. The zsh hook sourced
from `.zshrc` only adds immediate per-command renames; the plugin holds a lock so
the two don't race.

By default it also prefixes workspaces, tabs and agents with their `[1]`-`[9]`
jump-key number, so labels read `[1] claude`. Unlike a hand-maintained index this
is recomputed on every event, so it never goes stale.

Configuration is optional — every setting has a working default. Copy
`config.example.sh` to `~/.config/herdr-automatic-rename/config.sh` (note: *not*
herdr's plugin config dir, which the engine ignores):

| Setting | Default | Purpose |
|---------|---------|---------|
| `NAME_TABS` | `1` | Auto-name tabs at all |
| `AUTO_INDEX` | `1` | `[N]` jump-key prefixes |
| `SHOW_PROGRAM_ARGS` | `0` | Program name only, vs full command |
| `MAX_NAME_LEN` | `20` | Label truncation |
| `IGNORED_PROGRAMS` | `ls cat cd fzf sudo …` | Quick commands that shouldn't take over the name |
| `PROGRAM_ALIASES` | — | `<program>=<label>` overrides |

Requires `jq` and bash. A name typed with `C-a ,` takes precedence and stops
automatic renaming for that tab until reset (`Reset tab to automatic naming`
action).

herdr itself has no process-derived tab naming: an unnamed tab shows a bare
number, and only pane borders show the process
(`show_agent_labels_on_pane_borders = true`). Nor is there any tab spacing,
padding or density setting — `UiConfig` ships `pane_gaps` for split panes and
`row_gap` for sidebar rows, but nothing for the tab row, and the gaps between tabs
are hardcoded in the renderer. Tab height is one character row, i.e. kitty's
`font_size`.

The tmux setup forced every window name to the current folder via a zsh `chpwd`
hook. That carryover was dropped: the folder name is already in kitty's tab
title, and it read identically across every tab in a project. Note that herdr
keeps auto-named labels *compact* while public tab ids stay stable, so closing a
middle tab does not leave gaps in what you see.

Note herdr's tab and space numbers are stable public ids, not positions: open
tabs 1-5, close 2 and 3, and the rest stay 1, 4, 5 while the next new tab gets 6.

### Launchers

| Key | Action |
|-----|--------|
| `C-a c` | Claude Code (pane) |
| `C-a e` | Neovim (pane) |
| `C-a g` | Lazygit (popup) |
| `C-a J` | Lazyjira (popup) |

### Sidebar

Replaces the old 2-line tmux status bar. Shows per-agent state
(blocked / working / done / idle) grouped by space, plus branch and git status
per workspace. Styling is herdr's default apart from the koda-green accent.

Each space shows two rows: `state_icon` + `workspace`, then a dimmed `branch` +
`git_status`. Styling a token requires declaring `rows`, so those restate herdr's
defaults for spaces with only the `branch` style changed.

Accenting *only* the focused space's branch is not expressible and was settled as a
uniform dim. herdr's contextual default bolds the workspace **name** on focus but
renders `branch` the same either way, and no conditional styling exists —
`rows_by_agent` is the only `rows_by_*`, and no `[theme.custom]` token targets a
focused row. An `fg` colours every branch. The config comment records what a real
implementation would take.

There is **no system-metric row**. getpipher/herdr-sysmon was tried twice and
dropped both times: it collects one set of whole-machine values and pushes it to
*every* workspace (`push_all` does this by design), so cpu/ram rendered identically
on every space — repeated data, not per-workspace usage. Per-workspace numbers are
obtainable by summing each pane's process tree, but that means owning a poller, and
`ps %CPU` on macOS is a lifetime average so CPU would need delta sampling to mean
anything. sketchybar already covers battery and clock at the OS level.

Note also there is **no focus-conditional styling**: `rows_by_agent` is the only
`rows_by_*` in the binary, so an `fg` on `branch` would colour every space's branch
rather than just the focused one.

Only settings that differ from herdr's defaults live in `herdr/config.toml`, so
bindings like `C-a h/j/k/l`, `C-a z`, `C-a r`, `C-a 1-9`, `C-a w`, `C-a R` and
`C-a -` are absent from it — they already match herdr's own defaults. The tables
above are the full keymap.

The lazydocker launcher was dropped (it was never installed, so `C-a D` was a dead
key under tmux too). Re-adding it means restoring `close_workspace` off
`prefix+shift+d`, which it now uses again:

```toml
[[keys.command]]
key = "prefix+shift+d"
type = "popup"
command = "lazydocker"
width = "90%"
height = "90%"
```

### Plugins

herdr has a plugin system (`herdr plugin --help`, absent from the top-level usage).

| Plugin | Purpose |
|--------|---------|
| [qu8n/herdr-automatic-rename](https://github.com/qu8n/herdr-automatic-rename) | Names tabs after their foreground program; `[N]` jump-key prefixes |
| [persiyanov/herdr-reviewr](https://github.com/persiyanov/herdr-reviewr) | Git diff review sidebar — comment on lines, send the comments to the agent |
| [thanhdat77/herdr-navigator](https://github.com/thanhdat77/herdr-navigator) | Fuzzy index over workspaces, agents, projects, sessions and zoxide dirs |
| [Tyru5/herdr-floax](https://github.com/Tyru5/herdr-floax) | Floating scratch shell, one per space (tmux-floax for herdr) |

```bash
herdr plugin install qu8n/herdr-automatic-rename --yes
herdr plugin install persiyanov/herdr-reviewr --yes
herdr plugin install thanhdat77/herdr-navigator --ref v0.3.3 --yes
herdr plugin install Tyru5/herdr-floax --yes
```

`C-a Shift+V` toggles reviewr and `C-a n` opens Navigator. No plugin here ships a
default key, so every binding is ours, using `type = "plugin_action"` — a
`[[keys.command]]` type that is also missing from `--default-config`:

```toml
[[keys.command]]
key = "prefix+shift+v"
type = "plugin_action"
command = "persiyanov.reviewr.toggle"

[[keys.command]]
key = "prefix+n"
type = "plugin_action"
command = "herdr-navigator.open"

[[keys.command]]
key = "prefix+f"
type = "plugin_action"
command = "herdr-floax.toggle"
```

Navigator's README suggests `prefix+t`, which is `new_tab` here — hence `prefix+n`,
free because `next_tab` moved to `prefix+shift+l`. It replaced
[jeffarese/herdr-bar](https://github.com/jeffarese/herdr-bar), a narrower palette
over just agents/tabs/spaces; running both meant two pickers on two keys. Its
`jump-back` (toggle current ↔ previous workspace) and `open-side` (persistent side
pane) actions are unbound.

Pinned to `v0.3.3` because that is what its docs pin, and the templates/Quick
Actions sources need "Herdr Plus" so they stay inert here. Workspaces it creates are
labelled `dir: <name>`, which looks odd in the sidebar but is **load-bearing**:
`src/sources.rs` derives the workspace kind from that prefix, and `app.rs` requires
kind `Dir` to focus an existing workspace rather than create another. Rename it and
you get duplicates.

floax uses `prefix+f`, its own documented default. It builds a Rust binary at
install (`cargo build --release`) and needs a detach tool to persist the scratch
shell across dismissals, choosing in strict order: `dtach`, `abduco`, `tmux`, else a
plain non-persistent shell. **`dtach` is why `dtach` is in the brew list** — without
it the order falls through to `tmux`, which works but loads all of
`~/.config/tmux/tmux.conf` (statusbar, `C-a` prefix, TPM) inside the floating pane.
It runs on its own socket (`-L herdr-floax`) so real tmux sessions are untouched,
but herdr's client grabs `C-a` first, leaving that tmux layer visible and
undrivable. `dtach` has no UI or config, so nothing shows. Its config is
`~/.config/herdr/plugins/config/herdr-floax/floax.conf` (`width_pct`,
`height_pct`, `key_hint`, `backdrop`). The binding was added by hand rather than
with its `scripts/install-keybinding.sh`, which appends to the end of
`config.toml`. Caveat: the backdrop is a solid fill, not a dimmed view of the
workspace behind it — herdr gives plugins no overlay primitive to composite with.

reviewr is local-only: it reads git, makes no external API calls, and comments stay
in memory until you explicitly send them. The PR tab additionally reads GitHub via
an authenticated `gh`. Its own settings (theme, `base_branches`, `default_scope`,
`navigator_position`, `auto_open`, key rebinds) live in
`~/.config/herdr/plugins/config/persiyanov.reviewr/config.toml`, which is empty by
default. Note comments are session-only — closing the pane without sending or
copying loses them.

### Not carried over from tmux

herdr has no equivalent for these, so they are gone rather than reimplemented:

- `select-layout main-vertical-mirrored` (`C-a V`) — no layout presets
- `swap-window` (`C-a [` / `]`) — kitty's `C-S-[` / `]` covers tab reordering
- Search in scrollback (`C-a /`) — copy mode exists, search binding does not
- Double-tap `C-a` to send a literal `C-a` to the shell
- `destroy-unattached` — herdr sessions are server-backed and survive tab close;
  clean up with `herdr session stop <name>`. This is why herdr is opt-in per tab
  rather than auto-launched like tmux was.

### Project picker

`C-a p` (and `Cmd+P` in kitty) runs `herdr/scripts/sessionizer.sh`: pick a zoxide
project with fzf and it opens as a **workspace in the session you're already in**,
rather than spawning another kitty tab with its own herdr session. An existing
workspace for that project is focused instead of duplicated, matched on its label
with the plugin's `[N]` prefix stripped.

It picks a target in three steps:

1. Inside a herdr pane — `$HERDR_SOCKET_PATH` already points at the session.
2. As a kitty overlay over a herdr tab — `herdr-tab.sh` tags the tab with
   `project=<session>`, so the socket path is derivable from `kitty @ ls`.
3. Neither, i.e. a plain shell tab — falls back to opening or focusing a kitty tab
   running `herdr --session <name>`, the old behavior.

So a whole new session is only created when there is no session to add to.

### Recovering a session

Each session runs its own `herdr server` daemon, reparented to launchd (PPID 1),
so closing the terminal kills only the client — the session keeps running.

| What happened | How to get back |
|---------------|-----------------|
| Closed the terminal by mistake | `Cmd+Shift+R`, or `hl` in a shell — attaches to the most recently active session (`herdr/scripts/herdr-last.sh`, newest `session.json` mtime) |
| Closed one tab | `Cmd+Shift+T` in the same directory reattaches by name |
| Want a specific one | `herdr session list`, then `herdr session attach <name>` |
| Server stopped / rebooted | Layout is restored from `session.json`; `pane_history = true` also restores pane scrollback, and `resume_agents_on_restore` resumes claude conversations |

`herdr session stop <name>` stops without destroying — it stays listed as
`stopped` and restarts on next attach. Only `herdr session delete <name>` removes
it, and only when already stopped.
- Repeatable (`-r`) arrow resize — use resize mode for sustained resizing
- TPM and its plugins (tmux-sensible, vim-tmux-navigator, tmux-resurrect,
  tmux-continuum) — herdr has no plugin manager; persistence is built in
- sidekick.nvim's external-pane mode — its mux layer speaks only tmux/zellij,
  so cli sessions now run in an nvim terminal window

### Mouse

Mouse capture is on, with copy-on-select. Pane apps that request mouse (nvim,
lazygit, less, htop) still receive it. Wheel scrolls 3 lines per notch.

## Neovim

Leader key is **Space**. Plugin manager: lazy.nvim. Fuzzy finder: fzf-lua. File explorer: Neo-tree (right side). Formatting on save via conform.nvim.

### General

| Key | Action |
|-----|--------|
| `Q` | Record macro (`q` is disabled) |
| `Esc` | Clear search highlight |
| `Ctrl + s` | Save file |
| `Ctrl + h/j/k/l` | Move focus between splits |
| `Ctrl + j/k` | Jump 10 lines down / up |
| `Alt + j/k` | Move line(s) up / down |
| `J/K` (visual) | Move selected lines down / up |
| `< / >` (visual) | Indent and keep selection |
| `s` | Flash jump |
| `S` | Flash treesitter select |
| `F2` | Search and replace word under cursor |
| `gco` / `gcO` | Add comment below / above |
| `leader r` | Reload config |
| `leader -` / `leader \|` | Split below / right |
| `leader wd` | Close window |
| `leader qq` | Quit all |
| `leader z` / `leader Z` | Zen mode / Zoom mode |
| `leader ?` | Show buffer keymaps (which-key) |

### Buffers

| Key | Action |
|-----|--------|
| `Shift + h` / `Shift + l` | Previous / next buffer |
| `leader bb` or `` leader ` `` | Switch to alternate buffer |
| `leader bd` | Delete buffer |
| `leader bo` | Delete other buffers |
| `leader bD` | Delete buffer and window |
| `leader be` | Buffer explorer (Neo-tree) |

### Find / Search (fzf-lua)

| Key | Action |
|-----|--------|
| `leader Space` | Find files |
| `leader /` | Live grep |
| `leader ,` | Switch buffer (MRU) |
| `leader :` | Command history |
| `leader ff` | Find files |
| `leader fb` | Buffers |
| `leader fr` | Recent files |
| `leader fe` / `leader e` | File explorer (Neo-tree) |
| `leader fE` / `leader E` | File explorer (cwd) |
| `leader fg` | GrugFar (find & replace) |
| `leader ss` | Document symbols |
| `leader sS` | Workspace symbols |
| `leader sb` | Grep current buffer |
| `leader sd` / `leader sD` | Document / workspace diagnostics |
| `leader sh` | Help pages |
| `leader sH` | Highlight groups |
| `leader sk` | Keymaps |
| `leader sm` | Marks |
| `leader sj` | Jumplist |
| `leader sl` | Location list |
| `leader sq` | Quickfix list |
| `leader sR` | Resume last search |
| `leader s"` | Registers |
| `leader sa` | Auto commands |
| `leader sc` | Command history |
| `leader sC` | Commands |
| `leader sM` | Man pages |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | References |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `gD` | Go to declaration |
| `K` | Hover (merged from all LSP clients) |
| `gK` | Signature help |
| `leader ca` | Code action |
| `leader cr` | Rename |
| `leader cf` | Format document |
| `leader cc` | Run codelens |
| `leader cC` | Refresh codelens |
| `leader ck` | Show diagnostics in fzf |
| `leader cd` | Line diagnostics (float) |
| `leader cs` | Symbols (Trouble) |
| `leader cS` | LSP refs/defs (Trouble) |
| `leader th` | Toggle inlay hints |
| `]d` / `[d` | Next / prev diagnostic |
| `]e` / `[e` | Next / prev error |
| `]w` / `[w` | Next / prev warning |

### Diagnostics / Trouble

| Key | Action |
|-----|--------|
| `leader xx` | Diagnostics (Trouble) |
| `leader xX` | Buffer diagnostics (Trouble) |
| `leader xL` | Location list (Trouble) |
| `leader xQ` | Quickfix list (Trouble) |
| `leader xq` | Toggle quickfix list |
| `]q` / `[q` | Next / prev quickfix/trouble item |

### Git

| Key | Action |
|-----|--------|
| `leader gg` | Lazygit |
| `leader gc` | Git commits (fzf) |
| `leader gs` | Git status |
| `leader gf` | Git files |
| `leader ge` | Git explorer (Neo-tree) |
| `leader gla` | Lazygit log |
| `leader glc` | Lazygit current file history |
| `leader glA` | Git log (picker) |
| `leader glC` | Git file commits (picker) |
| `leader gde` | Open diffview |
| `leader gdq` | Close diffview |

### AI (Sidekick)

| Key | Action |
|-----|--------|
| `leader aa` | Toggle Sidekick CLI (float) |
| `leader as` | Toggle Sidekick CLI (split right) |
| `leader ac` | Toggle Claude session |
| `leader ap` | Ask prompt |
| `Ctrl + .` | Switch focus to/from Sidekick |
| `Ctrl + q` | Toggle Sidekick (from terminal) |
| `Tab` | Jump to / apply next edit suggestion |

### GitHub (Octo)

| Key | Action |
|-----|--------|
| `leader oi` | List issues |
| `leader op` | List pull requests |
| `leader od` | List discussions |
| `leader on` | List notifications |
| `leader os` | Search GitHub |

## Shell (Zsh)

Prompt: [oh-my-posh](https://ohmyposh.dev/) (star theme). History: [atuin](https://atuin.sh/). Directory jumping: [zoxide](https://github.com/ajeetdsouza/zoxide). Tool versions: [mise](https://mise.jdx.dev/). Vi mode: [zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode). `vim` is aliased to `nvim`.

### Git Aliases

| Alias | Command |
|-------|---------|
| `g` | `git` |
| `gst` / `gss` | `git status` / `git status -s` |
| `ga` | `git add` |
| `gc` | `git commit -v` |
| `gca` | `git commit -v -a` |
| `gco` | `git checkout` |
| `gcm` | `git checkout master` |
| `gb` / `gba` | `git branch` / `git branch -a` |
| `gl` | `git pull` |
| `gp` | `git push` |
| `gm` | `git merge` |
| `gcp` | `git cherry-pick` |
| `gup` | `git fetch && git rebase` |
| `grh` / `grhh` | `git reset HEAD` / `git reset HEAD --hard` |
| `glg` / `glgg` | `git log --stat` / `git log --graph` |
| `ggpull` / `ggpush` | Pull / push current branch to origin |
| `ggpnp` | Pull then push current branch |

## File Layout

```
dotfiles/
├── nvim/           # Neovim (lazy.nvim, fzf-lua, Neo-tree, Sidekick, LSP)
├── wezterm/        # Wezterm terminal (modular Lua config)
├── aerospace/      # AeroSpace tiling window manager
├── karabiner/      # Karabiner-Elements (Caps Lock -> Hyper key)
├── sketchybar/     # SketchyBar status bar (AeroSpace workspaces, battery, clock, calendar)
├── zsh/            # Zsh config (.zshrc)
├── herdr/          # herdr multiplexer (agent sidebar, leader = C-a)
├── tmux/           # Legacy — replaced by herdr, kept as fallback
├── zellij/         # Legacy — replaced by tmux, kept temporarily for reference
├── lazygit/        # LazyGit config (not symlinked)
└── nushell/        # Nushell config (not symlinked)
```
