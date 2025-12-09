/**
* ============================================================================
* AutoHotkey v2 #HotIf Directive - Context-Sensitive Hotkeys
* ============================================================================
*
* @description Comprehensive examples demonstrating #HotIf directive for
*              creating context-sensitive hotkeys in AutoHotkey v2
*
* @author AHK v2 Documentation Team
* @version 2.0.0
* @date 2025-01-15
*
* DIRECTIVE: #HotIf
* PURPOSE: Make hotkeys context-sensitive based on conditions
* SYNTAX: #HotIf [Expression]
*         #HotIf WinActive("ahk_class Notepad")
*         #HotIf MyFunction()
*
* @reference https://www.autohotkey.com/docs/v2/lib/_HotIf.htm
*/

#Requires AutoHotkey v2.0

/**
* ============================================================================
* Example 1: Basic #HotIf Usage
* ============================================================================
*
* @description Simple context-sensitive hotkey examples
* @concept Basic #HotIf, context switching, conditional hotkeys
*/

; Global hotkey - works everywhere
F1::MsgBox("F1 pressed globally", "Global Hotkey", "Iconi")

; Context-sensitive hotkey for Notepad
#HotIf WinActive("ahk_class Notepad")

F2::MsgBox("F2 in Notepad - Insert current date", "Notepad", "Iconi")
^d::SendText(FormatTime(, "yyyy-MM-dd"))  ; Ctrl+D inserts date
#HotIf

; Context-sensitive hotkey for Chrome
#HotIf WinActive("ahk_exe chrome.exe")

F2::MsgBox("F2 in Chrome - Open developer tools", "Chrome", "Iconi")
F12::Send("^+i")  ; Alternative dev tools shortcut
#HotIf

; Context-sensitive hotkey for VS Code
#HotIf WinActive("ahk_exe Code.exe")

F2::MsgBox("F2 in VS Code - Quick file open", "VS Code", "Iconi")
^p::MsgBox("Override Ctrl+P in VS Code", "VS Code", "Iconi")
#HotIf

; Reset context - back to global
#HotIf

/**
* ============================================================================
* Example 2: Multiple Condition Types
* ============================================================================
*
* @description Demonstrate various #HotIf condition types
* @concept Window matching, process matching, title matching
*/

; Activate for specific window class
#HotIf WinActive("ahk_class CabinetWClass")  ; File Explorer

F3::{
    MsgBox("F3 in File Explorer`nCurrent path: " WinGetTitle("A"), "Explorer", "Iconi")
}
#HotIf

; Activate for specific window title
#HotIf WinActive("Document1 - Microsoft Word")

F4::MsgBox("Specific Word document active", "Word", "Iconi")
#HotIf

; Activate for windows matching partial title
#HotIf WinActive("- Microsoft Excel")

F4::MsgBox("Any Excel window active", "Excel", "Iconi")
#HotIf

; Activate for specific process ID (dynamic example)
#HotIf WinActive("ahk_pid " . GetCurrentPID())

F5::MsgBox("This would match current process", "Process", "Iconi")
#HotIf

GetCurrentPID() {
    return WinGetPID("A")
}

/**
* ============================================================================
* Example 3: Window Existence vs Active State
* ============================================================================
*
* @description Distinguish between window active and window exists
* @concept WinActive vs WinExist, conditional logic
*/

; Only when Notepad is the active window
#HotIf WinActive("ahk_class Notepad")

^!n::MsgBox("Notepad is ACTIVE", "Active", "Iconi")
#HotIf

; When Notepad exists (even if not active)
#HotIf WinExist("ahk_class Notepad")

^!+n::MsgBox("Notepad EXISTS (may not be active)", "Exists", "Iconi")
#HotIf

; When Notepad does NOT exist
#HotIf !WinExist("ahk_class Notepad")

^!n::MsgBox("Notepad does not exist - launching...", "Launch", "Iconi")
#HotIf

/**
* Display window state information
*/
^!w::{
    notepadActive := WinActive("ahk_class Notepad")
    notepadExists := WinExist("ahk_class Notepad")

    info := "Window State Information`n"
    info .= "========================`n`n"
    info .= "Notepad Active: " (notepadActive ? "Yes" : "No") "`n"
    info .= "Notepad Exists: " (notepadExists ? "Yes" : "No") "`n`n"

    if (notepadExists) {
        WinGetTitle(&title, "ahk_class Notepad")
        info .= "Notepad Title: " title "`n"
    }

    info .= "`nActive Window: " WinGetTitle("A") "`n"
    info .= "Active Class: " WinGetClass("A")

    MsgBox(info, "Window State", "Iconi")
}

/**
* ============================================================================
* Example 4: Combining Multiple Conditions
* ============================================================================
*
* @description Use complex expressions with multiple conditions
* @concept Logical operators, complex conditions, expression evaluation
*/

; Multiple conditions with AND
#HotIf WinActive("ahk_class Notepad") && GetKeyState("CapsLock", "T")

^s::MsgBox("Save in Notepad WITH CapsLock ON", "Conditional Save", "Iconi")
#HotIf

