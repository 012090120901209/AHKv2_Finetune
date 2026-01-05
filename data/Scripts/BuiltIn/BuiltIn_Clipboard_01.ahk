#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 - A_Clipboard Read/Write Operations
 * ============================================================================
 * 
 * This file demonstrates comprehensive usage of the A_Clipboard built-in
 * variable for reading and writing clipboard content in AutoHotkey v2.
 * 
 * A_Clipboard is a built-in variable that provides access to the Windows
 * clipboard as plain text. It can be used to read or write text content.
 * 
 * @file BuiltIn_Clipboard_01.ahk
 * @version 2.0.0
 * @author AHK v2 Examples Collection
 * @date 2024-11-16
 * 
 * TABLE OF CONTENTS:
 * ──────────────────────────────────────────────────────────────────────────
 * 1. Basic Read/Write Operations
 * 2. Clipboard Backup and Restore
 * 3. Text Appending to Clipboard
 * 4. Clipboard Clear Operations
 * 5. Multi-line Text Handling
 * 6. Clipboard Content Transformation
 * 7. Smart Clipboard Manager
 * 
 * EXAMPLES SUMMARY:
 * ──────────────────────────────────────────────────────────────────────────
 * - Reading current clipboard content
 * - Writing new content to clipboard
 * - Backing up and restoring clipboard
 * - Appending text to existing clipboard content
 * - Clearing clipboard content
 * - Handling multi-line clipboard data
 * - Transforming clipboard content (uppercase, lowercase, etc.)
 * - Building a simple clipboard manager with hotkeys
 * 
 * ============================================================================
 */

; ============================================================================
; Example 1: Basic Clipboard Read and Write
; ============================================================================

/**
 * Demonstrates basic reading from and writing to the clipboard.
 * 
 * @function Example1_BasicReadWrite
 * @description Shows how to read current clipboard content and write new content
 * @hotkey F1 - Read and display current clipboard content
 * @hotkey F2 - Write sample text to clipboard
 * @returns {void}
 */

; Read clipboard content
F1:: {
    ; Check if clipboard contains text
    if (A_Clipboard != "") {
        clipContent := A_Clipboard
        MsgBox("Current Clipboard Content:`n`n" . clipContent,
            "Clipboard Reader", "Icon Info T5")
    } else {
        MsgBox("Clipboard is empty or contains non-text data.",
            "Clipboard Reader", "Icon Warn T3")
    }
}

; Write to clipboard
F2:: {
    A_Clipboard := "This is sample text written to clipboard at " . A_Now
    TrayTip("Clipboard Updated", "New text has been written to clipboard",
        "Icon Info")
}

; ============================================================================
; Example 2: Clipboard Backup and Restore
; ============================================================================

/**
 * Demonstrates backing up clipboard content before operations and restoring it.
 * 
 * @class ClipboardBackup
 * @description Manages clipboard backup and restore operations
 */

class ClipboardBackup {
    static backupText := ""

    /**
     * Backs up current clipboard content
     * @returns {String} The backed up content
     */
    static Backup() {
        this.backupText := A_Clipboard
        return this.backupText
    }

    /**
     * Restores previously backed up clipboard content
     * @returns {void}
     */
    static Restore() {
        A_Clipboard := this.backupText
    }

    /**
     * Checks if backup exists
     * @returns {Boolean}
     */
    static HasBackup() {
        return (this.backupText != "")
    }
}

; Backup clipboard
F3:: {
    ClipboardBackup.Backup()
    MsgBox("Clipboard content backed up successfully!",
        "Backup", "Icon Info T2")
}

; Restore clipboard
F4:: {
    if (ClipboardBackup.HasBackup()) {
        ClipboardBackup.Restore()
        MsgBox("Clipboard restored from backup!",
            "Restore", "Icon Info T2")
    } else {
        MsgBox("No backup available!", "Restore", "Icon Warn T2")
    }
}

; ============================================================================
; Example 3: Text Appending to Clipboard
; ============================================================================

/**
 * Demonstrates appending new text to existing clipboard content.
 * 
 * @function Example3_AppendToClipboard
 * @description Appends text to clipboard with various separators
 * @hotkey ^!a - Append text with newline
 * @hotkey ^!s - Append text with space
 * @returns {void}
 */

