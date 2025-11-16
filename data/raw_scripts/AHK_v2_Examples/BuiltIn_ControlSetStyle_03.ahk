#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * ControlSetStyle - Professional UI Customization
 * ============================================================================
 *
 * Professional-grade UI customization techniques using ControlSetStyle.
 *
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 */


;==============================================================================
; Example 1: Form State Management
;==============================================================================

/**
 * Manage form states with style changes
 *
 * @example
 * Switch between edit and view modes
 */
Example1_FormStates() {
    MyGui := Gui("+Resize", "Example 1: Form State Management")
    
    MyGui.Add("Text", "w500", "Form state management:")
    
    Edit1 := MyGui.Add("Edit", "w300 y+20", "Field 1")
    Edit2 := MyGui.Add("Edit", "w300 y+10", "Field 2")
    Edit3 := MyGui.Add("Edit", "w300 y+10", "Field 3")
    
    BtnEdit := MyGui.Add("Button", "xm y+20 w140", "Edit Mode")
    BtnEdit.OnEvent("Click", EnableEdit)
    
    BtnView := MyGui.Add("Button", "x+10 w140", "View Mode")
    BtnView.OnEvent("Click", EnableView)
    
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    
    MyGui.Show()
    
    EnableEdit(*) {
        for ctrl in [Edit1, Edit2, Edit3] {
            ControlSetStyle("-0x0800", ctrl)
            ControlSetStyle("-0x08000000", ctrl)
        }
        ResultsEdit.Value := "Switched to Edit Mode\n" . ResultsEdit.Value
    }
    
    EnableView(*) {
        for ctrl in [Edit1, Edit2, Edit3] {
            ControlSetStyle("+0x0800", ctrl)
        }
        ResultsEdit.Value := "Switched to View Mode\n" . ResultsEdit.Value
    }
}

;==============================================================================
; Example 2: Accessibility Enhancements
;==============================================================================

/**
 * Improve accessibility with style modifications
 *
 * @example
 * Enhanced visual accessibility
 */
Example2_AccessibilityEnhance() {
    MyGui := Gui("+Resize", "Example 2: Accessibility Enhancements")
    
    MyGui.Add("Text", "w500", "Accessibility enhancements:")
    
    TestEdit := MyGui.Add("Edit", "w400 y+20", "Sample text")
    
    BtnHighContrast := MyGui.Add("Button", "xm y+20 w200", "High Contrast Mode")
    BtnHighContrast.OnEvent("Click", ApplyHighContrast)
    
    BtnNormal := MyGui.Add("Button", "x+10 w200", "Normal Mode")
    BtnNormal.OnEvent("Click", ApplyNormal)
    
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")
    
    MyGui.Show()
    
    ApplyHighContrast(*) {
        ControlSetStyle("+0x00800000", TestEdit)
        ResultsEdit.Value := "Applied high contrast\n" . ResultsEdit.Value
    }
    
    ApplyNormal(*) {
        ControlSetStyle("-0x00800000", TestEdit)
        ResultsEdit.Value := "Applied normal mode\n" . ResultsEdit.Value
    }
}

;==============================================================================
; Example 3: Error State Indication
;==============================================================================

/**
 * Indicate errors with style changes
 *
 * @example
 * Visual error feedback
 */
Example3_ErrorIndication() {
    MyGui := Gui("+Resize", "Example 3: Error State Indication")
    
    MyGui.Add("Text", "w500", "Error state indication:")
    
    EmailEdit := MyGui.Add("Edit", "w300 y+20", "")
    
    BtnValidate := MyGui.Add("Button", "xm y+20 w200", "Validate Email")
    BtnValidate.OnEvent("Click", ValidateEmail)
    
    StatusText := MyGui.Add("Text", "xm y+10 w400", "")
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    
    MyGui.Show()
    
    ValidateEmail(*) {
        email := EmailEdit.Value
        if (InStr(email, "@")) {
            ControlSetStyle("-0x00800000", EmailEdit)
            StatusText.Value := "✓ Valid email"
        } else {
            ControlSetStyle("+0x00800000", EmailEdit)
            StatusText.Value := "✗ Invalid email"
        }
    }
}

;==============================================================================
; Example 4: Progressive Disclosure
;==============================================================================

/**
 * Progressively reveal form fields
 *
 * @example
 * Show fields based on selections
 */
Example4_ProgressiveDisclosure() {
    MyGui := Gui("+Resize", "Example 4: Progressive Disclosure")
    
    MyGui.Add("Text", "w500", "Progressive disclosure:")
    
    Check1 := MyGui.Add("Checkbox", "xm y+20", "Enable advanced options")
    Edit1 := MyGui.Add("Edit", "xm y+10 w300", "Advanced option 1")
    Edit2 := MyGui.Add("Edit", "xm y+10 w300", "Advanced option 2")
    
    ; Initially disable advanced options
    ControlSetStyle("+0x08000000", Edit1)
    ControlSetStyle("+0x08000000", Edit2)
    
    Check1.OnEvent("Click", ToggleAdvanced)
    
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h200 ReadOnly Multi")
    
    MyGui.Show()
    
    ToggleAdvanced(*) {
        if (Check1.Value) {
            ControlSetStyle("-0x08000000", Edit1)
            ControlSetStyle("-0x08000000", Edit2)
            ResultsEdit.Value := "Advanced options enabled\n" . ResultsEdit.Value
        } else {
            ControlSetStyle("+0x08000000", Edit1)
            ControlSetStyle("+0x08000000", Edit2)
            ResultsEdit.Value := "Advanced options disabled\n" . ResultsEdit.Value
        }
    }
}

;==============================================================================
; Example 5: Responsive Styling
;==============================================================================

