#Requires AutoHotkey v2.0
/**
#SingleInstance Force
 * @file BuiltIn_WinWait_01.ahk
 * @description Comprehensive examples demonstrating WinWait function for waiting on window appearance in AutoHotkey v2
 * @author AutoHotkey Foundation
 * @version 2.0
 * @date 2024-01-15
 * 
 * @section EXAMPLES
 * Example 1: Basic window waiting
 * Example 2: Window wait with timeout
 * Example 3: Multi-window waiter
 * Example 4: Startup sequence automation
 * Example 5: Application launcher with wait
 * Example 6: Window appearance monitor
 * Example 7: Conditional window waiting
 * 
 * @section FEATURES
 * - Wait for windows
 * - Timeout handling
 * - Multi-window waiting
 * - Startup automation
 * - Application launching
 * - Appearance monitoring
 * - Conditional waiting
 */

#Requires AutoHotkey v2.0

; ========================================
; Example 1: Basic Window Waiting
; ========================================

/**
 * @function WaitForWindow
 * @description Wait for a window to appear
 * @param WinTitle Window to wait for
 * @param timeout Timeout in seconds (0 = infinite)
 * @returns {Boolean} True if window appeared
 */
WaitForWindow(WinTitle, timeout := 0) {
    try {
        if timeout > 0 {
            if WinWait(WinTitle, , timeout) {
                return true
            }
            return false
        } else {
            WinWait(WinTitle)
            return true
        }
    } catch {
        return false
    }
}

/**
 * @function WaitAndActivate
 * @description Wait for window and activate it
 * @param WinTitle Window to wait for
 * @param timeout Timeout in seconds
 * @returns {Boolean} Success status
 */
WaitAndActivate(WinTitle, timeout := 10) {
    try {
        if WinWait(WinTitle, , timeout) {
            WinActivate(WinTitle)
            TrayTip("Window appeared and activated", WinTitle, "Icon!")
            return true
        } else {
            TrayTip("Timeout waiting for window", WinTitle, "Icon!")
            return false
        }
    } catch as err {
        MsgBox("Error: " err.Message, "Error", "IconX")
        return false
    }
}

; Hotkey: Ctrl+Shift+W - Wait for window
^+w:: {
    winTitle := InputBox("Enter window title to wait for:", "Wait for Window").Value
    if winTitle = ""
        return

    TrayTip("Waiting for: " winTitle, "Window Wait", "Icon!")

    if WaitAndActivate(winTitle, 30) {
        MsgBox("Window found and activated!", "Success", "Icon!")
    } else {
        MsgBox("Window did not appear within 30 seconds", "Timeout", "Icon!")
    }
}

; ========================================
; Example 2: Window Wait with Timeout
; ========================================

/**
 * @class TimeoutWaiter
 * @description Advanced window waiting with timeout handling
 */
class TimeoutWaiter {
    /**
     * @method WaitWithProgress
     * @description Wait for window with progress indicator
     * @param WinTitle Window to wait for
     * @param timeout Timeout in seconds
     * @returns {Boolean} Success status
     */
    static WaitWithProgress(WinTitle, timeout := 30) {
        progressGui := Gui("+AlwaysOnTop -SysMenu", "Waiting for Window")
        progressGui.Add("Text", "w300", "Waiting for: " WinTitle)
        progressGui.Add("Progress", "w300 h20 vProgress")
        progressGui.Add("Text", "w300 vTimeLeft", "Time remaining: " timeout "s")
        progressGui.Add("Button", "w100", "Cancel").OnEvent("Click", (*) => progressGui.Destroy())

        progressGui.Show()

        startTime := A_TickCount
        found := false

        Loop timeout * 10 {  ; Check 10 times per second
            if WinExist(WinTitle) {
                found := true
                break
            }

            elapsed := (A_TickCount - startTime) / 1000
            remaining := timeout - elapsed

            if remaining <= 0
                break

            try {
                progressGui["Progress"].Value := (elapsed / timeout) * 100
                progressGui["TimeLeft"].Value := "Time remaining: " Round(remaining, 1) "s"
            } catch {
                break  ; GUI was closed
            }

            Sleep(100)
        }

        try {
            progressGui.Destroy()
        }

        return found
    }

