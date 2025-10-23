//
//  PreferencesManager.swift
//  NotchPop
//
//  Manages user preferences
//

import Foundation

class PreferencesManager {

    static let shared = PreferencesManager()

    private let defaults = UserDefaults.standard

    private init() {
        registerDefaults()
    }

    private func registerDefaults() {
        defaults.register(defaults: [
            Keys.isEnabled: true,
            Keys.autoRestoreDelay: 30.0,
            Keys.launchAtLogin: false
        ])
    }

    // MARK: - Keys

    private struct Keys {
        static let isEnabled = "isEnabled"
        static let autoRestoreDelay = "autoRestoreDelay"
        static let launchAtLogin = "launchAtLogin"
    }

    // MARK: - Properties

    var isEnabled: Bool {
        get { defaults.bool(forKey: Keys.isEnabled) }
        set { defaults.set(newValue, forKey: Keys.isEnabled) }
    }

    var autoRestoreDelay: TimeInterval {
        get { defaults.double(forKey: Keys.autoRestoreDelay) }
        set { defaults.set(newValue, forKey: Keys.autoRestoreDelay) }
    }

    var launchAtLogin: Bool {
        get { defaults.bool(forKey: Keys.launchAtLogin) }
        set {
            defaults.set(newValue, forKey: Keys.launchAtLogin)
            LaunchAtLoginHelper.setLaunchAtLogin(enabled: newValue)
        }
    }

}
