#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 - ClipWait: Waiting for Clipboard Operations
 * ============================================================================
 *
 * This file demonstrates using ClipWait to wait for clipboard operations
 * to complete, ensuring reliable clipboard automation.
 *
 * ClipWait pauses script execution until the clipboard contains data,
 * which is essential when automating copy operations.
 *
 * @file BuiltIn_ClipWait_01.ahk
 * @version 2.0.0
 * @author AHK v2 Examples Collection
 * @date 2024-11-16
 *
 * TABLE OF CONTENTS:
 * ──────────────────────────────────────────────────────────────────────────
 * 1. Basic ClipWait Usage
 * 2. ClipWait with Timeout Handling
 * 3. Safe Copy Operations
 * 4. Multiple Copy Operations
 * 5. Clipboard Verification
 * 6. Advanced Copy Automation
 * 7. Robust Clipboard Utilities
 *
 * EXAMPLES SUMMARY:
 * ──────────────────────────────────────────────────────────────────────────
 * - Basic ClipWait usage and syntax
 * - Handling timeouts gracefully
 * - Creating safe copy operations
 * - Chaining multiple copy operations
 * - Verifying clipboard content after copy
 * - Building automation with ClipWait
 * - Creating robust clipboard utilities
 *
 * ============================================================================
 */

; ============================================================================
; Example 1: Basic ClipWait Usage
; ============================================================================

/**
 * Demonstrates basic ClipWait usage.
 *
 * @class BasicClipWait
 * @description Shows fundamental ClipWait operations
 */

class BasicClipWait {

    /**
     * Simple copy with ClipWait
     * @returns {Boolean} Success status
     */
    static SimpleCopy() {
        ; Clear clipboard first
        A_Clipboard := ""

        ; Send copy command
        Send("^c")

        ; Wait for clipboard to contain data (default 1 second timeout)
        if (ClipWait(1)) {
            MsgBox("Copy successful!`n`nClipboard: " . A_Clipboard,
                   "Success", "Icon Info")
            return true
        } else {
            MsgBox("Copy failed - clipboard did not receive data!",
                   "Failed", "Icon Warn")
            return false
        }
    }

    /**
     * Copy with longer timeout
     * @param {Integer} timeout - Timeout in seconds
     * @returns {Boolean} Success status
     */
    static CopyWithTimeout(timeout := 3) {
        A_Clipboard := ""
        Send("^c")

        if (ClipWait(timeout)) {
            TrayTip("Copy Successful",
                    "Data copied to clipboard",
                    "Icon Info")
            return true
        } else {
            TrayTip("Copy Failed",
                    "Timeout waiting for clipboard",
                    "Icon Warn")
            return false
        }
    }

    /**
     * Wait for any clipboard change
     * @param {Integer} timeout - Timeout in seconds
     * @returns {Boolean} Success status
     */
    static WaitForClipboard(timeout := 2) {
        ; ClipWait returns true if clipboard receives ANY data
        return ClipWait(timeout)
    }

    /**
     * Wait for specific type of data
     * @param {Integer} dataType - 0=any, 1=text only
     * @param {Integer} timeout - Timeout in seconds
     * @returns {Boolean} Success status
     */
    static WaitForDataType(dataType := 0, timeout := 2) {
        ; ClipWait's second parameter:
        ; 0 or omitted = wait for any data
        ; 1 = wait for data that isn't only text

        return ClipWait(timeout, dataType)
    }
}

; Simple copy demonstration
F1:: {
    MsgBox("Select some text, then press OK to test ClipWait.",
           "Basic ClipWait Demo", "Icon Info")
    BasicClipWait.SimpleCopy()
}

; Copy with extended timeout
F2:: {
    MsgBox("Select some text, then press OK.`nYou have 3 seconds.",
           "Extended Timeout Demo", "Icon Info")
    BasicClipWait.CopyWithTimeout(3)
}

; ============================================================================
; Example 2: ClipWait with Timeout Handling
; ============================================================================

/**
 * Demonstrates proper timeout handling with ClipWait.
 *
 * @class TimeoutHandler
 * @description Handles ClipWait timeouts gracefully
 */

class TimeoutHandler {

