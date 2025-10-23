//
//  MouseTracker.swift
//  NotchPop
//
//  Tracks mouse position and detects when it enters/exits notch area
//

import Cocoa

class MouseTracker {

    private var eventMonitor: Any?
    private(set) var isMouseInNotchArea = false
    private var debounceTimer: Timer?

    var onMouseEnterNotch: (() -> Void)?
    var onMouseExitNotch: (() -> Void)?

    func start() {
        stop() // Ensure we don't have multiple monitors

        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { [weak self] event in
            self?.handleMouseMoved(event)
        }

        // Also track local events
        NSEvent.addLocalMonitorForEvents(matching: .mouseMoved) { [weak self] event in
            self?.handleMouseMoved(event)
            return event
        }
    }

    func stop() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
        debounceTimer?.invalidate()
        debounceTimer = nil
    }

    private func handleMouseMoved(_ event: NSEvent) {
        let mouseLocation = NSEvent.mouseLocation
        let isInNotchArea = NotchDetector.shared.isPointInNotchArea(mouseLocation)

        if isInNotchArea != isMouseInNotchArea {
            isMouseInNotchArea = isInNotchArea

            // Debounce to avoid rapid triggering
            debounceTimer?.invalidate()
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [weak self] _ in
                guard let self = self else { return }

                if self.isMouseInNotchArea {
                    self.onMouseEnterNotch?()
                } else {
                    self.onMouseExitNotch?()
                }
            }
        }
    }

    deinit {
        stop()
    }
}
