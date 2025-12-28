#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Practical Hotkey Systems - Real-World Applications
 * ============================================================================
 * 
 * Comprehensive examples of practical hotkey systems for real-world use cases.
 * Includes window management, clipboard management, text manipulation,
 * launcher systems, and productivity tools.
 * 
 * @author AutoHotkey v2 Documentation Team
 * @version 1.0.0
 */

; ============================================================================
; Example 1: Window Management System
; ============================================================================

Example1_WindowManagement() {
    /**
     * Snaps window to left half of screen
     */
    Hotkey("#Left", (*) {
        if WinExist("A") {
            WinGetPos(&x, &y, &w, &h, "A")
            screenW := A_ScreenWidth
            screenH := A_ScreenHeight
            WinMove(0, 0, screenW // 2, screenH, "A")
        }
    })

    /**
     * Snaps window to right half
     */
    Hotkey("#Right", (*) {
        if WinExist("A") {
            screenW := A_ScreenWidth
            screenH := A_ScreenHeight
            WinMove(screenW // 2, 0, screenW // 2, screenH, "A")
        }
    })

    /**
     * Maximizes window
     */
    Hotkey("#Up", (*) {
        if WinExist("A")
            WinMaximize("A")
    })

    /**
     * Minimizes window
     */
    Hotkey("#Down", (*) {
        if WinExist("A")
            WinMinimize("A")
    })

    /**
     * Centers window
     */
    Hotkey("#c", (*) {
        if WinExist("A") {
            WinGetPos(, , &w, &h, "A")
            x := (A_ScreenWidth - w) // 2
            y := (A_ScreenHeight - h) // 2
            WinMove(x, y, , , "A")
        }
    })

    /**
     * Always on top toggle
     */
    Hotkey("#t", (*) {
        if WinExist("A") {
            WinSetAlwaysOnTop(-1, "A")
            exStyle := WinGetExStyle("A")
            isOnTop := (exStyle & 0x8) ? true : false
            ToolTip("Always on top: " . (isOnTop ? "ON" : "OFF"))
            SetTimer(() => ToolTip(), -1500)
        }
    })

    MsgBox(
        "Window Management System`n`n"
        "Win+Left → Snap left`n"
        "Win+Right → Snap right`n"
        "Win+Up → Maximize`n"
        "Win+Down → Minimize`n"
        "Win+C → Center window`n"
        "Win+T → Toggle always on top`n`n"
        "Open some windows and try!",
        "Example 1"
    )
}

; ============================================================================
; Example 2: Advanced Clipboard Manager
; ============================================================================

Example2_ClipboardManager() {
    global clipHistory := []
    global maxHistory := 10

    /**
     * Saves clipboard to history
     */
    SaveClipboard() {
        global clipHistory, maxHistory

        if A_Clipboard != "" {
            ; Add to history
            clipHistory.Push({
                content: A_Clipboard,
                time: FormatTime(, "HH:mm:ss"),
                type: DllCall("IsClipboardFormatAvailable", "uint", 1) ? "text" : "other"
            })

            ; Trim history
            while clipHistory.Length > maxHistory
                clipHistory.RemoveAt(1)
        }
    }

    /**
     * Shows clipboard history
     */
    ShowHistory() {
        global clipHistory

        if clipHistory.Length = 0 {
            MsgBox("Clipboard history is empty!", "History")
            return
        }

        histGui := Gui("+AlwaysOnTop", "Clipboard History")

        histGui.AddText("", "Select an item to restore:")
        histList := histGui.AddListBox("w500 r10", [])

        ; Populate list
        for index, item in clipHistory {
            preview := SubStr(item.content, 1, 50)
            if StrLen(item.content) > 50
                preview .= "..."
            histList.Add([index . ". " . preview . " [" . item.time . "]"])
        }

        histGui.AddButton("w500", "Restore Selected").OnEvent("Click", (*) {
            sel := histList.Value
            if sel > 0 && sel <= clipHistory.Length {
                A_Clipboard := clipHistory[sel].content
                MsgBox("Restored to clipboard!", "Restore")
                histGui.Destroy()
            }
        })

        histGui.Show()
    }

    ; Monitor clipboard changes
    OnClipboardChange(SaveClipboard)

    ; Hotkeys
    Hotkey("^!v", (*) => ShowHistory())
    Hotkey("^!#c", (*) {
        global clipHistory
        clipHistory := []
        MsgBox("Clipboard history cleared!", "Clear")
    })

    MsgBox(
        "Advanced Clipboard Manager`n`n"
        "Automatically saves last 10 clipboard items`n`n"
        "Ctrl+Alt+V → Show clipboard history`n"
        "Ctrl+Alt+Win+C → Clear history`n`n"
        "Copy some text and try viewing history!",
        "Example 2"
    )
}

; ============================================================================
; Example 3: Text Manipulation Tools
; ============================================================================

Example3_TextManipulation() {
    /**
     * Converts selected text to UPPER CASE
     */
    Hotkey("^!u", (*) {
        saved := A_Clipboard
        A_Clipboard := ""
        Send("^c")
        if ClipWait(0.5) {
            A_Clipboard := StrUpper(A_Clipboard)
            Send("^v")
        }
        Sleep(100)
        A_Clipboard := saved
    })

    /**
     * Converts selected text to lower case
     */
    Hotkey("^!l", (*) {
        saved := A_Clipboard
        A_Clipboard := ""
        Send("^c")
        if ClipWait(0.5) {
            A_Clipboard := StrLower(A_Clipboard)
            Send("^v")
        }
        Sleep(100)
        A_Clipboard := saved
    })

    /**
     * Converts to Title Case
     */
    Hotkey("^!t", (*) {
        saved := A_Clipboard
        A_Clipboard := ""
        Send("^c")
        if ClipWait(0.5) {
            A_Clipboard := StrTitle(A_Clipboard)
            Send("^v")
        }
        Sleep(100)
        A_Clipboard := saved
    })

    /**
     * Reverses selected text
     */
    Hotkey("^!r", (*) {
        saved := A_Clipboard
        A_Clipboard := ""
        Send("^c")
        if ClipWait(0.5) {
            text := A_Clipboard
            reversed := ""
            Loop Parse text
                reversed := A_LoopField . reversed
            A_Clipboard := reversed
            Send("^v")
        }
        Sleep(100)
        A_Clipboard := saved
    })

    /**
     * Wraps text in quotes
     */
    Hotkey("^!q", (*) {
        saved := A_Clipboard
        A_Clipboard := ""
        Send("^c")
        if ClipWait(0.5) {
            A_Clipboard := '"' . A_Clipboard . '"'
            Send("^v")
        }
        Sleep(100)
        A_Clipboard := saved
    })

    MsgBox(
        "Text Manipulation Tools`n`n"
        "Select text and press:`n"
        "Ctrl+Alt+U → UPPER CASE`n"
        "Ctrl+Alt+L → lower case`n"
        "Ctrl+Alt+T → Title Case`n"
        "Ctrl+Alt+R → Reverse text`n"
        "Ctrl+Alt+Q → Wrap in quotes`n`n"
        "Try selecting some text!",
        "Example 3"
    )
}

; ============================================================================
; Example 4: Application Launcher System
; ============================================================================

Example4_LauncherSystem() {
    global apps := Map(
        "n", { path: "notepad.exe", desc: "Notepad" },
        "c", { path: "calc.exe", desc: "Calculator" },
        "p", { path: "mspaint.exe", desc: "Paint" },
        "e", { path: "explorer.exe", desc: "Explorer" }
    )

    /**
     * Launches or activates an application
     */
    LaunchApp(key) {
        global apps

        if !apps.Has(key) {
            MsgBox("No app assigned to: " . key, "Error")
            return
        }

        app := apps[key]

        ; Try to activate if already running
        if WinExist("ahk_exe " . app.path) {
            WinActivate()
        } else {
            Run(app.path)
        }

        ToolTip("Launching: " . app.desc)
        SetTimer(() => ToolTip(), -1000)
    }

    /**
     * Shows launcher menu
     */
    ShowLauncher() {
        global apps

        menu := "Quick Launcher`n" . Repeat("=", 40) . "`n`n"

        for key, app in apps {
            menu .= "Win+Shift+" . StrUpper(key) . " → " . app.desc . "`n"
        }

        MsgBox(menu, "Launcher")
    }

    Repeat(char, count) {
        result := ""
        Loop count
            result .= char
        return result
    }

    ; Create launcher hotkeys
    for key in apps {
        Hotkey("#+", . key, (*) => LaunchApp(key))
    }

    ; Help hotkey
    Hotkey("#+/", (*) => ShowLauncher())

    ShowLauncher()
}

; ============================================================================
; Example 5: Multi-Monitor Productivity Tools
; ============================================================================

Example5_MultiMonitor() {
    /**
     * Moves window to next monitor
     */
    Hotkey("^!#Right", (*) {
        if WinExist("A") {
            ; Get current window position
            WinGetPos(&x, &y, &w, &h, "A")

            ; Simple logic: move to right
            newX := x + A_ScreenWidth
            WinMove(newX, y, w, h, "A")

            ToolTip("Moved to next monitor")
            SetTimer(() => ToolTip(), -1000)
        }
    })

    /**
     * Moves window to previous monitor
     */
    Hotkey("^!#Left", (*) {
        if WinExist("A") {
            WinGetPos(&x, &y, &w, &h, "A")
            newX := x - A_ScreenWidth
            WinMove(newX, y, w, h, "A")

            ToolTip("Moved to previous monitor")
            SetTimer(() => ToolTip(), -1000)
        }
    })

    MsgBox(
        "Multi-Monitor Tools`n`n"
        "Ctrl+Alt+Win+Right → Move window right`n"
        "Ctrl+Alt+Win+Left → Move window left`n`n"
        "Works best with multiple monitors!",
        "Example 5"
    )
}

; ============================================================================
; Example 6: Quick Note System
; ============================================================================

Example6_QuickNotes() {
    global notes := []

    /**
     * Creates a quick note
     */
    Hotkey("^!n", (*) {
        global notes

        result := InputBox("Enter your note:", "Quick Note", "w400 h100")

        if result.Result = "OK" && result.Value != "" {
            notes.Push({
                text: result.Value,
                time: FormatTime(, "yyyy-MM-dd HH:mm:ss")
            })

            MsgBox("Note saved! Total notes: " . notes.Length, "Saved")
        }
    })

    /**
     * Shows all notes
     */
    Hotkey("^!#n", (*) {
        global notes

        if notes.Length = 0 {
            MsgBox("No notes yet!", "Notes")
            return
        }

        noteList := "Quick Notes`n" . Repeat("=", 60) . "`n`n"

        for index, note in notes {
            noteList .= index . ". [" . note.time . "]`n"
            noteList .= "   " . note.text . "`n`n"
        }

        MsgBox(noteList, "All Notes")
    })

    /**
     * Exports notes to clipboard
     */
    Hotkey("^!#x", (*) {
        global notes

        if notes.Length = 0 {
            MsgBox("No notes to export!", "Export")
            return
        }

        export := "Quick Notes Export`n"
        export .= "Generated: " . FormatTime() . "`n"
        export .= Repeat("=", 60) . "`n`n"

        for note in notes {
            export .= "[" . note.time . "]`n"
            export .= note.text . "`n`n"
        }

        A_Clipboard := export
        MsgBox("Notes exported to clipboard!", "Export")
    })

    Repeat(char, count) {
        result := ""
        Loop count
            result .= char
        return result
    }

    MsgBox(
        "Quick Note System`n`n"
        "Ctrl+Alt+N → Create note`n"
        "Ctrl+Alt+Win+N → View all notes`n"
        "Ctrl+Alt+Win+X → Export to clipboard`n`n"
        "Perfect for quick ideas!",
        "Example 6"
    )
}

; ============================================================================
; Example 7: Custom Typing Speed Booster
; ============================================================================

Example7_TypingBooster() {
    /**
     * Date shortcuts
     */
    Hotkey("^!d", (*) => SendText(FormatTime(, "yyyy-MM-dd")))
    Hotkey("^!+d", (*) => SendText(FormatTime(, "MM/dd/yyyy")))
    Hotkey("^!#d", (*) => SendText(FormatTime(, "dddd, MMMM d, yyyy")))

    /**
     * Time shortcuts
     */
    Hotkey("^!t", (*) => SendText(FormatTime(, "HH:mm")))
    Hotkey("^!+t", (*) => SendText(FormatTime(, "h:mm tt")))

    /**
     * Email templates
     */
    Hotkey("^!e1", (*) => SendText("Dear [Name],`n`n`n`nBest regards,`n" . A_UserName))
    Hotkey("^!e2", (*) => SendText("Hi [Name],`n`n`n`nThanks,`n" . A_UserName))

    /**
     * Common phrases
     */
    Hotkey("^!1", (*) => SendText("Thank you for your email."))
    Hotkey("^!2", (*) => SendText("I will get back to you shortly."))
    Hotkey("^!3", (*) => SendText("Please let me know if you have any questions."))

    /**
     * Symbols
     */
    Hotkey("^!-", (*) => SendText("—")) ; Em dash
    Hotkey("^!.", (*) => SendText("…")) ; Ellipsis
    Hotkey("^!8", (*) => SendText("•")) ; Bullet

    MsgBox(
        "Typing Speed Booster`n`n"
        "Dates:`n"
        "  Ctrl+Alt+D → ISO date`n"
        "  Ctrl+Alt+Shift+D → US date`n`n"
        "Time:`n"
        "  Ctrl+Alt+T → 24h time`n"
        "  Ctrl+Alt+Shift+T → 12h time`n`n"
        "Templates & Phrases:`n"
        "  Ctrl+Alt+E1/E2 → Email templates`n"
        "  Ctrl+Alt+1/2/3 → Common phrases`n`n"
        "Symbols:`n"
        "  Ctrl+Alt+- → Em dash (—)`n"
        "  Ctrl+Alt+. → Ellipsis (…)`n"
        "  Ctrl+Alt+8 → Bullet (•)",
        "Example 7"
    )
}

; ============================================================================
; Main Execution
; ============================================================================

ShowExampleMenu() {
    menu := "
    (
    Practical Hotkey Systems
    =========================

    1. Window Management
    2. Clipboard Manager
    3. Text Manipulation
    4. Application Launcher
    5. Multi-Monitor Tools
    6. Quick Note System
    7. Typing Speed Booster

    Press Ctrl+F[1-7] to run
    )"

    MsgBox(menu, "Practical Systems")
}

Hotkey("^F1", (*) => Example1_WindowManagement())
Hotkey("^F2", (*) => Example2_ClipboardManager())
Hotkey("^F3", (*) => Example3_TextManipulation())
Hotkey("^F4", (*) => Example4_LauncherSystem())
Hotkey("^F5", (*) => Example5_MultiMonitor())
Hotkey("^F6", (*) => Example6_QuickNotes())
Hotkey("^F7", (*) => Example7_TypingBooster())

ShowExampleMenu()