    /**
     * Copy with retry on timeout
     * @param {Integer} maxRetries - Maximum retry attempts
     * @param {Integer} timeout - Timeout per attempt
     * @returns {Boolean} Success status
     */
    static CopyWithRetry(maxRetries := 3, timeout := 1) {
        Loop maxRetries {
            attempt := A_Index

            ; Clear and copy
            A_Clipboard := ""
            Send("^c")

            ; Wait for clipboard
            if (ClipWait(timeout)) {
                TrayTip("Copy Successful",
                        "Succeeded on attempt " . attempt,
                        "Icon Info")
                return true
            }

            ; Failed - retry if attempts remain
            if (attempt < maxRetries) {
                Sleep(100)  ; Brief pause before retry
            }
        }

        ; All attempts failed
        MsgBox("Copy failed after " . maxRetries . " attempts!",
               "Copy Failed", "Icon Error")
        return false
    }

    /**
     * Copy with custom error handling
     * @param {Func} errorCallback - Function to call on error
     * @param {Integer} timeout - Timeout in seconds
     * @returns {Boolean} Success status
     */
    static CopyWithErrorHandler(errorCallback, timeout := 2) {
        A_Clipboard := ""
        Send("^c")

        if (!ClipWait(timeout)) {
            ; Call error handler
            errorCallback(timeout)
            return false
        }

        return true
    }

    /**
     * Copy with progress indication
     * @param {Integer} timeout - Timeout in seconds
     * @returns {Boolean} Success status
     */
    static CopyWithProgress(timeout := 3) {
        A_Clipboard := ""

        ; Show progress tooltip
        ToolTip("Copying... Please wait")

        Send("^c")

        result := ClipWait(timeout)

        ToolTip()  ; Hide tooltip

        if (result) {
            TrayTip("Copy Complete", "", "Icon Info")
        } else {
            MsgBox("Copy operation timed out after " . timeout . " seconds!",
                   "Timeout", "Icon Warn")
        }

        return result
    }
}

; Copy with retry
^!c::TimeoutHandler.CopyWithRetry(3, 1)

; Copy with progress
^!p::TimeoutHandler.CopyWithProgress(3)

; Copy with custom error handler
^!e:: {
    errorHandler := (timeout) {
        MsgBox("Copy failed! Timed out after " . timeout . " seconds.`n`n"
             . "Possible causes:`n"
             . "• No text was selected`n"
             . "• Application doesn't support copying`n"
             . "• Clipboard is locked by another process",
               "Copy Error", "Icon Error")
    }

    TimeoutHandler.CopyWithErrorHandler(errorHandler, 2)
}

; ============================================================================
; Example 3: Safe Copy Operations
; ============================================================================

/**
 * Demonstrates safe clipboard copy operations.
 *
 * @class SafeCopy
 * @description Performs safe clipboard operations
 */

class SafeCopy {

    /**
     * Safely copies text without losing clipboard
     * @returns {String} Copied text or empty string on failure
     */
    static SafeCopyText() {
        ; Save current clipboard
        savedClip := ClipboardAll()

        try {
            ; Clear and copy
            A_Clipboard := ""
            Send("^c")

            ; Wait for clipboard
            if (ClipWait(2)) {
                copiedText := A_Clipboard

                ; Restore original clipboard
                A_Clipboard := savedClip
                ClipWait(1)

                return copiedText
            } else {
                ; Restore on failure too
                A_Clipboard := savedClip
                ClipWait(1)
                return ""
            }
        } catch as err {
            ; Restore on error
            A_Clipboard := savedClip
            ClipWait(1)
            throw err
        }
    }

    /**
     * Copies selected text and returns it
     * @param {Integer} timeout - Timeout in seconds
     * @returns {String} Copied text
     */
    static GetSelectedText(timeout := 2) {
        savedClip := ClipboardAll()

        A_Clipboard := ""
        Send("^c")

        if (ClipWait(timeout)) {
            result := A_Clipboard
            A_Clipboard := savedClip
            ClipWait(1)
            return result
        }

        A_Clipboard := savedClip
        ClipWait(1)
        return ""
    }

    /**
     * Copies and processes text without affecting clipboard
     * @param {Func} processor - Function to process text
     * @returns {Any} Result from processor
     */
    static CopyAndProcess(processor) {
        savedClip := ClipboardAll()

        try {
            A_Clipboard := ""
            Send("^c")

            if (ClipWait(2)) {
                result := processor(A_Clipboard)
                A_Clipboard := savedClip
                ClipWait(1)
                return result
            }

            A_Clipboard := savedClip
            ClipWait(1)
            return ""
        } catch as err {
            A_Clipboard := savedClip
            ClipWait(1)
            throw err
        }
    }
}

