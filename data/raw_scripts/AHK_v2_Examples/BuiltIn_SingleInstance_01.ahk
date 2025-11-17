/**
 * ============================================================================
 * AutoHotkey v2 #SingleInstance Directive - Instance Control
 * ============================================================================
 *
 * @description Comprehensive examples demonstrating #SingleInstance directive
 *              for controlling multiple script instances in AutoHotkey v2
 *
 * @author AHK v2 Documentation Team
 * @version 2.0.0
 * @date 2025-01-15
 *
 * DIRECTIVE: #SingleInstance
 * PURPOSE: Control behavior when script is launched multiple times
 * OPTIONS:
 *   - Force: Automatically replace old instance
 *   - Ignore: Keep old instance, don't start new one
 *   - Prompt: Ask user what to do
 *   - Off: Allow multiple instances
 *
 * @reference https://www.autohotkey.com/docs/v2/lib/_SingleInstance.htm
 */

#Requires AutoHotkey v2.0
#SingleInstance Force  ; Demonstrate Force mode

/**
 * ============================================================================
 * Example 1: Force Mode - Automatic Replacement
 * ============================================================================
 *
 * @description Automatically replace old instance with new one
 * @concept Auto-replacement, seamless updates, no prompts
 */

/**
 * Instance manager for tracking script instances
 * @class
 */
class InstanceManager {
    static StartTime := A_Now
    static InstanceID := Random(10000, 99999)
    static ReloadCount := 0

    /**
     * Initialize instance tracking
     * @returns {void}
     */
    static Initialize() {
        ; Check if this is a reload
        if (FileExist(A_Temp "\AHK_Instance.txt")) {
            try {
                content := FileRead(A_Temp "\AHK_Instance.txt")
                this.ReloadCount := Integer(content) + 1
            }
        }

        ; Save current reload count
        try {
            FileDelete(A_Temp "\AHK_Instance.txt")
            FileAppend(this.ReloadCount, A_Temp "\AHK_Instance.txt")
        }

        ; Log instance start
        this.LogStart()
    }

    /**
     * Log instance start
     * @returns {void}
     */
    static LogStart() {
        log := "Instance started:`n"
        log .= "  ID: " this.InstanceID "`n"
        log .= "  Time: " FormatTime(this.StartTime, "yyyy-MM-dd HH:mm:ss") "`n"
        log .= "  Reload #: " this.ReloadCount "`n"
        log .= "  Mode: Force`n"

        OutputDebug(log)
    }

    /**
     * Get instance information
     * @returns {Object} Instance details
     */
    static GetInfo() {
        return {
            ID: this.InstanceID,
            StartTime: this.StartTime,
            ReloadCount: this.ReloadCount,
            Uptime: this.GetUptime(),
            Mode: "Force"
        }
    }

    /**
     * Get uptime in seconds
     * @returns {Integer} Uptime in seconds
     */
    static GetUptime() {
        start := FormatTime(this.StartTime, "yyyyMMddHHmmss")
        now := FormatTime(A_Now, "yyyyMMddHHmmss")
        return DateDiff(now, start, "Seconds")
    }

    /**
     * Display instance information
     * @returns {void}
     */
    static ShowInfo() {
        info := this.GetInfo()

        output := "Instance Information`n"
        output .= "====================`n`n"
        output .= "Instance ID: " info.ID "`n"
        output .= "Start Time: " FormatTime(info.StartTime, "yyyy-MM-dd HH:mm:ss") "`n"
        output .= "Uptime: " info.Uptime " seconds`n"
        output .= "Reload Count: " info.ReloadCount "`n"
        output .= "Mode: " info.Mode "`n`n"

        output .= "Script Info:`n"
        output .= "  Name: " A_ScriptName "`n"
        output .= "  Path: " A_ScriptDir "`n"
        output .= "  AHK Version: " A_AhkVersion

        MsgBox(output, "Instance Info", "Iconi")
    }
}

InstanceManager.Initialize()

^!i::InstanceManager.ShowInfo()

