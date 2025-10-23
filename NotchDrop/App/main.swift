//
//  main.swift
//  NotchDrop
//

import Cocoa

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

print("========================================")
print("💧 NOTCHDROP STARTING")
print("========================================")

// Force activation policy
app.setActivationPolicy(.regular)
print("✅ Activation policy set")

// Run the app
app.run()