    /**
     * @method WaitMultipleConditions
     * @description Wait with multiple timeout stages
     * @param WinTitle Window to wait for
     * @param stages Array of {timeout, action} objects
     * @returns {Integer} Stage at which window appeared (0 if timeout)
     */
    static WaitMultipleConditions(WinTitle, stages) {
        for index, stage in stages {
            TrayTip("Stage " index ": Waiting " stage.Timeout "s", "Multi-Stage Wait", "Icon!")

            if WinWait(WinTitle, , stage.Timeout) {
                if stage.HasOwnProp("Action")
                    stage.Action()

                return index
            }

            ; Stage timeout - execute timeout action if exists
            if stage.HasOwnProp("OnTimeout")
                stage.OnTimeout()
        }

        return 0  ; All stages timed out
    }
}

; Hotkey: Ctrl+Shift+T - Wait with timeout and progress
^+t:: {
    winTitle := InputBox("Enter window title:", "Wait with Progress").Value
    if winTitle = ""
        return

    if TimeoutWaiter.WaitWithProgress(winTitle, 20) {
        MsgBox("Window found!", "Success", "Icon!")
        WinActivate(winTitle)
    } else {
        MsgBox("Window did not appear", "Timeout", "Icon!")
    }
}

; ========================================
; Example 3: Multi-Window Waiter
; ========================================

/**
 * @class MultiWindowWaiter
 * @description Wait for multiple windows
 */
class MultiWindowWaiter {
    /**
     * @method WaitForAny
     * @description Wait for any of multiple windows
     * @param windowTitles Array of window titles
     * @param timeout Timeout in seconds
     * @returns {String} Title of window that appeared (empty if timeout)
     */
    static WaitForAny(windowTitles, timeout := 30) {
        startTime := A_TickCount
        endTime := startTime + (timeout * 1000)

        Loop {
            for title in windowTitles {
                if WinExist(title) {
                    return title
                }
            }

            if A_TickCount >= endTime
                break

            Sleep(100)
        }

        return ""
    }

    /**
     * @method WaitForAll
     * @description Wait for all specified windows
     * @param windowTitles Array of window titles
     * @param timeout Timeout in seconds
     * @returns {Array} Array of appeared windows
     */
    static WaitForAll(windowTitles, timeout := 30) {
        appeared := []
        startTime := A_TickCount
        endTime := startTime + (timeout * 1000)

        remainingTitles := windowTitles.Clone()

        Loop {
            for index, title in remainingTitles {
                if WinExist(title) {
                    appeared.Push(title)
                    remainingTitles.RemoveAt(index)
                    break
                }
            }

            if remainingTitles.Length = 0
                break

            if A_TickCount >= endTime
                break

            Sleep(100)
        }

        return appeared
    }

    /**
     * @method WaitForSequence
     * @description Wait for windows to appear in sequence
     * @param sequence Array of window titles in order
     * @param perWindowTimeout Timeout per window
     * @returns {Boolean} True if entire sequence appeared
     */
    static WaitForSequence(sequence, perWindowTimeout := 10) {
        for title in sequence {
            TrayTip("Waiting for: " title, "Sequence Wait", "Icon!")

            if !WinWait(title, , perWindowTimeout) {
                TrayTip("Sequence broken at: " title, "Wait Failed", "Icon!")
                return false
            }

            Sleep(500)  ; Brief pause between windows
        }

        TrayTip("Complete sequence appeared!", "Success", "Icon!")
        return true
    }
}

; Hotkey: Ctrl+Shift+M - Wait for multiple windows
^+m:: {
    windows := ["Notepad", "Calculator", "Paint"]

    TrayTip("Waiting for any window...", "Multi-Wait", "Icon!")

    found := MultiWindowWaiter.WaitForAny(windows, 20)

    if found != "" {
        MsgBox("Found: " found, "Success", "Icon!")
        WinActivate(found)
    } else {
        MsgBox("No windows appeared", "Timeout", "Icon!")
    }
}

; ========================================
; Example 4: Startup Sequence Automation
; ========================================

/**
 * @class StartupAutomation
 * @description Automate application startup sequences
 */
class StartupAutomation {
    static sequences := Map()

    /**
     * @method DefineSequence
     * @description Define a startup sequence
     * @param name Sequence name
     * @param steps Array of startup steps
     */
    static DefineSequence(name, steps) {
        this.sequences[name] := steps
    }

