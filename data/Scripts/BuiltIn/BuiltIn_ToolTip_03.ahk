#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * ToolTip Practical Applications - Part 3
 * ============================================================================
 * 
 * Practical ToolTip applications for real-world scenarios in AutoHotkey v2.
 * 
 * @description This file covers practical ToolTip uses including:
 *              - Mouse coordinate trackers
 *              - Clipboard monitors
 *              - Keystroke displays
 *              - Timer and reminder systems
 *              - Form validation feedback
 *              - Application launchers
 * 
 * @author AutoHotkey Foundation
 * @version 2.0
 * @see https://www.autohotkey.com/docs/v2/lib/ToolTip.htm
 * 
 * ============================================================================
 */

; ============================================================================
; EXAMPLE 1: Mouse Coordinate Tracker
; ============================================================================
/**
 * Tracks and displays mouse coordinates in real-time.
 * 
 * @description Useful for GUI design and positioning elements.
 */
Example1_MouseTracker() {
    MsgBox "Mouse coordinate tracker active for 10 seconds.`nMove your mouse around!"

    startTime := A_TickCount

    Loop {
        MouseGetPos &x, &y, &winID, &control

        try winTitle := WinGetTitle(winID)
        catch
            winTitle := "N/A"

        ToolTip Format("═══ Mouse Tracker ═══`n`n"
            . "Position: X={1}, Y={2}`n"
            . "Screen: {3}x{4}`n`n"
            . "Window: {5}`n"
            . "Control: {6}",
            x, y,
            A_ScreenWidth, A_ScreenHeight,
            SubStr(winTitle, 1, 30),
            control ? control : "None"),
            x + 20, y + 20

        Sleep 50

        if ((A_TickCount - startTime) > 10000)
            break
    }
    ToolTip

    ; Screen quadrant indicator
    MsgBox "Move mouse to see which screen quadrant you're in (5 seconds)"

    startTime := A_TickCount
    Loop {
        MouseGetPos &x, &y
        quadrant := GetQuadrant(x, y)

        ToolTip Format("Screen Quadrant: {1}`n`nX: {2}`nY: {3}",
            quadrant, x, y),
            x + 20, y + 20

        Sleep 100

        if ((A_TickCount - startTime) > 5000)
            break
    }
    ToolTip

    ; Distance tracker
    MsgBox "Click to set origin, then move mouse to see distance"
    KeyWait "LButton", "D"
    MouseGetPos &originX, &originY

    Loop 50 {
        MouseGetPos &x, &y
        distance := Round(Sqrt((x - originX) ** 2 + (y - originY) ** 2))
        angle := Round(ATan((y - originY) / (x - originX)) * 180 / 3.14159)

        ToolTip Format("Origin: ({1}, {2})`n"
            . "Current: ({3}, {4})`n`n"
            . "Distance: {5} pixels`n"
            . "Angle: {6}°",
            originX, originY, x, y, distance, angle),
            x + 20, y + 20

        Sleep 100
    }
    ToolTip
}

/**
 * Determines screen quadrant.
 */
GetQuadrant(x, y) {
    midX := A_ScreenWidth // 2
    midY := A_ScreenHeight // 2

    if (x < midX && y < midY)
        return "Top-Left"
    else if (x >= midX && y < midY)
        return "Top-Right"
    else if (x < midX && y >= midY)
        return "Bottom-Left"
    else
        return "Bottom-Right"
}

; ============================================================================
; EXAMPLE 2: Clipboard Monitor
; ============================================================================
/**
 * Monitors clipboard and shows content in tooltip.
 * 
 * @description Displays clipboard content and statistics.
 */
Example2_ClipboardMonitor() {
    ; Show current clipboard
    if (A_Clipboard != "") {
        content := SubStr(A_Clipboard, 1, 200)
        if (StrLen(A_Clipboard) > 200)
            content .= "..."

        ToolTip Format("═══ Clipboard ═══`n`n{1}`n`n"
            . "Length: {2} characters",
            content,
            StrLen(A_Clipboard))
        Sleep 3000
        ToolTip
    }

    ; Clipboard stats
    ShowClipboardStats()

    ; Clipboard history simulation
    history := []

    Loop 5 {
        text := "Clipboard item " . A_Index
        history.Push(text)

        historyText := "═══ Clipboard History ═══`n`n"
        for index, item in history {
            historyText .= index . ". " . item . "`n"
        }

        ToolTip historyText
        Sleep 1000
    }
    ToolTip

    ; Clipboard type detector
    DetectClipboardType()
}

