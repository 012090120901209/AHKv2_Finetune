#Requires AutoHotkey v2.0

/**
* ============================================================================
* ListHotkeys - Hotkey Inspection and Debugging
* ============================================================================
*
* Demonstrates using ListHotkeys command and related inspection techniques
* to view, debug, and manage hotkeys at runtime.
*
* Features:
* - Viewing all active hotkeys
* - Hotkey statistics and metrics
* - Debugging hotkey issues
* - Custom hotkey listings
* - Hotkey documentation generation
*
* @author AutoHotkey v2 Documentation Team
* @version 1.0.0
* @see https://www.autohotkey.com/docs/v2/lib/ListHotkeys.htm
*/

; ============================================================================
; Example 1: Basic ListHotkeys Usage
; ============================================================================

Example1_BasicListing() {
    ; Create various hotkeys for demonstration
    Hotkey("F1", (*) => MsgBox("F1 pressed"))
    Hotkey("F2", (*) => MsgBox("F2 pressed"))
    Hotkey("^!a", (*) => SendText("Ctrl+Alt+A"))
    Hotkey("^!b", (*) => SendText("Ctrl+Alt+B"))
    Hotkey("#r", (*) => Reload())

    ; Create a hotkey to show the list
    Hotkey("^!l", (*) {
        ListHotkeys()
        MsgBox(
        "The ListHotkeys window shows:`n`n"
        "• All active hotkeys`n"
        "• Their functions/labels`n"
        "• Registration status`n"
        "• Current state (on/off)`n`n"
        "Close the window to continue.",
        "ListHotkeys Info"
        )
    })

    MsgBox(
    "Basic ListHotkeys Usage`n`n"
    "Created hotkeys:`n"
    "  F1, F2`n"
    "  Ctrl+Alt+A, Ctrl+Alt+B`n"
    "  Win+R`n`n"
    "Press Ctrl+Alt+L to view the hotkey list`n`n"
    "The list shows all registered hotkeys!",
    "Example 1"
    )
}

; ============================================================================
; Example 2: Custom Hotkey Registry with Metadata
; ============================================================================

Example2_CustomRegistry() {
    global hotkeyDB := Map()

    /**
    * Registers a hotkey with metadata
    */
    RegisterHotkey(keys, callback, category := "", description := "") {
        global hotkeyDB

        ; Create the hotkey
        Hotkey(keys, callback)

        ; Store metadata
        hotkeyDB[keys] := {
            category: category,
            description: description,
            created: A_Now,
            pressCount: 0
        }
    }

    /**
    * Wraps callback to count presses
    */
    CountingCallback(keys, originalCallback) {
        global hotkeyDB
        return (*) {
            hotkeyDB[keys].pressCount++
            originalCallback.Call()
        }
    }

    /**
    * Shows custom hotkey list
    */
    ShowCustomList() {
        global hotkeyDB

        list := "Custom Hotkey Registry`n" . Repeat("=", 60) . "`n`n"

        ; Group by category
        categories := Map()

        for keys, info in hotkeyDB {
            cat := info.category != "" ? info.category : "Uncategorized"
            if !categories.Has(cat)
            categories[cat] := []
            categories[cat].Push(keys)
        }

        ; Build list
        for category, keyList in categories {
            list .= category . ":`n"
            for keys in keyList {
                info := hotkeyDB[keys]
                list .= "  " . keys
                if info.description != ""
                list .= " - " . info.description
                list .= " (pressed: " . info.pressCount . "x)`n"
            }
            list .= "`n"
        }

        MsgBox(list, "Custom Registry")
    }

    Repeat(char, count) {
        result := ""
        Loop count
        result .= char
        return result
    }

    ; Register hotkeys with metadata
    RegisterHotkey("F3", (*) => SendText("Text 1"), "Text", "Insert text 1")
    RegisterHotkey("F4", (*) => SendText("Text 2"), "Text", "Insert text 2")
    RegisterHotkey("^F3", (*) => MsgBox("Action 1"), "Actions", "Show message 1")
    RegisterHotkey("^F4", (*) => MsgBox("Action 2"), "Actions", "Show message 2")

    ; Wrap callbacks to count presses
    for keys, info in hotkeyDB {
        originalCallback := Hotkey(keys, "")
        Hotkey(keys, CountingCallback(keys, originalCallback))
    }

    ; Show list hotkey
    Hotkey("^!r", (*) => ShowCustomList())

    ; Also show built-in list
    Hotkey("^!b", (*) => ListHotkeys())

    MsgBox(
    "Custom Hotkey Registry`n`n"
    "Test hotkeys:`n"
    "  F3, F4 (Text category)`n"
    "  Ctrl+F3, Ctrl+F4 (Actions category)`n`n"
    "Ctrl+Alt+R → Custom registry (with stats)`n"
    "Ctrl+Alt+B → Built-in ListHotkeys`n`n"
    "Try pressing hotkeys and viewing lists!",
    "Example 2"
    )
}

