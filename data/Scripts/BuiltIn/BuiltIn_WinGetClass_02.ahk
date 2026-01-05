#Requires AutoHotkey v2.0
/**
#SingleInstance Force
 * @file BuiltIn_WinGetClass_02.ahk
 * @description Advanced window class-based identification, filtering, and monitoring examples using WinGetClass in AutoHotkey v2
 * @author AutoHotkey Foundation
 * @version 2.0
 * @date 2024-01-15
 * 
 * @section EXAMPLES
 * Example 1: Class-based window monitor
 * Example 2: Application launcher by class
 * Example 3: Class hierarchy analyzer
 * Example 4: Window class grouping
 * Example 5: Class-based automation router
 * Example 6: Dynamic class templates
 * 
 * @section FEATURES
 * - Real-time class monitoring
 * - Application launching
 * - Class hierarchies
 * - Window grouping
 * - Automation routing
 * - Template system
 */

#Requires AutoHotkey v2.0

; ========================================
; Example 1: Class-Based Window Monitor
; ========================================

/**
 * @class ClassMonitor
 * @description Monitor windows based on their class names
 */
class ClassMonitor {
    static monitors := Map()
    static checkInterval := 1000
    static timerActive := false

    /**
     * @method WatchForClass
     * @description Watch for windows of a specific class
     * @param className Class to watch for
     * @param callback Function to call when found
     * @param continuous Keep watching (default: false)
     */
    static WatchForClass(className, callback, continuous := false) {
        this.monitors[className] := {
            ClassName: className,
            Callback: callback,
            Continuous: continuous,
            Found: Map(),
            LastCheck: 0
        }

        if !this.timerActive {
            SetTimer(() => this.CheckAllMonitors(), this.checkInterval)
            this.timerActive := true
        }

        TrayTip("Now watching for: " className, "Class Monitor", "Icon!")
    }

    /**
     * @method StopWatching
     * @description Stop watching for a class
     * @param className Class name
     */
    static StopWatching(className) {
        this.monitors.Delete(className)

        if this.monitors.Count = 0 {
            SetTimer(() => this.CheckAllMonitors(), 0)
            this.timerActive := false
        }
    }

    /**
     * @method CheckAllMonitors
     * @description Check all monitored classes
     */
    static CheckAllMonitors() {
        for className, monitor in this.monitors {
            this.CheckClass(className, monitor)
        }
    }

    /**
     * @method CheckClass
     * @description Check for windows of a specific class
     * @param className Class to check
     * @param monitor Monitor data
     */
    static CheckClass(className, monitor) {
        allWindows := WinGetList()
        foundNow := Map()

        for winId in allWindows {
            try {
                winClass := WinGetClass("ahk_id " winId)

                if winClass = className {
                    foundNow[winId] := true

                    ; Check if this is a new window
                    if !monitor.Found.Has(winId) {
                        monitor.Found[winId] := A_TickCount

                        ; Call callback for new window
                        monitor.Callback({
                            WindowID: winId,
                            ClassName: className,
                            Title: WinGetTitle("ahk_id " winId),
                            Process: WinGetProcessName("ahk_id " winId),
                            Event: "Created"
                        })
                    }
                }
            }
        }

        ; Check for closed windows
        for winId, _ in monitor.Found {
            if !foundNow.Has(winId) {
                ; Window was closed
                monitor.Callback({
                    WindowID: winId,
                    ClassName: className,
                    Event: "Closed"
                })

                monitor.Found.Delete(winId)
            }
        }

        monitor.LastCheck := A_TickCount

        ; Stop if not continuous and we found something
        if !monitor.Continuous && monitor.Found.Count > 0 {
            this.StopWatching(className)
        }
    }

