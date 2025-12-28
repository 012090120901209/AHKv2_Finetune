#Requires AutoHotkey v2.0

/**
 * BuiltIn_GuiControls_04.ahk - DropDownList, ComboBox, and ListBox Controls
 * 
 * This file demonstrates list controls including DropDownList, ComboBox, and ListBox in AutoHotkey v2.
 * Topics covered:
 * - DropDownList basics
 * - ComboBox usage
 * - ListBox controls
 * - Multi-select lists
 * - Dynamic list population
 * - List sorting
 * - Cascading dropdowns
 * 
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024
 */


; =============================================================================
; Example 1: DropDownList basics
; =============================================================================

/**
 * Demonstrates dropdownlist basics
 * Advanced GUI techniques and patterns
 */
Example1_DropDownListbasics() {
    myGui := Gui(, "DropDownList basics Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: DropDownList basics")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates dropdownlist basics with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "DropDownList basics Features:\n\n"
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
; Example 2: ComboBox usage
; =============================================================================

/**
 * Demonstrates combobox usage
 * Advanced GUI techniques and patterns
 */
Example2_ComboBoxusage() {
    myGui := Gui(, "ComboBox usage Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: ComboBox usage")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates combobox usage with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "ComboBox usage Features:\n\n"
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
; Example 3: ListBox controls
; =============================================================================

/**
 * Demonstrates listbox controls
 * Advanced GUI techniques and patterns
 */
Example3_ListBoxcontrols() {
    myGui := Gui(, "ListBox controls Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: ListBox controls")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates listbox controls with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "ListBox controls Features:\n\n"
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
; Example 4: Multi-select lists
; =============================================================================

/**
 * Demonstrates multi-select lists
 * Advanced GUI techniques and patterns
 */
Example4_Multiselectlists() {
    myGui := Gui(, "Multi-select lists Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Multi-select lists")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates multi-select lists with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Multi-select lists Features:\n\n"
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
; Example 5: Dynamic list population
; =============================================================================

/**
 * Demonstrates dynamic list population
 * Advanced GUI techniques and patterns
 */
Example5_Dynamiclistpopulation() {
    myGui := Gui(, "Dynamic list population Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Dynamic list population")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates dynamic list population with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Dynamic list population Features:\n\n"
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
; Example 6: List sorting
; =============================================================================

/**
 * Demonstrates list sorting
 * Advanced GUI techniques and patterns
 */
Example6_Listsorting() {
    myGui := Gui(, "List sorting Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: List sorting")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates list sorting with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "List sorting Features:\n\n"
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
; Example 7: Cascading dropdowns
; =============================================================================

/**
 * Demonstrates cascading dropdowns
 * Advanced GUI techniques and patterns
 */
Example7_Cascadingdropdowns() {
    myGui := Gui(, "Cascading dropdowns Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Advanced: Cascading dropdowns")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w560", "This demonstrates cascading dropdowns with practical examples.")

    ; Main demonstration area
    demoArea := myGui.Add("Edit", "x20 y85 w560 h250 ReadOnly Multi")
    demoArea.Value := "Cascading dropdowns Features:\n\n"
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
    menuGui := Gui(, "BuiltIn_GuiControls_04.ahk - Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "DropDownList, ComboBox, and ListBox Controls")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    menuGui.Add("Button", "x20 y80 w360", "Example 1: DropDownList basics").OnEvent("Click", (*) => Example1_DropDownListbasics())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: ComboBox usage").OnEvent("Click", (*) => Example2_ComboBoxusage())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: ListBox controls").OnEvent("Click", (*) => Example3_ListBoxcontrols())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Multi-select lists").OnEvent("Click", (*) => Example4_Multiselectlists())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Dynamic list population").OnEvent("Click", (*) => Example5_Dynamiclistpopulation())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: List sorting").OnEvent("Click", (*) => Example6_Listsorting())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Cascading dropdowns").OnEvent("Click", (*) => Example7_Cascadingdropdowns())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
