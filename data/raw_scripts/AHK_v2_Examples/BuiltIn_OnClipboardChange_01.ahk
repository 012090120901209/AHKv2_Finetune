#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 - OnClipboardChange: Clipboard Monitoring
 * ============================================================================
 *
 * This file demonstrates using OnClipboardChange to monitor and respond to
 * clipboard changes in real-time, including building clipboard monitors
 * and basic clipboard history.
 *
 * OnClipboardChange is a callback function that runs automatically whenever
 * the clipboard content changes.
 *
 * @file BuiltIn_OnClipboardChange_01.ahk
 * @version 2.0.0
 * @author AHK v2 Examples Collection
 * @date 2024-11-16
 *
 * TABLE OF CONTENTS:
 * ──────────────────────────────────────────────────────────────────────────
 * 1. Basic OnClipboardChange Usage
 * 2. Clipboard Change Logging
 * 3. Real-time Clipboard Monitor
 * 4. Clipboard Change Filtering
 * 5. Basic Clipboard History
 * 6. Clipboard Change Notifications
 * 7. Advanced Clipboard Watcher
 *
 * EXAMPLES SUMMARY:
 * ──────────────────────────────────────────────────────────────────────────
 * - Setting up clipboard change callbacks
 * - Logging clipboard changes
 * - Monitoring clipboard in real-time
 * - Filtering specific clipboard changes
 * - Building basic clipboard history
 * - Creating change notifications
 * - Advanced clipboard watching
 *
 * ============================================================================
 */

; ============================================================================
; Example 1: Basic OnClipboardChange Usage
; ============================================================================

/**
 * Demonstrates basic OnClipboardChange setup and usage.
 *
 * @class BasicClipboardMonitor
 * @description Basic clipboard change monitoring
 */

class BasicClipboardMonitor {
    static enabled := false
    static changeCount := 0

    /**
     * Enables clipboard monitoring
     * @returns {void}
     */
    static Enable() {
        if (this.enabled)
            return

        OnClipboardChange(ClipChanged)
        this.enabled := true
        this.changeCount := 0
        TrayTip("Monitor Enabled", "Clipboard changes will be monitored", "Icon Info")
    }

    /**
     * Disables clipboard monitoring
     * @returns {void}
     */
    static Disable() {
        if (!this.enabled)
            return

        OnClipboardChange(ClipChanged, 0)
        this.enabled := false
        TrayTip("Monitor Disabled",
                "Stopped monitoring. Total changes: " . this.changeCount,
                "Icon Info")
    }

    /**
     * Toggles clipboard monitoring
     * @returns {void}
     */
    static Toggle() {
        if (this.enabled)
            this.Disable()
        else
            this.Enable()
    }

    /**
     * Handles clipboard changes
     * @param {Integer} dataType - Type of data (0=empty, 1=text, 2=non-text)
     * @returns {void}
     */
    static OnChange(dataType) {
        this.changeCount++

        typeStr := ""
        switch dataType {
            case 0: typeStr := "Empty"
            case 1: typeStr := "Text"
            case 2: typeStr := "Non-text/Binary"
            default: typeStr := "Unknown"
        }

        TrayTip("Clipboard Changed #" . this.changeCount,
                "Type: " . typeStr,
                "Icon Info Mute")
    }
}

; Callback function for OnClipboardChange
ClipChanged(DataType) {
    BasicClipboardMonitor.OnChange(DataType)
}

; Toggle monitoring
F1::BasicClipboardMonitor.Toggle()

; ============================================================================
; Example 2: Clipboard Change Logging
; ============================================================================

/**
 * Demonstrates logging clipboard changes to file and memory.
 *
 * @class ClipboardLogger
 * @description Logs clipboard changes with details
 */

class ClipboardLogger {
    static log := []
    static maxLogSize := 100
    static logToFile := false
    static logFilePath := A_ScriptDir . "\clipboard_log.txt"