/**
 * Shows clipboard statistics.
 */
ShowClipboardStats() {
    if (A_Clipboard = "") {
        ToolTip "Clipboard is empty"
        Sleep 2000
        ToolTip
        return
    }

    text := A_Clipboard
    chars := StrLen(text)
    lines := 0
    words := 0

    Loop Parse text, "`n", "`r" {
        lines++
    }

    wordArray := StrSplit(text, [" ", "`n", "`r", "`t"])
    for word in wordArray {
        if (Trim(word) != "")
            words++
    }

    ToolTip Format("═══ Clipboard Stats ═══`n`n"
        . "Characters: {1}`n"
        . "Words: {2}`n"
        . "Lines: {3}",
        chars, words, lines)
    Sleep 3000
    ToolTip
}

/**
 * Detects clipboard content type.
 */
DetectClipboardType() {
    if (A_Clipboard = "") {
        type := "Empty"
        detail := "No content"
    } else if (RegExMatch(A_Clipboard, "^https?://")) {
        type := "URL"
        detail := A_Clipboard
    } else if (RegExMatch(A_Clipboard, "^[\d.]+$")) {
        type := "Number"
        detail := "Value: " . A_Clipboard
    } else if (RegExMatch(A_Clipboard, "^[a-zA-Z]:\\")) {
        type := "File Path"
        detail := A_Clipboard
    } else {
        type := "Text"
        detail := SubStr(A_Clipboard, 1, 50) . "..."
    }

    ToolTip Format("═══ Clipboard Type ═══`n`n"
        . "Type: {1}`n`n{2}",
        type, detail)
    Sleep 3000
    ToolTip
}

; ============================================================================
; EXAMPLE 3: Keystroke Display
; ============================================================================
/**
 * Displays pressed keys in real-time.
 * 
 * @description Useful for tutorials and presentations.
 */
Example3_KeystrokeDisplay() {
    global keyBuffer := ""

    MsgBox "Type some keys! (Shown for 10 seconds)"

    ; In real implementation, you'd set up hotkeys to capture keys
    ; This is a simulation
    keySequence := ["H", "e", "l", "l", "o", " ", "W", "o", "r", "l", "d"]

    for key in keySequence {
        keyBuffer .= key
        if (StrLen(keyBuffer) > 50)
            keyBuffer := SubStr(keyBuffer, -49)

        ToolTip Format("═══ Keystrokes ═══`n`n{1}_", keyBuffer),
            A_ScreenWidth - 300, 50

        Sleep 300
    }

    Sleep 2000
    ToolTip

    ; Modifier key indicator
    ShowModifierKeys(5)

    ; Key combo display
    ShowKeyCombo()
}

/**
 * Shows active modifier keys.
 */
ShowModifierKeys(duration) {
    startTime := A_TickCount

    Loop {
        modifiers := []

        if GetKeyState("Ctrl", "P")
            modifiers.Push("Ctrl")
        if GetKeyState("Alt", "P")
            modifiers.Push("Alt")
        if GetKeyState("Shift", "P")
            modifiers.Push("Shift")
        if GetKeyState("LWin", "P") || GetKeyState("RWin", "P")
            modifiers.Push("Win")

        if (modifiers.Length > 0) {
            modText := ""
            for mod in modifiers {
                modText .= mod . " + "
            }
            modText := SubStr(modText, 1, -3)  ; Remove last " + "
        } else {
            modText := "No modifiers pressed"
        }

        ToolTip Format("═══ Modifier Keys ═══`n`n{1}`n`n"
            . "Press Ctrl, Alt, Shift, or Win",
            modText),
            A_ScreenWidth // 2 - 150, 100

        Sleep 50

        if ((A_TickCount - startTime) > (duration * 1000))
            break
    }
    ToolTip
}

/**
 * Shows key combination.
 */
ShowKeyCombo() {
    combos := [
        "Ctrl + C",
        "Ctrl + V",
        "Alt + Tab",
        "Ctrl + Shift + Esc"
    ]

    for combo in combos {
        ToolTip Format("═══ Key Combo ═══`n`n{1}", combo),
            A_ScreenWidth // 2 - 100, 100
        Sleep 1500
    }
    ToolTip
}

; ============================================================================
; EXAMPLE 4: Timer and Reminder System
; ============================================================================
/**
 * Creates timer and reminder tooltips.
 * 
 * @description Countdown timers and periodic reminders.
 */
