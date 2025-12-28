#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * WinExist Examples - Part 3: Conditional Logic
 * ============================================================================
 * 
 * This script demonstrates advanced conditional logic using WinExist.
 * Shows practical patterns for window-based decision making and automation.
 * 
 * @description Advanced conditional operations based on window existence
 * @author AutoHotkey Community
 * @version 2.0.0
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Toggle Window Visibility
; ============================================================================

/**
 * Toggles between showing and activating a window
 * If exists, activate; if active, minimize; if minimized, restore
 * 
 * @hotkey F1 - Toggle Notepad
 */
F1:: {
    ToggleNotepad()
}

/**
 * Smart toggle for Notepad window
 */
ToggleNotepad() {
    try {
        if WinExist("ahk_class Notepad") {
            ; Window exists - check if it's active
            if WinActive("ahk_class Notepad") {
                ; Active - minimize it
                WinMinimize()
                ToolTip("Notepad minimized")
                SetTimer(() => ToolTip(), -1500)
            } else {
                ; Exists but not active - check if minimized
                state := WinGetMinMax()
                if (state = -1) {
                    ; Minimized - restore and activate
                    WinRestore()
                    WinActivate()
                    ToolTip("Notepad restored")
                } else {
                    ; Just activate
                    WinActivate()
                    ToolTip("Notepad activated")
                }
                SetTimer(() => ToolTip(), -1500)
            }
        } else {
            ; Doesn't exist - launch it
            Run("notepad.exe")
            WinWait("ahk_class Notepad", , 5)
            ToolTip("Notepad launched")
            SetTimer(() => ToolTip(), -1500)
        }
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 2: Conditional Window Actions Based on State
; ============================================================================

/**
 * Performs different actions based on window state
 * Demonstrates complex conditional logic
 * 
 * @hotkey F2 - Conditional window action
 */
F2:: {
    ConditionalWindowAction()
}

/**
 * Performs context-aware window operations
 */
ConditionalWindowAction() {
    static actionGui := ""

    if actionGui {
        try actionGui.Destroy()
    }

    actionGui := Gui("+AlwaysOnTop", "Conditional Window Actions")
    actionGui.SetFont("s10", "Segoe UI")

    actionGui.Add("Text", "w400", "Select target application:")
    appDrop := actionGui.Add("DropDownList", "w400 vApp Choose1",
        ["Notepad", "Calculator", "Paint"])

    actionGui.Add("Text", "w400", "Action logic:")
    actionGui.Add("Text", "w400", "• If doesn't exist → Launch it`n• If exists but not active → Activate it`n• If active and maximized → Restore it`n• If active and normal → Maximize it")

    actionGui.Add("Button", "w195 Default", "Execute").OnEvent("Click", Execute)
    actionGui.Add("Button", "w195 x+10 yp", "Cancel").OnEvent("Click", (*) => actionGui.Destroy())

    actionGui.Show()

    Execute(*) {
        appChoice := appDrop.Value

        ; Define application specs
        apps := Map(
            1, { name: "Notepad", exe: "notepad.exe", criteria: "ahk_class Notepad" },
            2, { name: "Calculator", exe: "calc.exe", criteria: "Calculator ahk_exe ApplicationFrameHost.exe" },
            3, { name: "Paint", exe: "mspaint.exe", criteria: "ahk_class MSPaintApp" }
        )

        app := apps[appChoice]
        actionGui.Destroy()

        ; Execute conditional logic
        if !WinExist(app.criteria) {
            ; Launch if doesn't exist
            Run(app.exe)
            WinWait(app.criteria, , 5)
            MsgBox("Launched: " app.name, "Action: Launch", 64)
        } else if !WinActive(app.criteria) {
            ; Activate if not active
            WinActivate()
            MsgBox("Activated: " app.name, "Action: Activate", 64)
        } else {
            ; Active - toggle maximize/restore
            state := WinGetMinMax()
            if (state = 1) {
                ; Maximized - restore it
                WinRestore()
                MsgBox("Restored: " app.name, "Action: Restore", 64)
            } else {
                ; Normal - maximize it
                WinMaximize()
                MsgBox("Maximized: " app.name, "Action: Maximize", 64)
            }
        }
    }
}

; ============================================================================
; Example 3: Multi-Condition Window Router
; ============================================================================

/**
 * Routes to different windows based on complex conditions
 * Useful for workspace management
 * 
 * @hotkey F3 - Smart window router
 */
F3:: {
    SmartWindowRouter()
}

/**
 * Intelligently routes to the most appropriate window
 */
SmartWindowRouter() {
    ; Priority list of applications to check
    priorities := [{
        name: "Code Editor", criteria: "ahk_exe Code.exe", priority: 1 }, {
            name: "Browser", criteria: "ahk_exe chrome.exe", priority: 2 }, {
                name: "Terminal", criteria: "ahk_class ConsoleWindowClass", priority: 3 }, {
                    name: "File Explorer", criteria: "ahk_class CabinetWClass", priority: 4 }, {
                        name: "Notepad", criteria: "ahk_class Notepad", priority: 5
                    }
    ]

    ; Find highest priority existing window
    foundWindow := ""
    highestPriority := 999

    for app in priorities {
        if WinExist(app.criteria) && app.priority < highestPriority {
            foundWindow := app
            highestPriority := app.priority
        }
    }

    if foundWindow != "" {
        WinActivate(foundWindow.criteria)
        count := WinGetCount(foundWindow.criteria)
        MsgBox("Routed to: " foundWindow.name "`nPriority: " foundWindow.priority "`nWindows: " count, "Window Router", 64)
    } else {
        MsgBox("No priority windows found.`n`nChecked for:`n- Code Editor`n- Browser`n- Terminal`n- File Explorer`n- Notepad", "No Windows", 48)
    }
}

; ============================================================================
; Example 4: Workspace State Manager
; ============================================================================

/**
 * Manages different workspace states based on window existence
 * Demonstrates workspace automation
 * 
 * @hotkey F4 - Manage workspace
 */
F4:: {
    ManageWorkspace()
}

/**
 * Manages workspace configurations
 */
ManageWorkspace() {
    static wsGui := ""

    if wsGui {
        try wsGui.Destroy()
    }

    wsGui := Gui("+AlwaysOnTop", "Workspace Manager")
    wsGui.SetFont("s10", "Segoe UI")

    ; Define workspaces
    workspaces := Map(
        "Coding", ["Code.exe", "chrome.exe", "cmd.exe"],
        "Office", ["WINWORD.EXE", "EXCEL.EXE", "chrome.exe"],
        "General", ["notepad.exe", "calc.exe", "explorer.exe"]
    )

    wsGui.Add("Text", "w400", "Select workspace to check/create:")

    wsList := wsGui.Add("ListBox", "w400 h100 vWorkspace")
    for wsName in workspaces {
        wsList.Add([wsName])
    }
    wsList.Choose(1)

    wsGui.Add("Button", "w195 Default", "Check Status").OnEvent("Click", CheckStatus)
    wsGui.Add("Button", "w195 x+10 yp", "Close").OnEvent("Click", (*) => wsGui.Destroy())

    wsGui.Show()

    CheckStatus(*) {
        wsName := wsList.Text
        if !workspaces.Has(wsName) {
            return
        }

        requiredApps := workspaces[wsName]
        status := "Workspace: " wsName "`n" StrRepeat("=", 40) "`n`n"

        foundCount := 0
        missingApps := []

        for exe in requiredApps {
            criteria := "ahk_exe " exe
            if WinExist(criteria) {
                count := WinGetCount(criteria)
                status .= "[✓] " exe ": " count " window(s)`n"
                foundCount++
            } else {
                status .= "[✗] " exe ": Not running`n"
                missingApps.Push(exe)
            }
        }

        status .= "`nStatus: " foundCount "/" requiredApps.Length " applications running"

        if missingApps.Length > 0 {
            status .= "`n`nMissing: " missingApps.Length " app(s)"
        }

        MsgBox(status, "Workspace Status", 64)
    }
}

/**
 * Helper to repeat string
 */
StrRepeat(str, count) {
    result := ""
    Loop count {
        result .= str
    }
    return result
}

; ============================================================================
; Example 5: If-Else Window Decision Tree
; ============================================================================

/**
 * Complex decision tree based on multiple window conditions
 * Demonstrates nested conditional logic
 * 
 * @hotkey F5 - Execute decision tree
 */
F5:: {
    WindowDecisionTree()
}

/**
 * Executes complex decision tree
 */
WindowDecisionTree() {
    decision := ""

    ; Level 1: Check for code editor
    if WinExist("ahk_exe Code.exe") {
        decision .= "Code editor found → "

        ; Level 2: Check if it's active
        if WinActive("ahk_exe Code.exe") {
            decision .= "Already active → "

            ; Level 3: Check for browser
            if WinExist("ahk_exe chrome.exe") {
                decision .= "Browser exists → Switching to browser"
                WinActivate("ahk_exe chrome.exe")
            } else {
                decision .= "No browser → Staying in editor"
            }
        } else {
            decision .= "Not active → Activating editor"
            WinActivate("ahk_exe Code.exe")
        }
    } else {
        decision .= "No code editor → "

        ; Check for Notepad as fallback
        if WinExist("ahk_class Notepad") {
            decision .= "Notepad found → Activating Notepad"
            WinActivate("ahk_class Notepad")
        } else {
            decision .= "No Notepad → Launching Notepad"
            Run("notepad.exe")
        }
    }

    MsgBox("Decision Path:`n" decision, "Decision Tree Result", 64)
}

; ============================================================================
; Example 6: Window Existence Validator
; ============================================================================

/**
 * Validates that required windows exist before executing operations
 * Prevents errors in automation workflows
 * 
 * @hotkey F6 - Validate and execute
 */
F6:: {
    ValidateAndExecute()
}

/**
 * Validates window prerequisites
 */
ValidateAndExecute() {
    ; Define required windows for operation
    requirements := [{
        name: "Source", criteria: "ahk_class Notepad", desc: "Notepad (source)" }, {
            name: "Target", criteria: "ahk_class WordPadClass", desc: "WordPad (target)"
        }
    ]

    ; Validate all requirements
    validated := true
    missingWindows := []

    for req in requirements {
        if !WinExist(req.criteria) {
            validated := false
            missingWindows.Push(req.desc)
        }
    }

    if !validated {
        missing := ""
        for win in missingWindows {
            missing .= "• " win "`n"
        }

        result := MsgBox("Missing required windows:`n" missing "`nWould you like to launch them?",
            "Validation Failed", 4)

        if result = "Yes" {
            ; Launch missing windows
            for req in requirements {
                if !WinExist(req.criteria) {
                    if InStr(req.criteria, "Notepad") {
                        Run("notepad.exe")
                        WinWait("ahk_class Notepad", , 5)
                    } else if InStr(req.criteria, "WordPad") {
                        Run("write.exe")
                        WinWait("ahk_class WordPadClass", , 5)
                    }
                }
            }
            MsgBox("Required windows launched. Try again.", "Ready", 64)
        }
        return
    }

    ; Execute operation if validated
    MsgBox("All required windows exist!`n`nExecuting operation...`n(This is a demonstration)", "Validation Passed", 64)

    ; Simulate operation
    WinActivate(requirements[1].criteria)
    Send("^a^c")  ; Copy from source
    Sleep(500)
    WinActivate(requirements[2].criteria)
    Send("^v")  ; Paste to target

    MsgBox("Operation completed successfully!", "Success", 64)
}

; ============================================================================
; Example 7: Context-Aware Hotkey Behavior
; ============================================================================

/**
 * Changes hotkey behavior based on which windows exist
 * Demonstrates adaptive scripting
 * 
 * @hotkey F7 - Context-aware action
 */
F7:: {
    ContextAwareAction()
}

/**
 * Performs different actions based on context
 */
ContextAwareAction() {
    ; Determine context
    context := "Unknown"
    action := ""

    if WinExist("ahk_exe Code.exe") && WinExist("ahk_exe chrome.exe") {
        context := "Development Environment"
        action := "Detected: Code editor + Browser`nAction: Arranging windows side-by-side"

        ; Arrange windows
        WinActivate("ahk_exe Code.exe")
        WinMove(0, 0, A_ScreenWidth // 2, A_ScreenHeight)

        WinActivate("ahk_exe chrome.exe")
        WinMove(A_ScreenWidth // 2, 0, A_ScreenWidth // 2, A_ScreenHeight)

    } else if WinExist("ahk_class Notepad") {
        context := "Text Editing"
        action := "Detected: Notepad`nAction: Inserting timestamp"

        WinActivate("ahk_class Notepad")
        Send(A_Now)

    } else if WinExist("ahk_exe chrome.exe") {
        context := "Web Browsing"
        action := "Detected: Browser only`nAction: Opening new tab"

        WinActivate("ahk_exe chrome.exe")
        Send("^t")

    } else {
        context := "No Context"
        action := "No recognized applications found`nAction: Showing available options"
    }

    MsgBox("Context: " context "`n`n" action, "Context-Aware Hotkey", 64)
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc:: ExitApp()

^F1:: {
    help := "
                        (
                        WinExist Examples - Part 3 (Conditional Logic)
                        ==============================================

                        Hotkeys:
                        F1 - Toggle Notepad (smart toggle)
                        F2 - Conditional window action
                        F3 - Smart window router
                        F4 - Manage workspace
                        F5 - Execute decision tree
                        F6 - Validate and execute
                        F7 - Context-aware action
                        Esc - Exit script

                        Ctrl+F1 - Show this help
                        )"

    MsgBox(help, "Help", 64)
}
