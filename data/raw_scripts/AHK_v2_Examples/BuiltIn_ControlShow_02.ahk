#Requires AutoHotkey v2.0

/**
 * ControlShow - Advanced Display Control
 * 
 * Comprehensive examples for AutoHotkey v2.0
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 */


;==============================================================================
; Example 1: Smart Reveal
;==============================================================================

Example1() {
    MyGui := Gui("+Resize", "Example 1: Smart Reveal")
    MyGui.Add("Text", "w500", "Context-aware revealing:")
    
    Basic := MyGui.Add("Edit", "w200 y+20", "Basic")
    Advanced := MyGui.Add("Edit", "w200 y+10", "Advanced")
    Expert := MyGui.Add("Edit", "w200 y+10", "Expert")
    ControlHide(Advanced)
    ControlHide(Expert)
    Level := MyGui.Add("DropDownList", "xm y+20 w200", ["Basic", "Advanced", "Expert"])
    Level.Choose(1)
    Level.OnEvent("Change", UpdateLevel)
    UpdateLevel(*) {
        lvl := Level.Text
        ControlShow(Basic)
        if (lvl = "Advanced" || lvl = "Expert")
            ControlShow(Advanced)
        else
            ControlHide(Advanced)
        if (lvl = "Expert")
            ControlShow(Expert)
        else
            ControlHide(Expert)
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 2: Group Reveal
;==============================================================================

Example2() {
    MyGui := Gui("+Resize", "Example 2: Group Reveal")
    MyGui.Add("Text", "w500", "Show entire groups:")
    
    Group1 := []
    Group2 := []
    MyGui.Add("Text", "xm y+20", "Group 1:")
    loop 2 {
        ctrl := MyGui.Add("Edit", "xm y+10 w200", "G1-" . A_Index)
        ControlHide(ctrl)
        Group1.Push(ctrl)
    }
    MyGui.Add("Text", "xm y+20", "Group 2:")
    loop 2 {
        ctrl := MyGui.Add("Edit", "xm y+10 w200", "G2-" . A_Index)
        ControlHide(ctrl)
        Group2.Push(ctrl)
    }
    Btn1 := MyGui.Add("Button", "xm y+20 w140", "Show Group 1")
    Btn1.OnEvent("Click", (*) => ShowGroup(Group1))
    Btn2 := MyGui.Add("Button", "x+10 w140", "Show Group 2")
    Btn2.OnEvent("Click", (*) => ShowGroup(Group2))
    ShowGroup(grp) {
        for ctrl in grp
            ControlShow(ctrl)
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 3: Cascade Reveal
;==============================================================================

Example3() {
    MyGui := Gui("+Resize", "Example 3: Cascade Reveal")
    MyGui.Add("Text", "w500", "Show in cascade:")
    
    controls := []
    loop 5 {
        ctrl := MyGui.Add("Edit", "w200 y+10", "Level " . A_Index)
        ControlHide(ctrl)
        controls.Push(ctrl)
    }
    BtnCascade := MyGui.Add("Button", "xm y+20 w200", "Cascade Show")
    BtnCascade.OnEvent("Click", Cascade)
    Cascade(*) {
        for ctrl in controls {
            ControlShow(ctrl)
            Sleep(200)
        }
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 4: Wizard Navigation
;==============================================================================

Example4() {
    MyGui := Gui("+Resize", "Example 4: Wizard Navigation")
    MyGui.Add("Text", "w500", "Show wizard steps:")
    
    steps := []
    loop 4 {
        step := MyGui.Add("Edit", "w250 y+10", "Step " . A_Index)
        ControlHide(step)
        steps.Push(step)
    }
    current := 0
    BtnNext := MyGui.Add("Button", "xm y+60 w140", "Next")
    BtnNext.OnEvent("Click", Next)
    BtnPrev := MyGui.Add("Button", "x+10 w140", "Previous")
    BtnPrev.OnEvent("Click", Prev)
    StatusText := MyGui.Add("Text", "xm y+10 w300", "Step: 0/4")
    Next(*) {
        if (current < steps.Length) {
            current++
            ControlShow(steps[current])
            StatusText.Value := "Step: " . current . "/" . steps.Length
        }
    }
    Prev(*) {
        if (current > 0) {
            ControlHide(steps[current])
            current--
            StatusText.Value := "Step: " . current . "/" . steps.Length
        }
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 5: Modal Display
;==============================================================================

Example5() {
    MyGui := Gui("+Resize", "Example 5: Modal Display")
    MyGui.Add("Text", "w500", "Show modal-style:")
    
    MainContent := MyGui.Add("Edit", "w300 y+20", "Main")
    ModalContent := MyGui.Add("Edit", "w300 y+10", "Modal")
    BtnModal := MyGui.Add("Button", "xm y+20 w200", "Show Modal")
    BtnModal.OnEvent("Click", ShowModal)
    BtnClose := MyGui.Add("Button", "x+10 w200", "Close")
    ControlHide(ModalContent)
    ControlHide(BtnClose)
    ShowModal(*) {
        ControlShow(ModalContent)
        ControlShow(BtnClose)
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 6: Expand/Collapse
;==============================================================================

Example6() {
    MyGui := Gui("+Resize", "Example 6: Expand/Collapse")
    MyGui.Add("Text", "w500", "Expandable sections:")
    
    Header := MyGui.Add("Text", "xm y+20 w200", "▶ Section 1")
    Content := []
    loop 3 {
        ctrl := MyGui.Add("Edit", "xm y+10 w200", "Field " . A_Index)
        ControlHide(ctrl)
        Content.Push(ctrl)
    }
    BtnToggle := MyGui.Add("Button", "xm y+20 w200", "Expand")
    BtnToggle.OnEvent("Click", Toggle)
    expanded := false
    Toggle(*) {
        expanded := !expanded
        for ctrl in Content
            if (expanded)
                ControlShow(ctrl)
            else
                ControlHide(ctrl)
        BtnToggle.Value := expanded ? "Collapse" : "Expand"
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 7: Delayed Reveal
;==============================================================================

Example7() {
    MyGui := Gui("+Resize", "Example 7: Delayed Reveal")
    MyGui.Add("Text", "w500", "Show after user action:")
    
    Trigger := MyGui.Add("Button", "w200 y+20", "Click to Reveal")
    Hidden := []
    loop 3 {
        ctrl := MyGui.Add("Edit", "w200 y+10", "Revealed " . A_Index)
        ControlHide(ctrl)
        Hidden.Push(ctrl)
    }
    Trigger.OnEvent("Click", Reveal)
    Reveal(*) {
        for ctrl in Hidden
            ControlShow(ctrl)
        Trigger.Enabled := false
    }
    
    MyGui.Show()
}


;==============================================================================
; Main Menu
;==============================================================================

MainGui := Gui("+Resize", "Examples Menu")
MainGui.Add("Text", "w400", "Select an example:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
    "Example 1: Smart Reveal",
    "Example 2: Group Reveal",
    "Example 3: Cascade Reveal",
    "Example 4: Wizard Navigation",
    "Example 5: Modal Display",
    "Example 6: Expand/Collapse",
    "Example 7: Delayed Reveal",
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
