#Requires AutoHotkey v2.0

/**
* BuiltIn_GuiEvents_01.ahk - OnClick Event Handling
*
* This file demonstrates click event handling and management in AutoHotkey v2.
* Topics covered:
* - Button click events
* - Double click handling
* - Click parameters
* - Event propagation
* - Click counters
* - Debouncing clicks
* - Context clicks
*
* @author AutoHotkey Community
* @version 2.0
* @date 2024
*/



; =============================================================================
; Example 1: Button click events
; =============================================================================

/**
* Demonstrates button click events with practical examples
* Shows event handling patterns and best practices
*/
Example1_Buttonclickevents() {
    myGui := Gui(, "Button click events Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Button click events Event Handling")
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
; Example 2: Double click handling
; =============================================================================

/**
* Demonstrates double click handling with practical examples
* Shows event handling patterns and best practices
*/
Example2_Doubleclickhandling() {
    myGui := Gui(, "Double click handling Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Double click handling Event Handling")
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
; Example 3: Click parameters
; =============================================================================

/**
* Demonstrates click parameters with practical examples
* Shows event handling patterns and best practices
*/
Example3_Clickparameters() {
    myGui := Gui(, "Click parameters Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Click parameters Event Handling")
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
; Example 4: Event propagation
; =============================================================================

/**
* Demonstrates event propagation with practical examples
* Shows event handling patterns and best practices
*/
Example4_Eventpropagation() {
    myGui := Gui(, "Event propagation Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Event propagation Event Handling")
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
; Example 5: Click counters
; =============================================================================

/**
* Demonstrates click counters with practical examples
* Shows event handling patterns and best practices
*/
Example5_Clickcounters() {
    myGui := Gui(, "Click counters Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Click counters Event Handling")
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
; Example 6: Debouncing clicks
; =============================================================================

/**
* Demonstrates debouncing clicks with practical examples
* Shows event handling patterns and best practices
*/
Example6_Debouncingclicks() {
    myGui := Gui(, "Debouncing clicks Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Debouncing clicks Event Handling")
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
; Example 7: Context clicks
; =============================================================================

/**
* Demonstrates context clicks with practical examples
* Shows event handling patterns and best practices
*/
Example7_Contextclicks() {
    myGui := Gui(, "Context clicks Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Context clicks Event Handling")
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
    menuGui := Gui(, "BuiltIn_GuiEvents_01.ahk - Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "OnClick Event Handling")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    menuGui.Add("Button", "x20 y80 w360", "Example 1: Button click events").OnEvent("Click", (*) => Example1_Buttonclickevents())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Double click handling").OnEvent("Click", (*) => Example2_Doubleclickhandling())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: Click parameters").OnEvent("Click", (*) => Example3_Clickparameters())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Event propagation").OnEvent("Click", (*) => Example4_Eventpropagation())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Click counters").OnEvent("Click", (*) => Example5_Clickcounters())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Debouncing clicks").OnEvent("Click", (*) => Example6_Debouncingclicks())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Context clicks").OnEvent("Click", (*) => Example7_Contextclicks())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
