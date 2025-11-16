#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Suspend - Hotkey Suspension Management
 * ============================================================================
 *
 * Demonstrates the Suspend function for temporarily disabling hotkeys
 * and hotstrings. Useful for gaming, presentations, or preventing
 * interference during specific tasks.
 *
 * Features:
 * - Basic suspend/resume
 * - Selective suspension with HotIf
 * - Timed suspension
 * - Application-specific suspension
 * - Suspension indicators
 * - Permit mode
 *
 * @author AutoHotkey v2 Documentation Team
 * @version 1.0.0
 * @see https://www.autohotkey.com/docs/v2/lib/Suspend.htm
 */

; ============================================================================
; Example 1: Basic Suspend Operations
; ============================================================================

Example1_BasicSuspend() {
    ; Create test hotkeys
    Hotkey("F5", (*) => SendText("F5 is active!"))
    Hotkey("F6", (*) => SendText("F6 is active!"))
    Hotkey("F7", (*) => SendText("F7 is active!"))

    ; Suspend controller (not affected by suspend)
    Hotkey("!s", (*) {
        Suspend(-1) ; Toggle suspend
        state := A_IsSuspended ? "SUSPENDED" : "ACTIVE"
        ToolTip("Hotkeys " . state, A_ScreenWidth - 150, 10)
        SetTimer(() => ToolTip(), -2000)
    })

    ; Explicit suspend
    Hotkey("!+s", (*) {
        Suspend(1) ; Force suspend
        ToolTip("Hotkeys SUSPENDED", A_ScreenWidth - 150, 10)
        SetTimer(() => ToolTip(), -2000)
    })

    ; Explicit resume
    Hotkey("!^s", (*) {
        Suspend(0) ; Force resume
        ToolTip("Hotkeys ACTIVE", A_ScreenWidth - 150, 10)
        SetTimer(() => ToolTip(), -2000)
    })

    MsgBox(
        "Basic Suspend Operations`n`n"
        "Test hotkeys: F5, F6, F7`n`n"
        "Alt+S → Toggle suspend`n"
        "Alt+Shift+S → Force suspend`n"
        "Alt+Ctrl+S → Force resume`n`n"
        "Try suspending and pressing F5-F7!",
        "Example 1"
    )
}

; ============================================================================
; Example 2: Permit Mode - Hotkeys That Work While Suspended
; ============================================================================

Example2_PermitMode() {
    ; Regular hotkeys (will be suspended)
    Hotkey("F1", (*) => MsgBox("F1 - Regular hotkey", "Regular"))
    Hotkey("F2", (*) => MsgBox("F2 - Regular hotkey", "Regular"))

    ; Permit hotkeys (work even when suspended)
    Hotkey("F3", (*) => MsgBox("F3 - Permit hotkey (always works)", "Permit"), "P")
    Hotkey("F4", (*) => MsgBox("F4 - Permit hotkey (always works)", "Permit"), "P")

    ; Suspend toggler (permit)
    Hotkey("^!p", (*) {
        Suspend(-1)
        state := A_IsSuspended ? "SUSPENDED (F3/F4 still work)" : "ACTIVE"
        MsgBox("State: " . state . "`n`nPermit hotkeys (F3, F4) always work", "Suspend")
    }, "P")

    MsgBox(
        "Permit Mode Example`n`n"
        "Regular hotkeys (suspended): F1, F2`n"
        "Permit hotkeys (always work): F3, F4`n`n"
        "Ctrl+Alt+P → Toggle suspend`n`n"
        "Permit hotkeys work even when suspended!",
        "Example 2"
    )
}

; ============================================================================
; Example 3: Timed Suspension
; ============================================================================

Example3_TimedSuspension() {
    global suspendTimer := 0

    /**
     * Suspends hotkeys for specified duration
     */
    SuspendFor(seconds) {
        global suspendTimer

        Suspend(1)

        ; Show countdown
        remaining := seconds
        UpdateCountdown() {
            remaining--
            if remaining > 0 {
                ToolTip("Suspended: " . remaining . "s remaining", A_ScreenWidth - 180, 10)
            } else {
                ToolTip()
                Suspend(0)
                MsgBox("Hotkeys resumed!", "Resume")
            }
        }

        ; Start countdown
        ToolTip("Suspended: " . seconds . "s remaining", A_ScreenWidth - 180, 10)
        SetTimer(UpdateCountdown, 1000)

        ; Stop countdown after duration
        SetTimer(UpdateCountdown, -seconds * 1000)
    }

    ; Test hotkeys
    Hotkey("F8", (*) => SendText("F8 works!"))
    Hotkey("F9", (*) => SendText("F9 works!"))

    ; Timed suspension hotkeys (permit)
    Hotkey("^!t3", (*) => SuspendFor(3), "P")
    Hotkey("^!t5", (*) => SuspendFor(5), "P")
    Hotkey("^!t10", (*) => SuspendFor(10), "P")

    MsgBox(
        "Timed Suspension`n`n"
        "Test hotkeys: F8, F9`n`n"
        "Ctrl+Alt+T3 → Suspend for 3 seconds`n"
        "Ctrl+Alt+T5 → Suspend for 5 seconds`n"
        "Ctrl+Alt+T10 → Suspend for 10 seconds`n`n"
        "Hotkeys auto-resume after timeout!",
        "Example 3"
    )
}

