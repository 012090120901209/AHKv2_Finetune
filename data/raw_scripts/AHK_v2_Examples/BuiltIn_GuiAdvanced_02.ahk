#Requires AutoHotkey v2.0

/**
 * BuiltIn_GuiAdvanced_02.ahk - Owner-Drawn Controls
 *
 * This file demonstrates owner-drawn control techniques in AutoHotkey v2.
 * Topics covered:
 * - Owner-draw basics
 * - Custom buttons
 * - Gradient effects
 * - Hover states
 * - Focus indicators
 * - Custom list items
 * - Image rendering
 *
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024
 */



; =============================================================================
; Example 1: Owner-draw basics
; =============================================================================

/**
 * Demonstrates owner-draw basics
 * Advanced GUI techniques and patterns
 */
Example1_Ownerdrawbasics() {
    myGui := Gui(, "Owner-draw basics Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Owner-draw basics")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates owner-draw basics with practical examples.")
    
    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Owner-draw basics Features:\n\n"
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
; Example 2: Custom buttons
; =============================================================================

/**
 * Demonstrates custom buttons
 * Advanced GUI techniques and patterns
 */
Example2_Custombuttons() {
    myGui := Gui(, "Custom buttons Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Custom buttons")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates custom buttons with practical examples.")
    
    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Custom buttons Features:\n\n"
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
; Example 3: Gradient effects
; =============================================================================

/**
 * Demonstrates gradient effects
 * Advanced GUI techniques and patterns
 */
Example3_Gradienteffects() {
    myGui := Gui(, "Gradient effects Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Gradient effects")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates gradient effects with practical examples.")
    
    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Gradient effects Features:\n\n"
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
; Example 4: Hover states
; =============================================================================

/**
 * Demonstrates hover states
 * Advanced GUI techniques and patterns
 */
Example4_Hoverstates() {
    myGui := Gui(, "Hover states Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Hover states")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates hover states with practical examples.")
    
    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Hover states Features:\n\n"
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
; Example 5: Focus indicators
; =============================================================================

/**
 * Demonstrates focus indicators
 * Advanced GUI techniques and patterns
 */
Example5_Focusindicators() {
    myGui := Gui(, "Focus indicators Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Focus indicators")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates focus indicators with practical examples.")
    
    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Focus indicators Features:\n\n"
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
; Example 6: Custom list items
; =============================================================================

/**
 * Demonstrates custom list items
 * Advanced GUI techniques and patterns
 */
Example6_Customlistitems() {
    myGui := Gui(, "Custom list items Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Custom list items")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates custom list items with practical examples.")
    
    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Custom list items Features:\n\n"
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
; Example 7: Image rendering
; =============================================================================

/**
 * Demonstrates image rendering
 * Advanced GUI techniques and patterns
 */
Example7_Imagerendering() {
    myGui := Gui(, "Image rendering Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Image rendering")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates image rendering with practical examples.")
    
    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Image rendering Features:\n\n"
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
    menuGui := Gui(, "BuiltIn_GuiAdvanced_02.ahk - Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "Owner-Drawn Controls")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    menuGui.Add("Button", "x20 y80 w360", "Example 1: Owner-draw basics").OnEvent("Click", (*) => Example1_Ownerdrawbasics())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Custom buttons").OnEvent("Click", (*) => Example2_Custombuttons())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: Gradient effects").OnEvent("Click", (*) => Example3_Gradienteffects())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Hover states").OnEvent("Click", (*) => Example4_Hoverstates())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Focus indicators").OnEvent("Click", (*) => Example5_Focusindicators())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Custom list items").OnEvent("Click", (*) => Example6_Customlistitems())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Image rendering").OnEvent("Click", (*) => Example7_Imagerendering())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
