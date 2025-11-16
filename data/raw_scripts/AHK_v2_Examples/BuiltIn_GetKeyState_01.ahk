#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 GetKeyState Function - Check Key State
 * ============================================================================
 *
 * GetKeyState retrieves the current state of a keyboard key or mouse button.
 * Essential for conditional logic, state-based automation, and input monitoring.
 *
 * Syntax: GetKeyState(KeyName [, Mode])
 * Modes: "P" (Physical), "T" (Toggle)
 *
 * @module BuiltIn_GetKeyState_01
 * @author AutoHotkey Community
 * @version 2.0.0
 */

; ============================================================================
; Example 1: Basic Key State Checking
; ============================================================================

/**
 * Checks if key is currently pressed.
 * Returns true if key is down, false if up.
 *
 * @example
 * ; Press F1 to check Shift state
 */
F1:: {
    shiftState := GetKeyState("Shift", "P")

    if (shiftState)
        ToolTip("Shift is currently PRESSED")
    else
        ToolTip("Shift is currently RELEASED")

    Sleep(2000)
    ToolTip()
}

/**
 * Checks Ctrl key state
 * Demonstrates physical state checking
 */
F2:: {
    ctrlState := GetKeyState("Ctrl", "P")

    msg := "Ctrl key is "
    msg .= ctrlState ? "DOWN" : "UP"

    MsgBox(msg, "Ctrl State")
}

/**
 * Checks Alt key state
 * Useful for modifier-dependent actions
 */
F3:: {
    altState := GetKeyState("Alt", "P")

    if (altState)
        MsgBox("Alt key is being held!", "Alt Detected")
    else
        MsgBox("Alt key is not pressed.", "Alt Not Detected")
}

; ============================================================================
; Example 2: Toggle State Checking
; ============================================================================

/**
 * Checks CapsLock toggle state.
 * Returns true if CapsLock is ON.
 *
 * @description
 * Demonstrates toggle state monitoring
 */
^F1:: {
    capsState := GetKeyState("CapsLock", "T")

    if (capsState)
        MsgBox("CapsLock is ON", "CapsLock State")
    else
        MsgBox("CapsLock is OFF", "CapsLock State")
}

/**
 * Checks NumLock state
 * Monitors numpad mode
 */
^F2:: {
    numState := GetKeyState("NumLock", "T")

    msg := "NumLock is "
    msg .= numState ? "ON (numbers enabled)" : "OFF (navigation mode)"

    MsgBox(msg, "NumLock State")
}

/**
 * Checks ScrollLock state
 * Less common but still useful
 */
^F3:: {
    scrollState := GetKeyState("ScrollLock", "T")

    msg := "ScrollLock is "
    msg .= scrollState ? "ENABLED" : "DISABLED"

    MsgBox(msg, "ScrollLock State")
}

/**
 * Checks Insert key toggle
 * Insert/Overwrite mode
 */
^F4:: {
    insertState := GetKeyState("Insert", "T")

    msg := "Insert mode is "
    msg .= insertState ? "ON (insert mode)" : "OFF (overwrite mode)"

    MsgBox(msg, "Insert Mode")
}

; ============================================================================
; Example 3: Mouse Button State
; ============================================================================

/**
 * Checks left mouse button state.
 * Detects if button is being held.
 *
 * @description
 * Mouse button monitoring
 */
^F5:: {
    ToolTip("Checking mouse buttons for 5 seconds...`nPress and hold mouse buttons!")

    startTime := A_TickCount

    Loop {
        elapsed := A_TickCount - startTime
        if (elapsed > 5000)
            break

        lbState := GetKeyState("LButton", "P")
        rbState := GetKeyState("RButton", "P")
        mbState := GetKeyState("MButton", "P")

        status := "Mouse Button States:`n`n"
        status .= "Left:   " (lbState ? "PRESSED" : "Released") "`n"
        status .= "Right:  " (rbState ? "PRESSED" : "Released") "`n"
        status .= "Middle: " (mbState ? "PRESSED" : "Released") "`n`n"
        status .= "Time: " Round(elapsed / 1000, 1) "s / 5s"

        ToolTip(status)
        Sleep(50)
    }

    ToolTip()
}

; ============================================================================
; Example 4: Conditional Actions Based on Key State
; ============================================================================

/**
 * Performs different actions based on modifier state.
 * Shift changes behavior.
 *
 * @description
 * State-dependent automation
 */
^F6:: {
    shiftHeld := GetKeyState("Shift", "P")

    if (shiftHeld)
        MsgBox("SHIFT MODE: Special action executed!", "Conditional Action")
    else
        MsgBox("NORMAL MODE: Standard action executed!", "Conditional Action")
}

