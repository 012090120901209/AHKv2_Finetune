#Requires AutoHotkey v2.0

/**
* ControlHide - Hide Controls Dynamically
*
* Comprehensive examples for AutoHotkey v2.0
* @author AutoHotkey Community
* @date 2025-01-16
* @version 1.0.0
*/


;==============================================================================
; Example 1: Basic Hide
;==============================================================================

Example1() {
    MyGui := Gui("+Resize", "Example 1: Basic Hide")
    MyGui.Add("Text", "w500", "Hide controls:")

    Edit1 := MyGui.Add("Edit", "w250 y+20", "Visible")
    Edit2 := MyGui.Add("Edit", "w250 y+10", "Will be hidden")
    BtnHide := MyGui.Add("Button", "xm y+20 w200", "Hide Edit2")
    BtnHide.OnEvent("Click", (*) => ControlHide(Edit2))
    BtnShow := MyGui.Add("Button", "x+10 w200", "Show Edit2")
    BtnShow.OnEvent("Click", (*) => ControlShow(Edit2))
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h200 ReadOnly Multi")

    MyGui.Show()
}

;==============================================================================
; Example 2: Hide Multiple
;==============================================================================

Example2() {
    MyGui := Gui("+Resize", "Example 2: Hide Multiple")
    MyGui.Add("Text", "w500", "Hide several controls:")

    controls := []
    loop 5
    controls.Push(MyGui.Add("Edit", "w200 y+10", "Edit " . A_Index))
    BtnHideAll := MyGui.Add("Button", "xm y+20 w200", "Hide All")
    BtnHideAll.OnEvent("Click", HideAll)
    BtnShowAll := MyGui.Add("Button", "x+10 w200", "Show All")
    BtnShowAll.OnEvent("Click", ShowAll)
    HideAll(*) {
        for ctrl in controls
        ControlHide(ctrl)
    }
    ShowAll(*) {
        for ctrl in controls
        ControlShow(ctrl)
    }

    MyGui.Show()
}

;==============================================================================
; Example 3: Conditional Hide
;==============================================================================

Example3() {
    MyGui := Gui("+Resize", "Example 3: Conditional Hide")
    MyGui.Add("Text", "w500", "Hide based on conditions:")

    Input := MyGui.Add("Edit", "w300 y+20", "")
    Dependent := MyGui.Add("Edit", "w300 y+10", "Shows when input filled")
    ControlHide(Dependent)
    Input.OnEvent("Change", Check)
    Check(ctrl, *) {
        if (StrLen(ctrl.Value) > 0)
        ControlShow(Dependent)
        else
        ControlHide(Dependent)
    }

    MyGui.Show()
}

;==============================================================================
; Example 4: Progressive Hide
;==============================================================================

Example4() {
    MyGui := Gui("+Resize", "Example 4: Progressive Hide")
    MyGui.Add("Text", "w500", "Hide progressively:")

    controls := []
    loop 5
    controls.Push(MyGui.Add("Edit", "w200 y+10", "Field " . A_Index))
    BtnHide := MyGui.Add("Button", "xm y+20 w200", "Hide Progressively")
    BtnHide.OnEvent("Click", HideSeq)
    HideSeq(*) {
        for ctrl in controls {
            ControlHide(ctrl)
            Sleep(200)
        }
    }

    MyGui.Show()
}

;==============================================================================
; Example 5: Toggle Hide
;==============================================================================

Example5() {
    MyGui := Gui("+Resize", "Example 5: Toggle Hide")
    MyGui.Add("Text", "w500", "Toggle visibility:")

    TestEdit := MyGui.Add("Edit", "w300 y+20", "Toggle Me")
    BtnToggle := MyGui.Add("Button", "xm y+20 w200", "Toggle")
    BtnToggle.OnEvent("Click", Toggle)
    StatusText := MyGui.Add("Text", "xm y+10 w300", "Status: Visible")
    Toggle(*) {
        if (ControlGetVisible(TestEdit)) {
            ControlHide(TestEdit)
            StatusText.Value := "Status: Hidden"
        } else {
            ControlShow(TestEdit)
            StatusText.Value := "Status: Visible"
        }
    }

    MyGui.Show()
}

;==============================================================================
; Example 6: Context Menu
;==============================================================================

Example6() {
    MyGui := Gui("+Resize", "Example 6: Context Menu")
    MyGui.Add("Text", "w500", "Hide based on selection:")

    Type := MyGui.Add("DropDownList", "w200 y+20", ["Simple", "Advanced"])
    SimpleOpts := MyGui.Add("Edit", "xm y+10 w200", "Simple Options")
    AdvancedOpts := MyGui.Add("Edit", "xm y+10 w200", "Advanced Options")
    Type.Choose(1)
    Type.OnEvent("Change", Update)
    Update(*) {
        if (Type.Text = "Simple") {
            ControlShow(SimpleOpts)
            ControlHide(AdvancedOpts)
        } else {
            ControlHide(SimpleOpts)
            ControlShow(AdvancedOpts)
        }
    }
    Update()

    MyGui.Show()
}

;==============================================================================
; Example 7: Animated Hide
;==============================================================================

Example7() {
    MyGui := Gui("+Resize", "Example 7: Animated Hide")
    MyGui.Add("Text", "w500", "Hide with animation effect:")

    TestEdit := MyGui.Add("Edit", "w300 y+20", "Animated")
    BtnHide := MyGui.Add("Button", "xm y+20 w200", "Animate Hide")
    BtnHide.OnEvent("Click", AnimHide)
    AnimHide(*) {
        loop 3 {
            ControlHide(TestEdit)
            Sleep(100)
            ControlShow(TestEdit)
            Sleep(100)
        }
        ControlHide(TestEdit)
    }

    MyGui.Show()
}


;==============================================================================
; Main Menu
;==============================================================================

MainGui := Gui("+Resize", "Examples Menu")
MainGui.Add("Text", "w400", "Select an example:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
"Example 1: Basic Hide",
"Example 2: Hide Multiple",
"Example 3: Conditional Hide",
"Example 4: Progressive Hide",
"Example 5: Toggle Hide",
"Example 6: Context Menu",
"Example 7: Animated Hide",
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
