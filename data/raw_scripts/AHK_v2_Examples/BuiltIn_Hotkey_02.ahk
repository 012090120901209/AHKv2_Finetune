#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Hotkey() Function - Dynamic Hotkey Management Examples
 * ============================================================================
 *
 * This file demonstrates advanced dynamic hotkey management using the
 * Hotkey() function. Shows how to modify, replace, and manage hotkeys
 * during runtime based on application state and user input.
 *
 * Features demonstrated:
 * - Dynamic hotkey assignment
 * - Runtime hotkey modification
 * - Hotkey replacement and updating
 * - State-based hotkey systems
 * - User-configurable hotkeys
 *
 * @author AutoHotkey v2 Documentation Team
 * @version 1.0.0
 * @see https://www.autohotkey.com/docs/v2/lib/Hotkey.htm
 */

; ============================================================================
; Example 1: Dynamic Hotkey Assignment
; ============================================================================

/**
 * Demonstrates assigning different actions to the same hotkey based on
 * application state or mode.
 *
 * @example
 * ; Press F9 to cycle through different hotkey behaviors
 */
Example1_DynamicAssignment() {
    static mode := 1
    static modes := [
        {name: "Text Mode", action: (*) => SendText("Hello World!")},
        {name: "Number Mode", action: (*) => SendText(A_Now)},
        {name: "Symbol Mode", action: (*) => SendText("★☆✓✗→←")}
    ]

    ; F9 cycles through modes and updates F8's behavior
    Hotkey("F9", (*) {
        mode := Mod(mode, modes.Length) + 1
        currentMode := modes[mode]

        ; Update F8 hotkey with new action
        Hotkey("F8", currentMode.action)

        MsgBox(
            "Mode changed to: " currentMode.name "`n`n"
            "Press F8 to test the new behavior",
            "Mode Switcher"
        )
    })

    ; Set initial F8 behavior
    Hotkey("F8", modes[1].action)

    MsgBox(
        "Dynamic Hotkey Assignment Demo`n`n"
        "F9 - Switch modes (Text/Number/Symbol)`n"
        "F8 - Execute current mode action`n`n"
        "Current mode: Text Mode",
        "Example 1"
    )
}

; ============================================================================
; Example 2: Runtime Hotkey Builder
; ============================================================================

/**
 * Creates a system for building and modifying hotkeys at runtime
 * based on user input.
 *
 * @example
 * ; Create custom hotkeys through a GUI interface
 */
Example2_RuntimeBuilder() {
    ; Storage for user-defined hotkeys
    global customHotkeys := Map()

    CreateHotkeyBuilder() {
        builderGui := Gui("+AlwaysOnTop", "Hotkey Builder")

        builderGui.AddText("", "Key Combination:")
        keyEdit := builderGui.AddEdit("w200", "^!F9")

        builderGui.AddText("", "Action (Text to send):")
        actionEdit := builderGui.AddEdit("w200", "Custom Text")

        builderGui.AddButton("w200", "Create Hotkey").OnEvent("Click", (*) => CreateCustom())
        builderGui.AddButton("w200", "List All Hotkeys").OnEvent("Click", (*) => ListCustom())

        CreateCustom(*) {
            global customHotkeys
            key := keyEdit.Value
            action := actionEdit.Value

            try {
                Hotkey(key, (*) => SendText(action))
                customHotkeys[key] := action
                MsgBox("Hotkey created: " key "`nAction: " action, "Success")
            } catch Error as err {
                MsgBox("Error creating hotkey: " err.Message, "Error")
            }
        }

        ListCustom(*) {
            global customHotkeys
            if customHotkeys.Count = 0 {
                MsgBox("No custom hotkeys created yet.", "Hotkey List")
                return
            }

            list := "Custom Hotkeys:`n" . RepeatChar("-", 40) . "`n"
            for key, action in customHotkeys {
                list .= key . " → " . action . "`n"
            }
            MsgBox(list, "Hotkey List")
        }

        builderGui.Show()
    }

    RepeatChar(char, count) {
        result := ""
        Loop count
            result .= char
        return result
    }

    CreateHotkeyBuilder()

    MsgBox(
        "Runtime Hotkey Builder`n`n"
        "Use the GUI to create custom hotkeys`n"
        "Enter a key combination and text action",
        "Example 2"
    )
}

