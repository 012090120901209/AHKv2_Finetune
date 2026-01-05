#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 - ClipboardAll Binary Clipboard Operations
 * ============================================================================
 * 
 * This file demonstrates advanced binary clipboard operations using
 * ClipboardAll, including working with images, files, and custom formats.
 * 
 * @file BuiltIn_ClipboardAll_02.ahk
 * @version 2.0.0
 * @author AHK v2 Examples Collection
 * @date 2024-11-16
 * 
 * TABLE OF CONTENTS:
 * ──────────────────────────────────────────────────────────────────────────
 * 1. Binary Data Operations
 * 2. Image Clipboard Handling
 * 3. File Clipboard Operations
 * 4. Custom Format Detection
 * 5. Clipboard Size Analysis
 * 6. Binary Clipboard Comparison
 * 7. Advanced Binary Operations
 * 
 * EXAMPLES SUMMARY:
 * ──────────────────────────────────────────────────────────────────────────
 * - Working with binary clipboard data
 * - Detecting and handling images
 * - Managing file clipboard operations
 * - Detecting custom clipboard formats
 * - Analyzing clipboard size and content
 * - Comparing clipboard states
 * - Performing advanced binary operations
 * 
 * ============================================================================
 */

; ============================================================================
; Example 1: Binary Data Operations
; ============================================================================

/**
 * Demonstrates basic binary clipboard operations.
 * 
 * @class BinaryClipboardOps
 * @description Handles binary clipboard data
 */

class BinaryClipboardOps {

    /**
     * Gets clipboard as binary data
     * @returns {ClipboardAll}
     */
    static GetBinary() {
        return ClipboardAll()
    }

    /**
     * Sets clipboard from binary data
     * @param {ClipboardAll} binaryData - Binary clipboard data
     * @returns {Boolean}
     */
    static SetBinary(binaryData) {
        try {
            A_Clipboard := binaryData
            ClipWait(2)
            return true
        } catch {
            return false
        }
    }

    /**
     * Checks if clipboard has binary data (non-text)
     * @returns {Boolean}
     */
    static HasBinaryData() {
        clipData := ClipboardAll()
        ; If ClipboardAll has data but A_Clipboard is empty, it's binary
        return (Type(clipData) = "ClipboardAll" && A_Clipboard = "")
    }

    /**
     * Gets size of clipboard data in bytes
     * @returns {Integer}
     */
    static GetSize() {
        try {
            clipData := ClipboardAll()
            return clipData.Size
        } catch {
            return 0
        }
    }

    /**
     * Creates a clipboard info map
     * @returns {Map}
     */
    static GetInfo() {
        info := Map()
        info["hasText"] := (A_Clipboard != "")
        info["hasBinary"] := this.HasBinaryData()
        info["size"] := this.GetSize()
        info["sizeFormatted"] := this.FormatSize(info["size"])

        return info
    }

    /**
     * Formats byte size to human-readable format
     * @param {Integer} bytes - Size in bytes
     * @returns {String}
     */
    static FormatSize(bytes) {
        if (bytes < 1024)
            return bytes . " bytes"
        else if (bytes < 1048576)
            return Round(bytes / 1024, 2) . " KB"
        else if (bytes < 1073741824)
            return Round(bytes / 1048576, 2) . " MB"
        else
            return Round(bytes / 1073741824, 2) . " GB"
    }
}

; Show clipboard binary info
F1:: {
    info := BinaryClipboardOps.GetInfo()

    infoText := "Clipboard Binary Information:`n`n"
    infoText .= "Has Text: " . (info["hasText"] ? "Yes" : "No") . "`n"
    infoText .= "Has Binary Data: " . (info["hasBinary"] ? "Yes" : "No") . "`n"
    infoText .= "Total Size: " . info["sizeFormatted"]

    MsgBox(infoText, "Binary Clipboard Info", "Icon Info")
}

; ============================================================================
; Example 2: Image Clipboard Handling
; ============================================================================

/**
 * Demonstrates handling images in the clipboard.
 * 
 * @class ImageClipboardHandler
 * @description Detects and manages clipboard images
 */

class ImageClipboardHandler {

