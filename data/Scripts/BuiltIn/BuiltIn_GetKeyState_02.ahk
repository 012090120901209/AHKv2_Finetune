#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 GetKeyState Function - Toggle Detection
* ============================================================================
*
* Advanced toggle state detection, state change monitoring, and toggle-based
* automation for CapsLock, NumLock, ScrollLock, and Insert keys.
*
* @module BuiltIn_GetKeyState_02
* @author AutoHotkey Community
* @version 2.0.0
*/

; ============================================================================
; Example 1: CapsLock State Management
; ============================================================================

/**
* Detects CapsLock state changes.
* Monitors when CapsLock is toggled on/off.
*
* @example
* ; Press F1 to start CapsLock monitoring
*/
F1:: {
    global capsMonitoring := true
    global lastCapsState := GetKeyState("CapsLock", "T")

    SetTimer(CheckCapsLock, 100)

    ToolTip("CapsLock monitoring active (Press F1 to stop)")

    CheckCapsLock() {
        if (!capsMonitoring)
        return

        currentState := GetKeyState("CapsLock", "T")

        if (currentState != lastCapsState) {
            ; State changed!
            if (currentState)
            ToolTip("CapsLock turned ON`nPress F1 to stop")
            else
            ToolTip("CapsLock turned OFF`nPress F1 to stop")

            SoundBeep(currentState ? 800 : 400, 100)

            lastCapsState := currentState
        } else {
            status := "CapsLock: " (currentState ? "ON" : "OFF")
            status .= "`nPress F1 to stop"
            ToolTip(status)
        }
    }
}

F1 up:: {
    global capsMonitoring := false
    SetTimer(CheckCapsLock, 0)
    ToolTip()
}

/**
* Auto-corrects CapsLock state
* Automatically turns off CapsLock
*/
F2:: {
    global autoCapsCorrect := true

    SetTimer(AutoCorrectCaps, 500)

    ToolTip("Auto CapsLock correction active`n(Automatically turns OFF CapsLock)`nPress F2 to stop")

    AutoCorrectCaps() {
        if (!autoCapsCorrect)
        return

        capsState := GetKeyState("CapsLock", "T")

        if (capsState) {
            SetCapsLockState(0)  ; Turn off
            ToolTip("CapsLock auto-corrected to OFF`nPress F2 to stop")
            SoundBeep(600, 200)
        }
    }
}

F2 up:: {
    global autoCapsCorrect := false
    SetTimer(AutoCorrectCaps, 0)
    ToolTip()
}

; ============================================================================
; Example 2: NumLock State Monitoring
; ============================================================================

/**
* Monitors NumLock state for warnings.
* Alerts when NumLock is in wrong state.
*
* @description
* Prevents accidental NumLock changes
*/
^F1:: {
    global numMonitoring := true
    global preferredNumState := true  ; Prefer NumLock ON

    SetTimer(CheckNumLock, 200)

    ToolTip("NumLock monitoring active`nPreferred: ON`nPress Ctrl+F1 to stop")

    CheckNumLock() {
        if (!numMonitoring)
        return

        currentState := GetKeyState("NumLock", "T")

        if (currentState != preferredNumState) {
            ToolTip("WARNING: NumLock is " (currentState ? "ON" : "OFF") "`nPreferred state is " (preferredNumState ? "ON" : "OFF") "`n`nPress Ctrl+F1 to stop")
            SoundBeep(1000, 100)
        } else {
            ToolTip("NumLock: " (currentState ? "ON" : "OFF") " (Correct)`nPress Ctrl+F1 to stop")
        }
    }
}

^F1 up:: {
    global numMonitoring := false
    SetTimer(CheckNumLock, 0)
    ToolTip()
}

/**
* Auto-enforces NumLock state
* Keeps NumLock in desired state
*/
^F2:: {
    global numEnforcing := true
    global enforcedNumState := true  ; Keep NumLock ON

    SetTimer(EnforceNumLock, 300)

    ToolTip("NumLock enforcement active`nWill keep NumLock ON`nPress Ctrl+F2 to stop")

    EnforceNumLock() {
        if (!numEnforcing)
        return

        currentState := GetKeyState("NumLock", "T")

        if (currentState != enforcedNumState) {
            SetNumLockState(enforcedNumState ? 1 : 0)
            ToolTip("NumLock auto-corrected to " (enforcedNumState ? "ON" : "OFF") "`nPress Ctrl+F2 to stop")
            SoundBeep(700, 100)
        }
    }
}

