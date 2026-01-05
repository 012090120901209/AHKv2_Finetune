#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ControlShow - Professional UI Patterns
 * 
 * Comprehensive examples for AutoHotkey v2.0
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 */


;==============================================================================
; Example 1: Page Navigation
;==============================================================================

Example1() {
    MyGui := Gui("+Resize", "Example 1: Page Navigation")
    MyGui.Add("Text", "w500", "Navigate between pages:")

    pages := Map()
    pages["Home"] := []
    pages["Settings"] := []
    loop 2 {
        ctrl := MyGui.Add("Edit", "w200 y+10", "Home " . A_Index)
        ControlHide(ctrl)
        pages["Home"].Push(ctrl)
    }
    loop 2 {
        ctrl := MyGui.Add("Edit", "w200 y+10", "Settings " . A_Index)
        ControlHide(ctrl)
        pages["Settings"].Push(ctrl)
    }
    BtnHome := MyGui.Add("Button", "xm y+60 w140", "Home")
    BtnHome.OnEvent("Click", (*) => ShowPage("Home"))
    BtnSettings := MyGui.Add("Button", "x+10 w140", "Settings")
    BtnSettings.OnEvent("Click", (*) => ShowPage("Settings"))
    ShowPage(name) {
        for page, controls in pages {
            for ctrl in controls {
                if (page = name)
                    ControlShow(ctrl)
                else
                    ControlHide(ctrl)
            }
        }
    }
    ShowPage("Home")

    MyGui.Show()
}

;==============================================================================
; Example 2: Feature Unlock
;==============================================================================

Example2() {
    MyGui := Gui("+Resize", "Example 2: Feature Unlock")
    MyGui.Add("Text", "w500", "Unlock features progressively:")

    features := []
    features.Push(MyGui.Add("Edit", "w200 y+20", "Basic Feature"))
    features.Push(MyGui.Add("Edit", "w200 y+10", "Feature 2"))
    features.Push(MyGui.Add("Edit", "w200 y+10", "Feature 3"))
    loop features.Length - 1
        ControlHide(features[A_Index + 1])
    BtnUnlock := MyGui.Add("Button", "xm y+20 w200", "Unlock Next")
    BtnUnlock.OnEvent("Click", Unlock)
    current := 1
    Unlock(*) {
        if (current < features.Length) {
            current++
            ControlShow(features[current])
        }
    }

    MyGui.Show()
}

;==============================================================================
; Example 3: State Transitions
;==============================================================================

Example3() {
    MyGui := Gui("+Resize", "Example 3: State Transitions")
    MyGui.Add("Text", "w500", "Smooth state transitions:")

    states := Map("idle", [], "active", [], "complete", [])
    states["idle"].Push(MyGui.Add("Text", "xm y+20 w200", "Idle"))
    states["active"].Push(MyGui.Add("Text", "xm y+20 w200", "Active"))
    states["complete"].Push(MyGui.Add("Text", "xm y+20 w200", "Complete"))
    BtnStart := MyGui.Add("Button", "xm y+60 w120", "Start")
    BtnStart.OnEvent("Click", (*) => SetState("active"))
    BtnComplete := MyGui.Add("Button", "x+10 w120", "Complete")
    BtnComplete.OnEvent("Click", (*) => SetState("complete"))
    BtnReset := MyGui.Add("Button", "x+10 w120", "Reset")
    BtnReset.OnEvent("Click", (*) => SetState("idle"))
    SetState(name) {
        for state, controls in states {
            for ctrl in controls {
                if (state = name)
                    ControlShow(ctrl)
                else
                    ControlHide(ctrl)
            }
        }
    }
    SetState("idle")

    MyGui.Show()
}

;==============================================================================
; Example 4: Permission Reveal
;==============================================================================

Example4() {
    MyGui := Gui("+Resize", "Example 4: Permission Reveal")
    MyGui.Add("Text", "w500", "Show based on permissions:")

    PublicCtrls := []
    AdminCtrls := []
    loop 2
        PublicCtrls.Push(MyGui.Add("Edit", "w200 y+10", "Public " . A_Index))
    loop 2 {
        ctrl := MyGui.Add("Edit", "w200 y+10", "Admin " . A_Index)
        ControlHide(ctrl)
        AdminCtrls.Push(ctrl)
    }
    Role := MyGui.Add("DropDownList", "xm y+20 w200", ["User", "Admin"])
    Role.Choose(1)
    Role.OnEvent("Change", UpdatePerms)
    UpdatePerms(*) {
        if (Role.Text = "Admin")
            for ctrl in AdminCtrls
                ControlShow(ctrl)
            else
                for ctrl in AdminCtrls
                    ControlHide(ctrl)
    }

    MyGui.Show()
}

;==============================================================================
; Example 5: Loading Complete
;==============================================================================

Example5() {
    MyGui := Gui("+Resize", "Example 5: Loading Complete")
    MyGui.Add("Text", "w500", "Show after loading:")

    Loader := MyGui.Add("Text", "xm y+20 w250", "Loading...")
    Content := []
    loop 3 {
        ctrl := MyGui.Add("Edit", "w250 y+10", "Content " . A_Index)
        ControlHide(ctrl)
        Content.Push(ctrl)
    }
    BtnLoad := MyGui.Add("Button", "xm y+60 w200", "Load")
    BtnLoad.OnEvent("Click", Load)
    Load(*) {
        ControlShow(Loader)
        for ctrl in Content
            ControlHide(ctrl)
        SetTimer(Complete, -2000)
    }
    Complete() {
        ControlHide(Loader)
        for ctrl in Content
            ControlShow(ctrl)
    }
    ControlHide(Loader)

    MyGui.Show()
}

;==============================================================================
; Example 6: Form Completion
;==============================================================================

Example6() {
    MyGui := Gui("+Resize", "Example 6: Form Completion")
    MyGui.Add("Text", "w500", "Show on form completion:")

    fields := []
    loop 3
        fields.Push(MyGui.Add("Edit", "w200 y+10", ""))
    SuccessMsg := MyGui.Add("Text", "xm y+10 w300 cGreen", "✓ Complete!")
    ControlHide(SuccessMsg)
    for field in fields
        field.OnEvent("Change", CheckComplete)
    CheckComplete(*) {
        allFilled := true
        for field in fields
            if (StrLen(field.Value) = 0)
                allFilled := false
        if (allFilled)
            ControlShow(SuccessMsg)
        else
            ControlHide(SuccessMsg)
    }

    MyGui.Show()
}

;==============================================================================
; Example 7: Help System
;==============================================================================

Example7() {
    MyGui := Gui("+Resize", "Example 7: Help System")
    MyGui.Add("Text", "w500", "Show contextual help:")

    Input := MyGui.Add("Edit", "w300 y+20", "")
    HelpText := MyGui.Add("Text", "xm y+10 w300", "Enter your email address")
    ControlHide(HelpText)
    Input.OnEvent("Focus", (*) => ControlShow(HelpText))
    Input.OnEvent("LoseFocus", (*) => ControlHide(HelpText))

    MyGui.Show()
}


;==============================================================================
; Main Menu
;==============================================================================

MainGui := Gui("+Resize", "Examples Menu")
MainGui.Add("Text", "w400", "Select an example:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
    "Example 1: Page Navigation",
    "Example 2: Feature Unlock",
    "Example 3: State Transitions",
    "Example 4: Permission Reveal",
    "Example 5: Loading Complete",
    "Example 6: Form Completion",
    "Example 7: Help System",
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
