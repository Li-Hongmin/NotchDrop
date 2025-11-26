# NotchDrop 💧

**Automatic menu bar control for MacBook with notch**

![Platform](https://img.shields.io/badge/platform-macOS%2014%2B-blue.svg)
![Swift](https://img.shields.io/badge/swift-5.0-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Compatibility](https://img.shields.io/badge/MacBook-All%20Models%20with%20Notch-purple.svg)

<p align="center">
  <img src="Screenshots/icon.png" width="200" alt="NotchDrop Icon">
</p>

## 🎯 Problem

The MacBook notch hides menu bar icons—WiFi, Bluetooth, system controls, and your favorite apps become hard to access.

## ✨ Solution

**Just move your mouse toward the notch—menu bar automatically drops down. No clicking needed!**

Move mouse to notch → Menu bar auto-drops below → All icons visible → Move away → Auto-restores

## 🎮 How to Use

**It's automatic!**

1. **Hover your mouse toward the notch** (black area at top center)
2. Menu bar **automatically drops** below the notch
3. Access any menu bar app you need
4. **Move mouse away** - countdown starts (30...29...28...)
5. Menu bar **auto-restores** to original position

**Manual control:** Click the NotchDrop icon or the countdown number for instant restore

## ⚙️ Features

✨ **Automatic Mouse Detection**
- Hover near the notch → Menu bar drops instantly
- No clicking required, just natural mouse movement
- Smart detection zone calibrated for perfect timing

🎯 **Smart Auto-Restore**
- Customizable countdown (5-60 seconds)
- Click countdown to restore immediately
- Or simply move mouse away and let it auto-restore

🖱️ **Manual Control Option**
- Click menu bar icon to toggle anytime
- Right-click for quick settings access
- Both automatic and manual modes available

🚀 **Seamless Experience**
- Real display mode switching (not simulation)
- All menu bar icons remain fully functional
- Smooth animations, zero lag
- Launch at login option

## 🚀 Installation

### Build from Source

```bash
git clone https://github.com/yourusername/NotchDrop.git
cd NotchDrop
open NotchDrop.xcodeproj
# Press ⌘R in Xcode
```

## 💡 Technical Approach

NotchDrop uses intelligent display mode switching:
- **Normal Mode**: 3:2 aspect ratio - menu bar positioned in notch area
- **Dropped Mode**: 16:10 aspect ratio - menu bar moves below notch
- **Mouse Tracking**: Monitors cursor position to detect notch proximity
- **Smart Debouncing**: Prevents flickering with intelligent timing

All menu bar icons remain fully functional (not screenshots or simulations).

## 📋 Requirements

- **macOS**: 14.0 (Sonoma) or later
- **Device**: Any MacBook with notch
  - MacBook Pro 14" (2021, 2023, 2024)
  - MacBook Pro 16" (2021, 2023, 2024)
  - MacBook Air 13" / 15" (if equipped with notch)
- **Chip**: Apple Silicon (M1, M2, M3, M4 series) or Intel

## 📄 License

MIT License

## 🙏 Credits

Inspired by Say No to Notch and Hidden Bar

## 🌟 Why NotchDrop?

**Other solutions require:**
- ❌ Clicking buttons
- ❌ Keyboard shortcuts
- ❌ Manual activation

**NotchDrop gives you:**
- ✅ Automatic mouse detection
- ✅ Zero-click access
- ✅ Natural, intuitive interaction
- ✅ Works on ALL MacBooks with notch

---

**NotchDrop** - Automatic menu bar access. Zero clicks required. 💧
