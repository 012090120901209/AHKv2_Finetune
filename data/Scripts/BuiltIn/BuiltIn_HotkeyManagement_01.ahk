#Requires AutoHotkey v2.0

/**
* ============================================================================
* A_ThisHotkey - Hotkey Identification and Dynamic Behavior
* ============================================================================
*
* Demonstrates using the A_ThisHotkey built-in variable to identify which
* hotkey triggered the current code, enabling smart multi-hotkey handlers
* and dynamic behavior.
*
* Features:
* - Identifying the triggering hotkey
* - Shared handlers for multiple hotkeys
* - Dynamic behavior based on hotkey
* - Hotkey history tracking
* - Context-sensitive hotkey responses
*
* @author AutoHotkey v2 Documentation Team
* @version 1.0.0
* @see https://www.autohotkey.com/docs/v2/lib/A_ThisHotkey.htm
*/

; ============================================================================
; Example 1: Basic A_ThisHotkey Usage
; ============================================================================

Example1_BasicUsage() {
    /**
    * Single handler for multiple hotkeys
    */
    SharedHandler(*) {
        MsgBox(
        "You pressed: " . A_ThisHotkey . "`n`n"
        "Time: " . FormatTime(, "HH:mm:ss"),
        "Hotkey Info"
        )
    }

    ; Assign same handler to multiple hotkeys
    Hotkey("F1", SharedHandler)
    Hotkey("F2", SharedHandler)
    Hotkey("F3", SharedHandler)
    Hotkey("F4", SharedHandler)

    MsgBox(
    "Basic A_ThisHotkey Usage`n`n"
    "Press F1, F2, F3, or F4`n`n"
    "Each shows which key was pressed using A_ThisHotkey",
    "Example 1"
    )
}

; ============================================================================
; Example 2: Dynamic Behavior Based on Hotkey
; ============================================================================

Example2_DynamicBehavior() {
    /**
    * Handler with different behavior per hotkey
    */
    NumberHandler(*) {
        switch A_ThisHotkey {
            case "^1":
            SendText("One")
            case "^2":
            SendText("Two")
            case "^3":
            SendText("Three")
            case "^4":
            SendText("Four")
            case "^5":
            SendText("Five")
            default:
            SendText("Unknown")
        }
    }

    ; Create number hotkeys
    Loop 5 {
        Hotkey("^" . A_Index, NumberHandler)
    }

    /**
    * Arrow key handler with direction info
    */
    DirectionHandler(*) {
        switch A_ThisHotkey {
            case "^Up":
            direction := "North ↑"
            case "^Down":
            direction := "South ↓"
            case "^Left":
            direction := "West ←"
            case "^Right":
            direction := "East →"
        }

        ToolTip("Direction: " . direction)
        SetTimer(() => ToolTip(), -1500)
    }

    Hotkey("^Up", DirectionHandler)
    Hotkey("^Down", DirectionHandler)
    Hotkey("^Left", DirectionHandler)
    Hotkey("^Right", DirectionHandler)

    MsgBox(
    "Dynamic Behavior Example`n`n"
    "Ctrl+1-5 → Insert number words`n"
    "Ctrl+Arrows → Show directions`n`n"
    "Same handler, different behavior based on A_ThisHotkey",
    "Example 2"
    )
}

; ============================================================================
; Example 3: Hotkey History Tracker
; ============================================================================

Example3_HistoryTracker() {
    global hotkeyHistory := []
    global maxHistorySize := 10

    /**
    * Tracks hotkey usage
    */
    TrackHotkey(*) {
        global hotkeyHistory, maxHistorySize

        ; Add to history
        hotkeyHistory.Push({
            key: A_ThisHotkey,
            time: FormatTime(, "HH:mm:ss"),
            tick: A_TickCount
        })

        ; Trim history if too long
        while hotkeyHistory.Length > maxHistorySize {
            hotkeyHistory.RemoveAt(1)
        }

        ; Perform action based on hotkey
        switch A_ThisHotkey {
            case "^!h":
            ShowHistory()
            case "^!c":
            ClearHistory()
            default:
            MsgBox("Hotkey pressed: " . A_ThisHotkey, "Tracked")
        }
    }

    /**
    * Shows hotkey history
    */
    ShowHistory() {
        global hotkeyHistory

        if hotkeyHistory.Length = 0 {
            MsgBox("No hotkey history yet!", "History")
            return
        }

        list := "Hotkey History (Last " . hotkeyHistory.Length . "):`n"
        list .= Repeat("=", 50) . "`n`n"

        for index, entry in hotkeyHistory {
            list .= index . ". " . entry.key . " at " . entry.time . "`n"
        }

        MsgBox(list, "Hotkey History")
    }

    /**
    * Clears history
    */
    ClearHistory() {
        global hotkeyHistory
        hotkeyHistory := []
        MsgBox("History cleared!", "Clear")
    }

    Repeat(char, count) {
        result := ""
        Loop count
        result .= char
        return result
    }

    ; Create tracked hotkeys
    Hotkey("^!1", TrackHotkey)
    Hotkey("^!2", TrackHotkey)
    Hotkey("^!3", TrackHotkey)
    Hotkey("^!h", TrackHotkey) ; Show history
    Hotkey("^!c", TrackHotkey) ; Clear history

    MsgBox(
    "Hotkey History Tracker`n`n"
    "Ctrl+Alt+1,2,3 → Tracked hotkeys`n"
    "Ctrl+Alt+H → Show history`n"
    "Ctrl+Alt+C → Clear history`n`n"
    "Last 10 hotkey presses are remembered",
    "Example 3"
    )
}

