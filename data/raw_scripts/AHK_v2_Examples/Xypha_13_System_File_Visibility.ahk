#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * System File Visibility Toggle
 *
 * Demonstrates toggling the visibility of hidden system files
 * in Windows Explorer via registry modification.
 *
 * Source: xypha/AHK-v2-scripts - Showcase.ahk
 * Inspired by: https://github.com/xypha/AHK-v2-scripts
 */

MsgBox("System File Visibility Toggle`n`n"
     . "This script toggles the visibility of:`n"
     . "- Hidden files and folders`n"
     . "- System files`n"
     . "- File extensions`n`n"
     . "Press Win+H to toggle visibility`n`n"
     . "Changes are applied to all Explorer windows.", , "T5")

; Hotkey to toggle
#h::ToggleSystemFileVisibility()

/**
 * Toggle system file visibility in Explorer
 */
ToggleSystemFileVisibility() {
    ; Registry key for Explorer settings
    regKey := "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

    try {
        ; Read current state
        currentHidden := RegRead(regKey, "Hidden")
        currentSystem := RegRead(regKey, "ShowSuperHidden")
        currentExt := RegRead(regKey, "HideFileExt")

        ; Determine new state (toggle)
        if (currentHidden == 1 && currentSystem == 1 && currentExt == 0) {
            ; Currently showing - hide everything
            RegWrite(2, "REG_DWORD", regKey, "Hidden")
            RegWrite(0, "REG_DWORD", regKey, "ShowSuperHidden")
            RegWrite(1, "REG_DWORD", regKey, "HideFileExt")
            state := "Hidden"
        } else {
            ; Currently hidden - show everything
            RegWrite(1, "REG_DWORD", regKey, "Hidden")
            RegWrite(1, "REG_DWORD", regKey, "ShowSuperHidden")
            RegWrite(0, "REG_DWORD", regKey, "HideFileExt")
            state := "Visible"
        }

        ; Refresh all Explorer windows
        RefreshExplorer()

        ; Show notification
        ToolTip("System Files: " state "`n"
              . "Hidden Files: " state "`n"
              . "File Extensions: " (state == "Visible" ? "Shown" : "Hidden"))
        SetTimer(() => ToolTip(), -3000)

    } catch Error as e {
        MsgBox("Failed to modify registry:`n" e.Message, "Error", "Icon!")
    }
}

/**
 * Refresh all Explorer windows to apply changes
 */
RefreshExplorer() {
    ; Method 1: Send F5 to all Explorer windows
    try {
        for window in ComObject("Shell.Application").Windows {
            ; Send refresh to each window
            PostMessage(0x111, 41504, 0, , "ahk_id " window.HWND)  ; ID_REFRESH
        }
    }

    ; Method 2: Broadcast setting change
    DllCall("shell32\SHChangeNotify", "UInt", 0x8000000, "UInt", 0, "Ptr", 0, "Ptr", 0)
}

/*
 * Key Concepts:
 *
 * 1. Registry Settings:
 *    HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
 *    Hidden: 1=Show, 2=Don't show
 *    ShowSuperHidden: 1=Show system, 0=Hide
 *    HideFileExt: 0=Show, 1=Hide
 *
 * 2. Registry Operations:
 *    RegRead(key, value) - Read value
 *    RegWrite(value, type, key, name) - Write value
 *    REG_DWORD for numbers
 *    REG_SZ for strings
 *
 * 3. Explorer Refresh:
 *    PostMessage(ID_REFRESH) - Soft refresh
 *    SHChangeNotify() - System-wide notification
 *    Both needed for immediate effect
 *
 * 4. Shell Change Notify:
 *    0x8000000 = SHCNE_ASSOCCHANGED
 *    Notifies shell of setting change
 *    Refreshes all Explorer windows
 *
 * 5. Use Cases:
 *    ✅ Development (view .git, node_modules)
 *    ✅ System administration
 *    ✅ Troubleshooting
 *    ✅ File recovery
 *    ✅ Security analysis
 *
 * 6. File Visibility States:
 *    Normal files - Always visible
 *    Hidden files - Hidden attribute
 *    System files - System attribute
 *    Extensions - Filename display
 *
 * 7. Safety Considerations:
 *    ✅ Read before write
 *    ✅ Try/catch for errors
 *    ✅ Admin rights may be needed
 *    ⚠ Don't delete system files
 *
 * 8. Registry Structure:
 *    HKCU - Current user settings
 *    HKLM - Machine-wide settings
 *    Software - Application data
 *    Policies override Advanced
 *
 * 9. Best Practices:
 *    ✅ Check current state
 *    ✅ Toggle, don't assume
 *    ✅ Refresh immediately
 *    ✅ Show confirmation
 *
 * 10. Related Settings:
 *     SuperHidden - System files
 *     Hidden - Hidden attribute
 *     HideFileExt - Extensions
 *     ShowCompColor - Compressed
 *     ShowEncryptCompressedColor - Encrypted
 *
 * 11. Alternative Methods:
 *     - attrib command
 *     - Group Policy
 *     - Folder Options dialog
 *     - PowerShell cmdlets
 *
 * 12. Enhancements:
 *     - Separate toggles for each setting
 *     - Remember user preferences
 *     - Temporary visibility
 *     - Per-folder settings
 *     - Tray icon indicator
 *     - Keyboard shortcuts in Explorer
 */