^F2 up:: {
    global numEnforcing := false
    SetTimer(EnforceNumLock, 0)
    ToolTip()
}

; ============================================================================
; Example 3: Multi-Toggle State Detection
; ============================================================================

/**
* Monitors all toggle keys simultaneously.
* Displays state of all toggle keys.
*
* @description
* Comprehensive toggle monitoring
*/
^F3:: {
    global multiToggleMonitoring := true

    SetTimer(MonitorAllToggles, 100)

    ToolTip("All toggle monitoring active`nPress Ctrl+F3 to stop")

    MonitorAllToggles() {
        if (!multiToggleMonitoring)
        return

        capsState := GetKeyState("CapsLock", "T")
        numState := GetKeyState("NumLock", "T")
        scrollState := GetKeyState("ScrollLock", "T")
        insertState := GetKeyState("Insert", "T")

        status := "=== TOGGLE KEY STATES ===`n`n"
        status .= "CapsLock:   " (capsState ? "✓ ON " : "✗ OFF") "`n"
        status .= "NumLock:    " (numState ? "✓ ON " : "✗ OFF") "`n"
        status .= "ScrollLock: " (scrollState ? "✓ ON " : "✗ OFF") "`n"
        status .= "Insert:     " (insertState ? "✓ ON " : "✗ OFF") "`n`n"
        status .= "Press Ctrl+F3 to stop"

        ToolTip(status)
    }
}

^F3 up:: {
    global multiToggleMonitoring := false
    SetTimer(MonitorAllToggles, 0)
    ToolTip()
}

; ============================================================================
; Example 4: Toggle State Change Logging
; ============================================================================

/**
* Logs all toggle state changes.
* Creates timestamped log of changes.
*
* @description
* State change tracking
*/
^F4:: {
    global toggleLogging := true
    global toggleLog := []
    global lastStates := Map()

    ; Initialize last states
    lastStates["CapsLock"] := GetKeyState("CapsLock", "T")
    lastStates["NumLock"] := GetKeyState("NumLock", "T")
    lastStates["ScrollLock"] := GetKeyState("ScrollLock", "T")

    SetTimer(LogToggleChanges, 100)

    ToolTip("Toggle logging started`nPress Ctrl+F4 to view log")

    LogToggleChanges() {
        if (!toggleLogging)
        return

        keys := ["CapsLock", "NumLock", "ScrollLock"]

        for keyName in keys {
            currentState := GetKeyState(keyName, "T")

            if (currentState != lastStates[keyName]) {
                ; State changed, log it
                timestamp := FormatTime(, "HH:mm:ss")
                logEntry := timestamp " - " keyName " turned " (currentState ? "ON" : "OFF")

                toggleLog.Push(logEntry)

                lastStates[keyName] := currentState

                ToolTip("CHANGE DETECTED!`n" logEntry "`n`nPress Ctrl+F4 to view full log")
                SoundBeep(900, 150)
            }
        }
    }
}

^F4 up:: {
    global toggleLogging := false
    SetTimer(LogToggleChanges, 0)

    ; Display log
    if (toggleLog.Length > 0) {
        logText := "Toggle State Change Log:`n"
        logText .= "======================`n`n"

        for index, entry in toggleLog {
            logText .= entry "`n"
        }

        logText .= "`nTotal changes: " toggleLog.Length

        MsgBox(logText, "Toggle Change Log")
    } else {
        MsgBox("No toggle changes detected.", "Toggle Log")
    }

    ToolTip()
}

; ============================================================================
; Example 5: Context-Sensitive Actions Based on Toggles
; ============================================================================

/**
* Different actions based on CapsLock state.
* Typing mode changes with CapsLock.
*
* @description
* Toggle-aware automation
*/
^F5:: {
    capsOn := GetKeyState("CapsLock", "T")

    if (capsOn) {
        SendText("THIS TEXT IS UPPERCASE BECAUSE CAPSLOCK IS ON!")
    } else {
        SendText("this text is lowercase because capslock is off.")
    }

    ToolTip("Text sent based on CapsLock state!")
    Sleep(2000)
    ToolTip()
}

