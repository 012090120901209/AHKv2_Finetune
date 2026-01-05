#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 Examples - Shutdown Function (Part 01: Shutdown basics)
 * ============================================================================
 * 
 * Shutdown initiates system shutdown, restart, or logoff operations.
 * 
 * @description Examples demonstrating shutdown basics
 * @author AHK v2 Documentation Team
 * @date 2024
 * @version 2.0.0
 * 
 * SYNTAX:
 *   Shutdown(Flag)
 * 
 * FLAGS:
 *   0 = Logoff
 *   1 = Shutdown
 *   2 = Reboot
 *   4 = Force
 *   8 = Power down
 *   Combine with + (e.g., 1+4 = Force shutdown)
 */

; ============================================================================
; Examples 1-7: System shutdown and restart operations
; ============================================================================

Example1() {
    MsgBox("Example 1: Understanding Shutdown Flags`n`n" .
        "Learn about different shutdown flags:",
        "Shutdown - Example 1", "Icon!")

    info := "Shutdown Flags:`n`n" .
        "0 = Logoff current user`n" .
        "1 = Shutdown system`n" .
        "2 = Reboot system`n" .
        "4 = Force (close apps without asking)`n" .
        "8 = Power down after shutdown`n`n" .
        "Combine with +:`n" .
        "1+4 = Force shutdown`n" .
        "2+4 = Force reboot`n" .
        "1+8 = Shutdown and power down"

    MsgBox(info, "Shutdown Flags", "Icon!")

    MsgBox("NOTE: Examples are SAFE and won't actually shut down!`n`n" .
        "They demonstrate the syntax and UI only.",
        "Safety Note", "Icon!")
}

Example2() {
    MsgBox("Example 2: Shutdown Confirmation Dialog`n`n" .
        "Create safe shutdown confirmation:", "Example 2", "Icon!")

    result := MsgBox("This is a DEMONSTRATION only.`n`n" .
        "In real use, this would shut down the system.`n`n" .
        "Shutdown syntax: Shutdown(1)",
        "Demo Shutdown", "OKCancel Icon!")

    if result = "OK" {
        MsgBox("In real script, system would shutdown now.`n`n" .
            "Actual code: Shutdown(1)",
            "Would Shutdown", "Icon!")
    } else {
        MsgBox("Shutdown cancelled by user.", "Cancelled", "Icon!")
    }
}

Example3() {
    MsgBox("Example 3: Shutdown Timer GUI`n`n" .
        "Create shutdown timer interface:", "Example 3", "Icon!")

    CreateShutdownTimer()
}

CreateShutdownTimer() {
    gui := Gui(, "Shutdown Timer (DEMO)")
    gui.SetFont("s10")

    gui.Add("Text", "w400", "Shutdown Timer Control Panel (DEMONSTRATION)")
    gui.Add("Text", "w400", "⚠ This is a DEMO - won't actually shut down")

    gui.Add("Text", "w400 0x10")

    gui.Add("Text", "w400", "Time until shutdown (minutes):")
    timeEdit := gui.Add("Edit", "w100", "5")
    gui.Add("UpDown", "Range1-120", 5)

    gui.Add("Text", "w400", "Action:")
    actionDD := gui.Add("DropDownList", "w400", ["Shutdown", "Restart", "Logoff"])
    actionDD.Choose(1)

    gui.Add("Checkbox", "w400", "Force close applications").Value := 0

    statusText := gui.Add("Text", "w400 h30", "Status: Ready")

    gui.Add("Button", "w190 h35", "Start Timer (DEMO)").OnEvent("Click", StartDemo)
    gui.Add("Button", "x+20 yp w190 h35", "Cancel").OnEvent("Click", (*) => (statusText.Text := "Status: Cancelled", ""))

    gui.Add("Button", "xm w400 h30", "Close").OnEvent("Click", (*) => gui.Destroy())

    StartDemo(*) {
        minutes := Integer(timeEdit.Value)
        action := actionDD.Text

        statusText.Text := "Status: DEMO - Would " . action . " in " . minutes . " min"

        MsgBox("DEMONSTRATION MODE`n`n" .
            "In real use, system would " . action . " in " . minutes . " minutes.`n`n" .
            "Actual code would be:`n" .
            "SetTimer(() => Shutdown(flag), " . (minutes * 60000) . ")",
            "Demo", "Icon!")
    }

    gui.Show()
    MsgBox("Shutdown timer GUI created (demonstration only)!", "Ready", "Icon!")
}