    /**
     * Checks if clipboard contains an image
     * @returns {Boolean}
     */
    static HasImage() {
        ; If clipboard has binary data but no text, likely an image
        ; Could also check for specific clipboard formats
        return (A_Clipboard = "" && BinaryClipboardOps.GetSize() > 0)
    }

    /**
     * Saves clipboard image to file
     * @param {String} filepath - Path to save image
     * @returns {Boolean}
     */
    static SaveImage(filepath) {
        if (!this.HasImage())
            return false

        try {
            clipData := ClipboardAll()

            ; Save to file
            FileObj := FileOpen(filepath, "w")
            FileObj.RawWrite(clipData)
            FileObj.Close()

            return true
        } catch as err {
            MsgBox("Error saving image: " . err.Message, "Error", "Icon Error")
            return false
        }
    }

    /**
     * Loads image from file to clipboard
     * @param {String} filepath - Path to image file
     * @returns {Boolean}
     */
    static LoadImage(filepath) {
        if (!FileExist(filepath))
            return false

        try {
            ; Read binary file
            FileObj := FileOpen(filepath, "r")
            clipData := ClipboardAll()
            clipData := FileObj.RawRead()
            FileObj.Close()

            ; Set to clipboard
            A_Clipboard := clipData
            ClipWait(2)

            return true
        } catch as err {
            MsgBox("Error loading image: " . err.Message, "Error", "Icon Error")
            return false
        }
    }

    /**
     * Shows image save dialog
     * @returns {void}
     */
    static ShowSaveDialog() {
        if (!this.HasImage()) {
            MsgBox("Clipboard does not contain an image!",
                "No Image", "Icon Warn")
            return
        }

        ; Get save path
        filepath := FileSelect("S", , "Save Clipboard Image", "Clipboard Files (*.clip)")

        if (filepath = "")
            return

        ; Add extension if not present
        if (!InStr(filepath, "."))
            filepath .= ".clip"

        if (this.SaveImage(filepath)) {
            MsgBox("Image saved to:`n" . filepath, "Saved", "Icon Info T3")
        }
    }
}

; Save clipboard image
^!i:: ImageClipboardHandler.ShowSaveDialog()

; ============================================================================
; Example 3: File Clipboard Operations
; ============================================================================

/**
 * Demonstrates working with file clipboard data.
 * 
 * @class FileClipboardHandler
 * @description Handles files in clipboard
 */

class FileClipboardHandler {

    /**
     * Gets list of files from clipboard
     * @returns {Array}
     */
    static GetFileList() {
        files := []

        try {
            ; Try to get files from clipboard
            Loop Parse, A_Clipboard, "`n", "`r" {
                if (FileExist(A_LoopField))
                    files.Push(A_LoopField)
            }
        }

        return files
    }

    /**
     * Checks if clipboard contains files
     * @returns {Boolean}
     */
    static HasFiles() {
        return this.GetFileList().Length > 0
    }

    /**
     * Gets file information from clipboard
     * @returns {Map}
     */
    static GetFileInfo() {
        info := Map()
        files := this.GetFileList()

        info["count"] := files.Length
        info["files"] := files
        info["totalSize"] := 0

        for filepath in files {
            if (FileExist(filepath) && !InStr(FileExist(filepath), "D"))
                info["totalSize"] += FileGetSize(filepath)
        }

        info["totalSizeFormatted"] := BinaryClipboardOps.FormatSize(info["totalSize"])

        return info
    }

