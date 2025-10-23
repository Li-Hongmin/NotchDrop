//
//  AppDelegate.swift
//  NotchDrop
//
//  Smart menu bar manager - drops below notch on hover
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    var mouseTracker: MouseTracker?

    // Menu bar control button
    var toggleButton: NSStatusItem?

    // Auto-restore timer
    var restoreTimer: Timer?
    var countdownTimer: Timer?
    var remainingSeconds: Int = 0
    var restoreDelay: TimeInterval = 30.0  // 30 seconds (configurable)

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("========================================")
        print("💧 NOTCHDROP STARTING")
        print("========================================")

        // Initialize display mode switcher
        DisplayModeSwitcher.shared.initialize()

        // Show settings window on launch
        PreferencesWindowController.shared.showWindow(nil)

        // Setup mouse tracking for hover trigger
        setupMouseTracking()

        // Setup menu bar button
        setupMenuBarButton()

        // Listen for preference changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(preferencesChanged),
            name: NSNotification.Name("PreferencesChanged"),
            object: nil
        )

        print("✅ NotchDrop Ready!")
    }

    @objc func preferencesChanged() {
        // Update restore delay from preferences
        restoreDelay = PreferencesManager.shared.autoRestoreDelay
        print("⚙️ Preferences updated - restore delay: \(restoreDelay)s")
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // When clicking Dock icon, show settings
        PreferencesWindowController.shared.showWindow(nil)
        return true
    }

    // MARK: - Mouse Tracking

    func setupMouseTracking() {
        print("🖱️ Setting up mouse tracking...")

        mouseTracker = MouseTracker()

        mouseTracker?.onMouseEnterNotch = { [weak self] in
            print("👆 Mouse entered notch - dropping menu bar...")
            self?.cancelRestoreTimer()
            self?.dropMenuBar()
        }

        mouseTracker?.onMouseExitNotch = { [weak self] in
            print("👇 Mouse left notch - will restore in 30s...")
            self?.startRestoreTimer()
        }

        mouseTracker?.start()
        print("   ✅ Mouse tracking started")
    }

    func dropMenuBar() {
        DisplayModeSwitcher.shared.switchTo(position: .belowNotch) { [weak self] success in
            if success {
                self?.updateButtonIcon(dropped: true)
            }
        }
    }

    func raiseMenuBar() {
        DisplayModeSwitcher.shared.switchTo(position: .normal) { [weak self] success in
            if success {
                self?.updateButtonIcon(dropped: false)
            }
        }
    }

    // MARK: - Auto Restore Timer

    func startRestoreTimer() {
        cancelRestoreTimer()

        remainingSeconds = Int(restoreDelay)
        print("   ⏰ Starting \(remainingSeconds)-second restore timer...")

        // Update countdown every second
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }

        // Final restore timer
        restoreTimer = Timer.scheduledTimer(withTimeInterval: restoreDelay, repeats: false) { [weak self] _ in
            print("   ⏰ Timer expired - auto restoring menu bar")
            self?.raiseMenuBar()
        }

        // Show initial countdown
        updateButtonWithCountdown(remainingSeconds)
    }

    func cancelRestoreTimer() {
        if restoreTimer != nil {
            print("   ⏰ Canceling restore timer")
            restoreTimer?.invalidate()
            restoreTimer = nil
        }
        countdownTimer?.invalidate()
        countdownTimer = nil
    }

    func updateCountdown() {
        remainingSeconds -= 1

        if remainingSeconds > 0 {
            updateButtonWithCountdown(remainingSeconds)
        }
    }

    func updateButtonWithCountdown(_ seconds: Int) {
        toggleButton?.button?.title = "\(seconds)"
        toggleButton?.button?.image = nil  // Remove icon, show number
    }

    // MARK: - Menu Bar Button

    func setupMenuBarButton() {
        print("🔘 Setting up menu bar button...")

        toggleButton = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = toggleButton?.button {
            updateButtonIcon(dropped: false)
            button.target = self
            button.action = #selector(buttonClicked)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        toggleButton?.autosaveName = "notchpop_toggle"

        print("   ✅ Menu bar button created")
    }

    func createContextMenu() -> NSMenu {
        let menu = NSMenu()

        let settingsItem = NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)

        menu.addItem(NSMenuItem.separator())

        let aboutItem = NSMenuItem(title: "About NotchPop", action: #selector(showAbout), keyEquivalent: "")
        aboutItem.target = self
        menu.addItem(aboutItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: "Quit NotchPop", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(quitItem)

        return menu
    }

    func updateButtonIcon(dropped: Bool) {
        toggleButton?.button?.title = ""  // Clear text
        let iconName = dropped ? "arrow.up.circle.fill" : "arrow.down.circle.fill"
        toggleButton?.button?.image = NSImage(
            systemSymbolName: iconName,
            accessibilityDescription: dropped ? "Raise Menu Bar" : "Drop Menu Bar"
        )
    }

    @objc func buttonClicked() {
        guard let event = NSApp.currentEvent else { return }

        // Right click - show menu
        if event.type == .rightMouseUp {
            print("🔘 Right click - showing menu")
            let menu = createContextMenu()
            toggleButton?.popUpMenu(menu)
            return
        }

        // Left click - toggle or immediate restore
        guard event.type == .leftMouseUp else { return }

        print("🔘 Left click")

        let isDown = (DisplayModeSwitcher.shared.currentPosition == .belowNotch)

        // If countdown is running (button shows number), immediately restore
        if isDown && restoreTimer != nil {
            print("   ⏰ Countdown clicked - IMMEDIATE RESTORE!")
            cancelRestoreTimer()
            raiseMenuBar()
        }
        // If menu bar is down but no countdown
        else if isDown {
            print("   ⬆️ Raising menu bar")
            raiseMenuBar()
        }
        // If menu bar is up
        else {
            print("   ⬇️ Dropping menu bar")
            dropMenuBar()
            startRestoreTimer()
        }
    }

    @objc func openSettings() {
        print("⚙️ Opening settings...")
        PreferencesWindowController.shared.showWindow(nil)
    }

    @objc func showAbout() {
        NSApp.orderFrontStandardAboutPanel(nil)
    }
}


