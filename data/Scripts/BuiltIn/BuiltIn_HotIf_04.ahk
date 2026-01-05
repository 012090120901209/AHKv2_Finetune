#Requires AutoHotkey v2.0
/**
#SingleInstance Force
 * ============================================================================
 * AutoHotkey v2 #HotIf Directive - Dynamic Contexts
 * ============================================================================
 * 
 * @description Comprehensive examples demonstrating dynamic context
 *              switching and runtime context management with #HotIf
 * 
 * @author AHK v2 Documentation Team
 * @version 2.0.0
 * @date 2025-01-15
 * 
 * DIRECTIVE: #HotIf with dynamic contexts
 * PURPOSE: Create hotkeys that adapt to changing runtime conditions
 * CONCEPTS:
 *   - Runtime context evaluation
 *   - Dynamic condition updates
 *   - Context state management
 *   - Adaptive hotkey behavior
 * 
 * @reference https://www.autohotkey.com/docs/v2/lib/_HotIf.htm
 */

#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Example 1: Dynamic Window Context Tracking
 * ============================================================================
 * 
 * @description Track and respond to changing window contexts
 * @concept Window tracking, context awareness, dynamic adaptation
 */

/**
 * Window context tracker
 * @class
 */
class WindowTracker {
    static PreviousWindow := ""
    static CurrentWindow := ""
    static WindowHistory := []
    static MaxHistory := 10

    /**
     * Update current window context
     * @returns {void}
     */
    static Update() {
        title := WinGetTitle("A")
        if (title != this.CurrentWindow) {
            this.PreviousWindow := this.CurrentWindow
            this.CurrentWindow := title

            ; Add to history
            this.WindowHistory.Push({
                Title: title,
                Time: A_Now,
                Process: WinGetProcessName("A")
            })

            ; Limit history size
            if (this.WindowHistory.Length > this.MaxHistory)
                this.WindowHistory.RemoveAt(1)
        }
    }

    /**
     * Check if window changed recently
     * @param {Integer} seconds - Time window in seconds
     * @returns {Boolean} True if window changed within time window
     */
    static ChangedRecently(seconds := 5) {
        if (this.WindowHistory.Length < 2)
            return false

        latest := this.WindowHistory[-1]
        timeDiff := DateDiff(A_Now, latest.Time, "Seconds")
        return (timeDiff <= seconds)
    }

    /**
     * Get window by position in history
     * @param {Integer} index - History index (negative for recent)
     * @returns {Object|Boolean} Window info or false
     */
    static GetFromHistory(index) {
        if (Abs(index) > this.WindowHistory.Length)
            return false

        if (index < 0)
            index := this.WindowHistory.Length + index + 1

        return this.WindowHistory[index]
    }

    /**
     * Display window history
     * @returns {void}
     */
    static ShowHistory() {
        output := "Window History`n"
        output .= "==============`n`n"

        output .= "Current: " this.CurrentWindow "`n"
        output .= "Previous: " this.PreviousWindow "`n`n"

        output .= "Recent Windows:`n"
        for win in this.WindowHistory {
            output .= "• " win.Title "`n"
            output .= "  " FormatTime(win.Time, "HH:mm:ss") " - " win.Process "`n`n"
        }

        MsgBox(output, "Window History", "Iconi")
    }
}

; Update window context periodically
SetTimer(() => WindowTracker.Update(), 500)

; Hotkey active when window changed recently
#HotIf WindowTracker.ChangedRecently()

^!w:: MsgBox("Window changed recently!", "Dynamic", "Iconi")
#HotIf

^!h:: WindowTracker.ShowHistory()

/**
 * ============================================================================
 * Example 2: Workspace State Management
 * ============================================================================
 * 
 * @description Manage complex workspace states dynamically
 * @concept Workspace management, state transitions, profile switching
 */

/**
 * Workspace manager for context-aware hotkeys
 * @class
 */
class WorkspaceManager {
    static CurrentWorkspace := "default"
    static Workspaces := Map()