Example4() {
    MsgBox("Example 4: Quick Shutdown Menu`n`n" .
        "Create quick access shutdown menu:", "Example 4", "Icon!")

    result := MsgBox("Choose shutdown type:`n`n" .
        "Yes = Shutdown`n" .
        "No = Restart`n" .
        "Cancel = Logoff`n`n" .
        "(DEMO ONLY - won't actually execute)",
        "Quick Shutdown Menu", "YesNoCancel Icon?")

    switch result {
        case "Yes":
            MsgBox("Would execute: Shutdown(1) - Shutdown system", "Demo", "Icon!")
        case "No":
            MsgBox("Would execute: Shutdown(2) - Restart system", "Demo", "Icon!")
        case "Cancel":
            MsgBox("Would execute: Shutdown(0) - Logoff user", "Demo", "Icon!")
    }
}

Example5() {
    MsgBox("Example 5: Scheduled Shutdown`n`n" .
        "Schedule shutdown at specific time:", "Example 5", "Icon!")

    gui := Gui(, "Scheduled Shutdown (DEMO)")
    gui.SetFont("s10")

    gui.Add("Text", "w400", "Schedule System Shutdown (DEMONSTRATION)")

    gui.Add("Text", "w400", "Shutdown at time:")
    timeEdit := gui.Add("Edit", "w100", "23:00")

    gui.Add("Text", "w400", "Action type:")
    actionDD := gui.Add("DropDownList", "w400", ["Shutdown", "Restart"])
    actionDD.Choose(1)

    statusText := gui.Add("Edit", "w400 h100 +ReadOnly +Multi", "Enter time (HH:MM format) and click Schedule")

    gui.Add("Button", "w400 h35", "Schedule (DEMO)").OnEvent("Click", Schedule)
    gui.Add("Button", "w400 h30", "Close").OnEvent("Click", (*) => gui.Destroy())

    Schedule(*) {
        schedTime := timeEdit.Value
        action := actionDD.Text

        statusText.Value := "DEMONSTRATION MODE`n`n" .
            "Would schedule " . action . " at " . schedTime . "`n`n" .
            "Actual implementation would:`n" .
            "1. Calculate time until " . schedTime . "`n" .
            "2. SetTimer(() => Shutdown(flag), milliseconds)`n" .
            "3. Show countdown notifications"
    }

    gui.Show()
    MsgBox("Scheduled shutdown interface created!", "Ready", "Icon!")
}

Example6() {
    MsgBox("Example 6: Shutdown with Warnings`n`n" .
        "Implement multi-stage warnings before shutdown:", "Example 6", "Icon!")

    warnings := [{
        time: 5, msg: "5 minutes until shutdown" }, {
            time: 3, msg: "3 minutes until shutdown" }, {
                time: 1, msg: "1 minute until shutdown - SAVE YOUR WORK!" }, {
                    time: 0, msg: "Shutting down NOW"
                }
    ]

    demo := "DEMO: Shutdown Warning System`n`n"

    for warning in warnings {
        demo .= "At " . warning.time . " min: " . warning.msg . "`n"
    }

    demo .= "`nIn real implementation, each warning would use:`n" .
        "SetTimer(() => MsgBox('" . warnings[1].msg . "'), timeInMs)"

    MsgBox(demo, "Warning System Demo", "Icon!")
}