    /**
     * @method GetMonitorStats
     * @description Get statistics for all monitors
     * @returns {String} Formatted statistics
     */
    static GetMonitorStats() {
        if this.monitors.Count = 0
            return "No active monitors"

        output := "Active Class Monitors:`n`n"

        for className, monitor in this.monitors {
            output .= className ": " monitor.Found.Count " window(s)`n"
            output .= "  Continuous: " (monitor.Continuous ? "Yes" : "No") "`n"
            output .= "  Last Check: " ((A_TickCount - monitor.LastCheck) // 1000) "s ago`n`n"
        }

        return output
    }
}

; Example callback
OnClassDetected(data) {
    if data.Event = "Created" {
        TrayTip("Window Created: " data.Title, "Class: " data.ClassName, "Icon!")
    } else if data.Event = "Closed" {
        TrayTip("Window Closed", "Class: " data.ClassName, "Icon!")
    }
}

; Hotkey: Ctrl+Shift+W - Watch for class
^+w:: {
    className := WinGetClass("A")
    ClassMonitor.WatchForClass(className, OnClassDetected, true)
}

; ========================================
; Example 2: Application Launcher by Class
; ========================================

/**
 * @class ClassLauncher
 * @description Launch or activate applications by their window class
 */
class ClassLauncher {
    static appDatabase := Map()

    /**
     * @method RegisterApplication
     * @description Register an application with its class and executable
     * @param name Application name
     * @param className Window class
     * @param exePath Executable path
     * @param args Command line arguments
     */
    static RegisterApplication(name, className, exePath, args := "") {
        this.appDatabase[name] := {
            Name: name,
            ClassName: className,
            ExePath: exePath,
            Args: args,
            LaunchCount: 0,
            LastLaunched: ""
        }
    }

    /**
     * @method LaunchOrActivate
     * @description Launch app if not running, or activate if it is
     * @param name Application name
     * @returns {Boolean} Success status
     */
    static LaunchOrActivate(name) {
        if !this.appDatabase.Has(name) {
            MsgBox("Application not registered: " name, "Error", "IconX")
            return false
        }

        app := this.appDatabase[name]

        ; Check if app is already running
        existing := WindowIdentifier.FindWindowsByClass(app.ClassName, true)

        if existing.Length > 0 {
            ; Activate existing window
            try {
                WinActivate("ahk_id " existing[1])
                TrayTip("Activated: " app.Name, "Class Launcher", "Icon!")
                return true
            } catch {
                ; Window found but can't activate, try launching
            }
        }

        ; Launch application
        try {
            if app.Args != "" {
                Run(app.ExePath " " app.Args)
            } else {
                Run(app.ExePath)
            }

            app.LaunchCount++
            app.LastLaunched := A_Now

            ; Wait for window to appear
            try {
                WinWait("ahk_class " app.ClassName, , 5)
                WinActivate("ahk_class " app.ClassName)
                TrayTip("Launched: " app.Name, "Class Launcher", "Icon!")
                return true
            } catch {
                MsgBox("Application launched but window not detected", "Warning", "Icon!")
                return false
            }

        } catch as err {
            MsgBox("Failed to launch " app.Name ": " err.Message, "Error", "IconX")
            return false
        }
    }

    /**
     * @method RegisterCommonApps
     * @description Register common Windows applications
     */
    static RegisterCommonApps() {
        ; Notepad
        this.RegisterApplication("Notepad", "Notepad", "notepad.exe")

        ; Calculator
        this.RegisterApplication("Calculator", "ApplicationFrameWindow", "calc.exe")

        ; Paint
        this.RegisterApplication("Paint", "MSPaintApp", "mspaint.exe")

        ; Task Manager
        this.RegisterApplication("TaskManager", "TaskManagerWindow", "taskmgr.exe")

        TrayTip("Registered common applications", "Class Launcher", "Icon!")
    }