/**
 * Adjust styles based on content
 *
 * @example
 * Dynamic style adaptation
 */
Example5_ResponsiveStyling() {
    MyGui := Gui("+Resize", "Example 5: Responsive Styling")
    
    MyGui.Add("Text", "w500", "Responsive styling:")
    
    TestEdit := MyGui.Add("Edit", "w400 y+20", "")
    TestEdit.OnEvent("Change", AdaptStyle)
    
    StatusText := MyGui.Add("Text", "xm y+10 w400", "Enter text to see adaptive styling")
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    
    MyGui.Show()
    
    AdaptStyle(ctrl, *) {
        length := StrLen(ctrl.Value)
        
        if (length > 100) {
            ControlSetStyle("+0x00800000", ctrl)
            StatusText.Value := "Style: Warning (text > 100 chars)"
        } else if (length > 50) {
            ControlSetStyle("+0x00800000", ctrl)
            StatusText.Value := "Style: Caution (text > 50 chars)"
        } else {
            ControlSetStyle("-0x00800000", ctrl)
            StatusText.Value := "Style: Normal"
        }
    }
}

;==============================================================================
; Example 6: Focus Visualization
;==============================================================================

/**
 * Enhance focus indication
 *
 * @example
 * Clear focus visualization
 */
Example6_FocusVisualization() {
    MyGui := Gui("+Resize", "Example 6: Focus Visualization")
    
    MyGui.Add("Text", "w500", "Focus visualization:")
    
    Edit1 := MyGui.Add("Edit", "w200 y+20", "Field 1")
    Edit2 := MyGui.Add("Edit", "w200 y+10", "Field 2")
    Edit3 := MyGui.Add("Edit", "w200 y+10", "Field 3")
    
    Edit1.OnEvent("Focus", (*) => OnFocus(Edit1))
    Edit2.OnEvent("Focus", (*) => OnFocus(Edit2))
    Edit3.OnEvent("Focus", (*) => OnFocus(Edit3))
    
    Edit1.OnEvent("LoseFocus", (*) => OnBlur(Edit1))
    Edit2.OnEvent("LoseFocus", (*) => OnBlur(Edit2))
    Edit3.OnEvent("LoseFocus", (*) => OnBlur(Edit3))
    
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    
    MyGui.Show()
    
    OnFocus(ctrl) {
        ControlSetStyle("+0x00800000", ctrl)
        ResultsEdit.Value := "Focused: " . ctrl.Value . "\n" . ResultsEdit.Value
    }
    
    OnBlur(ctrl) {
        ControlSetStyle("-0x00800000", ctrl)
        ResultsEdit.Value := "Blurred: " . ctrl.Value . "\n" . ResultsEdit.Value
    }
}

;==============================================================================
; Example 7: Style Persistence
;==============================================================================

/**
 * Save and restore custom styles
 *
 * @example
 * Persistent style configurations
 */
Example7_StylePersistence() {
    MyGui := Gui("+Resize", "Example 7: Style Persistence")
    
    MyGui.Add("Text", "w500", "Style persistence:")
    
    TestEdit := MyGui.Add("Edit", "w400 y+20", "Test")
    
    BtnSave := MyGui.Add("Button", "xm y+20 w140", "Save Style")
    BtnSave.OnEvent("Click", SaveStyle)
    
    BtnRestore := MyGui.Add("Button", "x+10 w140", "Restore Style")
    BtnRestore.OnEvent("Click", RestoreStyle)
    
    BtnModify := MyGui.Add("Button", "x+10 w140", "Modify Style")
    BtnModify.OnEvent("Click", ModifyStyle)
    
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")
    
    savedStyle := 0
    
    MyGui.Show()
    
    SaveStyle(*) {
        savedStyle := ControlGetStyle(TestEdit)
        ResultsEdit.Value := "Saved style: 0x" . Format("{:08X}", savedStyle) . "\n" . ResultsEdit.Value
    }
    
    RestoreStyle(*) {
        if (savedStyle) {
            ControlSetStyle(savedStyle, TestEdit)
            ResultsEdit.Value := "Restored style: 0x" . Format("{:08X}", savedStyle) . "\n" . ResultsEdit.Value
        }
    }
    
    ModifyStyle(*) {
        ControlSetStyle("+0x00800000", TestEdit)
        ResultsEdit.Value := "Modified style\n" . ResultsEdit.Value
    }
}

;==============================================================================
; Main Menu - Run any example
;==============================================================================

MainGui := Gui("+Resize", "Control Function Examples - Main Menu")
MainGui.Add("Text", "w400", "Select an example to run:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
    "Example 1: Form State Management",
    "Example 2: Accessibility Enhancements",
    "Example 3: Error State Indication",
    "Example 4: Progressive Disclosure",
    "Example 5: Responsive Styling",
    "Example 6: Focus Visualization",
    "Example 7: Style Persistence"
])

btnRun := MainGui.Add("Button", "w200 y+20", "Run Example")
btnRun.OnEvent("Click", RunSelected)

btnExit := MainGui.Add("Button", "x+10 w200", "Exit")
btnExit.OnEvent("Click", (*) => ExitApp())

MainGui.Show()

RunSelected(*) {
    selected := examplesList.Value
    if (selected = 0) {
        MsgBox("Please select an example first", "Info", "Iconi")
        return
    }

    switch selected {
        case 1: Example1_FormStates()
        case 2: Example2_AccessibilityEnhance()
        case 3: Example3_ErrorIndication()
        case 4: Example4_ProgressiveDisclosure()
        case 5: Example5_ResponsiveStyling()
        case 6: Example6_FocusVisualization()
        case 7: Example7_StylePersistence()
    }
}

return