; ============================================================================
; Example 4: Modifier Detection
; ============================================================================

Example4_ModifierDetection() {
    /**
    * Analyzes the hotkey modifiers
    */
    AnalyzeHotkey(*) {
        hotkey := A_ThisHotkey
        modifiers := ""
        key := ""

        ; Parse modifiers
        if InStr(hotkey, "^")
        modifiers .= "Ctrl+"
        if InStr(hotkey, "!")
        modifiers .= "Alt+"
        if InStr(hotkey, "+")
        modifiers .= "Shift+"
        if InStr(hotkey, "#")
        modifiers .= "Win+"

        ; Extract base key
        key := RegExReplace(hotkey, "[^!+#]+", "")
        if key = ""
        key := hotkey

        info := "Hotkey Analysis`n"
        info .= Repeat("-", 30) . "`n"
        info .= "Full hotkey: " . hotkey . "`n"
        info .= "Modifiers: " . (modifiers != "" ? modifiers : "None") . "`n"
        info .= "Base key: " . key . "`n"

        MsgBox(info, "Analysis")
    }

    Repeat(char, count) {
        result := ""
        Loop count
        result .= char
        return result
    }

    ; Create hotkeys with various modifier combinations
    Hotkey("^!+a", AnalyzeHotkey)
    Hotkey("^a", AnalyzeHotkey)
    Hotkey("!a", AnalyzeHotkey)
    Hotkey("+a", AnalyzeHotkey)
    Hotkey("#a", AnalyzeHotkey)

    MsgBox(
    "Modifier Detection`n`n"
    "Try these combinations:`n"
    "Ctrl+Alt+Shift+A`n"
    "Ctrl+A`n"
    "Alt+A`n"
    "Shift+A`n"
    "Win+A`n`n"
    "Each shows its modifier analysis",
    "Example 4"
    )
}

; ============================================================================
; Example 5: Hotkey Pattern Matching
; ============================================================================

Example5_PatternMatching() {
    /**
    * Handles hotkeys based on patterns
    */
    PatternHandler(*) {
        hotkey := A_ThisHotkey

        ; Function key pattern
        if RegExMatch(hotkey, "F(\d+)", &match) {
            num := match[1]
            SendText("Function key " . num . " pressed")
        }
        ; Number key pattern
        else if RegExMatch(hotkey, "\^(\d)", &match) {
            num := match[1]
            SendText("Ctrl+" . num . " = " . (num * 10))
        }
        ; Numpad pattern
        else if RegExMatch(hotkey, "Numpad(\d)", &match) {
            num := match[1]
            SendText("Numpad " . num)
        }
        else {
            MsgBox("Hotkey: " . hotkey, "Pattern Match")
        }
    }

    ; Create function key hotkeys
    Loop 12 {
        Hotkey("F" . A_Index, PatternHandler)
    }

    ; Create number hotkeys
    Loop 9 {
        Hotkey("^" . A_Index, PatternHandler)
    }

    ; Create numpad hotkeys
    Loop 9 {
        Hotkey("Numpad" . A_Index, PatternHandler)
    }

    MsgBox(
    "Pattern Matching`n`n"
    "F1-F12 → 'Function key X pressed'`n"
    "Ctrl+1-9 → Multiply by 10`n"
    "Numpad1-9 → 'Numpad X'`n`n"
    "Single handler uses A_ThisHotkey + patterns",
    "Example 5"
    )
}

; ============================================================================
; Example 6: Hotkey Toggle System
; ============================================================================

