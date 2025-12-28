/**
 * ============================================================================
 * AutoHotkey v2 #HotIf Directive - Custom Conditions
 * ============================================================================
 * 
 * @description Comprehensive examples demonstrating custom condition
 *              functions for #HotIf directive in AutoHotkey v2
 * 
 * @author AHK v2 Documentation Team
 * @version 2.0.0
 * @date 2025-01-15
 * 
 * DIRECTIVE: #HotIf with custom functions
 * PURPOSE: Create hotkeys with complex custom activation conditions
 * SYNTAX: #HotIf MyCustomFunction()
 *         #HotIf IsSpecialState() && SomeOtherCondition()
 * 
 * @reference https://www.autohotkey.com/docs/v2/lib/_HotIf.htm
 */

#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Example 1: Simple Custom Condition Functions
 * ============================================================================
 * 
 * @description Create basic custom condition functions
 * @concept Custom conditions, function-based activation
 */

; Global state variables
global CustomMode := false
global AdvancedMode := false

/**
 * Check if custom mode is active
 * @returns {Boolean} True if custom mode enabled
 */
IsCustomMode() {
    global CustomMode
    return CustomMode
}

/**
 * Check if advanced mode is active
 * @returns {Boolean} True if advanced mode enabled
 */
IsAdvancedMode() {
    global AdvancedMode
    return AdvancedMode
}

; Hotkeys active only in custom mode
#HotIf IsCustomMode()

F1:: MsgBox("F1 in Custom Mode", "Custom", "Iconi")
^c:: MsgBox("Custom Ctrl+C action", "Custom", "Iconi")
#HotIf

; Hotkeys active only in advanced mode
#HotIf IsAdvancedMode()

F1:: MsgBox("F1 in Advanced Mode", "Advanced", "Iconi")
^a:: MsgBox("Advanced Ctrl+A action", "Advanced", "Iconi")
#HotIf

; Mode toggle hotkeys (always active)
^!1:: ToggleCustomMode()
^!2:: ToggleAdvancedMode()

/**
 * Toggle custom mode
 */
ToggleCustomMode() {
    global CustomMode
    CustomMode := !CustomMode
    TrayTip("Custom Mode: " (CustomMode ? "ON" : "OFF"), "Mode", "Iconi Mute")
}

/**
 * Toggle advanced mode
 */
ToggleAdvancedMode() {
    global AdvancedMode
    AdvancedMode := !AdvancedMode
    TrayTip("Advanced Mode: " (AdvancedMode ? "ON" : "OFF"), "Mode", "Iconi Mute")
}

/**
 * ============================================================================
 * Example 2: Keyboard State Conditions
 * ============================================================================
 * 
 * @description Conditions based on keyboard state
 * @concept Keyboard state, modifier keys, toggle keys
 */

/**
 * Check if CapsLock is on
 * @returns {Boolean} True if CapsLock is toggled on
 */
IsCapsLockOn() {
    return GetKeyState("CapsLock", "T")
}

/**
 * Check if NumLock is on
 * @returns {Boolean} True if NumLock is toggled on
 */
IsNumLockOn() {
    return GetKeyState("NumLock", "T")
}

/**
 * Check if Shift is held
 * @returns {Boolean} True if either Shift key is pressed
 */
IsShiftHeld() {
    return GetKeyState("Shift", "P")
}

/**
 * Check if Ctrl is held
 * @returns {Boolean} True if either Ctrl key is pressed
 */
IsCtrlHeld() {
    return GetKeyState("Ctrl", "P")
}

; Hotkeys active when CapsLock is ON
#HotIf IsCapsLockOn()

a:: MsgBox("A pressed with CapsLock ON", "CapsLock", "Iconi")
Space:: MsgBox("Space with CapsLock ON", "CapsLock", "Iconi")
#HotIf

; Hotkeys active when NumLock is ON
#HotIf IsNumLockOn()

NumpadEnter:: MsgBox("NumpadEnter with NumLock ON", "NumLock", "Iconi")
#HotIf

/**
 * Display keyboard state
 */
^!k:: {
    state := "Keyboard State`n"
    state .= "==============`n`n"

    state .= "Toggle Keys:`n"
    state .= "  CapsLock: " (IsCapsLockOn() ? "ON" : "OFF") "`n"
    state .= "  NumLock: " (IsNumLockOn() ? "ON" : "OFF") "`n"
    state .= "  ScrollLock: " (GetKeyState("ScrollLock", "T") ? "ON" : "OFF") "`n`n"

    state .= "Modifier Keys:`n"
    state .= "  Shift: " (IsShiftHeld() ? "Held" : "Released") "`n"
    state .= "  Ctrl: " (IsCtrlHeld() ? "Held" : "Released") "`n"
    state .= "  Alt: " (GetKeyState("Alt", "P") ? "Held" : "Released") "`n"
    state .= "  Win: " (GetKeyState("LWin", "P") || GetKeyState("RWin", "P") ? "Held" : "Released")

    MsgBox(state, "Keyboard", "Iconi")
}

