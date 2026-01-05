#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_GuiAdvanced_03.ahk - Tab Control Management
 * 
 * This file demonstrates tab controls and navigation in AutoHotkey v2.
 * Topics covered:
 * - Tab creation
 * - Adding pages
 * - Tab navigation
 * - Dynamic tabs
 * - Tab icons
 * - Nested tabs
 * - Tab validation
 * 
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024
 */


; =============================================================================
; Example 1: Tab creation
; =============================================================================

/**
 * Demonstrates tab creation
 * Advanced GUI techniques and patterns
 */
Example1_Tabcreation() {
    myGui := Gui(, "Tab creation Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Tab creation")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates tab creation with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Tab creation Features:\n\n"
    demoArea.Value .= "• Feature 1: Core functionality\n"
    demoArea.Value .= "• Feature 2: Event handling\n"
    demoArea.Value .= "• Feature 3: Data management\n"
    demoArea.Value .= "• Feature 4: User interaction\n"
    demoArea.Value .= "• Feature 5: Advanced options\n"
    demoArea.Value .= "• Feature 6: Error handling\n"
    demoArea.Value .= "• Feature 7: Best practices\n\n"
    demoArea.Value .= "Click the buttons below to see each feature in action."

    ; Interactive controls
    myGui.Add("Text", "x20 y350", "Interactive Controls:")

    ; Feature toggles
    toggle1 := myGui.Add("Checkbox", "x20 y375", "Enable Feature A")
    toggle2 := myGui.Add("Checkbox", "x200 y375", "Enable Feature B")
    toggle3 := myGui.Add("Checkbox", "x380 y375 Checked", "Enable Feature C")

    statusText := myGui.Add("Text", "x20 y405 w560 h30 Border BackgroundWhite", "Status: Ready")

    toggle1.OnEvent("Click", UpdateStatus)
    toggle2.OnEvent("Click", UpdateStatus)
    toggle3.OnEvent("Click", UpdateStatus)

    UpdateStatus(*) {
        enabled := []
        if (toggle1.Value) enabled.Push("A")
            if (toggle2.Value) enabled.Push("B")
                if (toggle3.Value) enabled.Push("C")
                    if (enabled.Length > 0) {
                        statusText.Value := "Status: Features " enabled.Join(", ") " enabled"
                    } else {
                        statusText.Value := "Status: No features enabled"
                    }
    }

    ; Action buttons
    myGui.Add("Button", "x20 y445 w180", "Execute Action").OnEvent("Click", (*) => MsgBox("Action executed!", "Info"))
    myGui.Add("Button", "x210 y445 w180", "Reset Settings").OnEvent("Click", ResetSettings)
    myGui.Add("Button", "x400 y445 w180", "Close").OnEvent("Click", (*) => myGui.Destroy())

    ResetSettings(*) {
        toggle1.Value := 0
        toggle2.Value := 0
        toggle3.Value := 1
        UpdateStatus()
    }

    UpdateStatus()
    myGui.Show("w600 h495")
}


; =============================================================================
; Example 2: Adding pages
; =============================================================================

/**
 * Demonstrates adding pages
 * Advanced GUI techniques and patterns
 */