Example4_TimerReminders() {
    ; Countdown timer
    CountdownTimer(10, "Break time!")

    ; Pomodoro timer simulation
    PomodoroTimer(25)

    ; Interval reminders
    IntervalReminders(3, 5)

    ; Stopwatch
    Stopwatch(5)
}

/**
 * Countdown timer.
 */
CountdownTimer(seconds, message := "") {
    Loop seconds {
        remaining := seconds - A_Index + 1
        mins := remaining // 60
        secs := Mod(remaining, 60)

        ToolTip Format("⏱️ Countdown Timer`n`n{1:02}:{2:02}",
            mins, secs),
            A_ScreenWidth - 200, 50

        Sleep 1000
    }

    if (message != "") {
        ToolTip "⏰ " . message, A_ScreenWidth - 200, 50
        Sleep 2000
    }

    ToolTip
}

/**
 * Pomodoro timer.
 */
PomodoroTimer(minutes) {
    MsgBox Format("Starting {1}-minute Pomodoro session", minutes)

    totalSeconds := minutes * 60
    Loop totalSeconds {
        remaining := totalSeconds - A_Index + 1
        mins := remaining // 60
        secs := Mod(remaining, 60)
        percent := ((totalSeconds - remaining) / totalSeconds) * 100

        bar := CreateProgressBar(percent, 20)

        ToolTip Format("🍅 Pomodoro`n`n{1:02}:{2:02}`n{3}`n`n"
            . "Stay focused!",
            mins, secs, bar),
            A_ScreenWidth - 250, 50

        Sleep 1000
    }

    ToolTip "✓ Pomodoro Complete!`n`nTime for a break!", A_ScreenWidth - 250, 50
    Sleep 3000
    ToolTip
}

/**
 * Creates progress bar.
 */
CreateProgressBar(percent, width := 20) {
    filled := Round((percent / 100) * width)
    bar := ""

    Loop width {
        bar .= (A_Index <= filled) ? "█" : "░"
    }

    return bar
}

/**
 * Interval reminders.
 */
IntervalReminders(intervals, intervalSeconds) {
    Loop intervals {
        ToolTip Format("⏰ Reminder #{1}`n`n"
            . "Don't forget to save your work!",
            A_Index),
            A_ScreenWidth - 300, 50
        Sleep 2000
        ToolTip
        Sleep intervalSeconds * 1000
    }
}

/**
 * Stopwatch.
 */
Stopwatch(duration) {
    MsgBox Format("Stopwatch running for {1} seconds", duration)

    startTime := A_TickCount

    Loop {
        elapsed := A_TickCount - startTime
        ms := Mod(elapsed, 1000)
        totalSecs := elapsed // 1000
        secs := Mod(totalSecs, 60)
        mins := totalSecs // 60

        ToolTip Format("⏱️ Stopwatch`n`n{1:02}:{2:02}.{3:03}",
            mins, secs, ms),
            A_ScreenWidth - 200, 50

        Sleep 50

        if (elapsed > (duration * 1000))
            break
    }
    ToolTip
}

; ============================================================================
; EXAMPLE 5: Form Validation Feedback
; ============================================================================
/**
 * Provides real-time validation feedback.
 * 
 * @description Shows validation status as user types.
 */
Example5_FormValidation() {
    ; Email validation feedback
    ValidateEmail()

    ; Password strength indicator
    ValidatePassword()

    ; Form completion progress
    ShowFormProgress()
}

/**
 * Validates email with feedback.
 */
ValidateEmail() {
    testEmails := [
        "user",
        "user@",
        "user@domain",
        "user@domain.",
        "user@domain.com"
    ]

    for email in testEmails {
        isValid := RegExMatch(email, "^[\w\.-]+@[\w\.-]+\.\w{2,}$")
        icon := isValid ? "✓" : "❌"
        status := isValid ? "Valid" : "Invalid"
        color := isValid ? "green" : "red"

        feedback := ""
        if (!InStr(email, "@"))
            feedback := "Missing @ symbol"
        else if (!RegExMatch(email, "\.\w+$"))
            feedback := "Missing domain extension"

        ToolTip Format("{1} Email: {2}`n`nStatus: {3}`n{4}",
            icon, email, status, feedback),
            A_ScreenWidth - 300, 100

        Sleep 1500
    }
    ToolTip
}

/**
 * Validates password strength.
 */
