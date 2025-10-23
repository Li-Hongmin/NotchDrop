//
//  LaunchAtLoginHelper.swift
//  NotchPop
//
//  Manages launch at login functionality
//

import Foundation
import ServiceManagement

class LaunchAtLoginHelper {

    static func setLaunchAtLogin(enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to \(enabled ? "enable" : "disable") launch at login: \(error)")
            }
        } else {
            // For older macOS versions, use deprecated API
            #if !targetEnvironment(macCatalyst)
            let success = SMLoginItemSetEnabled("com.notchpop.launcher" as CFString, enabled)
            if !success {
                print("Failed to \(enabled ? "enable" : "disable") launch at login")
            }
            #endif
        }
    }

    static func isLaunchAtLoginEnabled() -> Bool {
        if #available(macOS 13.0, *) {
            return SMAppService.mainApp.status == .enabled
        } else {
            // For older macOS, check using defaults
            return UserDefaults.standard.bool(forKey: "launchAtLogin")
        }
    }
}