/**
 * Multi-modifier checking
 * Different actions for different modifier combinations
 */
^F7:: {
    shiftHeld := GetKeyState("Shift", "P")
    ctrlHeld := GetKeyState("Ctrl", "P")
    altHeld := GetKeyState("Alt", "P")

    action := "Action: "

    if (shiftHeld && ctrlHeld && altHeld)
        action .= "ALL modifiers held!"
    else if (shiftHeld && ctrlHeld)
        action .= "Shift + Ctrl combo"
    else if (shiftHeld && altHeld)
        action .= "Shift + Alt combo"
    else if (ctrlHeld && altHeld)
        action .= "Ctrl + Alt combo"
    else if (shiftHeld)
        action .= "Shift only"
    else if (ctrlHeld)
        action .= "Ctrl only"
    else if (altHeld)
        action .= "Alt only"
    else
        action .= "No modifiers"

    MsgBox(action, "Modifier Detection")
}

; ============================================================================
; Example 5: Continuous State Monitoring
; ============================================================================

/**
 * Monitors key state in real-time.
 * Shows live updates of key state.
 *
 * @description
 * Real-time monitoring demo
 */
^F8:: {
    global monitoring := true

    SetTimer(MonitorKeys, 50)

    ToolTip("Key monitoring active (Press Ctrl+F8 to stop)")

    MonitorKeys() {
        if (!monitoring)
            return

        ; Check multiple keys
        spaceState := GetKeyState("Space", "P")
        enterState := GetKeyState("Enter", "P")
        escState := GetKeyState("Escape", "P")
        tabState := GetKeyState("Tab", "P")

        status := "Key States (Press Ctrl+F8 to stop):`n`n"
        status .= "Space:  " (spaceState ? "[PRESSED]" : "Released") "`n"
        status .= "Enter:  " (enterState ? "[PRESSED]" : "Released") "`n"
        status .= "Escape: " (escState ? "[PRESSED]" : "Released") "`n"
        status .= "Tab:    " (tabState ? "[PRESSED]" : "Released")

        ToolTip(status)
    }
}

^F8 up:: {
    global monitoring := false
    SetTimer(MonitorKeys, 0)
    ToolTip()
}

/**
 * Monitors toggle keys continuously
 * Real-time toggle state display
 */
^F9:: {
    global toggleMonitoring := true

    SetTimer(MonitorToggles, 100)

    ToolTip("Toggle monitoring active (Press Ctrl+F9 to stop)")

    MonitorToggles() {
        if (!toggleMonitoring)
            return

        capsState := GetKeyState("CapsLock", "T")
        numState := GetKeyState("NumLock", "T")
        scrollState := GetKeyState("ScrollLock", "T")
        insertState := GetKeyState("Insert", "T")

        status := "Toggle Key States (Press Ctrl+F9 to stop):`n`n"
        status .= "CapsLock:   " (capsState ? "[ON]" : "OFF") "`n"
        status .= "NumLock:    " (numState ? "[ON]" : "OFF") "`n"
        status .= "ScrollLock: " (scrollState ? "[ON]" : "OFF") "`n"
        status .= "Insert:     " (insertState ? "[ON]" : "OFF")

        ToolTip(status)
    }
}

^F9 up:: {
    global toggleMonitoring := false
    SetTimer(MonitorToggles, 0)
    ToolTip()
}

; ============================================================================
; Example 6: Wait for Key Press/Release
; ============================================================================

/**
 * Waits for key to be pressed.
 * Blocks until key state changes.
 *
 * @description
 * Synchronous key waiting
 */
^F10:: {
    ToolTip("Waiting for Space to be pressed...")

    ; Wait loop
    while (!GetKeyState("Space", "P")) {
        Sleep(50)
    }

    ToolTip("Space detected! Now waiting for release...")

    ; Wait for release
    while (GetKeyState("Space", "P")) {
        Sleep(50)
    }

    ToolTip("Space released! Complete.")
    Sleep(2000)
    ToolTip()
}

/**
 * Waits for mouse button
 * Synchronous mouse button detection
 */
