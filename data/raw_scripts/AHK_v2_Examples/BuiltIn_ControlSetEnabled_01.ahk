#Requires AutoHotkey v2.0

/**
 * ControlSetEnabled - Basic Enable/Disable
 * 
 * Comprehensive examples for AutoHotkey v2.0
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 */


;==============================================================================
; Example 1: Basic Enable/Disable
;==============================================================================

Example1() {
    MyGui := Gui("+Resize", "Example 1: Basic Enable/Disable")
    MyGui.Add("Text", "w500", "Enable and disable controls:")
    
    TestEdit := MyGui.Add("Edit", "w300 y+20", "Test")
    BtnDisable := MyGui.Add("Button", "xm y+20 w140", "Disable")
    BtnDisable.OnEvent("Click", (*) => ControlSetEnabled(false, TestEdit))
    BtnEnable := MyGui.Add("Button", "x+10 w140", "Enable")
    BtnEnable.OnEvent("Click", (*) => ControlSetEnabled(true, TestEdit))
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    
    MyGui.Show()
}

;==============================================================================
; Example 2: Toggle Enable
;==============================================================================

Example2() {
    MyGui := Gui("+Resize", "Example 2: Toggle Enable")
    MyGui.Add("Text", "w500", "Toggle control enabled state:")
    
    TestEdit := MyGui.Add("Edit", "w300 y+20", "Toggle Me")
    BtnToggle := MyGui.Add("Button", "xm y+20 w200", "Toggle Enable")
    BtnToggle.OnEvent("Click", Toggle)
    StatusText := MyGui.Add("Text", "xm y+10 w300", "Status: Enabled")
    Toggle(*) {
        current := ControlGetEnabled(TestEdit)
        ControlSetEnabled(!current, TestEdit)
        StatusText.Value := "Status: " . (!current ? "Enabled" : "Disabled")
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 3: Batch Enable
;==============================================================================

Example3() {
    MyGui := Gui("+Resize", "Example 3: Batch Enable")
    MyGui.Add("Text", "w500", "Enable multiple controls:")
    
    controls := []
    loop 5
        controls.Push(MyGui.Add("Edit", "w200 y+10", "Edit " . A_Index))
    BtnEnableAll := MyGui.Add("Button", "xm y+20 w140", "Enable All")
    BtnEnableAll.OnEvent("Click", EnableAll)
    BtnDisableAll := MyGui.Add("Button", "x+10 w140", "Disable All")
    BtnDisableAll.OnEvent("Click", DisableAll)
    EnableAll(*) {
        for ctrl in controls
            ControlSetEnabled(true, ctrl)
    }
    DisableAll(*) {
        for ctrl in controls
            ControlSetEnabled(false, ctrl)
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 4: Conditional Enable
;==============================================================================

Example4() {
    MyGui := Gui("+Resize", "Example 4: Conditional Enable")
    MyGui.Add("Text", "w500", "Enable based on input:")
    
    Input := MyGui.Add("Edit", "w300 y+20", "")
    Dependent := MyGui.Add("Edit", "w300 y+10", "Dependent field")
    ControlSetEnabled(false, Dependent)
    Input.OnEvent("Change", Check)
    Check(ctrl, *) {
        if (StrLen(ctrl.Value) > 0)
            ControlSetEnabled(true, Dependent)
        else
            ControlSetEnabled(false, Dependent)
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 5: Form Lock
;==============================================================================

Example5() {
    MyGui := Gui("+Resize", "Example 5: Form Lock")
    MyGui.Add("Text", "w500", "Lock/unlock entire form:")
    
    controls := []
    controls.Push(MyGui.Add("Edit", "w200 y+20", "Field 1"))
    controls.Push(MyGui.Add("Edit", "w200 y+10", "Field 2"))
    controls.Push(MyGui.Add("Edit", "w200 y+10", "Field 3"))
    BtnLock := MyGui.Add("Button", "xm y+20 w140", "Lock Form")
    BtnLock.OnEvent("Click", (*) => LockForm(true))
    BtnUnlock := MyGui.Add("Button", "x+10 w140", "Unlock Form")
    BtnUnlock.OnEvent("Click", (*) => LockForm(false))
    LockForm(lock) {
        for ctrl in controls
            ControlSetEnabled(!lock, ctrl)
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 6: Step by Step
;==============================================================================

Example6() {
    MyGui := Gui("+Resize", "Example 6: Step by Step")
    MyGui.Add("Text", "w500", "Enable fields progressively:")
    
    steps := []
    loop 4
        steps.Push(MyGui.Add("Edit", "w250 y+10", "Step " . A_Index))
    for i, step in steps
        if (i > 1)
            ControlSetEnabled(false, step)
    current := 1
    BtnNext := MyGui.Add("Button", "xm y+20 w200", "Next Step")
    BtnNext.OnEvent("Click", Next)
    StatusText := MyGui.Add("Text", "xm y+10 w300", "Step: 1")
    Next(*) {
        if (current < steps.Length) {
            current++
            ControlSetEnabled(true, steps[current])
            StatusText.Value := "Step: " . current
        }
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 7: State Management
;==============================================================================

Example7() {
    MyGui := Gui("+Resize", "Example 7: State Management")
    MyGui.Add("Text", "w500", "Manage control states:")
    
    TestEdit := MyGui.Add("Edit", "w300 y+20", "Managed")
    BtnSaveState := MyGui.Add("Button", "xm y+20 w140", "Save State")
    BtnRestoreState := MyGui.Add("Button", "x+10 w140", "Restore State")
    BtnToggle := MyGui.Add("Button", "xm y+10 w290", "Toggle Now")
    BtnToggle.OnEvent("Click", (*) => ControlSetEnabled(!ControlGetEnabled(TestEdit), TestEdit))
    savedState := true
    BtnSaveState.OnEvent("Click", (*) => savedState := ControlGetEnabled(TestEdit))
    BtnRestoreState.OnEvent("Click", (*) => ControlSetEnabled(savedState, TestEdit))
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h200 ReadOnly Multi")
    
    MyGui.Show()
}


;==============================================================================
; Main Menu
;==============================================================================

MainGui := Gui("+Resize", "Examples Menu")
MainGui.Add("Text", "w400", "Select an example:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
    "Example 1: Basic Enable/Disable",
    "Example 2: Toggle Enable",
    "Example 3: Batch Enable",
    "Example 4: Conditional Enable",
    "Example 5: Form Lock",
    "Example 6: Step by Step",
    "Example 7: State Management",
])

btnRun := MainGui.Add("Button", "w200 y+20", "Run Example")
btnRun.OnEvent("Click", RunSelected)
btnExit := MainGui.Add("Button", "x+10 w200", "Exit")
btnExit.OnEvent("Click", (*) => ExitApp())

MainGui.Show()

RunSelected(*) {
    selected := examplesList.Value
    if (selected = 0) {
        MsgBox("Please select an example", "Info", "Iconi")
        return
    }
    switch selected {
        case 1: Example1()
        case 2: Example2()
        case 3: Example3()
        case 4: Example4()
        case 5: Example5()
        case 6: Example6()
        case 7: Example7()
    }
}

return
