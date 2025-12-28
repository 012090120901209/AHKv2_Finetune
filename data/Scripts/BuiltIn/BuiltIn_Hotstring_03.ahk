#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Hotstring() Function - Dynamic Hotstring Management
 * ============================================================================
 * 
 * Demonstrates advanced dynamic hotstring creation, modification, and
 * management at runtime. Shows how to build flexible text expansion systems.
 * 
 * Features:
 * - Runtime hotstring creation
 * - Hotstring modification and updates
 * - Conditional hotstring activation
 * - Template-based hotstring generation
 * - User-defined hotstring sets
 * 
 * @author AutoHotkey v2 Documentation Team
 * @version 1.0.0
 */

; ============================================================================
; Example 1: Runtime Hotstring Creation
; ============================================================================

Example1_RuntimeCreation() {
    ; Create hotstrings programmatically based on data
    templates := [{
        trigger: "hello", text: "Hello, how can I help you?" }, {
            trigger: "thanks", text: "Thank you for your message!" }, {
                trigger: "bye", text: "Goodbye! Have a great day!"
            }
    ]

    ; Create all hotstrings from templates
    for template in templates {
        Hotstring("::" . template.trigger . "::", template.text)
    }

    ; Dynamic creation based on current date
    monthName := FormatTime(, "MMMM")
    Hotstring("::thismonth::", monthName)

    ; Dynamic creation with functions
    Hotstring("::random::", (*) => SendText(String(Random(1, 100))))
    Hotstring("::timestamp::", (*) => SendText(FormatTime(, "yyyy-MM-dd HH:mm:ss")))

    MsgBox(
        "Runtime Hotstrings Created!`n`n"
        "Static:`n"
        "  hello, thanks, bye`n`n"
        "Dynamic:`n"
        "  thismonth → " monthName "`n"
        "  random → random number`n"
        "  timestamp → current time",
        "Example 1"
    )
}

; ============================================================================
; Example 2: Hotstring Modification System
; ============================================================================

Example2_ModificationSystem() {
    global hotstringData := Map()

    /**
     * Creates or updates a hotstring
     */
    SetHotstring(trigger, replacement) {
        global hotstringData
        Hotstring("::" . trigger . "::", replacement)
        hotstringData[trigger] := {
            replacement: replacement,
            modified: A_Now
        }
    }

    /**
     * Gets current hotstring replacement
     */
    GetHotstring(trigger) {
        global hotstringData
        if hotstringData.Has(trigger)
            return hotstringData[trigger].replacement
        return ""
    }

    /**
     * Updates an existing hotstring
     */
    UpdateHotstring(trigger, newReplacement) {
        SetHotstring(trigger, newReplacement)
        MsgBox("Updated: " trigger " → " newReplacement, "Update")
    }

    ; Create initial hotstrings
    SetHotstring("sig1", "Regards, John")
    SetHotstring("sig2", "Best, John")

    ; Hotkey to modify hotstrings
    Hotkey("^!u", (*) {
        result := InputBox(
            "Enter trigger to update:",
            "Update Hotstring"
        )

        if result.Result = "OK" && result.Value != "" {
            trigger := result.Value
            current := GetHotstring(trigger)

            result2 := InputBox(
                "Current: " current "`n`nEnter new replacement:",
                "New Replacement"
            )

            if result2.Result = "OK" && result2.Value != ""
                UpdateHotstring(trigger, result2.Value)
        }
    })

    MsgBox(
        "Hotstring Modification System`n`n"
        "Initial hotstrings:`n"
        "  sig1 → Regards, John`n"
        "  sig2 → Best, John`n`n"
        "Ctrl+Alt+U - Update a hotstring`n`n"
        "Try updating sig1 or sig2!",
        "Example 2"
    )
}

; ============================================================================
; Example 3: Conditional Hotstring Activation
; ============================================================================