    /**
     * Logs a clipboard change
     * @param {Integer} dataType - Type of data
     * @returns {void}
     */
    static LogChange(dataType) {
        logEntry := Map()
        logEntry["timestamp"] := A_Now
        logEntry["dataType"] := dataType
        logEntry["typeStr"] := this.GetTypeString(dataType)

        if (dataType = 1) {  ; Text
            logEntry["content"] := A_Clipboard
            logEntry["length"] := StrLen(A_Clipboard)
        } else {
            logEntry["content"] := ""
            logEntry["length"] := 0
        }

        ; Add to memory log
        this.log.Push(logEntry)

        ; Limit log size
        if (this.log.Length > this.maxLogSize)
            this.log.RemoveAt(1)

        ; Log to file if enabled
        if (this.logToFile)
            this.WriteToFile(logEntry)
    }

    /**
     * Gets type string from data type
     * @param {Integer} dataType - Data type code
     * @returns {String}
     */
    static GetTypeString(dataType) {
        switch dataType {
            case 0: return "Empty"
            case 1: return "Text"
            case 2: return "Binary"
            default: return "Unknown"
        }
    }

    /**
     * Writes log entry to file
     * @param {Map} entry - Log entry
     * @returns {void}
     */
    static WriteToFile(entry) {
        timestamp := FormatTime(entry["timestamp"], "yyyy-MM-dd HH:mm:ss")
        logLine := timestamp . " | " . entry["typeStr"]

        if (entry["length"] > 0) {
            preview := StrLen(entry["content"]) > 50
                ? SubStr(entry["content"], 1, 50) . "..."
                : entry["content"]
            preview := StrReplace(preview, "`n", " ")
            logLine .= " | " . preview
        }

        logLine .= "`n"

        try {
            FileAppend(logLine, this.logFilePath)
        }
    }