; ============================================================================
; Example 4: Application-Specific Suspension
; ============================================================================

Example4_ApplicationSuspension() {
    global gameProcesses := ["notepad.exe", "mspaint.exe"] ; Demo with Notepad/Paint

    /**
     * Checks if a game is active
     */
    IsGameActive() {
        global gameProcesses
        for process in gameProcesses {
            if WinActive("ahk_exe " . process)
                return true
        }
        return false
    }

    /**
     * Auto-suspend when games are active
     */
    UpdateGameSuspension() {
        static wasGameActive := false

        isGameActive := IsGameActive()

        ; State changed
        if isGameActive && !wasGameActive {
            Suspend(1)
            ToolTip("Hotkeys suspended (Game active)", A_ScreenWidth - 200, 10)
            SetTimer(() => ToolTip(), -2000)
        }
        else if !isGameActive && wasGameActive {
            Suspend(0)
            ToolTip("Hotkeys resumed (Game closed)", A_ScreenWidth - 200, 10)
            SetTimer(() => ToolTip(), -2000)
        }

        wasGameActive := isGameActive
    }

    ; Test hotkeys
    Hotkey("^Space", (*) => SendText("Ctrl+Space works outside games"))

    ; Auto-suspension checker
    SetTimer(UpdateGameSuspension, 500)

    ; Manual override (permit)
    Hotkey("^!o", (*) {
        Suspend(0)
        MsgBox("Manual override - hotkeys forced ON", "Override")
    }, "P")

    MsgBox(
        "Application-Specific Suspension`n`n"
        "Hotkeys auto-suspend when these apps are active:`n"
        "  • Notepad`n"
        "  • Paint`n`n"
        "Test hotkey: Ctrl+Space`n"
        "Override: Ctrl+Alt+O`n`n"
        "Try opening Notepad and pressing Ctrl+Space!",
        "Example 4"
    )
}

; ============================================================================
; Example 5: Selective Suspension with HotIf
; ============================================================================

Example5_SelectiveSuspension() {
    global groupEnabled := true

    ; Group A hotkeys - can be suspended
    HotIf(() => groupEnabled)
    Hotkey("^1", (*) => SendText("Group A - Key 1"))
    Hotkey("^2", (*) => SendText("Group A - Key 2"))

    ; Group B hotkeys - always active
    HotIf(() => true)
    Hotkey("^3", (*) => SendText("Group B - Key 3 (always works)"))
    Hotkey("^4", (*) => SendText("Group B - Key 4 (always works)"))

    ; Reset context
    HotIf()

    ; Toggle Group A
    Hotkey("^!g", (*) {
        global groupEnabled
        groupEnabled := !groupEnabled
        status := groupEnabled ? "ENABLED" : "DISABLED"
        MsgBox(
            "Group A hotkeys " . status . "`n`n"
            "Group A: Ctrl+1, Ctrl+2`n"
            "Group B (always on): Ctrl+3, Ctrl+4",
            "Toggle"
        )
    })

    MsgBox(
        "Selective Suspension`n`n"
        "Group A (toggleable): Ctrl+1, Ctrl+2`n"
        "Group B (always on): Ctrl+3, Ctrl+4`n`n"
        "Ctrl+Alt+G → Toggle Group A`n`n"
        "Use HotIf for selective control!",
        "Example 5"
    )
}

; ============================================================================
; Example 6: Suspension Status Indicators
; ============================================================================

Example6_StatusIndicators() {
    global statusGui := ""

    /**
     * Creates a status indicator GUI
     */
    CreateStatusIndicator() {
        global statusGui

        statusGui := Gui("+AlwaysOnTop -Caption +ToolWindow", "Hotkey Status")
        statusGui.BackColor := "White"

        statusText := statusGui.AddText("w200 h30 Center 0x200", "")
        statusText.SetFont("s12 Bold")

        UpdateStatusDisplay()

        statusGui.Show("x" . (A_ScreenWidth - 220) . " y10 w200 h30")

        return statusGui
    }

    /**
     * Updates the status display
     */
    UpdateStatusDisplay() {
        global statusGui

        if !IsObject(statusGui)
            return

        status := A_IsSuspended ? "SUSPENDED" : "ACTIVE"
        color := A_IsSuspended ? "Red" : "Green"

        for ctrl in statusGui {
            ctrl.Value := "Hotkeys: " . status
            ctrl.SetFont("c" . color)
        }

        statusGui.BackColor := A_IsSuspended ? "0xFFEEEE" : "0xEEFFEE"
    }

    ; Create status GUI
    CreateStatusIndicator()

    ; Test hotkeys
    Hotkey("^F1", (*) => MsgBox("Ctrl+F1 active", "Test"))
    Hotkey("^F2", (*) => MsgBox("Ctrl+F2 active", "Test"))

    ; Suspend toggle with status update
    Hotkey("^!z", (*) {
        Suspend(-1)
        UpdateStatusDisplay()
    })

    ; Update on timer
    SetTimer(UpdateStatusDisplay, 500)

    MsgBox(
        "Status Indicators`n`n"
        "Watch the status indicator in top-right corner`n`n"
        "Test hotkeys: Ctrl+F1, Ctrl+F2`n"
        "Toggle: Ctrl+Alt+Z`n`n"
        "Status changes color:  `n"
        "  Green = Active`n"
        "  Red = Suspended",
        "Example 6"
    )
}