; Append with newline
^!a:: {
    currentText := A_Clipboard

    ; Get text to append
    ib := InputBox("Enter text to append to clipboard (with newline):",
        "Append to Clipboard")
    if (ib.Result = "Cancel")
        return

    ; Append with newline
    A_Clipboard := currentText . "`n" . ib.Value
    TrayTip("Text Appended", "New text added to clipboard with newline",
        "Icon Info")
}

; Append with space
^!s:: {
    currentText := A_Clipboard

    ; Get text to append
    ib := InputBox("Enter text to append to clipboard (with space):",
        "Append to Clipboard")
    if (ib.Result = "Cancel")
        return

    ; Append with space
    A_Clipboard := currentText . " " . ib.Value
    TrayTip("Text Appended", "New text added to clipboard with space",
        "Icon Info")
}

; ============================================================================
; Example 4: Clipboard Clear Operations
; ============================================================================

/**
 * Demonstrates various methods to clear clipboard content.
 * 
 * @function Example4_ClearClipboard
 * @description Shows different ways to empty the clipboard
 * @hotkey ^!c - Clear clipboard (set to empty string)
 * @hotkey ^!x - Clear clipboard with confirmation
 * @returns {void}
 */

; Clear clipboard instantly
^!c:: {
    A_Clipboard := ""
    TrayTip("Clipboard Cleared", "Clipboard has been emptied", "Icon Info")
}

; Clear clipboard with confirmation
^!x:: {
    result := MsgBox("Are you sure you want to clear the clipboard?",
        "Confirm Clear", "YesNo Icon Question")
    if (result = "Yes") {
        A_Clipboard := ""
        MsgBox("Clipboard cleared successfully!", "Cleared", "Icon Info T2")
    }
}

; ============================================================================
; Example 5: Multi-line Text Handling
; ============================================================================

/**
 * Demonstrates handling multi-line text in clipboard.
 * 
 * @function Example5_MultiLineHandling
 * @description Processes multi-line clipboard content
 * @hotkey ^!l - Count lines in clipboard
 * @hotkey ^!n - Number lines in clipboard
 * @returns {void}
 */

; Count lines in clipboard
^!l:: {
    if (A_Clipboard = "") {
        MsgBox("Clipboard is empty!", "Line Counter", "Icon Warn")
        return
    }

    ; Split by newline and count
    lines := StrSplit(A_Clipboard, "`n")
    lineCount := lines.Length

    ; Count non-empty lines
    nonEmptyCount := 0
    for line in lines {
        if (Trim(line) != "")
            nonEmptyCount++
    }

    MsgBox("Total Lines: " . lineCount . "`n"
        . "Non-Empty Lines: " . nonEmptyCount,
        "Line Counter", "Icon Info")
}

; Number lines in clipboard
^!n:: {
    if (A_Clipboard = "") {
        MsgBox("Clipboard is empty!", "Line Numberer", "Icon Warn")
        return
    }

    lines := StrSplit(A_Clipboard, "`n")
    numberedLines := []

    for index, line in lines {
        numberedLines.Push(index . ". " . line)
    }

    ; Join back with newlines
    A_Clipboard := ""
    for numberedLine in numberedLines {
        A_Clipboard .= numberedLine . "`n"
    }

    ; Remove trailing newline
    A_Clipboard := RTrim(A_Clipboard, "`n")

    TrayTip("Lines Numbered", "Clipboard lines have been numbered",
        "Icon Info")
}

; ============================================================================
; Example 6: Clipboard Content Transformation
; ============================================================================

/**
 * Demonstrates transforming clipboard content.
 * 
 * @class ClipboardTransformer
 * @description Provides various text transformation operations
 */

class ClipboardTransformer {

    /**
     * Converts clipboard text to uppercase
     * @returns {void}
     */
    static ToUpperCase() {
        if (A_Clipboard != "") {
            A_Clipboard := StrUpper(A_Clipboard)
            TrayTip("Transformed", "Text converted to UPPERCASE", "Icon Info")
        }
    }

    /**
     * Converts clipboard text to lowercase
     * @returns {void}
     */
    static ToLowerCase() {
        if (A_Clipboard != "") {
            A_Clipboard := StrLower(A_Clipboard)
            TrayTip("Transformed", "Text converted to lowercase", "Icon Info")
        }
    }