    /**
     * Initialize workspaces
     * @returns {void}
     */
    static Initialize() {
        ; Define workspaces
        this.Workspaces := Map(
            "default", {
                Name: "Default",
                Color: "Gray",
                Hotkeys: Map()
            },
            "coding", {
                Name: "Coding",
                Color: "Blue",
                WindowPatterns: ["ahk_exe Code.exe", "ahk_exe sublime_text.exe"]
            },
            "browsing", {
                Name: "Web Browsing",
                Color: "Green",
                WindowPatterns: ["ahk_exe chrome.exe", "ahk_exe firefox.exe"]
            },
            "writing", {
                Name: "Writing",
                Color: "Yellow",
                WindowPatterns: ["ahk_exe WINWORD.EXE", "ahk_class Notepad"]
            }
        )
    }

    /**
     * Auto-detect workspace based on active window
     * @returns {String} Detected workspace name
     */
    static DetectWorkspace() {
        process := WinGetProcessName("A")

        for name, workspace in this.Workspaces {
            if workspace.HasOwnProp("WindowPatterns") {
                for pattern in workspace.WindowPatterns {
                    if WinActive(pattern)
                        return name
                }
            }
        }

        return "default"
    }

    /**
     * Switch to workspace
     * @param {String} name - Workspace name
     * @returns {Boolean} True if switched successfully
     */
    static SwitchTo(name) {
        if (!this.Workspaces.Has(name))
            return false

        this.CurrentWorkspace := name
        workspace := this.Workspaces[name]

        TrayTip("Workspace: " workspace.Name, "Switched", "Iconi Mute")
        return true
    }

    /**
     * Check if in specific workspace
     * @param {String} name - Workspace name
     * @returns {Boolean} True if in workspace
     */
    static IsWorkspace(name) {
        return (this.CurrentWorkspace = name)
    }

    /**
     * Auto-switch workspace based on window
     * @returns {void}
     */
    static AutoSwitch() {
        detected := this.DetectWorkspace()
        if (detected != this.CurrentWorkspace)
            this.SwitchTo(detected)
    }

    /**
     * Display workspace info
     * @returns {void}
     */
    static ShowInfo() {
        output := "Workspace Manager`n"
        output .= "=================`n`n"

        output .= "Current: " this.Workspaces[this.CurrentWorkspace].Name "`n`n"

        output .= "Available Workspaces:`n"
        for name, workspace in this.Workspaces {
            status := (name = this.CurrentWorkspace) ? "✓" : "○"
            output .= status " " workspace.Name

            if (workspace.HasOwnProp("Color"))
                output .= " (" workspace.Color ")"

            output .= "`n"
        }

        MsgBox(output, "Workspaces", "Iconi")
    }
}

WorkspaceManager.Initialize()

; Auto-switch workspace based on window
SetTimer(() => WorkspaceManager.AutoSwitch(), 1000)

; Workspace-specific hotkeys
#HotIf WorkspaceManager.IsWorkspace("coding")

^!c:: MsgBox("Coding workspace active", "Coding", "Iconi")
F5:: MsgBox("Run/Debug in coding workspace", "Coding", "Iconi")
#HotIf

#HotIf WorkspaceManager.IsWorkspace("browsing")

^!b:: MsgBox("Browsing workspace active", "Browsing", "Iconi")
^r:: MsgBox("Refresh in browsing workspace", "Browsing", "Iconi")
#HotIf

#HotIf WorkspaceManager.IsWorkspace("writing")

^!d:: SendText(FormatTime(, "yyyy-MM-dd"))  ; Insert date
^!t:: SendText(FormatTime(, "HH:mm"))  ; Insert time
#HotIf

; Manual workspace switching
^!1:: WorkspaceManager.SwitchTo("default")
^!2:: WorkspaceManager.SwitchTo("coding")
^!3:: WorkspaceManager.SwitchTo("browsing")
^!4:: WorkspaceManager.SwitchTo("writing")

^!w:: WorkspaceManager.ShowInfo()

