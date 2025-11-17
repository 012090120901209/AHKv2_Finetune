#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * ControlSetStyle - Advanced Customization and Themes
 * ============================================================================
 *
 * Advanced control style customization for themes and visual design.
 *
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 */


;==============================================================================
; Example 1: Theme Presets
;==============================================================================

/**
 * Apply visual theme presets to controls
 *
 * @example
 * Shows how to create and apply different visual themes
 */
Example1_ThemePresets() {
    MyGui := Gui("+Resize", "Example 1: Theme Presets")
    
    MyGui.Add("Text", "w500", "Apply different visual themes:")
    
    TestEdit := MyGui.Add("Edit", "w400 y+20", "Sample Text")
    
    BtnDark := MyGui.Add("Button", "xm y+20 w120", "Dark Theme")
    BtnDark.OnEvent("Click", (*) => ApplyDarkTheme(TestEdit))
    
    BtnLight := MyGui.Add("Button", "x+10 w120", "Light Theme")
    BtnLight.OnEvent("Click", (*) => ApplyLightTheme(TestEdit))
    
    BtnClassic := MyGui.Add("Button", "x+10 w120", "Classic")
    BtnClassic.OnEvent("Click", (*) => ApplyClassic(TestEdit))
    
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")
    
    MyGui.Show()
    
    ApplyDarkTheme(ctrl) {
        ControlSetStyle("+0x00800000", ctrl)  ; Add border
        ResultsEdit.Value := "Applied Dark Theme\n" . ResultsEdit.Value
    }
    
    ApplyLightTheme(ctrl) {
        ControlSetStyle("-0x00800000", ctrl)  ; Remove border
        ResultsEdit.Value := "Applied Light Theme\n" . ResultsEdit.Value
    }
    
    ApplyClassic(ctrl) {
        ControlSetStyle("+0x00800000", ctrl)  ; Add border
        ResultsEdit.Value := "Applied Classic Theme\n" . ResultsEdit.Value
    }
}

;==============================================================================
; Example 2: Border Styles
;==============================================================================

/**
 * Modify border appearance
 *
 * @example
 * Demonstrates different border configurations
 */
Example2_BorderStyles() {
    MyGui := Gui("+Resize", "Example 2: Border Styles")
    
    MyGui.Add("Text", "w500", "Experiment with border styles:")
    
    Edit1 := MyGui.Add("Edit", "w300 y+20", "No Border")
    Edit2 := MyGui.Add("Edit", "w300 y+10", "With Border")
    ControlSetStyle("+0x00800000", Edit2)
    
    BtnToggle := MyGui.Add("Button", "xm y+20 w200", "Toggle Borders")
    BtnToggle.OnEvent("Click", ToggleBorders)
    
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    
    MyGui.Show()
    
    ToggleBorders(*) {
        style1 := ControlGetStyle(Edit1)
        style2 := ControlGetStyle(Edit2)
        
        if (style1 & 0x00800000)
            ControlSetStyle("-0x00800000", Edit1)
        else
            ControlSetStyle("+0x00800000", Edit1)
            
        if (style2 & 0x00800000)
            ControlSetStyle("-0x00800000", Edit2)
        else
            ControlSetStyle("+0x00800000", Edit2)
            
        ResultsEdit.Value := "Toggled borders\n" . ResultsEdit.Value
    }
}

;==============================================================================
; Example 3: Read-Only Styling
;==============================================================================

/**
 * Style read-only controls distinctively
 *
 * @example
 * Makes read-only controls visually distinct
 */
Example3_ReadOnlyStyling() {
    MyGui := Gui("+Resize", "Example 3: Read-Only Styling")
    
    MyGui.Add("Text", "w500", "Style read-only controls:")
    
    Edit1 := MyGui.Add("Edit", "w300 y+20", "Editable")
    Edit2 := MyGui.Add("Edit", "w300 y+10", "Read-Only")
    ControlSetStyle("+0x0800", Edit2)
    
    BtnStyle := MyGui.Add("Button", "xm y+20 w200", "Apply Read-Only Style")
    BtnStyle.OnEvent("Click", StyleReadOnly)
    
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    
    MyGui.Show()
    
    StyleReadOnly(*) {
        ControlSetStyle("+0x0800", Edit2)
        ControlSetStyle("+0x00800000", Edit2)
        ResultsEdit.Value := "Styled read-only control\n" . ResultsEdit.Value
    }
}

;==============================================================================
; Example 4: Dynamic Style Updates
;==============================================================================

/**
 * Update styles based on user interaction
 *
 * @example
 * Changes styles dynamically
 */