; ============================================================================
; Example 3: Hotkey Statistics and Analytics
; ============================================================================

Example3_Statistics() {
    global stats := Map(
    "totalCreated", 0,
    "totalPressed", 0,
    "startTime", A_TickCount,
    "pressLog", []
    )

    /**
    * Creates a tracked hotkey
    */
    CreateTrackedHotkey(keys, action) {
        global stats

        stats["totalCreated"]++

        Hotkey(keys, (*) {
            stats["totalPressed"]++
            stats["pressLog"].Push({
                key: keys,
                time: A_TickCount,
                timestamp: FormatTime(, "HH:mm:ss")
            })

            action.Call()
        })
    }

    /**
    * Shows statistics
    */
    ShowStatistics() {
        global stats

        runtime := Round((A_TickCount - stats["startTime"]) / 1000)
        avgPerMin := runtime > 0 ? Round(stats["totalPressed"] / (runtime / 60), 2) : 0

        report := "Hotkey Statistics`n" . Repeat("=", 50) . "`n`n"
        report .= "Total hotkeys created: " . stats["totalCreated"] . "`n"
        report .= "Total presses: " . stats["totalPressed"] . "`n"
        report .= "Runtime: " . runtime . " seconds`n"
        report .= "Average: " . avgPerMin . " presses/min`n`n"

        report .= "Recent Activity (last 5):`n"
        logLen := stats["pressLog"].Length
        startIdx := Max(1, logLen - 4)

        Loop Min(5, logLen) {
            idx := startIdx + A_Index - 1
            entry := stats["pressLog"][idx]
            report .= "  " . entry.timestamp . " - " . entry.key . "`n"
        }

        MsgBox(report, "Statistics")
    }

    /**
    * Shows hotkey frequency analysis
    */
    ShowFrequencyAnalysis() {
        global stats

        freq := Map()

        for entry in stats["pressLog"] {
            key := entry.key
            if !freq.Has(key)
            freq[key] := 0
            freq[key]++
        }

        list := "Hotkey Frequency Analysis`n" . Repeat("=", 50) . "`n`n"

        ; Convert to array for sorting
        freqArray := []
        for key, count in freq {
            freqArray.Push({key: key, count: count})
        }

        ; Simple bubble sort by count
        Loop freqArray.Length {
            i := A_Index
            Loop freqArray.Length - i {
                j := A_Index
                if freqArray[j].count < freqArray[j + 1].count {
                    temp := freqArray[j]
                    freqArray[j] := freqArray[j + 1]
                    freqArray[j + 1] := temp
                }
            }
        }

        ; Build list
        for item in freqArray {
            list .= item.key . ": " . item.count . " times`n"
        }

        if freqArray.Length = 0
        list .= "No hotkey activity yet"

        MsgBox(list, "Frequency")
    }

    Repeat(char, count) {
        result := ""
        Loop count
        result .= char
        return result
    }

    ; Create tracked hotkeys
    CreateTrackedHotkey("F5", (*) => SendText("Text A"))
    CreateTrackedHotkey("F6", (*) => SendText("Text B"))
    CreateTrackedHotkey("F7", (*) => SendText("Text C"))
    CreateTrackedHotkey("F8", (*) => MsgBox("Action D"))

    ; Analysis hotkeys
    Hotkey("^!s", (*) => ShowStatistics())
    Hotkey("^!f", (*) => ShowFrequencyAnalysis())
    Hotkey("^!l", (*) => ListHotkeys())

    MsgBox(
    "Hotkey Statistics & Analytics`n`n"
    "Test hotkeys: F5, F6, F7, F8`n`n"
    "Ctrl+Alt+S → Show statistics`n"
    "Ctrl+Alt+F → Frequency analysis`n"
    "Ctrl+Alt+L → Built-in list`n`n"
    "Press hotkeys and check stats!",
    "Example 3"
    )
}

; ============================================================================
; Example 4: Hotkey Debugging Tools
; ============================================================================