/**
* NumLock-dependent number pad behavior
* Shows different behavior based on NumLock
*/
^F6:: {
    numOn := GetKeyState("NumLock", "T")

    if (numOn)
    MsgBox("NumLock ON: Numpad produces NUMBERS (0-9)", "NumLock Mode")
    else
    MsgBox("NumLock OFF: Numpad produces NAVIGATION (arrows, home, etc.)", "NumLock Mode")
}

; ============================================================================
; Example 6: Toggle State Combinations
; ============================================================================

/**
* Detects specific toggle combinations.
* Different actions for different toggle states.
*
* @description
* Complex toggle logic
*/
^F7:: {
    capsOn := GetKeyState("CapsLock", "T")
    numOn := GetKeyState("NumLock", "T")
    scrollOn := GetKeyState("ScrollLock", "T")

    mode := ""

    if (capsOn && numOn && scrollOn)
    mode := "ALL TOGGLES ON - Maximum mode!"
    else if (!capsOn && !numOn && !scrollOn)
    mode := "ALL TOGGLES OFF - Minimal mode"
    else if (capsOn && numOn)
    mode := "Caps + Num ON - Typing + Numbers mode"
    else if (capsOn)
    mode := "Caps ONLY - UPPERCASE mode"
    else if (numOn)
    mode := "Num ONLY - Number pad mode"
    else
    mode := "Mixed toggle state"

    MsgBox("Current Mode: " mode, "Toggle Combination")
}

; ============================================================================
; Example 7: Toggle State Persistence Checking
; ============================================================================

/**
* Checks toggle persistence over time.
* Monitors how long toggles stay in state.
*
* @description
* Duration tracking
*/
^F8:: {
    global persistenceMonitoring := true
    global capsOnTime := 0
    global capsOnStart := 0

    SetTimer(CheckTogglePersistence, 100)

    ToolTip("Toggle persistence monitoring`nPress Ctrl+F8 to stop and view report")

    CheckTogglePersistence() {
        if (!persistenceMonitoring)
        return

        capsOn := GetKeyState("CapsLock", "T")

        if (capsOn) {
            if (capsOnStart = 0)
            capsOnStart := A_TickCount

            capsOnTime := A_TickCount - capsOnStart

            ToolTip("CapsLock ON Duration: " Round(capsOnTime / 1000, 1) " seconds`nPress Ctrl+F8 to stop")
        } else {
            if (capsOnStart != 0) {
                ToolTip("CapsLock is OFF`nLast ON duration: " Round(capsOnTime / 1000, 1) " seconds`nPress Ctrl+F8 to stop")
            } else {
                ToolTip("CapsLock is OFF`nPress Ctrl+F8 to stop")
            }
        }
    }
}

^F8 up:: {
    global persistenceMonitoring := false
    SetTimer(CheckTogglePersistence, 0)

    report := "Toggle Persistence Report:`n`n"
    report .= "CapsLock was ON for: " Round(capsOnTime / 1000, 1) " seconds"

    MsgBox(report, "Persistence Report")
    ToolTip()
}

; ============================================================================
; Example 8: Toggle State Validation
; ============================================================================

/**
* Validates toggle states before operations.
* Ensures correct toggle configuration.
*
* @description
* Pre-operation validation
*/
^F9:: {
    ; Define required states
    requiredStates := {
        CapsLock: false,    ; Must be OFF
        NumLock: true,      ; Must be ON
        ScrollLock: false   ; Must be OFF
    }

    ; Check states
    capsOK := GetKeyState("CapsLock", "T") = requiredStates.CapsLock
    numOK := GetKeyState("NumLock", "T") = requiredStates.NumLock
    scrollOK := GetKeyState("ScrollLock", "T") = requiredStates.ScrollLock

    allOK := capsOK && numOK && scrollOK

    result := "Toggle State Validation:`n`n"
    result .= "CapsLock:   " (capsOK ? "✓ Correct (OFF)" : "✗ Wrong (should be OFF)") "`n"
    result .= "NumLock:    " (numOK ? "✓ Correct (ON)" : "✗ Wrong (should be ON)") "`n"
    result .= "ScrollLock: " (scrollOK ? "✓ Correct (OFF)" : "✗ Wrong (should be OFF)") "`n`n"

    if (allOK)
    result .= "Status: READY TO PROCEED"
    else
    result .= "Status: FIX TOGGLE STATES BEFORE PROCEEDING"

    MsgBox(result, "State Validation")
}