    /**
     * @method ExecuteSequence
     * @description Execute a startup sequence
     * @param name Sequence name
     * @returns {Boolean} Success status
     */
    static ExecuteSequence(name) {
        if !this.sequences.Has(name) {
            MsgBox("Sequence not found: " name, "Error", "IconX")
            return false
        }

        steps := this.sequences[name]

        for index, step in steps {
            TrayTip("Step " index ": " step.Description, "Startup Sequence", "Icon!")

            ; Launch application if specified
            if step.HasOwnProp("Launch") {
                try {
                    Run(step.Launch)
                } catch as err {
                    MsgBox("Failed to launch: " err.Message, "Error", "IconX")
                    return false
                }
            }

            ; Wait for window
            if step.HasOwnProp("WaitFor") {
                timeout := step.HasOwnProp("Timeout") ? step.Timeout : 10

                if !WinWait(step.WaitFor, , timeout) {
                    MsgBox("Timeout waiting for: " step.WaitFor, "Error", "IconX")
                    return false
                }

                Sleep(step.HasOwnProp("Delay") ? step.Delay : 500)
            }

            ; Execute action if specified
            if step.HasOwnProp("Action") {
                step.Action()
            }

            ; Position window if specified
            if step.HasOwnProp("Position") {
                WinMove(step.Position.X, step.Position.Y,
                    step.Position.Width, step.Position.Height,
                    step.WaitFor)
            }
        }

        TrayTip("Startup sequence complete!", "Success", "Icon!")
        return true
    }

    /**
     * @method CreateExampleSequences
     * @description Create example startup sequences
     */
    static CreateExampleSequences() {
        ; Notepad startup
        this.DefineSequence("Notepad", [{
            Description: "Launch Notepad",
            Launch: "notepad.exe",
            WaitFor: "ahk_class Notepad",
            Timeout: 5,
            Position: { X: 100, Y: 100, Width: 800, Height: 600 }
        }
        ])

        ; Multi-app startup
        this.DefineSequence("Office", [{
            Description: "Launch Calculator",
            Launch: "calc.exe",
            WaitFor: "Calculator",
            Timeout: 5
        }, {
            Description: "Launch Notepad",
            Launch: "notepad.exe",
            WaitFor: "ahk_class Notepad",
            Timeout: 5,
            Delay: 1000
        }
        ])

        TrayTip("Example sequences created", "Startup Automation", "Icon!")
    }
}

; Initialize example sequences
StartupAutomation.CreateExampleSequences()

; Hotkey: Ctrl+Shift+S - Execute startup sequence
^+s:: {
    list := "Available sequences:`n`n"
    for name, _ in StartupAutomation.sequences {
        list .= "- " name "`n"
    }

    MsgBox(list, "Startup Sequences", "Icon!")

    name := InputBox("Enter sequence name:", "Execute Sequence").Value
    if name != ""
        StartupAutomation.ExecuteSequence(name)
}

; ========================================
; Example 5: Application Launcher with Wait
; ========================================

/**
 * @class SmartLauncher
 * @description Launch applications and wait for their windows
 */
class SmartLauncher {
    /**
     * @method LaunchAndWait
     * @description Launch app and wait for its window
     * @param exePath Executable path
     * @param winTitle Expected window title pattern
     * @param args Command line arguments
     * @param timeout Wait timeout
     * @returns {Boolean} Success status
     */
    static LaunchAndWait(exePath, winTitle, args := "", timeout := 10) {
        try {
            ; Launch application
            if args != ""
                Run(exePath " " args)
            else
                Run(exePath)

            ; Wait for window
            if WinWait(winTitle, , timeout) {
                WinActivate(winTitle)
                TrayTip("Application launched: " exePath, "Smart Launcher", "Icon!")
                return true
            } else {
                TrayTip("Window did not appear", "Timeout", "Icon!")
                return false
            }

        } catch as err {
            MsgBox("Launch failed: " err.Message, "Error", "IconX")
            return false
        }
    }

    /**
     * @method LaunchOrActivate
     * @description Launch if not running, or activate if already running
     * @param exePath Executable path
     * @param winTitle Window title pattern
     * @param timeout Wait timeout if launching
     * @returns {Boolean} Success status
     */
    static LaunchOrActivate(exePath, winTitle, timeout := 10) {
        ; Check if already running
        if WinExist(winTitle) {
            WinActivate(winTitle)
            TrayTip("Window activated", winTitle, "Icon!")
            return true
        }

        ; Launch and wait
        return this.LaunchAndWait(exePath, winTitle, "", timeout)
    }
}