/**
 * ============================================================================
 * Example 3: Mouse Position and State Conditions
 * ============================================================================
 * 
 * @description Conditions based on mouse position and button state
 * @concept Mouse tracking, position-based activation, click state
 */

/**
 * Check if mouse is in specific screen region
 * @returns {Boolean} True if mouse in top-left corner
 */
IsMouseInCorner() {
    CoordMode("Mouse", "Screen")
    MouseGetPos(&x, &y)
    return (x < 100 && y < 100)
}

/**
 * Check if mouse is on left half of screen
 * @returns {Boolean} True if on left half
 */
IsMouseOnLeftHalf() {
    CoordMode("Mouse", "Screen")
    MouseGetPos(&x, &y)
    return (x < A_ScreenWidth / 2)
}

/**
 * Check if mouse is on right half of screen
 * @returns {Boolean} True if on right half
 */
IsMouseOnRightHalf() {
    CoordMode("Mouse", "Screen")
    MouseGetPos(&x, &y)
    return (x >= A_ScreenWidth / 2)
}

/**
 * Check if mouse button is held
 * @returns {Boolean} True if left mouse button held
 */
IsMouseButtonHeld() {
    return GetKeyState("LButton", "P")
}

; Hotkeys active in top-left corner
#HotIf IsMouseInCorner()

MButton:: MsgBox("Middle click in corner", "Corner", "Iconi")
#HotIf

; Different hotkeys for left vs right side
#HotIf IsMouseOnLeftHalf()

^!m:: MsgBox("Left half of screen", "Left", "Iconi")
#HotIf

#HotIf IsMouseOnRightHalf()

^!m:: MsgBox("Right half of screen", "Right", "Iconi")
#HotIf

/**
 * Display mouse information
 */
^!mouse:: {
    CoordMode("Mouse", "Screen")
    MouseGetPos(&x, &y, &win, &control)

    info := "Mouse Information`n"
    info .= "=================`n`n"

    info .= "Position (Screen):`n"
    info .= "  X: " x ", Y: " y "`n"
    info .= "  Left Half: " (IsMouseOnLeftHalf() ? "Yes" : "No") "`n"
    info .= "  In Corner: " (IsMouseInCorner() ? "Yes" : "No") "`n`n"

    info .= "Window:`n"
    if win {
        info .= "  HWND: " win "`n"
        info .= "  Title: " WinGetTitle("ahk_id " win) "`n"
        info .= "  Control: " control "`n"
    }

    info .= "`nButtons:`n"
    info .= "  Left: " (GetKeyState("LButton", "P") ? "Pressed" : "Released") "`n"
    info .= "  Right: " (GetKeyState("RButton", "P") ? "Pressed" : "Released") "`n"
    info .= "  Middle: " (GetKeyState("MButton", "P") ? "Pressed" : "Released")

    MsgBox(info, "Mouse Info", "Iconi")
}

/**
 * ============================================================================
 * Example 4: Time-Based Conditions
 * ============================================================================
 * 
 * @description Conditions based on time of day or date
 * @concept Time-based activation, temporal conditions, scheduling
 */

/**
 * Check if it's morning (6 AM - 12 PM)
 * @returns {Boolean} True if morning
 */
IsMorning() {
    hour := Integer(FormatTime(, "H"))
    return (hour >= 6 && hour < 12)
}

/**
 * Check if it's afternoon (12 PM - 6 PM)
 * @returns {Boolean} True if afternoon
 */
IsAfternoon() {
    hour := Integer(FormatTime(, "H"))
    return (hour >= 12 && hour < 18)
}

/**
 * Check if it's evening (6 PM - 12 AM)
 * @returns {Boolean} True if evening
 */
IsEvening() {
    hour := Integer(FormatTime(, "H"))
    return (hour >= 18 && hour < 24)
}

/**
 * Check if it's night (12 AM - 6 AM)
 * @returns {Boolean} True if night
 */
IsNight() {
    hour := Integer(FormatTime(, "H"))
    return (hour >= 0 && hour < 6)
}

/**
 * Check if it's a weekend
 * @returns {Boolean} True if Saturday or Sunday
 */
IsWeekend() {
    day := Integer(FormatTime(, "WDay"))  ; 1=Sunday, 7=Saturday
    return (day = 1 || day = 7)
}

; Time-based hotkeys
#HotIf IsMorning()

^!t:: MsgBox("Good morning!", "Morning", "Iconi")
#HotIf

#HotIf IsAfternoon()

^!t:: MsgBox("Good afternoon!", "Afternoon", "Iconi")
#HotIf