ValidatePassword() {
    testPasswords := [
        "weak",
        "Medium1",
        "Str0ng!Pass"
    ]

    for pwd in testPasswords {
        strength := CalculateStrength(pwd)
        color := (strength >= 80) ? "green" : (strength >= 50) ? "yellow" : "red"
        label := (strength >= 80) ? "Strong" : (strength >= 50) ? "Medium" : "Weak"

        bar := CreateProgressBar(strength, 20)

        requirements := ""
        requirements .= (StrLen(pwd) >= 8) ? "✓" : "❌"
        requirements .= " Length (8+)`n"
        requirements .= RegExMatch(pwd, "[A-Z]") ? "✓" : "❌"
        requirements .= " Uppercase`n"
        requirements .= RegExMatch(pwd, "[a-z]") ? "✓" : "❌"
        requirements .= " Lowercase`n"
        requirements .= RegExMatch(pwd, "\d") ? "✓" : "❌"
        requirements .= " Number`n"
        requirements .= RegExMatch(pwd, "[!@#$%^&*]") ? "✓" : "❌"
        requirements .= " Special char"

        ToolTip Format("Password Strength: {1}`n`n"
            . "{2} {3}%`n`n"
            . "{4}",
            label, bar, strength, requirements),
            A_ScreenWidth - 300, 100

        Sleep 2000
    }
    ToolTip
}

/**
 * Calculates password strength.
 */
CalculateStrength(password) {
    score := 0

    if (StrLen(password) >= 8)
        score += 20
    if (StrLen(password) >= 12)
        score += 20
    if (RegExMatch(password, "[A-Z]"))
        score += 20
    if (RegExMatch(password, "[a-z]"))
        score += 20
    if (RegExMatch(password, "\d"))
        score += 10
    if (RegExMatch(password, "[!@#$%^&*]"))
        score += 10

    return score
}

/**
 * Shows form completion progress.
 */
ShowFormProgress() {
    fields := [{
        name: "Name", filled: false }, {
            name: "Email", filled: false }, {
                name: "Phone", filled: false }, {
                    name: "Address", filled: false
                }
    ]

    Loop fields.Length {
        fields[A_Index].filled := true

        completed := 0
        for field in fields {
            if (field.filled)
                completed++
        }

        percent := (completed / fields.Length) * 100
        bar := CreateProgressBar(percent, 20)

        status := ""
        for field in fields {
            icon := field.filled ? "✓" : "○"
            status .= icon . " " . field.name . "`n"
        }

        ToolTip Format("Form Progress: {1}%`n`n{2}`n{3}",
            Round(percent), bar, status),
            A_ScreenWidth - 300, 100

        Sleep 1500
    }
    ToolTip
}

; ============================================================================
; EXAMPLE 6: Application Status Bar
; ============================================================================
/**
 * Creates status bar using tooltips.
 * 
 * @description Shows application state and statistics.
 */
Example6_ApplicationStatus() {
    ; Status bar
    ShowStatusBar(5)

    ; Activity log
    ShowActivityLog()

    ; Connection status
    ShowConnectionStatus()
}

/**
 * Shows application status bar.
 */
ShowStatusBar(duration) {
    startTime := A_TickCount

    Loop {
        status := (Mod(A_Index, 2) = 0) ? "Ready" : "Busy"
        items := Random(10, 50)
        modified := (Mod(A_Index, 3) = 0)

        statusText := Format("Status: {1} │ Items: {2} │ Modified: {3} │ Time: {4}",
            status,
            items,
            modified ? "Yes" : "No",
            FormatTime(, "HH:mm:ss"))

        ToolTip statusText, 10, A_ScreenHeight - 50

        Sleep 500

        if ((A_TickCount - startTime) > (duration * 1000))
            break
    }
    ToolTip
}

/**
 * Shows activity log.
 */
ShowActivityLog() {
    activities := [
        "File opened: document.txt",
        "Changes saved",
        "Export completed",
        "Settings updated",
        "Connection established"
    ]

    log := "═══ Activity Log ═══`n`n"

    for index, activity in activities {
        log .= FormatTime(, "HH:mm:ss") . " - " . activity
        if (index < activities.Length)
            log .= "`n"

        ToolTip log, 10, A_ScreenHeight - 200
        Sleep 1000
    }

    Sleep 2000
    ToolTip
}

/**
 * Shows connection status.
 */
