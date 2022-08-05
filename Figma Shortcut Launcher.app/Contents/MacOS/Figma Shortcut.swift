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

@discardableResult
func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

var inited = false
var nFilesOpened = 0

@available(macOS 10.15, *)
class AppDelegate: NSObject, NSApplicationDelegate {
    let window = NSWindow()
    let windowDelegate = WindowDelegate()

    func applicationDidFinishLaunching(_: Notification) {
        let appMenu = NSMenuItem(title: "MyApp", action: nil, keyEquivalent: "")
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
        // window.makeKeyAndOrderFront(window)

        NSApp.setActivationPolicy(.accessory)
        // NSApp.activate(ignoringOtherApps: true)
    }

    // Handle opening files
    func application(_: NSApplication, openFile filename: String) -> Bool {
        nFilesOpened += 1
        if nFilesOpened <= 2 {
            return true
        }

        shell("sh", "-c", "open -b com.figma.Desktop \"$(cat \"$1\")\"", "-", filename)
        return true

        let alert = NSAlert()
        alert.messageText = "File opened"
        alert.informativeText = "The file \(filename) was opened. \(inited)"
        alert.addButton(withTitle: "OK")
        alert.alertStyle = .warning
        alert.runModal()
        return true
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
