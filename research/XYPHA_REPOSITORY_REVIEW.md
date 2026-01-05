# xypha AHK v2 Scripts Repository Review

**Repository:** https://github.com/xypha/AHK-v2-scripts
**Main Script:** Showcase.ahk
**License:** MIT
**Last Updated:** 2024.11.29

## Overview

xypha's repository is an **all-in-one productivity script** collection focused on practical Windows automation, keyboard enhancements, and quality-of-life improvements. Unlike function libraries, this is a complete, ready-to-use script with customizable features.

---

## Repository Structure

```
AHK-v2-scripts/
├── Showcase.ahk          # Main all-in-one script
├── standalone/
│   └── MultiClip.ahk     # Standalone clipboard manager
├── Lib/                  # Library dependencies
├── icons/
│   └── Tray/            # Icon resources
└── obsolete/            # Deprecated scripts
```

---

## Feature Categories

### 1. **System Management**

| Feature | Hotkey | Description |
|---------|--------|-------------|
| Lock Key Control | Startup | Set default states for CapsLock, NumLock, ScrollLock |
| OS File Visibility | Tray Menu | Toggle hidden system files in Explorer |
| Display Control | Ctrl+Esc | Turn monitor off instantly |
| Process Priority | Win+P | Adjust priority of active process |

**Key Functions:**
- `OSfiles_toggle()` - Toggle hidden system files via registry
- `RefreshExplorer()` - Refresh all open Explorer windows
- `RegJump()` - Jump to specific registry key

---

### 2. **Window & Interface Management**

| Feature | Hotkey | Description |
|---------|--------|-------------|
| Window Transparency | Ctrl+Shift+Wheel | Adjust opacity incrementally |
| Preset Transparency | F8 | Cycle through preset levels |
| Always-On-Top | Alt+T | Toggle window always-on-top |
| Gentle Close | Alt+RightClick | Close window gracefully |
| Force Kill | Ctrl+Alt+F4 | Force close window |
| Terminate Process | Ctrl+Alt+Shift+F4 | Kill entire process |

**Key Functions:**
- `WinTrans_setMouse()` - Set transparency under mouse
- `WinTrans_get()` - Get current transparency value

**Transparency Presets:**
- 100% - Fully opaque
- 90% - Slight transparency
- 80% - Moderate
- 70% - Transparent
- 60% - Very transparent
- 50% - Half transparent

---

### 3. **Keyboard Customization**

| Feature | Hotkey | Description |
|---------|--------|-------------|
| Disable Insert | Insert | Blocks accidental Insert key |
| Win+Tab Remap | Win+Tab | Maps to Alt+Tab |
| Mouse Movement | Win+Numpad1-9 | Pixel-precise mouse control |
| CapsLock Enhancement | Shift+CapsLock | Auto-disable with timeout |

**Key Features:**
- Function key remapping for laptops
- Custom key blocking
- Enhanced navigation

---

### 4. **Text & Clipboard Tools**

#### **Case Conversion**
| Type | Example |
|------|---------|
| lowercase | "hello world" |
| UPPERCASE | "HELLO WORLD" |
| Sentence case | "Hello world" |
| Title Case | "Hello World" |
| iNVERT cASE | "hELLO wORLD" |

**Function:** `ChangeCase_menuFn()`

#### **Text Wrapping**
Enclose selections in:
- "Double quotes"
- 'Single quotes'
- (Parentheses)
- [Square brackets]
- {Curly braces}
- <Angle brackets>
- \`Backticks\`

**Function:** `WrapText_menuFn()`

#### **Character Operations**
- `Alt+L` - Swap adjacent characters
- Trim clipboard whitespace
- Insert date/time stamps

---

### 5. **MultiClip - Clipboard Manager**

**Features:**
- 25 clipboard slots
- Persistent storage
- Quick paste with v1+, v2+, etc.
- Clipboard history tracking
- File backup

**Key Functions:**
- `MultiClip_onChange()` - Monitor clipboard
- `MultiClip_addClip()` - Add to history
- `MultiClip_pasteV()` - Paste from v-hotstrings
- `MultiClip_pasteC()` - Paste multiple slots
- `MultiClip_saveFileBackup()` - Persist to file

**Hotstring Pattern:**
```
v1+ → Paste slot 1
v2+ → Paste slot 2
...
v25+ → Paste slot 25