Example4_DebuggingTools() {
    global debugLog := []

    /**
    * Creates a debuggable hotkey
    */
    CreateDebugHotkey(keys, action, label := "") {
        global debugLog

        Hotkey(keys, (*) {
            startTime := A_TickCount

            ; Log start
            debugLog.Push("START: " . keys . " at " . FormatTime(, "HH:mm:ss.") . Mod(A_TickCount, 1000))

            ; Execute action
            try {
                action.Call()
                success := true
                errorMsg := ""
            } catch Error as err {
                success := false
                errorMsg := err.Message
            }

            ; Log result
            duration := A_TickCount - startTime
            status := success ? "SUCCESS" : "ERROR"
            debugLog.Push(status . ": " . keys . " (" . duration . "ms)" .
            (errorMsg != "" ? " - " . errorMsg : ""))

            ; Trim log
            while debugLog.Length > 20
            debugLog.RemoveAt(1)
        })
    }

    /**
    * Shows debug log
    */
    ShowDebugLog() {
        global debugLog

        list := "Hotkey Debug Log`n" . Repeat("=", 60) . "`n`n"

        if debugLog.Length = 0 {
            list .= "No activity logged yet"
        } else {
            for entry in debugLog {
                list .= entry . "`n"
            }
        }

        MsgBox(list, "Debug Log")
    }

    /**
    * Clears debug log
    */
    ClearDebugLog() {
        global debugLog
        debugLog := []
        MsgBox("Debug log cleared!", "Clear")
    }

    Repeat(char, count) {
        result := ""
        Loop count
        result .= char
        return result
    }

    ; Create debug hotkeys
    CreateDebugHotkey("F9", (*) => Sleep(100), "Slow action")
    CreateDebugHotkey("F10", (*) => MsgBox("Quick action"), "Quick action")
    CreateDebugHotkey("F11", (*) { throw Error("Intentional error") }, "Error action")

    ; Debug tools
    Hotkey("^!d", (*) => ShowDebugLog())
    Hotkey("^!c", (*) => ClearDebugLog())

    MsgBox(
    "Hotkey Debugging Tools`n`n"
    "Test hotkeys:`n"
    "  F9 - Slow action (100ms sleep)`n"
    "  F10 - Quick action`n"
    "  F11 - Error test`n`n"
    "Ctrl+Alt+D → Show debug log`n"
    "Ctrl+Alt+C → Clear log`n`n"
    "Log shows timing and errors!",
    "Example 4"
    )
}

; ============================================================================
; Example 5: Hotkey Documentation Generator
; ============================================================================

Example5_Documentation() {
    global docRegistry := Map()

    /**
    * Registers hotkey with full documentation
    */
    RegisterDocumentedHotkey(keys, action, doc) {
        global docRegistry

        Hotkey(keys, action)

        docRegistry[keys] := {
            description: doc.Has("description") ? doc["description"] : "",
            category: doc.Has("category") ? doc["category"] : "General",
            example: doc.Has("example") ? doc["example"] : "",
            notes: doc.Has("notes") ? doc["notes"] : ""
        }
    }

    /**
    * Generates documentation
    */
    GenerateDocumentation() {
        global docRegistry

        doc := "HOTKEY DOCUMENTATION`n" . Repeat("=", 70) . "`n`n"

        ; Group by category
        categories := Map()

        for keys, info in docRegistry {
            cat := info.category
            if !categories.Has(cat)
            categories[cat] := []
            categories[cat].Push(keys)
        }

        ; Build documentation
        for category, keyList in categories {
            doc .= category . "`n" . Repeat("-", 70) . "`n`n"

            for keys in keyList {
                info := docRegistry[keys]
                doc .= "Hotkey: " . keys . "`n"
                if info.description != ""
                doc .= "Description: " . info.description . "`n"
                if info.example != ""
                doc .= "Example: " . info.example . "`n"
                if info.notes != ""
                doc .= "Notes: " . info.notes . "`n"
                doc .= "`n"
            }
        }

        ; Copy to clipboard
        A_Clipboard := doc

        MsgBox(
        "Documentation generated and copied to clipboard!`n`n"
        "Total hotkeys documented: " . docRegistry.Count,
        "Documentation"
        )
    }

    Repeat(char, count) {
        result := ""
        Loop count
        result .= char
        return result
    }

    ; Register documented hotkeys
    RegisterDocumentedHotkey("^!n", (*) => SendText("New"), Map(
    "description", "Creates a new item",
    "category", "File Operations",
    "example", "Press in any text field",
    "notes", "Inserts the word 'New'"
    ))

    RegisterDocumentedHotkey("^!o", (*) => SendText("Open"), Map(
    "description", "Opens an item",
    "category", "File Operations"
    ))

    RegisterDocumentedHotkey("^!1", (*) => MsgBox("Tool 1"), Map(
    "description", "Activates Tool 1",
    "category", "Tools",
    "example", "Quick access to Tool 1"
    ))

    ; Documentation generator
    Hotkey("^!g", (*) => GenerateDocumentation())

    MsgBox(
    "Hotkey Documentation Generator`n`n"
    "Test hotkeys:`n"
    "  Ctrl+Alt+N - New (File Operations)`n"
    "  Ctrl+Alt+O - Open (File Operations)`n"
    "  Ctrl+Alt+1 - Tool 1 (Tools)`n`n"
    "Ctrl+Alt+G → Generate documentation`n`n"
    "Documentation copied to clipboard!",
    "Example 5"
    )
}

; ============================================================================
; Example 6: Interactive Hotkey Inspector
; ============================================================================