Example2_Addingpages() {
    myGui := Gui(, "Adding pages Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Adding pages")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates adding pages with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Adding pages Features:\n\n"
    demoArea.Value .= "• Feature 1: Core functionality\n"
    demoArea.Value .= "• Feature 2: Event handling\n"
    demoArea.Value .= "• Feature 3: Data management\n"
    demoArea.Value .= "• Feature 4: User interaction\n"
    demoArea.Value .= "• Feature 5: Advanced options\n"
    demoArea.Value .= "• Feature 6: Error handling\n"
    demoArea.Value .= "• Feature 7: Best practices\n\n"
    demoArea.Value .= "Click the buttons below to see each feature in action."

    ; Interactive controls
    myGui.Add("Text", "x20 y350", "Interactive Controls:")

    ; Feature toggles
    toggle1 := myGui.Add("Checkbox", "x20 y375", "Enable Feature A")
    toggle2 := myGui.Add("Checkbox", "x200 y375", "Enable Feature B")
    toggle3 := myGui.Add("Checkbox", "x380 y375 Checked", "Enable Feature C")

    statusText := myGui.Add("Text", "x20 y405 w560 h30 Border BackgroundWhite", "Status: Ready")

    toggle1.OnEvent("Click", UpdateStatus)
    toggle2.OnEvent("Click", UpdateStatus)
    toggle3.OnEvent("Click", UpdateStatus)

    UpdateStatus(*) {
        enabled := []
        if (toggle1.Value) enabled.Push("A")
            if (toggle2.Value) enabled.Push("B")
                if (toggle3.Value) enabled.Push("C")
                    if (enabled.Length > 0) {
                        statusText.Value := "Status: Features " enabled.Join(", ") " enabled"
                    } else {
                        statusText.Value := "Status: No features enabled"
                    }
    }

    ; Action buttons
    myGui.Add("Button", "x20 y445 w180", "Execute Action").OnEvent("Click", (*) => MsgBox("Action executed!", "Info"))
    myGui.Add("Button", "x210 y445 w180", "Reset Settings").OnEvent("Click", ResetSettings)
    myGui.Add("Button", "x400 y445 w180", "Close").OnEvent("Click", (*) => myGui.Destroy())

    ResetSettings(*) {
        toggle1.Value := 0
        toggle2.Value := 0
        toggle3.Value := 1
        UpdateStatus()
    }

    UpdateStatus()
    myGui.Show("w600 h495")
}


; =============================================================================
; Example 3: Tab navigation
; =============================================================================

/**
 * Demonstrates tab navigation
 * Advanced GUI techniques and patterns
 */
Example3_Tabnavigation() {
    myGui := Gui(, "Tab navigation Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Tab navigation")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates tab navigation with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Tab navigation Features:\n\n"
    demoArea.Value .= "• Feature 1: Core functionality\n"
    demoArea.Value .= "• Feature 2: Event handling\n"
    demoArea.Value .= "• Feature 3: Data management\n"
    demoArea.Value .= "• Feature 4: User interaction\n"
    demoArea.Value .= "• Feature 5: Advanced options\n"
    demoArea.Value .= "• Feature 6: Error handling\n"
    demoArea.Value .= "• Feature 7: Best practices\n\n"
    demoArea.Value .= "Click the buttons below to see each feature in action."

    ; Interactive controls
    myGui.Add("Text", "x20 y350", "Interactive Controls:")

    ; Feature toggles
    toggle1 := myGui.Add("Checkbox", "x20 y375", "Enable Feature A")
    toggle2 := myGui.Add("Checkbox", "x200 y375", "Enable Feature B")
    toggle3 := myGui.Add("Checkbox", "x380 y375 Checked", "Enable Feature C")

    statusText := myGui.Add("Text", "x20 y405 w560 h30 Border BackgroundWhite", "Status: Ready")

    toggle1.OnEvent("Click", UpdateStatus)
    toggle2.OnEvent("Click", UpdateStatus)
    toggle3.OnEvent("Click", UpdateStatus)

    UpdateStatus(*) {
        enabled := []
        if (toggle1.Value) enabled.Push("A")
            if (toggle2.Value) enabled.Push("B")
                if (toggle3.Value) enabled.Push("C")
                    if (enabled.Length > 0) {
                        statusText.Value := "Status: Features " enabled.Join(", ") " enabled"
                    } else {
                        statusText.Value := "Status: No features enabled"
                    }
    }

    ; Action buttons
    myGui.Add("Button", "x20 y445 w180", "Execute Action").OnEvent("Click", (*) => MsgBox("Action executed!", "Info"))
    myGui.Add("Button", "x210 y445 w180", "Reset Settings").OnEvent("Click", ResetSettings)
    myGui.Add("Button", "x400 y445 w180", "Close").OnEvent("Click", (*) => myGui.Destroy())

    ResetSettings(*) {
        toggle1.Value := 0
        toggle2.Value := 0
        toggle3.Value := 1
        UpdateStatus()
    }

    UpdateStatus()
    myGui.Show("w600 h495")
}