; Get selected text and show it
^!g:: {
    text := SafeCopy.GetSelectedText(2)

    if (text != "") {
        MsgBox("Selected text:`n`n" . text,
               "Selection", "Icon Info")
    } else {
        MsgBox("No text was copied!",
               "No Selection", "Icon Warn")
    }
}

; Copy and count words
^!w:: {
    wordCount := SafeCopy.CopyAndProcess((text) {
        count := 0
        Loop Parse, text, " `t`n`r" {
            if (A_LoopField != "")
                count++
        }
        return count
    })

    if (wordCount != "") {
        MsgBox("Word count: " . wordCount, "Word Counter", "Icon Info")
    } else {
        MsgBox("Failed to copy text!", "Error", "Icon Warn")
    }
}

; ============================================================================
; Example 4: Multiple Copy Operations
; ============================================================================

/**
 * Demonstrates chaining multiple copy operations.
 *
 * @class MultiCopy
 * @description Handles multiple sequential copies
 */

class MultiCopy {

    /**
     * Copies multiple selections sequentially
     * @param {Integer} count - Number of selections to copy
     * @param {Integer} timeout - Timeout per copy
     * @returns {Array} Array of copied texts
     */
    static CopyMultiple(count, timeout := 2) {
        results := []

        Loop count {
            index := A_Index

            ; Prompt user
            MsgBox("Select text #" . index . " and press OK",
                   "Multi-Copy", "Icon Info")

            ; Copy
            A_Clipboard := ""
            Send("^c")

            if (ClipWait(timeout)) {
                results.Push(A_Clipboard)
            } else {
                MsgBox("Copy #" . index . " failed!",
                       "Copy Failed", "Icon Warn")
                return results  ; Return what we have so far
            }
        }

        return results
    }

    /**
     * Copies from multiple windows
     * @param {Array} windowTitles - Array of window titles
     * @param {Integer} timeout - Timeout per copy
     * @returns {Map} Map of window title to copied text
     */
    static CopyFromWindows(windowTitles, timeout := 2) {
        results := Map()

        for title in windowTitles {
            ; Activate window
            try {
                WinActivate(title)
                WinWaitActive(title, , 2)
            } catch {
                results[title] := "ERROR: Window not found"
                continue
            }

            ; Copy
            A_Clipboard := ""
            Send("^c")

            if (ClipWait(timeout)) {
                results[title] := A_Clipboard
            } else {
                results[title] := "ERROR: Copy timeout"
            }

            Sleep(100)
        }

        return results
    }

    /**
     * Collects multiple copies into single result
     * @param {Integer} count - Number of items to copy
     * @param {String} separator - Separator between items
     * @returns {String} Combined result
     */
    static CollectMultiple(count, separator := "`n") {
        collected := []

        Loop count {
            index := A_Index

            MsgBox("Select item #" . index . " and press OK",
                   "Collect Items", "Icon Info")

            A_Clipboard := ""
            Send("^c")

            if (ClipWait(2)) {
                collected.Push(A_Clipboard)
            }
        }

        ; Join with separator
        result := ""
        for item in collected {
            if (result != "")
                result .= separator
            result .= item
        }

        return result
    }
}

; Copy 3 selections
^!3:: {
    results := MultiCopy.CopyMultiple(3, 2)

    if (results.Length > 0) {
        msg := "Copied " . results.Length . " item(s):`n`n"
        for text in results {
            preview := StrLen(text) > 50 ? SubStr(text, 1, 50) . "..." : text
            msg .= "• " . preview . "`n"
        }
        MsgBox(msg, "Multi-Copy Results", "Icon Info")
    }
}

; Collect multiple items
^!+c:: {
    collected := MultiCopy.CollectMultiple(3, "`n")

    A_Clipboard := collected
    MsgBox("Collected items copied to clipboard!`n`nPreview:`n`n"
         . SubStr(collected, 1, 200),
           "Collected", "Icon Info")
}

; ============================================================================
; Example 5: Clipboard Verification
; ============================================================================

/**
 * Demonstrates verifying clipboard content after copy.
 *
 * @class ClipboardVerifier
 * @description Verifies clipboard operations
 */

class ClipboardVerifier {

    /**
     * Copies and verifies content is not empty
     * @param {Integer} timeout - Timeout in seconds
     * @returns {Boolean} True if copy succeeded and has content
     */
    static CopyAndVerifyNotEmpty(timeout := 2) {
        A_Clipboard := ""
        Send("^c")

        if (!ClipWait(timeout))
            return false

        return (A_Clipboard != "")
    }