Example3_ConditionalActivation() {
    static workMode := false

    /**
     * Creates work-related hotstrings
     */
    EnableWorkHotstrings() {
        Hotstring("::mtg::", "Meeting scheduled for: ")
        Hotstring("::proj::", "Project status: ")
        Hotstring("::task::", "Task assigned: ")
        Hotstring("::deadline::", "Deadline: " . FormatTime(, "yyyy-MM-dd"))
    }

    /**
     * Creates casual hotstrings
     */
    EnableCasualHotstrings() {
        Hotstring("::mtg::", "Let's hang out")
        Hotstring("::proj::", "Working on: ")
        Hotstring("::task::", "Need to: ")
        Hotstring("::deadline::", "Due: ")
    }

    /**
     * Toggles between work and casual modes
     */
    ToggleMode() {
        static workMode
        workMode := !workMode

        if workMode {
            EnableWorkHotstrings()
            mode := "WORK"
        } else {
            EnableCasualHotstrings()
            mode := "CASUAL"
        }

        ToolTip("Mode: " mode, A_ScreenWidth - 150, A_ScreenHeight - 50)
        SetTimer(() => ToolTip(), -2000)
    }

    ; Set initial mode
    EnableCasualHotstrings()

    ; Toggle hotkey
    Hotkey("^!m", (*) => ToggleMode())

    MsgBox(
        "Conditional Hotstring Activation`n`n"
        "Ctrl+Alt+M - Toggle Work/Casual mode`n`n"
        "Same triggers, different replacements:`n"
        "  mtg, proj, task, deadline`n`n"
        "Try switching modes and testing!",
        "Example 3"
    )
}

; ============================================================================
; Example 4: Template-Based Generation
; ============================================================================

Example4_TemplateGeneration() {
    /**
     * Generates hotstrings from templates
     */
    GenerateFromTemplate(prefix, items) {
        for index, item in items {
            trigger := prefix . index
            Hotstring("::" . trigger . "::", item)
        }
    }

    ; Generate numbered lists
    GenerateFromTemplate("item", [
        "First item",
        "Second item",
        "Third item",
        "Fourth item",
        "Fifth item"
    ])

    ; Generate priority tags
    GenerateFromTemplate("p", [
        "[HIGH PRIORITY] ",
        "[MEDIUM PRIORITY] ",
        "[LOW PRIORITY] "
    ])

    ; Generate status tags
    GenerateFromTemplate("s", [
        "[COMPLETED] ",
        "[IN PROGRESS] ",
        "[PENDING] ",
        "[BLOCKED] "
    ])

    ; Generate email templates
    emailTemplates := [
        "Dear [Name],`n`nThank you for your inquiry.`n`nBest regards,",
        "Hi [Name],`n`nFollowing up on our conversation.`n`nThanks,",
        "Hello [Name],`n`nI hope this message finds you well.`n`nRegards,"
    ]
    GenerateFromTemplate("email", emailTemplates)

    MsgBox(
        "Template-Based Hotstrings Generated!`n`n"
        "Items:`n  item1-item5`n`n"
        "Priorities:`n  p1-p3`n`n"
        "Status:`n  s1-s4`n`n"
        "Emails:`n  email1-email3",
        "Example 4"
    )
}

; ============================================================================
; Example 5: User-Defined Hotstring Sets
; ============================================================================

