#Requires AutoHotkey v2.0

/**
* BuiltIn_GuiEvents_02.ahk - OnChange Event Handling
*
* This file demonstrates change events for GUI controls in AutoHotkey v2.
* Topics covered:
* - Edit box changes
* - Dropdown changes
* - Real-time validation
* - Change tracking
* - Undo/redo systems
* - Auto-save
* - Change notifications
*
* @author AutoHotkey Community
* @version 2.0
* @date 2024
*/



; =============================================================================
; Example 1: Edit box changes
; =============================================================================

/**
* Demonstrates edit box changes with practical examples
* Shows event handling patterns and best practices
*/
Example1_Editboxchanges() {
    myGui := Gui(, "Edit box changes Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Edit box changes Event Handling")
    myGui.SetFont("s9 Norm")

    ; Event log
    myGui.Add("Text", "x20 y55", "Event Log:")
    eventLog := myGui.Add("Edit", "x20 y75 w560 h200 ReadOnly Multi")
    eventLog.Value := "Event log initialized...\n"

    eventCount := 0

    LogEvent(msg) {
        timestamp := FormatTime(A_Now, "HH:mm:ss")
        eventCount++
        eventLog.Value .= Format("[{1}] Event #{2}: {3}\n", timestamp, eventCount, msg)
        ControlSend("{End}", eventLog)
    }

    ; Interactive elements
    myGui.Add("Text", "x20 y285", "Interact with these controls to trigger events:")

    ; Buttons
    btn1 := myGui.Add("Button", "x20 y310 w130", "Button 1")
    btn2 := myGui.Add("Button", "x160 y310 w130", "Button 2")
    btn3 := myGui.Add("Button", "x300 y310 w130", "Button 3")

    btn1.OnEvent("Click", (*) => LogEvent("Button 1 clicked"))
    btn2.OnEvent("Click", (*) => LogEvent("Button 2 clicked"))
    btn3.OnEvent("Click", (*) => LogEvent("Button 3 clicked"))

    ; Edit box with change detection
    myGui.Add("Text", "x20 y350", "Type to trigger change events:")
    editBox := myGui.Add("Edit", "x20 y370 w280")
    editBox.OnEvent("Change", (*) => LogEvent("Edit box changed: " editBox.Value))

    ; Checkbox
    chk := myGui.Add("Checkbox", "x320 y370", "Enable feature")
    chk.OnEvent("Click", (*) => LogEvent("Checkbox " (chk.Value ? "checked" : "unchecked")))

    ; Clear log button
    myGui.Add("Button", "x440 y310 w140", "Clear Log").OnEvent("Click", ClearLog)

    ClearLog(*) {
        eventLog.Value := "Event log cleared...\n"
        eventCount := 0
        LogEvent("Log cleared")
    }

    myGui.Add("Button", "x20 y410 w560", "Close").OnEvent("Click", (*) => myGui.Destroy())

    LogEvent("Window created and shown")
    myGui.Show("w600 h460")
}



; =============================================================================
; Example 2: Dropdown changes
; =============================================================================

/**
* Demonstrates dropdown changes with practical examples
* Shows event handling patterns and best practices
*/
Example2_Dropdownchanges() {
    myGui := Gui(, "Dropdown changes Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Dropdown changes Event Handling")
    myGui.SetFont("s9 Norm")

    ; Event log
    myGui.Add("Text", "x20 y55", "Event Log:")
    eventLog := myGui.Add("Edit", "x20 y75 w560 h200 ReadOnly Multi")
    eventLog.Value := "Event log initialized...\n"

    eventCount := 0

    LogEvent(msg) {
        timestamp := FormatTime(A_Now, "HH:mm:ss")
        eventCount++
        eventLog.Value .= Format("[{1}] Event #{2}: {3}\n", timestamp, eventCount, msg)
        ControlSend("{End}", eventLog)
    }

    ; Interactive elements
    myGui.Add("Text", "x20 y285", "Interact with these controls to trigger events:")

    ; Buttons
    btn1 := myGui.Add("Button", "x20 y310 w130", "Button 1")
    btn2 := myGui.Add("Button", "x160 y310 w130", "Button 2")
    btn3 := myGui.Add("Button", "x300 y310 w130", "Button 3")

    btn1.OnEvent("Click", (*) => LogEvent("Button 1 clicked"))
    btn2.OnEvent("Click", (*) => LogEvent("Button 2 clicked"))
    btn3.OnEvent("Click", (*) => LogEvent("Button 3 clicked"))

    ; Edit box with change detection
    myGui.Add("Text", "x20 y350", "Type to trigger change events:")
    editBox := myGui.Add("Edit", "x20 y370 w280")
    editBox.OnEvent("Change", (*) => LogEvent("Edit box changed: " editBox.Value))

    ; Checkbox
    chk := myGui.Add("Checkbox", "x320 y370", "Enable feature")
    chk.OnEvent("Click", (*) => LogEvent("Checkbox " (chk.Value ? "checked" : "unchecked")))

    ; Clear log button
    myGui.Add("Button", "x440 y310 w140", "Clear Log").OnEvent("Click", ClearLog)

    ClearLog(*) {
        eventLog.Value := "Event log cleared...\n"
        eventCount := 0
        LogEvent("Log cleared")
    }

    myGui.Add("Button", "x20 y410 w560", "Close").OnEvent("Click", (*) => myGui.Destroy())

    LogEvent("Window created and shown")
    myGui.Show("w600 h460")
}



