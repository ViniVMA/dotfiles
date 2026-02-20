# Sketchybar Helpers

Custom helper binaries for sketchybar, written in Swift.

## menubar-monitor

Monitors the cursor position and toggles sketchybar visibility when the cursor approaches the top of the screen, allowing the native macOS menu bar to appear without overlapping.

### How it works

1. Tracks mouse position via `NSEvent.addGlobalMonitorForEvents`
2. When the cursor enters a 20px zone at the top of the screen:
   - Hides sketchybar (`sketchybar --bar hidden=on`)
   - Simulates **Fn+Ctrl+F2** via `CGEvent` to activate the native menu bar
3. When the cursor leaves the zone:
   - Sends **Escape** to dismiss the native menu bar
   - After a 0.3s delay, restores sketchybar (`sketchybar --bar hidden=off`)

The delay prevents flicker when the cursor briefly passes through the zone, and gives the native menu bar time to dismiss before sketchybar reappears.

### Why Fn+Ctrl+F2?

On stacked multi-monitor setups (one display above another), the cursor passes straight to the upper monitor instead of hitting the top edge — making the native menu bar's hover trigger unreachable on the lower screen. Simulating the keyboard shortcut activates it programmatically regardless of monitor arrangement.

### Requirements

- **Accessibility permissions**: The binary posts synthetic key events via `CGEvent`, which requires Accessibility access. Grant it in **System Settings > Privacy & Security > Accessibility**.
- If your keyboard uses F-keys directly (without Fn), change the flags in `activateMenuBar()` to just `.maskControl`.

### Build

```bash
swiftc -O -o menubar-monitor menubar-monitor.swift -framework Cocoa
```

### Configuration

| Parameter | Location | Default | Description |
|-----------|----------|---------|-------------|
| Detection threshold | `checkMouse()`, line `screenTop - 20` | 20px | How far from the top of the screen to trigger |
| Restore delay | `Timer.scheduledTimer(withTimeInterval:)` | 0.3s | Delay before restoring sketchybar after cursor leaves |
| Bar y_offset | `sketchybarrc` | 12px | Gap above sketchybar; threshold should exceed this |

## aerospace-menu

Native macOS popup menu for switching AeroSpace workspaces. Triggered by clicking the workspace item in sketchybar.

### Build

```bash
swiftc -O -o aerospace-menu aerospace-menu.swift -framework Cocoa
```