c12+ → Paste slots 1 and 2
c35+ → Paste slots 3 and 5
```

---

### 6. **File & Folder Operations**

| Feature | Hotkey | Description |
|---------|--------|-------------|
| Recycle Bin | Ctrl+Delete | Quick access to Recycle Bin |
| Copy Path | Explorer-specific | Copy full path of selection |
| Copy Filename | Explorer-specific | Copy filename only |
| Unicode Filenames | Auto | Allow special symbols in names |

**Key Functions:**
- `ExplorerTab_GetSelectionPath()` - Get selected file paths
- `Explorer_GetSize()` - Calculate folder/file sizes
- `DeleteEmptyFolder()` - Remove empty directories
- `RBinDisplay()` - Show Recycle Bin contents

---

### 7. **Encoding Utilities**

**Base64:**
- `Base64_encode()` - Encode to Base64
- `Base64_decode()` - Decode from Base64
- `Base64_decodeX2()` - Double decode

**URL:**
- `URL_encode()` - Percent-encode URLs
- `URL_decode()` - Decode URL encoding

**Use Cases:**
- API authentication
- Data transmission
- URL construction
- Binary data in text format

---

### 8. **Notification System**

**Function:** `MyNotification_show()`

**Parameters:**
- `myText` - Message content
- `myDuration` - Display time (ms)
- `xAxis` - Horizontal position (left/center/right)
- `yAxis` - Vertical position (top/center/bottom)
- `endType` - Close behavior

**Features:**
- Custom GUI notifications
- Replaces deprecated TrayTip
- Positioning control
- Auto-close timer
- No Action Center dependency

---

### 9. **App-Specific Features**

#### **Firefox**
- `Ctrl+Shift+O` - Open bookmarks manager
- `Ctrl+Shift+Q` - Disable accidental exit

#### **Explorer**
- Enhanced selection commands
- Path copying shortcuts
- Bulk renaming tools

#### **Telegram Desktop**
- Custom keyboard shortcuts

---

### 10. **Additional Utilities**

**Horizontal Scrolling:**
Five methods for simulating tilt-wheel:
- Shift+Wheel
- Ctrl+Wheel
- Alt+Wheel
- RButton+Wheel
- Custom combinations

**Auto-Capitalization:**
- Capitalize first letters after punctuation
- Opt-in for specific applications
- Notepad++ integration

**Error Handling:**
- `CatchError_details()` - Extract error info
- `CatchError_show()` - Display errors
- Context-specific help

---

## Global Configuration

### Variables
```autohotkey
MenuShortcuts := [1-9, 0, Q-G]  ; Menu navigation
MultiClip_arr := []             ; Clipboard history (25 slots)
MultiClip_fileBackup := path    ; Persistent storage
Send_LenLimit := 20             ; Threshold for Send vs. Paste
```

### Hotkey Groups
```autohotkey
CapitaliseFirstLetter_optIn     ; Auto-capitalize
CloseWithEscQW                  ; Close with Esc/Q/W
HorizontalScroll1               ; Shift+Wheel scrolling
FileNameSymbols                 ; Replace forbidden chars
```

---

## Code Quality

### Strengths
✅ **Well-Organized** - Clear section separation
✅ **Documented** - Comments explain functions
✅ **Modular** - Functions are reusable
✅ **Tested** - Production-ready code
✅ **Maintained** - Regular updates

### Best Practices
✅ Error handling with try/catch
✅ Clipboard preservation
✅ User notifications
✅ Persistent storage
✅ Registry safety checks

---

## Comparison Matrix

| Aspect | xypha | jNizM | Lexikos |
|--------|-------|-------|---------|
| **Type** | All-in-one | Utilities | Libraries |
| **Scope** | Productivity | System APIs | Frameworks |
| **Usage** | Run directly | Copy functions | Include libraries |
| **Complexity** | Medium | Low-Medium | High |
| **Customization** | High | N/A | Medium |
| **Learning Curve** | Low | Low | High |

---

## Installation & Usage

### Quick Start
1. Download `Showcase.ahk`
2. Review and customize hotkeys
3. Run the script
4. Access features via tray icon

### Customization
```autohotkey
; Modify hotkeys
^+v::YourFunction()  ; Change from default

; Configure behavior
Send_LenLimit := 30  ; Adjust threshold