/**
 * ============================================================================
 * Example 2: Force Mode Benefits and Use Cases
 * ============================================================================
 *
 * @description Demonstrate when Force mode is beneficial
 * @concept Development workflow, testing, quick updates
 */

/**
 * Development helper for quick script updates
 * @class
 */
class DevHelper {
    /**
     * Quick reload with notification
     * @returns {void}
     */
    static QuickReload() {
        TrayTip("Reloading script...", "Force Mode", "Iconi Mute")

        ; Save state before reload if needed
        this.SaveState()

        ; Reload will replace old instance automatically
        Reload()
    }

    /**
     * Save state before reload
     * @returns {void}
     */
    static SaveState() {
        ; Example: Save window positions, settings, etc.
        state := Map(
            "ReloadTime", A_Now,
            "ActiveWindow", WinGetTitle("A")
        )

        ; In real application, save to file
        OutputDebug("State saved for reload")
    }

    /**
     * Restore state after reload
     * @returns {void}
     */
    static RestoreState() {
        ; Example: Restore saved state
        OutputDebug("State restored after reload")
    }

    /**
     * Display reload information
     * @returns {void}
     */
    static ShowReloadInfo() {
        output := "Force Mode Benefits`n"
        output .= "==================`n`n"

        output .= "✓ Automatic Replacement`n"
        output .= "  No prompts or dialogs`n`n"

        output .= "✓ Development Workflow`n"
        output .= "  Quick script updates`n"
        output .= "  No manual instance killing`n`n"

        output .= "✓ Seamless Updates`n"
        output .= "  Users don't see conflicts`n"
        output .= "  Clean restarts`n`n"

        output .= "Usage:`n"
        output .= "  #SingleInstance Force`n"
        output .= "  (at top of script)`n`n"

        output .= "Current Status:`n"
        output .= "  Reloads: " InstanceManager.ReloadCount "`n"
        output .= "  Press ^!r to reload"

        MsgBox(output, "Force Mode", "Iconi")
    }
}

; Quick reload hotkey
^!r::DevHelper.QuickReload()
^!f::DevHelper.ShowReloadInfo()

/**
 * ============================================================================
 * Example 3: Testing Force Mode Behavior
 * ============================================================================
 *
 * @description Test and demonstrate Force mode behavior
 * @concept Testing, verification, behavior demonstration
 */

/**
 * Force mode tester
 * @class
 */
class ForceModeTester {
    /**
     * Launch additional instance (will replace this one)
     * @returns {void}
     */
    static LaunchNewInstance() {
        currentID := InstanceManager.InstanceID

        MsgBox(
            "Current Instance ID: " currentID "`n`n"
            "Launching new instance...`n"
            "This instance will be automatically replaced!",
            "Force Mode Test",
            "Iconi 3"
        )

        ; Launch new instance
        Run('"' A_AhkPath '" "' A_ScriptFullPath '"')

        ; This instance will be terminated automatically
    }

    /**
     * Test script with modifications
     * @returns {void}
     */
    static TestWithModifications() {
        output := "Force Mode Testing`n"
        output .= "==================`n`n"

        output .= "Test Procedure:`n"
        output .= "1. Note current Instance ID: " InstanceManager.InstanceID "`n"
        output .= "2. Modify this script (add a comment)`n"
        output .= "3. Save the file`n"
        output .= "4. Run the script again`n"
        output .= "5. Old instance will be replaced`n"
        output .= "6. New instance will have different ID`n`n"

        output .= "Or press ^!r to reload immediately"

        MsgBox(output, "Testing", "Iconi")
    }