; Multiple conditions with OR
#HotIf WinActive("ahk_exe notepad.exe") || WinActive("ahk_exe notepad++.exe")

^!t::MsgBox("Works in Notepad OR Notepad++", "Text Editors", "Iconi")
#HotIf

; Complex condition with function call
#HotIf IsTextEditor()

^!e::MsgBox("Text editor detected!", "Editor", "Iconi")
#HotIf

/**
* Check if current window is a text editor
* @returns {Boolean} True if text editor
*/
IsTextEditor() {
    editors := [
    "ahk_exe notepad.exe",
    "ahk_exe notepad++.exe",
    "ahk_exe Code.exe",
    "ahk_exe sublime_text.exe"
    ]

    for editor in editors {
        if WinActive(editor)
        return true
    }
    return false
}

/**
* ============================================================================
* Example 5: State-Based Hotkeys
* ============================================================================
*
* @description Create hotkeys based on script state variables
* @concept State management, dynamic behavior, mode switching
*/

global EditMode := false
global DebugMode := false

; Hotkey only active when EditMode is enabled
#HotIf EditMode

e::MsgBox("Edit mode is ON - E pressed", "Edit Mode", "Iconi")
^e::MsgBox("Edit mode - Ctrl+E", "Edit Mode", "Iconi")
#HotIf

; Hotkey only active when DebugMode is enabled
#HotIf DebugMode

d::MsgBox("Debug mode is ON - D pressed", "Debug Mode", "Iconi")
F9::MsgBox("Debug: Set breakpoint", "Debug", "Iconi")
#HotIf

; Hotkeys to toggle modes (always available)
#HotIf

^!e::ToggleEditMode()
^!d::ToggleDebugMode()
^!i::ShowModeInfo()
#HotIf

/**
* Toggle edit mode
* @returns {void}
*/
ToggleEditMode() {
    global EditMode
    EditMode := !EditMode
    TrayTip("Edit Mode: " (EditMode ? "ON" : "OFF"), "Mode Toggle", "Iconi Mute")
}

/**
* Toggle debug mode
* @returns {void}
*/
ToggleDebugMode() {
    global DebugMode
    DebugMode := !DebugMode
    TrayTip("Debug Mode: " (DebugMode ? "ON" : "OFF"), "Mode Toggle", "Iconi Mute")
}

/**
* Display current mode information
* @returns {void}
*/
ShowModeInfo() {
    global EditMode, DebugMode

    info := "Current Mode Status`n"
    info .= "===================`n`n"
    info .= "Edit Mode: " (EditMode ? "✓ ON" : "○ OFF") "`n"
    info .= "Debug Mode: " (DebugMode ? "✓ ON" : "○ OFF") "`n`n"

    info .= "Available Hotkeys:`n"
    info .= "^!e - Toggle Edit Mode`n"
    info .= "^!d - Toggle Debug Mode`n"
    info .= "^!i - Show this info`n"

    if (EditMode)
    info .= "`nEdit Mode Hotkeys: E, ^e`n"

    if (DebugMode)
    info .= "`nDebug Mode Hotkeys: D, F9`n"

    MsgBox(info, "Mode Info", "Iconi")
}

/**
* ============================================================================
* Example 6: Nested and Overlapping Contexts
* ============================================================================
*
* @description Handle nested #HotIf contexts and priority
* @concept Context nesting, priority, override behavior
*/

; Base context: Any browser
#HotIf IsBrowser()

F6::MsgBox("F6 in any browser", "Browser", "Iconi")
#HotIf

; More specific context: Chrome specifically
#HotIf WinActive("ahk_exe chrome.exe")

F6::MsgBox("F6 in Chrome (overrides generic browser)", "Chrome", "Iconi")
^r::MsgBox("Reload in Chrome", "Chrome", "Iconi")
#HotIf

; Even more specific: Chrome with specific tab/site
#HotIf WinActive("ahk_exe chrome.exe") && IsGoogleSite()

F6::MsgBox("F6 in Chrome on Google site", "Chrome/Google", "Iconi")
#HotIf

/**
* Check if window is a browser
* @returns {Boolean} True if browser
*/
IsBrowser() {
    browsers := [
    "ahk_exe chrome.exe",
    "ahk_exe firefox.exe",
    "ahk_exe msedge.exe",
    "ahk_exe opera.exe"
    ]

    for browser in browsers {
        if WinActive(browser)
        return true
    }
    return false
}

/**
* Check if current page is a Google site
* @returns {Boolean} True if Google site
*/
IsGoogleSite() {
    try {
        title := WinGetTitle("A")
        return InStr(title, "Google") > 0
    }
    return false
}

/**
* ============================================================================
* Example 7: Dynamic Context Evaluation
* ============================================================================
*
* @description Contexts that evaluate dynamically based on runtime conditions
* @concept Dynamic evaluation, runtime conditions, time-based contexts
*/

; Hotkey only works during business hours
#HotIf IsBusinessHours()

^!b::MsgBox("Business hours hotkey activated", "Business", "Iconi")
#HotIf

; Hotkey only works on weekdays
#HotIf IsWeekday()

^!5::MsgBox("Weekday-only hotkey", "Weekday", "Iconi")
#HotIf