; =============================================================================
; Example 4: Dynamic tabs
; =============================================================================

/**
 * Demonstrates dynamic tabs
 * Advanced GUI techniques and patterns
 */
Example4_Dynamictabs() {
    myGui := Gui(, "Dynamic tabs Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Dynamic tabs")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates dynamic tabs with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Dynamic tabs Features:\n\n"
    demoArea.Value .= "• Feature 1: Core functionality\n"
    demoArea.Value .= "• Feature 2: Event handling\n"
    demoArea.Value .= "• Feature 3: Data management\n"
    demoArea.Value .= "• Feature 4: User interaction\n"
    demoArea.Value .= "• Feature 5: Advanced options\n"
    demoArea.Value .= "• Feature 6: Error handling\n"
    demoArea.Value .= "• Feature 7: Best practices\n\n"
    demoArea.Value .= "Click the buttons below to see each feature in action."

    ; Interactive controls
    myGui.Add("Text", "x20 y350", "Interactive Controls:")

    ; Feature toggles
    toggle1 := myGui.Add("Checkbox", "x20 y375", "Enable Feature A")
    toggle2 := myGui.Add("Checkbox", "x200 y375", "Enable Feature B")
    toggle3 := myGui.Add("Checkbox", "x380 y375 Checked", "Enable Feature C")

    statusText := myGui.Add("Text", "x20 y405 w560 h30 Border BackgroundWhite", "Status: Ready")

    toggle1.OnEvent("Click", UpdateStatus)
    toggle2.OnEvent("Click", UpdateStatus)
    toggle3.OnEvent("Click", UpdateStatus)

    UpdateStatus(*) {
        enabled := []
        if (toggle1.Value) enabled.Push("A")
            if (toggle2.Value) enabled.Push("B")
                if (toggle3.Value) enabled.Push("C")
                    if (enabled.Length > 0) {
                        statusText.Value := "Status: Features " enabled.Join(", ") " enabled"
                    } else {
                        statusText.Value := "Status: No features enabled"
                    }
    }

    ; Action buttons
    myGui.Add("Button", "x20 y445 w180", "Execute Action").OnEvent("Click", (*) => MsgBox("Action executed!", "Info"))
    myGui.Add("Button", "x210 y445 w180", "Reset Settings").OnEvent("Click", ResetSettings)
    myGui.Add("Button", "x400 y445 w180", "Close").OnEvent("Click", (*) => myGui.Destroy())

    ResetSettings(*) {
        toggle1.Value := 0
        toggle2.Value := 0
        toggle3.Value := 1
        UpdateStatus()
    }

    UpdateStatus()
    myGui.Show("w600 h495")
}


; =============================================================================
; Example 5: Tab icons
; =============================================================================

/**
 * Demonstrates tab icons
 * Advanced GUI techniques and patterns
 */
