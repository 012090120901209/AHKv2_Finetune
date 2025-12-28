#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 - ClipWait: Timeout Handling and Error Recovery
 * ============================================================================
 * 
 * This file demonstrates advanced timeout handling, error recovery, and
 * clipboard operation monitoring using ClipWait in AutoHotkey v2.
 * 
 * @file BuiltIn_ClipWait_02.ahk
 * @version 2.0.0
 * @author AHK v2 Examples Collection
 * @date 2024-11-16
 * 
 * TABLE OF CONTENTS:
 * ──────────────────────────────────────────────────────────────────────────
 * 1. Advanced Timeout Strategies
 * 2. Error Recovery Mechanisms
 * 3. Clipboard Operation Monitoring
 * 4. Performance Optimization
 * 5. Clipboard Lock Detection
 * 6. Batch Copy Operations
 * 7. Production-Ready Copy System
 * 
 * EXAMPLES SUMMARY:
 * ──────────────────────────────────────────────────────────────────────────
 * - Implementing smart timeout strategies
 * - Recovering from clipboard failures
 * - Monitoring clipboard operation performance
 * - Optimizing clipboard operations
 * - Detecting and handling clipboard locks
 * - Performing batch copy operations
 * - Building production-ready systems
 * 
 * ============================================================================
 */

; ============================================================================
; Example 1: Advanced Timeout Strategies
; ============================================================================

/**
 * Demonstrates advanced timeout handling strategies.
 * 
 * @class TimeoutStrategies
 * @description Advanced timeout management
 */

class TimeoutStrategies {

    /**
     * Adaptive timeout based on content type
     * @param {String} contentType - Expected content type
     * @returns {Integer} Timeout in seconds
     */
    static GetAdaptiveTimeout(contentType) {
        ; Different operations need different timeouts
        timeouts := Map(
            "text", 1,
            "image", 3,
            "file", 5,
            "large", 10
        )

        return timeouts.Has(contentType) ? timeouts[contentType] : 2
    }

    /**
     * Copy with dynamic timeout adjustment
     * @param {String} contentType - Expected content type
     * @returns {Map} Result with timing info
     */
    static CopyWithDynamicTimeout(contentType := "text") {
        result := Map()
        timeout := this.GetAdaptiveTimeout(contentType)

        A_Clipboard := ""
        startTime := A_TickCount

        Send("^c")

        result["success"] := ClipWait(timeout)
        result["elapsed"] := A_TickCount - startTime
        result["timeout"] := timeout
        result["content"] := result["success"] ? A_Clipboard : ""

        return result
    }

    /**
     * Progressive timeout with feedback
     * @param {Array} timeouts - Array of timeouts to try
     * @returns {Map} Result
     */
    static CopyWithProgressiveTimeout(timeouts := [1, 2, 5]) {
        result := Map()

        A_Clipboard := ""
        Send("^c")

        for timeout in timeouts {
            ToolTip("Waiting for clipboard... (" . timeout . "s)")

            if (ClipWait(timeout)) {
                ToolTip()
                result["success"] := true
                result["timeout"] := timeout
                result["content"] := A_Clipboard
                return result
            }
        }

        ToolTip()
        result["success"] := false
        result["timeout"] := 0
        result["content"] := ""

        return result
    }

    /**
     * Timeout with user intervention option
     * @param {Integer} initialTimeout - Initial timeout
     * @returns {Boolean} Success
     */
    static CopyWithUserIntervention(initialTimeout := 2) {
        A_Clipboard := ""
        Send("^c")

        if (ClipWait(initialTimeout))
            return true

        ; Ask user if they want to wait longer
        response := MsgBox(
            "Clipboard operation timed out after " . initialTimeout . " seconds.`n`n"
            . "Wait another " . initialTimeout . " seconds?",
            "Timeout",
            "YesNo Icon Question"
        )

        if (response = "Yes") {
            return ClipWait(initialTimeout)
        }

        return false
    }
}

