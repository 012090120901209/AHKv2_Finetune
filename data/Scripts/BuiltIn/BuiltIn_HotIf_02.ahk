/**
 * ============================================================================
 * AutoHotkey v2 #HotIf Directive - WinActive Patterns
 * ============================================================================
 * 
 * @description Comprehensive examples demonstrating WinActive function
 *              with various window matching patterns for #HotIf
 * 
 * @author AHK v2 Documentation Team
 * @version 2.0.0
 * @date 2025-01-15
 * 
 * DIRECTIVE: #HotIf with WinActive
 * PURPOSE: Create hotkeys active only for specific windows
 * PATTERNS:
 *   - Window Title matching
 *   - Window Class (ahk_class)
 *   - Process Name (ahk_exe)
 *   - Process ID (ahk_pid)
 *   - Window ID (ahk_id)
 *   - Regular expressions (RegEx)
 * 
 * @reference https://www.autohotkey.com/docs/v2/lib/WinActive.htm
 * @reference https://www.autohotkey.com/docs/v2/misc/WinTitle.htm
 */

#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Example 1: Window Title Matching
 * ============================================================================
 * 
 * @description Match windows by their title text
 * @concept Title matching, exact vs partial, case sensitivity
 */

; Exact title match (case-sensitive by default)
#HotIf WinActive("Untitled - Notepad")

^s:: MsgBox("Save in new Notepad document", "Exact Title", "Iconi")
#HotIf

; Partial title match (anywhere in title)
#HotIf WinActive("- Notepad")  ; Matches any Notepad window

F5:: MsgBox("Refresh/Reload in Notepad", "Partial Title", "Iconi")
#HotIf

; Title starts with specific text
#HotIf WinActive("Document")  ; Matches "Document1 - Word", etc.

^!d:: MsgBox("Document window active", "Title Prefix", "Iconi")
#HotIf

/**
 * Test window title matching
 */
^!1:: {
    currentTitle := WinGetTitle("A")

    matches := [{
        pattern: "Untitled - Notepad", desc: "Exact match" }, {
            pattern: "- Notepad", desc: "Contains" }, {
                pattern: "Notepad", desc: "Partial match"
            }
    ]

    output := "Window Title Matching`n"
    output .= "=====================`n"
    output .= "Current: " currentTitle "`n`n"

    for match in matches {
        active := WinActive(match.pattern)
        status := active ? "✓" : "✗"
        output .= status " " match.pattern "`n"
        output .= "  " match.desc "`n`n"
    }

    MsgBox(output, "Title Matching", "Iconi")
}

/**
 * ============================================================================
 * Example 2: Window Class Matching (ahk_class)
 * ============================================================================
 * 
 * @description Match windows by their window class
 * @concept Window class, class identification, class-based targeting
 */

; Match Notepad by class
#HotIf WinActive("ahk_class Notepad")

^!n:: MsgBox("Notepad class detected", "Class Match", "Iconi")
#HotIf

; Match File Explorer by class
#HotIf WinActive("ahk_class CabinetWClass")

