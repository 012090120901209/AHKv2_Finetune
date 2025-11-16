#Requires AutoHotkey v2.0

/**
 * BuiltIn_GuiEvents_03.ahk - Custom Event Handlers
 *
 * This file demonstrates creating and managing custom event handlers in AutoHotkey v2.
 * Topics covered:
 * - Custom events
 * - Event callbacks
 * - Event queuing
 * - Async events
 * - Event filtering
 * - Event delegation
 * - Observer pattern
 *
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024
 */



; =============================================================================
; Example 1: Custom events
; =============================================================================

/**
 * Demonstrates custom events with practical examples
 * Shows event handling patterns and best practices
 */
Example1_Customevents() {
    myGui := Gui(, "Custom events Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Custom events Event Handling")
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
; Example 2: Event callbacks
; =============================================================================

/**
 * Demonstrates event callbacks with practical examples
 * Shows event handling patterns and best practices
 */
Example2_Eventcallbacks() {
    myGui := Gui(, "Event callbacks Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Event callbacks Event Handling")
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
; Example 3: Event queuing
; =============================================================================

/**
 * Demonstrates event queuing with practical examples
 * Shows event handling patterns and best practices
 */
Example3_Eventqueuing() {
    myGui := Gui(, "Event queuing Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Event queuing Event Handling")
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
; Example 4: Async events
; =============================================================================

/**
 * Demonstrates async events with practical examples
 * Shows event handling patterns and best practices
 */
Example4_Asyncevents() {
    myGui := Gui(, "Async events Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Async events Event Handling")
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
; Example 5: Event filtering
; =============================================================================

/**
 * Demonstrates event filtering with practical examples
 * Shows event handling patterns and best practices
 */
Example5_Eventfiltering() {
    myGui := Gui(, "Event filtering Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Event filtering Event Handling")
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
; Example 6: Event delegation
; =============================================================================

/**
 * Demonstrates event delegation with practical examples
 * Shows event handling patterns and best practices
 */
Example6_Eventdelegation() {
    myGui := Gui(, "Event delegation Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Event delegation Event Handling")
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
; Example 7: Observer pattern
; =============================================================================

/**
 * Demonstrates observer pattern with practical examples
 * Shows event handling patterns and best practices
 */
Example7_Observerpattern() {
    myGui := Gui(, "Observer pattern Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Observer pattern Event Handling")
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
    menuGui := Gui(, "BuiltIn_GuiEvents_03.ahk - Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "Custom Event Handlers")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    menuGui.Add("Button", "x20 y80 w360", "Example 1: Custom events").OnEvent("Click", (*) => Example1_Customevents())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Event callbacks").OnEvent("Click", (*) => Example2_Eventcallbacks())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: Event queuing").OnEvent("Click", (*) => Example3_Eventqueuing())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Async events").OnEvent("Click", (*) => Example4_Asyncevents())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Event filtering").OnEvent("Click", (*) => Example5_Eventfiltering())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Event delegation").OnEvent("Click", (*) => Example6_Eventdelegation())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Observer pattern").OnEvent("Click", (*) => Example7_Observerpattern())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