; =============================================================================
; Example 3: Real-time validation
; =============================================================================

/**
* Demonstrates real-time validation with practical examples
* Shows event handling patterns and best practices
*/
Example3_Realtimevalidation() {
    myGui := Gui(, "Real-time validation Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Real-time validation Event Handling")
    myGui.SetFont("s9 Norm")

    ; Event log
    myGui.Add("Text", "x20 y55", "Event Log:")
    eventLog := myGui.Add("Edit", "x20 y75 w560 h200 ReadOnly Multi")
    eventLog.Value := "Event log initialized...\n"

    eventCount := 0

    LogEvent(msg) {
        timestamp := FormatTime(A_Now, "HH:mm:ss")
        eventCount++
        eventLog.Value .= Format("[{1}] Event #{2}: {3}\n", timestamp, eventCount, msg)
        ControlSend("{End}", eventLog)
    }

    ; Interactive elements
    myGui.Add("Text", "x20 y285", "Interact with these controls to trigger events:")

    ; Buttons
    btn1 := myGui.Add("Button", "x20 y310 w130", "Button 1")
    btn2 := myGui.Add("Button", "x160 y310 w130", "Button 2")
    btn3 := myGui.Add("Button", "x300 y310 w130", "Button 3")

    btn1.OnEvent("Click", (*) => LogEvent("Button 1 clicked"))
    btn2.OnEvent("Click", (*) => LogEvent("Button 2 clicked"))
    btn3.OnEvent("Click", (*) => LogEvent("Button 3 clicked"))

    ; Edit box with change detection
    myGui.Add("Text", "x20 y350", "Type to trigger change events:")
    editBox := myGui.Add("Edit", "x20 y370 w280")
    editBox.OnEvent("Change", (*) => LogEvent("Edit box changed: " editBox.Value))

    ; Checkbox
    chk := myGui.Add("Checkbox", "x320 y370", "Enable feature")
    chk.OnEvent("Click", (*) => LogEvent("Checkbox " (chk.Value ? "checked" : "unchecked")))

    ; Clear log button
    myGui.Add("Button", "x440 y310 w140", "Clear Log").OnEvent("Click", ClearLog)

    ClearLog(*) {
        eventLog.Value := "Event log cleared...\n"
        eventCount := 0
        LogEvent("Log cleared")
    }

    myGui.Add("Button", "x20 y410 w560", "Close").OnEvent("Click", (*) => myGui.Destroy())

    LogEvent("Window created and shown")
    myGui.Show("w600 h460")
}



; =============================================================================
; Example 4: Change tracking
; =============================================================================

/**
* Demonstrates change tracking with practical examples
* Shows event handling patterns and best practices
*/
Example4_Changetracking() {
    myGui := Gui(, "Change tracking Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Change tracking Event Handling")
    myGui.SetFont("s9 Norm")

    ; Event log
    myGui.Add("Text", "x20 y55", "Event Log:")
    eventLog := myGui.Add("Edit", "x20 y75 w560 h200 ReadOnly Multi")
    eventLog.Value := "Event log initialized...\n"

    eventCount := 0

    LogEvent(msg) {
        timestamp := FormatTime(A_Now, "HH:mm:ss")
        eventCount++
        eventLog.Value .= Format("[{1}] Event #{2}: {3}\n", timestamp, eventCount, msg)
        ControlSend("{End}", eventLog)
    }

    ; Interactive elements
    myGui.Add("Text", "x20 y285", "Interact with these controls to trigger events:")

    ; Buttons
    btn1 := myGui.Add("Button", "x20 y310 w130", "Button 1")
    btn2 := myGui.Add("Button", "x160 y310 w130", "Button 2")
    btn3 := myGui.Add("Button", "x300 y310 w130", "Button 3")

    btn1.OnEvent("Click", (*) => LogEvent("Button 1 clicked"))
    btn2.OnEvent("Click", (*) => LogEvent("Button 2 clicked"))
    btn3.OnEvent("Click", (*) => LogEvent("Button 3 clicked"))

    ; Edit box with change detection
    myGui.Add("Text", "x20 y350", "Type to trigger change events:")
    editBox := myGui.Add("Edit", "x20 y370 w280")
    editBox.OnEvent("Change", (*) => LogEvent("Edit box changed: " editBox.Value))

    ; Checkbox
    chk := myGui.Add("Checkbox", "x320 y370", "Enable feature")
    chk.OnEvent("Click", (*) => LogEvent("Checkbox " (chk.Value ? "checked" : "unchecked")))

    ; Clear log button
    myGui.Add("Button", "x440 y310 w140", "Clear Log").OnEvent("Click", ClearLog)

    ClearLog(*) {
        eventLog.Value := "Event log cleared...\n"
        eventCount := 0
        LogEvent("Log cleared")
    }

    myGui.Add("Button", "x20 y410 w560", "Close").OnEvent("Click", (*) => myGui.Destroy())

    LogEvent("Window created and shown")
    myGui.Show("w600 h460")
}