Example5_UserDefinedSets() {
    global hostringSets := Map()
    global activeSet := ""

    /**
     * Creates a named hotstring set
     */
    CreateSet(setName, hotstrings) {
        global hostringSets
        hostringSets[setName] := hotstrings
    }

    /**
     * Activates a hotstring set
     */
    ActivateSet(setName) {
        global hostringSets, activeSet

        if !hostringSets.Has(setName) {
            MsgBox("Set not found: " setName, "Error")
            return
        }

        ; Deactivate all hotstrings first
        if activeSet != "" {
            for item in hostringSets[activeSet] {
                try Hotstring("::" . item.trigger . "::", "Off")
            }
        }

        ; Activate new set
        for item in hostringSets[setName] {
            Hotstring("::" . item.trigger . "::", item.text)
        }

        activeSet := setName
        MsgBox("Activated set: " setName, "Set Active")
    }

    /**
     * Lists available sets
     */
    ListSets() {
        global hostringSets, activeSet

        list := "Available Hotstring Sets:`n" . Repeat("=", 40) . "`n`n"

        for setName in hostringSets {
            marker := (setName = activeSet) ? "► " : "  "
            list .= marker . setName . "`n"
        }

        list .= "`n► = Active Set"

        MsgBox(list, "Hotstring Sets")
    }

    Repeat(char, count) {
        result := ""
        Loop count
            result .= char
        return result
    }

    ; Create predefined sets
    CreateSet("Programming", [{
        trigger: "fn", text: "function" }, {
            trigger: "ret", text: "return" }, {
                trigger: "const", text: "constant" }, {
                    trigger: "var", text: "variable"
                }
    ])

    CreateSet("Writing", [{
        trigger: "intro", text: "In this document, we will explore..." }, {
            trigger: "concl", text: "In conclusion,..." }, {
                trigger: "para", text: "Furthermore,..." }, {
                    trigger: "however", text: "However, it should be noted that..."
                }
    ])

    CreateSet("Email", [{
        trigger: "dear", text: "Dear [Name]," }, {
            trigger: "thanks", text: "Thank you for your time." }, {
                trigger: "regards", text: "Best regards,`n" . A_UserName }, {
                    trigger: "followup", text: "Following up on my previous message..."
                }
    ])

    ; Hotkeys for set management
    Hotkey("F9", (*) => ListSets())
    Hotkey("F10", (*) {
        result := InputBox("Enter set name to activate:`n(Programming, Writing, Email)", "Activate Set")
        if result.Result = "OK" && result.Value != ""
            ActivateSet(result.Value)
    })

    MsgBox(
        "User-Defined Hotstring Sets`n`n"
        "Available sets:`n"
        "  • Programming`n"
        "  • Writing`n"
        "  • Email`n`n"
        "F9 - List all sets`n"
        "F10 - Activate a set`n`n"
        "Only one set active at a time!",
        "Example 5"
    )
}

; ============================================================================
; Example 6: Context-Aware Dynamic Creation
; ============================================================================

Example6_ContextAware() {
    /**
     * Creates hotstrings based on active window
     */
    UpdateContextHotstrings() {
        try {
            title := WinGetTitle("A")

            ; Clear previous context hotstrings
            static previousTriggers := []
            for trigger in previousTriggers {
                try Hotstring("::" . trigger . "::", "Off")
            }
            previousTriggers := []

            ; Create new context-specific hotstrings
            if InStr(title, "Notepad") {
                Hotstring("::note::", "Note: ")
                Hotstring("::todo::", "TODO: ")
                Hotstring("::idea::", "IDEA: ")
                previousTriggers := ["note", "todo", "idea"]
            }
            else if InStr(title, "Code") {
                Hotstring(":://", "// TODO: ")
                Hotstring("::/*", "/* */")
                Hotstring("::dbg", "console.log('DEBUG:', );")
                previousTriggers := ["//", "/*", "dbg"]
            }
            else if InStr(title, "Mail") || InStr(title, "Message") {
                Hotstring("::hi", "Hi [Name],`n`n")
                Hotstring("::ty", "Thank you,`n" . A_UserName)
                previousTriggers := ["hi", "ty"]
            }
        }
    }

    ; Update on window change
    SetTimer(UpdateContextHotstrings, 1000)

    ; Initial update
    UpdateContextHotstrings()

    MsgBox(
        "Context-Aware Hotstrings`n`n"
        "Hotstrings change based on active window!`n`n"
        "Notepad: note, todo, idea`n"
        "VS Code: //, /*, dbg`n"
        "Email: hi, ty`n`n"
        "Switch between windows to see changes!",
        "Example 6"
    )
}

; ============================================================================
; Example 7: Advanced Dynamic Builder with Storage
; ============================================================================