/**
 * ============================================================================
 * Example 3: Activity-Based Context Switching
 * ============================================================================
 * 
 * @description Switch contexts based on user activity patterns
 * @concept Activity tracking, behavior analysis, smart context
 */

/**
 * Activity tracker for intelligent context switching
 * @class
 */
class ActivityTracker {
    static KeypressCount := 0
    static MouseMoveCount := 0
    static LastActivity := A_TickCount
    static IsIdle := false
    static IdleThreshold := 60000  ; 1 minute

    /**
     * Record keypress activity
     * @returns {void}
     */
    static RecordKeypress() {
        this.KeypressCount++
        this.LastActivity := A_TickCount
        this.IsIdle := false
    }

    /**
     * Record mouse activity
     * @returns {void}
     */
    static RecordMouseMove() {
        this.MouseMoveCount++
        this.LastActivity := A_TickCount
        this.IsIdle := false
    }

    /**
     * Check if user is idle
     * @returns {Boolean} True if idle
     */
    static CheckIdle() {
        idleTime := A_TickCount - this.LastActivity
        this.IsIdle := (idleTime > this.IdleThreshold)
        return this.IsIdle
    }

    /**
     * Get activity level (0-100)
     * @returns {Integer} Activity percentage
     */
    static GetActivityLevel() {
        ; Calculate based on recent activity
        ; This is simplified - real implementation would track over time
        static LastCheck := A_TickCount
        static LastKeyCount := 0
        static LastMouseCount := 0

        timeDiff := (A_TickCount - LastCheck) / 1000  ; seconds
        if (timeDiff < 1)
            return 0

        keyRate := (this.KeypressCount - LastKeyCount) / timeDiff
        mouseRate := (this.MouseMoveCount - LastMouseCount) / timeDiff

        LastCheck := A_TickCount
        LastKeyCount := this.KeypressCount
        LastMouseCount := this.MouseMoveCount

        ; Normalize to 0-100
        activity := Min(100, (keyRate * 10) + (mouseRate / 10))
        return Integer(activity)
    }

    /**
     * Check if user is actively typing
     * @returns {Boolean} True if typing actively
     */
    static IsTyping() {
        static LastCheck := A_TickCount
        static LastCount := 0

        timeDiff := (A_TickCount - LastCheck) / 1000
        if (timeDiff < 1)
            return false

        rate := (this.KeypressCount - LastCount) / timeDiff
        LastCheck := A_TickCount
        LastCount := this.KeypressCount

        return (rate > 1)  ; More than 1 key per second
    }

    /**
     * Display activity stats
     * @returns {void}
     */
    static ShowStats() {
        output := "Activity Statistics`n"
        output .= "===================`n`n"

        output .= "Keypresses: " this.KeypressCount "`n"
        output .= "Mouse Moves: " this.MouseMoveCount "`n"
        output .= "Idle: " (this.IsIdle ? "Yes" : "No") "`n"
        output .= "Idle Time: " Integer((A_TickCount - this.LastActivity) / 1000) "s`n"
        output .= "Activity Level: " this.GetActivityLevel() "%`n"
        output .= "Typing: " (this.IsTyping() ? "Yes" : "No")

        MsgBox(output, "Activity", "Iconi")
    }
}

; Track activity
SetTimer(() => ActivityTracker.CheckIdle(), 5000)

; Hotkeys based on activity
#HotIf !ActivityTracker.IsIdle

^!a:: MsgBox("User is active", "Activity", "Iconi")
#HotIf

#HotIf ActivityTracker.IsTyping()

^!+t:: MsgBox("User is typing", "Typing", "Iconi")
#HotIf

^!+a:: ActivityTracker.ShowStats()

/**
 * ============================================================================
 * Example 4: Clipboard-Based Context
 * ============================================================================
 * 
 * @description Dynamic contexts based on clipboard content
 * @concept Clipboard awareness, content-based activation
 */

/**
 * Clipboard context manager
 * @class
 */
class ClipboardContext {
    static CurrentType := "empty"
    static CurrentContent := ""