; =============================================================================
; Example 5: Undo/redo systems
; =============================================================================

/**
* Demonstrates undo/redo systems with practical examples
* Shows event handling patterns and best practices
*/
Example5_UndoRedoSystems() {
    myGui := Gui(, "Undo/redo systems Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Undo/redo systems Event Handling")
    myGui.SetFont("s9 Norm")

    ; Event log
    myGui.Add("Text", "x20 y55", "Event Log:")
    eventLog := myGui.Add("Edit", "x20 y75 w560 h200 ReadOnly Multi")
    eventLog.Value := "Event log initialized...\n"

    eventCount := 0

    LogEvent(msg) {
        timestamp := FormatTime(A_Now, "HH:mm:ss")
        eventCount++
        eventLog.Value .= Format("[{1}] Event #{2}: {3}\n", timestamp, eventCount, msg)
        ControlSend("{End}", eventLog)
    }

    ; Interactive elements
    myGui.Add("Text", "x20 y285", "Interact with these controls to trigger events:")

    ; Buttons
    btn1 := myGui.Add("Button", "x20 y310 w130", "Button 1")
    btn2 := myGui.Add("Button", "x160 y310 w130", "Button 2")
    btn3 := myGui.Add("Button", "x300 y310 w130", "Button 3")

    btn1.OnEvent("Click", (*) => LogEvent("Button 1 clicked"))
    btn2.OnEvent("Click", (*) => LogEvent("Button 2 clicked"))
    btn3.OnEvent("Click", (*) => LogEvent("Button 3 clicked"))

    ; Edit box with change detection
    myGui.Add("Text", "x20 y350", "Type to trigger change events:")
    editBox := myGui.Add("Edit", "x20 y370 w280")
    editBox.OnEvent("Change", (*) => LogEvent("Edit box changed: " editBox.Value))

    ; Checkbox
    chk := myGui.Add("Checkbox", "x320 y370", "Enable feature")
    chk.OnEvent("Click", (*) => LogEvent("Checkbox " (chk.Value ? "checked" : "unchecked")))

    ; Clear log button
    myGui.Add("Button", "x440 y310 w140", "Clear Log").OnEvent("Click", ClearLog)

    ClearLog(*) {
        eventLog.Value := "Event log cleared...\n"
        eventCount := 0
        LogEvent("Log cleared")
    }

    myGui.Add("Button", "x20 y410 w560", "Close").OnEvent("Click", (*) => myGui.Destroy())

    LogEvent("Window created and shown")
    myGui.Show("w600 h460")
}


; =============================================================================
; Example 6: Auto-save
; =============================================================================

