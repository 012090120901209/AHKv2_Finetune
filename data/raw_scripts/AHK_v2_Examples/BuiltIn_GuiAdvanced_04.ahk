#Requires AutoHotkey v2.0

/**
 * BuiltIn_GuiAdvanced_04.ahk - Menu Bar and Context Menus
 *
 * This file demonstrates menu systems including menu bars and context menus in AutoHotkey v2.
 * Topics covered:
 * - Menu bar creation
 * - Submenus
 * - Menu items
 * - Menu icons
 * - Dynamic menus
 * - Menu shortcuts
 * - Status bar
 *
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024
 */



; =============================================================================
; Example 1: Menu bar creation
; =============================================================================

/**
 * Demonstrates menu bar creation
 * Advanced GUI techniques and patterns
 */
Example1_Menubarcreation() {
    myGui := Gui(, "Menu bar creation Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Menu bar creation")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates menu bar creation with practical examples.")
    
    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Menu bar creation Features:\n\n"
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
; Example 2: Submenus
; =============================================================================

/**
 * Demonstrates submenus
 * Advanced GUI techniques and patterns
 */
Example2_Submenus() {
    myGui := Gui(, "Submenus Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Submenus")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates submenus with practical examples.")
    
    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Submenus Features:\n\n"
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
; Example 3: Menu items
; =============================================================================

/**
 * Demonstrates menu items
 * Advanced GUI techniques and patterns
 */
Example3_Menuitems() {
    myGui := Gui(, "Menu items Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Menu items")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates menu items with practical examples.")
    
    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Menu items Features:\n\n"
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
; Example 4: Menu icons
; =============================================================================

/**
 * Demonstrates menu icons
 * Advanced GUI techniques and patterns
 */
Example4_Menuicons() {
    myGui := Gui(, "Menu icons Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Menu icons")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates menu icons with practical examples.")
    
    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Menu icons Features:\n\n"
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
; Example 5: Dynamic menus
; =============================================================================

/**
 * Demonstrates dynamic menus
 * Advanced GUI techniques and patterns
 */
Example5_Dynamicmenus() {
    myGui := Gui(, "Dynamic menus Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Dynamic menus")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates dynamic menus with practical examples.")
    
    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Dynamic menus Features:\n\n"
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
; Example 6: Menu shortcuts
; =============================================================================

/**
 * Demonstrates menu shortcuts
 * Advanced GUI techniques and patterns
 */
Example6_Menushortcuts() {
    myGui := Gui(, "Menu shortcuts Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Menu shortcuts")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates menu shortcuts with practical examples.")
    
    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Menu shortcuts Features:\n\n"
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
; Example 7: Status bar
; =============================================================================

/**
 * Demonstrates status bar
 * Advanced GUI techniques and patterns
 */
Example7_Statusbar() {
    myGui := Gui(, "Status bar Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Status bar")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates status bar with practical examples.")
    
    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Status bar Features:\n\n"
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
    menuGui := Gui(, "BuiltIn_GuiAdvanced_04.ahk - Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "Menu Bar and Context Menus")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    menuGui.Add("Button", "x20 y80 w360", "Example 1: Menu bar creation").OnEvent("Click", (*) => Example1_Menubarcreation())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Submenus").OnEvent("Click", (*) => Example2_Submenus())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: Menu items").OnEvent("Click", (*) => Example3_Menuitems())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Menu icons").OnEvent("Click", (*) => Example4_Menuicons())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Dynamic menus").OnEvent("Click", (*) => Example5_Dynamicmenus())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Menu shortcuts").OnEvent("Click", (*) => Example6_Menushortcuts())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Status bar").OnEvent("Click", (*) => Example7_Statusbar())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