; ============================================================================
; Example 9: Toggle State Auto-Configuration
; ============================================================================

/**
* Automatically configures toggle states.
* Sets toggles to optimal configuration.
*
* @description
* Auto-setup for optimal state
*/
^F10:: {
    ToolTip("Auto-configuring toggle states...")

    ; Desired configuration
    SetCapsLockState(0)    ; CapsLock OFF
    SetNumLockState(1)     ; NumLock ON
    SetScrollLockState(0)  ; ScrollLock OFF

    Sleep(500)

    ; Verify configuration
    capsState := GetKeyState("CapsLock", "T")
    numState := GetKeyState("NumLock", "T")
    scrollState := GetKeyState("ScrollLock", "T")

    result := "Toggle Auto-Configuration Complete:`n`n"
    result .= "CapsLock:   " (capsState ? "ON" : "OFF") "`n"
    result .= "NumLock:    " (numState ? "ON" : "OFF") "`n"
    result .= "ScrollLock: " (scrollState ? "ON" : "OFF")

    ToolTip()
    MsgBox(result, "Auto-Configuration")
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
* Gets all toggle states
*
* @returns {Object} All toggle states
*/
GetAllToggleStates() {
    return {
        capsLock: GetKeyState("CapsLock", "T"),
        numLock: GetKeyState("NumLock", "T"),
        scrollLock: GetKeyState("ScrollLock", "T"),
        insert: GetKeyState("Insert", "T")
    }
}

/**
* Checks if toggle configuration matches requirements
*
* @param {Object} required - Required states
* @returns {Boolean} True if matches
*/
ValidateToggleConfig(required) {
    for toggleName, requiredState in required.OwnProps() {
        actualState := GetKeyState(toggleName, "T")
        if (actualState != requiredState)
        return false
    }
    return true
}

/**
* Sets multiple toggle states
*
* @param {Object} states - Desired states
*/
SetToggleStates(states) {
    if (states.HasOwnProp("capsLock"))
    SetCapsLockState(states.capsLock ? 1 : 0)

    if (states.HasOwnProp("numLock"))
    SetNumLockState(states.numLock ? 1 : 0)

    if (states.HasOwnProp("scrollLock"))
    SetScrollLockState(states.scrollLock ? 1 : 0)
}

/**
* Counts how many toggles are ON
*
* @returns {Number} Count of active toggles
*/
CountActiveToggles() {
    count := 0

    if (GetKeyState("CapsLock", "T"))
    count++
    if (GetKeyState("NumLock", "T"))
    count++
    if (GetKeyState("ScrollLock", "T"))
    count++

    return count
}

; Test utilities
!F1:: {
    states := GetAllToggleStates()

    msg := "All Toggle States:`n`n"
    for name, state in states.OwnProps()
    msg .= name ": " (state ? "ON" : "OFF") "`n"

    MsgBox(msg, "GetAllToggleStates Test")
}

!F2:: {
    count := CountActiveToggles()

    MsgBox("Active Toggles: " count " / 3", "CountActiveToggles Test")
}

!F3:: {
    ; Set optimal config
    SetToggleStates({
        capsLock: false,
        numLock: true,
        scrollLock: false
    })

    MsgBox("Toggle states set to optimal configuration!", "SetToggleStates Test")
}

; ============================================================================
; Exit and Help
; ============================================================================

Esc::ExitApp()

F12:: {
    helpText := "
    (
    GetKeyState - Toggle Detection
    ===============================

    F1 - Monitor CapsLock changes
    F2 - Auto-correct CapsLock

    Ctrl+F1  - Monitor NumLock warnings
    Ctrl+F2  - Enforce NumLock state
    Ctrl+F3  - Monitor all toggles
    Ctrl+F4  - Toggle change logging
    Ctrl+F5  - CapsLock-based typing
    Ctrl+F6  - NumLock mode display
    Ctrl+F7  - Toggle combinations
    Ctrl+F8  - Persistence monitoring
    Ctrl+F9  - State validation
    Ctrl+F10 - Auto-configuration

    Alt+F1 - GetAllToggleStates test
    Alt+F2 - CountActiveToggles test
    Alt+F3 - SetToggleStates test

    F12 - Show this help
    ESC - Exit script
    )"

    MsgBox(helpText, "Toggle Detection Help")
}