; Enable/disable features
; Comment out unwanted hotkeys
```

### Standalone Scripts
- `MultiClip.ahk` - Use clipboard manager independently
- Extract individual functions as needed

---

## Use Cases

### Perfect For:
1. **Daily Productivity** - Quick access to common tasks
2. **Text Editing** - Case conversion, wrapping, swapping
3. **Window Management** - Transparency, always-on-top
4. **Clipboard Power Users** - Multiple clipboard slots
5. **Custom Workflows** - Hotkey automation

### Not Ideal For:
1. **Minimal Scripts** - Too feature-rich for simple needs
2. **Specific Workflows** - May need customization
3. **Learning AHK** - Start with simpler scripts first

---

## Rating: 4.5/5

### Strengths:
✅ **Comprehensive** - Covers many use cases
✅ **Practical** - Real-world utility
✅ **Customizable** - Easy to modify
✅ **Quality Code** - Well-written and maintained
✅ **Documentation** - Good inline comments
✅ **MIT License** - Free for any use

### Weaknesses:
⚠️ **Feature Overload** - May be overwhelming initially
⚠️ **Hotkey Conflicts** - May conflict with other apps
⚠️ **Windows-Only** - Platform-specific features

---

## Highlighted Features

### Top 5 Most Useful:
1. **MultiClip** - 25-slot clipboard manager with persistence
2. **Window Transparency** - Smooth control with mouse wheel
3. **Case Converter** - 5 case types with one hotkey
4. **Text Wrapping** - Quick formatting for coding
5. **Custom Notifications** - Better than Windows notifications

### Most Innovative:
- **MultiClip hotstring system** (v1+, c12+)
- **Five horizontal scrolling methods**
- **Auto-capitalize with opt-in**
- **Unicode filename support**
- **Preset transparency cycling**

---

## Learning Value

### Beginner-Friendly:
- Clear function names
- Well-commented code
- Practical examples
- Easy to test

### Advanced Techniques:
- GUI creation
- Clipboard monitoring
- Registry manipulation
- DLL calls (Base64)
- OnMessage handlers

### Patterns to Study:
- Menu systems
- Static variables
- Hotkey groups
- Error handling
- File I/O

---

## Examples Created

We've created 6 comprehensive examples demonstrating:

1. **Notification System** - Custom GUI notifications with positioning
2. **MultiClip Manager** - Full clipboard history implementation
3. **Text Case Converter** - All 5 case conversion types
4. **Window Transparency** - Mouse wheel and preset controls
5. **Text Wrapping** - Quote and bracket wrapping
6. **Encoding Utilities** - Base64 and URL encoding/decoding

---

## Recommendations

### For New Users:
1. Start with Notepad to test features
2. Review hotkeys for conflicts
3. Customize gradually
4. Use tray menu for discovery

### For Developers:
1. Study function organization
2. Learn GUI creation patterns
3. Understand clipboard management
4. Review error handling

### For Power Users:
1. Customize hotkeys to workflow
2. Extend MultiClip slots
3. Add custom text wrappers
4. Create app-specific features

---

## Resources

- **Repository:** https://github.com/xypha/AHK-v2-scripts
- **Main Script:** Showcase.ahk (all-in-one)
- **Standalone:** MultiClip.ahk
- **Issues:** GitHub Issues for bugs
- **License:** MIT (free for all use)

---

## Conclusion

xypha's repository is an **excellent all-in-one productivity script** that demonstrates professional-quality AHK v2 development. It's immediately useful, well-maintained, and serves as both a practical tool and learning resource.

**Best For:** Daily Windows users who want to supercharge their productivity with keyboard shortcuts and automation.

**Install If:** You want a comprehensive, tested, ready-to-use automation suite.

**Fork If:** You want to customize for your specific workflow.

---

## Quick Reference Card

```
SYSTEM
  Ctrl+Esc        - Turn off monitor
  Win+P           - Adjust process priority

WINDOWS
  Ctrl+Shift+Wheel - Adjust transparency
  F8              - Cycle transparency presets
  Alt+T           - Toggle always-on-top

TEXT
  Alt+C           - Case converter menu
  Alt+W           - Text wrapping menu
  Alt+L           - Swap adjacent characters

CLIPBOARD
  Ctrl+Shift+V    - MultiClip menu
  Ctrl+1-9, 0     - Paste from slots
  v1+, v2+...     - Paste hotstrings

FILES
  Ctrl+Delete     - Recycle Bin access
  (Explorer-specific path/filename copying)

APPS
  Firefox: Ctrl+Shift+O (bookmarks)
  Various app-specific enhancements
```

