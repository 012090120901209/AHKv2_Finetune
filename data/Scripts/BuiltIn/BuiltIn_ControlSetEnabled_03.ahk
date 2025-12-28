#Requires AutoHotkey v2.0

/**
 * ControlSetEnabled - Professional Applications
 * 
 * Comprehensive examples for AutoHotkey v2.0
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 */


;==============================================================================
; Example 1: Workflow States
;==============================================================================

Example1() {
    MyGui := Gui("+Resize", "Example 1: Workflow States")
    MyGui.Add("Text", "w500", "Implement workflow states:")

    controls := Map()
    controls["Draft"] := MyGui.Add("Edit", "w200 y+20", "Draft")
    controls["Review"] := MyGui.Add("Edit", "w200 y+10", "Review")
    controls["Approve"] := MyGui.Add("Edit", "w200 y+10", "Approve")
    state := "draft"
    BtnNext := MyGui.Add("Button", "xm y+20 w200", "Next State")
    BtnNext.OnEvent("Click", NextState)
    StatusText := MyGui.Add("Text", "xm y+10 w300", "State: Draft")
    UpdateState("draft")
    NextState(*) {
        if (state = "draft") {
            UpdateState("review")
        } else if (state = "review") {
            UpdateState("approve")
        }
    }
    UpdateState(newState) {
        state := newState
        ControlSetEnabled(state = "draft", controls["Draft"])
        ControlSetEnabled(state = "review", controls["Review"])
        ControlSetEnabled(state = "approve", controls["Approve"])
        StatusText.Value := "State: " . state
    }

    MyGui.Show()
}

;==============================================================================
; Example 2: Permission System
;==============================================================================

Example2() {
    MyGui := Gui("+Resize", "Example 2: Permission System")
    MyGui.Add("Text", "w500", "Permission-based enabling:")

    permissions := Map("read", true, "write", false, "delete", false)
    ReadEdit := MyGui.Add("Edit", "w200 y+20 ReadOnly", "Read-only")
    WriteEdit := MyGui.Add("Edit", "w200 y+10", "Write")
    DeleteBtn := MyGui.Add("Button", "w200 y+10", "Delete")
    ApplyPermissions()
    BtnGrant := MyGui.Add("Button", "xm y+20 w200", "Grant All")
    BtnGrant.OnEvent("Click", (*) => GrantAll())
    ApplyPermissions() {
        ControlSetEnabled(permissions["write"], WriteEdit)
        ControlSetEnabled(permissions["delete"], DeleteBtn)
    }
    GrantAll() {
        permissions["write"] := true
        permissions["delete"] := true
        ApplyPermissions()
    }

    MyGui.Show()
}

;==============================================================================
; Example 3: Form Wizard
;==============================================================================

Example3() {
    MyGui := Gui("+Resize", "Example 3: Form Wizard")
    MyGui.Add("Text", "w500", "Multi-step wizard:")

    pages := []
    loop 3 {
        page := []
        loop 2
            page.Push(MyGui.Add("Edit", "w200 " . (A_Index = 1 ? "xm" : "x+10") . " y" . (A_Index = 1 ? "+20" : "+0"), "Page" . A_Index - 1 . " Field" . A_Index))
        pages.Push(page)
    }
    currentPage := 1
    BtnNext := MyGui.Add("Button", "xm y+60 w140", "Next")
    BtnNext.OnEvent("Click", Next)
    BtnPrev := MyGui.Add("Button", "x+10 w140", "Previous")
    BtnPrev.OnEvent("Click", Prev)
    ShowPage(1)
    Next(*) {
        if (currentPage < pages.Length) {
            currentPage++
            ShowPage(currentPage)
        }
    }
    Prev(*) {
        if (currentPage > 1) {
            currentPage--
            ShowPage(currentPage)
        }
    }
    ShowPage(page) {
        for i, p in pages {
            for ctrl in p
                ControlSetEnabled(i = page, ctrl)
        }
    }

    MyGui.Show()
}

;==============================================================================
; Example 4: Conditional UI
;==============================================================================