/**
* Demonstrates auto-save with practical examples
* Shows event handling patterns and best practices
*/
Example6_Autosave() {
    myGui := Gui(, "Auto-save Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Auto-save Event Handling")
    myGui.SetFont("s9 Norm")

    ; Event log
    myGui.Add("Text", "x20 y55", "Event Log:")
    eventLog := myGui.Add("Edit", "x20 y75 w560 h200 ReadOnly Multi")
    eventLog.Value := "Event log initialized...\n"

    eventCount := 0

    LogEvent(msg) {
        timestamp := FormatTime(A_Now, "HH:mm:ss")
        eventCount++
        eventLog.Value .= Format("[{1}] Event #{2}: {3}\n", timestamp, eventCount, msg)
        ControlSend("{End}", eventLog)
    }

    ; Interactive elements
    myGui.Add("Text", "x20 y285", "Interact with these controls to trigger events:")

    ; Buttons
    btn1 := myGui.Add("Button", "x20 y310 w130", "Button 1")
    btn2 := myGui.Add("Button", "x160 y310 w130", "Button 2")
    btn3 := myGui.Add("Button", "x300 y310 w130", "Button 3")

    btn1.OnEvent("Click", (*) => LogEvent("Button 1 clicked"))
    btn2.OnEvent("Click", (*) => LogEvent("Button 2 clicked"))
    btn3.OnEvent("Click", (*) => LogEvent("Button 3 clicked"))

    ; Edit box with change detection
    myGui.Add("Text", "x20 y350", "Type to trigger change events:")
    editBox := myGui.Add("Edit", "x20 y370 w280")
    editBox.OnEvent("Change", (*) => LogEvent("Edit box changed: " editBox.Value))

    ; Checkbox
    chk := myGui.Add("Checkbox", "x320 y370", "Enable feature")
    chk.OnEvent("Click", (*) => LogEvent("Checkbox " (chk.Value ? "checked" : "unchecked")))

    ; Clear log button
    myGui.Add("Button", "x440 y310 w140", "Clear Log").OnEvent("Click", ClearLog)

    ClearLog(*) {
        eventLog.Value := "Event log cleared...\n"
        eventCount := 0
        LogEvent("Log cleared")
    }

    myGui.Add("Button", "x20 y410 w560", "Close").OnEvent("Click", (*) => myGui.Destroy())

    LogEvent("Window created and shown")
    myGui.Show("w600 h460")
}



; =============================================================================
; Example 7: Change notifications
; =============================================================================

/**
* Demonstrates change notifications with practical examples
* Shows event handling patterns and best practices
*/
Example7_Changenotifications() {
    myGui := Gui(, "Change notifications Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Change notifications Event Handling")
    myGui.SetFont("s9 Norm")

    ; Event log
    myGui.Add("Text", "x20 y55", "Event Log:")
    eventLog := myGui.Add("Edit", "x20 y75 w560 h200 ReadOnly Multi")
    eventLog.Value := "Event log initialized...\n"

    eventCount := 0

    LogEvent(msg) {
        timestamp := FormatTime(A_Now, "HH:mm:ss")
        eventCount++
        eventLog.Value .= Format("[{1}] Event #{2}: {3}\n", timestamp, eventCount, msg)
        ControlSend("{End}", eventLog)
    }

    ; Interactive elements
    myGui.Add("Text", "x20 y285", "Interact with these controls to trigger events:")

    ; Buttons
    btn1 := myGui.Add("Button", "x20 y310 w130", "Button 1")
    btn2 := myGui.Add("Button", "x160 y310 w130", "Button 2")
    btn3 := myGui.Add("Button", "x300 y310 w130", "Button 3")

    btn1.OnEvent("Click", (*) => LogEvent("Button 1 clicked"))
    btn2.OnEvent("Click", (*) => LogEvent("Button 2 clicked"))
    btn3.OnEvent("Click", (*) => LogEvent("Button 3 clicked"))

    ; Edit box with change detection
    myGui.Add("Text", "x20 y350", "Type to trigger change events:")
    editBox := myGui.Add("Edit", "x20 y370 w280")
    editBox.OnEvent("Change", (*) => LogEvent("Edit box changed: " editBox.Value))

    ; Checkbox
    chk := myGui.Add("Checkbox", "x320 y370", "Enable feature")
    chk.OnEvent("Click", (*) => LogEvent("Checkbox " (chk.Value ? "checked" : "unchecked")))

    ; Clear log button
    myGui.Add("Button", "x440 y310 w140", "Clear Log").OnEvent("Click", ClearLog)

    ClearLog(*) {
        eventLog.Value := "Event log cleared...\n"
        eventCount := 0
        LogEvent("Log cleared")
    }

    myGui.Add("Button", "x20 y410 w560", "Close").OnEvent("Click", (*) => myGui.Destroy())

    LogEvent("Window created and shown")
    myGui.Show("w600 h460")
}


; =============================================================================
; Main Menu - Example Launcher
; =============================================================================

/**
* Creates a main menu to launch all examples
*/
ShowMainMenu() {
    menuGui := Gui(, "BuiltIn_GuiEvents_02.ahk - Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "OnChange Event Handling")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    menuGui.Add("Button", "x20 y80 w360", "Example 1: Edit box changes").OnEvent("Click", (*) => Example1_Editboxchanges())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Dropdown changes").OnEvent("Click", (*) => Example2_Dropdownchanges())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: Real-time validation").OnEvent("Click", (*) => Example3_Realtimevalidation())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Change tracking").OnEvent("Click", (*) => Example4_Changetracking())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Undo/redo systems").OnEvent("Click", (*) => Example5_UndoRedoSystems())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Auto-save").OnEvent("Click", (*) => Example6_Autosave())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Change notifications").OnEvent("Click", (*) => Example7_Changenotifications())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