Example5_Tabicons() {
    myGui := Gui(, "Tab icons Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Tab icons")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates tab icons with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Tab icons Features:\n\n"
    demoArea.Value .= "• Feature 1: Core functionality\n"
    demoArea.Value .= "• Feature 2: Event handling\n"
    demoArea.Value .= "• Feature 3: Data management\n"
    demoArea.Value .= "• Feature 4: User interaction\n"
    demoArea.Value .= "• Feature 5: Advanced options\n"
    demoArea.Value .= "• Feature 6: Error handling\n"
    demoArea.Value .= "• Feature 7: Best practices\n\n"
    demoArea.Value .= "Click the buttons below to see each feature in action."

    ; Interactive controls
    myGui.Add("Text", "x20 y350", "Interactive Controls:")

    ; Feature toggles
    toggle1 := myGui.Add("Checkbox", "x20 y375", "Enable Feature A")
    toggle2 := myGui.Add("Checkbox", "x200 y375", "Enable Feature B")
    toggle3 := myGui.Add("Checkbox", "x380 y375 Checked", "Enable Feature C")

    statusText := myGui.Add("Text", "x20 y405 w560 h30 Border BackgroundWhite", "Status: Ready")

    toggle1.OnEvent("Click", UpdateStatus)
    toggle2.OnEvent("Click", UpdateStatus)
    toggle3.OnEvent("Click", UpdateStatus)

    UpdateStatus(*) {
        enabled := []
        if (toggle1.Value) enabled.Push("A")
            if (toggle2.Value) enabled.Push("B")
                if (toggle3.Value) enabled.Push("C")
                    if (enabled.Length > 0) {
                        statusText.Value := "Status: Features " enabled.Join(", ") " enabled"
                    } else {
                        statusText.Value := "Status: No features enabled"
                    }
    }

    ; Action buttons
    myGui.Add("Button", "x20 y445 w180", "Execute Action").OnEvent("Click", (*) => MsgBox("Action executed!", "Info"))
    myGui.Add("Button", "x210 y445 w180", "Reset Settings").OnEvent("Click", ResetSettings)
    myGui.Add("Button", "x400 y445 w180", "Close").OnEvent("Click", (*) => myGui.Destroy())

    ResetSettings(*) {
        toggle1.Value := 0
        toggle2.Value := 0
        toggle3.Value := 1
        UpdateStatus()
    }

    UpdateStatus()
    myGui.Show("w600 h495")
}


; =============================================================================
; Example 6: Nested tabs
; =============================================================================

/**
 * Demonstrates nested tabs
 * Advanced GUI techniques and patterns
 */
Example6_Nestedtabs() {
    myGui := Gui(, "Nested tabs Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Nested tabs")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates nested tabs with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Nested tabs Features:\n\n"
    demoArea.Value .= "• Feature 1: Core functionality\n"
    demoArea.Value .= "• Feature 2: Event handling\n"
    demoArea.Value .= "• Feature 3: Data management\n"
    demoArea.Value .= "• Feature 4: User interaction\n"
    demoArea.Value .= "• Feature 5: Advanced options\n"
    demoArea.Value .= "• Feature 6: Error handling\n"
    demoArea.Value .= "• Feature 7: Best practices\n\n"
    demoArea.Value .= "Click the buttons below to see each feature in action."

    ; Interactive controls
    myGui.Add("Text", "x20 y350", "Interactive Controls:")

    ; Feature toggles
    toggle1 := myGui.Add("Checkbox", "x20 y375", "Enable Feature A")
    toggle2 := myGui.Add("Checkbox", "x200 y375", "Enable Feature B")
    toggle3 := myGui.Add("Checkbox", "x380 y375 Checked", "Enable Feature C")

    statusText := myGui.Add("Text", "x20 y405 w560 h30 Border BackgroundWhite", "Status: Ready")

    toggle1.OnEvent("Click", UpdateStatus)
    toggle2.OnEvent("Click", UpdateStatus)
    toggle3.OnEvent("Click", UpdateStatus)

    UpdateStatus(*) {
        enabled := []
        if (toggle1.Value) enabled.Push("A")
            if (toggle2.Value) enabled.Push("B")
                if (toggle3.Value) enabled.Push("C")
                    if (enabled.Length > 0) {
                        statusText.Value := "Status: Features " enabled.Join(", ") " enabled"
                    } else {
                        statusText.Value := "Status: No features enabled"
                    }
    }

    ; Action buttons
    myGui.Add("Button", "x20 y445 w180", "Execute Action").OnEvent("Click", (*) => MsgBox("Action executed!", "Info"))
    myGui.Add("Button", "x210 y445 w180", "Reset Settings").OnEvent("Click", ResetSettings)
    myGui.Add("Button", "x400 y445 w180", "Close").OnEvent("Click", (*) => myGui.Destroy())

    ResetSettings(*) {
        toggle1.Value := 0
        toggle2.Value := 0
        toggle3.Value := 1
        UpdateStatus()
    }

    UpdateStatus()
    myGui.Show("w600 h495")
}