; ============================================================================
; Example 3: State Machine with Dynamic Hotkeys
; ============================================================================

/**
 * Implements a state machine where hotkeys change behavior based on
 * the current state of the application.
 *
 * @example
 * ; Different states have different hotkey behaviors
 */
Example3_StateMachine() {
    ; Define states and their hotkey configurations
    static currentState := "idle"
    static states := Map(
        "idle", Map(
            "F10", (*) => ChangeState("working"),
            "desc", "Idle State - F10 to start working"
        ),
        "working", Map(
            "F10", (*) => ChangeState("break"),
            "F11", (*) => SendText("Working on task..."),
            "desc", "Working State - F10 for break, F11 to insert text"
        ),
        "break", Map(
            "F10", (*) => ChangeState("idle"),
            "F11", (*) => SendText("On break..."),
            "desc", "Break State - F10 to finish, F11 to insert text"
        )
    )

    ChangeState(newState) {
        static currentState
        currentState := newState
        LoadStateHotkeys(newState)

        MsgBox(
            "State changed to: " newState "`n`n" .
            states[newState]["desc"],
            "State Machine"
        )
    }

    LoadStateHotkeys(state) {
        stateConfig := states[state]

        ; Clear previous F11 if it exists (only in some states)
        try Hotkey("F11", "Off")

        ; Load hotkeys for this state
        for key, value in stateConfig {
            if key != "desc" && Type(value) = "Func" {
                Hotkey(key, value)
            }
        }
    }

    ; Initialize with idle state
    LoadStateHotkeys("idle")

    MsgBox(
        "State Machine Hotkey System`n`n"
        "States: idle → working → break → idle`n`n"
        "F10 - Transition to next state`n"
        "F11 - State-specific action (when available)`n`n"
        "Current state: idle",
        "Example 3"
    )
}

; ============================================================================
; Example 4: Hotkey Remapping System
; ============================================================================

/**
 * Creates a system for remapping hotkeys on the fly, allowing users
 * to swap or reassign key bindings.
 *
 * @example
 * ; Remap common shortcuts to different keys
 */
Example4_RemappingSystem() {
    ; Default hotkey mappings
    static mappings := Map(
        "Copy", "^c",
        "Paste", "^v",
        "Cut", "^x",
        "Undo", "^z"
    )

    ; Actions for each operation
    static actions := Map(
        "Copy", (*) => MsgBox("Copy operation", "Copy"),
        "Paste", (*) => MsgBox("Paste operation", "Paste"),
        "Cut", (*) => MsgBox("Cut operation", "Cut"),
        "Undo", (*) => MsgBox("Undo operation", "Undo")
    )

    /**
     * Applies current mappings to hotkeys
     */
    ApplyMappings() {
        ; First disable all old hotkeys
        for operation, oldKey in mappings {
            try Hotkey(oldKey, "Off")
        }

        ; Apply new mappings
        for operation, key in mappings {
            if actions.Has(operation) {
                Hotkey(key, actions[operation])
            }
        }
    }

    /**
     * Remaps a specific operation to a new key
     */
    RemapOperation(operation, newKey) {
        if !mappings.Has(operation) {
            MsgBox("Unknown operation: " operation, "Error")
            return false
        }

        oldKey := mappings[operation]

        ; Try to create new mapping
        try {
            Hotkey(oldKey, "Off")
            Hotkey(newKey, actions[operation])
            mappings[operation] := newKey
            MsgBox(
                "Remapped " operation "`n"
                "From: " oldKey "`n"
                "To: " newKey,
                "Remap Success"
            )
            return true
        } catch Error as err {
            MsgBox("Remap failed: " err.Message, "Error")
            return false
        }
    }

    /**
     * Shows current mappings
     */
    ShowMappings() {
        list := "Current Hotkey Mappings:`n" . RepeatStr("-", 40) . "`n"
        for operation, key in mappings {
            list .= operation . ": " . key . "`n"
        }
        MsgBox(list, "Mappings")
    }

    RepeatStr(char, count) {
        result := ""
        Loop count
            result .= char
        return result
    }

    ; Initialize default mappings
    ApplyMappings()

    ; Example: Remap Copy to Ctrl+Alt+C
    ; RemapOperation("Copy", "^!c")

    ; Create helper hotkeys
    Hotkey("^!m", (*) => ShowMappings())

    ShowMappings()
}