    /**
     * Display comparison with other modes
     * @returns {void}
     */
    static CompareWithOtherModes() {
        output := "#SingleInstance Mode Comparison`n"
        output .= "================================`n`n"

        output .= "FORCE (current):`n"
        output .= "  ✓ Automatically replaces old instance`n"
        output .= "  ✓ No user prompts`n"
        output .= "  ✓ Best for development`n"
        output .= "  ✗ Might lose unsaved state`n`n"

        output .= "IGNORE:`n"
        output .= "  ✓ Keeps old instance running`n"
        output .= "  ✓ Prevents accidental restarts`n"
        output .= "  ✗ New instance doesn't start`n`n"

        output .= "PROMPT:`n"
        output .= "  ✓ User decides what happens`n"
        output .= "  ✓ Safe for important scripts`n"
        output .= "  ✗ Requires user interaction`n`n"

        output .= "OFF:`n"
        output .= "  ✓ Multiple instances allowed`n"
        output .= "  ✗ Can cause conflicts`n"
        output .= "  ✗ Resource intensive"

        MsgBox(output, "Mode Comparison", "Iconi")
    }
}

^!+l::ForceModeTester.LaunchNewInstance()
^!+t::ForceModeTester.TestWithModifications()
^!+m::ForceModeTester.CompareWithOtherModes()

/**
 * ============================================================================
 * Example 4: State Preservation Across Reloads
 * ============================================================================
 *
 * @description Preserve script state across Force mode reloads
 * @concept State persistence, reload recovery, data preservation
 */

/**
 * State manager for reload persistence
 * @class
 */
class StateManager {
    static StateFile := A_Temp "\AHK_ScriptState.ini"
    static State := Map()

    /**
     * Save current state
     * @returns {void}
     */
    static Save() {
        try {
            ; Write state to INI file
            IniWrite(InstanceManager.InstanceID, this.StateFile, "Instance", "LastID")
            IniWrite(A_Now, this.StateFile, "Instance", "LastSave")
            IniWrite(InstanceManager.ReloadCount, this.StateFile, "Instance", "ReloadCount")

            ; Save custom state variables
            for key, value in this.State {
                IniWrite(value, this.StateFile, "CustomState", key)
            }

            OutputDebug("State saved successfully")
            return true
        } catch Error as err {
            OutputDebug("State save failed: " err.Message)
            return false
        }
    }

    /**
     * Load previous state
     * @returns {Boolean} True if loaded successfully
     */
    static Load() {
        if (!FileExist(this.StateFile))
            return false

        try {
            lastID := IniRead(this.StateFile, "Instance", "LastID", "")
            lastSave := IniRead(this.StateFile, "Instance", "LastSave", "")

            if (lastID != "" && lastSave != "") {
                OutputDebug("Previous instance ID: " lastID)
                OutputDebug("Last save: " lastSave)
                return true
            }
        } catch Error as err {
            OutputDebug("State load failed: " err.Message)
        }

        return false
    }

    /**
     * Set state value
     * @param {String} key - State key
     * @param {Any} value - State value
     * @returns {void}
     */
    static Set(key, value) {
        this.State[key] := value
        this.Save()
    }

    /**
     * Get state value
     * @param {String} key - State key
     * @param {Any} default - Default value
     * @returns {Any} State value
     */
    static Get(key, default := "") {
        if this.State.Has(key)
            return this.State[key]

        ; Try to load from file
        if FileExist(this.StateFile) {
            try {
                value := IniRead(this.StateFile, "CustomState", key, default)
                this.State[key] := value
                return value
            }
        }

        return default
    }

    /**
     * Display state information
     * @returns {void}
     */
    static ShowState() {
        output := "Persistent State`n"
        output .= "================`n`n"

        if FileExist(this.StateFile) {
            output .= "State File: Exists`n"

            try {
                lastID := IniRead(this.StateFile, "Instance", "LastID", "N/A")
                lastSave := IniRead(this.StateFile, "Instance", "LastSave", "N/A")

                output .= "Previous ID: " lastID "`n"
                output .= "Last Save: " FormatTime(lastSave, "yyyy-MM-dd HH:mm:ss") "`n`n"
            }
        } else {
            output .= "State File: Not found`n`n"
        }

        if (this.State.Count > 0) {
            output .= "Custom State:`n"
            for key, value in this.State {
                output .= "  " key ": " value "`n"
            }
        } else {
            output .= "No custom state saved"
        }

        MsgBox(output, "State", "Iconi")
    }