ShowConnectionStatus() {
    states := ["Disconnected", "Connecting", "Connected", "Synchronizing", "Connected"]

    for state in states {
        icon := (state = "Connected") ? "✓" : (state = "Connecting" || state = "Synchronizing") ? "⟳" : "❌"

        ToolTip Format("{1} Status: {2}", icon, state),
            A_ScreenWidth - 250, 50

        Sleep 1000
    }
    ToolTip
}

; ============================================================================
; EXAMPLE 7: Quick Reference and Help
; ============================================================================
/**
 * Shows quick reference information.
 * 
 * @description Displays helpful reference data.
 */
Example7_QuickReference() {
    ; Keyboard shortcuts
    ShowShortcutReference()

    ; Color codes
    ShowColorReference()

    ; Formula reference
    ShowFormulaReference()

    ; Character map
    ShowCharacterMap()
}

/**
 * Shows keyboard shortcuts.
 */
ShowShortcutReference() {
    shortcuts := "╔════════════════════════╗`n"
        . "║  Keyboard Shortcuts    ║`n"
        . "╠════════════════════════╣`n"
        . "║ Ctrl+C    Copy         ║`n"
        . "║ Ctrl+V    Paste        ║`n"
        . "║ Ctrl+Z    Undo         ║`n"
        . "║ Ctrl+Y    Redo         ║`n"
        . "║ Ctrl+F    Find         ║`n"
        . "║ Ctrl+S    Save         ║`n"
        . "╚════════════════════════╝"

    ToolTip shortcuts, A_ScreenWidth - 300, 50
    Sleep 3000
    ToolTip
}

/**
 * Shows color codes.
 */
ShowColorReference() {
    colors := "╔══════════════════════╗`n"
        . "║  Common Color Codes  ║`n"
        . "╠══════════════════════╣`n"
        . "║ Red:    #FF0000      ║`n"
        . "║ Green:  #00FF00      ║`n"
        . "║ Blue:   #0000FF      ║`n"
        . "║ Yellow: #FFFF00      ║`n"
        . "║ White:  #FFFFFF      ║`n"
        . "║ Black:  #000000      ║`n"
        . "╚══════════════════════╝"

    ToolTip colors, A_ScreenWidth - 300, 50
    Sleep 3000
    ToolTip
}

/**
 * Shows formula reference.
 */
ShowFormulaReference() {
    formulas := "╔═══════════════════════════╗`n"
        . "║  Math Formulas            ║`n"
        . "╠═══════════════════════════╣`n"
        . "║ Area = π × r²             ║`n"
        . "║ Volume = l × w × h        ║`n"
        . "║ Distance = √(x² + y²)     ║`n"
        . "║ Average = Sum / Count     ║`n"
        . "╚═══════════════════════════╝"

    ToolTip formulas, A_ScreenWidth - 350, 50
    Sleep 3000
    ToolTip
}

/**
 * Shows special characters.
 */
ShowCharacterMap() {
    chars := "╔════════════════════════╗`n"
        . "║  Special Characters    ║`n"
        . "╠════════════════════════╣`n"
        . "║ © ® ™ § ¶ † ‡          ║`n"
        . "║ • ○ ◘ ◙ ◊ ◦             ║`n"
        . "║ ← → ↑ ↓ ↔ ↕             ║`n"
        . "║ ≈ ≠ ≤ ≥ ± ∞             ║`n"
        . "║ α β γ δ ε θ             ║`n"
        . "╚════════════════════════╝"

    ToolTip chars, A_ScreenWidth - 300, 50
    Sleep 3000
    ToolTip
}

; ============================================================================
; Hotkey Triggers
; ============================================================================

^1:: Example1_MouseTracker()
^2:: Example2_ClipboardMonitor()
^3:: Example3_KeystrokeDisplay()
^4:: Example4_TimerReminders()
^5:: Example5_FormValidation()
^6:: Example6_ApplicationStatus()
^7:: Example7_QuickReference()
^0:: ExitApp

/**
 * ============================================================================
 * SUMMARY
 * ============================================================================
 * 
 * Practical ToolTip applications:
 * 1. Mouse coordinate tracking and positioning
 * 2. Clipboard monitoring and statistics
 * 3. Keystroke display and key combo indication
 * 4. Timer systems (countdown, Pomodoro, stopwatch)
 * 5. Form validation feedback
 * 6. Application status bars and activity logs
 * 7. Quick reference displays (shortcuts, colors, formulas)
 * 
 * ============================================================================
 */

