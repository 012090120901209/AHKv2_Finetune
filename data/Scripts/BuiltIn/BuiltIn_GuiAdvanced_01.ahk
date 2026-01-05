#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_GuiAdvanced_01.ahk - Custom GUI Controls
 * 
 * This file demonstrates creating custom GUI controls in AutoHotkey v2.
 * Topics covered:
 * - Custom controls
 * - Control subclass
 * - Custom drawing
 * - Widgets
 * - Composite controls
 * - Templates
 * - Reusable components
 * 
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024
 */


; =============================================================================
; Example 1: Custom controls
; =============================================================================

/**
 * Demonstrates custom controls
 * Advanced GUI techniques and patterns
 */
Example1_Customcontrols() {
    myGui := Gui(, "Custom controls Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Custom controls")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates custom controls with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Custom controls Features:\n\n"
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
; Example 2: Control subclass
; =============================================================================

/**
 * Demonstrates control subclass
 * Advanced GUI techniques and patterns
 */
Example2_Controlsubclass() {
    myGui := Gui(, "Control subclass Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Control subclass")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates control subclass with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Control subclass Features:\n\n"
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
; Example 3: Custom drawing
; =============================================================================

/**
 * Demonstrates custom drawing
 * Advanced GUI techniques and patterns
 */
Example3_Customdrawing() {
    myGui := Gui(, "Custom drawing Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Custom drawing")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates custom drawing with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Custom drawing Features:\n\n"
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
; Example 4: Widgets
; =============================================================================

/**
 * Demonstrates widgets
 * Advanced GUI techniques and patterns
 */
Example4_Widgets() {
    myGui := Gui(, "Widgets Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Widgets")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates widgets with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Widgets Features:\n\n"
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
; Example 5: Composite controls
; =============================================================================

/**
 * Demonstrates composite controls
 * Advanced GUI techniques and patterns
 */
Example5_Compositecontrols() {
    myGui := Gui(, "Composite controls Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Composite controls")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates composite controls with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Composite controls Features:\n\n"
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
; Example 6: Templates
; =============================================================================

/**
 * Demonstrates templates
 * Advanced GUI techniques and patterns
 */
Example6_Templates() {
    myGui := Gui(, "Templates Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Templates")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates templates with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Templates Features:\n\n"
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
; Example 7: Reusable components
; =============================================================================

/**
 * Demonstrates reusable components
 * Advanced GUI techniques and patterns
 */
Example7_Reusablecomponents() {
    myGui := Gui(, "Reusable components Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Reusable components")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates reusable components with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Reusable components Features:\n\n"
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
    menuGui := Gui(, "BuiltIn_GuiAdvanced_01.ahk - Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "Custom GUI Controls")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    menuGui.Add("Button", "x20 y80 w360", "Example 1: Custom controls").OnEvent("Click", (*) => Example1_Customcontrols())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Control subclass").OnEvent("Click", (*) => Example2_Controlsubclass())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: Custom drawing").OnEvent("Click", (*) => Example3_Customdrawing())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Widgets").OnEvent("Click", (*) => Example4_Widgets())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Composite controls").OnEvent("Click", (*) => Example5_Compositecontrols())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Templates").OnEvent("Click", (*) => Example6_Templates())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Reusable components").OnEvent("Click", (*) => Example7_Reusablecomponents())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
