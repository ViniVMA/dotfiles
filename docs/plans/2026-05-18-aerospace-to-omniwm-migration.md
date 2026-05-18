# Aerospace → OmniWM Migration (Evaluation)

**Date:** 2026-05-18
**Status:** Plan validated; execution in progress
**Outcome target:** Decide on go/no-go after a 5-day evaluation

## 1. Goal, scope, and success criteria

**Goal.** Time-boxed evaluation of OmniWM (https://github.com/BarutSRB/OmniWM) as
a replacement for Aerospace, without burning the boats. Aerospace stays
installed and config-intact; rollback is one command away.

**In scope**
- Install OmniWM alongside Aerospace; only one runs at a time (AX API
  conflict).
- Recreate the workspace topology (18 named workspaces) and app-routing rules
  inside OmniWM.
- Port Hyper-key bindings to OmniWM hotkeys.
- Build Aerospace's `service` mode as a Goku layer in `karabiner.edn`.
- Use OmniWM's built-in workspace bar; leave sketchybar + JankyBorders running
  but inert.
- Default layout: **Niri** (scrolling columns) on all workspaces.

**Out of scope (deferred)**
- Removing sketchybar / JankyBorders / aerospace JXA helpers.
- Wiring sketchybar to `omniwmctl` IPC.
- Porting the "center floating window on monitor" JXA scripts.
- Trimming the 18-workspace set.
- Versioning the OmniWM config in dotfiles.

**Success criteria (decide go/no-go after ~5 working days)**
1. All 18 named workspaces exist and route apps correctly.
2. Hyper bindings + service-mode layer at parity with Aerospace.
3. Niri scrolling columns either click or clearly don't.
4. No daily-driver blocker.

**Abort triggers**
- Named workspaces aren't supported as the README implies.
- >2 hours of debugging on day 1.
- Critical app rule can't be replicated (Zed, wezterm, Slack, Zen).

## 2. Pre-flight & install

**Prereqs (verify before install)**
- macOS 15+ ✓ (26.3 confirmed)
- Aerospace works today → "Displays have separate Spaces" already OFF.
- Accessibility permission ready (granted on first launch).

**Install**
```bash
brew tap BarutSRB/tap
brew install omniwm
brew install yqrashawn/goku/goku   # not currently installed; needed for modal layer
```
Do **not** launch OmniWM yet.

**Snapshot for rollback**
```bash
cp ~/.config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json.pre-omniwm
launchctl list | grep -iE "sketchy|borders|aerospace" > /tmp/wm-pre-eval-state.txt
```

**Karabiner setup note.** Existing config is hand-rolled JSON (86 lines) with
two rules: Caps Lock → Hyper / Escape, and physical-Escape disable. Migrating
to `karabiner.edn` is part of this plan — Goku compiles EDN into the JSON
Karabiner reads, so the two existing rules need to be re-expressed in EDN
before adding the service-mode layer.

OmniWM creates `~/.config/omniwm/settings.toml` on first launch. Let it.

## 3. Workspace + app rules port

Source of truth = OmniWM's GUI Settings; TOML is a serialization.

**Workspaces (18 named)** — recreate via *Settings > Workspaces*:

```
Browsing, Communication, Development, Extra, File_Management,
Gaming, Music, Other, Planning, Project_1, Project_2, Project_3,
Project_4, Research, System_Administration, Tooling, VM, Writing
```

**Open question:** does OmniWM cap workspace count at 9? README hints at
numeric shortcuts but named workspaces should be unbounded. Verify on launch.

**Per-workspace layout:** all Niri for the eval. `Option+Shift+L` flips.

**App rules** — recreate via *Settings > App Rules > Assign to Workspace*:

| Workspace | App bundle IDs |
|---|---|
| Development | `com.github.wez.wezterm` |
| Tooling | `dev.zed.Zed`, `com.microsoft.VSCode`, `com.postmanlabs.mac`, `com.apple.Terminal` |
| Browsing | `app.zen-browser.zen`, `com.apple.Safari` |
| Project_2 | `com.google.Chrome` |
| Communication | `com.tinyspeck.slackmacgap`, `us.zoom.xos`, `net.whatsapp.WhatsApp`, `com.apple.MobileSMS`, `com.apple.FaceTime`, `com.apple.mail` |
| Music | `com.spotify.client`, `com.tinfine.MusicWidget`, `com.apple.Music`, `com.apple.podcasts` |
| Planning | `com.cron.electron`, `com.apple.TextEdit`, `com.todoist.mac.Todoist`, `com.apple.reminders`, `com.apple.Notes`, `com.apple.iCal`, `com.apple.freeform` |
| File_Management | `com.apple.finder`, `com.apple.Preview`, `com.apple.Photos`, `com.apple.Image-Capture` |
| System_Administration | `com.apple.systempreferences`, `com.apple.AppStore`, `com.apple.ActivityMonitor`, `com.apple.DiskUtility`, `com.apple.Console`, `com.apple.SystemProfiler`, `com.microsoft.CompanyPortalMac`, `com.jamfsoftware.selfservice.mac` |
| Extra | `com.bitwarden.desktop`, `com.keepersecurity.passwordmanager`, `com.apple.Passwords` |
| Research | `com.celestial.ClaudeIsland`, `com.pieces.x`, `com.apple.Dictionary`, `com.apple.iBooksX` |
| Gaming | `com.krafton.kira`, `com.apple.Chess` |
| VM | `com.teamviewer.TeamViewer`, `com.apple.ScreenSharing` |

Float rules: none for now; revisit if anything misbehaves.

## 4. Hotkeys + Goku service mode

### 4a. OmniWM hotkeys (Settings > Hotkeys)

| Aerospace binding | OmniWM action |
|---|---|
| `Hyper+h/j/k/l` | Focus Left/Down/Up/Right |
| `Hyper+minus`/`Hyper+equal` | Cycle Column Width Backward/Forward |
| `Hyper+<letter>` (per workspace) | Switch to Workspace `<name>` |
| `Hyper+space` | Switch to Previous Workspace (Back and Forth) |
| `Hyper+Shift+<letter>` (per workspace) | **Move Window to Workspace `<name>`** |
| `Hyper+a` | (unassigned — Goku owns this) |

### 4b. Goku service-mode layer

Create `~/.config/karabiner.edn` with: (a) the two existing rules ported from
JSON (Caps→Hyper/Escape, physical-Escape disable), and (b) the service-mode
layer below (toggle-gated; switch to frontmost-app condition once OmniWM
bundle ID verified):

```clojure
{:layers
 {:service-mode {:key :a :alone {:key :a}}}
 :main
 [{:des "OmniWM service mode"
   :rules [[:!CTOSa [:service-mode 1]]
           [:escape [:service-mode 0] [:service-mode]]
           [:h [:!CTOSleft_arrow]  [:service-mode]]
           [:j [:!CTOSdown_arrow]  [:service-mode]]
           [:k [:!CTOSup_arrow]    [:service-mode]]
           [:l [:!CTOSright_arrow] [:service-mode]]
           [:b [:!CTOSb] [:service-mode]]
           [:c [:!CTOSc] [:service-mode]]
           [:d [:!CTOSd] [:service-mode]]
           ;; ...one line per workspace letter
           [:slash     [:!CTOSslash]     [:service-mode]]
           [:r         [:!CTOSr]         [:service-mode]]
           [:f         [:!CTOSf]         [:service-mode]]
           [:backspace [:!CTOSbackspace] [:service-mode]]]}]}
```

### 4c. Chord-family contract

- **Hyper+letter** → "Switch to Workspace" (unchanged from Aerospace).
- **Hyper+Shift+letter** → "Move Window to Workspace" (new in OmniWM).
- **Service mode + bare letter** → Goku emits Hyper+Shift+letter.

Both flows feel identical to muscle memory.

### 4d. Deferred

- Dock-autohide JXA on Hyper+backtick.
- "Center floating window" JXA (service-mode `f`).
- `close-all-windows-but-current` if no OmniWM equivalent.
- `move-workspace-to-monitor --wrap-around next`.

## 5. Cutover

```bash
aerospace stop
ps aux | grep -iE "aerospace|yabai|amethyst" | grep -v grep    # expect empty
open -a OmniWM
# grant Accessibility on first launch
```

**Smoke test (first 10 min)**
1. wezterm → Development
2. Slack → Communication
3. Hyper+d → focus Development
4. Hyper+c → focus Communication
5. Hyper+a then b → window moves to Browsing
6. Hyper+h/j/k/l → focus moves
7. Option+Shift+L → Niri↔Dwindle toggles
8. Control+Option+Space → Command Palette

**Multi-day protocol**
- Day 1: triage smoke-test punch list, add float rules as needed.
- Days 2–3: real work; running notes in `~/omniwm-eval-notes.md`.
- Day 4: stress edges (multi-monitor, overview, palette, quake terminal).
- Day 5: decide.

**Try deliberately** (the actual reasons to be on OmniWM):
- Overview (`Option+Shift+O`) instead of Cmd+Tab.
- Command palette (`Control+Option+Space`) instead of Spotlight.
- Tabbed columns (`Option+T`) on Communication — accordion replacement.
- Quake terminal (`` Option+` ``) for one-off shells.

## 6. Rollback

```bash
osascript -e 'tell application "OmniWM" to quit'
ps aux | grep -i omniwm | grep -v grep    # expect empty
aerospace start
```

Goku layer: gated on frontmost-app → no revert needed. Manual toggle → flip
off, or restore from `~/.config/karabiner.edn.pre-omniwm` and re-run `goku`.

Verify rollback: smoke test (Section 5) expecting Aerospace behavior;
sketchybar updates on workspace switch; borders render.

Partial rollback options:
- Swap default layout to Dwindle in OmniWM Settings.
- Disable Goku layer, keep OmniWM with flat hotkeys to isolate.

## 7. Decision + post-eval

| Outcome | Trigger | Next |
|---|---|---|
| Commit | Smoke test passed, no blockers, Niri/overview/palette earned their keep | 7b |
| Abandon | Abort trigger fired, OR friction > Niri upside | 7c |
| Keep evaluating | Mixed signal | One more focused week with a specific hypothesis |

### 7b. If committing
1. Symlink `~/.config/omniwm/settings.toml` into dotfiles after verifying TOML
   round-trip.
2. Decide sketchybar — quit / wire to `omniwmctl` IPC.
3. Decide JankyBorders — quit / uninstall.
4. Port deferred JXA scripts via `omniwmctl` + AX scripting.
5. `aerospace stop && brew uninstall nikitabobko/tap/aerospace && git rm -r dotfiles/aerospace`.
6. Update CLAUDE.md / README.

### 7c. If abandoning
1. Confirm rollback in effect.
2. `brew uninstall omniwm`.
3. Remove Goku service-mode layer; re-run `goku`.
4. Delete `~/.config/omniwm/` (optional).
5. Note in `omniwm-eval-notes.md` why it didn't work — for future re-evaluation.