; Hotkey only works when system isn't busy
#HotIf !IsSystemBusy()

^!p::MsgBox("System performance hotkey", "Performance", "Iconi")
#HotIf

/**
* Check if current time is during business hours
* @returns {Boolean} True if business hours (9 AM - 5 PM)
*/
IsBusinessHours() {
    hour := FormatTime(, "H")
    return (hour >= 9 && hour < 17)
}

/**
* Check if today is a weekday
* @returns {Boolean} True if Monday-Friday
*/
IsWeekday() {
    day := FormatTime(, "WDay")  ; 1=Sunday, 7=Saturday
    return (day >= 2 && day <= 6)
}

/**
* Check if system is busy (simplified)
* @returns {Boolean} True if system appears busy
*/
IsSystemBusy() {
    ; This is a simplified example
    ; In practice, you might check CPU usage, memory, etc.
    return false
}

/**
* Display context evaluation information
*/
^!t::{
    info := "Dynamic Context Status`n"
    info .= "======================`n`n"

    ; Time information
    info .= "Current Time: " FormatTime(, "HH:mm:ss") "`n"
    info .= "Business Hours: " (IsBusinessHours() ? "Yes" : "No") "`n"
    info .= "Weekday: " (IsWeekday() ? "Yes" : "No") "`n"
    info .= "System Busy: " (IsSystemBusy() ? "Yes" : "No") "`n`n"

    ; Window information
    info .= "Active Window:`n"
    info .= "  Title: " WinGetTitle("A") "`n"
    info .= "  Class: " WinGetClass("A") "`n"
    info .= "  Process: " WinGetProcessName("A") "`n`n"

    ; Context checks
    info .= "Context Checks:`n"
    info .= "  Browser: " (IsBrowser() ? "Yes" : "No") "`n"
    info .= "  Text Editor: " (IsTextEditor() ? "Yes" : "No") "`n"

    MsgBox(info, "Context Status", "Iconi")
}

/**
* ============================================================================
* CONTEXT MANAGEMENT CLASS
* ============================================================================
*/

/**
* Context manager for programmatic context control
* @class
*/
class ContextManager {
    static ActiveContexts := Map()

    /**
    * Register a context
    * @param {String} name - Context name
    * @param {Func} condition - Condition function
    * @returns {void}
    */
    static Register(name, condition) {
        this.ActiveContexts[name] := {
            Condition: condition,
            Active: false
        }
    }

    /**
    * Check if context is active
    * @param {String} name - Context name
    * @returns {Boolean} True if active
    */
    static IsActive(name) {
        if (!this.ActiveContexts.Has(name))
        return false

        context := this.ActiveContexts[name]
        context.Active := context.Condition.Call()
        return context.Active
    }

    /**
    * Get all active contexts
    * @returns {Array} List of active context names
    */
    static GetActiveContexts() {
        active := []
        for name, context in this.ActiveContexts {
            if this.IsActive(name)
            active.Push(name)
        }
        return active
    }

    /**
    * Display context status
    * @returns {void}
    */
    static ShowStatus() {
        output := "Context Manager Status`n"
        output .= "======================`n`n"

        output .= "Registered Contexts: " this.ActiveContexts.Count "`n`n"

        if (this.ActiveContexts.Count > 0) {
            for name, context in this.ActiveContexts {
                active := this.IsActive(name)
                status := active ? "✓ Active" : "○ Inactive"
                output .= name ": " status "`n"
            }
        }

        MsgBox(output, "Context Manager", "Iconi")
    }
}

; Register example contexts
ContextManager.Register("Browser", () => IsBrowser())
ContextManager.Register("TextEditor", () => IsTextEditor())
ContextManager.Register("BusinessHours", () => IsBusinessHours())
ContextManager.Register("Weekday", () => IsWeekday())

^!c::ContextManager.ShowStatus()

/**
* ============================================================================
* STARTUP AND HELP
* ============================================================================
*/

TrayTip("Context-sensitive hotkeys loaded", "Script Ready", "Iconi Mute")

/**
* Help system
*/
^!h::{
    help := "Context-Sensitive Hotkeys`n"
    help .= "=========================`n`n"

    help .= "Test Hotkeys:`n"
    help .= "F1 - Global hotkey`n"
    help .= "F2 - Context-specific (varies by window)`n"
    help .= "F3 - File Explorer only`n`n"

    help .= "Mode Toggles:`n"
    help .= "^!e - Toggle Edit Mode`n"
    help .= "^!d - Toggle Debug Mode`n`n"

    help .= "Information:`n"
    help .= "^!w - Window State Info`n"
    help .= "^!t - Context Status`n"
    help .= "^!i - Mode Info`n"
    help .= "^!c - Context Manager`n"
    help .= "^!h - This Help`n`n"

    help .= "Current Status:`n"
    help .= "Edit Mode: " (EditMode ? "ON" : "OFF") "`n"
    help .= "Debug Mode: " (DebugMode ? "ON" : "OFF") "`n"
    help .= "Active Window: " WinGetProcessName("A")

    MsgBox(help, "Help", "Iconi")
}