    /**
     * Copies and verifies minimum length
     * @param {Integer} minLength - Minimum required length
     * @param {Integer} timeout - Timeout in seconds
     * @returns {Boolean} True if meets minimum length
     */
    static CopyAndVerifyLength(minLength, timeout := 2) {
        A_Clipboard := ""
        Send("^c")

        if (!ClipWait(timeout))
            return false

        return (StrLen(A_Clipboard) >= minLength)
    }

    /**
     * Copies and verifies against pattern
     * @param {String} pattern - Regex pattern to match
     * @param {Integer} timeout - Timeout in seconds
     * @returns {Boolean} True if matches pattern
     */
    static CopyAndVerifyPattern(pattern, timeout := 2) {
        A_Clipboard := ""
        Send("^c")

        if (!ClipWait(timeout))
            return false

        return RegExMatch(A_Clipboard, pattern)
    }

    /**
     * Copies and validates content
     * @param {Func} validator - Validation function
     * @param {Integer} timeout - Timeout in seconds
     * @returns {Map} Validation result
     */
    static CopyAndValidate(validator, timeout := 2) {
        result := Map()

        A_Clipboard := ""
        Send("^c")

        result["success"] := ClipWait(timeout)

        if (result["success"]) {
            result["content"] := A_Clipboard
            result["valid"] := validator(A_Clipboard)
        } else {
            result["content"] := ""
            result["valid"] := false
        }

        return result
    }
}

; Copy and verify not empty
^!v:: {
    if (ClipboardVerifier.CopyAndVerifyNotEmpty(2)) {
        TrayTip("Verified", "Copy successful and not empty", "Icon Info")
    } else {
        TrayTip("Failed", "Copy failed or clipboard is empty", "Icon Warn")
    }
}

; Copy and verify email pattern
^!@:: {
    if (ClipboardVerifier.CopyAndVerifyPattern("i)[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}", 2)) {
        MsgBox("Valid email address copied!", "Email Verified", "Icon Info")
    } else {
        MsgBox("Copied text is not a valid email address!", "Invalid", "Icon Warn")
    }
}

; ============================================================================
; Example 6: Advanced Copy Automation
; ============================================================================

/**
 * Demonstrates advanced copy automation techniques.
 *
 * @class AdvancedCopyAutomation
 * @description Advanced clipboard automation
 */

class AdvancedCopyAutomation {

    /**
     * Copies entire document/page
     * @param {Integer} timeout - Timeout in seconds
     * @returns {String} Copied content
     */
    static CopyAll(timeout := 3) {
        savedClip := ClipboardAll()

        ; Select all and copy
        Send("^a")
        Sleep(100)

        A_Clipboard := ""
        Send("^c")

        if (ClipWait(timeout)) {
            result := A_Clipboard
            A_Clipboard := savedClip
            ClipWait(1)
            return result
        }

        A_Clipboard := savedClip
        ClipWait(1)
        return ""
    }

    /**
     * Copies current line
     * @param {Integer} timeout - Timeout in seconds
     * @returns {String} Copied line
     */
    static CopyCurrentLine(timeout := 2) {
        savedClip := ClipboardAll()

        ; Select line (Home, Shift+End)
        Send("{Home}")
        Sleep(50)
        Send("+{End}")
        Sleep(50)

        A_Clipboard := ""
        Send("^c")

        if (ClipWait(timeout)) {
            result := A_Clipboard
            A_Clipboard := savedClip
            ClipWait(1)
            return result
        }

        A_Clipboard := savedClip
        ClipWait(1)
        return ""
    }

    /**
     * Copies word at cursor
     * @param {Integer} timeout - Timeout in seconds
     * @returns {String} Copied word
     */
    static CopyCurrentWord(timeout := 2) {
        savedClip := ClipboardAll()

        ; Double-click to select word
        Click(2)
        Sleep(100)

        A_Clipboard := ""
        Send("^c")

        if (ClipWait(timeout)) {
            result := A_Clipboard
            A_Clipboard := savedClip
            ClipWait(1)
            return result
        }

        A_Clipboard := savedClip
        ClipWait(1)
        return ""
    }
}

; Copy entire document
^!a:: {
    content := AdvancedCopyAutomation.CopyAll(3)

    if (content != "") {
        lines := StrSplit(content, "`n").Length
        chars := StrLen(content)
        MsgBox("Copied entire document:`n`n"
             . "Lines: " . lines . "`n"
             . "Characters: " . chars,
               "Copy All", "Icon Info")
    }
}

