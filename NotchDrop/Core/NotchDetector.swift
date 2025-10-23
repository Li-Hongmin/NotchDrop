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
    }

    var notchInfo: NotchInfo {
        calculateNotchInfo()
    }

    private func calculateNotchInfo() -> NotchInfo {
        guard let screen = NSScreen.main else {
            return NotchInfo(hasNotch: false, frame: .zero, triggerArea: .zero)
        }

        let screenFrame = screen.frame
        let visibleFrame = screen.visibleFrame

        // Check if there's a notch by comparing screen and visible frames
        let hasNotch = visibleFrame.maxY < screenFrame.maxY

        guard hasNotch else {
            return NotchInfo(hasNotch: false, frame: .zero, triggerArea: .zero)
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
            triggerArea: triggerArea
        )
    }

    func isPointInNotchArea(_ point: CGPoint) -> Bool {
        let info = notchInfo
        guard info.hasNotch else { return false }
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
