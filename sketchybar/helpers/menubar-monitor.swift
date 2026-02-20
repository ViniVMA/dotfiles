import Cocoa

let sketchybarPath: String = {
    let paths = ["/opt/homebrew/bin/sketchybar", "/usr/local/bin/sketchybar"]
    return paths.first { FileManager.default.fileExists(atPath: $0) } ?? "sketchybar"
}()

var sketchybarHidden = false
var menuBarActivated = false

func toggleBar(hidden: Bool) {
    guard hidden != sketchybarHidden else { return }
    sketchybarHidden = hidden
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

func isMenuBarVisible() -> Bool {
    let windowList = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? [[String: Any]] ?? []
    return windowList.contains { info in
        (info[kCGWindowLayer as String] as? Int) == 24
    }
}

func check() {
    let mouseLocation = NSEvent.mouseLocation
    let screen = NSScreen.screens.first(where: {
        NSMouseInRect(mouseLocation, $0.frame, false)
    })

    // Activate native menu bar when mouse is in the top 20px zone
    if let screen = screen {
        let atTop = mouseLocation.y >= screen.frame.maxY - 15
        if atTop && !menuBarActivated {
            menuBarActivated = true
            activateMenuBar()
        } else if !atTop {
            menuBarActivated = false
        }
    }

    // Toggle sketchybar based on native menu bar visibility
    let menuBarOnScreen = isMenuBarVisible()
    toggleBar(hidden: menuBarOnScreen)
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { _ in
    check()
}

Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
    check()
}

app.run()