Example6_Inspector() {
    /**
    * Creates hotkey inspector GUI
    */
    CreateInspector() {
        inspectorGui := Gui("+Resize", "Hotkey Inspector")

        inspectorGui.AddText("", "Press any hotkey to inspect it")
        inspectorGui.AddText("", "Last Hotkey:")
        lastKeyText := inspectorGui.AddEdit("w400 ReadOnly")

        inspectorGui.AddText("", "Hotkey Details:")
        detailsText := inspectorGui.AddEdit("w400 r10 ReadOnly")

        inspectorGui.AddButton("w400", "Refresh ListHotkeys").OnEvent("Click", (*) => ListHotkeys())

        ; Monitor for hotkey presses
        SetTimer(UpdateInspector, 100)

        UpdateInspector() {
            static lastHotkey := ""

            if A_PriorHotkey != lastHotkey {
                lastHotkey := A_PriorHotkey

                if lastHotkey != "" {
                    lastKeyText.Value := lastHotkey

                    details := "Hotkey: " . lastHotkey . "`n"
                    details .= "Time: " . FormatTime(, "HH:mm:ss") . "`n"
                    details .= "Suspended: " . (A_IsSuspended ? "Yes" : "No") . "`n"
                    details .= "This Hotkey: " . A_ThisHotkey . "`n"
                    details .= "Prior Hotkey: " . A_PriorHotkey . "`n"

                    detailsText.Value := details
                }
            }
        }

        inspectorGui.Show()
    }

    ; Create test hotkeys
    Hotkey("^!i1", (*) => MsgBox("Inspector Test 1"))
    Hotkey("^!i2", (*) => MsgBox("Inspector Test 2"))

    ; Open inspector
    Hotkey("^!i", (*) => CreateInspector())

    MsgBox(
    "Interactive Hotkey Inspector`n`n"
    "Ctrl+Alt+I → Open inspector`n`n"
    "Test hotkeys:`n"
    "  Ctrl+Alt+I1`n"
    "  Ctrl+Alt+I2`n`n"
    "Inspector shows realtime hotkey info!",
    "Example 6"
    )
}

; ============================================================================
; Example 7: Comprehensive Hotkey Manager
; ============================================================================

Example7_ComprehensiveManager() {
    global allHotkeys := Map()

    /**
    * Master registration function
    */
    MasterRegister(keys, action, metadata := Map()) {
        global allHotkeys

        Hotkey(keys, action)

        allHotkeys[keys] := {
            metadata: metadata,
            enabled: true,
            pressCount: 0,
            lastPressed: 0
        }
    }

    /**
    * Shows comprehensive list
    */
    ShowComprehensiveList() {
        global allHotkeys

        list := "Comprehensive Hotkey List`n" . Repeat("=", 60) . "`n`n"

        for keys, info in allHotkeys {
            status := info.enabled ? "✓" : "✗"
            list .= status . " " . keys

            if info.metadata.Has("desc")
            list .= " - " . info.metadata["desc"]

            list .= " [" . info.pressCount . "x]`n"
        }

        MsgBox(list, "All Hotkeys")
    }

    Repeat(char, count) {
        result := ""
        Loop count
        result .= char
        return result
    }

    ; Register hotkeys
    MasterRegister("^!m1", (*) => SendText("Manager 1"), Map("desc", "Test 1"))
    MasterRegister("^!m2", (*) => SendText("Manager 2"), Map("desc", "Test 2"))

    ; Manager controls
    Hotkey("^!m", (*) => ShowComprehensiveList())
    Hotkey("^!#l", (*) => ListHotkeys())

    MsgBox(
    "Comprehensive Hotkey Manager`n`n"
    "Ctrl+Alt+M → Custom list`n"
    "Ctrl+Alt+Win+L → Built-in list`n`n"
    "Combines all management features!",
    "Example 7"
    )
}

; ============================================================================
; Main Execution
; ============================================================================

ShowExampleMenu() {
    menu := "
    (
    ListHotkeys & Inspection Examples
    ==================================

    1. Basic ListHotkeys
    2. Custom Registry
    3. Statistics & Analytics
    4. Debugging Tools
    5. Documentation Generator
    6. Interactive Inspector
    7. Comprehensive Manager

    Press Win+Ctrl+[1-7]
    )"

    MsgBox(menu, "ListHotkeys")
}

Hotkey("#^1", (*) => Example1_BasicListing())
Hotkey("#^2", (*) => Example2_CustomRegistry())
Hotkey("#^3", (*) => Example3_Statistics())
Hotkey("#^4", (*) => Example4_DebuggingTools())
Hotkey("#^5", (*) => Example5_Documentation())
Hotkey("#^6", (*) => Example6_Inspector())
Hotkey("#^7", (*) => Example7_ComprehensiveManager())

ShowExampleMenu()
