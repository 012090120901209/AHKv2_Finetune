#Requires AutoHotkey v2.0

/**
 * ControlShow - Show Controls Dynamically
 * 
 * Comprehensive examples for AutoHotkey v2.0
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 */


;==============================================================================
; Example 1: Basic Show
;==============================================================================

Example1() {
    MyGui := Gui("+Resize", "Example 1: Basic Show")
    MyGui.Add("Text", "w500", "Show hidden controls:")
    
    Edit1 := MyGui.Add("Edit", "w250 y+20", "Visible")
    Edit2 := MyGui.Add("Edit", "w250 y+10", "Hidden")
    ControlHide(Edit2)
    BtnShow := MyGui.Add("Button", "xm y+20 w200", "Show Edit2")
    BtnShow.OnEvent("Click", (*) => ControlShow(Edit2))
    BtnHide := MyGui.Add("Button", "x+10 w200", "Hide Edit2")
    BtnHide.OnEvent("Click", (*) => ControlHide(Edit2))
    
    MyGui.Show()
}

;==============================================================================
; Example 2: Show Multiple
;==============================================================================

Example2() {
    MyGui := Gui("+Resize", "Example 2: Show Multiple")
    MyGui.Add("Text", "w500", "Show several controls:")
    
    controls := []
    loop 5 {
        ctrl := MyGui.Add("Edit", "w200 y+10", "Edit " . A_Index)
        ControlHide(ctrl)
        controls.Push(ctrl)
    }
    BtnShowAll := MyGui.Add("Button", "xm y+20 w200", "Show All")
    BtnShowAll.OnEvent("Click", ShowAll)
    ShowAll(*) {
        for ctrl in controls
            ControlShow(ctrl)
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 3: Progressive Disclosure
;==============================================================================

Example3() {
    MyGui := Gui("+Resize", "Example 3: Progressive Disclosure")
    MyGui.Add("Text", "w500", "Show progressively:")
    
    steps := []
    loop 4 {
        step := MyGui.Add("Edit", "w250 y+10", "Step " . A_Index)
        if (A_Index > 1)
            ControlHide(step)
        steps.Push(step)
    }
    current := 1
    BtnNext := MyGui.Add("Button", "xm y+20 w200", "Show Next")
    BtnNext.OnEvent("Click", Next)
    StatusText := MyGui.Add("Text", "xm y+10 w300", "Showing: Step 1")
    Next(*) {
        if (current < steps.Length) {
            current++
            ControlShow(steps[current])
            StatusText.Value := "Showing: Step " . current
        }
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 4: Conditional Show
;==============================================================================

Example4() {
    MyGui := Gui("+Resize", "Example 4: Conditional Show")
    MyGui.Add("Text", "w500", "Show based on input:")
    
    Input := MyGui.Add("Edit", "w300 y+20", "")
    Dependent := MyGui.Add("Edit", "w300 y+10", "Shows when filled")
    ControlHide(Dependent)
    Input.OnEvent("Change", Check)
    Check(ctrl, *) {
        if (StrLen(ctrl.Value) > 3)
            ControlShow(Dependent)
        else
            ControlHide(Dependent)
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 5: Timed Show
;==============================================================================

Example5() {
    MyGui := Gui("+Resize", "Example 5: Timed Show")
    MyGui.Add("Text", "w500", "Show after delay:")
    
    TestEdit := MyGui.Add("Edit", "w300 y+20", "Will appear")
    ControlHide(TestEdit)
    BtnStart := MyGui.Add("Button", "xm y+20 w200", "Show in 3s")
    BtnStart.OnEvent("Click", StartTimer)
    StatusText := MyGui.Add("Text", "xm y+10 w300", "")
    StartTimer(*) {
        StatusText.Value := "Showing in 3 seconds..."
        SetTimer(ShowIt, -3000)
    }
    ShowIt() {
        ControlShow(TestEdit)
        StatusText.Value := "Shown!"
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 6: Menu-Based Show
;==============================================================================

Example6() {
    MyGui := Gui("+Resize", "Example 6: Menu-Based Show")
    MyGui.Add("Text", "w500", "Show based on selection:")
    
    Type := MyGui.Add("DropDownList", "w200 y+20", ["Text", "Number"])
    TextOpts := MyGui.Add("Edit", "xm y+10 w200", "Text Options")
    NumberOpts := MyGui.Add("Edit", "xm y+10 w200", "Number Options")
    Type.Choose(1)
    Type.OnEvent("Change", Update)
    ControlHide(NumberOpts)
    Update(*) {
        if (Type.Text = "Text") {
            ControlShow(TextOpts)
            ControlHide(NumberOpts)
        } else {
            ControlHide(TextOpts)
            ControlShow(NumberOpts)
        }
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 7: Reveal Animation
;==============================================================================

Example7() {
    MyGui := Gui("+Resize", "Example 7: Reveal Animation")
    MyGui.Add("Text", "w500", "Animated reveal:")
    
    TestEdit := MyGui.Add("Edit", "w300 y+20", "Animated")
    ControlHide(TestEdit)
    BtnReveal := MyGui.Add("Button", "xm y+20 w200", "Animate Show")
    BtnReveal.OnEvent("Click", AnimShow)
    AnimShow(*) {
        loop 3 {
            ControlShow(TestEdit)
            Sleep(100)
            ControlHide(TestEdit)
            Sleep(100)
        }
        ControlShow(TestEdit)
    }
    
    MyGui.Show()
}


;==============================================================================
; Main Menu
;==============================================================================

MainGui := Gui("+Resize", "Examples Menu")
MainGui.Add("Text", "w400", "Select an example:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
    "Example 1: Basic Show",
    "Example 2: Show Multiple",
    "Example 3: Progressive Disclosure",
    "Example 4: Conditional Show",
    "Example 5: Timed Show",
    "Example 6: Menu-Based Show",
    "Example 7: Reveal Animation",
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