Example4() {
    MyGui := Gui("+Resize", "Example 4: Conditional UI")
    MyGui.Add("Text", "w500", "Dynamic UI based on conditions:")

    Feature1 := MyGui.Add("Checkbox", "xm y+20", "Enable Feature 1")
    Feature1Opts := []
    Feature1Opts.Push(MyGui.Add("Edit", "xm y+10 w200", "Option 1"))
    Feature1Opts.Push(MyGui.Add("Edit", "xm y+10 w200", "Option 2"))
    Feature1.OnEvent("Click", Update)
    Update(*) {
        for opt in Feature1Opts
            ControlSetEnabled(Feature1.Value, opt)
    }
    for opt in Feature1Opts
        ControlSetEnabled(false, opt)

    MyGui.Show()
}

;==============================================================================
; Example 5: Error Recovery
;==============================================================================

Example5() {
    MyGui := Gui("+Resize", "Example 5: Error Recovery")
    MyGui.Add("Text", "w500", "Enable during error recovery:")

    Input := MyGui.Add("Edit", "w300 y+20", "")
    Submit := MyGui.Add("Button", "w300 y+10", "Submit")
    StatusText := MyGui.Add("Text", "xm y+10 w300", "")
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h200 ReadOnly Multi")
    Submit.OnEvent("Click", Process)
    Process(*) {
        ControlSetEnabled(false, Input)
        ControlSetEnabled(false, Submit)
        StatusText.Value := "Processing..."
        SetTimer(Finish, -2000)
    }
    Finish() {
        ControlSetEnabled(true, Input)
        ControlSetEnabled(true, Submit)
        StatusText.Value := "Complete!"
        ResultsEdit.Value := "Processed\n" . ResultsEdit.Value
    }

    MyGui.Show()
}

;==============================================================================
; Example 6: Access Control
;==============================================================================

Example6() {
    MyGui := Gui("+Resize", "Example 6: Access Control")
    MyGui.Add("Text", "w500", "Fine-grained access control:")

    levels := ["Guest", "User", "Admin"]
    controls := Map()
    controls["Public"] := MyGui.Add("Edit", "w200 y+20", "Public")
    controls["User"] := MyGui.Add("Edit", "w200 y+10", "User Only")
    controls["Admin"] := MyGui.Add("Edit", "w200 y+10", "Admin Only")
    Level := MyGui.Add("DropDownList", "xm y+20 w200", levels)
    Level.Choose(1)
    Level.OnEvent("Change", UpdateAccess)
    UpdateAccess(*) {
        level := Level.Text
        ControlSetEnabled(true, controls["Public"])
        ControlSetEnabled(level != "Guest", controls["User"])
        ControlSetEnabled(level = "Admin", controls["Admin"])
    }
    UpdateAccess()

    MyGui.Show()
}

;==============================================================================
; Example 7: Loading States
;==============================================================================

Example7() {
    MyGui := Gui("+Resize", "Example 7: Loading States")
    MyGui.Add("Text", "w500", "Handle loading states:")

    controls := []
    loop 3
        controls.Push(MyGui.Add("Edit", "w250 y+10", "Field " . A_Index))
    BtnLoad := MyGui.Add("Button", "xm y+20 w200", "Load Data")
    BtnLoad.OnEvent("Click", LoadData)
    StatusText := MyGui.Add("Text", "xm y+10 w300", "")
    LoadData(*) {
        for ctrl in controls
            ControlSetEnabled(false, ctrl)
        StatusText.Value := "Loading..."
        SetTimer(Loaded, -1500)
    }
    Loaded() {
        for ctrl in controls
            ControlSetEnabled(true, ctrl)
        StatusText.Value := "Ready"
    }

    MyGui.Show()
}


;==============================================================================
; Main Menu
;==============================================================================

MainGui := Gui("+Resize", "Examples Menu")
MainGui.Add("Text", "w400", "Select an example:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
    "Example 1: Workflow States",
    "Example 2: Permission System",
    "Example 3: Form Wizard",
    "Example 4: Conditional UI",
    "Example 5: Error Recovery",
    "Example 6: Access Control",
    "Example 7: Loading States",
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