; ============================================================================
; Example 5: Profile-Based Hotkey System
; ============================================================================

/**
 * Implements a profile system where users can switch between different
 * sets of hotkeys for different tasks or applications.
 *
 * @example
 * ; Switch between Work, Gaming, and Default profiles
 */
Example5_ProfileSystem() {
    ; Define profiles with their hotkey sets
    static profiles := Map(
        "Default", [
            {key: "^!a", action: (*) => MsgBox("Default Action A"), desc: "Action A"},
            {key: "^!b", action: (*) => MsgBox("Default Action B"), desc: "Action B"}
        ],
        "Work", [
            {key: "^!a", action: (*) => SendText("Work Document Template"), desc: "Template"},
            {key: "^!b", action: (*) => SendText(FormatTime(, "yyyy-MM-dd")), desc: "Date"},
            {key: "^!c", action: (*) => SendText("Meeting Notes:`n"), desc: "Notes"}
        ],
        "Gaming", [
            {key: "^!a", action: (*) => MsgBox("Quick Save"), desc: "Save"},
            {key: "^!b", action: (*) => MsgBox("Quick Load"), desc: "Load"},
            {key: "^!c", action: (*) => MsgBox("Screenshot"), desc: "Screenshot"}
        ]
    )

    static currentProfile := "Default"
    static activeHotkeys := []

    /**
     * Switches to a different profile
     */
    SwitchProfile(profileName) {
        static currentProfile, activeHotkeys, profiles

        if !profiles.Has(profileName) {
            MsgBox("Profile not found: " profileName, "Error")
            return
        }

        ; Disable all active hotkeys
        for hotkey in activeHotkeys {
            try Hotkey(hotkey, "Off")
        }
        activeHotkeys := []

        ; Load new profile
        profile := profiles[profileName]
        for item in profile {
            Hotkey(item.key, item.action)
            activeHotkeys.Push(item.key)
        }

        currentProfile := profileName

        ; Build description
        desc := "Profile: " profileName "`n`n"
        for item in profile {
            desc .= item.key . " - " . item.desc . "`n"
        }

        MsgBox(desc, "Profile Loaded")
    }

    /**
     * Cycles through available profiles
     */
    CycleProfiles() {
        static currentProfile, profiles
        profileNames := []
        for name in profiles {
            profileNames.Push(name)
        }

        ; Find current index
        currentIndex := 1
        for i, name in profileNames {
            if name = currentProfile {
                currentIndex := i
                break
            }
        }

        ; Get next profile
        nextIndex := Mod(currentIndex, profileNames.Length) + 1
        SwitchProfile(profileNames[nextIndex])
    }

    ; Create profile switcher hotkey
    Hotkey("^!p", (*) => CycleProfiles())

    ; Load default profile
    SwitchProfile("Default")

    MsgBox(
        "Profile System Initialized`n`n"
        "Ctrl+Alt+P - Cycle through profiles`n"
        "(Default → Work → Gaming → Default)`n`n"
        "Each profile has different hotkey behaviors",
        "Example 5"
    )
}

; ============================================================================
; Example 6: Hotkey Priority and Override System
; ============================================================================

/**
 * Demonstrates a priority-based system where hotkeys can be temporarily
 * overridden and then restored.
 *
 * @example
 * ; Temporarily override hotkeys with high-priority actions
 */