Example7_AdvancedBuilder() {
    global customHotstrings := Map()

    /**
     * Adds a hotstring with metadata
     */
    AddCustomHotstring(trigger, replacement, category := "General") {
        global customHotstrings

        Hotstring("::" . trigger . "::", replacement)

        customHotstrings[trigger] := {
            replacement: replacement,
            category: category,
            created: A_Now,
            useCount: 0
        }
    }

    /**
     * Removes a hotstring
     */
    RemoveHotstring(trigger) {
        global customHotstrings

        if !customHotstrings.Has(trigger) {
            MsgBox("Hotstring not found: " trigger, "Error")
            return false
        }

        Hotstring("::" . trigger . "::", "Off")
        customHotstrings.Delete(trigger)
        MsgBox("Removed: " trigger, "Success")
        return true
    }

    /**
     * Exports hotstrings to text
     */
    ExportHotstrings() {
        global customHotstrings

        if customHotstrings.Count = 0 {
            MsgBox("No hotstrings to export!", "Export")
            return
        }

        export := "; Custom Hotstrings Export`n"
        export .= "; Generated: " . FormatTime() . "`n`n"

        for trigger, info in customHotstrings {
            export .= 'Hotstring("::"' . trigger . '"::", "'
            export .= StrReplace(info.replacement, "`n", "\n")
            export .= '") ; ' . info.category . "`n"
        }

        A_Clipboard := export
        MsgBox("Hotstrings exported to clipboard!`n`n" . customHotstrings.Count . " hotstrings", "Export")
    }

    /**
     * Shows advanced builder GUI
     */
    ShowAdvancedBuilder() {
        builderGui := Gui("+AlwaysOnTop +Resize", "Advanced Hotstring Builder")

        builderGui.AddText("", "Trigger:")
        triggerEdit := builderGui.AddEdit("w400")

        builderGui.AddText("", "Replacement:")
        replacementEdit := builderGui.AddEdit("w400 r5")

        builderGui.AddText("", "Category:")
        categoryEdit := builderGui.AddEdit("w400", "General")

        ; Buttons
        builderGui.AddButton("w195", "Add Hotstring").OnEvent("Click", (*) => {
            trigger := triggerEdit.Value
            replacement := replacementEdit.Value
            category := categoryEdit.Value
            if trigger = "" || replacement = "" {
                MsgBox("Trigger and replacement required!", "Error")
                return
                }
                AddCustomHotstring(trigger, replacement, category)
                MsgBox("Added: " trigger, "Success")
                triggerEdit.Value := ""
                replacementEdit.Value := ""
            })
            builderGui.AddButton("x+10 w195", "Remove Hotstring").OnEvent("Click", (*) => {
                trigger := triggerEdit.Value
                if trigger != ""
                    RemoveHotstring(trigger)
                })
                builderGui.AddButton("xm w400", "Export to Clipboard").OnEvent("Click", (*) => ExportHotstrings())
                builderGui.AddButton("w400", "List All Hotstrings").OnEvent("Click", (*) => {
                    global customHotstrings
                    list := "Custom Hotstrings:`n" . Repeat("=", 50) . "`n`n"
                    for trigger, info in customHotstrings {
                        list .= trigger . " [" . info.category . "]`n"
                        list .= "  → " . SubStr(info.replacement, 1, 60)
                        if StrLen(info.replacement) > 60
                            list .= "..."
                            list .= "`n`n"
                        }
                        if customHotstrings.Count = 0
                            list := "No custom hotstrings defined."
                            MsgBox(list, "Hotstrings")
                        })
                        builderGui.Show()
                }
                    Repeat(char, count) {
                        result := ""
                        Loop count
                            result .= char
                        return result
                    }
                    ; Hotkey to open builder
                    Hotkey("^!h", (*) => ShowAdvancedBuilder())
                    MsgBox(
                        "Advanced Hotstring Builder`n`n"
                        "Ctrl+Alt+H - Open builder GUI`n`n"
                        "Features:`n"
                        "  • Add/remove hotstrings`n"
                        "  • Categorize hotstrings`n"
                        "  • Export to clipboard`n"
                        "  • List all hotstrings`n`n"
                        "Build your custom library!",
                        "Example 7"
                    )
                }
                ; ============================================================================
                ; Main Execution
                ; ============================================================================
                ShowExampleMenu() {
                    menu := "
                                                (
                                                Dynamic Hotstring Management
                                                =============================

                                                1. Runtime Creation
                                                2. Modification System
                                                3. Conditional Activation
                                                4. Template Generation
                                                5. User-Defined Sets
                                                6. Context-Aware
                                                7. Advanced Builder

                                                Press Win+Shift+[1-7]
                                                )"

                    MsgBox(menu, "Dynamic Hotstrings")
                }
                Hotkey("#+1", (*) => Example1_RuntimeCreation())
                Hotkey("#+2", (*) => Example2_ModificationSystem())
                Hotkey("#+3", (*) => Example3_ConditionalActivation())
                Hotkey("#+4", (*) => Example4_TemplateGeneration())
                Hotkey("#+5", (*) => Example5_UserDefinedSets())
                Hotkey("#+6", (*) => Example6_ContextAware())
                Hotkey("#+7", (*) => Example7_AdvancedBuilder())
                ShowExampleMenu()
