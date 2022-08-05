#!/usr/bin/env swift
// https://theswiftdev.com/how-to-build-macos-apps-using-only-the-swift-package-manager/

import AppKit
import SwiftUI

@available(macOS 10.15, *)
struct HelloView: View {
    var body: some View {
        Text("Hello world!")
    }
}

@available(macOS 10.15, *)
class WindowDelegate: NSObject, NSWindowDelegate {
    func windowWillClose(_: Notification) {
        NSApplication.shared.terminate(0)
    }
}

@available(macOS 10.15, *)
class AppDelegate: NSObject, NSApplicationDelegate {
    let window = NSWindow()
    let windowDelegate = WindowDelegate()

    func applicationDidFinishLaunching(_: Notification) {
        let appMenu = NSMenuItem()
        appMenu.submenu = NSMenu()
        appMenu.submenu?.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        let mainMenu = NSMenu(title: "My Swift Script")
        mainMenu.addItem(appMenu)
        NSApplication.shared.mainMenu = mainMenu

        let size = CGSize(width: 480, height: 270)
        window.setContentSize(size)
        window.styleMask = [.closable, .miniaturizable, .resizable, .titled]
        window.delegate = windowDelegate
        window.title = "My Swift Script"

        let view = NSHostingView(rootView: HelloView())
        view.frame = CGRect(origin: .zero, size: size)
        view.autoresizingMask = [.height, .width]
        window.contentView!.addSubview(view)
        window.center()
        window.makeKeyAndOrderFront(window)

        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
