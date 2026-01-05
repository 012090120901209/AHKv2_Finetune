#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * WinShow Examples - Part 1
 * ============================================================================
 * 
 * Demonstrates window showing/revealing techniques.
 * 
 * @description Window showing examples
 * @author AutoHotkey Community
 * @version 2.0.0
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Show Hidden Window
; ============================================================================

/**
 * Shows the last hidden window
 * 
 * @hotkey F1 - Show hidden window
 */
F1:: {
    if IsSet(lastHiddenWindow) && WinExist(lastHiddenWindow) {
        WinShow(lastHiddenWindow)
        WinActivate(lastHiddenWindow)
        ToolTip("Window shown")
        SetTimer(() => ToolTip(), -1500)
    } else {
        MsgBox("No hidden window to show.", "Info", 64)
    }
}

; ============================================================================
; Example 2: Show All Hidden Windows
; ============================================================================

/**
 * Shows all currently hidden windows
 * 
 * @hotkey F2 - Show all hidden
 */
F2:: {
    allWindows := WinGetList()
    shown := 0

    for hwnd in allWindows {
        try {
            ; Check if window is hidden
            style := WinGetStyle(hwnd)
            if !(style & 0x10000000) {  ; Not visible
                title := WinGetTitle(hwnd)
                if title != "" {
                    WinShow(hwnd)
                    shown++
                }
            }
        }
    }

    MsgBox("Shown " shown " hidden window(s).", "Success", 64)
}

; ============================================================================
; Example 3: Show and Activate Window
; ============================================================================

/**
 * Shows window and brings to front
 * 
 * @hotkey F3 - Show and activate Notepad
 */
F3:: {
    if WinExist("ahk_class Notepad") {
        WinShow("ahk_class Notepad")
        WinActivate("ahk_class Notepad")
        WinRestore("ahk_class Notepad")
        ToolTip("Notepad shown and activated")
        SetTimer(() => ToolTip(), -1500)
    }
}

; ============================================================================
; Example 4: Selective Show
; ============================================================================

/**
 * Shows windows matching criteria
 * 
 * @hotkey F4 - Selective show
 */
F4:: {
    result := InputBox("Enter process name to show:", "Selective Show", "w300 h130", "notepad.exe")

    if result.Result != "OK" || result.Value = "" {
        return
    }

    windows := WinGetList("ahk_exe " result.Value)
    shown := 0

    for hwnd in windows {
        try {
            WinShow(hwnd)
            shown++
        }
    }

    MsgBox("Shown " shown " window(s) of " result.Value, "Success", 64)
}

; ============================================================================
; Example 5: Show With Animation
; ============================================================================

/**
 * Shows window with fade-in effect
 * 
 * @hotkey F5 - Show with animation
 */
F5:: {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    hwnd := WinGetID("A")

    ; Hide first
    WinHide(hwnd)
    Sleep(500)

    ; Show with transparency animation
    WinSetTransparent(0, hwnd)
    WinShow(hwnd)

    Loop 10 {
        WinSetTransparent(A_Index * 25, hwnd)
        Sleep(50)
    }

    WinSetTransparent("Off", hwnd)
    ToolTip("Window shown with animation")
    SetTimer(() => ToolTip(), -1500)
}

; ============================================================================
; Example 6: Restore Minimized Windows
; ============================================================================

/**
 * Shows all minimized windows
 * 
 * @hotkey F6 - Restore all minimized
 */
F6:: {
    allWindows := WinGetList()
    restored := 0

    for hwnd in allWindows {
        try {
            if WinGetMinMax(hwnd) = -1 {  ; Minimized
                WinRestore(hwnd)
                WinShow(hwnd)
                restored++
            }
        }
    }

    MsgBox("Restored " restored " minimized window(s).", "Success", 64)
}

; ============================================================================
; Example 7: Show Window List
; ============================================================================

/**
 * Shows GUI with all hidden windows
 * 
 * @hotkey F7 - Show hidden window list
 */
F7:: {
    ShowHiddenWindowList()
}

ShowHiddenWindowList() {
    static listGui := ""

    if listGui {
        try listGui.Destroy()
    }

    listGui := Gui("+AlwaysOnTop", "Hidden Windows")
    listGui.SetFont("s10", "Segoe UI")

    listGui.Add("Text", "w400", "Select window to show:")

    lv := listGui.Add("ListView", "w400 h250 vHiddenList", ["Title", "Process"])

    hiddenWins := []
    allWindows := WinGetList()

    for hwnd in allWindows {
        try {
            style := WinGetStyle(hwnd)
            if !(style & 0x10000000) {  ; Hidden
                title := WinGetTitle(hwnd)
                if title != "" {
                    process := WinGetProcessName(hwnd)
                    lv.Add("", title, process)
                    hiddenWins.Push(hwnd)
                }
            }
        }
    }

    if hiddenWins.Length = 0 {
        MsgBox("No hidden windows found.", "Info", 64)
        return
    }

    lv.ModifyCol(1, 250)
    lv.ModifyCol(2, "AutoHdr")

    listGui.Add("Button", "w195 Default", "Show Selected").OnEvent("Click", ShowSelected)
    listGui.Add("Button", "w195 x+10 yp", "Cancel").OnEvent("Click", (*) => listGui.Destroy())

    listGui.Show()

    ShowSelected(*) {
        selectedRow := lv.GetNext()
        if selectedRow = 0 {
            MsgBox("Please select a window.", "Error", 16)
            return
        }

        hwnd := hiddenWins[selectedRow]
        WinShow(hwnd)
        WinActivate(hwnd)

        listGui.Destroy()
        ToolTip("Window shown")
        SetTimer(() => ToolTip(), -1500)
    }
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc:: ExitApp()

^F1:: {
    help := "
    (
    WinShow Examples - Part 1
    =============================

    Hotkeys:
    F1 - Show last hidden window
    F2 - Show all hidden windows
    F3 - Show and activate Notepad
    F4 - Selective show by process
    F5 - Show with animation
    F6 - Restore all minimized
    F7 - Show hidden window list
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(help, "Help", 64)
}