; =============================================================================
; Example 7: Tab validation
; =============================================================================

/**
 * Demonstrates tab validation
 * Advanced GUI techniques and patterns
 */
Example7_Tabvalidation() {
    myGui := Gui(, "Tab validation Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Tab validation")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates tab validation with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Tab validation Features:\n\n"
    demoArea.Value .= "• Feature 1: Core functionality\n"
    demoArea.Value .= "• Feature 2: Event handling\n"
    demoArea.Value .= "• Feature 3: Data management\n"
    demoArea.Value .= "• Feature 4: User interaction\n"
    demoArea.Value .= "• Feature 5: Advanced options\n"
    demoArea.Value .= "• Feature 6: Error handling\n"
    demoArea.Value .= "• Feature 7: Best practices\n\n"
    demoArea.Value .= "Click the buttons below to see each feature in action."

    ; Interactive controls
    myGui.Add("Text", "x20 y350", "Interactive Controls:")

    ; Feature toggles
    toggle1 := myGui.Add("Checkbox", "x20 y375", "Enable Feature A")
    toggle2 := myGui.Add("Checkbox", "x200 y375", "Enable Feature B")
    toggle3 := myGui.Add("Checkbox", "x380 y375 Checked", "Enable Feature C")

    statusText := myGui.Add("Text", "x20 y405 w560 h30 Border BackgroundWhite", "Status: Ready")

    toggle1.OnEvent("Click", UpdateStatus)
    toggle2.OnEvent("Click", UpdateStatus)
    toggle3.OnEvent("Click", UpdateStatus)

    UpdateStatus(*) {
        enabled := []
        if (toggle1.Value) enabled.Push("A")
            if (toggle2.Value) enabled.Push("B")
                if (toggle3.Value) enabled.Push("C")
                    if (enabled.Length > 0) {
                        statusText.Value := "Status: Features " enabled.Join(", ") " enabled"
                    } else {
                        statusText.Value := "Status: No features enabled"
                    }
    }

    ; Action buttons
    myGui.Add("Button", "x20 y445 w180", "Execute Action").OnEvent("Click", (*) => MsgBox("Action executed!", "Info"))
    myGui.Add("Button", "x210 y445 w180", "Reset Settings").OnEvent("Click", ResetSettings)
    myGui.Add("Button", "x400 y445 w180", "Close").OnEvent("Click", (*) => myGui.Destroy())

    ResetSettings(*) {
        toggle1.Value := 0
        toggle2.Value := 0
        toggle3.Value := 1
        UpdateStatus()
    }

    UpdateStatus()
    myGui.Show("w600 h495")
}


; =============================================================================
; Main Menu - Example Launcher
; =============================================================================

/**
 * Creates a main menu to launch all examples
 */
ShowMainMenu() {
    menuGui := Gui(, "BuiltIn_GuiAdvanced_03.ahk - Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "Tab Control Management")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    menuGui.Add("Button", "x20 y80 w360", "Example 1: Tab creation").OnEvent("Click", (*) => Example1_Tabcreation())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Adding pages").OnEvent("Click", (*) => Example2_Addingpages())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: Tab navigation").OnEvent("Click", (*) => Example3_Tabnavigation())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Dynamic tabs").OnEvent("Click", (*) => Example4_Dynamictabs())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Tab icons").OnEvent("Click", (*) => Example5_Tabicons())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Nested tabs").OnEvent("Click", (*) => Example6_Nestedtabs())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Tab validation").OnEvent("Click", (*) => Example7_Tabvalidation())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
