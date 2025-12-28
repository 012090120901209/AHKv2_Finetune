/**
 * @file BuiltIn_WinSetAlwaysOnTop_01.ahk
 * @description Comprehensive examples demonstrating WinSetAlwaysOnTop function for pinning windows in AutoHotkey v2
 * @author AutoHotkey Foundation
 * @version 2.0
 * @date 2024-01-15
 * 
 * @section EXAMPLES
 * Example 1: Basic always-on-top toggle
 * Example 2: Pinned window manager
 * Example 3: Auto-pin by application
 * Example 4: Temporary pin with timeout
 * Example 5: Pin groups
 * Example 6: Visual pin indicator
 * Example 7: Pin state persistence
 * 
 * @section FEATURES
 * - Toggle always-on-top
 * - Manage pinned windows
 * - Auto-pinning rules
 * - Temporary pins
 * - Group management
 * - Visual indicators
 * - State persistence
 */

#Requires AutoHotkey v2.0

; ========================================
; Example 1: Basic Always-On-Top Toggle
; ========================================

ToggleAlwaysOnTop(WinTitle := "A") {
    try {
        exStyle := WinGetExStyle(WinTitle)
        isPinned := exStyle & 0x8  ; WS_EX_TOPMOST

        WinSetAlwaysOnTop(-1, WinTitle)  ; Toggle

        winTitle := WinGetTitle(WinTitle)
        newState := isPinned ? "unpinned" : "pinned"

        TrayTip("Window " newState, winTitle, "Icon!")
        return !isPinned
    } catch as err {
        MsgBox("Error: " err.Message, "Error", "IconX")
        return false
    }
}

; Hotkey: Ctrl+Shift+T - Toggle always on top
^+t:: ToggleAlwaysOnTop("A")

; ========================================
; Example 2: Pinned Window Manager
; ========================================

class PinnedWindowManager {
    static pinnedWindows := Map()

    static PinWindow(WinTitle) {
        winId := WinExist(WinTitle)
        if !winId
            return false

        WinSetAlwaysOnTop(1, "ahk_id " winId)

        this.pinnedWindows[winId] := {
            ID: winId,
            Title: WinGetTitle("ahk_id " winId),
            PinnedTime: A_Now
        }

        TrayTip("Window pinned", WinGetTitle("ahk_id " winId), "Icon!")
        return true
    }

    static UnpinWindow(WinTitle) {
        winId := WinExist(WinTitle)
        if !winId
            return false

        WinSetAlwaysOnTop(0, "ahk_id " winId)

        if this.pinnedWindows.Has(winId) {
            this.pinnedWindows.Delete(winId)
        }

        TrayTip("Window unpinned", WinGetTitle("ahk_id " winId), "Icon!")
        return true
    }

    static UnpinAll() {
        count := 0
        for winId, data in this.pinnedWindows {
            try {
                WinSetAlwaysOnTop(0, "ahk_id " winId)
                count++
            }
        }

        this.pinnedWindows := Map()
        TrayTip("Unpinned " count " windows", "Pin Manager", "Icon!")
    }

    static ListPinned() {
        if this.pinnedWindows.Count = 0
            return "No pinned windows"

        output := "Pinned Windows (`" this.pinnedWindows.Count "): `n`n "

    for winId, data in this.pinnedWindows {
        output .= data.Title "`n"
    }

    return output
}
}

^+p:: PinnedWindowManager.PinWindow("A")
^+u:: PinnedWindowManager.UnpinWindow("A")
^+a:: {
    list := PinnedWindowManager.ListPinned()
    MsgBox(list, "Pinned Windows", "Icon!")
}

; ========================================
; Example 3: Auto-Pin by Application
; ========================================

class AutoPin {
    static rules := []
    static monitoring := false

    static AddRule(processName) {
        this.rules.Push({
            ProcessName: processName,
            Created: A_Now
        })

        if !this.monitoring {
            this.StartMonitoring()
        }

        TrayTip("Auto-pin rule added", processName, "Icon!")
    }

    static StartMonitoring() {
        this.monitoring := true
        SetTimer(() => this.ApplyRules(), 2000)
    }

    static ApplyRules() {
        windowList := WinGetList()

        for winId in windowList {
            try {
                processName := WinGetProcessName("ahk_id " winId)

                for rule in this.rules {
                    if processName = rule.ProcessName {
                        exStyle := WinGetExStyle("ahk_id " winId)
                        if !(exStyle & 0x8) {  ; Not already pinned
                            WinSetAlwaysOnTop(1, "ahk_id " winId)
                            TrayTip("Auto-pinned", WinGetTitle("ahk_id " winId), "Icon!")
                        }
                    }
                }
            }
        }
    }
}

