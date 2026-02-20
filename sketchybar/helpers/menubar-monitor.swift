import Cocoa

var barHidden = false
var hideTimer: Timer?
let sketchybarPath: String = {
    let paths = ["/opt/homebrew/bin/sketchybar", "/usr/local/bin/sketchybar"]
    return paths.first { FileManager.default.fileExists(atPath: $0) } ?? "sketchybar"
}()

func toggleBar(hidden: Bool) {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: sketchybarPath)
    task.arguments = ["--bar", "hidden=\(hidden ? "on" : "off")"]
    task.standardOutput = FileHandle.nullDevice
    task.standardError = FileHandle.nullDevice
    try? task.run()
}

func postKey(code: CGKeyCode, flags: CGEventFlags = [], keyDown: Bool) {
    guard let event = CGEvent(keyboardEventSource: nil, virtualKey: code, keyDown: keyDown) else { return }
    event.flags = flags
    event.post(tap: .cghidEventTap)
}

func activateMenuBar() {
    // Fn+Ctrl+F2 (F2 = keycode 0x78)
    let flags: CGEventFlags = [.maskControl, .maskSecondaryFn]
    postKey(code: 0x78, flags: flags, keyDown: true)
    postKey(code: 0x78, flags: flags, keyDown: false)
}

func dismissMenuBar() {
    // Escape (keycode 0x35)
    postKey(code: 0x35, keyDown: true)
    postKey(code: 0x35, keyDown: false)
}

func checkMouse() {
    let mouseLocation = NSEvent.mouseLocation
    guard let screen = NSScreen.screens.first(where: {
        NSMouseInRect(mouseLocation, $0.frame, false)
    }) else { return }

    let screenTop = screen.frame.maxY
    let atTop = mouseLocation.y >= screenTop - 20

    if atTop && !barHidden {
        hideTimer?.invalidate()
        hideTimer = nil
        barHidden = true
        toggleBar(hidden: true)
        activateMenuBar()
    } else if !atTop && barHidden {
        if hideTimer == nil {
            dismissMenuBar()
            hideTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                barHidden = false
                toggleBar(hidden: false)
                hideTimer = nil
            }
        }
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { _ in
    checkMouse()
}

// Periodic fallback check
Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
    checkMouse()
}

app.run()
