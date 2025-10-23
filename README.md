# NotchDrop 💧

**Smart menu bar manager for MacBook Pro with notch**

![Platform](https://img.shields.io/badge/platform-macOS%2014%2B-blue.svg)
![Swift](https://img.shields.io/badge/swift-5.0-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

<p align="center">
  <img src="Screenshots/icon.png" width="200" alt="NotchDrop Icon">
</p>

## 🎯 Problem

MacBook Pro's notch hides menu bar icons - can't access WiFi, Bluetooth, and other controls.

## ✨ Solution

Move mouse into the notch → Menu bar drops below it → All icons visible and clickable!

## 🎮 How to Use

1. Hover mouse **into the notch** (black area at top center)
2. Menu bar automatically drops below notch
3. Move mouse away - countdown starts (`30`...`29`...`28`)
4. Click countdown number for immediate restore, or wait for auto-restore

## ⚙️ Features

- Hover activation (strict notch area only)
- Real menu bar repositioning (fully functional icons)
- Smart countdown timer display
- Click to cancel countdown
- Customizable auto-restore delay (5-120 seconds)
- Right-click menu bar button for settings

## 🚀 Installation

### Build from Source

```bash
git clone https://github.com/yourusername/NotchDrop.git
cd NotchDrop
open NotchDrop.xcodeproj
# Press ⌘R in Xcode
```

## 💡 Technical Approach

Uses display resolution switching:
- **Normal**: 3:2 ratio - menu bar in notch area
- **Dropped**: 16:10 ratio - menu bar below notch

All menu bar icons remain fully functional (not simulated).

## 📋 Requirements

- macOS 14.0+
- MacBook Pro with notch (14" or 16")

## 📄 License

MIT License

## 🙏 Credits

Inspired by Say No to Notch and Hidden Bar

---

**NotchDrop** - One hover to access all menu bar icons 💧