; Test adaptive timeout
F1:: {
    ; Simulate copying an image
    result := TimeoutStrategies.CopyWithDynamicTimeout("image")

    if (result["success"]) {
        MsgBox("Copy successful!`n`n"
            . "Elapsed: " . result["elapsed"] . "ms`n"
            . "Timeout: " . result["timeout"] . "s",
            "Success", "Icon Info")
    } else {
        MsgBox("Copy failed after " . result["timeout"] . "s timeout!",
            "Failed", "Icon Warn")
    }
}

; Test progressive timeout
F2:: {
    result := TimeoutStrategies.CopyWithProgressiveTimeout([1, 3, 5])

    if (result["success"]) {
        MsgBox("Copy succeeded with " . result["timeout"] . "s timeout!",
            "Success", "Icon Info")
    } else {
        MsgBox("Copy failed after trying all timeouts!",
            "Failed", "Icon Error")
    }
}

; ============================================================================
; Example 2: Error Recovery Mechanisms
; ============================================================================

/**
 * Demonstrates error recovery for failed clipboard operations.
 * 
 * @class ErrorRecovery
 * @description Handles and recovers from clipboard errors
 */

class ErrorRecovery {

    /**
     * Copy with automatic retry and backoff
     * @param {Integer} maxRetries - Maximum retry attempts
     * @returns {Map} Result
     */
    static CopyWithExponentialBackoff(maxRetries := 3) {
        result := Map()
        baseTimeout := 1

        Loop maxRetries {
            attempt := A_Index
            timeout := baseTimeout * (2 ** (attempt - 1))  ; Exponential backoff

            ToolTip("Attempt " . attempt . " (timeout: " . timeout . "s)")

            A_Clipboard := ""
            Send("^c")

            if (ClipWait(timeout)) {
                ToolTip()
                result["success"] := true
                result["attempts"] := attempt
                result["content"] := A_Clipboard
                return result
            }

            ; Brief pause before retry
            Sleep(200)
        }

        ToolTip()
        result["success"] := false
        result["attempts"] := maxRetries
        result["content"] := ""

        return result
    }

    /**
     * Copy with fallback methods
     * @returns {Map} Result with method used
     */
    static CopyWithFallback() {
        result := Map("success", false, "method", "", "content", "")

        ; Method 1: Standard Ctrl+C
        A_Clipboard := ""
        Send("^c")
        if (ClipWait(1)) {
            result["success"] := true
            result["method"] := "Ctrl+C"
            result["content"] := A_Clipboard
            return result
        }

        ; Method 2: Context menu copy
        Send("+{F10}")  ; Shift+F10 for context menu
        Sleep(100)
        Send("c")
        if (ClipWait(1)) {
            result["success"] := true
            result["method"] := "Context Menu"
            result["content"] := A_Clipboard
            return result
        }

        ; Method 3: Application-specific (e.g., Ctrl+Insert)
        A_Clipboard := ""
        Send("^{Insert}")
        if (ClipWait(1)) {
            result["success"] := true
            result["method"] := "Ctrl+Insert"
            result["content"] := A_Clipboard
            return result
        }

        return result
    }

    /**
     * Copy with clipboard unlock attempt
     * @param {Integer} timeout - Timeout in seconds
     * @returns {Boolean} Success
     */
    static CopyWithUnlock(timeout := 2) {
        ; Clear clipboard to unlock
        A_Clipboard := ""
        Sleep(100)

        ; Try to force unlock by opening/closing clipboard
        DllCall("OpenClipboard", "Ptr", 0)
        DllCall("EmptyClipboard")
        DllCall("CloseClipboard")

        Sleep(100)

        ; Now try copy
        Send("^c")
        return ClipWait(timeout)
    }
}

; Test exponential backoff
^!b:: {
    result := ErrorRecovery.CopyWithExponentialBackoff(4)

    if (result["success"]) {
        MsgBox("Copy succeeded on attempt " . result["attempts"] . "!",
            "Success", "Icon Info")
    } else {
        MsgBox("Copy failed after " . result["attempts"] . " attempts!",
            "Failed", "Icon Error")
    }
}

