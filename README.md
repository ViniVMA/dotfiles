# dotfiles

macOS dev environment — Neovim, Wezterm, AeroSpace, Karabiner, SketchyBar, Zsh. Everything symlinked from `~/dev/dotfiles`.

## Installation

### Dependencies

```bash
# CLI tools
brew install neovim lazygit zoxide oh-my-posh atuin mise fzf ripgrep fd git-delta stylua zsh-vi-mode ical-buddy

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
ln -s ~/dev/dotfiles/karabiner ~/.config/karabiner
ln -s ~/dev/dotfiles/sketchybar ~/.config/sketchybar

# Individual files
ln -s ~/dev/dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/dev/dotfiles/aerospace/.aerospace.toml ~/.aerospace.toml
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

Terminal emulator. All keybinds use **Alt** as modifier. Font: Maple Mono (16pt), with Monaspace and Commit Mono fallbacks.

### Panes & Tabs

| Key | Action |
|-----|--------|
| `Alt + t` | New tab |
| `Alt + \` | Split horizontal |
| `Alt + -` | Split vertical |
| `Alt + h/j/k/l` | Focus pane left / down / up / right |
| `Alt + H` / `Alt + L` | Previous / next tab |
| `Alt + 1-9` | Go to tab by index |
| `Alt + q` | Close pane |
| `Alt + x` | Swap pane |
| `Alt + z` | Toggle pane zoom |
| `Shift+Alt + arrows` | Resize pane |
| `Alt + m` | Enter move-tab mode (h/j/k/l to reorder, Esc to exit) |
| `Alt + r` | Enter resize-pane mode (h/j/k/l to resize, Esc to exit) |

### Navigation & Tools

| Key | Action |
|-----|--------|
| `Alt + f` | Search |
| `Alt + [` | Copy mode |
| `Alt + i` | Quick-select URL and open |
| `Alt + s` | Fuzzy workspace switcher |
| `Alt + p` | Sessionizer (zoxide projects) |
| `Alt + P` | List workspaces |
| `Alt + .` | Command palette |
| `Alt + Enter` | Toggle fullscreen |
| `Alt + Up/Down` | Scroll line up / down |

### Launch in New Tab

| Key | Action |
|-----|--------|
| `Alt + e` | Neovim |
| `Alt + d` | Lazydocker |
| `Alt + c` | Claude Code |

### Nvim Integration

`Ctrl + ;` — If inside Neovim with no split, creates a bottom terminal pane (30%). If already split, zooms back to the Neovim pane.

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
├── lazygit/        # LazyGit config (not symlinked)
├── nushell/        # Nushell config (not symlinked)
├── old-nvim/       # Deprecated: previous LazyVim config
└── old-wezterm/    # Deprecated: previous Wezterm config
```