#HotIf IsEvening()

^!t:: MsgBox("Good evening!", "Evening", "Iconi")
#HotIf

#HotIf IsWeekend()

^!w:: MsgBox("Happy weekend!", "Weekend", "Iconi")
#HotIf

/**
 * Display time information
 */
^!t:: {
    now := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    hour := Integer(FormatTime(, "H"))
    dayName := FormatTime(, "dddd")

    info := "Time Information`n"
    info .= "================`n`n"
    info .= "Current: " now "`n"
    info .= "Day: " dayName "`n`n"

    info .= "Time Period:`n"
    if IsMorning()
        info .= "  ✓ Morning (6 AM - 12 PM)`n"
    else if IsAfternoon()
        info .= "  ✓ Afternoon (12 PM - 6 PM)`n"
    else if IsEvening()
        info .= "  ✓ Evening (6 PM - 12 AM)`n"
    else if IsNight()
        info .= "  ✓ Night (12 AM - 6 AM)`n"

    info .= "`nWeek:`n"
    info .= "  " (IsWeekend() ? "✓ Weekend" : "○ Weekday")

    MsgBox(info, "Time Info", "Iconi")
}

/**
 * ============================================================================
 * Example 5: Application State Conditions
 * ============================================================================
 * 
 * @description Conditions based on application-specific state
 * @concept Application state, context awareness, smart activation
 */

/**
 * Application state manager
 * @class
 */
class AppState {
    static Mode := "normal"
    static Project := ""
    static Tasks := []
    static Flags := Map()

    /**
     * Set application mode
     * @param {String} mode - Mode name
     */
    static SetMode(mode) {
        this.Mode := mode
        TrayTip("Mode: " mode, "App State", "Iconi Mute")
    }

    /**
     * Check if in specific mode
     * @param {String} mode - Mode to check
     * @returns {Boolean} True if in mode
     */
    static IsMode(mode) {
        return (this.Mode = mode)
    }

    /**
     * Set flag
     * @param {String} name - Flag name
     * @param {Boolean} value - Flag value
     */
    static SetFlag(name, value) {
        this.Flags[name] := value
    }

    /**
     * Get flag
     * @param {String} name - Flag name
     * @returns {Boolean} Flag value
     */
    static GetFlag(name) {
        return this.Flags.Get(name, false)
    }
}

; Mode-based hotkeys
#HotIf AppState.IsMode("edit")

^s:: MsgBox("Save in edit mode", "Edit Mode", "Iconi")
^z:: MsgBox("Undo in edit mode", "Edit Mode", "Iconi")
#HotIf

#HotIf AppState.IsMode("review")

^n:: MsgBox("Next in review mode", "Review Mode", "Iconi")
^p:: MsgBox("Previous in review mode", "Review Mode", "Iconi")
#HotIf

; Mode switching
^!+e:: AppState.SetMode("edit")
^!+r:: AppState.SetMode("review")
^!+n:: AppState.SetMode("normal")

/**
 * Display application state
 */
^!s:: {
    info := "Application State`n"
    info .= "=================`n`n"
    info .= "Mode: " AppState.Mode "`n"
    info .= "Project: " (AppState.Project != "" ? AppState.Project : "(none)") "`n"
    info .= "Tasks: " AppState.Tasks.Length "`n`n"

    if (AppState.Flags.Count > 0) {
        info .= "Flags:`n"
        for name, value in AppState.Flags {
            info .= "  " name ": " (value ? "ON" : "OFF") "`n"
        }
    }

    MsgBox(info, "App State", "Iconi")
}

/**
 * ============================================================================
 * Example 6: Complex Multi-Condition Functions
 * ============================================================================
 * 
 * @description Combine multiple conditions in single function
 * @concept Complex conditions, multi-factor evaluation
 */

/**
 * Check if in productive coding state
 * @returns {Boolean} True if conditions met
 */
IsProductiveCodingTime() {
    ; Must be weekday
    if IsWeekend()
        return false

    ; Must be business hours (9 AM - 5 PM)
    hour := Integer(FormatTime(, "H"))
    if (hour < 9 || hour >= 17)
        return false

    ; Must be in text editor
    editors := ["notepad.exe", "Code.exe", "sublime_text.exe"]
    process := WinGetProcessName("A")

    for editor in editors {
        if (process = editor)
            return true
    }

    return false
}

/**
 * Check if conditions are right for break
 * @returns {Boolean} True if should take break
 */
ShouldTakeBreak() {
    static LastBreak := 0

    ; Check if 1 hour has passed since last break
    hoursSinceBreak := (A_TickCount - LastBreak) / (1000 * 60 * 60)

    if (hoursSinceBreak >= 1) {
        ; During work hours
        hour := Integer(FormatTime(, "H"))
        if (hour >= 9 && hour < 17) {
            return true
        }
    }

    return false
}