Example6_ToggleSystem() {
    global toggleStates := Map()

    /**
    * Toggle handler using A_ThisHotkey as key
    */
    ToggleHandler(*) {
        global toggleStates
        hotkey := A_ThisHotkey

        ; Initialize if not exists
        if !toggleStates.Has(hotkey)
        toggleStates[hotkey] := false

        ; Toggle state
        toggleStates[hotkey] := !toggleStates[hotkey]
        state := toggleStates[hotkey]

        ; Show state
        ToolTip(
        hotkey . ": " . (state ? "ON" : "OFF"),
        A_ScreenWidth - 150,
        A_ScreenHeight - 50
        )
        SetTimer(() => ToolTip(), -1500)

        ; Perform action based on state
        if state {
            MsgBox(hotkey . " is now ON", "Toggle")
        } else {
            MsgBox(hotkey . " is now OFF", "Toggle")
        }
    }

    /**
    * Shows all toggle states
    */
    ShowToggleStates() {
        global toggleStates

        list := "Toggle States:`n" . Repeat("=", 40) . "`n`n"

        for hotkey, state in toggleStates {
            status := state ? "ON ✓" : "OFF ✗"
            list .= hotkey . " → " . status . "`n"
        }

        if toggleStates.Count = 0
        list .= "No toggles activated yet"

        MsgBox(list, "Toggle States")
    }

    Repeat(char, count) {
        result := ""
        Loop count
        result .= char
        return result
    }

    ; Create toggle hotkeys
    Hotkey("^F1", ToggleHandler)
    Hotkey("^F2", ToggleHandler)
    Hotkey("^F3", ToggleHandler)
    Hotkey("^F4", ToggleHandler)

    ; Status hotkey
    Hotkey("^F12", (*) => ShowToggleStates())

    MsgBox(
    "Hotkey Toggle System`n`n"
    "Ctrl+F1-F4 → Toggle ON/OFF`n"
    "Ctrl+F12 → Show all states`n`n"
    "Each hotkey maintains its own state using A_ThisHotkey",
    "Example 6"
    )
}

; ============================================================================
; Example 7: Advanced Hotkey Router
; ============================================================================

Example7_AdvancedRouter() {
    global hotkeyActions := Map()

    /**
    * Registers an action for a hotkey
    */
    RegisterAction(hotkey, action, description := "") {
        global hotkeyActions
        hotkeyActions[hotkey] := {
            action: action,
            desc: description,
            count: 0
        }
    }

    /**
    * Main router function
    */
    HotkeyRouter(*) {
        global hotkeyActions
        hotkey := A_ThisHotkey

        if !hotkeyActions.Has(hotkey) {
            MsgBox("No action registered for: " . hotkey, "Error")
            return
        }

        info := hotkeyActions[hotkey]
        info.count++

        ; Execute action
        info.action.Call()

        ; Show stats
        ToolTip(
        hotkey . " (" . info.desc . ")`n"
        "Used: " . info.count . " times",
        A_ScreenWidth - 200,
        A_ScreenHeight - 80
        )
        SetTimer(() => ToolTip(), -2000)
    }

    /**
    * Shows all registered actions
    */
    ShowActions() {
        global hotkeyActions

        list := "Registered Hotkey Actions:`n" . Repeat("=", 50) . "`n`n"

        for hotkey, info in hotkeyActions {
            list .= hotkey . " → " . info.desc . " (used " . info.count . "x)`n"
        }

        MsgBox(list, "Actions")
    }

    Repeat(char, count) {
        result := ""
        Loop count
        result .= char
        return result
    }

    ; Register actions
    RegisterAction("^!a", () => SendText("Action A"), "Insert A")
    RegisterAction("^!b", () => SendText("Action B"), "Insert B")
    RegisterAction("^!c", () => MsgBox("Action C executed"), "Show C")
    RegisterAction("^!d", () => SendText(FormatTime()), "Insert Date")

    ; Create hotkeys
    for hotkey in hotkeyActions {
        Hotkey(hotkey, HotkeyRouter)
    }

    ; Status hotkey
    Hotkey("^!s", (*) => ShowActions())

    MsgBox(
    "Advanced Hotkey Router`n`n"
    "Ctrl+Alt+A-D → Execute registered actions`n"
    "Ctrl+Alt+S → Show all actions`n`n"
    "Central router uses A_ThisHotkey to dispatch",
    "Example 7"
    )
}

; ============================================================================
; Main Execution
; ============================================================================

ShowExampleMenu() {
    menu := "
    (
    A_ThisHotkey Examples
    =====================

    1. Basic Usage
    2. Dynamic Behavior
    3. History Tracker
    4. Modifier Detection
    5. Pattern Matching
    6. Toggle System
    7. Advanced Router

    Press Alt+Shift+[1-7]
    )"

    MsgBox(menu, "A_ThisHotkey")
}

Hotkey("!+1", (*) => Example1_BasicUsage())
Hotkey("!+2", (*) => Example2_DynamicBehavior())
Hotkey("!+3", (*) => Example3_HistoryTracker())
Hotkey("!+4", (*) => Example4_ModifierDetection())
Hotkey("!+5", (*) => Example5_PatternMatching())
Hotkey("!+6", (*) => Example6_ToggleSystem())
Hotkey("!+7", (*) => Example7_AdvancedRouter())

ShowExampleMenu()