    /**
     * Converts clipboard text to title case
     * @returns {void}
     */
    static ToTitleCase() {
        if (A_Clipboard != "") {
            A_Clipboard := StrTitle(A_Clipboard)
            TrayTip("Transformed", "Text converted to Title Case", "Icon Info")
        }
    }

    /**
     * Reverses clipboard text
     * @returns {void}
     */
    static Reverse() {
        if (A_Clipboard != "") {
            reversed := ""
            Loop Parse, A_Clipboard {
                reversed := A_LoopField . reversed
            }
            A_Clipboard := reversed
            TrayTip("Transformed", "Text has been reversed", "Icon Info")
        }
    }

    /**
     * Removes extra whitespace from clipboard
     * @returns {void}
     */
    static TrimWhitespace() {
        if (A_Clipboard != "") {
            ; Remove leading/trailing whitespace from each line
            lines := StrSplit(A_Clipboard, "`n")
            trimmedLines := []

            for line in lines {
                trimmed := Trim(line)
                if (trimmed != "")
                    trimmedLines.Push(trimmed)
            }

            A_Clipboard := ""
            for line in trimmedLines {
                A_Clipboard .= line . "`n"
            }
            A_Clipboard := RTrim(A_Clipboard, "`n")

            TrayTip("Transformed", "Whitespace trimmed", "Icon Info")
        }
    }
}

; Hotkeys for transformations
^!u:: ClipboardTransformer.ToUpperCase()      ; Ctrl+Alt+U - Uppercase
^!j:: ClipboardTransformer.ToLowerCase()      ; Ctrl+Alt+J - Lowercase
^!t:: ClipboardTransformer.ToTitleCase()      ; Ctrl+Alt+T - Title Case
^!r:: ClipboardTransformer.Reverse()          ; Ctrl+Alt+R - Reverse
^!w:: ClipboardTransformer.TrimWhitespace()   ; Ctrl+Alt+W - Trim

; ============================================================================
; Example 7: Smart Clipboard Manager
; ============================================================================

/**
 * Demonstrates a comprehensive clipboard manager with multiple features.
 * 
 * @class SmartClipboardManager
 * @description Advanced clipboard manager with history and utilities
 */

class SmartClipboardManager {
    static history := []
    static maxHistory := 10

    /**
     * Adds current clipboard to history
     * @returns {void}
     */
    static AddToHistory() {
        if (A_Clipboard != "" && !this.IsInHistory(A_Clipboard)) {
            this.history.Push(A_Clipboard)

            ; Keep only last maxHistory items
            if (this.history.Length > this.maxHistory) {
                this.history.RemoveAt(1)
            }
        }
    }

    /**
     * Checks if text is already in history
     * @param {String} text - Text to check
     * @returns {Boolean}
     */
    static IsInHistory(text) {
        for item in this.history {
            if (item = text)
                return true
        }
        return false
    }

    /**
     * Shows clipboard history in a GUI
     * @returns {void}
     */
    static ShowHistory() {
        if (this.history.Length = 0) {
            MsgBox("No clipboard history available!",
                "Clipboard History", "Icon Info")
            return
        }

        ; Create GUI
        historyGui := Gui("+Resize", "Clipboard History")
        historyGui.SetFont("s10")

        ; Add list view
        lv := historyGui.Add("ListView", "w600 h400", ["#", "Preview"])
        lv.ModifyCol(1, 50)
        lv.ModifyCol(2, 530)

        ; Populate history (newest first)
        Loop this.history.Length {
            index := this.history.Length - A_Index + 1
            item := this.history[index]
            preview := StrLen(item) > 100 ? SubStr(item, 1, 100) . "..." : item
            preview := StrReplace(preview, "`n", " ")
            lv.Add("", index, preview)
        }

        ; Add buttons
        btnRestore := historyGui.Add("Button", "w100", "Restore")
        btnRestore.OnEvent("Click", (*) => this.RestoreFromHistory(lv, historyGui))

        btnClear := historyGui.Add("Button", "x+10 w100", "Clear History")
        btnClear.OnEvent("Click", (*) => this.ClearHistory(historyGui))

        btnClose := historyGui.Add("Button", "x+10 w100", "Close")
        btnClose.OnEvent("Click", (*) => historyGui.Destroy())

        historyGui.Show()
    }