    /**
     * Shows file clipboard info
     * @returns {void}
     */
    static ShowInfo() {
        if (!this.HasFiles()) {
            MsgBox("Clipboard does not contain files!",
                "No Files", "Icon Info")
            return
        }

        info := this.GetFileInfo()

        gui := Gui("+Resize", "Clipboard Files")
        gui.SetFont("s10")

        gui.Add("Text", "w500",
            "Files in Clipboard: " . info["count"] . "`n"
            . "Total Size: " . info["totalSizeFormatted"])

        lv := gui.Add("ListView", "w500 h300", ["Filename", "Size", "Type"])
        lv.ModifyCol(1, 250)
        lv.ModifyCol(2, 100)
        lv.ModifyCol(3, 130)

        for filepath in info["files"] {
            SplitPath(filepath, &name, , &ext)
            size := BinaryClipboardOps.FormatSize(FileGetSize(filepath))
            fileType := InStr(FileExist(filepath), "D") ? "Directory" : "File"

            lv.Add("", name, size, fileType)
        }

        btnClose := gui.Add("Button", "w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }
}

; Show file clipboard info
^!f:: FileClipboardHandler.ShowInfo()

; ============================================================================
; Example 4: Custom Format Detection
; ============================================================================

/**
 * Demonstrates detecting clipboard formats.
 * 
 * @class ClipboardFormatDetector
 * @description Detects various clipboard formats
 */

class ClipboardFormatDetector {

    /**
     * Detects clipboard content type
     * @returns {String}
     */
    static DetectType() {
        ; Check for text
        if (A_Clipboard != "")
            return "Text"

        ; Check for files
        if (FileClipboardHandler.HasFiles())
            return "Files"

        ; Check for binary/image
        if (BinaryClipboardOps.HasBinaryData())
            return "Binary/Image"

        ; Empty
        return "Empty"
    }

    /**
     * Gets detailed format information
     * @returns {Map}
     */
    static GetFormatInfo() {
        info := Map()

        info["type"] := this.DetectType()
        info["hasText"] := (A_Clipboard != "")
        info["hasBinary"] := BinaryClipboardOps.HasBinaryData()
        info["hasFiles"] := FileClipboardHandler.HasFiles()
        info["size"] := BinaryClipboardOps.GetSize()
        info["sizeFormatted"] := BinaryClipboardOps.FormatSize(info["size"])

        if (info["hasText"]) {
            info["textLength"] := StrLen(A_Clipboard)
            info["textLines"] := StrSplit(A_Clipboard, "`n").Length
        }

        if (info["hasFiles"]) {
            fileInfo := FileClipboardHandler.GetFileInfo()
            info["fileCount"] := fileInfo["count"]
        }

        return info
    }
}

; Show format detection
F2:: {
    formatInfo := ClipboardFormatDetector.GetFormatInfo()

    infoText := "Clipboard Format Detection:`n`n"
    infoText .= "Type: " . formatInfo["type"] . "`n"
    infoText .= "Total Size: " . formatInfo["sizeFormatted"] . "`n`n"

    if (formatInfo["hasText"]) {
        infoText .= "Text Information:`n"
        infoText .= "  Length: " . formatInfo["textLength"] . " characters`n"
        infoText .= "  Lines: " . formatInfo["textLines"] . "`n`n"
    }

    if (formatInfo["hasFiles"]) {
        infoText .= "File Information:`n"
        infoText .= "  Count: " . formatInfo["fileCount"] . " file(s)"
    }

    MsgBox(infoText, "Format Detection", "Icon Info")
}

; ============================================================================
; Example 5: Clipboard Size Analysis
; ============================================================================

/**
 * Demonstrates clipboard size analysis and monitoring.
 * 
 * @class ClipboardSizeAnalyzer
 * @description Analyzes clipboard memory usage
 */

class ClipboardSizeAnalyzer {
    static history := []
    static maxHistory := 20

    /**
     * Records current clipboard size
     * @returns {void}
     */
    static RecordSize() {
        size := BinaryClipboardOps.GetSize()
        timestamp := A_Now

        this.history.Push(Map("timestamp", timestamp, "size", size))

        if (this.history.Length > this.maxHistory)
            this.history.RemoveAt(1)
    }

    /**
     * Gets size statistics
     * @returns {Map}
     */
    static GetStats() {
        stats := Map()

        if (this.history.Length = 0) {
            stats["count"] := 0
            return stats
        }

        stats["count"] := this.history.Length
        stats["current"] := this.history[this.history.Length]["size"]
        stats["average"] := 0
        stats["max"] := 0
        stats["min"] := 999999999

        totalSize := 0
        for record in this.history {
            size := record["size"]
            totalSize += size

            if (size > stats["max"])
                stats["max"] := size

            if (size < stats["min"])
                stats["min"] := size
        }

        stats["average"] := totalSize / this.history.Length

        ; Format sizes
        stats["currentFormatted"] := BinaryClipboardOps.FormatSize(stats["current"])
        stats["averageFormatted"] := BinaryClipboardOps.FormatSize(stats["average"])
        stats["maxFormatted"] := BinaryClipboardOps.FormatSize(stats["max"])
        stats["minFormatted"] := BinaryClipboardOps.FormatSize(stats["min"])

        return stats
    }

    /**
     * Shows size analysis GUI
     * @returns {void}
     */
    static ShowAnalysis() {
        if (this.history.Length = 0) {
            MsgBox("No size history available!`n`nUse Ctrl+Alt+R to record current size.",
                "Size Analysis", "Icon Info")
            return
        }

        stats := this.GetStats()

        gui := Gui("+Resize", "Clipboard Size Analysis")
        gui.SetFont("s10")

        gui.Add("Text", "w500", "Size Statistics:")
        gui.Add("Text", "x20 y+10", "Current Size:")
        gui.Add("Text", "x+10", stats["currentFormatted"])

        gui.Add("Text", "x20 y+5", "Average Size:")
        gui.Add("Text", "x+10", stats["averageFormatted"])

        gui.Add("Text", "x20 y+5", "Maximum Size:")
        gui.Add("Text", "x+5", stats["maxFormatted"])

        gui.Add("Text", "x20 y+5", "Minimum Size:")
        gui.Add("Text", "x+10", stats["minFormatted"])

        gui.Add("Text", "x10 y+10", "Recorded Samples: " . stats["count"])

        ; History list
        lv := gui.Add("ListView", "x10 y+10 w500 h200", ["#", "Time", "Size"])
        lv.ModifyCol(1, 50)
        lv.ModifyCol(2, 200)
        lv.ModifyCol(3, 230)

        Loop this.history.Length {
            index := this.history.Length - A_Index + 1
            record := this.history[index]
            timeStr := FormatTime(record["timestamp"], "yyyy-MM-dd HH:mm:ss")
            sizeStr := BinaryClipboardOps.FormatSize(record["size"])

            lv.Add("", index, timeStr, sizeStr)
        }

        btnClose := gui.Add("Button", "w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }
}

; Record current clipboard size
^!r:: ClipboardSizeAnalyzer.RecordSize()

; Show size analysis
^!+r:: ClipboardSizeAnalyzer.ShowAnalysis()

; ============================================================================
; Example 6: Binary Clipboard Comparison
; ============================================================================

/**
 * Demonstrates comparing clipboard states.
 * 
 * @class ClipboardComparator
 * @description Compares clipboard contents
 */

class ClipboardComparator {
    static snapshot1 := ""
    static snapshot2 := ""

    /**
     * Takes first snapshot
     * @returns {void}
     */
    static TakeSnapshot1() {
        this.snapshot1 := ClipboardAll()
        TrayTip("Snapshot 1 Taken", "First clipboard snapshot saved", "Icon Info")
    }

    /**
     * Takes second snapshot
     * @returns {void}
     */
    static TakeSnapshot2() {
        this.snapshot2 := ClipboardAll()
        TrayTip("Snapshot 2 Taken", "Second clipboard snapshot saved", "Icon Info")
    }

    /**
     * Compares two snapshots
     * @returns {Map}
     */
    static Compare() {
        result := Map()

        result["hasSnapshot1"] := Type(this.snapshot1) = "ClipboardAll"
        result["hasSnapshot2"] := Type(this.snapshot2) = "ClipboardAll"

        if (!result["hasSnapshot1"] || !result["hasSnapshot2"]) {
            result["canCompare"] := false
            return result
        }

        result["canCompare"] := true
        result["size1"] := this.snapshot1.Size
        result["size2"] := this.snapshot2.Size
        result["sizeDiff"] := result["size2"] - result["size1"]

        result["sizeEqual"] := (result["size1"] = result["size2"])

        return result
    }

    /**
     * Shows comparison results
     * @returns {void}
     */
    static ShowComparison() {
        comparison := this.Compare()

        if (!comparison["canCompare"]) {
            MsgBox("Please take two snapshots first!`n`n"
                . "Ctrl+Alt+1 - Take Snapshot 1`n"
                . "Ctrl+Alt+2 - Take Snapshot 2",
                "Comparison", "Icon Info")
            return
        }

        infoText := "Clipboard Comparison:`n`n"
        infoText .= "Snapshot 1 Size: "
            . BinaryClipboardOps.FormatSize(comparison["size1"]) . "`n"
        infoText .= "Snapshot 2 Size: "
            . BinaryClipboardOps.FormatSize(comparison["size2"]) . "`n"
        infoText .= "Difference: "
            . BinaryClipboardOps.FormatSize(Abs(comparison["sizeDiff"]))
        infoText .= " (" . (comparison["sizeDiff"] >= 0 ? "+" : "-") . ")`n`n"
        infoText .= "Sizes Equal: " . (comparison["sizeEqual"] ? "Yes" : "No")

        MsgBox(infoText, "Clipboard Comparison", "Icon Info")
    }
}

; Take snapshots and compare
^!1:: ClipboardComparator.TakeSnapshot1()
^!2:: ClipboardComparator.TakeSnapshot2()
^!3:: ClipboardComparator.ShowComparison()

; ============================================================================
; Example 7: Advanced Binary Operations
; ============================================================================

/**
 * Advanced binary clipboard operations.
 * 
 * @class AdvancedBinaryOps
 * @description Advanced binary clipboard utilities
 */

class AdvancedBinaryOps {

    /**
     * Creates a clipboard checksum/hash
     * @returns {Integer}
     */
    static GetChecksum() {
        clipData := ClipboardAll()
        if (!Type(clipData) = "ClipboardAll")
            return 0

        ; Simple checksum - sum of bytes
        checksum := 0
        size := clipData.Size

        ; Note: Actual implementation would need DllCall to read bytes
        ; This is a simplified example
        return size  ; Use size as simple checksum for demo
    }

    /**
     * Monitors clipboard for changes
     * @param {Func} callback - Function to call on change
     * @returns {void}
     */
    static StartMonitoring(callback) {
        ; Set up OnClipboardChange to call callback
        OnClipboardChange(callback)
    }

    /**
     * Stops clipboard monitoring
     * @returns {void}
     */
    static StopMonitoring() {
        OnClipboardChange(ClipChanged, 0)
    }
}

; Monitor clipboard changes
^!+m:: {
    static monitoring := false

    if (!monitoring) {
        AdvancedBinaryOps.StartMonitoring(ClipChanged)
        monitoring := true
        TrayTip("Monitoring Started", "Clipboard changes are being monitored", "Icon Info")
    } else {
        AdvancedBinaryOps.StopMonitoring()
        monitoring := false
        TrayTip("Monitoring Stopped", "Clipboard monitoring disabled", "Icon Info")
    }
}

ClipChanged(DataType) {
    size := BinaryClipboardOps.GetSize()
    sizeStr := BinaryClipboardOps.FormatSize(size)

    TrayTip("Clipboard Changed",
        "Type: " . DataType . "`nSize: " . sizeStr,
        "Icon Info")
}

; ============================================================================
; HELP AND INFORMATION
; ============================================================================

F12:: {
    helpText := "
    (
    ╔════════════════════════════════════════════════════════════════╗
    ║      CLIPBOARDALL BINARY OPERATIONS - HOTKEYS                  ║
    ╠════════════════════════════════════════════════════════════════╣
    ║ BINARY INFO:                                                   ║
    ║   F1                  Show binary clipboard info               ║
    ║   F2                  Show format detection                    ║
    ║                                                                ║
    ║ IMAGE OPERATIONS:                                              ║
    ║   Ctrl+Alt+I          Save clipboard image                     ║
    ║                                                                ║
    ║ FILE OPERATIONS:                                               ║
    ║   Ctrl+Alt+F          Show file clipboard info                 ║
    ║                                                                ║
    ║ SIZE ANALYSIS:                                                 ║
    ║   Ctrl+Alt+R          Record current size                      ║
    ║   Ctrl+Alt+Shift+R    Show size analysis                       ║
    ║                                                                ║
    ║ COMPARISON:                                                    ║
    ║   Ctrl+Alt+1          Take snapshot 1                          ║
    ║   Ctrl+Alt+2          Take snapshot 2                          ║
    ║   Ctrl+Alt+3          Compare snapshots                        ║
    ║                                                                ║
    ║ MONITORING:                                                    ║
    ║   Ctrl+Alt+Shift+M    Toggle clipboard monitoring              ║
    ║                                                                ║
    ║ F12                   Show this help                           ║
    ╚════════════════════════════════════════════════════════════════╝
    )"

    MsgBox(helpText, "Binary Clipboard Help", "Icon Info")
}
