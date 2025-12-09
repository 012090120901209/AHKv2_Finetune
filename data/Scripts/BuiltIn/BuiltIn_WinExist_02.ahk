#Requires AutoHotkey v2.0

/**
* ============================================================================
* WinExist Examples - Part 2: Wait for Window
* ============================================================================
*
* This script demonstrates advanced WinExist usage with WinWait and WinWaitActive
* for synchronizing script execution with window appearance and state changes.
*
* @description Advanced window waiting and synchronization techniques
* @author AutoHotkey Community
* @version 2.0.0
* @requires AutoHotkey v2.0+
*/

; ============================================================================
; Example 1: Basic Window Waiting
; ============================================================================

/**
* Waits for a window to appear before proceeding
* Essential for launch-and-configure workflows
*
* @hotkey F1 - Launch and wait for Notepad
*/
F1:: {
    try {
        MsgBox("Launching Notepad and waiting for it to appear...", "Info", 64)

        ; Launch Notepad
        Run("notepad.exe")

        ; Wait for it to appear (timeout: 5 seconds)
        if WinWait("ahk_class Notepad", , 5) {
            WinActivate()
            Sleep(100)
            Send("This text was automatically inserted after Notepad appeared!")
            MsgBox("Notepad launched and text inserted successfully!", "Success", 64)
        } else {
            MsgBox("Notepad did not appear within 5 seconds.", "Timeout", 48)
        }
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 2: Wait for Window with Progress Display
; ============================================================================

/**
* Waits for a window while showing visual progress
* Improves user experience for longer waits
*
* @hotkey F2 - Wait with progress bar
*/
F2:: {
    WaitWithProgress()
}

/**
* Waits for a window with a progress indicator
*/
WaitWithProgress() {
    static progressGui := ""

    ; Create progress GUI
    if progressGui {
        try progressGui.Destroy()
    }

    progressGui := Gui("+AlwaysOnTop +ToolWindow", "Waiting for Window")
    progressGui.SetFont("s10", "Segoe UI")

    progressGui.Add("Text", "w350", "Enter window title to wait for:")
    titleEdit := progressGui.Add("Edit", "w350 vWindowTitle", "Calculator")

    progressGui.Add("Text", "w350", "Timeout (seconds):")
    timeoutEdit := progressGui.Add("Edit", "w350 vTimeout Number", "30")

    progressGui.Add("CheckBox", "vAutoLaunch", "Auto-launch if possible")

    progressGui.Add("Button", "w170 Default", "Start Waiting").OnEvent("Click", StartWait)
    progressGui.Add("Button", "w170 x+10 yp", "Cancel").OnEvent("Click", (*) => progressGui.Destroy())

    progressGui.Show()

    StartWait(*) {
        windowTitle := titleEdit.Value
        timeoutSec := Integer(timeoutEdit.Value)
        autoLaunch := progressGui.Submit(false).AutoLaunch

        if windowTitle = "" {
            MsgBox("Please enter a window title.", "Error", 16)
            return
        }

        progressGui.Destroy()

        ; Create waiting GUI
        waitGui := Gui("+AlwaysOnTop +ToolWindow -SysMenu", "Waiting...")
        waitGui.Add("Text", "w400", "Waiting for window: " windowTitle)
        progressBar := waitGui.Add("Progress", "w400 h30 vProgress")
        statusText := waitGui.Add("Text", "w400 vStatus", "Elapsed: 0s / " timeoutSec "s")
        waitGui.Add("Button", "w400", "Cancel").OnEvent("Click", (*) => waitGui.Destroy())
        waitGui.Show()

        ; Auto-launch common applications
        if autoLaunch {
            launchMap := Map(
            "Calculator", "calc.exe",
            "Notepad", "notepad.exe",
            "Paint", "mspaint.exe"
            )

            for appName, exe in launchMap {
                if InStr(windowTitle, appName) {
                    Run(exe)
                    break
                }
            }
        }

        ; Wait with progress updates
        startTime := A_TickCount
        found := false

        while ((A_TickCount - startTime) < (timeoutSec * 1000)) {
            if WinExist(windowTitle) {
                found := true
                break
            }

            elapsed := (A_TickCount - startTime) / 1000
            progress := (elapsed / timeoutSec) * 100
            progressBar.Value := progress
            statusText.Value := "Elapsed: " Round(elapsed, 1) "s / " timeoutSec "s"

            Sleep(100)
        }

        waitGui.Destroy()

        if found {
            WinActivate(windowTitle)
            MsgBox("Window found and activated!`nTitle: " windowTitle, "Success", 64)
        } else {
            MsgBox("Window not found within " timeoutSec " seconds.`nTitle: " windowTitle, "Timeout", 48)
        }
    }
}

; ============================================================================
; Example 3: Wait for Window to Become Active
; ============================================================================

/**
* Waits specifically for a window to become active
* Different from just existing - it must have focus
*
* @hotkey F3 - Wait for active window
*/
F3:: {
    WaitForActiveWindow()
}

/**
* Demonstrates WinWaitActive functionality
*/
WaitForActiveWindow() {
    try {
        ; Launch Notepad
        Run("notepad.exe", , , &pid)

        MsgBox("Notepad launched. Click OK and then click on the Notepad window within 10 seconds.", "Instruction", 64)

        ; Wait for Notepad to become active
        if WinWaitActive("ahk_pid " pid, , 10) {
            Send("Success! This window became active.`n")
            Send("Current time: " A_Hour ":" A_Min ":" A_Sec)
            MsgBox("Notepad became active and text was sent!", "Success", 64)
        } else {
            MsgBox("Notepad did not become active within 10 seconds.", "Timeout", 48)
        }
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 4: Wait for Multiple Windows (First to Appear)
; ============================================================================

/**
* Waits for any of multiple windows to appear
* Useful when waiting for one of several possible outcomes
*
* @hotkey F4 - Wait for multiple windows
*/
F4:: {
    WaitForMultipleWindows()
}

/**
* Waits for first of multiple windows to appear
*/
WaitForMultipleWindows() {
    MsgBox("This will wait for either Notepad, Calculator, or Paint to appear.`nYou have 15 seconds to open one of them.", "Waiting for Multiple Windows", 64)

    windowList := [
    {
        name: "Notepad", criteria: "ahk_class Notepad"},
        {
            name: "Calculator", criteria: "Calculator ahk_exe ApplicationFrameHost.exe"},
            {
                name: "Paint", criteria: "ahk_class MSPaintApp"
            }
            ]

            startTime := A_TickCount
            timeout := 15000  ; 15 seconds
            foundWindow := ""

            while ((A_TickCount - startTime) < timeout) {
                for win in windowList {
                    if WinExist(win.criteria) {
                        foundWindow := win.name
                        break 2  ; Break out of both loops
                    }
                }

                ToolTip("Waiting... " Round((timeout - (A_TickCount - startTime)) / 1000, 1) "s remaining")
                Sleep(100)
            }

            ToolTip()

            if foundWindow != "" {
                WinActivate()
                MsgBox("Found window: " foundWindow, "Success", 64)
            } else {
                MsgBox("No window appeared within 15 seconds.", "Timeout", 48)
            }
        }

        ; ============================================================================
        ; Example 5: Wait for Window Close
        ; ============================================================================

        /**
        * Waits for a window to close (disappear)
        * Useful for sequential operations
        *
        * @hotkey F5 - Wait for window close
        */
        F5:: {
            WaitForWindowClose()
        }

        /**
        * Demonstrates waiting for a window to close
        */
        WaitForWindowClose() {
            if !WinExist("ahk_class Notepad") {
                result := MsgBox("No Notepad window found. Launch one?", "Launch?", 4)
                if result = "Yes" {
                    Run("notepad.exe")
                    WinWait("ahk_class Notepad", , 5)
                } else {
                    return
                }
            }

            hwnd := WinExist("ahk_class Notepad")
            title := WinGetTitle(hwnd)

            MsgBox("Close the Notepad window within 30 seconds.`nWindow: " title, "Instruction", 64)

            ; Wait for window to close
            startTime := A_TickCount
            timeout := 30000  ; 30 seconds
            closed := false

            while ((A_TickCount - startTime) < timeout) {
                if !WinExist(hwnd) {
                    closed := true
                    break
                }

                remaining := Round((timeout - (A_TickCount - startTime)) / 1000, 1)
                ToolTip("Waiting for window to close... " remaining "s remaining")
                Sleep(100)
            }

            ToolTip()

            if closed {
                MsgBox("Window was closed successfully!", "Success", 64)
            } else {
                MsgBox("Window was not closed within 30 seconds.", "Timeout", 48)
            }
        }

        ; ============================================================================
        ; Example 6: Advanced Window State Monitor
        ; ============================================================================

        /**
        * Monitors window state changes with callbacks
        * Demonstrates event-driven window monitoring
        *
        * @hotkey F6 - Start state monitor
        */
        F6:: {
            static monitoring := false

            if !monitoring {
                monitoring := true
                StartStateMonitor()
            } else {
                monitoring := false
                MsgBox("Monitoring will stop.", "Monitor", 64)
            }
        }

        /**
        * Monitors window appearance, activation, and closing
        */
        StartStateMonitor() {
            static monitorGui := ""
            static logEdit := ""
            static monitorTimer := 0
            static lastStates := Map()

            if monitorGui {
                try monitorGui.Destroy()
            }

            monitorGui := Gui("+AlwaysOnTop +Resize", "Window State Monitor")
            monitorGui.SetFont("s9", "Consolas")

            monitorGui.Add("Text", "w600", "Monitoring window states (real-time updates):")
            logEdit := monitorGui.Add("Edit", "w600 h400 ReadOnly vLog +HScroll")

            monitorGui.Add("Button", "w290 Default", "Stop Monitor").OnEvent("Click", StopMonitor)
            monitorGui.Add("Button", "w290 x+20 yp", "Clear Log").OnEvent("Click", ClearLog)

            monitorGui.Show()

            ; Initialize monitoring
            watchList := [
            {
                name: "Notepad", criteria: "ahk_class Notepad"},
                {
                    name: "Calculator", criteria: "Calculator ahk_exe ApplicationFrameHost.exe"},
                    {
                        name: "Chrome", criteria: "ahk_exe chrome.exe"
                    }
                    ]

                    for win in watchList {
                        lastStates[win.name] := {
                            exists: WinExist(win.criteria) ? true : false,
                            active: WinActive(win.criteria) ? true : false
                        }
                    }

                    LogEvent("Monitor started at " A_Hour ":" A_Min ":" A_Sec)

                    ; Start monitoring timer
                    monitorTimer := SetTimer(CheckStates, 500)

                    CheckStates() {
                        for win in watchList {
                            nowExists := WinExist(win.criteria) ? true : false
                            nowActive := WinActive(win.criteria) ? true : false

                            lastState := lastStates[win.name]

                            ; Check for existence changes
                            if nowExists != lastState.exists {
                                event := nowExists ? "APPEARED" : "CLOSED"
                                LogEvent("[" win.name "] " event)
                            }

                            ; Check for activation changes
                            if nowExists && (nowActive != lastState.active) {
                                event := nowActive ? "ACTIVATED" : "DEACTIVATED"
                                LogEvent("[" win.name "] " event)
                            }

                            ; Update state
                            lastStates[win.name].exists := nowExists
                            lastStates[win.name].active := nowActive
                        }
                    }

                    LogEvent(message) {
                        timestamp := A_Hour ":" A_Min ":" A_Sec "." A_MSec
                        logEdit.Value := "[" timestamp "] " message "`n" logEdit.Value
                    }

                    StopMonitor(*) {
                        if monitorTimer {
                            SetTimer(monitorTimer, 0)
                        }
                        LogEvent("Monitor stopped")
                        monitorGui.Destroy()
                    }

                    ClearLog(*) {
                        logEdit.Value := ""
                        LogEvent("Log cleared at " A_Hour ":" A_Min ":" A_Sec)
                    }
                }

                ; ============================================================================
                ; Example 7: Application Launch Sequence Manager
                ; ============================================================================

                /**
                * Launches multiple applications in sequence, waiting for each
                * Demonstrates practical use of window waiting
                *
                * @hotkey F7 - Launch sequence
                */
                F7:: {
                    LaunchSequence()
                }

                /**
                * Launches applications in a defined sequence
                */
                LaunchSequence() {
                    static seqGui := ""

                    if seqGui {
                        try seqGui.Destroy()
                    }

                    seqGui := Gui("+AlwaysOnTop", "Application Launch Sequence")
                    seqGui.SetFont("s10", "Segoe UI")

                    seqGui.Add("Text", "w500", "Configure launch sequence:")

                    ; Define available applications
                    apps := [
                    {
                        name: "Notepad", exe: "notepad.exe", wait: "ahk_class Notepad"},
                        {
                            name: "Calculator", exe: "calc.exe", wait: "Calculator"},
                            {
                                name: "Paint", exe: "mspaint.exe", wait: "ahk_class MSPaintApp"
                            }
                            ]

                            checks := []
                            for app in apps {
                                cb := seqGui.Add("CheckBox", "w500 Checked", app.name)
                                checks.Push(cb)
                            }

                            seqGui.Add("Text", "w500", "Wait time between launches (seconds):")
                            delayEdit := seqGui.Add("Edit", "w500 vDelay Number", "2")

                            seqGui.Add("Button", "w240 Default", "Start Sequence").OnEvent("Click", StartSequence)
                            seqGui.Add("Button", "w240 x+20 yp", "Cancel").OnEvent("Click", (*) => seqGui.Destroy())

                            seqGui.Show()

                            StartSequence(*) {
                                submitted := seqGui.Submit(false)
                                delay := Integer(submitted.Delay)

                                ; Get selected apps
                                selectedApps := []
                                for index, cb in checks {
                                    if cb.Value {
                                        selectedApps.Push(apps[index])
                                    }
                                }

                                if selectedApps.Length = 0 {
                                    MsgBox("Please select at least one application.", "Error", 16)
                                    return
                                }

                                seqGui.Destroy()

                                ; Execute launch sequence
                                progressGui := Gui("+AlwaysOnTop +ToolWindow", "Launching...")
                                statusText := progressGui.Add("Text", "w400", "Preparing to launch...")
                                progressGui.Show()

                                for app in selectedApps {
                                    statusText.Value := "Launching " app.name "..."

                                    Run(app.exe)

                                    statusText.Value := "Waiting for " app.name " to appear..."

                                    if WinWait(app.wait, , 10) {
                                        statusText.Value := app.name " launched successfully!"
                                        Sleep(delay * 1000)
                                    } else {
                                        MsgBox(app.name " failed to appear within 10 seconds.`nContinuing with sequence...", "Warning", 48)
                                    }
                                }

                                progressGui.Destroy()
                                MsgBox("Launch sequence completed!`nLaunched " selectedApps.Length " application(s).", "Complete", 64)
                            }
                        }

                        ; ============================================================================
                        ; Cleanup and Help
                        ; ============================================================================

                        Esc::ExitApp()

                        ^F1:: {
                            help := "
                            (
                            WinExist Examples - Part 2 (Wait for Window)
                            ============================================

                            Hotkeys:
                            F1 - Launch and wait for Notepad
                            F2 - Wait with progress bar
                            F3 - Wait for window to become active
                            F4 - Wait for multiple windows
                            F5 - Wait for window to close
                            F6 - Start/stop state monitor
                            F7 - Launch application sequence
                            Esc - Exit script

                            Ctrl+F1 - Show this help
                            )"

                            MsgBox(help, "Help", 64)
                        }