    /**
     * @method ListRegistered
     * @description List all registered applications
     * @returns {String} Formatted list
     */
    static ListRegistered() {
        if this.appDatabase.Count = 0
            return "No applications registered"

        output := "Registered Applications:`n`n"

        for name, app in this.appDatabase {
            output .= name "`n"
            output .= "  Class: " app.ClassName "`n"
            output .= "  Path: " app.ExePath "`n"
            output .= "  Launches: " app.LaunchCount "`n`n"
        }

        return output
    }
}

; Register common apps on startup
ClassLauncher.RegisterCommonApps()

; Hotkey: Ctrl+Shift+L - Launch/Activate by class
^+l:: {
    list := ClassLauncher.ListRegistered()
    MsgBox(list, "Registered Apps", "Icon!")

    name := InputBox("Enter application name to launch:", "Class Launcher").Value
    if name != ""
        ClassLauncher.LaunchOrActivate(name)
}

; ========================================
; Example 3: Class Hierarchy Analyzer
; ========================================

/**
 * @class ClassHierarchy
 * @description Analyze window class hierarchies and parent-child relationships
 */
class ClassHierarchy {
    /**
     * @method GetWindowHierarchy
     * @description Get full window hierarchy starting from a window
     * @param WinTitle Window identifier
     * @returns {Object} Hierarchy data
     */
    static GetWindowHierarchy(WinTitle := "A") {
        try {
            hwnd := WinExist(WinTitle)

            hierarchy := {
                Window: this.GetWindowInfo(hwnd),
                Parent: {},
                Children: [],
                Ancestors: [],
                Descendants: []
            }

            ; Get parent
            parentHwnd := DllCall("GetParent", "Ptr", hwnd, "Ptr")
            if parentHwnd {
                hierarchy.Parent := this.GetWindowInfo(parentHwnd)

                ; Get all ancestors
                current := parentHwnd
                Loop {
                    parent := DllCall("GetParent", "Ptr", current, "Ptr")
                    if !parent
                        break

                    hierarchy.Ancestors.Push(this.GetWindowInfo(parent))
                    current := parent

                    if A_Index > 20  ; Safety limit
                        break
                }
            }

            ; Get children
            children := this.GetChildWindows(hwnd)
            for child in children {
                hierarchy.Children.Push(this.GetWindowInfo(child))
            }

            ; Get all descendants recursively
            hierarchy.Descendants := this.GetAllDescendants(hwnd)

            return hierarchy

        } catch as err {
            return { Error: err.Message }
        }
    }

    /**
     * @method GetWindowInfo
     * @description Get information about a window by HWND
     * @param hwnd Window handle
     * @returns {Object} Window information
     */
    static GetWindowInfo(hwnd) {
        try {
            return {
                HWND: hwnd,
                Class: WinGetClass("ahk_id " hwnd),
                Title: WinGetTitle("ahk_id " hwnd),
                Visible: WinGetStyle("ahk_id " hwnd) & 0x10000000,
                Process: WinGetProcessName("ahk_id " hwnd)
            }
        } catch {
            return {
                HWND: hwnd,
                Class: "Unknown",
                Title: "Unknown",
                Visible: false
            }
        }
    }

    /**
     * @method GetChildWindows
     * @description Get direct children of a window
     * @param hwnd Parent window handle
     * @returns {Array} Child window handles
     */
    static GetChildWindows(hwnd) {
        children := []

        ; Callback for EnumChildWindows
        EnumChildProc := CallbackCreate((child, lParam) => {
            children.Push(child)
            return true  ; Continue enumeration
        }, "Fast", 2)

        DllCall("EnumChildWindows", "Ptr", hwnd, "Ptr", EnumChildProc, "Ptr", 0)
        CallbackFree(EnumChildProc)

        return children
    }

    /**
     * @method GetAllDescendants
     * @description Get all descendants recursively
     * @param hwnd Root window handle
     * @returns {Array} All descendant windows
     */
    static GetAllDescendants(hwnd, depth := 0) {
        descendants := []

        if depth > 10  ; Safety limit
            return descendants

        children := this.GetChildWindows(hwnd)

        for child in children {
            descendants.Push(this.GetWindowInfo(child))

            ; Recursively get descendants
            childDescendants := this.GetAllDescendants(child, depth + 1)
            for desc in childDescendants {
                descendants.Push(desc)
            }
        }

        return descendants
    }