; Copy current line
^!l:: {
    line := AdvancedCopyAutomation.CopyCurrentLine(2)

    if (line != "") {
        MsgBox("Current line:`n`n" . line,
               "Line Copy", "Icon Info")
    }
}

; Copy current word
^!d:: {
    word := AdvancedCopyAutomation.CopyCurrentWord(2)

    if (word != "") {
        MsgBox("Current word: " . word,
               "Word Copy", "Icon Info")
    }
}

; ============================================================================
; Example 7: Robust Clipboard Utilities
; ============================================================================

/**
 * Robust clipboard utility functions using ClipWait.
 *
 * @class RobustClipboard
 * @description Production-ready clipboard utilities
 */

class RobustClipboard {

    /**
     * Performs copy with full error handling
     * @param {Map} options - Configuration options
     * @returns {Map} Result with status and data
     */
    static Copy(options := unset) {
        ; Default options
        opts := Map(
            "timeout", 2,
            "retries", 1,
            "preserveClip", true,
            "clearFirst", true,
            "verify", false
        )

        ; Merge provided options
        if (IsSet(options)) {
            for key, value in options {
                opts[key] := value
            }
        }

        result := Map("success", false, "content", "", "error", "")

        ; Save clipboard if requested
        savedClip := opts["preserveClip"] ? ClipboardAll() : ""

        try {
            ; Attempt copy with retries
            Loop opts["retries"] {
                if (opts["clearFirst"])
                    A_Clipboard := ""

                Send("^c")

                if (ClipWait(opts["timeout"])) {
                    result["content"] := A_Clipboard
                    result["success"] := true
                    break
                }
            }

            ; Restore clipboard if requested
            if (opts["preserveClip"] && Type(savedClip) = "ClipboardAll") {
                A_Clipboard := savedClip
                ClipWait(1)
            }

            if (!result["success"])
                result["error"] := "Timeout after " . opts["retries"] . " attempt(s)"

        } catch as err {
            result["error"] := err.Message

            if (opts["preserveClip"] && Type(savedClip) = "ClipboardAll") {
                A_Clipboard := savedClip
                ClipWait(1)
            }
        }

        return result
    }
}

; Robust copy demo
^!r:: {
    options := Map(
        "timeout", 2,
        "retries", 3,
        "preserveClip", true
    )

    result := RobustClipboard.Copy(options)

    if (result["success"]) {
        MsgBox("Copy successful!`n`nContent: " . SubStr(result["content"], 1, 100),
               "Success", "Icon Info")
    } else {
        MsgBox("Copy failed!`n`nError: " . result["error"],
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
    ║           CLIPWAIT OPERATIONS - HOTKEYS                        ║
    ╠════════════════════════════════════════════════════════════════╣
    ║ BASIC OPERATIONS:                                              ║
    ║   F1                  Basic ClipWait demo                      ║
    ║   F2                  Extended timeout demo                    ║
    ║                                                                ║
    ║ COPY WITH RETRY:                                               ║
    ║   Ctrl+Alt+C          Copy with retry                          ║
    ║   Ctrl+Alt+P          Copy with progress                       ║
    ║   Ctrl+Alt+E          Copy with error handler                  ║
    ║                                                                ║
    ║ SAFE COPY:                                                     ║
    ║   Ctrl+Alt+G          Get selected text                        ║
    ║   Ctrl+Alt+W          Copy and count words                     ║
    ║                                                                ║
    ║ MULTI-COPY:                                                    ║
    ║   Ctrl+Alt+3          Copy 3 selections                        ║
    ║   Ctrl+Alt+Shift+C    Collect multiple items                   ║
    ║                                                                ║
    ║ VERIFICATION:                                                  ║
    ║   Ctrl+Alt+V          Copy and verify not empty                ║
    ║   Ctrl+Alt+@          Copy and verify email                    ║
    ║                                                                ║
    ║ ADVANCED:                                                      ║
    ║   Ctrl+Alt+A          Copy entire document                     ║
    ║   Ctrl+Alt+L          Copy current line                        ║
    ║   Ctrl+Alt+D          Copy current word                        ║
    ║   Ctrl+Alt+R          Robust copy demo                         ║
    ║                                                                ║
    ║ F12                   Show this help                           ║
    ╚════════════════════════════════════════════════════════════════╝
    )"

    MsgBox(helpText, "ClipWait Help", "Icon Info")
}