    /**
     * Analyze clipboard content
     * @returns {String} Content type
     */
    static AnalyzeClipboard() {
        content := A_Clipboard

        if (content = "") {
            this.CurrentType := "empty"
        } else if RegExMatch(content, "i)^https?://") {
            this.CurrentType := "url"
        } else if RegExMatch(content, "^\d+$") {
            this.CurrentType := "number"
        } else if RegExMatch(content, "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$") {
            this.CurrentType := "email"
        } else if RegExMatch(content, "^[A-Z]:\\") {
            this.CurrentType := "filepath"
        } else if (StrLen(content) > 100) {
            this.CurrentType := "longtext"
        } else {
            this.CurrentType := "text"
        }

        this.CurrentContent := content
        return this.CurrentType
    }

    /**
     * Check if clipboard contains specific type
     * @param {String} type - Type to check
     * @returns {Boolean} True if matches
     */
    static IsType(type) {
        this.AnalyzeClipboard()
        return (this.CurrentType = type)
    }

    /**
     * Display clipboard info
     * @returns {void}
     */
    static ShowInfo() {
        this.AnalyzeClipboard()

        output := "Clipboard Context`n"
        output .= "=================`n`n"

        output .= "Type: " this.CurrentType "`n"
        output .= "Length: " StrLen(this.CurrentContent) " chars`n`n"

        if (StrLen(this.CurrentContent) > 0) {
            preview := StrLen(this.CurrentContent) > 100
                ? SubStr(this.CurrentContent, 1, 100) "..."
                : this.CurrentContent

            output .= "Preview:`n" preview
        }

        MsgBox(output, "Clipboard", "Iconi")
    }
}

; Monitor clipboard changes
OnClipboardChange(ClipChanged)
ClipChanged(Type) {
    if (Type = 1)  ; Text
        ClipboardContext.AnalyzeClipboard()
}

; Clipboard-type-specific hotkeys
#HotIf ClipboardContext.IsType("url")

^!v:: MsgBox("Paste URL: " A_Clipboard, "URL", "Iconi")
#HotIf

#HotIf ClipboardContext.IsType("email")

^!v:: MsgBox("Email address: " A_Clipboard, "Email", "Iconi")
#HotIf

#HotIf ClipboardContext.IsType("filepath")

^!v:: MsgBox("File path: " A_Clipboard, "Path", "Iconi")
#HotIf

^!+c:: ClipboardContext.ShowInfo()

/**
 * ============================================================================
 * Example 5: Time-Based Dynamic Contexts
 * ============================================================================
 * 
 * @description Contexts that change based on time of day
 * @concept Time-based switching, schedule management, temporal contexts
 */

/**
 * Time-based context scheduler
 * @class
 */
class TimeScheduler {
    static Schedule := Map()
    static CurrentContext := "default"

    /**
     * Add scheduled context
     * @param {String} name - Context name
     * @param {Integer} startHour - Start hour (0-23)
     * @param {Integer} endHour - End hour (0-23)
     * @returns {void}
     */
    static AddSchedule(name, startHour, endHour) {
        this.Schedule[name] := {
            StartHour: startHour,
            EndHour: endHour
        }
    }

    /**
     * Get current scheduled context
     * @returns {String} Context name
     */
    static GetCurrentContext() {
        hour := Integer(FormatTime(, "H"))

        for name, schedule in this.Schedule {
            if (hour >= schedule.StartHour && hour < schedule.EndHour)
                return name
        }

        return "default"
    }

    /**
     * Update current context
     * @returns {void}
     */
    static Update() {
        newContext := this.GetCurrentContext()
        if (newContext != this.CurrentContext) {
            this.CurrentContext := newContext
            TrayTip("Context: " newContext, "Schedule", "Iconi Mute")
        }
    }

    /**
     * Check if in specific context
     * @param {String} name - Context name
     * @returns {Boolean} True if in context
     */
    static IsContext(name) {
        this.Update()
        return (this.CurrentContext = name)
    }