^!f:: {
    path := "Unknown"
    try {
        ; Get current explorer path
        for window in ComObject("Shell.Application").Windows {
            if (window.HWND = WinGetID("A")) {
                path := window.LocationURL
                path := StrReplace(path, "file:///", "")
                path := StrReplace(path, "/", "\")
                break
            }
        }
    }
    MsgBox("File Explorer Path:`n" path, "Explorer", "Iconi")
}
#HotIf

; Match Calculator by class
#HotIf WinActive("ahk_class Calculator")  ; Old Calculator

^c:: MsgBox("Classic Calculator", "Calc", "Iconi")
#HotIf

#HotIf WinActive("ahk_class ApplicationFrameWindow") && InStr(WinGetTitle("A"), "Calculator")

^c:: MsgBox("Modern Calculator (Windows 10/11)", "Calc", "Iconi")
#HotIf

/**
 * Display window class information
 */
^!2:: {
    hwnd := WinGetID("A")
    class := WinGetClass("A")
    title := WinGetTitle("A")
    process := WinGetProcessName("A")

    info := "Window Class Information`n"
    info .= "========================`n`n"
    info .= "Title: " title "`n"
    info .= "Class: " class "`n"
    info .= "Process: " process "`n"
    info .= "HWND: " hwnd "`n`n"

    ; Common window classes
    commonClasses := Map(
        "Notepad", "Notepad",
        "CabinetWClass", "File Explorer",
        "Chrome_WidgetWin_1", "Google Chrome",
        "MozillaWindowClass", "Firefox",
        "XLMAIN", "Microsoft Excel",
        "OpusApp", "Microsoft Word"
    )

    if commonClasses.Has(class)
        info .= "Identified as: " commonClasses[class]

    MsgBox(info, "Class Info", "Iconi")
}

/**
 * ============================================================================
 * Example 3: Process/Executable Matching (ahk_exe)
 * ============================================================================
 * 
 * @description Match windows by process executable name
 * @concept Process matching, executable identification
 */

; Match Google Chrome
#HotIf WinActive("ahk_exe chrome.exe")

^!+d:: {
    MsgBox("Chrome Developer Tools`nProcess: chrome.exe", "Chrome", "Iconi")
}
#HotIf

; Match VS Code
#HotIf WinActive("ahk_exe Code.exe")

^!+c:: {
    MsgBox("VS Code Command Palette`nProcess: Code.exe", "VS Code", "Iconi")
}
#HotIf

; Match Microsoft Office applications
#HotIf WinActive("ahk_exe WINWORD.EXE")

^!w:: MsgBox("Microsoft Word", "Word", "Iconi")
#HotIf

#HotIf WinActive("ahk_exe EXCEL.EXE")

^!e:: MsgBox("Microsoft Excel", "Excel", "Iconi")
#HotIf

#HotIf WinActive("ahk_exe POWERPNT.EXE")

^!p:: MsgBox("Microsoft PowerPoint", "PowerPoint", "Iconi")
#HotIf

/**
 * Display process information
 */
^!3:: {
    process := WinGetProcessName("A")
    pid := WinGetPID("A")
    path := WinGetProcessPath("A")

    info := "Process Information`n"
    info .= "===================`n`n"
    info .= "Process Name: " process "`n"
    info .= "Process ID: " pid "`n"
    info .= "Path: " path "`n`n"

    ; Get additional process info
    try {
        for proc in ComObjGet("winmgmts:").ExecQuery(
            "Select * from Win32_Process where ProcessId=" pid) {
            info .= "Command Line:`n" proc.CommandLine "`n`n"
            info .= "Working Directory: " proc.ExecutablePath
            break
        }
    }

    MsgBox(info, "Process Info", "Iconi")
}

/**
 * ============================================================================
 * Example 4: Process ID Matching (ahk_pid)
 * ============================================================================
 * 
 * @description Match specific window by process ID
 * @concept PID matching, specific instance targeting
 */

global TargetPID := 0

/**
 * Set target window PID
 */
^!SetPID:: {
    global TargetPID
    TargetPID := WinGetPID("A")
    TrayTip("Target PID set to: " TargetPID, "PID Set", "Iconi Mute")
}

; Hotkey for specific PID (requires dynamic context)
#HotIf TargetPID > 0 && WinActive("ahk_pid " TargetPID)

^!target:: MsgBox("Target window with PID " TargetPID, "PID Match", "Iconi")
#HotIf

/**
 * Display all windows for current process
 */
^!4:: {
    pid := WinGetPID("A")
    processName := WinGetProcessName("A")

    windows := []
    ids := WinGetList("ahk_pid " pid)

    for id in ids {
        title := WinGetTitle("ahk_id " id)
        if (title != "")
            windows.Push({ ID: id, Title: title })
    }

    output := "Windows for Process`n"
    output .= "===================`n"
    output .= "Process: " processName "`n"
    output .= "PID: " pid "`n"
    output .= "Window Count: " windows.Length "`n`n"

    if (windows.Length > 0) {
        output .= "Windows:`n"
        for win in windows {
            output .= "• " win.Title "`n"
            output .= "  ID: " win.ID "`n`n"
        }
    }

    MsgBox(output, "Process Windows", "Iconi")
}

/**
 * ============================================================================
 * Example 5: Window ID Matching (ahk_id)
 * ============================================================================
 * 
 * @description Match specific window by unique ID
 * @concept HWND matching, specific window targeting
 */

global TargetHWND := 0

/**
 * Set target window ID
 */
^!SetID:: {
    global TargetHWND
    TargetHWND := WinGetID("A")
    title := WinGetTitle("ahk_id " TargetHWND)
    TrayTip("Target window set:`n" title, "Window Set", "Iconi Mute")
}

; Hotkey for specific window ID
#HotIf TargetHWND > 0 && WinActive("ahk_id " TargetHWND)

^!+t:: MsgBox("Specific target window active`nHWND: " TargetHWND, "ID Match", "Iconi")
#HotIf

/**
 * Display window ID information
 */
^!5:: {
    hwnd := WinGetID("A")
    title := WinGetTitle("A")
    class := WinGetClass("A")
    process := WinGetProcessName("A")

    ; Get window rect
    WinGetPos(&x, &y, &w, &h, "A")

    info := "Window ID Information`n"
    info .= "=====================`n`n"
    info .= "HWND: " hwnd " (0x" Format("{:X}", hwnd) ")`n"
    info .= "Title: " title "`n"
    info .= "Class: " class "`n"
    info .= "Process: " process "`n`n"

    info .= "Position:`n"
    info .= "  X: " x ", Y: " y "`n"
    info .= "  Width: " w ", Height: " h "`n`n"

    ; Window state
    info .= "State:`n"
    info .= "  Minimized: " (WinGetMinMax("A") = -1 ? "Yes" : "No") "`n"
    info .= "  Maximized: " (WinGetMinMax("A") = 1 ? "Yes" : "No") "`n"
    info .= "  Always on Top: " (WinGetExStyle("A") & 0x8 ? "Yes" : "No")

    MsgBox(info, "Window ID", "Iconi")
}

/**
 * ============================================================================
 * Example 6: Multiple Criteria Matching
 * ============================================================================
 * 
 * @description Combine multiple window matching criteria
 * @concept Compound matching, multiple filters
 */

; Match by class AND title
#HotIf WinActive("ahk_class Notepad") && InStr(WinGetTitle("A"), ".ahk")

^!a:: MsgBox("Notepad with AHK file open", "AHK in Notepad", "Iconi")
#HotIf

; Match by process AND title pattern
#HotIf WinActive("ahk_exe chrome.exe") && InStr(WinGetTitle("A"), "GitHub")

^!g:: MsgBox("Chrome with GitHub page", "GitHub", "Iconi")
#HotIf

; Match by class OR process
#HotIf WinActive("ahk_class Notepad") || WinActive("ahk_exe notepad++.exe")

^!+n:: MsgBox("Any Notepad variant", "Notepad", "Iconi")
#HotIf

/**
 * Advanced window filter
 * @param {String} title - Window title
 * @returns {Boolean} True if matches criteria
 */
AdvancedFilter(title := "A") {
    ; Get window information
    class := WinGetClass(title)
    process := WinGetProcessName(title)
    winTitle := WinGetTitle(title)

    ; Complex filtering logic
    isTextEditor := (process = "notepad.exe"
        || process = "notepad++.exe"
        || process = "Code.exe")

    isWorkFile := (InStr(winTitle, ".txt")
        || InStr(winTitle, ".ahk")
        || InStr(winTitle, ".md"))

    return isTextEditor && isWorkFile
}

#HotIf AdvancedFilter()

^!+f:: MsgBox("Advanced filter matched!", "Filter", "Iconi")
#HotIf

/**
 * Test multiple criteria
 */
^!6:: {
    output := "Multiple Criteria Testing`n"
    output .= "=========================`n`n"

    title := WinGetTitle("A")
    class := WinGetClass("A")
    process := WinGetProcessName("A")

    output .= "Current Window:`n"
    output .= "  Title: " title "`n"
    output .= "  Class: " class "`n"
    output .= "  Process: " process "`n`n"

    tests := [{
        desc: "Is Notepad", check: WinActive("ahk_class Notepad") }, {
            desc: "Is Browser", check: IsBrowser() }, {
                desc: "Has .ahk file", check: InStr(title, ".ahk") > 0 }, {
                    desc: "Advanced Filter", check: AdvancedFilter()
                }
    ]

    output .= "Test Results:`n"
    for test in tests {
        status := test.check ? "✓" : "✗"
        output .= "  " status " " test.desc "`n"
    }

    MsgBox(output, "Criteria Test", "Iconi")
}

/**
 * Check if browser window
 * @returns {Boolean} True if browser
 */
IsBrowser() {
    browsers := ["chrome.exe", "firefox.exe", "msedge.exe", "opera.exe"]
    process := WinGetProcessName("A")
    for browser in browsers {
        if (process = browser)
            return true
    }
    return false
}

/**
 * ============================================================================
 * Example 7: Window Group Matching
 * ============================================================================
 * 
 * @description Create and use window groups for matching
 * @concept Window groups, group management, collective matching
 */

/**
 * Window group manager
 * @class
 */
class WindowGroups {
    static Groups := Map()

    /**
     * Define a window group
     * @param {String} name - Group name
     * @param {Array} criteria - Array of window criteria
     * @returns {void}
     */
    static Define(name, criteria) {
        this.Groups[name] := criteria
    }

    /**
     * Check if active window matches group
     * @param {String} groupName - Group name
     * @returns {Boolean} True if matches
     */
    static MatchesGroup(groupName) {
        if (!this.Groups.Has(groupName))
            return false

        for criterion in this.Groups[groupName] {
            if WinActive(criterion)
                return true
        }
        return false
    }

    /**
     * Get all matching groups
     * @returns {Array} List of matching group names
     */
    static GetMatchingGroups() {
        matching := []
        for name, criteria in this.Groups {
            if this.MatchesGroup(name)
                matching.Push(name)
        }
        return matching
    }

    /**
     * Display group information
     * @returns {void}
     */
    static ShowGroups() {
        output := "Window Groups`n"
        output .= "=============`n`n"

        output .= "Defined Groups: " this.Groups.Count "`n`n"

        for name, criteria in this.Groups {
            matches := this.MatchesGroup(name)
            status := matches ? "✓" : "○"

            output .= status " " name " (" criteria.Length " criteria)`n"
            for criterion in criteria {
                output .= "    • " criterion "`n"
            }
            output .= "`n"
        }

        MsgBox(output, "Window Groups", "Iconi")
    }
}

; Define window groups
WindowGroups.Define("TextEditors", [
    "ahk_exe notepad.exe",
    "ahk_exe notepad++.exe",
    "ahk_exe Code.exe",
    "ahk_exe sublime_text.exe"
])

WindowGroups.Define("Browsers", [
    "ahk_exe chrome.exe",
    "ahk_exe firefox.exe",
    "ahk_exe msedge.exe",
    "ahk_exe opera.exe"
])

WindowGroups.Define("Office", [
    "ahk_exe WINWORD.EXE",
    "ahk_exe EXCEL.EXE",
    "ahk_exe POWERPNT.EXE",
    "ahk_exe OUTLOOK.EXE"
])

; Use window groups in hotkeys
#HotIf WindowGroups.MatchesGroup("TextEditors")

^!+e:: MsgBox("Text editor detected!", "Editor", "Iconi")
#HotIf

#HotIf WindowGroups.MatchesGroup("Browsers")

^!+b:: MsgBox("Browser detected!", "Browser", "Iconi")
#HotIf

^!7:: WindowGroups.ShowGroups()

/**
 * ============================================================================
 * UTILITY FUNCTIONS
 * ============================================================================
 */

/**
 * Get comprehensive window information
 * @returns {Object} Window information
 */
GetWindowInfo() {
    return {
        Title: WinGetTitle("A"),
        Class: WinGetClass("A"),
        Process: WinGetProcessName("A"),
        ProcessPath: WinGetProcessPath("A"),
        PID: WinGetPID("A"),
        ID: WinGetID("A")
    }
}

/**
 * Display all window information
 */
^!i:: {
    info := GetWindowInfo()

    output := "Complete Window Information`n"
    output .= "===========================`n`n"
    output .= "Title: " info.Title "`n"
    output .= "Class: " info.Class "`n"
    output .= "Process: " info.Process "`n"
    output .= "Path: " info.ProcessPath "`n"
    output .= "PID: " info.PID "`n"
    output .= "HWND: " info.ID " (0x" Format("{:X}", info.ID) ")`n`n"

    ; Matching groups
    groups := WindowGroups.GetMatchingGroups()
    if (groups.Length > 0) {
        output .= "Matches Groups:`n"
        for group in groups
            output .= "  • " group "`n"
    }

    MsgBox(output, "Window Info", "Iconi")
}

/**
 * ============================================================================
 * STARTUP
 * ============================================================================
 */

TrayTip("WinActive patterns loaded", "Script Ready", "Iconi Mute")

/**
 * Help
 */
^!h:: {
    help := "WinActive Pattern Matching`n"
    help .= "==========================`n`n"

    help .= "Information Hotkeys:`n"
    help .= "^!1 - Title Matching Tests`n"
    help .= "^!2 - Window Class Info`n"
    help .= "^!3 - Process Info`n"
    help .= "^!4 - Process Windows`n"
    help .= "^!5 - Window ID Info`n"
    help .= "^!6 - Criteria Tests`n"
    help .= "^!7 - Window Groups`n"
    help .= "^!i - Complete Window Info`n`n"

    help .= "Targeting:`n"
    help .= "^!SetPID - Set target PID`n"
    help .= "^!SetID - Set target window`n`n"

    help .= "^!h - Show Help"

    MsgBox(help, "Help", "Iconi")
}
