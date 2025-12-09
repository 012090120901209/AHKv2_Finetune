#Requires AutoHotkey v2.0

/**
* ============================================================================
* Hotkey() Function - Enable/Disable Hotkey Management
* ============================================================================
*
* This file demonstrates how to enable and disable hotkeys dynamically
* using the Hotkey() function. Shows various patterns for controlling
* hotkey availability based on application state, conditions, and user input.
*
* Key concepts:
* - Hotkey "On" and "Off" options
* - Toggle hotkey states
* - Conditional enabling/disabling
* - Bulk hotkey management
* - Temporary hotkey suspension
*
* @author AutoHotkey v2 Documentation Team
* @version 1.0.0
* @see https://www.autohotkey.com/docs/v2/lib/Hotkey.htm
*/

; ============================================================================
; Example 1: Basic Enable/Disable Operations
; ============================================================================

/**
* Demonstrates the fundamental enable/disable operations for hotkeys.
*
* @example
* ; Toggle hotkeys on and off
*/
Example1_BasicEnableDisable() {
    ; Create a test hotkey
    Hotkey("F1", (*) => MsgBox("F1 is active!", "Hotkey"))

    ; Create control hotkeys
    Hotkey("^!e", (*) {
        Hotkey("F1", "On")
        MsgBox("F1 hotkey ENABLED`n`nPress F1 to test", "Enable")
    })

    Hotkey("^!d", (*) {
        Hotkey("F1", "Off")
        MsgBox("F1 hotkey DISABLED`n`nF1 will not respond", "Disable")
    })

    Hotkey("^!t", (*) {
        Hotkey("F1", "Toggle")
        ; Check if enabled (we'll use a variable to track)
        MsgBox("F1 hotkey TOGGLED", "Toggle")
    })

    MsgBox(
    "Basic Enable/Disable Demo`n`n"
    "F1 - Test hotkey`n"
    "Ctrl+Alt+E - Enable F1`n"
    "Ctrl+Alt+D - Disable F1`n"
    "Ctrl+Alt+T - Toggle F1`n`n"
    "F1 is currently ENABLED",
    "Example 1"
    )
}

; ============================================================================
; Example 2: Hotkey State Tracker
; ============================================================================

/**
* Implements a system to track and manage hotkey enabled/disabled states.
*
* @example
* ; Track multiple hotkeys and their states
*/
Example2_StateTracker() {
    ; Hotkey state tracker
    static hotkeyStates := Map()

    /**
    * Creates a managed hotkey with state tracking
    */
    CreateManagedHotkey(key, callback, initialState := true) {
        static hotkeyStates
        Hotkey(key, callback)
        if !initialState
        Hotkey(key, "Off")
        hotkeyStates[key] := initialState
    }

    /**
    * Enables a managed hotkey
    */
    EnableHotkey(key) {
        static hotkeyStates
        Hotkey(key, "On")
        hotkeyStates[key] := true
        MsgBox("Enabled: " key, "Hotkey Manager")
    }

    /**
    * Disables a managed hotkey
    */
    DisableHotkey(key) {
        static hotkeyStates
        Hotkey(key, "Off")
        hotkeyStates[key] := false
        MsgBox("Disabled: " key, "Hotkey Manager")
    }

    /**
    * Toggles a managed hotkey
    */
    ToggleHotkey(key) {
        static hotkeyStates
        if !hotkeyStates.Has(key)
        return

        newState := !hotkeyStates[key]
        Hotkey(key, newState ? "On" : "Off")
        hotkeyStates[key] := newState

        status := newState ? "ENABLED" : "DISABLED"
        MsgBox("Toggled " key ": " status, "Hotkey Manager")
    }

    /**
    * Shows all hotkey states
    */
    ShowStates() {
        static hotkeyStates
        list := "Hotkey States:`n" . RepeatChar("-", 40) . "`n"

        for key, state in hotkeyStates {
            status := state ? "✓ Enabled" : "✗ Disabled"
            list .= key . " → " . status . "`n"
        }

        MsgBox(list, "Hotkey States")
    }

    RepeatChar(char, count) {
        result := ""
        Loop count
        result .= char
        return result
    }

    ; Create managed hotkeys
    CreateManagedHotkey("F2", (*) => MsgBox("F2 activated"), true)
    CreateManagedHotkey("F3", (*) => MsgBox("F3 activated"), true)
    CreateManagedHotkey("F4", (*) => MsgBox("F4 activated"), false)

    ; Control hotkeys
    Hotkey("^!F2", (*) => ToggleHotkey("F2"))
    Hotkey("^!F3", (*) => ToggleHotkey("F3"))
    Hotkey("^!F4", (*) => ToggleHotkey("F4"))
    Hotkey("^!s", (*) => ShowStates())

    ShowStates()
}

; ============================================================================
; Example 3: Conditional Hotkey Enabling
; ============================================================================

/**
* Shows how to enable/disable hotkeys based on conditions like
* active window, time, or application state.
*
* @example
* ; Hotkeys that enable/disable based on conditions
*/
Example3_ConditionalEnabling() {
    /**
    * Enables hotkeys only when Notepad is active
    */
    UpdateNotepadHotkeys() {
        if WinActive("ahk_exe notepad.exe") {
            Hotkey("^!n", "On")
            Hotkey("^!s", "On")
            return true
        } else {
            Hotkey("^!n", "Off")
            Hotkey("^!s", "Off")
            return false
        }
    }

    ; Create Notepad-specific hotkeys
    Hotkey("^!n", (*) => SendText("New note: " FormatTime()))
    Hotkey("^!s", (*) => SendText("---Section---"))

    ; Initially disable them
    Hotkey("^!n", "Off")
    Hotkey("^!s", "Off")

    ; Check window every 500ms
    SetTimer(UpdateNotepadHotkeys, 500)

    ; Create mode toggle
    static textMode := false

    Hotkey("^!m", (*) {
        static textMode
        textMode := !textMode

        if textMode {
            Hotkey("^1", "On")
            Hotkey("^2", "On")
            Hotkey("^3", "On")
            MsgBox("Text mode ENABLED`n`nCtrl+1,2,3 now insert text", "Mode")
        } else {
            Hotkey("^1", "Off")
            Hotkey("^2", "Off")
            Hotkey("^3", "Off")
            MsgBox("Text mode DISABLED", "Mode")
        }
    })

    ; Text insertion hotkeys (initially disabled)
    Hotkey("^1", (*) => SendText("Text snippet 1"))
    Hotkey("^2", (*) => SendText("Text snippet 2"))
    Hotkey("^3", (*) => SendText("Text snippet 3"))
    Hotkey("^1", "Off")
    Hotkey("^2", "Off")
    Hotkey("^3", "Off")

    MsgBox(
    "Conditional Hotkey Enabling`n`n"
    "1. Notepad hotkeys (auto-enabled in Notepad):`n"
    "   Ctrl+Alt+N - Insert note`n"
    "   Ctrl+Alt+S - Insert section`n`n"
    "2. Text mode (toggle with Ctrl+Alt+M):`n"
    "   Ctrl+1,2,3 - Insert snippets`n`n"
    "Text mode is currently DISABLED",
    "Example 3"
    )
}

; ============================================================================
; Example 4: Hotkey Groups Management
; ============================================================================

/**
* Demonstrates managing groups of hotkeys together,
* enabling/disabling entire sets at once.
*
* @example
* ; Manage hotkey groups for different purposes
*/
Example4_HotkeyGroups() {
    ; Define hotkey groups
    static groups := Map(
    "Editing", [
    {
        key: "^!c", action: (*) => SendText("Copy"), desc: "Copy"},
        {
            key: "^!v", action: (*) => SendText("Paste"), desc: "Paste"},
            {
                key: "^!x", action: (*) => SendText("Cut"), desc: "Cut"
            }
            ],
            "Navigation", [
            {
                key: "^!h", action: (*) => Send("{Home}"), desc: "Home"},
                {
                    key: "^!e", action: (*) => Send("{End}"), desc: "End"},
                    {
                        key: "^!u", action: (*) => Send("{PgUp}"), desc: "Page Up"},
                        {
                            key: "^!d", action: (*) => Send("{PgDn}"), desc: "Page Down"
                        }
                        ],
                        "Formatting", [
                        {
                            key: "^!b", action: (*) => SendText("**bold**"), desc: "Bold"},
                            {
                                key: "^!i", action: (*) => SendText("*italic*"), desc: "Italic"},
                                {
                                    key: "^!u", action: (*) => SendText("__underline__"), desc: "Underline"
                                }
                                ]
                                )

                                static groupStates := Map()

                                /**
                                * Initializes all hotkey groups
                                */
                                InitializeGroups() {
                                    static groups, groupStates

                                    for groupName, hotkeys in groups {
                                        for item in hotkeys {
                                            Hotkey(item.key, item.action)
                                            Hotkey(item.key, "Off") ; Start disabled
                                        }
                                        groupStates[groupName] := false
                                    }
                                }

                                /**
                                * Enables a hotkey group
                                */
                                EnableGroup(groupName) {
                                    static groups, groupStates

                                    if !groups.Has(groupName)
                                    return false

                                    for item in groups[groupName] {
                                        Hotkey(item.key, "On")
                                    }
                                    groupStates[groupName] := true
                                    return true
                                }

                                /**
                                * Disables a hotkey group
                                */
                                DisableGroup(groupName) {
                                    static groups, groupStates

                                    if !groups.Has(groupName)
                                    return false

                                    for item in groups[groupName] {
                                        Hotkey(item.key, "Off")
                                    }
                                    groupStates[groupName] := false
                                    return true
                                }

                                /**
                                * Toggles a hotkey group
                                */
                                ToggleGroup(groupName) {
                                    static groupStates

                                    if !groupStates.Has(groupName)
                                    return false

                                    if groupStates[groupName]
                                    DisableGroup(groupName)
                                    else
                                    EnableGroup(groupName)

                                    ShowGroupStatus()
                                    return true
                                }

                                /**
                                * Shows status of all groups
                                */
                                ShowGroupStatus() {
                                    static groups, groupStates

                                    list := "Hotkey Group Status:`n" . Repeat("-", 50) . "`n`n"

                                    for groupName, hotkeys in groups {
                                        state := groupStates[groupName]
                                        status := state ? "✓ ENABLED" : "✗ DISABLED"
                                        list .= groupName . ": " . status . "`n"

                                        for item in hotkeys {
                                            prefix := state ? "  ✓ " : "  ✗ "
                                            list .= prefix . item.key . " - " . item.desc . "`n"
                                        }
                                        list .= "`n"
                                    }

                                    MsgBox(list, "Group Status")
                                }

                                Repeat(char, count) {
                                    result := ""
                                    Loop count
                                    result .= char
                                    return result
                                }

                                ; Initialize
                                InitializeGroups()

                                ; Control hotkeys
                                Hotkey("F5", (*) => ToggleGroup("Editing"))
                                Hotkey("F6", (*) => ToggleGroup("Navigation"))
                                Hotkey("F7", (*) => ToggleGroup("Formatting"))
                                Hotkey("F8", (*) => ShowGroupStatus())

                                ShowGroupStatus()
                            }

                            ; ============================================================================
                            ; Example 5: Temporary Hotkey Suspension
                            ; ============================================================================

                            /**
                            * Implements temporary suspension of hotkeys with automatic restoration.
                            *
                            * @example
                            * ; Suspend hotkeys for a specific duration
                            */
                            Example5_TemporarySuspension() {
                                ; Tracked hotkeys for suspension
                                static trackedHotkeys := []

                                /**
                                * Temporarily disables hotkeys for specified duration
                                */
                                SuspendHotkeysFor(duration, keys*) {
                                    static trackedHotkeys

                                    ; Disable all specified hotkeys
                                    for key in keys {
                                        Hotkey(key, "Off")
                                        trackedHotkeys.Push(key)
                                    }

                                    MsgBox(
                                    "Hotkeys suspended for " duration "ms`n`n"
                                    "Suspended keys: " Join(keys, ", "),
                                    "Suspension Active"
                                    )

                                    ; Set timer to re-enable
                                    SetTimer(() => RestoreHotkeys(keys*), -duration)
                                }

                                /**
                                * Restores previously suspended hotkeys
                                */
                                RestoreHotkeys(keys*) {
                                    for key in keys {
                                        Hotkey(key, "On")
                                    }

                                    MsgBox(
                                    "Hotkeys restored!`n`n"
                                    "Restored keys: " Join(keys, ", "),
                                    "Suspension Ended"
                                    )
                                }

                                /**
                                * Joins array elements with delimiter
                                */
                                Join(arr, delim := ", ") {
                                    result := ""
                                    for i, item in arr {
                                        result .= item
                                        if i < arr.Length
                                        result .= delim
                                    }
                                    return result
                                }

                                ; Create test hotkeys
                                Hotkey("F9", (*) => MsgBox("F9 active", "Test"))
                                Hotkey("F10", (*) => MsgBox("F10 active", "Test"))
                                Hotkey("F11", (*) => MsgBox("F11 active", "Test"))

                                ; Suspension controls
                                Hotkey("^!s3", (*) => SuspendHotkeysFor(3000, "F9", "F10", "F11"))
                                Hotkey("^!s5", (*) => SuspendHotkeysFor(5000, "F9", "F10", "F11"))

                                MsgBox(
                                "Temporary Suspension System`n`n"
                                "Test hotkeys: F9, F10, F11`n`n"
                                "Ctrl+Alt+S3 - Suspend for 3 seconds`n"
                                "Ctrl+Alt+S5 - Suspend for 5 seconds`n`n"
                                "All hotkeys currently ENABLED",
                                "Example 5"
                                )
                            }

                            ; ============================================================================
                            ; Example 6: Application-Aware Hotkey Management
                            ; ============================================================================

                            /**
                            * Automatically enables/disables hotkeys based on the active application.
                            *
                            * @example
                            * ; Different hotkeys active for different applications
                            */
                            Example6_ApplicationAware() {
                                ; Application-specific hotkey configurations
                                static appConfigs := Map(
                                "ahk_exe notepad.exe", [
                                {
                                    key: "^!i", action: (*) => SendText("Important: "), enabled: false
                                }
                                ],
                                "ahk_exe Code.exe", [
                                {
                                    key: "^!f", action: (*) => SendText("function() {}"), enabled: false
                                }
                                ],
                                "default", [
                                {
                                    key: "^!h", action: (*) => MsgBox("Default hotkey"), enabled: false
                                }
                                ]
                                )

                                /**
                                * Updates hotkeys based on active window
                                */
                                UpdateForActiveWindow() {
                                    static appConfigs

                                    ; Disable all app-specific hotkeys first
                                    for appId, hotkeys in appConfigs {
                                        for item in hotkeys {
                                            try Hotkey(item.key, "Off")
                                            item.enabled := false
                                        }
                                    }

                                    ; Find matching config
                                    activeConfig := appConfigs["default"]

                                    for appId, config in appConfigs {
                                        if appId != "default" && WinActive(appId) {
                                            activeConfig := config
                                            break
                                        }
                                    }

                                    ; Enable hotkeys for active config
                                    for item in activeConfig {
                                        try {
                                            Hotkey(item.key, item.action)
                                            Hotkey(item.key, "On")
                                            item.enabled := true
                                        }
                                    }
                                }

                                /**
                                * Shows currently enabled hotkeys
                                */
                                ShowActiveHotkeys() {
                                    static appConfigs

                                    list := "Active Hotkeys for Current Window:`n"
                                    list .= Duplicate("-", 45) . "`n`n"

                                    count := 0
                                    for appId, hotkeys in appConfigs {
                                        for item in hotkeys {
                                            if item.enabled {
                                                list .= "✓ " . item.key . " (enabled)`n"
                                                count++
                                            }
                                        }
                                    }

                                    if count = 0
                                    list .= "No hotkeys enabled for this window"

                                    MsgBox(list, "Active Hotkeys")
                                }

                                Duplicate(char, count) {
                                    result := ""
                                    Loop count
                                    result .= char
                                    return result
                                }

                                ; Update on window change
                                SetTimer(UpdateForActiveWindow, 500)

                                ; Initial update
                                UpdateForActiveWindow()

                                ; Status hotkey
                                Hotkey("^!?", (*) => ShowActiveHotkeys())

                                MsgBox(
                                "Application-Aware Hotkey System`n`n"
                                "Hotkeys automatically enable/disable based on`n"
                                "the active window.`n`n"
                                "Try switching between Notepad, VS Code,`n"
                                "or other applications.`n`n"
                                "Ctrl+Alt+? - Show active hotkeys",
                                "Example 6"
                                )
                            }

                            ; ============================================================================
                            ; Example 7: Smart Hotkey Disabling During User Input
                            ; ============================================================================

                            /**
                            * Automatically disables certain hotkeys when user is typing
                            * to prevent interference.
                            *
                            * @example
                            * ; Disable hotkeys during active typing
                            */
                            Example7_SmartInputDetection() {
                                static isTyping := false
                                static typingTimer := 0
                                static inputSensitiveHotkeys := ["^Space", "^Enter", "^Tab"]

                                /**
                                * Detects if user is actively typing
                                */
                                CheckTypingState() {
                                    static isTyping, typingTimer, inputSensitiveHotkeys

                                    currentTime := A_TickCount

                                    ; If recent input detected, consider user as typing
                                    if (currentTime - typingTimer < 2000) {
                                        if !isTyping {
                                            ; Disable input-sensitive hotkeys
                                            for key in inputSensitiveHotkeys {
                                                try Hotkey(key, "Off")
                                            }
                                            isTyping := true
                                        }
                                    } else {
                                        if isTyping {
                                            ; Re-enable input-sensitive hotkeys
                                            for key in inputSensitiveHotkeys {
                                                try Hotkey(key, "On")
                                            }
                                            isTyping := false
                                        }
                                    }
                                }

                                /**
                                * Input hook to detect typing
                                */
                                ih := InputHook("L0 T2")
                                ih.OnChar := (ihObj, char) => UpdateTypingTimer()
                                ih.Start()

                                UpdateTypingTimer() {
                                    static typingTimer
                                    typingTimer := A_TickCount
                                }

                                ; Create input-sensitive hotkeys
                                Hotkey("^Space", (*) => MsgBox("Ctrl+Space executed", "Hotkey"))
                                Hotkey("^Enter", (*) => MsgBox("Ctrl+Enter executed", "Hotkey"))
                                Hotkey("^Tab", (*) => MsgBox("Ctrl+Tab executed", "Hotkey"))

                                ; Monitor typing state
                                SetTimer(CheckTypingState, 250)

                                ; Status checker
                                Hotkey("^!?", (*) {
                                    static isTyping
                                    status := isTyping ? "DISABLED (typing detected)" : "ENABLED"
                                    MsgBox(
                                    "Input-sensitive hotkeys are: " status "`n`n"
                                    "Try typing in a text editor, then wait 2 seconds",
                                    "Typing Detection"
                                    )
                                })

                                MsgBox(
                                "Smart Input Detection System`n`n"
                                "Input-sensitive hotkeys (Ctrl+Space, Ctrl+Enter, Ctrl+Tab)`n"
                                "automatically disable when typing is detected.`n`n"
                                "Hotkeys re-enable 2 seconds after typing stops.`n`n"
                                "Ctrl+Alt+? - Check status",
                                "Example 7"
                                )
                            }

                            ; ============================================================================
                            ; Main Execution
                            ; ============================================================================

                            ShowExampleMenu() {
                                menu := "
                                (
                                Enable/Disable Hotkey Management Examples
                                ==========================================

                                Choose an example:

                                1. Basic Enable/Disable
                                2. State Tracker
                                3. Conditional Enabling
                                4. Hotkey Groups
                                5. Temporary Suspension
                                6. Application-Aware
                                7. Smart Input Detection

                                Press Ctrl+Alt+[1-7] to run examples
                                )"

                                MsgBox(menu, "Examples Menu")
                            }

                            ; Create example launcher hotkeys
                            Hotkey("^!1", (*) => Example1_BasicEnableDisable())
                            Hotkey("^!2", (*) => Example2_StateTracker())
                            Hotkey("^!3", (*) => Example3_ConditionalEnabling())
                            Hotkey("^!4", (*) => Example4_HotkeyGroups())
                            Hotkey("^!5", (*) => Example5_TemporarySuspension())
                            Hotkey("^!6", (*) => Example6_ApplicationAware())
                            Hotkey("^!7", (*) => Example7_SmartInputDetection())

                            ShowExampleMenu()
