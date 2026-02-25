//
//  DropdownMenuView.swift
//  Notebar
//
//  Created by Jay Stakelon on 1/30/21.
//
import SwiftUI
struct DropdownMenuView: NSViewRepresentable {

    @ObservedObject var themeManager: ThemeManager
    var onSaveToNotes: () -> Void
    var onClear: () -> Void

    func makeNSView(context: Context) -> NSPopUpButton {
        let dropdown = NSPopUpButton(frame: CGRect(x: 0, y: 0, width: 48, height: 24), pullsDown: true)
        dropdown.menu!.autoenablesItems = false
        dropdown.focusRingType = .none
        return dropdown
    }

    func updateNSView(_ nsView: NSPopUpButton, context: Context) {

        nsView.removeAllItems()

        let iconItem = NSMenuItem()

        let changeThemeItem = NSMenuItem(title: "Change theme", action: #selector(Coordinator.themeAction), keyEquivalent: "")
        changeThemeItem.representedObject = self.themeManager
        changeThemeItem.target = context.coordinator

        let clearItem = NSMenuItem(title: "Clear", action: #selector(Coordinator.clearAction), keyEquivalent: "k")
        clearItem.keyEquivalentModifierMask = .command
        clearItem.target = context.coordinator
        clearItem.representedObject = onClear as AnyObject

        let quitItem = NSMenuItem(title: "Quit", action: #selector(Coordinator.quitAction), keyEquivalent: "q")
        quitItem.target = context.coordinator

        let saveItem = NSMenuItem(title: "Save to Notes", action: #selector(Coordinator.saveAction), keyEquivalent: "s")
        saveItem.keyEquivalentModifierMask = .command
        saveItem.target = context.coordinator
        saveItem.representedObject = onSaveToNotes as AnyObject

        nsView.menu?.insertItem(iconItem, at: 0)
        nsView.menu?.insertItem(changeThemeItem, at: 1)
        nsView.menu?.insertItem(NSMenuItem.separator(), at: 2)
        nsView.menu?.insertItem(clearItem, at: 3)
        nsView.menu?.insertItem(NSMenuItem.separator(), at: 4)
        nsView.menu?.insertItem(saveItem, at: 5)
        nsView.menu?.insertItem(NSMenuItem.separator(), at: 6)
        nsView.menu?.insertItem(quitItem, at: 7)

        let cell = nsView.cell as? NSButtonCell
        cell?.imagePosition = .imageOnly
        cell?.bezelStyle = .texturedRounded
        nsView.wantsLayer = true
        nsView.layer?.backgroundColor = NSColor.clear.cgColor
        nsView.isBordered = false
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        @objc func quitAction(_ sender: NSMenuItem) {
            NSApplication.shared.terminate(self)
        }
        @objc func themeAction(_ sender: NSMenuItem) {
            let tm = sender.representedObject as! ThemeManager
            tm.showThemeEditor()
        }
        @objc func saveAction(_ sender: NSMenuItem) {
            let action = sender.representedObject as! () -> Void
            action()
        }
        @objc func clearAction(_ sender: NSMenuItem) {
            let action = sender.representedObject as! () -> Void
            action()
        }
    }
}