; Hotkey: Ctrl+Shift+L - Smart launch
^+l:: {
    if SmartLauncher.LaunchOrActivate("notepad.exe", "ahk_class Notepad", 5) {
        MsgBox("Notepad is ready!", "Success", "Icon!")
    }
}

; ========================================
; Example 6: Window Appearance Monitor
; ========================================

/**
 * @class AppearanceMonitor
 * @description Monitor for window appearances
 */
class AppearanceMonitor {
    static monitors := Map()
    static monitoring := false

    /**
     * @method WatchFor
     * @description Watch for a window to appear
     * @param WinTitle Window to watch for
     * @param callback Function to call when appears
     * @param continuous Keep watching after appearance
     */
    static WatchFor(WinTitle, callback, continuous := false) {
        this.monitors[WinTitle] := {
            Title: WinTitle,
            Callback: callback,
            Continuous: continuous,
            LastCheck: 0
        }

        if !this.monitoring {
            this.monitoring := true
            this.StartMonitoring()
        }

        TrayTip("Now watching for: " WinTitle, "Appearance Monitor", "Icon!")
    }

    /**
     * @method StartMonitoring
     * @description Begin monitoring loop
     */
    static StartMonitoring() {
        SetTimer(() => this.CheckAllMonitors(), 500)
    }

    /**
     * @method CheckAllMonitors
     * @description Check all monitored windows
     */
    static CheckAllMonitors() {
        for winTitle, monitor in this.monitors {
            if WinExist(winTitle) {
                ; Window appeared
                monitor.Callback(winTitle)

                if !monitor.Continuous {
                    this.monitors.Delete(winTitle)
                }

                monitor.LastCheck := A_TickCount
            }
        }

        if this.monitors.Count = 0 {
            this.monitoring := false
            SetTimer(() => this.CheckAllMonitors(), 0)
        }
    }
}

; Example callback
OnWindowAppeared(winTitle) {
    TrayTip("Window appeared: " winTitle, "Monitor Alert", "Icon!")
    WinActivate(winTitle)
}

; Hotkey: Ctrl+Shift+A - Watch for window
^+a:: {
    winTitle := InputBox("Enter window title to watch for:", "Watch").Value
    if winTitle != ""
        AppearanceMonitor.WatchFor(winTitle, OnWindowAppeared, false)
}

; ========================================
; Example 7: Conditional Window Waiting
; ========================================

/**
 * @class ConditionalWaiter
 * @description Wait for windows with conditions
 */
class ConditionalWaiter {
    /**
     * @method WaitWithCondition
     * @description Wait for window matching additional conditions
     * @param WinTitle Window title
     * @param condition Function to test condition
     * @param timeout Timeout in seconds
     * @returns {Boolean} Success status
     */
    static WaitWithCondition(WinTitle, condition, timeout := 30) {
        startTime := A_TickCount
        endTime := startTime + (timeout * 1000)

        Loop {
            if WinExist(WinTitle) {
                if condition(WinTitle) {
                    return true
                }
            }

            if A_TickCount >= endTime
                break

            Sleep(100)
        }

        return false
    }

    /**
     * @method WaitForActiveState
     * @description Wait for window to become active
     * @param WinTitle Window title
     * @param timeout Timeout
     * @returns {Boolean} Success status
     */
    static WaitForActiveState(WinTitle, timeout := 10) {
        return this.WaitWithCondition(WinTitle,
            (title) => WinActive(title),
            timeout)
    }

    /**
     * @method WaitForVisibleState
     * @description Wait for window to become visible
     * @param WinTitle Window title
     * @param timeout Timeout
     * @returns {Boolean} Success status
     */
    static WaitForVisibleState(WinTitle, timeout := 10) {
        return this.WaitWithCondition(WinTitle,
            (title) => WinGetStyle(title) & 0x10000000,
            timeout)
    }
}

; ========================================
; Script Initialization
; ========================================

if A_Args.Length = 0 && !A_IsCompiled {
    help := "
    (
    WinWait Examples - Hotkeys:

    Ctrl+Shift+W  - Wait for window
    Ctrl+Shift+T  - Wait with timeout/progress
    Ctrl+Shift+M  - Wait for multiple windows
    Ctrl+Shift+S  - Execute startup sequence
    Ctrl+Shift+L  - Smart launch
    Ctrl+Shift+A  - Watch for window
    )"

    TrayTip(help, "WinWait Examples Ready", "Icon!")
}