Example4_DynamicUpdates() {
    MyGui := Gui("+Resize", "Example 4: Dynamic Style Updates")
    
    MyGui.Add("Text", "w500", "Dynamic style updates:")
    
    TestEdit := MyGui.Add("Edit", "w400 y+20", "Type here")
    TestEdit.OnEvent("Change", OnTextChange)
    
    StatusText := MyGui.Add("Text", "xm y+10 w400", "Status: Normal")
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    
    MyGui.Show()
    
    OnTextChange(ctrl, *) {
        text := ctrl.Value
        if (StrLen(text) > 50) {
            ControlSetStyle("+0x00800000", ctrl)
            StatusText.Value := "Status: Warning - Text too long"
        } else {
            ControlSetStyle("-0x00800000", ctrl)
            StatusText.Value := "Status: Normal"
        }
    }
}

;==============================================================================
; Example 5: Multi-Control Theming
;==============================================================================

/**
 * Apply themes across multiple controls
 *
 * @example
 * Theme entire forms at once
 */
Example5_MultiControlTheming() {
    MyGui := Gui("+Resize", "Example 5: Multi-Control Theming")
    
    MyGui.Add("Text", "w500", "Apply themes to multiple controls:")
    
    controls := []
    loop 5 {
        controls.Push(MyGui.Add("Edit", "w200 y+10", "Edit " . A_Index))
    }
    
    BtnTheme1 := MyGui.Add("Button", "xm y+20 w150", "Theme 1")
    BtnTheme1.OnEvent("Click", (*) => ApplyTheme1(controls))
    
    BtnTheme2 := MyGui.Add("Button", "x+10 w150", "Theme 2")
    BtnTheme2.OnEvent("Click", (*) => ApplyTheme2(controls))
    
    MyGui.Show()
    
    ApplyTheme1(ctrls) {
        for ctrl in ctrls
            ControlSetStyle("+0x00800000", ctrl)
    }
    
    ApplyTheme2(ctrls) {
        for ctrl in ctrls
            ControlSetStyle("-0x00800000", ctrl)
    }
}

;==============================================================================
; Example 6: Animated Style Transitions
;==============================================================================

/**
 * Create smooth style transitions
 *
 * @example
 * Animated style changes
 */
Example6_AnimatedTransitions() {
    MyGui := Gui("+Resize", "Example 6: Animated Style Transitions")
    
    MyGui.Add("Text", "w500", "Animated style transitions:")
    
    TestEdit := MyGui.Add("Edit", "w400 y+20", "Watch the animation")
    
    BtnAnimate := MyGui.Add("Button", "xm y+20 w200", "Animate Styles")
    BtnAnimate.OnEvent("Click", AnimateStyles)
    
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    
    MyGui.Show()
    
    AnimateStyles(*) {
        ; Toggle border multiple times for animation effect
        loop 5 {
            ControlSetStyle("+0x00800000", TestEdit)
            Sleep(100)
            ControlSetStyle("-0x00800000", TestEdit)
            Sleep(100)
        }
        ResultsEdit.Value := "Animation complete\n" . ResultsEdit.Value
    }
}

;==============================================================================
; Example 7: Style Validation
;==============================================================================

/**
 * Validate style changes were successful
 *
 * @example
 * Ensures styles are properly applied
 */
Example7_StyleValidation() {
    MyGui := Gui("+Resize", "Example 7: Style Validation")
    
    MyGui.Add("Text", "w500", "Validate style modifications:")
    
    TestEdit := MyGui.Add("Edit", "w400 y+20", "Test")
    
    BtnValidate := MyGui.Add("Button", "xm y+20 w200", "Test & Validate")
    BtnValidate.OnEvent("Click", ValidateStyles)
    
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")
    
    MyGui.Show()
    
    ValidateStyles(*) {
        results := "=== VALIDATION TEST ===\n\n"
        
        oldStyle := ControlGetStyle(TestEdit)
        ControlSetStyle("+0x00800000", TestEdit)
        newStyle := ControlGetStyle(TestEdit)
        
        results .= "Added WS_BORDER: " . ((newStyle & 0x00800000) ? "✓ SUCCESS" : "✗ FAILED") . "\n"
        results .= "Old: 0x" . Format("{:08X}", oldStyle) . "\n"
        results .= "New: 0x" . Format("{:08X}", newStyle) . "\n"
        
        ResultsEdit.Value := results
    }
}

;==============================================================================
; Main Menu - Run any example
;==============================================================================

MainGui := Gui("+Resize", "Control Function Examples - Main Menu")
MainGui.Add("Text", "w400", "Select an example to run:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
    "Example 1: Theme Presets",
    "Example 2: Border Styles",
    "Example 3: Read-Only Styling",
    "Example 4: Dynamic Style Updates",
    "Example 5: Multi-Control Theming",
    "Example 6: Animated Style Transitions",
    "Example 7: Style Validation"
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
        case 1: Example1_ThemePresets()
        case 2: Example2_BorderStyles()
        case 3: Example3_ReadOnlyStyling()
        case 4: Example4_DynamicUpdates()
        case 5: Example5_MultiControlTheming()
        case 6: Example6_AnimatedTransitions()
        case 7: Example7_StyleValidation()
    }
}

return
