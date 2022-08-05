#!/usr/bin/env swift

import AppKit
import Cocoa

func main() -> Int {
    // NSAutoreleasePool()
    // NSApplication.shared
    NSApplication.shared

    NSApp.setActivationPolicy(.regular)

    let appName: String = ProcessInfo.processInfo.processName

    let appMenu = NSMenu()
    appMenu.addItem(NSMenuItem(
        title: "Quit " + appName,
        action: #selector(NSApp.terminate),
        keyEquivalent: "q"
    )
    )

    let appMenuItem = NSMenuItem()
    appMenuItem.submenu = appMenu

    let menubar = NSMenu()
    menubar.addItem(appMenuItem)

    NSApp.mainMenu = menubar

    let window = NSWindow(
        contentRect: NSMakeRect(0, 0, 200, 200),
        styleMask: .titled,
        backing: .buffered,
        defer: false
    )
    window.cascadeTopLeft(from: NSMakePoint(20, 20))
    window.title = appName
    window.makeKeyAndOrderFront(nil)

    NSApp.activate(ignoringOtherApps: true)
    NSApp.run()

    return 0
}
