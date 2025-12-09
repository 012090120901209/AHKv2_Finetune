#Requires AutoHotkey v2.0

/**
* ControlHide - Professional UI Management
*
* Comprehensive examples for AutoHotkey v2.0
* @author AutoHotkey Community
* @date 2025-01-16
* @version 1.0.0
*/


;==============================================================================
; Example 1: Tab-like Interface
;==============================================================================

Example1() {
    MyGui := Gui("+Resize", "Example 1: Tab-like Interface")
    MyGui.Add("Text", "w500", "Create tab-like switching:")

    pages := Map()
    pages["Home"] := []
    pages["Settings"] := []
    pages["About"] := []
    MyGui.Add("Text", "xm y+20", "Current: Home")
    loop 2
    pages["Home"].Push(MyGui.Add("Edit", "xm y+10 w200", "Home" . A_Index))
    loop 2
    pages["Settings"].Push(MyGui.Add("Edit", "xm y+10 w200", "Settings" . A_Index))
    loop 2
    pages["About"].Push(MyGui.Add("Edit", "xm y+10 w200", "About" . A_Index))
    BtnHome := MyGui.Add("Button", "xm y+60 w120", "Home")
    BtnHome.OnEvent("Click", (*) => ShowPage("Home"))
    BtnSettings := MyGui.Add("Button", "x+10 w120", "Settings")
    BtnSettings.OnEvent("Click", (*) => ShowPage("Settings"))
    BtnAbout := MyGui.Add("Button", "x+10 w120", "About")
    BtnAbout.OnEvent("Click", (*) => ShowPage("About"))
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
; Example 2: Feature Flags
;==============================================================================

Example2() {
    MyGui := Gui("+Resize", "Example 2: Feature Flags")
    MyGui.Add("Text", "w500", "Hide based on feature flags:")

    features := Map("beta", false, "experimental", false)
    BetaEdit := MyGui.Add("Edit", "w200 y+20", "Beta Feature")
    ExpEdit := MyGui.Add("Edit", "w200 y+10", "Experimental")
    BetaCheck := MyGui.Add("Checkbox", "xm y+20", "Enable Beta")
    BetaCheck.OnEvent("Click", (*) => ToggleFeature("beta"))
    ExpCheck := MyGui.Add("Checkbox", "xm y+10", "Enable Experimental")
    ExpCheck.OnEvent("Click", (*) => ToggleFeature("experimental"))
    ToggleFeature(name) {
        features[name] := !features[name]
        if (name = "beta") {
            if (features["beta"])
            ControlShow(BetaEdit)
            else
            ControlHide(BetaEdit)
        } else {
            if (features["experimental"])
            ControlShow(ExpEdit)
            else
            ControlHide(ExpEdit)
        }
    }
    ControlHide(BetaEdit)
    ControlHide(ExpEdit)

    MyGui.Show()
}

;==============================================================================
; Example 3: Form States
;==============================================================================

Example3() {
    MyGui := Gui("+Resize", "Example 3: Form States")
    MyGui.Add("Text", "w500", "Manage form state visibility:")

    ViewMode := []
    EditMode := []
    loop 3
    ViewMode.Push(MyGui.Add("Edit", "w200 y+10 ReadOnly", "View " . A_Index))
    loop 3
    EditMode.Push(MyGui.Add("Edit", "w200 y+10", "Edit " . A_Index))
    BtnEdit := MyGui.Add("Button", "xm y+40 w140", "Edit Mode")
    BtnEdit.OnEvent("Click", (*) => SetMode("edit"))
    BtnView := MyGui.Add("Button", "x+10 w140", "View Mode")
    BtnView.OnEvent("Click", (*) => SetMode("view"))
    SetMode(mode) {
        for ctrl in ViewMode
        if (mode = "view")
        ControlShow(ctrl)
        else
        ControlHide(ctrl)
        for ctrl in EditMode
        if (mode = "edit")
        ControlShow(ctrl)
        else
        ControlHide(ctrl)
    }
    SetMode("view")

    MyGui.Show()
}

;==============================================================================
; Example 4: Loading States
;==============================================================================

Example4() {
    MyGui := Gui("+Resize", "Example 4: Loading States")
    MyGui.Add("Text", "w500", "Hide during loading:")

    Content := []
    Loader := []
    loop 3
    Content.Push(MyGui.Add("Edit", "w250 y+10", "Content " . A_Index))
    Loader.Push(MyGui.Add("Text", "xm y+10", "Loading..."))
    BtnLoad := MyGui.Add("Button", "xm y+40 w200", "Load Data")
    BtnLoad.OnEvent("Click", LoadData)
    ShowContent()
    LoadData(*) {
        ShowLoader()
        SetTimer(ShowContent, -2000)
    }
    ShowLoader() {
        for ctrl in Content
        ControlHide(ctrl)
        for ctrl in Loader
        ControlShow(ctrl)
    }
    ShowContent() {
        for ctrl in Loader
        ControlHide(ctrl)
        for ctrl in Content
        ControlShow(ctrl)
    }

    MyGui.Show()
}

;==============================================================================
; Example 5: Responsive Layout
;==============================================================================

Example5() {
    MyGui := Gui("+Resize", "Example 5: Responsive Layout")
    MyGui.Add("Text", "w500", "Hide for different layouts:")

    FullView := []
    CompactView := []
    loop 4
    FullView.Push(MyGui.Add("Edit", "w200 y+10", "Full " . A_Index))
    loop 2
    CompactView.Push(MyGui.Add("Edit", "w200 y+10", "Compact " . A_Index))
    BtnFull := MyGui.Add("Button", "xm y+60 w140", "Full View")
    BtnFull.OnEvent("Click", (*) => SetView("full"))
    BtnCompact := MyGui.Add("Button", "x+10 w140", "Compact View")
    BtnCompact.OnEvent("Click", (*) => SetView("compact"))
    SetView(view) {
        for ctrl in FullView
        if (view = "full")
        ControlShow(ctrl)
        else
        ControlHide(ctrl)
        for ctrl in CompactView
        if (view = "compact")
        ControlShow(ctrl)
        else
        ControlHide(ctrl)
    }
    SetView("full")

    MyGui.Show()
}

;==============================================================================
; Example 6: Access Control
;==============================================================================

Example6() {
    MyGui := Gui("+Resize", "Example 6: Access Control")
    MyGui.Add("Text", "w500", "Hide based on permissions:")

    PublicControls := []
    AdminControls := []
    loop 2
    PublicControls.Push(MyGui.Add("Edit", "w200 y+10", "Public " . A_Index))
    loop 2
    AdminControls.Push(MyGui.Add("Edit", "w200 y+10", "Admin " . A_Index))
    Role := MyGui.Add("DropDownList", "xm y+20 w200", ["Guest", "User", "Admin"])
    Role.Choose(1)
    Role.OnEvent("Change", UpdateAccess)
    UpdateAccess(*) {
        role := Role.Text
        if (role = "Admin") {
            for ctrl in AdminControls
            ControlShow(ctrl)
        } else {
            for ctrl in AdminControls
            ControlHide(ctrl)
        }
    }
    UpdateAccess()

    MyGui.Show()
}

;==============================================================================
; Example 7: Error States
;==============================================================================

Example7() {
    MyGui := Gui("+Resize", "Example 7: Error States")
    MyGui.Add("Text", "w500", "Show/hide error messages:")

    Input := MyGui.Add("Edit", "w300 y+20", "")
    ErrorMsg := MyGui.Add("Text", "xm y+10 w300 cRed", "✗ Invalid input")
    ControlHide(ErrorMsg)
    Input.OnEvent("Change", Validate)
    Validate(ctrl, *) {
        if (StrLen(ctrl.Value) > 0 && InStr(ctrl.Value, "@"))
        ControlHide(ErrorMsg)
        else if (StrLen(ctrl.Value) > 0)
        ControlShow(ErrorMsg)
    }

    MyGui.Show()
}


;==============================================================================
; Main Menu
;==============================================================================

MainGui := Gui("+Resize", "Examples Menu")
MainGui.Add("Text", "w400", "Select an example:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
"Example 1: Tab-like Interface",
"Example 2: Feature Flags",
"Example 3: Form States",
"Example 4: Loading States",
"Example 5: Responsive Layout",
"Example 6: Access Control",
"Example 7: Error States",
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