    /**
     * Clear all state
     * @returns {void}
     */
    static Clear() {
        this.State.Clear()
        if FileExist(this.StateFile) {
            try {
                FileDelete(this.StateFile)
                TrayTip("State cleared", "State Manager", "Iconi Mute")
            }
        }
    }
}

; Load state on startup
StateManager.Load()

; Save state before exit
OnExit((*) => StateManager.Save())

; Test state persistence
^!+s::StateManager.ShowState()
^!+c::StateManager.Clear()

; Example: Set custom state
^!+1::StateManager.Set("TestValue", "Hello from state!")
^!+2::MsgBox(StateManager.Get("TestValue", "No value set"), "State Value", "Iconi")

/**
 * ============================================================================
 * Example 5: Development Mode Features
 * ============================================================================
 *
 * @description Special features useful during development with Force mode
 * @concept Development tools, debugging aids, productivity
 */

/**
 * Development mode utilities
 * @class
 */
class DevMode {
    static Enabled := true
    static LogFile := A_ScriptDir "\dev.log"

    /**
     * Log development message
     * @param {String} message - Message to log
     * @returns {void}
     */
    static Log(message) {
        if (!this.Enabled)
            return

        timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        logEntry := timestamp " [" InstanceManager.InstanceID "] " message "`n"

        try {
            FileAppend(logEntry, this.LogFile)
        }

        OutputDebug(logEntry)
    }

    /**
     * Log script reload
     * @returns {void}
     */
    static LogReload() {
        this.Log("Script reloaded (count: " InstanceManager.ReloadCount ")")
    }

    /**
     * Display recent log entries
     * @param {Integer} lines - Number of lines to show
     * @returns {void}
     */
    static ShowLog(lines := 20) {
        if (!FileExist(this.LogFile)) {
            MsgBox("No log file exists yet", "Dev Log", "Iconi")
            return
        }

        try {
            content := FileRead(this.LogFile)
            logLines := StrSplit(content, "`n")

            ; Get last N lines
            startLine := Max(1, logLines.Length - lines + 1)
            recentLines := []

            Loop (logLines.Length - startLine + 1) {
                line := logLines[startLine + A_Index - 1]
                if (line != "")
                    recentLines.Push(line)
            }

            output := "Recent Log Entries (last " recentLines.Length ")`n"
            output .= "====================================`n`n"

            for line in recentLines
                output .= line "`n"

            MsgBox(output, "Dev Log", "Iconi")
        }
    }

    /**
     * Clear log file
     * @returns {void}
     */
    static ClearLog() {
        if FileExist(this.LogFile) {
            try {
                FileDelete(this.LogFile)
                TrayTip("Log file cleared", "Dev Mode", "Iconi Mute")
            }
        }
    }
}

; Log reload events
DevMode.LogReload()

^!+log::DevMode.ShowLog()
^!+clear::DevMode.ClearLog()

/**
 * ============================================================================
 * Example 6: Auto-Reload on File Change
 * ============================================================================
 *
 * @description Automatically reload script when file changes
 * @concept Auto-reload, file monitoring, development automation
 */

/**
 * File change monitor for auto-reload
 * @class
 */
class FileMonitor {
    static Enabled := false
    static LastModified := 0
    static CheckInterval := 1000

    /**
     * Enable file monitoring
     * @returns {void}
     */
    static Enable() {
        this.Enabled := true
        this.LastModified := FileGetTime(A_ScriptFullPath, "M")

        SetTimer(() => this.CheckForChanges(), this.CheckInterval)
        TrayTip("Auto-reload enabled", "File Monitor", "Iconi Mute")
    }

    /**
     * Disable file monitoring
     * @returns {void}
     */
    static Disable() {
        this.Enabled := false
        SetTimer(() => this.CheckForChanges(), 0)
        TrayTip("Auto-reload disabled", "File Monitor", "Iconi Mute")
    }