    /**
     * Display schedule
     * @returns {void}
     */
    static ShowSchedule() {
        output := "Time-Based Schedule`n"
        output .= "===================`n`n"

        output .= "Current: " this.CurrentContext "`n"
        output .= "Time: " FormatTime(, "HH:mm") "`n`n"

        output .= "Scheduled Contexts:`n"
        for name, schedule in this.Schedule {
            output .= "• " name ": "
            output .= schedule.StartHour ":00 - " schedule.EndHour ":00`n"
        }

        MsgBox(output, "Schedule", "Iconi")
    }
}

; Define schedule
TimeScheduler.AddSchedule("morning", 6, 12)
TimeScheduler.AddSchedule("afternoon", 12, 18)
TimeScheduler.AddSchedule("evening", 18, 22)
TimeScheduler.AddSchedule("night", 22, 6)

; Update context every minute
SetTimer(() => TimeScheduler.Update(), 60000)

; Time-based hotkeys
#HotIf TimeScheduler.IsContext("morning")

^!g:: MsgBox("Good morning!", "Morning", "Iconi")
#HotIf

#HotIf TimeScheduler.IsContext("evening")

^!g:: MsgBox("Good evening!", "Evening", "Iconi")
#HotIf

^!+s:: TimeScheduler.ShowSchedule()

/**
 * ============================================================================
 * Example 6: Multi-Monitor Context
 * ============================================================================
 * 
 * @description Contexts based on monitor configuration
 * @concept Multi-monitor, screen awareness, display contexts
 */

/**
 * Monitor context manager
 * @class
 */
class MonitorContext {
    /**
     * Get monitor count
     * @returns {Integer} Number of monitors
     */
    static GetMonitorCount() {
        return SysGet(80)  ; SM_CMONITORS
    }

    /**
     * Get current monitor for active window
     * @returns {Integer} Monitor number
     */
    static GetCurrentMonitor() {
        WinGetPos(&x, &y, &w, &h, "A")
        centerX := x + (w / 2)
        centerY := y + (h / 2)

        count := this.GetMonitorCount()
        Loop count {
            MonitorGet(A_Index, &left, &top, &right, &bottom)
            if (centerX >= left && centerX <= right
                && centerY >= top && centerY <= bottom)
                return A_Index
        }

        return 1
    }

    /**
     * Check if on specific monitor
     * @param {Integer} monitor - Monitor number
     * @returns {Boolean} True if on monitor
     */
    static IsMonitor(monitor) {
        return (this.GetCurrentMonitor() = monitor)
    }

    /**
     * Check if multi-monitor setup
     * @returns {Boolean} True if multiple monitors
     */
    static IsMultiMonitor() {
        return (this.GetMonitorCount() > 1)
    }

    /**
     * Display monitor info
     * @returns {void}
     */
    static ShowInfo() {
        output := "Monitor Information`n"
        output .= "===================`n`n"

        count := this.GetMonitorCount()
        current := this.GetCurrentMonitor()

        output .= "Monitors: " count "`n"
        output .= "Current: " current "`n`n"

        Loop count {
            MonitorGet(A_Index, &left, &top, &right, &bottom)
            MonitorGetWorkArea(A_Index, &wLeft, &wTop, &wRight, &wBottom)

            output .= "Monitor " A_Index
            if (A_Index = current)
                output .= " (active)"
            output .= ":`n"
            output .= "  Position: " left "," top " to " right "," bottom "`n"
            output .= "  Size: " (right - left) "x" (bottom - top) "`n`n"
        }

        MsgBox(output, "Monitors", "Iconi")
    }
}

; Multi-monitor hotkeys
#HotIf MonitorContext.IsMultiMonitor() && MonitorContext.IsMonitor(1)

^!+1:: MsgBox("On primary monitor", "Monitor 1", "Iconi")
#HotIf

#HotIf MonitorContext.IsMultiMonitor() && MonitorContext.IsMonitor(2)

^!+2:: MsgBox("On secondary monitor", "Monitor 2", "Iconi")
#HotIf

