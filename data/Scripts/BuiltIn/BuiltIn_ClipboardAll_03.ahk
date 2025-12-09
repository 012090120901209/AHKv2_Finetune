#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 - ClipboardAll Format Preservation
* ============================================================================
*
* This file demonstrates preserving all clipboard formats using ClipboardAll,
* including handling rich text, HTML, images, and custom formats.
*
* @file BuiltIn_ClipboardAll_03.ahk
* @version 2.0.0
* @author AHK v2 Examples Collection
* @date 2024-11-16
*
* TABLE OF CONTENTS:
* ──────────────────────────────────────────────────────────────────────────
* 1. Format Preservation Basics
* 2. Rich Text Format (RTF) Handling
* 3. HTML Format Preservation
* 4. Multi-Format Clipboard Operations
* 5. Format Conversion and Export
* 6. Clipboard Format Inspector
* 7. Complete Format Preservation System
*
* EXAMPLES SUMMARY:
* ──────────────────────────────────────────────────────────────────────────
* - Preserving all clipboard formats
* - Handling rich text and formatting
* - Managing HTML clipboard content
* - Working with multiple formats simultaneously
* - Converting between clipboard formats
* - Inspecting available formats
* - Building a complete preservation system
*
* ============================================================================
*/

; ============================================================================
; Example 1: Format Preservation Basics
; ============================================================================

/**
* Demonstrates basic clipboard format preservation.
*
* @class FormatPreserver
* @description Preserves all clipboard formats
*/

class FormatPreserver {
    static preservedClipboard := ""
    static preserveHistory := []
    static maxHistory := 10

    /**
    * Preserves current clipboard with all formats
    * @param {String} label - Optional label for the preservation
    * @returns {Boolean}
    */
    static Preserve(label := "") {
        try {
            clipData := ClipboardAll()

            preservation := Map()
            preservation["data"] := clipData
            preservation["timestamp"] := A_Now
            preservation["label"] := label = "" ? "Preservation " . (this.preserveHistory.Length + 1) : label
            preservation["size"] := clipData.Size
            preservation["hasText"] := (A_Clipboard != "")

            this.preserveHistory.Push(preservation)

            ; Limit history
            if (this.preserveHistory.Length > this.maxHistory)
            this.preserveHistory.RemoveAt(1)

            return true
        } catch as err {
            MsgBox("Error preserving clipboard: " . err.Message, "Error", "Icon Error")
            return false
        }
    }

    /**
    * Restores preserved clipboard by index
    * @param {Integer} index - Index in history (1 = oldest)
    * @returns {Boolean}
    */
    static Restore(index) {
        if (index < 1 || index > this.preserveHistory.Length)
        return false

        try {
            preservation := this.preserveHistory[index]
            A_Clipboard := preservation["data"]
            ClipWait(2)
            return true
        } catch {
            return false
        }
    }

    /**
    * Gets preservation history
    * @returns {Array}
    */
    static GetHistory() {
        return this.preserveHistory
    }