; Test fallback methods
^!f:: {
    result := ErrorRecovery.CopyWithFallback()

    if (result["success"]) {
        MsgBox("Copy succeeded using: " . result["method"],
            "Success", "Icon Info")
    } else {
        MsgBox("All copy methods failed!", "Failed", "Icon Error")
    }
}

; ============================================================================
; Example 3: Clipboard Operation Monitoring
; ============================================================================

/**
 * Demonstrates monitoring clipboard operation performance.
 * 
 * @class ClipboardMonitor
 * @description Monitors and logs clipboard operations
 */

class ClipboardMonitor {
    static operationLog := []
    static maxLogSize := 50

    /**
     * Monitors a copy operation
     * @param {Integer} timeout - Timeout in seconds
     * @returns {Map} Operation details
     */
    static MonitorCopy(timeout := 2) {
        operation := Map()
        operation["timestamp"] := A_Now
        operation["startTime"] := A_TickCount

        A_Clipboard := ""
        Send("^c")

        operation["success"] := ClipWait(timeout)
        operation["duration"] := A_TickCount - operation["startTime"]
        operation["timeout"] := timeout
        operation["contentSize"] := StrLen(A_Clipboard)

        ; Log operation
        this.LogOperation(operation)

        return operation
    }

    /**
     * Logs an operation
     * @param {Map} operation - Operation details
     * @returns {void}
     */
    static LogOperation(operation) {
        this.operationLog.Push(operation)

        if (this.operationLog.Length > this.maxLogSize)
            this.operationLog.RemoveAt(1)
    }

    /**
     * Gets operation statistics
     * @returns {Map} Statistics
     */
    static GetStats() {
        if (this.operationLog.Length = 0)
            return Map("count", 0)

        stats := Map()
        stats["count"] := this.operationLog.Length

        totalDuration := 0
        successCount := 0
        failCount := 0
        maxDuration := 0
        minDuration := 999999

        for op in this.operationLog {
            totalDuration += op["duration"]

            if (op["success"])
                successCount++
            else
                failCount++

            if (op["duration"] > maxDuration)
                maxDuration := op["duration"]

            if (op["duration"] < minDuration)
                minDuration := op["duration"]
        }

        stats["avgDuration"] := Round(totalDuration / this.operationLog.Length, 0)
        stats["maxDuration"] := maxDuration
        stats["minDuration"] := minDuration
        stats["successCount"] := successCount
        stats["failCount"] := failCount
        stats["successRate"] := Round((successCount / this.operationLog.Length) * 100, 1)

        return stats
    }