    /**
     * @method FormatHierarchy
     * @description Format hierarchy as readable text
     * @param hierarchy Hierarchy data
     * @returns {String} Formatted text
     */
    static FormatHierarchy(hierarchy) {
        output := "=== Window Hierarchy ===`n`n"

        ; Ancestors
        if hierarchy.Ancestors.Length > 0 {
            output .= "Ancestors:`n"
            for i, ancestor in hierarchy.Ancestors {
                output .= "  " StrRepeat("  ", i - 1) "↑ " ancestor.Class
                if ancestor.Title != ""
                    output .= " (" ancestor.Title ")"
                output .= "`n"
            }
            output .= "`n"
        }

        ; Current window
        output .= "Current Window:`n"
        output .= "  • " hierarchy.Window.Class
        if hierarchy.Window.Title != ""
            output .= " (" hierarchy.Window.Title ")"
        output .= "`n`n"

        ; Children
        if hierarchy.Children.Length > 0 {
            output .= "Direct Children: " hierarchy.Children.Length "`n"
            for child in hierarchy.Children {
                output .= "  ↓ " child.Class
                if child.Title != ""
                    output .= " (" child.Title ")"
                output .= "`n"
            }
            output .= "`n"
        }

        ; Descendants
        if hierarchy.Descendants.Length > 0 {
            output .= "Total Descendants: " hierarchy.Descendants.Length
        }

        return output
    }
}

; Helper function
StrRepeat(str, count) {
    result := ""
    Loop count {
        result .= str
    }
    return result
}

; Hotkey: Ctrl+Shift+H - Show window hierarchy
^+h:: {
    hierarchy := ClassHierarchy.GetWindowHierarchy("A")

    if hierarchy.HasOwnProp("Error") {
        MsgBox(hierarchy.Error, "Error", "IconX")
        return
    }

    output := ClassHierarchy.FormatHierarchy(hierarchy)
    MsgBox(output, "Window Hierarchy", "Icon!")
}

; ========================================
; Example 4: Window Class Grouping
; ========================================

/**
 * @class WindowGroups
 * @description Group windows by their class for batch operations
 */
class WindowGroups {
    static groups := Map()

    /**
     * @method CreateGroup
     * @description Create a group of windows by class
     * @param groupName Group name
     * @param classPatterns Array of class patterns
     */
    static CreateGroup(groupName, classPatterns) {
        this.groups[groupName] := {
            Name: groupName,
            Patterns: classPatterns,
            Created: A_Now
        }
    }

    /**
     * @method GetGroupWindows
     * @description Get all windows belonging to a group
     * @param groupName Group name
     * @returns {Array} Window IDs
     */
    static GetGroupWindows(groupName) {
        if !this.groups.Has(groupName)
            return []

        group := this.groups[groupName]
        windows := []
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                winClass := WinGetClass("ahk_id " winId)

                for pattern in group.Patterns {
                    if InStr(winClass, pattern) {
                        windows.Push(winId)
                        break
                    }
                }
            }
        }

        return windows
    }

    /**
     * @method MinimizeGroup
     * @description Minimize all windows in a group
     * @param groupName Group name
     */
    static MinimizeGroup(groupName) {
        windows := this.GetGroupWindows(groupName)

        for winId in windows {
            try {
                WinMinimize("ahk_id " winId)
            }
        }

        TrayTip("Minimized " windows.Length " windows", "Group: " groupName, "Icon!")
    }

    /**
     * @method CloseGroup
     * @description Close all windows in a group
     * @param groupName Group name
     */
    static CloseGroup(groupName) {
        windows := this.GetGroupWindows(groupName)

        result := MsgBox("Close " windows.Length " windows?", "Confirm", "YesNo Icon?")
        if result = "No"
            return

        for winId in windows {
            try {
                WinClose("ahk_id " winId)
            }
        }

        TrayTip("Closed " windows.Length " windows", "Group: " groupName, "Icon!")
    }

    /**
     * @method CreatePredefinedGroups
     * @description Create common window groups
     */
    static CreatePredefinedGroups() {
        ; Browser group
        this.CreateGroup("Browsers", ["Chrome", "Mozilla", "Edge", "Firefox"])

        ; Office group
        this.CreateGroup("Office", ["OpusApp", "XLMAIN", "PPTFrameClass"])

        ; Explorer group
        this.CreateGroup("Explorer", ["CabinetWClass", "ExploreWClass"])

        ; Dialog group
        this.CreateGroup("Dialogs", ["#32770"])

        TrayTip("Created predefined groups", "Window Groups", "Icon!")
    }
}

