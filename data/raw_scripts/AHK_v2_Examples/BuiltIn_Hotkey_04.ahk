#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Hotkey() Function - Context-Sensitive Hotkeys
 * ============================================================================
 *
 * This file demonstrates creating context-sensitive hotkeys that behave
 * differently based on active window, cursor position, system state, and
 * other contextual factors using HotIf and the Hotkey() function.
 *
 * Features demonstrated:
 * - Window-specific hotkeys
 * - Application-specific hotkeys
 * - Position-based hotkeys
 * - State-based hotkeys
 * - Multi-context hotkey systems
 *
 * @author AutoHotkey v2 Documentation Team
 * @version 1.0.0
 * @see https://www.autohotkey.com/docs/v2/lib/Hotkey.htm
 * @see https://www.autohotkey.com/docs/v2/lib/HotIf.htm
 */

; ============================================================================
; Example 1: Basic Window-Specific Hotkeys
; ============================================================================

/**
 * Demonstrates creating hotkeys that only work in specific windows.
 *
 * @example
 * ; Same hotkey, different behavior in different applications
 */
Example1_WindowSpecific() {
    ; Hotkey for Notepad
    HotIf(() => WinActive("ahk_exe notepad.exe"))
    Hotkey("^q", (*) => MsgBox("Ctrl+Q in Notepad!", "Notepad"))

    ; Hotkey for any browser (example)
    HotIf(() => WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe firefox.exe"))
    Hotkey("^q", (*) => MsgBox("Ctrl+Q in Browser!", "Browser"))

    ; Default hotkey (no specific window)
    HotIf()
    Hotkey("^q", (*) => MsgBox("Ctrl+Q in other window!", "Default"))

    ; Create more window-specific examples
    HotIf(() => WinActive("ahk_exe notepad.exe"))
    Hotkey("^!t", (*) => SendText("Timestamp: " . FormatTime()))

    HotIf(() => WinActive("ahk_class CabinetWClass")) ; File Explorer
    Hotkey("^!n", (*) => Send("^+n")) ; New folder

    HotIf() ; Reset context

    MsgBox(
        "Window-Specific Hotkeys Created`n`n"
        "Ctrl+Q - Different behavior in:`n"
        "  • Notepad`n"
        "  • Browser`n"
        "  • Other windows`n`n"
        "Ctrl+Alt+T - Insert timestamp (Notepad only)`n"
        "Ctrl+Alt+N - New folder (Explorer only)`n`n"
        "Try in different windows!",
        "Example 1"
    )
}

; ============================================================================
; Example 2: Title-Based Context Hotkeys
; ============================================================================

/**
 * Creates hotkeys that activate based on window titles or partial matches.
 *
 * @example
 * ; Hotkeys for specific document types or project names
 */
Example2_TitleBased() {
    ; Hotkey for windows with "Report" in title
    HotIf(() => WinActive("Report"))
    Hotkey("^!h", (*) => SendText("REPORT HEADER`n" . Repeat("=", 40) . "`n"))

    ; Hotkey for windows with "Email" in title
    HotIf(() => WinActive("Email") || WinActive("Message"))
    Hotkey("^!s", (*) => SendText("Best regards,`n" . A_UserName))

    ; Hotkey for code files
    HotIf(() => WinActive(".ahk") || WinActive(".py") || WinActive(".js"))
    Hotkey("^!c", (*) => SendText("// TODO: "))

    ; Reset context
    HotIf()

    Repeat(char, count) {
        result := ""
        Loop count
            result .= char
        return result
    }

    ; Demo info hotkey
    Hotkey("^!i", (*) {
        title := WinGetTitle("A")
        MsgBox(
            "Active Window Title:`n" . title . "`n`n"
            "Context hotkeys available:`n"
            "• Contains 'Report': Ctrl+Alt+H`n"
            "• Contains 'Email': Ctrl+Alt+S`n"
            "• Contains code ext: Ctrl+Alt+C",
            "Title Info"
        )
    })

    MsgBox(
        "Title-Based Context Hotkeys`n`n"
        "Ctrl+Alt+H - Report header (if 'Report' in title)`n"
        "Ctrl+Alt+S - Email signature (if 'Email' in title)`n"
        "Ctrl+Alt+C - TODO comment (if code file in title)`n"
        "Ctrl+Alt+I - Show current window title`n`n"
        "Open different windows and test!",
        "Example 2"
    )
}

; ============================================================================
; Example 3: Mouse Position-Based Hotkeys
; ============================================================================

/**
 * Implements hotkeys that behave differently based on mouse position
 * on the screen.
 *
 * @example
 * ; Different actions based on screen region
 */
Example3_MousePositionBased() {
    ; Get screen dimensions
    screenWidth := A_ScreenWidth
    screenHeight := A_ScreenHeight

    /**
     * Checks if mouse is in left half of screen
     */
    IsMouseLeft() {
        MouseGetPos(&x, &y)
        return x < (A_ScreenWidth / 2)
    }

    /**
     * Checks if mouse is in top half of screen
     */
    IsMouseTop() {
        MouseGetPos(&x, &y)
        return y < (A_ScreenHeight / 2)
    }

    /**
     * Checks if mouse is in center region
     */
    IsMouseCenter() {
        MouseGetPos(&x, &y)
        centerX := A_ScreenWidth / 2
        centerY := A_ScreenHeight / 2
        marginX := A_ScreenWidth / 4
        marginY := A_ScreenHeight / 4

        return (Abs(x - centerX) < marginX) && (Abs(y - centerY) < marginY)
    }

    ; Left side hotkey
    HotIf(IsMouseLeft)
    Hotkey("^Space", (*) => MsgBox("Action from LEFT side!", "Left"))

    ; Right side hotkey
    HotIf(() => !IsMouseLeft())
    Hotkey("^Space", (*) => MsgBox("Action from RIGHT side!", "Right"))

    ; Center region hotkey
    HotIf(IsMouseCenter)
    Hotkey("^!Space", (*) => MsgBox("Action from CENTER!", "Center"))

    ; Reset context
    HotIf()

    ; Position info hotkey
    Hotkey("^!p", (*) {
        MouseGetPos(&x, &y)
        region := ""
        region .= IsMouseLeft() ? "Left" : "Right"
        region .= ", "
        region .= IsMouseTop() ? "Top" : "Bottom"
        region .= IsMouseCenter() ? " (Center)" : ""

        MsgBox(
            "Mouse Position: " x ", " y "`n"
            "Screen Region: " region "`n`n"
            "Ctrl+Space has different behavior based on left/right`n"
            "Ctrl+Alt+Space works in center region",
            "Position Info"
        )
    })

    MsgBox(
        "Mouse Position-Based Hotkeys`n`n"
        "Ctrl+Space - Different action based on:`n"
        "  • LEFT half of screen`n"
        "  • RIGHT half of screen`n`n"
        "Ctrl+Alt+Space - Special action (center only)`n"
        "Ctrl+Alt+P - Show current position/region`n`n"
        "Move mouse and test!",
        "Example 3"
    )
}

; ============================================================================
; Example 4: State-Based Context System
; ============================================================================

/**
 * Creates a mode system where hotkeys change based on application state.
 *
 * @example
 * ; Insert mode vs Command mode (like Vim)
 */
Example4_StateBased() {
    static appMode := "normal"

    ; Check if in insert mode
    IsInsertMode() => appMode = "insert"

    ; Check if in normal mode
    IsNormalMode() => appMode = "normal"

    ; Check if in command mode
    IsCommandMode() => appMode = "command"

    ; Switch to insert mode
    Hotkey("^i", (*) {
        global appMode := "insert"
        ToolTip("-- INSERT MODE --", A_ScreenWidth - 200, A_ScreenHeight - 50)
        SetTimer(() => ToolTip(), -2000)
    })

    ; Switch to normal mode (ESC from any mode)
    Hotkey("Esc", (*) {
        global appMode := "normal"
        ToolTip("-- NORMAL MODE --", A_ScreenWidth - 200, A_ScreenHeight - 50)
        SetTimer(() => ToolTip(), -2000)
    })

    ; Switch to command mode
    Hotkey("^;", (*) {
        global appMode := "command"
        ToolTip("-- COMMAND MODE --", A_ScreenWidth - 200, A_ScreenHeight - 50)
        SetTimer(() => ToolTip(), -2000)
    })

    ; Insert mode hotkeys
    HotIf(IsInsertMode)
    Hotkey("^s", (*) => SendText("Saved in insert mode"))
    Hotkey("^d", (*) => SendText("Deleted in insert mode"))

    ; Normal mode hotkeys
    HotIf(IsNormalMode)
    Hotkey("^s", (*) => MsgBox("Save in normal mode", "Normal"))
    Hotkey("^d", (*) => MsgBox("Delete in normal mode", "Normal"))

    ; Command mode hotkeys
    HotIf(IsCommandMode)
    Hotkey("^s", (*) => MsgBox("Execute save command", "Command"))
    Hotkey("^d", (*) => MsgBox("Execute delete command", "Command"))

    ; Reset context
    HotIf()

    ; Status hotkey (works in all modes)
    Hotkey("^!?", (*) {
        MsgBox(
            "Current Mode: " StrUpper(appMode) . "`n`n"
            "Mode Controls:`n"
            "Ctrl+I - Insert mode`n"
            "Ctrl+; - Command mode`n"
            "ESC - Normal mode`n`n"
            "Ctrl+S and Ctrl+D behave differently in each mode",
            "Status"
        )
    })

    MsgBox(
        "State-Based Context System`n`n"
        "Modes:`n"
        "• NORMAL (default)`n"
        "• INSERT (Ctrl+I)`n"
        "• COMMAND (Ctrl+;)`n"
        "• ESC returns to NORMAL`n`n"
        "Ctrl+S and Ctrl+D work differently in each mode`n"
        "Ctrl+Alt+? - Show current mode",
        "Example 4"
    )
}

; ============================================================================
; Example 5: Clipboard Content-Based Hotkeys
; ============================================================================

/**
 * Hotkeys that behave differently based on clipboard contents.
 *
 * @example
 * ; Different paste operations based on what's in clipboard
 */
Example5_ClipboardBased() {
    /**
     * Checks if clipboard contains a URL
     */
    IsClipboardURL() {
        content := A_Clipboard
        return RegExMatch(content, "i)^https?://")
    }

    /**
     * Checks if clipboard contains a number
     */
    IsClipboardNumber() {
        content := A_Clipboard
        return IsNumber(content)
    }

    /**
     * Checks if clipboard contains an email
     */
    IsClipboardEmail() {
        content := A_Clipboard
        return RegExMatch(content, "i)^[\w.+-]+@[\w.-]+\.\w+$")
    }

    ; URL paste
    HotIf(IsClipboardURL)
    Hotkey("^!v", (*) => SendText("<a href='" . A_Clipboard . "'>Link</a>"))

    ; Number paste
    HotIf(IsClipboardNumber)
    Hotkey("^!v", (*) => SendText("Number: " . A_Clipboard))

    ; Email paste
    HotIf(IsClipboardEmail)
    Hotkey("^!v", (*) => SendText("<" . A_Clipboard . ">"))

    ; Default paste
    HotIf()
    Hotkey("^!v", (*) => SendText(A_Clipboard))

    ; Clipboard info
    Hotkey("^!c", (*) {
        content := A_Clipboard
        type := "Unknown"

        if IsClipboardURL()
            type := "URL"
        else if IsClipboardNumber()
            type := "Number"
        else if IsClipboardEmail()
            type := "Email"
        else
            type := "Text"

        MsgBox(
            "Clipboard Type: " type "`n`n"
            "Content: " SubStr(content, 1, 50) .
            (StrLen(content) > 50 ? "..." : "") . "`n`n"
            "Ctrl+Alt+V will paste with format for: " type,
            "Clipboard Info"
        )
    })

    MsgBox(
        "Clipboard Content-Based Hotkeys`n`n"
        "Ctrl+Alt+V pastes differently based on clipboard:`n"
        "• URL → HTML link`n"
        "• Number → Formatted number`n"
        "• Email → Email format`n"
        "• Text → Plain text`n`n"
        "Ctrl+Alt+C - Show clipboard type`n`n"
        "Copy different content types and test!",
        "Example 5"
    )
}

; ============================================================================
; Example 6: Time-Based Context Hotkeys
; ============================================================================

/**
 * Hotkeys that behave differently based on time of day or day of week.
 *
 * @example
 * ; Work hours vs personal time hotkeys
 */
Example6_TimeBased() {
    /**
     * Checks if current time is work hours (9 AM - 5 PM, Mon-Fri)
     */
    IsWorkHours() {
        hour := A_Hour + 0
        day := A_WDay

        ; Monday = 2, Friday = 6
        isWeekday := (day >= 2 && day <= 6)
        isDuringWork := (hour >= 9 && hour < 17)

        return isWeekday && isDuringWork
    }

    /**
     * Checks if it's weekend
     */
    IsWeekend() {
        day := A_WDay
        return (day = 1 || day = 7) ; Sunday = 1, Saturday = 7
    }

    ; Work hours hotkeys
    HotIf(IsWorkHours)
    Hotkey("^!g", (*) => SendText("Good morning,`n"))
    Hotkey("^!m", (*) => SendText("Meeting at: " . FormatTime(, "h:mm tt")))

    ; Weekend hotkeys
    HotIf(IsWeekend)
    Hotkey("^!g", (*) => SendText("Happy weekend!`n"))
    Hotkey("^!m", (*) => SendText("Enjoying the weekend at " . FormatTime(, "h:mm tt")))

    ; After hours (weekday, not work hours)
    HotIf(() => !IsWorkHours() && !IsWeekend())
    Hotkey("^!g", (*) => SendText("Good evening,`n"))
    Hotkey("^!m", (*) => SendText("After hours: " . FormatTime(, "h:mm tt")))

    ; Reset context
    HotIf()

    ; Time info hotkey
    Hotkey("^!t", (*) {
        hour := A_Hour + 0
        day := FormatTime(, "dddd")
        context := ""

        if IsWorkHours()
            context := "WORK HOURS"
        else if IsWeekend()
            context := "WEEKEND"
        else
            context := "AFTER HOURS"

        MsgBox(
            "Current Context: " context "`n`n"
            "Day: " day "`n"
            "Time: " FormatTime(, "h:mm tt") "`n`n"
            "Ctrl+Alt+G and Ctrl+Alt+M adapt to time context",
            "Time Context"
        )
    })

    MsgBox(
        "Time-Based Context Hotkeys`n`n"
        "Hotkeys adapt to time context:`n"
        "• Work hours (Mon-Fri 9-5)`n"
        "• After hours (weekday evening)`n"
        "• Weekend`n`n"
        "Ctrl+Alt+G - Context greeting`n"
        "Ctrl+Alt+M - Context message`n"
        "Ctrl+Alt+T - Show time context",
        "Example 6"
    )
}

; ============================================================================
; Example 7: Multi-Factor Context System
; ============================================================================

/**
 * Advanced system combining multiple context factors.
 *
 * @example
 * ; Hotkeys based on window + time + clipboard + mouse position
 */
Example7_MultiFactorContext() {
    /**
     * Complex context: Notepad + URL in clipboard
     */
    IsNotepadWithURL() {
        return WinActive("ahk_exe notepad.exe") &&
               RegExMatch(A_Clipboard, "i)^https?://")
    }

    /**
     * Complex context: Explorer + weekend
     */
    IsExplorerWeekend() {
        day := A_WDay
        return WinActive("ahk_class CabinetWClass") &&
               (day = 1 || day = 7)
    }

    /**
     * Complex context: Mouse on right + work hours
     */
    IsRightWorkHours() {
        MouseGetPos(&x, &y)
        hour := A_Hour + 0
        day := A_WDay

        isRight := x > (A_ScreenWidth / 2)
        isWeekday := (day >= 2 && day <= 6)
        isDuringWork := (hour >= 9 && hour < 17)

        return isRight && isWeekday && isDuringWork
    }

    ; Multi-factor hotkeys
    HotIf(IsNotepadWithURL)
    Hotkey("^!l", (*) => SendText("[Link](" . A_Clipboard . ")"))

    HotIf(IsExplorerWeekend)
    Hotkey("^!p", (*) => MsgBox("Organizing files on weekend!", "Explorer"))

    HotIf(IsRightWorkHours)
    Hotkey("^!w", (*) => MsgBox("Work action from right screen", "Work"))

    ; Reset context
    HotIf()

    ; Context analyzer
    Hotkey("^!a", (*) {
        analysis := "Context Analysis:`n" . Repeat("-", 40) . "`n`n"

        ; Window
        try analysis .= "Window: " . WinGetTitle("A") . "`n"
        catch
            analysis .= "Window: Unknown`n"

        ; Clipboard
        clipType := "Empty"
        if A_Clipboard != "" {
            if RegExMatch(A_Clipboard, "i)^https?://")
                clipType := "URL"
            else if IsNumber(A_Clipboard)
                clipType := "Number"
            else
                clipType := "Text"
        }
        analysis .= "Clipboard: " . clipType . "`n"

        ; Mouse
        MouseGetPos(&x, &y)
        side := x > (A_ScreenWidth / 2) ? "Right" : "Left"
        analysis .= "Mouse: " . side . " side`n"

        ; Time
        hour := A_Hour + 0
        day := A_WDay
        timeCtx := ""
        if (day >= 2 && day <= 6) && (hour >= 9 && hour < 17)
            timeCtx := "Work hours"
        else if (day = 1 || day = 7)
            timeCtx := "Weekend"
        else
            timeCtx := "After hours"
        analysis .= "Time: " . timeCtx . "`n`n"

        ; Active contexts
        analysis .= "Active Contexts:`n"
        if IsNotepadWithURL()
            analysis .= "✓ Notepad + URL`n"
        if IsExplorerWeekend()
            analysis .= "✓ Explorer + Weekend`n"
        if IsRightWorkHours()
            analysis .= "✓ Right + Work Hours`n"

        MsgBox(analysis, "Context Analysis")
    })

    Repeat(char, count) {
        result := ""
        Loop count
            result .= char
        return result
    }

    MsgBox(
        "Multi-Factor Context System`n`n"
        "Hotkeys activate based on combined factors:`n`n"
        "Ctrl+Alt+L - Markdown link (Notepad + URL)`n"
        "Ctrl+Alt+P - Weekend file org (Explorer + Weekend)`n"
        "Ctrl+Alt+W - Work action (Right screen + Work hours)`n`n"
        "Ctrl+Alt+A - Analyze current context",
        "Example 7"
    )
}

; ============================================================================
; Main Execution
; ============================================================================

ShowExampleMenu() {
    menu := "
    (
    Context-Sensitive Hotkey Examples
    ==================================

    Choose an example:

    1. Window-Specific Hotkeys
    2. Title-Based Context
    3. Mouse Position-Based
    4. State-Based System
    5. Clipboard Content-Based
    6. Time-Based Context
    7. Multi-Factor Context

    Press Ctrl+Shift+[1-7] to run examples
    )"

    MsgBox(menu, "Examples Menu")
}

; Create example launcher hotkeys
Hotkey("^+1", (*) => Example1_WindowSpecific())
Hotkey("^+2", (*) => Example2_TitleBased())
Hotkey("^+3", (*) => Example3_MousePositionBased())
Hotkey("^+4", (*) => Example4_StateBased())
Hotkey("^+5", (*) => Example5_ClipboardBased())
Hotkey("^+6", (*) => Example6_TimeBased())
Hotkey("^+7", (*) => Example7_MultiFactorContext())

ShowExampleMenu()