Example6_PrioritySystem() {
    ; Hotkey stack for each key combination
    static hotkeyStacks := Map()

    /**
     * Pushes a new hotkey handler (higher priority)
     */
    PushHotkey(key, callback, description := "") {
        static hotkeyStacks

        if !hotkeyStacks.Has(key) {
            hotkeyStacks[key] := []
        }

        stack := hotkeyStacks[key]
        stack.Push({callback: callback, desc: description})
        Hotkey(key, callback)

        return true
    }

    /**
     * Pops the top hotkey handler (restores previous)
     */
    PopHotkey(key) {
        static hotkeyStacks

        if !hotkeyStacks.Has(key) || hotkeyStacks[key].Length = 0 {
            return false
        }

        stack := hotkeyStacks[key]
        stack.Pop()

        if stack.Length > 0 {
            ; Restore previous handler
            Hotkey(key, stack[stack.Length].callback)
        } else {
            ; No more handlers, disable hotkey
            Hotkey(key, "Off")
        }

        return true
    }

    /**
     * Shows the stack for a key
     */
    ShowStack(key) {
        static hotkeyStacks

        if !hotkeyStacks.Has(key) {
            MsgBox("No stack for key: " key, "Stack Info")
            return
        }

        stack := hotkeyStacks[key]
        list := "Stack for " key ":`n" . StrRepeat("-", 30) . "`n"

        for i, item in stack {
            desc := item.desc != "" ? item.desc : "No description"
            list .= i . ". " . desc . (i = stack.Length ? " ← Active" : "") . "`n"
        }

        MsgBox(list, "Hotkey Stack")
    }

    StrRepeat(char, count) {
        result := ""
        Loop count
            result .= char
        return result
    }

    ; Example usage
    ; Base handler
    PushHotkey("F7", (*) => MsgBox("Base handler"), "Base")

    ; Override with high priority
    PushHotkey("F7", (*) => MsgBox("Override 1"), "Override 1")
    PushHotkey("F7", (*) => MsgBox("Override 2"), "Override 2")

    ; Hotkey to show stack
    Hotkey("F6", (*) => ShowStack("F7"))

    ; Hotkey to pop
    Hotkey("F5", (*) {
        if PopHotkey("F7") {
            MsgBox("Popped top handler. F7 restored to previous.", "Pop")
        } else {
            MsgBox("No more handlers to pop.", "Pop")
        }
    })

    MsgBox(
        "Hotkey Priority System`n`n"
        "F7 - Execute current top handler`n"
        "F6 - Show F7 stack`n"
        "F5 - Pop top handler from F7`n`n"
        "Current: Override 2 (top of stack)",
        "Example 6"
    )
}

; ============================================================================
; Example 7: Time-Based Dynamic Hotkeys
; ============================================================================

/**
 * Creates hotkeys that change behavior based on time of day or
 * schedule.
 *
 * @example
 * ; Different hotkey behaviors during work hours vs. after hours
 */
Example7_TimeBasedHotkeys() {
    /**
     * Checks if current time is within work hours
     */
    IsWorkHours() {
        currentHour := A_Hour + 0
        return (currentHour >= 9 && currentHour < 17)
    }

    /**
     * Updates hotkeys based on time
     */
    UpdateTimeBasedHotkeys() {
        if IsWorkHours() {
            ; Work hours hotkeys
            Hotkey("^!t", (*) => SendText("Professional email template"))
            Hotkey("^!g", (*) => MsgBox("Work mode greeting", "Work"))
        } else {
            ; After hours hotkeys
            Hotkey("^!t", (*) => SendText("Casual message"))
            Hotkey("^!g", (*) => MsgBox("Casual mode greeting", "Personal"))
        }

        status := IsWorkHours() ? "Work Hours" : "After Hours"
        return status
    }

    ; Set up timer to check every hour
    SetTimer(UpdateTimeBasedHotkeys, 3600000) ; 1 hour

    ; Initial setup
    status := UpdateTimeBasedHotkeys()

    MsgBox(
        "Time-Based Hotkey System`n`n"
        "Current mode: " status "`n`n"
        "Ctrl+Alt+T - Insert template (changes by time)`n"
        "Ctrl+Alt+G - Show greeting (changes by time)`n`n"
        "Work hours: 9 AM - 5 PM`n"
        "After hours: 5 PM - 9 AM",
        "Example 7"
    )
}

; ============================================================================
; Main Execution
; ============================================================================

ShowExampleMenu() {
    menu := "
    (
    Dynamic Hotkey Management Examples
    ===================================

    Choose an example:

    1. Dynamic Assignment
    2. Runtime Builder
    3. State Machine
    4. Remapping System
    5. Profile System
    6. Priority/Override System
    7. Time-Based Hotkeys

    Press Ctrl+Alt+[1-7] to run examples
    )"

    MsgBox(menu, "Examples Menu")
}

; Create example launcher hotkeys
Hotkey("^!1", (*) => Example1_DynamicAssignment())
Hotkey("^!2", (*) => Example2_RuntimeBuilder())
Hotkey("^!3", (*) => Example3_StateMachine())
Hotkey("^!4", (*) => Example4_RemappingSystem())
Hotkey("^!5", (*) => Example5_ProfileSystem())
Hotkey("^!6", (*) => Example6_PrioritySystem())
Hotkey("^!7", (*) => Example7_TimeBasedHotkeys())

ShowExampleMenu()