^F11:: {
    ToolTip("Waiting for LEFT mouse button click...")

    ; Wait for press
    while (!GetKeyState("LButton", "P")) {
        Sleep(50)
    }

    ToolTip("Left button DOWN! Waiting for release...")

    ; Wait for release
    while (GetKeyState("LButton", "P")) {
        Sleep(50)
    }

    ToolTip("Left button released! Complete.")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 7: State-Based Hotkey Variations
; ============================================================================

/**
 * Context-sensitive hotkey behavior.
 * Same hotkey, different actions based on state.
 *
 * @description
 * Dynamic hotkey behavior
 */
Space:: {
    ; Check if Shift is held
    if (GetKeyState("Shift", "P"))
        SendText("UPPERCASE TEXT MODE!")
    else if (GetKeyState("Ctrl", "P"))
        SendText("Control mode activated")
    else
        Send("{Space}")  ; Normal space
}

/**
 * Toggle-aware hotkey
 * Behavior changes based on CapsLock
 */
^Space:: {
    capsOn := GetKeyState("CapsLock", "T")

    if (capsOn)
        MsgBox("CapsLock is ON - using UPPERCASE mode", "Mode")
    else
        MsgBox("CapsLock is OFF - using lowercase mode", "Mode")
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
 * Gets state of all modifier keys
 *
 * @returns {Object} Modifier states
 */
GetModifierStates() {
    return {
        shift: GetKeyState("Shift", "P"),
        ctrl: GetKeyState("Ctrl", "P"),
        alt: GetKeyState("Alt", "P"),
        win: GetKeyState("LWin", "P") || GetKeyState("RWin", "P")
    }
}

/**
 * Gets state of all toggle keys
 *
 * @returns {Object} Toggle states
 */
GetToggleStates() {
    return {
        capsLock: GetKeyState("CapsLock", "T"),
        numLock: GetKeyState("NumLock", "T"),
        scrollLock: GetKeyState("ScrollLock", "T"),
        insert: GetKeyState("Insert", "T")
    }
}

/**
 * Checks if any modifier is held
 *
 * @returns {Boolean} True if any modifier held
 */
IsAnyModifierHeld() {
    return (GetKeyState("Shift", "P") ||
            GetKeyState("Ctrl", "P") ||
            GetKeyState("Alt", "P") ||
            GetKeyState("LWin", "P") ||
            GetKeyState("RWin", "P"))
}

/**
 * Waits for all keys to be released
 *
 * @param {Number} timeout - Max wait time in ms
 * @returns {Boolean} True if all released
 */
WaitForKeyRelease(timeout := 5000) {
    startTime := A_TickCount

    while (IsAnyModifierHeld()) {
        if (A_TickCount - startTime > timeout)
            return false

        Sleep(50)
    }

    return true
}

; Test utilities
!F1:: {
    states := GetModifierStates()

    msg := "Modifier States:`n`n"
    msg .= "Shift: " (states.shift ? "DOWN" : "UP") "`n"
    msg .= "Ctrl:  " (states.ctrl ? "DOWN" : "UP") "`n"
    msg .= "Alt:   " (states.alt ? "DOWN" : "UP") "`n"
    msg .= "Win:   " (states.win ? "DOWN" : "UP")

    MsgBox(msg, "GetModifierStates Test")
}

!F2:: {
    states := GetToggleStates()

    msg := "Toggle States:`n`n"
    msg .= "CapsLock:   " (states.capsLock ? "ON" : "OFF") "`n"
    msg .= "NumLock:    " (states.numLock ? "ON" : "OFF") "`n"
    msg .= "ScrollLock: " (states.scrollLock ? "ON" : "OFF") "`n"
    msg .= "Insert:     " (states.insert ? "ON" : "OFF")

    MsgBox(msg, "GetToggleStates Test")
}

!F3:: {
    anyHeld := IsAnyModifierHeld()

    msg := anyHeld ? "YES - A modifier is held" : "NO - No modifiers held"

    MsgBox(msg, "IsAnyModifierHeld Test")
}

; ============================================================================
; Exit and Help
; ============================================================================

Esc::ExitApp()

F12:: {
    helpText := "
    (
    GetKeyState - Check Key State
    ==============================

    F1 - Check Shift state
    F2 - Check Ctrl state
    F3 - Check Alt state

    Ctrl+F1  - Check CapsLock
    Ctrl+F2  - Check NumLock
    Ctrl+F3  - Check ScrollLock
    Ctrl+F4  - Check Insert
    Ctrl+F5  - Monitor mouse buttons
    Ctrl+F6  - Conditional action (Shift)
    Ctrl+F7  - Multi-modifier check
    Ctrl+F8  - Toggle key monitoring
    Ctrl+F9  - Toggle state monitoring
    Ctrl+F10 - Wait for Space
    Ctrl+F11 - Wait for mouse click

    Space - Context-sensitive space
    Ctrl+Space - CapsLock-aware action

    Alt+F1 - GetModifierStates test
    Alt+F2 - GetToggleStates test
    Alt+F3 - IsAnyModifierHeld test

    F12 - Show this help
    ESC - Exit script
    )"

    MsgBox(helpText, "GetKeyState Examples Help")
}
