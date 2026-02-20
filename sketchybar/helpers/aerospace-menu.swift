import AppKit

class MenuHandler: NSObject {
    var selected: String?

    @objc func itemClicked(_ sender: NSMenuItem) {
        selected = sender.representedObject as? String
    }
}

// Read workspace data from stdin (tab-separated: id\tlabel\tfocused)
var workspaces: [(id: String, label: String, focused: Bool)] = []
while let line = readLine() {
    let parts = line.components(separatedBy: "\t")
    guard parts.count >= 2 else { continue }
    workspaces.append((
        id: parts[0],
        label: parts[1],
        focused: parts.count > 2 && parts[2] == "focused"
    ))
}

guard !workspaces.isEmpty else { exit(1) }

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

let handler = MenuHandler()
let menu = NSMenu()
menu.autoenablesItems = false

// Header
let header = NSMenuItem(title: "Workspaces:", action: nil, keyEquivalent: "")
header.isEnabled = false
menu.addItem(header)

// Workspace items
for ws in workspaces {
    let item = NSMenuItem(
        title: ws.label,
        action: #selector(MenuHandler.itemClicked(_:)),
        keyEquivalent: ""
    )
    item.target = handler
    item.representedObject = ws.id
    if ws.focused { item.state = .on }
    menu.addItem(item)
}

// Separator + actions
menu.addItem(NSMenuItem.separator())

let reload = NSMenuItem(
    title: "Reload config",
    action: #selector(MenuHandler.itemClicked(_:)),
    keyEquivalent: ""
)
reload.target = handler
reload.representedObject = "__reload__"
menu.addItem(reload)

// Show native menu at mouse position
app.activate(ignoringOtherApps: true)
menu.popUp(positioning: nil, at: NSEvent.mouseLocation, in: nil)

if let selected = handler.selected {
    print(selected)
}
