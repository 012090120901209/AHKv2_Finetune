#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ControlHide - Advanced Hiding Techniques
 * 
 * Comprehensive examples for AutoHotkey v2.0
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 */


;==============================================================================
; Example 1: Smart Hide
;==============================================================================

Example1() {
    MyGui := Gui("+Resize", "Example 1: Smart Hide")
    MyGui.Add("Text", "w500", "Hide based on form state:")

    Username := MyGui.Add("Edit", "w200 y+20", "")
    Password := MyGui.Add("Edit", "w200 y+10 Password", "")
    Advanced := MyGui.Add("Edit", "w200 y+10", "Advanced")
    ShowAdv := MyGui.Add("Checkbox", "xm y+10", "Show Advanced")
    ShowAdv.OnEvent("Click", Update)
    Update(*) {
        if (ShowAdv.Value)
            ControlShow(Advanced)
        else
            ControlHide(Advanced)
    }
    ControlHide(Advanced)

    MyGui.Show()
}

;==============================================================================
; Example 2: Group Hide
;==============================================================================

Example2() {
    MyGui := Gui("+Resize", "Example 2: Group Hide")
    MyGui.Add("Text", "w500", "Hide entire groups:")

    Group1 := []
    Group2 := []
    MyGui.Add("Text", "xm y+20", "Group 1:")
    loop 2
        Group1.Push(MyGui.Add("Edit", "xm y+10 w200", "G1-" . A_Index))
    MyGui.Add("Text", "xm y+20", "Group 2:")
    loop 2
        Group2.Push(MyGui.Add("Edit", "xm y+10 w200", "G2-" . A_Index))
    Btn1 := MyGui.Add("Button", "xm y+20 w140", "Hide Group 1")
    Btn1.OnEvent("Click", (*) => HideGroup(Group1))
    Btn2 := MyGui.Add("Button", "x+10 w140", "Hide Group 2")
    Btn2.OnEvent("Click", (*) => HideGroup(Group2))
    HideGroup(grp) {
        for ctrl in grp
            ControlHide(ctrl)
    }

    MyGui.Show()
}

;==============================================================================
; Example 3: Cascade Hide
;==============================================================================

Example3() {
    MyGui := Gui("+Resize", "Example 3: Cascade Hide")
    MyGui.Add("Text", "w500", "Hide in cascade:")

    controls := []
    loop 5
        controls.Push(MyGui.Add("Edit", "w200 y+10", "Level " . A_Index))
    BtnCascade := MyGui.Add("Button", "xm y+20 w200", "Cascade Hide")
    BtnCascade.OnEvent("Click", Cascade)
    Cascade(*) {
        for ctrl in controls {
            ControlHide(ctrl)
            Sleep(150)
        }
    }

    MyGui.Show()
}

;==============================================================================
; Example 4: Wizard Steps
;==============================================================================

Example4() {
    MyGui := Gui("+Resize", "Example 4: Wizard Steps")
    MyGui.Add("Text", "w500", "Hide completed steps:")

    steps := []
    loop 4
        steps.Push(MyGui.Add("Edit", "w250 y+10", "Step " . A_Index))
    current := 1
    BtnNext := MyGui.Add("Button", "xm y+20 w200", "Next Step")
    BtnNext.OnEvent("Click", Next)
    StatusText := MyGui.Add("Text", "xm y+10 w300", "Step: 1/4")
    Next(*) {
        if (current < steps.Length) {
            ControlHide(steps[current])
            current++
            StatusText.Value := "Step: " . current . "/" . steps.Length
        }
    }

    MyGui.Show()
}

;==============================================================================
; Example 5: Modal Dialog
;==============================================================================

Example5() {
    MyGui := Gui("+Resize", "Example 5: Modal Dialog")
    MyGui.Add("Text", "w500", "Simulate modal behavior:")

    MainContent := MyGui.Add("Edit", "w300 y+20", "Main")
    ModalContent := MyGui.Add("Edit", "w300 y+10", "Modal")
    BtnModal := MyGui.Add("Button", "xm y+20 w200", "Show Modal")
    BtnModal.OnEvent("Click", ShowModal)
    BtnClose := MyGui.Add("Button", "x+10 w200", "Close Modal")
    BtnClose.OnEvent("Click", CloseModal)
    ControlHide(ModalContent)
    ControlHide(BtnClose)
    ShowModal(*) {
        ControlHide(MainContent)
        ControlHide(BtnModal)
        ControlShow(ModalContent)
        ControlShow(BtnClose)
    }
    CloseModal(*) {
        ControlShow(MainContent)
        ControlShow(BtnModal)
        ControlHide(ModalContent)
        ControlHide(BtnClose)
    }

    MyGui.Show()
}

;==============================================================================
; Example 6: Timed Hide
;==============================================================================

Example6() {
    MyGui := Gui("+Resize", "Example 6: Timed Hide")
    MyGui.Add("Text", "w500", "Hide after delay:")

    TestEdit := MyGui.Add("Edit", "w300 y+20", "Will hide in 3s")
    BtnStart := MyGui.Add("Button", "xm y+20 w200", "Start Timer")
    BtnStart.OnEvent("Click", StartTimer)
    StatusText := MyGui.Add("Text", "xm y+10 w300", "")
    StartTimer(*) {
        StatusText.Value := "Hiding in 3 seconds..."
        SetTimer(HideIt, -3000)
    }
    HideIt() {
        ControlHide(TestEdit)
        StatusText.Value := "Hidden!"
    }

    MyGui.Show()
}

;==============================================================================
; Example 7: Smart Collapse
;==============================================================================

Example7() {
    MyGui := Gui("+Resize", "Example 7: Smart Collapse")
    MyGui.Add("Text", "w500", "Collapse/expand sections:")

    Section1 := []
    Section2 := []
    MyGui.Add("Text", "xm y+20", "▼ Section 1")
    loop 2
        Section1.Push(MyGui.Add("Edit", "xm y+10 w200", "Field " . A_Index))
    BtnCollapse := MyGui.Add("Button", "xm y+20 w200", "Collapse Section 1")
    BtnCollapse.OnEvent("Click", Collapse)
    collapsed := false
    Collapse(*) {
        collapsed := !collapsed
        for ctrl in Section1
            if (collapsed)
                ControlHide(ctrl)
            else
                ControlShow(ctrl)
        BtnCollapse.Value := collapsed ? "Expand Section 1" : "Collapse Section 1"
    }

    MyGui.Show()
}


;==============================================================================
; Main Menu
;==============================================================================

MainGui := Gui("+Resize", "Examples Menu")
MainGui.Add("Text", "w400", "Select an example:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
    "Example 1: Smart Hide",
    "Example 2: Group Hide",
    "Example 3: Cascade Hide",
    "Example 4: Wizard Steps",
    "Example 5: Modal Dialog",
    "Example 6: Timed Hide",
    "Example 7: Smart Collapse",
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
