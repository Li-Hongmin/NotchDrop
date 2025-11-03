//
//  NotchDetector.swift
//  NotchPop
//
//  Detects if the Mac has a notch and calculates its dimensions
//

import Cocoa

class NotchDetector {

    static let shared = NotchDetector()

    private init() {}

    struct NotchInfo {
        let hasNotch: Bool
        let frame: CGRect
        let triggerArea: CGRect
        let screen: NSScreen? // Store the screen reference
    }

    var notchInfo: NotchInfo {
        calculateNotchInfo()
    }

    // Get the built-in screen (the one with the notch)
    private func getBuiltInScreen() -> NSScreen? {
        // The built-in screen is typically the one with a notch
        // We check all screens and return the first one that has different
        // screen frame and visible frame (indicating a notch)
        for screen in NSScreen.screens {
            let screenFrame = screen.frame
            let visibleFrame = screen.visibleFrame

            // If visible frame's maxY is less than screen frame's maxY,
            // there's a notch at the top
            if visibleFrame.maxY < screenFrame.maxY {
                return screen
            }
        }
        return nil
    }

    private func calculateNotchInfo() -> NotchInfo {
        guard let screen = getBuiltInScreen() else {
            return NotchInfo(hasNotch: false, frame: .zero, triggerArea: .zero, screen: nil)
        }

        let screenFrame = screen.frame
        let visibleFrame = screen.visibleFrame

        // Check if there's a notch by comparing screen and visible frames
        let hasNotch = visibleFrame.maxY < screenFrame.maxY

        guard hasNotch else {
            return NotchInfo(hasNotch: false, frame: .zero, triggerArea: .zero, screen: nil)
        }

        // Calculate notch dimensions
        // MacBook Pro 14"/16" notch is approximately 300-350pt wide
        let notchWidth: CGFloat = 300
        let notchHeight = screenFrame.maxY - visibleFrame.maxY

        let notchX = (screenFrame.width - notchWidth) / 2
        let notchY = screenFrame.maxY - notchHeight

        let notchFrame = CGRect(
            x: notchX,
            y: notchY,
            width: notchWidth,
            height: notchHeight
        )

        // Trigger area is just the notch itself (no extension)
        let triggerArea = notchFrame

        return NotchInfo(
            hasNotch: true,
            frame: notchFrame,
            triggerArea: triggerArea,
            screen: screen
        )
    }

    func isPointInNotchArea(_ point: CGPoint) -> Bool {
        let info = notchInfo
        guard info.hasNotch, let builtInScreen = info.screen else { return false }

        // First, check if the mouse is on the built-in screen
        // by comparing the point against the built-in screen's frame
        let screenFrame = builtInScreen.frame
        guard screenFrame.contains(point) else {
            // Mouse is not on the built-in screen, so definitely not in notch
            return false
        }

        // Only trigger when mouse is INSIDE the actual notch (black area)
        // NOT the area below it
        return info.frame.contains(point)
    }

    func getMenuBarIconsInNotchArea() -> [CGRect] {
        guard notchInfo.hasNotch else { return [] }

        let notchFrame = notchInfo.frame
        let menuBarHeight: CGFloat = 24

        // Calculate the area where menu bar icons might be hidden
        let hiddenArea = CGRect(
            x: notchFrame.minX,
            y: notchFrame.minY - menuBarHeight,
            width: notchFrame.width,
            height: menuBarHeight
        )

        // This is a simplified version
        // In a full implementation, we would need to use Accessibility APIs
        // to get actual icon positions
        return [hiddenArea]
    }
}