; Initialize predefined groups
WindowGroups.CreatePredefinedGroups()

; ========================================
; Example 5: Class-Based Automation Router
; ========================================

/**
 * @class AutomationRouter
 * @description Route automation actions based on window class
 */
class AutomationRouter {
    static routes := Map()

    /**
     * @method RegisterRoute
     * @description Register a class-specific automation
     * @param className Window class
     * @param hotkey Hotkey to trigger
     * @param action Function to execute
     */
    static RegisterRoute(className, hotkey, action) {
        if !this.routes.Has(hotkey) {
            this.routes[hotkey] := Map()

            ; Register the hotkey
            Hotkey(hotkey, (*) => this.RouteAction(hotkey))
        }

        this.routes[hotkey][className] := action
    }

    /**
     * @method RouteAction
     * @description Route action based on active window class
     * @param hotkey Triggered hotkey
     */
    static RouteAction(hotkey) {
        try {
            className := WinGetClass("A")

            if this.routes.Has(hotkey) && this.routes[hotkey].Has(className) {
                action := this.routes[hotkey][className]
                action()
            } else {
                TrayTip("No route defined for " className, "Automation Router", "Icon!")
            }
        }
    }
}

; Example routes
AutomationRouter.RegisterRoute("Notepad", "^!t", () => Send("Test text"))
AutomationRouter.RegisterRoute("Chrome_WidgetWin_1", "^!t", () => Send("^t"))  ; New tab

; ========================================
; Example 6: Dynamic Class Templates
; ========================================

/**
 * @class ClassTemplates
 * @description Create and apply templates based on window classes
 */
class ClassTemplates {
    static templates := Map()

    /**
     * @method CreateTemplate
     * @description Create a template for a window class
     * @param className Class name
     * @param settings Template settings
     */
    static CreateTemplate(className, settings) {
        this.templates[className] := settings
    }

    /**
     * @method ApplyTemplate
     * @description Apply template to matching windows
     * @param WinTitle Window identifier
     */
    static ApplyTemplate(WinTitle := "A") {
        try {
            className := WinGetClass(WinTitle)

            if !this.templates.Has(className) {
                MsgBox("No template for class: " className, "Info", "Icon!")
                return
            }

            template := this.templates[className]

            ; Apply position
            if template.HasOwnProp("Position") {
                WinMove(template.Position.X, template.Position.Y,
                    template.Position.Width, template.Position.Height, WinTitle)
            }

            ; Apply transparency
            if template.HasOwnProp("Transparency") {
                WinSetTransparent(template.Transparency, WinTitle)
            }

            ; Apply always on top
            if template.HasOwnProp("AlwaysOnTop") {
                WinSetAlwaysOnTop(template.AlwaysOnTop, WinTitle)
            }

            TrayTip("Template applied", "Class: " className, "Icon!")

        } catch as err {
            MsgBox("Template apply failed: " err.Message, "Error", "IconX")
        }
    }
}

; ========================================
; Script Initialization
; ========================================

if A_Args.Length = 0 && !A_IsCompiled {
    help := "
    (
    WinGetClass Advanced Examples - Hotkeys:

    Ctrl+Shift+W  - Watch for window class
    Ctrl+Shift+L  - Launch by class
    Ctrl+Shift+H  - Show class hierarchy
    )"

    TrayTip(help, "WinGetClass Advanced Ready", "Icon!")
}