    /**
     * Check for file changes
     * @returns {void}
     */
    static CheckForChanges() {
        if (!this.Enabled)
            return

        try {
            currentModified := FileGetTime(A_ScriptFullPath, "M")

            if (currentModified != this.LastModified) {
                this.LastModified := currentModified
                DevMode.Log("File changed - auto-reloading...")

                TrayTip("File changed - reloading...", "Auto-Reload", "Iconi Mute")
                Sleep(500)  ; Brief delay to ensure file is fully written
                Reload()
            }
        }
    }

    /**
     * Toggle monitoring
     * @returns {void}
     */
    static Toggle() {
        if this.Enabled
            this.Disable()
        else
            this.Enable()
    }

    /**
     * Display monitor status
     * @returns {void}
     */
    static ShowStatus() {
        output := "File Monitor Status`n"
        output .= "===================`n`n"

        output .= "Status: " (this.Enabled ? "Enabled" : "Disabled") "`n"
        output .= "Check Interval: " this.CheckInterval "ms`n"
        output .= "Script File: " A_ScriptName "`n"

        if (this.LastModified != 0)
            output .= "Last Modified: " FormatTime(this.LastModified, "yyyy-MM-dd HH:mm:ss") "`n"

        output .= "`nPress ^!+auto to toggle"

        MsgBox(output, "File Monitor", "Iconi")
    }
}

^!+auto::FileMonitor.Toggle()
^!+mon::FileMonitor.ShowStatus()

/**
 * ============================================================================
 * Example 7: Force Mode Best Practices
 * ============================================================================
 *
 * @description Best practices for using Force mode effectively
 * @concept Best practices, guidelines, recommendations
 */

/**
 * Best practices guide
 * @class
 */
class BestPractices {
    /**
     * Display best practices
     * @returns {void}
     */
    static ShowGuide() {
        guide := "Force Mode Best Practices`n"
        guide .= "=========================`n`n"

        guide .= "✓ DO:`n"
        guide .= "  • Use for development scripts`n"
        guide .= "  • Save state before reload`n"
        guide .= "  • Log reload events`n"
        guide .= "  • Test reload behavior`n"
        guide .= "  • Document reload requirements`n`n"

        guide .= "✗ DON'T:`n"
        guide .= "  • Use for scripts with critical state`n"
        guide .= "  • Forget to save user data`n"
        guide .= "  • Ignore reload side effects`n"
        guide .= "  • Use with long-running tasks`n`n"

        guide .= "When to Use Force:`n"
        guide .= "  • Development & testing`n"
        guide .= "  • Stateless scripts`n"
        guide .= "  • Quick-reload scenarios`n"
        guide .= "  • Single-user environments`n`n"

        guide .= "When to Use Other Modes:`n"
        guide .= "  • Production scripts (Ignore/Prompt)`n"
        guide .= "  • Multi-user systems (Ignore)`n"
        guide .= "  • Critical applications (Prompt)`n"
        guide .= "  • Independent instances (Off)"

        MsgBox(guide, "Best Practices", "Iconi")
    }
}

^!+help::BestPractices.ShowGuide()

/**
 * ============================================================================
 * STARTUP
 * ============================================================================
 */

TrayTip(
    "Instance: " InstanceManager.InstanceID "`n"
    "Mode: Force`n"
    "Reload: " InstanceManager.ReloadCount,
    "Script Started",
    "Iconi Mute"
)

/**
 * Help
 */
^!h::{
    help := "Force Mode Examples`n"
    help .= "===================`n`n"

    help .= "Instance Info:`n"
    help .= "^!i - Instance info`n"
    help .= "^!+s - State info`n`n"

    help .= "Reload:`n"
    help .= "^!r - Quick reload`n"
    help .= "^!+auto - Toggle auto-reload`n`n"

    help .= "Testing:`n"
    help .= "^!+l - Launch new instance`n"
    help .= "^!+t - Test instructions`n"
    help .= "^!+m - Mode comparison`n`n"

    help .= "Development:`n"
    help .= "^!+log - Show dev log`n"
    help .= "^!+mon - Monitor status`n`n"

    help .= "^!+help - Best practices`n"
    help .= "^!h - Show help"

    MsgBox(help, "Help", "Iconi")
}
