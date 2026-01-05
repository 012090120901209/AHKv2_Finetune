#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ControlSetEnabled - Advanced Control
 * 
 * Comprehensive examples for AutoHotkey v2.0
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 */


;==============================================================================
; Example 1: Cascading Enable
;==============================================================================

Example1() {
    MyGui := Gui("+Resize", "Example 1: Cascading Enable")
    MyGui.Add("Text", "w500", "Enable controls in cascade:")

    controls := []
    loop 5
        controls.Push(MyGui.Add("Edit", "w200 y+10", "Level " . A_Index))
    for i, ctrl in controls
        if (i > 1)
            ControlSetEnabled(false, ctrl)
    BtnCascade := MyGui.Add("Button", "xm y+20 w200", "Cascade Enable")
    BtnCascade.OnEvent("Click", Cascade)
    Cascade(*) {
        for i, ctrl in controls {
            ControlSetEnabled(true, ctrl)
            Sleep(200)
        }
    }

    MyGui.Show()
}

;==============================================================================
; Example 2: Role-Based Access
;==============================================================================

Example2() {
    MyGui := Gui("+Resize", "Example 2: Role-Based Access")
    MyGui.Add("Text", "w500", "Enable based on role:")

    adminFields := []
    userFields := []
    adminFields.Push(MyGui.Add("Edit", "w200 y+20", "Admin Field 1"))
    adminFields.Push(MyGui.Add("Edit", "w200 y+10", "Admin Field 2"))
    userFields.Push(MyGui.Add("Edit", "w200 y+10", "User Field"))
    BtnAdmin := MyGui.Add("Button", "xm y+20 w140", "Admin Mode")
    BtnAdmin.OnEvent("Click", (*) => SetRole("admin"))
    BtnUser := MyGui.Add("Button", "x+10 w140", "User Mode")
    BtnUser.OnEvent("Click", (*) => SetRole("user"))
    SetRole(role) {
        for ctrl in adminFields
            ControlSetEnabled(role = "admin", ctrl)
        for ctrl in userFields
            ControlSetEnabled(true, ctrl)
    }

    MyGui.Show()
}

;==============================================================================
; Example 3: Timed Enable
;==============================================================================

Example3() {
    MyGui := Gui("+Resize", "Example 3: Timed Enable")
    MyGui.Add("Text", "w500", "Enable after delay:")

    TestEdit := MyGui.Add("Edit", "w300 y+20", "Will enable in 3s")
    ControlSetEnabled(false, TestEdit)
    BtnStart := MyGui.Add("Button", "xm y+20 w200", "Start Timer")
    BtnStart.OnEvent("Click", StartTimer)
    StatusText := MyGui.Add("Text", "xm y+10 w300", "")
    StartTimer(*) {
        StatusText.Value := "Enabling in 3 seconds..."
        SetTimer(EnableIt, -3000)
    }
    EnableIt() {
        ControlSetEnabled(true, TestEdit)
        StatusText.Value := "Enabled!"
    }

    MyGui.Show()
}

;==============================================================================
; Example 4: Validation-Based
;==============================================================================

Example4() {
    MyGui := Gui("+Resize", "Example 4: Validation-Based")
    MyGui.Add("Text", "w500", "Enable based on validation:")

    Email := MyGui.Add("Edit", "w250 y+20", "")
    Password := MyGui.Add("Edit", "w250 y+10 Password", "")
    Submit := MyGui.Add("Button", "w250 y+10", "Submit")
    ControlSetEnabled(false, Submit)
    Email.OnEvent("Change", Validate)
    Password.OnEvent("Change", Validate)
    Validate(*) {
        validEmail := InStr(Email.Value, "@")
        validPwd := StrLen(Password.Value) >= 6
        ControlSetEnabled(validEmail && validPwd, Submit)
    }

    MyGui.Show()
}

;==============================================================================
; Example 5: Dependency Chain
;==============================================================================

Example5() {
    MyGui := Gui("+Resize", "Example 5: Dependency Chain")
    MyGui.Add("Text", "w500", "Chain enabled dependencies:")

    Step1 := MyGui.Add("Edit", "w200 y+20", "Step 1")
    Step2 := MyGui.Add("Edit", "w200 y+10", "Step 2")
    Step3 := MyGui.Add("Edit", "w200 y+10", "Step 3")
    ControlSetEnabled(false, Step2)
    ControlSetEnabled(false, Step3)
    Step1.OnEvent("Change", (*) => CheckChain())
    Step2.OnEvent("Change", (*) => CheckChain())
    CheckChain() {
        if (StrLen(Step1.Value) > 0)
            ControlSetEnabled(true, Step2)
        if (StrLen(Step2.Value) > 0)
            ControlSetEnabled(true, Step3)
    }

    MyGui.Show()
}

;==============================================================================
; Example 6: Modal Enable
;==============================================================================

Example6() {
    MyGui := Gui("+Resize", "Example 6: Modal Enable")
    MyGui.Add("Text", "w500", "Modal-style enabling:")

    BgEdit := MyGui.Add("Edit", "w300 y+20", "Background")
    ModalEdit := MyGui.Add("Edit", "w300 y+10", "Modal (inactive)")
    ControlSetEnabled(false, ModalEdit)
    BtnModal := MyGui.Add("Button", "xm y+20 w200", "Toggle Modal")
    BtnModal.OnEvent("Click", Toggle)
    Toggle(*) {
        modal := !ControlGetEnabled(ModalEdit)
        ControlSetEnabled(!modal, BgEdit)
        ControlSetEnabled(modal, ModalEdit)
    }

    MyGui.Show()
}

;==============================================================================
; Example 7: Smart Enable
;==============================================================================

Example7() {
    MyGui := Gui("+Resize", "Example 7: Smart Enable")
    MyGui.Add("Text", "w500", "Smart context-aware enabling:")

    Type := MyGui.Add("DropDownList", "w200 y+20", ["Text", "Number", "Date"])
    Input := MyGui.Add("Edit", "w200 y+10", "")
    Type.OnEvent("Change", UpdateInput)
    StatusText := MyGui.Add("Text", "xm y+10 w300", "")
    UpdateInput(*) {
        choice := Type.Text
        if (choice = "Date") {
            ControlSetEnabled(false, Input)
            StatusText.Value := "Date picker would appear"
        } else {
            ControlSetEnabled(true, Input)
            StatusText.Value := "Manual input enabled"
        }
    }

    MyGui.Show()
}


;==============================================================================
; Main Menu
;==============================================================================

MainGui := Gui("+Resize", "Examples Menu")
MainGui.Add("Text", "w400", "Select an example:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
    "Example 1: Cascading Enable",
    "Example 2: Role-Based Access",
    "Example 3: Timed Enable",
    "Example 4: Validation-Based",
    "Example 5: Dependency Chain",
    "Example 6: Modal Enable",
    "Example 7: Smart Enable",
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
