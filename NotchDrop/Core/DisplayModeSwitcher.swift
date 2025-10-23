//
//  DisplayModeSwitcher.swift
//  NotchPop
//
//  Switches display resolution to move menu bar below notch
//

import Cocoa

class DisplayModeSwitcher {

    static let shared = DisplayModeSwitcher()

    private init() {}

    private var originalMode: CGDisplayMode?
    private var notchAvoidMode: CGDisplayMode?

    enum MenuBarPosition {
        case normal      // Menu bar in notch (original)
        case belowNotch  // Menu bar below notch (16:10 resolution)
    }

    private(set) var currentPosition: MenuBarPosition = .normal

    // Initialize and find available display modes
    func initialize() {
        print("🖥️ Initializing Display Mode Switcher...")

        guard let display = CGMainDisplayID() as CGDirectDisplayID? else {
            print("   ❌ Could not get main display")
            return
        }

        // Get current mode
        if let currentMode = CGDisplayCopyDisplayMode(display) {
            originalMode = currentMode
            let width = currentMode.width
            let height = currentMode.height
            print("   📐 Current resolution: \(width)×\(height)")
        }

        // Find all available modes
        let options = [kCGDisplayShowDuplicateLowResolutionModes: kCFBooleanTrue] as CFDictionary
        guard let allModes = CGDisplayCopyAllDisplayModes(display, options) as? [CGDisplayMode] else {
            print("   ❌ Could not get display modes")
            return
        }

        let usableModes = allModes.filter { $0.isUsableForDesktopGUI() }
        print("   📊 Found \(usableModes.count) usable display modes")

        // Find the 16:10 mode (menu bar below notch)
        notchAvoidMode = findNotchAvoidMode(from: usableModes, currentMode: originalMode)

        if let notchMode = notchAvoidMode {
            print("   ✅ Found notch-avoid mode: \(notchMode.width)×\(notchMode.height)")
        } else {
            print("   ⚠️ Could not find 16:10 mode")
        }
    }

    private func findNotchAvoidMode(from modes: [CGDisplayMode], currentMode: CGDisplayMode?) -> CGDisplayMode? {
        guard let current = currentMode else { return nil }

        let currentWidth = current.width
        let currentHeight = current.height
        let currentRatio = CGFloat(currentWidth) / CGFloat(currentHeight)

        print("   🔍 Current mode: \(currentWidth)×\(currentHeight), ratio: \(currentRatio)")

        // If current is already 16:10, we need to find the TALLER 3:2 native mode
        // If current is 3:2, we need to find the SHORTER 16:10 mode

        let ratio_16_10: CGFloat = 1.6
        let ratio_3_2: CGFloat = 1.5
        let tolerance: CGFloat = 0.05

        var nativeMode: CGDisplayMode?
        var avoidMode: CGDisplayMode?

        // Find both modes
        for mode in modes {
            let width = mode.width
            let height = mode.height
            let ratio = CGFloat(width) / CGFloat(height)

            // Same width only
            guard width == currentWidth else { continue }

            // Check if it's 3:2 (native with notch)
            if abs(ratio - ratio_3_2) < tolerance {
                print("      Found 3:2 mode: \(width)×\(height), ratio: \(ratio)")
                nativeMode = mode
            }

            // Check if it's 16:10 (notch avoid)
            if abs(ratio - ratio_16_10) < tolerance {
                print("      Found 16:10 mode: \(width)×\(height), ratio: \(ratio)")
                avoidMode = mode
            }
        }

        // Store the native mode
        if currentRatio < 1.55 {
            // Current is 3:2, this is native
            originalMode = current
            print("   ✅ Current is native 3:2 mode")
        } else {
            // Current is 16:10, find native
            originalMode = nativeMode
            print("   ✅ Found native mode: \(nativeMode?.width ?? 0)×\(nativeMode?.height ?? 0)")
        }

        return avoidMode
    }

    // Switch menu bar position
    func switchTo(position: MenuBarPosition, completion: ((Bool) -> Void)? = nil) {
        print("========================================")
        print("🔄 Switching menu bar to: \(position)")
        print("========================================")

        guard let display = CGMainDisplayID() as CGDirectDisplayID? else {
            print("   ❌ No main display")
            completion?(false)
            return
        }

        let targetMode: CGDisplayMode?

        switch position {
        case .normal:
            targetMode = originalMode
            print("   ⬆️ Moving menu bar UP (to notch)")
        case .belowNotch:
            targetMode = notchAvoidMode
            print("   ⬇️ Moving menu bar DOWN (below notch)")
        }

        guard let mode = targetMode else {
            print("   ❌ Target mode not available")
            completion?(false)
            return
        }

        // Begin configuration
        var config: CGDisplayConfigRef?
        let beginError = CGBeginDisplayConfiguration(&config)

        guard beginError == .success, let config = config else {
            print("   ❌ Failed to begin configuration: \(beginError)")
            completion?(false)
            return
        }

        // Set the new mode
        let configError = CGConfigureDisplayWithDisplayMode(config, display, mode, nil)
        guard configError == .success else {
            print("   ❌ Failed to configure mode: \(configError)")
            CGCancelDisplayConfiguration(config)
            completion?(false)
            return
        }

        // Apply permanently
        let completeError = CGCompleteDisplayConfiguration(config, .permanently)

        if completeError == .success {
            currentPosition = position
            print("   ✅ Display mode switched successfully!")
            print("   📐 New resolution: \(mode.width)×\(mode.height)")
            completion?(true)
        } else {
            print("   ❌ Failed to complete configuration: \(completeError)")
            completion?(false)
        }
    }

    // Toggle between positions
    func toggle(completion: ((Bool) -> Void)? = nil) {
        let newPosition: MenuBarPosition = (currentPosition == .normal) ? .belowNotch : .normal
        switchTo(position: newPosition, completion: completion)
    }

    // Check if notch-avoid mode is available
    var isNotchAvoidModeAvailable: Bool {
        return notchAvoidMode != nil
    }
}