; Hotkey for productive coding time
#HotIf IsProductiveCodingTime()

^!p:: MsgBox("Productive coding time detected!", "Productive", "Iconi")
#HotIf

/**
 * ============================================================================
 * Example 7: Dynamic Condition Builder
 * ============================================================================
 * 
 * @description Build conditions dynamically at runtime
 * @concept Dynamic conditions, runtime configuration
 */

/**
 * Condition builder for dynamic hotkey activation
 * @class
 */
class ConditionBuilder {
    static Conditions := Map()

    /**
     * Add a condition
     * @param {String} name - Condition name
     * @param {Func} checker - Condition function
     * @param {Boolean} enabled - Initially enabled
     */
    static Add(name, checker, enabled := true) {
        this.Conditions[name] := {
            Name: name,
            Checker: checker,
            Enabled: enabled
        }
    }

    /**
     * Enable condition
     * @param {String} name - Condition name
     */
    static Enable(name) {
        if this.Conditions.Has(name)
            this.Conditions[name].Enabled := true
    }

    /**
     * Disable condition
     * @param {String} name - Condition name
     */
    static Disable(name) {
        if this.Conditions.Has(name)
            this.Conditions[name].Enabled := false
    }

    /**
     * Check if all enabled conditions are met
     * @returns {Boolean} True if all enabled conditions pass
     */
    static AllMet() {
        for name, cond in this.Conditions {
            if (cond.Enabled && !cond.Checker.Call())
                return false
        }
        return true
    }

    /**
     * Check if any enabled condition is met
     * @returns {Boolean} True if any enabled condition passes
     */
    static AnyMet() {
        for name, cond in this.Conditions {
            if (cond.Enabled && cond.Checker.Call())
                return true
        }
        return false
    }

    /**
     * Display condition status
     */
    static ShowStatus() {
        output := "Condition Builder Status`n"
        output .= "========================`n`n"

        for name, cond in this.Conditions {
            enabled := cond.Enabled
            met := enabled ? cond.Checker.Call() : false

            status := ""
            if !enabled
                status := "○ Disabled"
            else if met
                status := "✓ Met"
            else
                status := "✗ Not Met"

            output .= name ": " status "`n"
        }

        output .= "`nCombined:`n"
        output .= "  All Met: " (this.AllMet() ? "Yes" : "No") "`n"
        output .= "  Any Met: " (this.AnyMet() ? "Yes" : "No")

        MsgBox(output, "Conditions", "Iconi")
    }
}

; Add example conditions
ConditionBuilder.Add("TextEditor", () => IsTextEditor())
ConditionBuilder.Add("BusinessHours", () => IsBusinessHours())
ConditionBuilder.Add("CustomMode", () => IsCustomMode())

; Hotkey using dynamic conditions
#HotIf ConditionBuilder.AllMet()

^!+d:: MsgBox("All dynamic conditions met!", "Dynamic", "Iconi")
#HotIf

^!+c:: ConditionBuilder.ShowStatus()

/**
 * Helper function - Check if text editor
 */
IsTextEditor() {
    editors := ["notepad.exe", "Code.exe", "sublime_text.exe"]
    process := WinGetProcessName("A")
    for editor in editors {
        if (process = editor)
            return true
    }
    return false
}

/**
 * Helper function - Check if business hours
 */
IsBusinessHours() {
    hour := Integer(FormatTime(, "H"))
    return (hour >= 9 && hour < 17)
}

/**
 * ============================================================================
 * STARTUP AND HELP
 * ============================================================================
 */

TrayTip("Custom conditions loaded", "Script Ready", "Iconi Mute")

/**
 * Help
 */
^!h:: {
    help := "Custom Condition Examples`n"
    help .= "=========================`n`n"

    help .= "Mode Toggles:`n"
    help .= "^!1 - Toggle Custom Mode`n"
    help .= "^!2 - Toggle Advanced Mode`n"
    help .= "^!+e - Set Edit Mode`n"
    help .= "^!+r - Set Review Mode`n"
    help .= "^!+n - Set Normal Mode`n`n"

    help .= "Information:`n"
    help .= "^!k - Keyboard State`n"
    help .= "^!mouse - Mouse Info`n"
    help .= "^!t - Time Info`n"
    help .= "^!s - App State`n"
    help .= "^!+c - Condition Status`n`n"

    help .= "Current States:`n"
    help .= "Custom Mode: " (CustomMode ? "ON" : "OFF") "`n"
    help .= "Advanced Mode: " (AdvancedMode ? "ON" : "OFF") "`n"
    help .= "App Mode: " AppState.Mode "`n`n"

    help .= "^!h - Show Help"

    MsgBox(help, "Help", "Iconi")
}