^!+m:: MonitorContext.ShowInfo()

/**
 * ============================================================================
 * Example 7: Master Context Controller
 * ============================================================================
 * 
 * @description Central controller for all dynamic contexts
 * @concept Context orchestration, unified management
 */

/**
 * Master context controller
 * @class
 */
class ContextController {
    static Contexts := Map()
    static UpdateInterval := 1000

    /**
     * Register a context
     * @param {String} name - Context name
     * @param {Func} checker - Checker function
     * @param {Integer} priority - Priority (higher = more important)
     * @returns {void}
     */
    static Register(name, checker, priority := 0) {
        this.Contexts[name] := {
            Name: name,
            Checker: checker,
            Priority: priority,
            Active: false
        }
    }

    /**
     * Update all contexts
     * @returns {void}
     */
    static UpdateAll() {
        for name, context in this.Contexts {
            context.Active := context.Checker.Call()
        }
    }

    /**
     * Get active contexts sorted by priority
     * @returns {Array} Active context names
     */
    static GetActiveContexts() {
        active := []

        for name, context in this.Contexts {
            if context.Active
                active.Push(context)
        }

        ; Sort by priority
        active := this.SortByPriority(active)

        names := []
        for context in active
            names.Push(context.Name)

        return names
    }

    /**
     * Sort contexts by priority
     * @private
     */
    static SortByPriority(contexts) {
        ; Simple bubble sort
        n := contexts.Length
        Loop n - 1 {
            i := A_Index
            Loop n - i {
                j := A_Index
                if (contexts[j].Priority < contexts[j + 1].Priority) {
                    temp := contexts[j]
                    contexts[j] := contexts[j + 1]
                    contexts[j + 1] := temp
                }
            }
        }
        return contexts
    }

    /**
     * Display context status
     * @returns {void}
     */
    static ShowStatus() {
        output := "Context Controller Status`n"
        output .= "=========================`n`n"

        output .= "Active Contexts:`n"
        active := this.GetActiveContexts()
        for name in active {
            context := this.Contexts[name]
            output .= "  ✓ " name " (priority: " context.Priority ")`n"
        }

        output .= "`nInactive Contexts:`n"
        for name, context in this.Contexts {
            if !context.Active
                output .= "  ○ " name "`n"
        }

        MsgBox(output, "Context Status", "Iconi")
    }
}

; Register all contexts with priorities
ContextController.Register("Idle", () => ActivityTracker.CheckIdle(), 1)
ContextController.Register("Typing", () => ActivityTracker.IsTyping(), 3)
ContextController.Register("Coding", () => WorkspaceManager.IsWorkspace("coding"), 5)
ContextController.Register("MultiMonitor", () => MonitorContext.IsMultiMonitor(), 2)

; Update all contexts periodically
SetTimer(() => ContextController.UpdateAll(), 1000)

^!+ctrl:: ContextController.ShowStatus()

/**
 * ============================================================================
 * STARTUP AND HELP
 * ============================================================================
 */

TrayTip("Dynamic contexts loaded", "Script Ready", "Iconi Mute")

/**
 * Help
 */
^!help:: {
    help := "Dynamic Context Examples`n"
    help .= "========================`n`n"

    help .= "Workspace Switching:`n"
    help .= "^!1-4 - Switch workspace`n"
    help .= "^!w - Workspace info`n`n"

    help .= "Information:`n"
    help .= "^!h - Window history`n"
    help .= "^!+a - Activity stats`n"
    help .= "^!+c - Clipboard info`n"
    help .= "^!+s - Time schedule`n"
    help .= "^!+m - Monitor info`n"
    help .= "^!+ctrl - Context status`n`n"

    help .= "Current State:`n"
    help .= "Workspace: " WorkspaceManager.CurrentWorkspace "`n"
    help .= "Time Context: " TimeScheduler.CurrentContext "`n"
    help .= "Monitor: " MonitorContext.GetCurrentMonitor()

    MsgBox(help, "Help", "Iconi")
}