    /**
     * Restores selected item from history
     * @param {Object} lv - ListView control
     * @param {Object} gui - GUI object
     * @returns {void}
     */
    static RestoreFromHistory(lv, gui) {
        rowNum := lv.GetNext()
        if (rowNum = 0) {
            MsgBox("Please select an item to restore!",
                "No Selection", "Icon Warn")
            return
        }

        index := lv.GetText(rowNum, 1)
        actualIndex := this.history.Length - index + 1
        A_Clipboard := this.history[actualIndex]

        MsgBox("Clipboard restored from history!", "Restored", "Icon Info T2")
        gui.Destroy()
    }

    /**
     * Clears clipboard history
     * @param {Object} gui - GUI object
     * @returns {void}
     */
    static ClearHistory(gui) {
        result := MsgBox("Clear all clipboard history?",
            "Confirm", "YesNo Icon Question")
        if (result = "Yes") {
            this.history := []
            gui.Destroy()
            MsgBox("History cleared!", "Cleared", "Icon Info T2")
        }
    }

    /**
     * Gets clipboard statistics
     * @returns {String}
     */
    static GetStats() {
        if (A_Clipboard = "") {
            return "Clipboard is empty"
        }

        charCount := StrLen(A_Clipboard)
        wordCount := 0
        lineCount := 0

        ; Count words
        Loop Parse, A_Clipboard, " `t`n`r" {
            if (A_LoopField != "")
                wordCount++
        }

        ; Count lines
        lines := StrSplit(A_Clipboard, "`n")
        lineCount := lines.Length

        return "Characters: " . charCount
            . "`nWords: " . wordCount
            . "`nLines: " . lineCount
            . "`nHistory Items: " . this.history.Length
    }
}

; Hotkeys for Smart Clipboard Manager
^!h:: SmartClipboardManager.ShowHistory()     ; Ctrl+Alt+H - Show history
^!i:: SmartClipboardManager.AddToHistory()    ; Ctrl+Alt+I - Add to history

; Show clipboard statistics
^!g:: {
    stats := SmartClipboardManager.GetStats()
    MsgBox(stats, "Clipboard Statistics", "Icon Info")
}

; ============================================================================
; HELP AND INFORMATION
; ============================================================================

; Show help with all hotkeys
F12:: {
    helpText := "
    (
    ╔═══════════════════════════════════════════════════════════════╗
    ║           CLIPBOARD READ/WRITE OPERATIONS - HOTKEYS           ║
    ╠═══════════════════════════════════════════════════════════════╣
    ║                                                               ║
    ║ BASIC OPERATIONS:                                             ║
    ║   F1                  Read and display clipboard              ║
    ║   F2                  Write sample text to clipboard          ║
    ║   F3                  Backup clipboard                        ║
    ║   F4                  Restore clipboard from backup           ║
    ║                                                               ║
    ║ APPEND OPERATIONS:                                            ║
    ║   Ctrl+Alt+A          Append text with newline                ║
    ║   Ctrl+Alt+S          Append text with space                  ║
    ║                                                               ║
    ║ CLEAR OPERATIONS:                                             ║
    ║   Ctrl+Alt+C          Clear clipboard instantly               ║
    ║   Ctrl+Alt+X          Clear clipboard with confirmation       ║
    ║                                                               ║
    ║ MULTI-LINE OPERATIONS:                                        ║
    ║   Ctrl+Alt+L          Count lines in clipboard                ║
    ║   Ctrl+Alt+N          Number lines in clipboard               ║
    ║                                                               ║
    ║ TRANSFORMATIONS:                                              ║
    ║   Ctrl+Alt+U          Convert to UPPERCASE                    ║
    ║   Ctrl+Alt+J          Convert to lowercase                    ║
    ║   Ctrl+Alt+T          Convert to Title Case                   ║
    ║   Ctrl+Alt+R          Reverse text                            ║
    ║   Ctrl+Alt+W          Trim whitespace                         ║
    ║                                                               ║
    ║ CLIPBOARD MANAGER:                                            ║
    ║   Ctrl+Alt+H          Show clipboard history                  ║
    ║   Ctrl+Alt+I          Add current to history                  ║
    ║   Ctrl+Alt+G          Show clipboard statistics               ║
    ║                                                               ║
    ║ HELP:                                                         ║
    ║   F12                 Show this help                          ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
    )"

    MsgBox(helpText, "Clipboard Operations Help", "Icon Info")
}