Example7() {
    MsgBox("Example 7: Advanced Shutdown Manager`n`n" .
        "Comprehensive shutdown management system:", "Example 7", "Icon!")

    CreateShutdownManager()
}

CreateShutdownManager() {
    gui := Gui(, "Advanced Shutdown Manager (DEMO)")
    gui.SetFont("s10")

    gui.Add("Text", "w500", "Advanced Shutdown Management System")
    gui.Add("Text", "w500", "⚠ DEMONSTRATION MODE - No actual shutdowns")

    gui.Add("Text", "w500 0x10")

    gui.Add("Text", "w500", "Quick Actions:")
    gui.Add("Button", "w160 h30", "Logoff (Demo)").OnEvent("Click", (*) => ShowDemo("Logoff", 0))
    gui.Add("Button", "x+10 yp w160 h30", "Shutdown (Demo)").OnEvent("Click", (*) => ShowDemo("Shutdown", 1))
    gui.Add("Button", "x+10 yp w160 h30", "Restart (Demo)").OnEvent("Click", (*) => ShowDemo("Restart", 2))

    gui.Add("Text", "xm w500 0x10")

    gui.Add("Text", "w500", "Scheduled Shutdown:")
    gui.Add("Text", "xm", "Minutes from now:")
    minEdit := gui.Add("Edit", "w100", "10")

    gui.Add("Button", "xm w500 h35", "Schedule Shutdown (DEMO)").OnEvent("Click", ScheduleDemo)

    logText := gui.Add("Edit", "w500 h150 +ReadOnly +Multi", "Action log (demonstration mode):`n")

    gui.Add("Button", "w500 h30", "Close").OnEvent("Click", (*) => gui.Destroy())

    ShowDemo(action, flag) {
        logText.Value .= FormatTime(A_Now, "HH:mm:ss") . " - DEMO " . action . " (flag: " . flag . ")`n"
        MsgBox("DEMO: Would execute Shutdown(" . flag . ") - " . action, "Demo", "Icon! T2")
    }

    ScheduleDemo(*) {
        minutes := Integer(minEdit.Value)
        logText.Value .= FormatTime(A_Now, "HH:mm:ss") . " - DEMO scheduled shutdown in " . minutes . " min`n"
        MsgBox("DEMO: Would schedule shutdown in " . minutes . " minutes`n`n" .
            "Code: SetTimer(() => Shutdown(1), " . (minutes * 60000) . ")",
            "Scheduled", "Icon!")
    }

    gui.Show()
    MsgBox("Advanced shutdown manager created (demo mode)!", "Ready", "Icon!")
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMainMenu() {
    menu := Gui(, "Shutdown Examples (Part 01) - Main Menu")
    menu.SetFont("s10")

    menu.Add("Text", "w500", "AutoHotkey v2 - Shutdown (Shutdown basics)")
    menu.Add("Text", "w500", "⚠ ALL EXAMPLES ARE SAFE DEMONSTRATIONS")
    menu.SetFont("s9")

    menu.Add("Button", "w500 h35", "Example 1: Understanding Shutdown Flags").OnEvent("Click", (*) => (menu.Hide(), Example1(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 2: Shutdown Confirmation Dialog").OnEvent("Click", (*) => (menu.Hide(), Example2(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 3: Shutdown Timer GUI").OnEvent("Click", (*) => (menu.Hide(), Example3(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 4: Quick Shutdown Menu").OnEvent("Click", (*) => (menu.Hide(), Example4(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 5: Scheduled Shutdown").OnEvent("Click", (*) => (menu.Hide(), Example5(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 6: Shutdown with Warnings").OnEvent("Click", (*) => (menu.Hide(), Example6(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 7: Advanced Shutdown Manager").OnEvent("Click", (*) => (menu.Hide(), Example7(), menu.Show()))

    menu.Add("Text", "w500 0x10")
    menu.Add("Button", "w500 h30", "Exit").OnEvent("Click", (*) => ExitApp())

    menu.Show()
}

ShowMainMenu()