    /**
     * Shows statistics GUI
     * @returns {void}
     */
    static ShowStats() {
        stats := this.GetStats()

        if (stats["count"] = 0) {
            MsgBox("No operations logged yet!", "Statistics", "Icon Info")
            return
        }

        gui := Gui("+AlwaysOnTop", "Clipboard Operation Statistics")
        gui.SetFont("s10")

        gui.Add("Text", "w400", "Performance Statistics:")

        gui.Add("Text", "x20 y+10", "Total Operations:")
        gui.Add("Text", "x+10", stats["count"])

        gui.Add("Text", "x20 y+5", "Success Rate:")
        gui.Add("Text", "x+10", stats["successRate"] . "%")

        gui.Add("Text", "x20 y+5", "Successful:")
        gui.Add("Text", "x+10", stats["successCount"])

        gui.Add("Text", "x20 y+5", "Failed:")
        gui.Add("Text", "x+10", stats["failCount"])

        gui.Add("Text", "x20 y+10", "Average Duration:")
        gui.Add("Text", "x+10", stats["avgDuration"] . " ms")

        gui.Add("Text", "x20 y+5", "Max Duration:")
        gui.Add("Text", "x+10", stats["maxDuration"] . " ms")

        gui.Add("Text", "x20 y+5", "Min Duration:")
        gui.Add("Text", "x+10", stats["minDuration"] . " ms")

        btnClose := gui.Add("Button", "x170 y+20 w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }
}

; Monitored copy
^!m:: {
    op := ClipboardMonitor.MonitorCopy(2)

    status := op["success"] ? "Success" : "Failed"
    MsgBox("Copy " . status . "!`n`n"
        . "Duration: " . op["duration"] . " ms`n"
        . "Content Size: " . op["contentSize"] . " chars",
        "Monitored Copy", "Icon Info")
}

; Show statistics
^!s:: ClipboardMonitor.ShowStats()

; ============================================================================
; Example 4: Performance Optimization
; ============================================================================

/**
 * Demonstrates optimizing clipboard operations.
 * 
 * @class PerformanceOptimizer
 * @description Optimizes clipboard performance
 */

class PerformanceOptimizer {

    /**
     * Fast copy with minimal timeout
     * @returns {Map} Result
     */
    static FastCopy() {
        result := Map()
        startTime := A_TickCount

        A_Clipboard := ""
        Send("^c")

        ; Use short timeout for responsive apps
        result["success"] := ClipWait(0.5)
        result["duration"] := A_TickCount - startTime

        return result
    }

    /**
     * Batch copy with optimized delays
     * @param {Integer} count - Number of items
     * @returns {Array} Results
     */
    static BatchCopy(count) {
        results := []

        Loop count {
            ; Minimal delay between operations
            if (A_Index > 1)
                Sleep(50)

            A_Clipboard := ""
            Send("^c")

            success := ClipWait(1)
            results.Push(Map(
                "index", A_Index,
                "success", success,
                "content", success ? A_Clipboard : ""
            ))
        }

        return results
    }

    /**
     * Cached copy - reuses clipboard if unchanged
     * @returns {String} Content
     */
    static CachedCopy() {
        static lastContent := ""
        static lastTime := 0

        currentTime := A_TickCount

        ; If less than 500ms since last copy, return cached
        if (currentTime - lastTime < 500 && lastContent != "") {
            return lastContent
        }

        ; Perform new copy
        A_Clipboard := ""
        Send("^c")

        if (ClipWait(1)) {
            lastContent := A_Clipboard
            lastTime := currentTime
            return lastContent
        }

        return ""
    }
}

; Fast copy test
^!q:: {
    result := PerformanceOptimizer.FastCopy()

    if (result["success"]) {
        MsgBox("Fast copy completed in " . result["duration"] . "ms!",
            "Fast Copy", "Icon Info")
    } else {
        MsgBox("Copy timed out!", "Failed", "Icon Warn")
    }
}

; ============================================================================
; Example 5: Clipboard Lock Detection
; ============================================================================

/**
 * Demonstrates detecting and handling clipboard locks.
 * 
 * @class ClipboardLockDetector
 * @description Detects clipboard lock conditions
 */

class ClipboardLockDetector {

    /**
     * Checks if clipboard is locked
     * @returns {Boolean} True if locked
     */
    static IsLocked() {
        ; Try to open clipboard
        if (DllCall("OpenClipboard", "Ptr", 0)) {
            DllCall("CloseClipboard")
            return false
        }
        return true
    }

    /**
     * Waits for clipboard to become available
     * @param {Integer} timeout - Timeout in seconds
     * @returns {Boolean} True if became available
     */
    static WaitForUnlock(timeout := 5) {
        endTime := A_TickCount + (timeout * 1000)

        while (A_TickCount < endTime) {
            if (!this.IsLocked())
                return true

            Sleep(100)
        }

        return false
    }

    /**
     * Copy with lock detection and handling
     * @param {Integer} timeout - Timeout in seconds
     * @returns {Map} Result
     */
    static CopyWithLockDetection(timeout := 2) {
        result := Map("success", false, "error", "")

        ; Check if locked
        if (this.IsLocked()) {
            result["error"] := "Clipboard is locked"

            ; Try to wait for unlock
            if (this.WaitForUnlock(2)) {
                result["error"] .= " - waited for unlock"
            } else {
                return result
            }
        }

        ; Perform copy
        A_Clipboard := ""
        Send("^c")

        result["success"] := ClipWait(timeout)
        if (!result["success"])
            result["error"] := "Timeout"

        return result
    }
}

; Copy with lock detection
^!k:: {
    result := ClipboardLockDetector.CopyWithLockDetection(2)

    if (result["success"]) {
        MsgBox("Copy successful!", "Success", "Icon Info")
    } else {
        MsgBox("Copy failed!`n`nError: " . result["error"],
            "Failed", "Icon Error")
    }
}

; ============================================================================
; Example 6: Batch Copy Operations
; ============================================================================

/**
 * Demonstrates efficient batch copy operations.
 * 
 * @class BatchCopyOperations
 * @description Handles multiple copy operations
 */

class BatchCopyOperations {

    /**
     * Copies multiple selections with progress
     * @param {Integer} count - Number of selections
     * @param {Integer} timeout - Timeout per copy
     * @returns {Array} Results
     */
    static CopyMultipleWithProgress(count, timeout := 2) {
        results := []

        ; Create progress GUI
        progress := Gui("+AlwaysOnTop -SysMenu", "Batch Copy Progress")
        progress.SetFont("s10")
        progress.Add("Text", "w300", "Copying items...")
        progressBar := progress.Add("Progress", "w300 h30", "Range0-" . count)
        statusText := progress.Add("Text", "w300", "Item 0 of " . count)
        progress.Show()

        Loop count {
            index := A_Index

            ; Update progress
            progressBar.Value := index
            statusText.Value := "Item " . index . " of " . count

            ; Copy
            A_Clipboard := ""
            Send("^c")

            success := ClipWait(timeout)
            results.Push(Map(
                "index", index,
                "success", success,
                "content", success ? A_Clipboard : ""
            ))

            ; Brief pause for next selection
            if (index < count)
                Sleep(500)
        }

        progress.Destroy()
        return results
    }

    /**
     * Copies from list of coordinates
     * @param {Array} coordinates - Array of [x, y] coordinates
     * @param {Integer} timeout - Timeout per copy
     * @returns {Array} Results
     */
    static CopyFromCoordinates(coordinates, timeout := 2) {
        results := []

        for coord in coordinates {
            ; Click at coordinates
            Click(coord[1], coord[2])
            Sleep(100)

            ; Select all at that location
            Send("^a")
            Sleep(100)

            ; Copy
            A_Clipboard := ""
            Send("^c")

            success := ClipWait(timeout)
            results.Push(Map(
                "x", coord[1],
                "y", coord[2],
                "success", success,
                "content", success ? A_Clipboard : ""
            ))

            Sleep(100)
        }

        return results
    }
}

; Batch copy demo
^!+b:: {
    MsgBox("Prepare 3 text selections.`n`n"
        . "You will have 0.5s between each copy.",
        "Batch Copy", "Icon Info")

    results := BatchCopyOperations.CopyMultipleWithProgress(3, 2)

    ; Show results
    successCount := 0
    for r in results {
        if (r["success"])
            successCount++
    }

    MsgBox("Batch copy complete!`n`n"
        . "Successful: " . successCount . " / " . results.Length,
        "Results", "Icon Info")
}

; ============================================================================
; Example 7: Production-Ready Copy System
; ============================================================================

/**
 * Production-ready clipboard copy system with full features.
 * 
 * @class ProductionCopySystem
 * @description Complete copy system for production use
 */

class ProductionCopySystem {

    /**
     * Universal copy function with all features
     * @param {Map} config - Configuration options
     * @returns {Map} Detailed result
     */
    static UniversalCopy(config := unset) {
        ; Default configuration
        cfg := Map(
            "timeout", 2,
            "retries", 2,
            "preserveClipboard", true,
            "verifyContent", false,
            "logOperation", true,
            "showProgress", false,
            "detectLock", true,
            "adaptiveTimeout", false
        )

        ; Merge config
        if (IsSet(config)) {
            for key, value in config {
                cfg[key] := value
            }
        }

        result := Map(
            "success", false,
            "content", "",
            "duration", 0,
            "attempts", 0,
            "error", ""
        )

        startTime := A_TickCount

        ; Save clipboard if needed
        savedClip := cfg["preserveClipboard"] ? ClipboardAll() : ""

        try {
            ; Detect clipboard lock
            if (cfg["detectLock"] && ClipboardLockDetector.IsLocked()) {
                if (!ClipboardLockDetector.WaitForUnlock(2)) {
                    result["error"] := "Clipboard locked"
                    return result
                }
            }

            ; Attempt copy with retries
            Loop cfg["retries"] {
                result["attempts"]++

                if (cfg["showProgress"])
                    ToolTip("Copying... (attempt " . A_Index . ")")

                A_Clipboard := ""
                Send("^c")

                if (ClipWait(cfg["timeout"])) {
                    result["success"] := true
                    result["content"] := A_Clipboard
                    break
                }

                Sleep(100)
            }

            if (cfg["showProgress"])
                ToolTip()

            result["duration"] := A_TickCount - startTime

            ; Log if enabled
            if (cfg["logOperation"])
                ClipboardMonitor.LogOperation(result)

        } catch as err {
            result["error"] := err.Message
        } finally {
            ; Restore clipboard if needed
            if (cfg["preserveClipboard"] && Type(savedClip) = "ClipboardAll") {
                A_Clipboard := savedClip
                ClipWait(1)
            }
        }

        return result
    }
}

; Production copy
^!+p:: {
    config := Map(
        "timeout", 2,
        "retries", 3,
        "preserveClipboard", true,
        "showProgress", true,
        "detectLock", true,
        "logOperation", true
    )

    result := ProductionCopySystem.UniversalCopy(config)

    if (result["success"]) {
        MsgBox("Copy successful!`n`n"
            . "Duration: " . result["duration"] . "ms`n"
            . "Attempts: " . result["attempts"],
            "Success", "Icon Info")
    } else {
        MsgBox("Copy failed!`n`n"
            . "Error: " . (result["error"] != "" ? result["error"] : "Timeout")
            . "`nAttempts: " . result["attempts"],
            "Failed", "Icon Error")
    }
}

; ============================================================================
; HELP AND INFORMATION
; ============================================================================

F12:: {
    helpText := "
    (
    ╔════════════════════════════════════════════════════════════════╗
    ║      CLIPWAIT TIMEOUT HANDLING - HOTKEYS                       ║
    ╠════════════════════════════════════════════════════════════════╣
    ║ TIMEOUT STRATEGIES:                                            ║
    ║   F1                  Adaptive timeout test                    ║
    ║   F2                  Progressive timeout test                 ║
    ║                                                                ║
    ║ ERROR RECOVERY:                                                ║
    ║   Ctrl+Alt+B          Exponential backoff                      ║
    ║   Ctrl+Alt+F          Fallback methods                         ║
    ║                                                                ║
    ║ MONITORING:                                                    ║
    ║   Ctrl+Alt+M          Monitored copy                           ║
    ║   Ctrl+Alt+S          Show statistics                          ║
    ║                                                                ║
    ║ PERFORMANCE:                                                   ║
    ║   Ctrl+Alt+Q          Fast copy test                           ║
    ║                                                                ║
    ║ LOCK DETECTION:                                                ║
    ║   Ctrl+Alt+K          Copy with lock detection                 ║
    ║                                                                ║
    ║ BATCH OPERATIONS:                                              ║
    ║   Ctrl+Alt+Shift+B    Batch copy demo                          ║
    ║                                                                ║
    ║ PRODUCTION:                                                    ║
    ║   Ctrl+Alt+Shift+P    Production copy system                   ║
    ║                                                                ║
    ║ F12                   Show this help                           ║
    ╚════════════════════════════════════════════════════════════════╝
    )"

    MsgBox(helpText, "ClipWait Timeout Help", "Icon Info")
}