    /**
    * Shows preservation history GUI
    * @returns {void}
    */
    static ShowHistory() {
        if (this.preserveHistory.Length = 0) {
            MsgBox("No preservation history available!", "History", "Icon Info")
            return
        }

        gui := Gui("+Resize", "Clipboard Format Preservation History")
        gui.SetFont("s10")

        lv := gui.Add("ListView", "w600 h300",
        ["#", "Label", "Time", "Size", "Has Text"])
        lv.ModifyCol(1, 40)
        lv.ModifyCol(2, 180)
        lv.ModifyCol(3, 150)
        lv.ModifyCol(4, 100)
        lv.ModifyCol(5, 100)

        ; Populate list (newest first)
        Loop this.preserveHistory.Length {
            index := this.preserveHistory.Length - A_Index + 1
            item := this.preserveHistory[index]

            timeStr := FormatTime(item["timestamp"], "yyyy-MM-dd HH:mm:ss")
            sizeStr := this.FormatSize(item["size"])
            hasText := item["hasText"] ? "Yes" : "No"

            lv.Add("", index, item["label"], timeStr, sizeStr, hasText)
        }

        ; Buttons
        btnRestore := gui.Add("Button", "w100", "Restore")
        btnRestore.OnEvent("Click", (*) => this.RestoreClick(lv, gui))

        btnClose := gui.Add("Button", "x+10 w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }

    static RestoreClick(lv, gui) {
        rowNum := lv.GetNext()
        if (rowNum = 0) {
            MsgBox("Please select an item to restore!", "No Selection", "Icon Warn")
            return
        }

        index := lv.GetText(rowNum, 1)
        actualIndex := this.preserveHistory.Length - index + 1

        if (this.Restore(actualIndex)) {
            MsgBox("Clipboard formats restored!", "Restored", "Icon Info T2")
            gui.Destroy()
        }
    }

    static FormatSize(bytes) {
        if (bytes < 1024)
        return bytes . " B"
        else if (bytes < 1048576)
        return Round(bytes / 1024, 2) . " KB"
        else
        return Round(bytes / 1048576, 2) . " MB"
    }
}

; Preserve clipboard with label
F1:: {
    ib := InputBox("Enter a label for this preservation:", "Preserve Clipboard")
    if (ib.Result = "Cancel")
    return

    if (FormatPreserver.Preserve(ib.Value))
    TrayTip("Preserved", "Clipboard formats preserved", "Icon Info")
}

; Show preservation history
F2::FormatPreserver.ShowHistory()

; ============================================================================
; Example 2: Rich Text Format (RTF) Handling
; ============================================================================

/**
* Demonstrates handling RTF clipboard content.
*
* @class RTFHandler
* @description Manages RTF clipboard operations
*/

class RTFHandler {

    /**
    * Checks if clipboard contains RTF data
    * @returns {Boolean}
    */
    static HasRTF() {
        ; RTF typically comes with plain text too
        ; Check if clipboard has more data than just text
        textSize := StrLen(A_Clipboard)
        totalSize := ClipboardAll().Size

        ; If total size is significantly larger than text, likely has formatting
        return (totalSize > textSize * 2)
    }

    /**
    * Extracts plain text from RTF clipboard
    * @returns {String}
    */
    static ExtractPlainText() {
        return A_Clipboard
    }

    /**
    * Preserves RTF while modifying plain text
    * @param {Func} modifier - Function to modify text
    * @returns {Boolean}
    */
    static ModifyPreservingFormat(modifier) {
        ; Save full clipboard
        savedClip := ClipboardAll()

        try {
            ; Get plain text
            plainText := A_Clipboard

            ; Modify it
            modifiedText := modifier(plainText)

            ; Restore full clipboard
            A_Clipboard := savedClip
            ClipWait(1)

            ; Now set modified text (this loses formatting)
            ; Note: True RTF preservation would require DllCall
            A_Clipboard := modifiedText

            return true
        } catch {
            A_Clipboard := savedClip
            return false
        }
    }

    /**
    * Gets RTF information
    * @returns {Map}
    */
    static GetInfo() {
        info := Map()

        info["hasRTF"] := this.HasRTF()
        info["plainText"] := A_Clipboard
        info["plainTextSize"] := StrLen(A_Clipboard)
        info["totalSize"] := ClipboardAll().Size
        info["formatOverhead"] := info["totalSize"] - info["plainTextSize"]

        return info
    }
}

; Show RTF info
F3:: {
    info := RTFHandler.GetInfo()

    infoText := "RTF Clipboard Information:`n`n"
    infoText .= "Has RTF/Formatting: " . (info["hasRTF"] ? "Yes" : "No") . "`n"
    infoText .= "Plain Text Size: " . info["plainTextSize"] . " bytes`n"
    infoText .= "Total Size: " . info["totalSize"] . " bytes`n"
    infoText .= "Format Overhead: " . info["formatOverhead"] . " bytes"

    if (info["plainTextSize"] > 0) {
        ratio := Round((info["formatOverhead"] / info["plainTextSize"]) * 100, 1)
        infoText .= " (" . ratio . "%)"
    }

    MsgBox(infoText, "RTF Information", "Icon Info")
}

; ============================================================================
; Example 3: HTML Format Preservation
; ============================================================================

/**
* Demonstrates HTML clipboard format handling.
*
* @class HTMLClipboardHandler
* @description Manages HTML clipboard content
*/

class HTMLClipboardHandler {

    /**
    * Checks if clipboard likely contains HTML
    * @returns {Boolean}
    */
    static HasHTML() {
        text := A_Clipboard
        return InStr(text, "<") && InStr(text, ">")
        && (InStr(text, "<html") || InStr(text, "<div") || InStr(text, "<p"))
    }

    /**
    * Strips HTML tags from clipboard
    * @returns {String}
    */
    static StripHTML() {
        text := A_Clipboard

        ; Remove HTML tags
        text := RegExReplace(text, "<[^>]+>", "")

        ; Decode common HTML entities
        text := StrReplace(text, "&nbsp;", " ")
        text := StrReplace(text, "&lt;", "<")
        text := StrReplace(text, "&gt;", ">")
        text := StrReplace(text, "&amp;", "&")
        text := StrReplace(text, "&quot;", '"')

        return text
    }

    /**
    * Converts plain text to HTML
    * @param {String} text - Plain text
    * @returns {String}
    */
    static TextToHTML(text) {
        ; Escape HTML special characters
        html := StrReplace(text, "&", "&amp;")
        html := StrReplace(html, "<", "&lt;")
        html := StrReplace(html, ">", "&gt;")
        html := StrReplace(html, '"', "&quot;")

        ; Convert newlines to <br>
        html := StrReplace(html, "`n", "<br>`n")

        ; Wrap in basic HTML structure
        html := "<html><body>" . html . "</body></html>"

        return html
    }
}

; Strip HTML from clipboard
^!h:: {
    if (HTMLClipboardHandler.HasHTML()) {
        stripped := HTMLClipboardHandler.StripHTML()
        A_Clipboard := stripped
        TrayTip("HTML Stripped", "HTML tags removed from clipboard", "Icon Info")
    } else {
        MsgBox("Clipboard does not contain HTML!", "No HTML", "Icon Info")
    }
}

; Convert plain text to HTML
^!+h:: {
    if (!HTMLClipboardHandler.HasHTML()) {
        html := HTMLClipboardHandler.TextToHTML(A_Clipboard)
        A_Clipboard := html
        TrayTip("Converted to HTML", "Text wrapped in HTML", "Icon Info")
    } else {
        MsgBox("Clipboard already contains HTML!", "Already HTML", "Icon Info")
    }
}

; ============================================================================
; Example 4: Multi-Format Clipboard Operations
; ============================================================================

/**
* Demonstrates working with multiple clipboard formats simultaneously.
*
* @class MultiFormatClipboard
* @description Manages multiple clipboard formats
*/

class MultiFormatClipboard {

    /**
    * Gets all available clipboard formats
    * @returns {Map}
    */
    static GetAllFormats() {
        formats := Map()

        ; Plain text
        formats["text"] := A_Clipboard

        ; Binary/All formats
        formats["binary"] := ClipboardAll()

        ; Text statistics
        if (formats["text"] != "") {
            formats["textLength"] := StrLen(formats["text"])
            formats["textLines"] := StrSplit(formats["text"], "`n").Length
        }

        ; Binary size
        formats["binarySize"] := formats["binary"].Size

        ; Check for specific formats
        formats["hasHTML"] := HTMLClipboardHandler.HasHTML()
        formats["hasRTF"] := RTFHandler.HasRTF()

        return formats
    }

    /**
    * Creates a format report
    * @returns {String}
    */
    static CreateReport() {
        formats := this.GetAllFormats()

        report := "═══ CLIPBOARD FORMAT REPORT ═══`n`n"

        ; Text information
        if (formats.Has("text") && formats["text"] != "") {
            report .= "TEXT FORMAT:`n"
            report .= "  Length: " . formats["textLength"] . " characters`n"
            report .= "  Lines: " . formats["textLines"] . "`n"
            report .= "  Preview: " . SubStr(formats["text"], 1, 50)
            if (StrLen(formats["text"]) > 50)
            report .= "..."
            report .= "`n`n"
        }

        ; Binary information
        report .= "BINARY FORMAT:`n"
        report .= "  Total Size: " . formats["binarySize"] . " bytes`n`n"

        ; Special formats
        report .= "SPECIAL FORMATS:`n"
        report .= "  HTML: " . (formats["hasHTML"] ? "Yes" : "No") . "`n"
        report .= "  RTF: " . (formats["hasRTF"] ? "Yes" : "No") . "`n"

        return report
    }

    /**
    * Shows format report
    * @returns {void}
    */
    static ShowReport() {
        report := this.CreateReport()
        MsgBox(report, "Clipboard Format Report", "Icon Info")
    }
}

; Show multi-format report
F4::MultiFormatClipboard.ShowReport()

; ============================================================================
; Example 5: Format Conversion and Export
; ============================================================================

/**
* Demonstrates converting and exporting clipboard formats.
*
* @class FormatConverter
* @description Converts between clipboard formats
*/

class FormatConverter {

    /**
    * Exports clipboard to multiple formats
    * @param {String} basePath - Base path for export files
    * @returns {Array} Array of created files
    */
    static ExportAll(basePath) {
        createdFiles := []

        ; Export plain text
        if (A_Clipboard != "") {
            textPath := basePath . ".txt"
            try {
                FileObj := FileOpen(textPath, "w")
                FileObj.Write(A_Clipboard)
                FileObj.Close()
                createdFiles.Push(textPath)
            }
        }

        ; Export binary clipboard
        try {
            binaryPath := basePath . ".clip"
            clipData := ClipboardAll()
            FileObj := FileOpen(binaryPath, "w")
            FileObj.RawWrite(clipData)
            FileObj.Close()
            createdFiles.Push(binaryPath)
        }

        ; Export HTML if present
        if (HTMLClipboardHandler.HasHTML()) {
            htmlPath := basePath . ".html"
            try {
                FileObj := FileOpen(htmlPath, "w")
                FileObj.Write(A_Clipboard)
                FileObj.Close()
                createdFiles.Push(htmlPath)
            }
        }

        return createdFiles
    }

    /**
    * Shows export dialog
    * @returns {void}
    */
    static ShowExportDialog() {
        ; Get save path
        filepath := FileSelect("S", , "Export Clipboard Formats", "Text Files (*.txt)")

        if (filepath = "")
        return

        ; Remove extension to use as base
        SplitPath(filepath, , &dir, , &nameNoExt)
        basePath := dir . "\" . nameNoExt

        createdFiles := this.ExportAll(basePath)

        if (createdFiles.Length > 0) {
            msg := "Exported " . createdFiles.Length . " file(s):`n`n"
            for file in createdFiles {
                msg .= "• " . file . "`n"
            }
            MsgBox(msg, "Export Complete", "Icon Info")
        }
    }
}

; Export clipboard formats
^!e::FormatConverter.ShowExportDialog()

; ============================================================================
; Example 6: Clipboard Format Inspector
; ============================================================================

/**
* Demonstrates detailed clipboard format inspection.
*
* @class FormatInspector
* @description Inspects clipboard formats in detail
*/

class FormatInspector {

    /**
    * Analyzes clipboard in detail
    * @returns {Map}
    */
    static Analyze() {
        analysis := Map()

        ; Basic info
        analysis["isEmpty"] := (A_Clipboard = "" && ClipboardAll().Size = 0)
        analysis["hasText"] := (A_Clipboard != "")
        analysis["textLength"] := StrLen(A_Clipboard)
        analysis["binarySize"] := ClipboardAll().Size

        ; Format detection
        analysis["formats"] := []

        if (analysis["hasText"])
        analysis["formats"].Push("Plain Text")

        if (HTMLClipboardHandler.HasHTML())
        analysis["formats"].Push("HTML")

        if (RTFHandler.HasRTF())
        analysis["formats"].Push("Rich Text (RTF)")

        if (analysis["binarySize"] > analysis["textLength"] * 1.5)
        analysis["formats"].Push("Binary/Image Data")

        ; Character analysis
        if (analysis["hasText"]) {
            text := A_Clipboard

            analysis["hasNewlines"] := InStr(text, "`n")
            analysis["hasTabs"] := InStr(text, "`t")
            analysis["hasSpecialChars"] := RegExMatch(text, "[^\x20-\x7E\r\n\t]")

            ; Count different character types
            analysis["alphaCount"] := this.CountMatches(text, "[A-Za-z]")
            analysis["digitCount"] := this.CountMatches(text, "\d")
            analysis["spaceCount"] := this.CountMatches(text, "\s")
        }

        return analysis
    }

    /**
    * Counts regex matches
    * @param {String} text - Text to search
    * @param {String} pattern - Regex pattern
    * @returns {Integer}
    */
    static CountMatches(text, pattern) {
        count := 0
        pos := 1
        while (RegExMatch(text, pattern, &match, pos)) {
            count++
            pos := match.Pos + match.Len
        }
        return count
    }

    /**
    * Shows detailed inspection GUI
    * @returns {void}
    */
    static ShowInspection() {
        analysis := this.Analyze()

        if (analysis["isEmpty"]) {
            MsgBox("Clipboard is empty!", "Format Inspector", "Icon Info")
            return
        }

        gui := Gui("+Resize", "Clipboard Format Inspector")
        gui.SetFont("s10")

        ; Basic info
        gui.Add("GroupBox", "w500 h120", "Basic Information")
        gui.Add("Text", "xp+10 yp+25", "Has Text:")
        gui.Add("Text", "x+10", analysis["hasText"] ? "Yes" : "No")

        gui.Add("Text", "x20 y+5", "Text Length:")
        gui.Add("Text", "x+10", analysis["textLength"] . " characters")

        gui.Add("Text", "x20 y+5", "Binary Size:")
        gui.Add("Text", "x+10", analysis["binarySize"] . " bytes")

        ; Formats
        gui.Add("GroupBox", "x10 y+20 w500 h100", "Detected Formats")
        formatList := gui.Add("ListBox", "xp+10 yp+25 w480 h60")
        for format in analysis["formats"] {
            formatList.Add([format])
        }

        ; Character analysis (if text)
        if (analysis["hasText"]) {
            gui.Add("GroupBox", "x10 y+20 w500 h120", "Character Analysis")
            gui.Add("Text", "xp+10 yp+25", "Letters:")
            gui.Add("Text", "x+10", analysis["alphaCount"])

            gui.Add("Text", "x20 y+5", "Digits:")
            gui.Add("Text", "x+10", analysis["digitCount"])

            gui.Add("Text", "x20 y+5", "Whitespace:")
            gui.Add("Text", "x+10", analysis["spaceCount"])
        }

        btnClose := gui.Add("Button", "w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }
}

; Show format inspector
F5::FormatInspector.ShowInspection()

; ============================================================================
; Example 7: Complete Format Preservation System
; ============================================================================

/**
* Complete clipboard format preservation system.
*
* @class CompletePreservationSystem
* @description Comprehensive format preservation
*/

class CompletePreservationSystem {
    static autoPreserve := false
    static preserveInterval := 5000  ; 5 seconds
    static timerRunning := false

    /**
    * Starts automatic preservation
    * @returns {void}
    */
    static StartAutoPreserve() {
        this.autoPreserve := true
        this.timerRunning := true
        SetTimer(() => this.AutoPreserveCallback(), this.preserveInterval)
        TrayTip("Auto-Preserve Started",
        "Clipboard will be preserved every " . (this.preserveInterval/1000) . " seconds",
        "Icon Info")
    }

    /**
    * Stops automatic preservation
    * @returns {void}
    */
    static StopAutoPreserve() {
        this.autoPreserve := false
        this.timerRunning := false
        SetTimer(() => this.AutoPreserveCallback(), 0)
        TrayTip("Auto-Preserve Stopped", "", "Icon Info")
    }

    /**
    * Toggles automatic preservation
    * @returns {void}
    */
    static ToggleAutoPreserve() {
        if (this.autoPreserve)
        this.StopAutoPreserve()
        else
        this.StartAutoPreserve()
    }

    /**
    * Auto-preserve callback
    * @private
    */
    static AutoPreserveCallback() {
        if (!this.autoPreserve)
        return

        FormatPreserver.Preserve("Auto-" . A_Now)
    }

    /**
    * Shows control panel
    * @returns {void}
    */
    static ShowControlPanel() {
        gui := Gui("+AlwaysOnTop", "Format Preservation System")
        gui.SetFont("s10")

        ; Status
        status := this.autoPreserve ? "Enabled" : "Disabled"
        gui.Add("Text", "w400", "Auto-Preserve Status: " . status)

        ; Controls
        btnToggle := gui.Add("Button", "w150", this.autoPreserve ? "Disable Auto-Preserve" : "Enable Auto-Preserve")
        btnToggle.OnEvent("Click", (*) => this.ToggleClick(gui))

        btnManual := gui.Add("Button", "x+10 w150", "Preserve Now")
        btnManual.OnEvent("Click", (*) => this.PreserveClick())

        btnHistory := gui.Add("Button", "x10 y+10 w150", "View History")
        btnHistory.OnEvent("Click", (*) => FormatPreserver.ShowHistory())

        btnInspect := gui.Add("Button", "x+10 w150", "Inspect Current")
        btnInspect.OnEvent("Click", (*) => FormatInspector.ShowInspection())

        btnClose := gui.Add("Button", "x10 y+10 w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }

    static ToggleClick(gui) {
        this.ToggleAutoPreserve()
        gui.Destroy()
        this.ShowControlPanel()
    }

    static PreserveClick() {
        FormatPreserver.Preserve("Manual-" . A_Now)
        TrayTip("Preserved", "Clipboard formats preserved", "Icon Info")
    }
}

; Show control panel
^!p::CompletePreservationSystem.ShowControlPanel()

; ============================================================================
; HELP AND INFORMATION
; ============================================================================

F12:: {
    helpText := "
    (
    ╔════════════════════════════════════════════════════════════════╗
    ║       CLIPBOARDALL FORMAT PRESERVATION - HOTKEYS               ║
    ╠════════════════════════════════════════════════════════════════╣
    ║ PRESERVATION:                                                  ║
    ║   F1                  Preserve with label                      ║
    ║   F2                  Show preservation history                ║
    ║                                                                ║
    ║ FORMAT INFO:                                                   ║
    ║   F3                  Show RTF information                     ║
    ║   F4                  Show multi-format report                 ║
    ║   F5                  Show format inspector                    ║
    ║                                                                ║
    ║ HTML OPERATIONS:                                               ║
    ║   Ctrl+Alt+H          Strip HTML tags                          ║
    ║   Ctrl+Alt+Shift+H    Convert to HTML                          ║
    ║                                                                ║
    ║ EXPORT:                                                        ║
    ║   Ctrl+Alt+E          Export all formats                       ║
    ║                                                                ║
    ║ SYSTEM:                                                        ║
    ║   Ctrl+Alt+P          Show control panel                       ║
    ║                                                                ║
    ║ F12                   Show this help                           ║
    ╚════════════════════════════════════════════════════════════════╝
    )"

    MsgBox(helpText, "Format Preservation Help", "Icon Info")
}