    /**
     * Shows log GUI
     * @returns {void}
     */
    static ShowLog() {
        if (this.log.Length = 0) {
            MsgBox("No clipboard changes logged yet!", "Log", "Icon Info")
            return
        }

        gui := Gui("+Resize", "Clipboard Change Log")
        gui.SetFont("s9")

        lv := gui.Add("ListView", "w700 h400",
                      ["#", "Time", "Type", "Length", "Preview"])
        lv.ModifyCol(1, 40)
        lv.ModifyCol(2, 150)
        lv.ModifyCol(3, 80)
        lv.ModifyCol(4, 80)
        lv.ModifyCol(5, 330)

        ; Populate log (newest first)
        Loop this.log.Length {
            index := this.log.Length - A_Index + 1
            entry := this.log[index]

            timeStr := FormatTime(entry["timestamp"], "HH:mm:ss")
            preview := ""

            if (entry["length"] > 0) {
                preview := StrLen(entry["content"]) > 50
                    ? SubStr(entry["content"], 1, 50) . "..."
                    : entry["content"]
                preview := StrReplace(preview, "`n", " ")
            }

            lv.Add("", index, timeStr, entry["typeStr"], entry["length"], preview)
        }

        ; Buttons
        btnClear := gui.Add("Button", "w100", "Clear Log")
        btnClear.OnEvent("Click", (*) => this.ClearLog(gui))

        btnClose := gui.Add("Button", "x+10 w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }

    /**
     * Clears the log
     * @param {Object} gui - GUI to close
     * @returns {void}
     */
    static ClearLog(gui) {
        this.log := []
        gui.Destroy()
        MsgBox("Log cleared!", "Cleared", "Icon Info T2")
    }
}

; Setup logger callback
OnClipboardChange(LogClipChanged)

LogClipChanged(DataType) {
    ClipboardLogger.LogChange(DataType)
}

; Show clipboard log
F2::ClipboardLogger.ShowLog()

; Toggle file logging
^!f:: {
    ClipboardLogger.logToFile := !ClipboardLogger.logToFile
    status := ClipboardLogger.logToFile ? "Enabled" : "Disabled"
    MsgBox("File logging " . status . "`n`nLog file: " . ClipboardLogger.logFilePath,
           "File Logging", "Icon Info")
}

; ============================================================================
; Example 3: Real-time Clipboard Monitor
; ============================================================================

/**
 * Demonstrates real-time clipboard monitoring with live display.
 *
 * @class RealtimeMonitor
 * @description Real-time clipboard monitor with GUI
 */

class RealtimeMonitor {
    static monitorGui := ""
    static textCtrl := ""
    static statsCtrl := ""
    static changeCount := 0

    /**
     * Shows monitor window
     * @returns {void}
     */
    static ShowMonitor() {
        if (this.monitorGui) {
            this.monitorGui.Show()
            return
        }

        this.monitorGui := Gui("+Resize +AlwaysOnTop", "Real-time Clipboard Monitor")
        this.monitorGui.SetFont("s9")

        ; Statistics
        this.statsCtrl := this.monitorGui.Add("Text", "w500",
                                               "Changes: 0 | Type: - | Size: 0")

        ; Current clipboard content
        this.monitorGui.Add("Text", "w500", "Current Clipboard Content:")
        this.textCtrl := this.monitorGui.Add("Edit", "w500 h300 ReadOnly vContent")

        ; Control buttons
        btnClear := this.monitorGui.Add("Button", "w100", "Clear Stats")
        btnClear.OnEvent("Click", (*) => this.ClearStats())

        btnClose := this.monitorGui.Add("Button", "x+10 w100", "Close")
        btnClose.OnEvent("Click", (*) => this.monitorGui.Hide())

        ; Set up callback
        OnClipboardChange(MonitorChanged)

        this.monitorGui.Show()
        this.UpdateDisplay(1)  ; Show initial content
    }

    /**
     * Updates monitor display
     * @param {Integer} dataType - Data type
     * @returns {void}
     */
    static UpdateDisplay(dataType) {
        if (!this.monitorGui)
            return

        this.changeCount++

        ; Update statistics
        typeStr := ""
        switch dataType {
            case 0: typeStr := "Empty"
            case 1: typeStr := "Text"
            case 2: typeStr := "Binary"
        }

        size := StrLen(A_Clipboard)
        this.statsCtrl.Value := "Changes: " . this.changeCount
                              . " | Type: " . typeStr
                              . " | Size: " . size . " chars"

        ; Update content
        if (dataType = 1) {
            this.textCtrl.Value := A_Clipboard
        } else if (dataType = 2) {
            this.textCtrl.Value := "[Binary/Image Data]"
        } else {
            this.textCtrl.Value := "[Empty]"
        }
    }

    /**
     * Clears statistics
     * @returns {void}
     */
    static ClearStats() {
        this.changeCount := 0
        this.UpdateDisplay(1)
    }
}

; Callback for real-time monitor
MonitorChanged(DataType) {
    RealtimeMonitor.UpdateDisplay(DataType)
}

; Show real-time monitor
F3::RealtimeMonitor.ShowMonitor()

; ============================================================================
; Example 4: Clipboard Change Filtering
; ============================================================================

/**
 * Demonstrates filtering clipboard changes by type and content.
 *
 * @class ClipboardFilter
 * @description Filters clipboard changes
 */

class ClipboardFilter {
    static filters := Map()
    static matchLog := []

    /**
     * Adds a filter
     * @param {String} name - Filter name
     * @param {Func} condition - Filter condition function
     * @returns {void}
     */
    static AddFilter(name, condition) {
        this.filters[name] := Map("condition", condition, "matches", 0)
    }

    /**
     * Checks clipboard against filters
     * @param {Integer} dataType - Data type
     * @returns {void}
     */
    static CheckFilters(dataType) {
        if (dataType != 1)  ; Only check text
            return

        content := A_Clipboard

        for name, filter in this.filters {
            if (filter["condition"](content)) {
                filter["matches"]++
                this.LogMatch(name, content)
            }
        }
    }

    /**
     * Logs a filter match
     * @param {String} filterName - Filter that matched
     * @param {String} content - Matched content
     * @returns {void}
     */
    static LogMatch(filterName, content) {
        this.matchLog.Push(Map(
            "filter", filterName,
            "content", content,
            "timestamp", A_Now
        ))

        ; Limit log size
        if (this.matchLog.Length > 50)
            this.matchLog.RemoveAt(1)

        TrayTip("Filter Match", "Filter: " . filterName, "Icon Info Mute")
    }

    /**
     * Shows filter statistics
     * @returns {void}
     */
    static ShowStats() {
        if (this.filters.Count = 0) {
            MsgBox("No filters defined!", "Filter Stats", "Icon Info")
            return
        }

        gui := Gui("+Resize", "Clipboard Filter Statistics")
        gui.SetFont("s10")

        lv := gui.Add("ListView", "w500 h200", ["Filter Name", "Matches"])
        lv.ModifyCol(1, 350)
        lv.ModifyCol(2, 130)

        for name, filter in this.filters {
            lv.Add("", name, filter["matches"])
        }

        btnClose := gui.Add("Button", "w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }
}

; Setup default filters
ClipboardFilter.AddFilter("Contains URL",
    (text) => RegExMatch(text, "i)https?://"))

ClipboardFilter.AddFilter("Contains Email",
    (text) => RegExMatch(text, "i)[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}"))

ClipboardFilter.AddFilter("Long Text (>100 chars)",
    (text) => StrLen(text) > 100)

ClipboardFilter.AddFilter("Contains Numbers",
    (text) => RegExMatch(text, "\d+"))

; Callback for filter checking
OnClipboardChange(FilterChanged)

FilterChanged(DataType) {
    ClipboardFilter.CheckFilters(DataType)
}

; Show filter stats
F4::ClipboardFilter.ShowStats()

; ============================================================================
; Example 5: Basic Clipboard History
; ============================================================================

/**
 * Demonstrates basic clipboard history functionality.
 *
 * @class BasicClipboardHistory
 * @description Simple clipboard history manager
 */

class BasicClipboardHistory {
    static history := []
    static maxHistory := 20
    static enabled := true

    /**
     * Adds item to history
     * @param {Integer} dataType - Data type
     * @returns {void}
     */
    static AddToHistory(dataType) {
        if (!this.enabled)
            return

        ; Only save text for basic history
        if (dataType != 1)
            return

        content := A_Clipboard

        ; Don't add empty or duplicate (last item)
        if (content = "" || (this.history.Length > 0 && this.history[this.history.Length] = content))
            return

        this.history.Push(content)

        ; Limit history size
        if (this.history.Length > this.maxHistory)
            this.history.RemoveAt(1)
    }

    /**
     * Shows history GUI
     * @returns {void}
     */
    static ShowHistory() {
        if (this.history.Length = 0) {
            MsgBox("No clipboard history available!", "History", "Icon Info")
            return
        }

        gui := Gui("+Resize", "Clipboard History")
        gui.SetFont("s9")

        lv := gui.Add("ListView", "w600 h350", ["#", "Preview"])
        lv.ModifyCol(1, 50)
        lv.ModifyCol(2, 530)

        ; Populate history (newest first)
        Loop this.history.Length {
            index := this.history.Length - A_Index + 1
            content := this.history[index]

            preview := StrLen(content) > 80 ? SubStr(content, 1, 80) . "..." : content
            preview := StrReplace(preview, "`n", " ")

            lv.Add("", index, preview)
        }

        ; Buttons
        btnPaste := gui.Add("Button", "w100", "Paste")
        btnPaste.OnEvent("Click", (*) => this.PasteItem(lv, gui))

        btnCopy := gui.Add("Button", "x+10 w100", "Copy")
        btnCopy.OnEvent("Click", (*) => this.CopyItem(lv, gui))

        btnClear := gui.Add("Button", "x+10 w100", "Clear")
        btnClear.OnEvent("Click", (*) => this.ClearHistory(gui))

        btnClose := gui.Add("Button", "x+10 w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }

    static PasteItem(lv, gui) {
        rowNum := lv.GetNext()
        if (rowNum = 0) {
            MsgBox("Please select an item!", "No Selection", "Icon Warn")
            return
        }

        index := lv.GetText(rowNum, 1)
        actualIndex := this.history.Length - index + 1

        ; Disable history temporarily to avoid adding this item again
        this.enabled := false
        A_Clipboard := this.history[actualIndex]
        Send("^v")
        Sleep(100)
        this.enabled := true

        gui.Destroy()
    }

    static CopyItem(lv, gui) {
        rowNum := lv.GetNext()
        if (rowNum = 0) {
            MsgBox("Please select an item!", "No Selection", "Icon Warn")
            return
        }

        index := lv.GetText(rowNum, 1)
        actualIndex := this.history.Length - index + 1

        this.enabled := false
        A_Clipboard := this.history[actualIndex]
        this.enabled := true

        MsgBox("Item copied to clipboard!", "Copied", "Icon Info T2")
        gui.Destroy()
    }

    static ClearHistory(gui) {
        result := MsgBox("Clear all clipboard history?",
                        "Confirm", "YesNo Icon Question")
        if (result = "Yes") {
            this.history := []
            gui.Destroy()
            MsgBox("History cleared!", "Cleared", "Icon Info T2")
        }
    }
}

; Callback for history
OnClipboardChange(HistoryChanged)

HistoryChanged(DataType) {
    BasicClipboardHistory.AddToHistory(DataType)
}

; Show history
F5::BasicClipboardHistory.ShowHistory()

; ============================================================================
; Example 6: Clipboard Change Notifications
; ============================================================================

/**
 * Demonstrates clipboard change notifications with customization.
 *
 * @class ClipboardNotifier
 * @description Customizable clipboard notifications
 */

class ClipboardNotifier {
    static notifyOnChange := true
    static notifyTypes := Map("text", true, "binary", false, "empty", false)
    static useTooltip := false
    static useTrayTip := true
    static tooltipDuration := 2000

    /**
     * Notifies on clipboard change
     * @param {Integer} dataType - Data type
     * @returns {void}
     */
    static Notify(dataType) {
        if (!this.notifyOnChange)
            return

        ; Check if we should notify for this type
        notifyType := ""
        switch dataType {
            case 0:
                if (!this.notifyTypes["empty"]) return
                notifyType := "empty"
            case 1:
                if (!this.notifyTypes["text"]) return
                notifyType := "text"
            case 2:
                if (!this.notifyTypes["binary"]) return
                notifyType := "binary"
        }

        ; Build notification message
        msg := this.BuildMessage(dataType)

        ; Show notification
        if (this.useTooltip) {
            ToolTip(msg)
            SetTimer(() => ToolTip(), -this.tooltipDuration)
        }

        if (this.useTrayTip) {
            TrayTip("Clipboard Changed", msg, "Icon Info Mute")
        }
    }

    /**
     * Builds notification message
     * @param {Integer} dataType - Data type
     * @returns {String}
     */
    static BuildMessage(dataType) {
        switch dataType {
            case 0:
                return "Clipboard cleared"
            case 1:
                preview := StrLen(A_Clipboard) > 50
                    ? SubStr(A_Clipboard, 1, 50) . "..."
                    : A_Clipboard
                preview := StrReplace(preview, "`n", " ")
                return preview
            case 2:
                return "Binary/Image data copied"
        }
        return "Unknown clipboard change"
    }

    /**
     * Shows settings GUI
     * @returns {void}
     */
    static ShowSettings() {
        gui := Gui("+AlwaysOnTop", "Notification Settings")
        gui.SetFont("s10")

        gui.Add("Checkbox", "vNotifyEnabled Checked" . this.notifyOnChange,
                "Enable notifications")

        gui.Add("GroupBox", "w300 h100", "Notify on:")
        gui.Add("Checkbox", "xp+10 yp+25 vNotifyText Checked" . this.notifyTypes["text"],
                "Text changes")
        gui.Add("Checkbox", "vNotifyBinary Checked" . this.notifyTypes["binary"],
                "Binary/Image changes")
        gui.Add("Checkbox", "vNotifyEmpty Checked" . this.notifyTypes["empty"],
                "Clipboard cleared")

        gui.Add("GroupBox", "x10 y+20 w300 h80", "Notification Method:")
        gui.Add("Checkbox", "xp+10 yp+25 vUseTooltip Checked" . this.useTooltip,
                "Use tooltip")
        gui.Add("Checkbox", "vUseTrayTip Checked" . this.useTrayTip,
                "Use tray tip")

        btnSave := gui.Add("Button", "w100", "Save")
        btnSave.OnEvent("Click", (*) => this.SaveSettings(gui))

        btnClose := gui.Add("Button", "x+10 w100", "Cancel")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }

    static SaveSettings(gui) {
        saved := gui.Submit()

        this.notifyOnChange := saved.NotifyEnabled
        this.notifyTypes["text"] := saved.NotifyText
        this.notifyTypes["binary"] := saved.NotifyBinary
        this.notifyTypes["empty"] := saved.NotifyEmpty
        this.useTooltip := saved.UseTooltip
        this.useTrayTip := saved.UseTrayTip

        MsgBox("Settings saved!", "Saved", "Icon Info T2")
    }
}

; Callback for notifications
OnClipboardChange(NotifyChanged)

NotifyChanged(DataType) {
    ClipboardNotifier.Notify(DataType)
}

; Show notification settings
F6::ClipboardNotifier.ShowSettings()

; ============================================================================
; Example 7: Advanced Clipboard Watcher
; ============================================================================

/**
 * Advanced clipboard watcher with comprehensive features.
 *
 * @class AdvancedClipboardWatcher
 * @description Complete clipboard monitoring system
 */

class AdvancedClipboardWatcher {
    static enabled := true
    static stats := Map("total", 0, "text", 0, "binary", 0, "empty", 0)
    static lastChange := 0

    /**
     * Handles all clipboard changes
     * @param {Integer} dataType - Data type
     * @returns {void}
     */
    static OnClipboardChange(dataType) {
        if (!this.enabled)
            return

        ; Update statistics
        this.stats["total"]++
        switch dataType {
            case 0: this.stats["empty"]++
            case 1: this.stats["text"]++
            case 2: this.stats["binary"]++
        }

        this.lastChange := A_TickCount

        ; Call all monitoring functions
        ClipboardLogger.LogChange(dataType)
        BasicClipboardHistory.AddToHistory(dataType)
        ClipboardFilter.CheckFilters(dataType)
        ClipboardNotifier.Notify(dataType)
        RealtimeMonitor.UpdateDisplay(dataType)
    }

    /**
     * Shows comprehensive statistics
     * @returns {void}
     */
    static ShowStats() {
        lastChangeStr := this.lastChange > 0
            ? Round((A_TickCount - this.lastChange) / 1000, 1) . " seconds ago"
            : "Never"

        msg := "Clipboard Watcher Statistics:`n`n"
        msg .= "Total Changes: " . this.stats["total"] . "`n"
        msg .= "Text: " . this.stats["text"] . "`n"
        msg .= "Binary: " . this.stats["binary"] . "`n"
        msg .= "Empty: " . this.stats["empty"] . "`n`n"
        msg .= "Last Change: " . lastChangeStr . "`n"
        msg .= "Status: " . (this.enabled ? "Enabled" : "Disabled")

        MsgBox(msg, "Clipboard Watcher Stats", "Icon Info")
    }
}

; Main callback - routes to advanced watcher
OnClipboardChange(WatcherChanged)

WatcherChanged(DataType) {
    AdvancedClipboardWatcher.OnClipboardChange(DataType)
}

; Show advanced statistics
F7::AdvancedClipboardWatcher.ShowStats()

; ============================================================================
; HELP AND INFORMATION
; ============================================================================

F12:: {
    helpText := "
    (
    ╔════════════════════════════════════════════════════════════════╗
    ║       ONCLIPBOARDCHANGE MONITORING - HOTKEYS                   ║
    ╠════════════════════════════════════════════════════════════════╣
    ║ F1                  Toggle basic monitoring                    ║
    ║ F2                  Show clipboard log                         ║
    ║ F3                  Show real-time monitor                     ║
    ║ F4                  Show filter statistics                     ║
    ║ F5                  Show clipboard history                     ║
    ║ F6                  Show notification settings                 ║
    ║ F7                  Show advanced statistics                   ║
    ║                                                                ║
    ║ Ctrl+Alt+F          Toggle file logging                        ║
    ║                                                                ║
    ║ F12                 Show this help                             ║
    ╚════════════════════════════════════════════════════════════════╝
    )"

    MsgBox(helpText, "OnClipboardChange Help", "Icon Info")
}