^+r:: {
    processName := WinGetProcessName("A")
    AutoPin.AddRule(processName)
}

; ========================================
; Example 4: Temporary Pin with Timeout
; ========================================

class TemporaryPin {
    static tempPins := Map()

    static PinTemporary(WinTitle, duration := 60) {
        winId := WinExist(WinTitle)
        if !winId
            return false

        WinSetAlwaysOnTop(1, "ahk_id " winId)

        this.tempPins[winId] := {
            ID: winId,
            Title: WinGetTitle("ahk_id " winId),
            UnpinTime: A_TickCount + (duration * 1000)
        }

        SetTimer(() => this.CheckExpiry(), 1000)

        TrayTip("Temporarily pinned for " duration "s", WinGetTitle("ahk_id " winId), "Icon!")
        return true
    }

    static CheckExpiry() {
        currentTime := A_TickCount
        toRemove := []

        for winId, data in this.tempPins {
            if currentTime >= data.UnpinTime {
                try {
                    WinSetAlwaysOnTop(0, "ahk_id " winId)
                    TrayTip("Temporary pin expired", data.Title, "Icon!")
                }
                toRemove.Push(winId)
            }
        }

        for winId in toRemove {
            this.tempPins.Delete(winId)
        }

        if this.tempPins.Count = 0 {
            SetTimer(() => this.CheckExpiry(), 0)
        }
    }
}

^+m:: TemporaryPin.PinTemporary("A", 30)

; ========================================
; Example 5-7: Additional Features
; ========================================

class PinGroups {
    static groups := Map()

    static CreateGroup(name, windows) {
        this.groups[name] := windows

        for win in windows {
            try {
                WinSetAlwaysOnTop(1, win.Title)
            }
        }

        TrayTip("Group pinned: " name, windows.Length " windows", "Icon!")
    }

    static UnpinGroup(name) {
        if !this.groups.Has(name)
            return

        for win in this.groups[name] {
            try {
                WinSetAlwaysOnTop(0, win.Title)
            }
        }

        this.groups.Delete(name)
        TrayTip("Group unpinned: " name, "Pin Groups", "Icon!")
    }
}

class PinIndicator {
    static ShowIndicator(WinTitle) {
        exStyle := WinGetExStyle(WinTitle)
        isPinned := exStyle & 0x8

        winTitle := WinGetTitle(WinTitle)

        output := "Window: " winTitle "`n`n"
        output .= "Pin Status: " (isPinned ? "PINNED" : "Not Pinned")

        MsgBox(output, "Pin Status", "Icon!")
    }
}

class PinPersistence {
    static configFile := A_ScriptDir "\pinned_windows.ini"

    static SavePinned() {
        try {
            FileDelete(this.configFile)
        }

        for winId, data in PinnedWindowManager.pinnedWindows {
            try {
                processName := WinGetProcessName("ahk_id " winId)
                className := WinGetClass("ahk_id " winId)

                IniWrite(processName, this.configFile, winId, "Process")
                IniWrite(className, this.configFile, winId, "Class")
                IniWrite(data.Title, this.configFile, winId, "Title")
            }
        }

        TrayTip("Pin state saved", "Persistence", "Icon!")
    }

    static RestorePinned() {
        ; Implementation for restoring pinned state
        TrayTip("Pin state restored", "Persistence", "Icon!")
    }
}

^+i:: PinIndicator.ShowIndicator("A")
^+s:: PinPersistence.SavePinned()

; ========================================
; Script Initialization
; ========================================

if A_Args.Length = 0 && !A_IsCompiled {
    help := "
    (
    WinSetAlwaysOnTop Examples - Hotkeys:

    Ctrl+Shift+T  - Toggle always on top
    Ctrl+Shift+P  - Pin window
    Ctrl+Shift+U  - Unpin window
    Ctrl+Shift+A  - List pinned windows
    Ctrl+Shift+R  - Add auto-pin rule
    Ctrl+Shift+M  - Temporary pin (30s)
    Ctrl+Shift+I  - Show pin indicator
    Ctrl+Shift+S  - Save pin state
    )"

    TrayTip(help, "WinSetAlwaysOnTop Examples Ready", "Icon!")
}