; ============================================================================
; Example 7: Advanced Suspension Manager
; ============================================================================

Example7_SuspensionManager() {
    global suspensionProfiles := Map()
    global currentProfile := "default"

    /**
     * Creates a suspension profile
     */
    CreateProfile(name, suspendedHotkeys, activeHotkeys) {
        global suspensionProfiles
        suspensionProfiles[name] := {
            suspended: suspendedHotkeys,
            active: activeHotkeys
        }
    }

    /**
     * Activates a profile
     */
    ActivateProfile(name) {
        global suspensionProfiles, currentProfile

        if !suspensionProfiles.Has(name) {
            MsgBox("Profile not found: " . name, "Error")
            return
        }

        profile := suspensionProfiles[name]

        ; Suspend specified hotkeys
        for hotkey in profile.suspended {
            try Hotkey(hotkey, "Off")
        }

        ; Activate specified hotkeys
        for hotkey in profile.active {
            try Hotkey(hotkey, "On")
        }

        currentProfile := name

        MsgBox("Activated profile: " . name, "Profile")
    }

    /**
     * Shows available profiles
     */
    ShowProfiles() {
        global suspensionProfiles, currentProfile

        list := "Suspension Profiles:`n" . Repeat("=", 40) . "`n`n"

        for name in suspensionProfiles {
            marker := (name = currentProfile) ? "► " : "  "
            list .= marker . name . "`n"
        }

        MsgBox(list, "Profiles")
    }

    Repeat(char, count) {
        result := ""
        Loop count
            result .= char
        return result
    }

    ; Create test hotkeys
    Hotkey("^!1", (*) => MsgBox("Hotkey 1", "Test"))
    Hotkey("^!2", (*) => MsgBox("Hotkey 2", "Test"))
    Hotkey("^!3", (*) => MsgBox("Hotkey 3", "Test"))
    Hotkey("^!4", (*) => MsgBox("Hotkey 4", "Test"))

    ; Create profiles
    CreateProfile("default", [], ["^!1", "^!2", "^!3", "^!4"])
    CreateProfile("gaming", ["^!1", "^!2"], ["^!3", "^!4"])
    CreateProfile("work", ["^!3", "^!4"], ["^!1", "^!2"])

    ; Profile switchers (permit)
    Hotkey("F5", (*) => ActivateProfile("default"), "P")
    Hotkey("F6", (*) => ActivateProfile("gaming"), "P")
    Hotkey("F7", (*) => ActivateProfile("work"), "P")
    Hotkey("F8", (*) => ShowProfiles(), "P")

    MsgBox(
        "Advanced Suspension Manager`n`n"
        "Profiles:`n"
        "  F5 - Default (all active)`n"
        "  F6 - Gaming (1,2 off; 3,4 on)`n"
        "  F7 - Work (3,4 off; 1,2 on)`n"
        "  F8 - Show profiles`n`n"
        "Test: Ctrl+Alt+1,2,3,4`n`n"
        "Switch profiles and test!",
        "Example 7"
    )
}

; ============================================================================
; Main Execution
; ============================================================================

ShowExampleMenu() {
    menu := "
    (
    Suspend Function Examples
    ==========================

    1. Basic Suspend/Resume
    2. Permit Mode
    3. Timed Suspension
    4. App-Specific Suspension
    5. Selective Suspension
    6. Status Indicators
    7. Suspension Manager

    Press Ctrl+Shift+[1-7]
    )"

    MsgBox(menu, "Suspend Examples")
}

Hotkey("^+1", (*) => Example1_BasicSuspend())
Hotkey("^+2", (*) => Example2_PermitMode())
Hotkey("^+3", (*) => Example3_TimedSuspension())
Hotkey("^+4", (*) => Example4_ApplicationSuspension())
Hotkey("^+5", (*) => Example5_SelectiveSuspension())
Hotkey("^+6", (*) => Example6_StatusIndicators())
Hotkey("^+7", (*) => Example7_SuspensionManager())

ShowExampleMenu()
