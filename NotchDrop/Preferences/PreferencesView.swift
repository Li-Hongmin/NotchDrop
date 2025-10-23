//
//  PreferencesView.swift
//  NotchDrop
//

import SwiftUI

struct PreferencesView: View {

    @ObservedObject private var preferences = PreferencesObservable.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("💧")
                    .font(.largeTitle)
                Text("NotchDrop Settings")
                    .font(.title2)
                    .fontWeight(.bold)
            }

            Divider()

            // General Settings
            GroupBox(label: Text("General").fontWeight(.semibold)) {
                VStack(alignment: .leading, spacing: 12) {
                    Toggle("Enable NotchDrop", isOn: $preferences.isEnabled)

                    Toggle("Launch at Login", isOn: $preferences.launchAtLogin)
                }
                .padding(.vertical, 8)
            }

            // Behavior Settings
            GroupBox(label: Text("Menu Bar Behavior").fontWeight(.semibold)) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("When menu bar drops down:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack {
                        Text("Auto-restore after:")
                        Slider(value: $preferences.autoRestoreDelay, in: 5...120, step: 5)
                        Text("\(Int(preferences.autoRestoreDelay))s")
                            .frame(width: 40)
                    }

                    Text("The menu bar will automatically rise back after this delay.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }

            // How to Use
            GroupBox(label: Text("How to Use").fontWeight(.semibold)) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "1.circle.fill")
                            .foregroundColor(.blue)
                        Text("Move mouse INTO the notch (black area)")
                    }

                    HStack {
                        Image(systemName: "2.circle.fill")
                            .foregroundColor(.blue)
                        Text("Menu bar drops down - all icons visible!")
                    }

                    HStack {
                        Image(systemName: "3.circle.fill")
                            .foregroundColor(.blue)
                        Text("Move mouse away - countdown starts")
                    }

                    HStack {
                        Image(systemName: "4.circle.fill")
                            .foregroundColor(.blue)
                        Text("After countdown, menu bar rises back up")
                    }

                    Divider()

                    Text("💡 Tip: Look for the ⬇️ button in menu bar. Right-click for options.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }

            Spacer()

            // Footer
            HStack {
                Button("Reset to Defaults") {
                    preferences.resetToDefaults()
                }

                Spacer()

                Text("Version 1.0")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .frame(width: 550, height: 550)
    }
}

// MARK: - Observable Wrapper

class PreferencesObservable: ObservableObject {

    static let shared = PreferencesObservable()

    private let manager = PreferencesManager.shared

    @Published var isEnabled: Bool {
        didSet { manager.isEnabled = isEnabled }
    }

    @Published var autoRestoreDelay: Double {
        didSet {
            manager.autoRestoreDelay = autoRestoreDelay
            // Notify AppDelegate to update its delay value
            NotificationCenter.default.post(name: NSNotification.Name("PreferencesChanged"), object: nil)
        }
    }

    @Published var launchAtLogin: Bool {
        didSet { manager.launchAtLogin = launchAtLogin }
    }

    private init() {
        self.isEnabled = manager.isEnabled
        self.autoRestoreDelay = manager.autoRestoreDelay
        self.launchAtLogin = manager.launchAtLogin
    }

    func resetToDefaults() {
        isEnabled = true
        autoRestoreDelay = 30.0
        launchAtLogin = false
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
