#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 - OnClipboardChange: History & Clipboard Managers
 * ============================================================================
 * 
 * This file demonstrates building comprehensive clipboard history systems
 * and full-featured clipboard managers using OnClipboardChange.
 * 
 * @file BuiltIn_OnClipboardChange_02.ahk
 * @version 2.0.0
 * @author AHK v2 Examples Collection
 * @date 2024-11-16
 * 
 * TABLE OF CONTENTS:
 * ──────────────────────────────────────────────────────────────────────────
 * 1. Advanced Clipboard History
 * 2. Persistent Clipboard History
 * 3. Clipboard History Search
 * 4. Multi-Format History Manager
 * 5. Clipboard Snippets Manager
 * 6. Smart Clipboard Manager
 * 7. Complete Clipboard Manager System
 * 
 * EXAMPLES SUMMARY:
 * ──────────────────────────────────────────────────────────────────────────
 * - Building advanced clipboard history
 * - Saving history to disk
 * - Searching clipboard history
 * - Managing multiple formats in history
 * - Creating reusable snippets
 * - Building smart clipboard features
 * - Complete clipboard manager application
 * 
 * ============================================================================
 */

; ============================================================================
; Example 1: Advanced Clipboard History
; ============================================================================

/**
 * Demonstrates advanced clipboard history with metadata and organization.
 * 
 * @class AdvancedHistory
 * @description Advanced clipboard history manager
 */

class AdvancedHistory {
    static history := []
    static maxHistory := 100
    static enabled := true

    /**
     * Adds item to history with metadata
     * @param {Integer} dataType - Data type
     * @returns {void}
     */
    static Add(dataType) {
        if (!this.enabled)
            return

        item := Map()
        item["timestamp"] := A_Now
        item["dataType"] := dataType
        item["appName"] := WinGetProcessName("A")
        item["windowTitle"] := WinGetTitle("A")

        ; Store content based on type
        if (dataType = 1) {  ; Text
            content := A_Clipboard

            ; Skip empty or duplicate
            if (content = "" || this.IsDuplicate(content))
                return

            item["content"] := content
            item["length"] := StrLen(content)
            item["preview"] := this.GeneratePreview(content)
            item["category"] := this.DetermineCategory(content)
        } else {  ; Binary
            item["content"] := ClipboardAll()
            item["length"] := item["content"].Size
            item["preview"] := "[Binary Data - " . item["length"] . " bytes]"
            item["category"] := "Binary"
        }

        this.history.Push(item)

        ; Limit history size
        if (this.history.Length > this.maxHistory)
            this.history.RemoveAt(1)
    }

    /**
     * Checks if content is duplicate of last item
     * @param {String} content - Content to check
     * @returns {Boolean}
     */
    static IsDuplicate(content) {
        if (this.history.Length = 0)
            return false

        lastItem := this.history[this.history.Length]
        return (lastItem["dataType"] = 1 && lastItem["content"] = content)
    }

    /**
     * Generates preview text
     * @param {String} content - Full content
     * @returns {String}
     */
    static GeneratePreview(content) {
        preview := StrLen(content) > 100 ? SubStr(content, 1, 100) . "..." : content
        preview := StrReplace(preview, "`n", " ")
        preview := StrReplace(preview, "`r", "")
        preview := StrReplace(preview, "`t", " ")
        return preview
    }

    /**
     * Determines content category
     * @param {String} content - Content to categorize
     * @returns {String}
     */
    static DetermineCategory(content) {
        if (RegExMatch(content, "i)https?://"))
            return "URL"
        if (RegExMatch(content, "i)[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}"))
            return "Email"
        if (RegExMatch(content, "^[A-Za-z]:\\") || RegExMatch(content, "^\\\\"))
            return "File Path"
        if (RegExMatch(content, "^\d+$"))
            return "Number"
        if (InStr(content, "`n") && StrSplit(content, "`n").Length > 5)
            return "Multi-line"
        if (StrLen(content) > 200)
            return "Long Text"
        return "Text"
    }

    /**
     * Shows advanced history GUI
     * @returns {void}
     */
    static ShowHistory() {
        if (this.history.Length = 0) {
            MsgBox("No history available!", "History", "Icon Info")
            return
        }

        gui := Gui("+Resize", "Advanced Clipboard History")
        gui.SetFont("s9")

        ; Filter dropdown
        gui.Add("Text", "x10 y10", "Filter by category:")
        filterDDL := gui.Add("DDL", "x+10 w150 vFilterCategory",
            ["All", "Text", "URL", "Email", "File Path", "Number", "Multi-line", "Long Text", "Binary"])
        filterDDL.OnEvent("Change", (*) => this.FilterHistory(gui, filterDDL))

        ; History list
        lv := gui.Add("ListView", "x10 y+10 w800 h400 vHistoryList",
            ["#", "Time", "Category", "App", "Preview"])
        lv.ModifyCol(1, 50)
        lv.ModifyCol(2, 120)
        lv.ModifyCol(3, 100)
        lv.ModifyCol(4, 120)
        lv.ModifyCol(5, 390)

        this.PopulateList(lv, "All")

        ; Buttons
        btnPaste := gui.Add("Button", "x10 y+10 w100", "Paste")
        btnPaste.OnEvent("Click", (*) => this.PasteItem(gui, lv))

        btnCopy := gui.Add("Button", "x+10 w100", "Copy")
        btnCopy.OnEvent("Click", (*) => this.CopyItem(gui, lv))

        btnDelete := gui.Add("Button", "x+10 w100", "Delete")
        btnDelete.OnEvent("Click", (*) => this.DeleteItem(gui, lv))

        btnClear := gui.Add("Button", "x+10 w100", "Clear All")
        btnClear.OnEvent("Click", (*) => this.ClearAll(gui))

        btnClose := gui.Add("Button", "x+10 w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }

    static PopulateList(lv, filter := "All") {
        lv.Delete()

        Loop this.history.Length {
            index := this.history.Length - A_Index + 1
            item := this.history[index]

            ; Apply filter
            if (filter != "All" && item["category"] != filter)
                continue

            timeStr := FormatTime(item["timestamp"], "HH:mm:ss")
            lv.Add("", index, timeStr, item["category"], item["appName"], item["preview"])
        }
    }

    static FilterHistory(gui, filterDDL) {
        filter := filterDDL.Text
        lv := gui["HistoryList"]
        this.PopulateList(lv, filter)
    }

    static PasteItem(gui, lv) {
        rowNum := lv.GetNext()
        if (rowNum = 0) {
            MsgBox("Please select an item!", "No Selection", "Icon Warn")
            return
        }

        index := lv.GetText(rowNum, 1)
        actualIndex := this.history.Length - index + 1
        item := this.history[actualIndex]

        this.enabled := false
        A_Clipboard := item["content"]
        ClipWait(1)
        Send("^v")
        Sleep(100)
        this.enabled := true

        gui.Destroy()
    }

    static CopyItem(gui, lv) {
        rowNum := lv.GetNext()
        if (rowNum = 0) {
            MsgBox("Please select an item!", "No Selection", "Icon Warn")
            return
        }

        index := lv.GetText(rowNum, 1)
        actualIndex := this.history.Length - index + 1
        item := this.history[actualIndex]

        this.enabled := false
        A_Clipboard := item["content"]
        ClipWait(1)
        this.enabled := true

        TrayTip("Copied", "Item copied to clipboard", "Icon Info")
    }

    static DeleteItem(gui, lv) {
        rowNum := lv.GetNext()
        if (rowNum = 0) {
            MsgBox("Please select an item!", "No Selection", "Icon Warn")
            return
        }

        index := lv.GetText(rowNum, 1)
        actualIndex := this.history.Length - index + 1

        this.history.RemoveAt(actualIndex)
        gui.Destroy()
        this.ShowHistory()
    }

    static ClearAll(gui) {
        result := MsgBox("Clear all history?", "Confirm", "YesNo Icon Question")
        if (result = "Yes") {
            this.history := []
            gui.Destroy()
            MsgBox("History cleared!", "Cleared", "Icon Info T2")
        }
    }
}

; Set up callback
OnClipboardChange(HistoryAdd)

HistoryAdd(DataType) {
    AdvancedHistory.Add(DataType)
}

; Show advanced history
^!h:: AdvancedHistory.ShowHistory()

; ============================================================================
; Example 2: Persistent Clipboard History
; ============================================================================

/**
 * Demonstrates saving clipboard history to disk for persistence.
 * 
 * @class PersistentHistory
 * @description Saves and loads clipboard history from disk
 */

class PersistentHistory {
    static historyFile := A_ScriptDir . "\clipboard_history.dat"
    static history := []
    static maxHistory := 50

    /**
     * Adds item and saves to disk
     * @param {Integer} dataType - Data type
     * @returns {void}
     */
    static Add(dataType) {
        if (dataType != 1)  ; Only save text for now
            return

        content := A_Clipboard
        if (content = "")
            return

        ; Add to history
        item := Map(
            "content", content,
            "timestamp", A_Now
        )

        this.history.Push(item)

        ; Limit size
        if (this.history.Length > this.maxHistory)
            this.history.RemoveAt(1)

        ; Save to disk
        this.SaveToDisk()
    }

    /**
     * Saves history to disk
     * @returns {void}
     */
    static SaveToDisk() {
        try {
            ; Create JSON-like format
            data := ""
            for item in this.history {
                ; Escape special characters
                content := item["content"]
                content := StrReplace(content, "`n", "\n")
                content := StrReplace(content, "`r", "\r")
                content := StrReplace(content, "|", "\|")

                data .= item["timestamp"] . "|" . content . "`n"
            }

            FileObj := FileOpen(this.historyFile, "w", "UTF-8")
            FileObj.Write(data)
            FileObj.Close()
        }
    }

    /**
     * Loads history from disk
     * @returns {Boolean} Success status
     */
    static LoadFromDisk() {
        if (!FileExist(this.historyFile))
            return false

        try {
            this.history := []

            content := FileRead(this.historyFile, "UTF-8")
            lines := StrSplit(content, "`n")

            for line in lines {
                if (Trim(line) = "")
                    continue

                ; Parse line
                parts := StrSplit(line, "|", , 2)
                if (parts.Length < 2)
                    continue

                ; Unescape
                itemContent := parts[2]
                itemContent := StrReplace(itemContent, "\n", "`n")
                itemContent := StrReplace(itemContent, "\r", "`r")
                itemContent := StrReplace(itemContent, "\|", "|")

                item := Map(
                    "timestamp", parts[1],
                    "content", itemContent
                )

                this.history.Push(item)
            }

            return true
        } catch {
            return false
        }
    }

    /**
     * Shows persistent history
     * @returns {void}
     */
    static ShowHistory() {
        if (this.history.Length = 0) {
            MsgBox("No persistent history available!", "History", "Icon Info")
            return
        }

        gui := Gui("+Resize", "Persistent Clipboard History")
        gui.SetFont("s9")

        gui.Add("Text", "w600", "History Items: " . this.history.Length . " (Saved to disk)")

        lv := gui.Add("ListView", "w600 h400", ["#", "Date/Time", "Preview"])
        lv.ModifyCol(1, 50)
        lv.ModifyCol(2, 150)
        lv.ModifyCol(3, 380)

        Loop this.history.Length {
            index := this.history.Length - A_Index + 1
            item := this.history[index]

            timeStr := FormatTime(item["timestamp"], "yyyy-MM-dd HH:mm:ss")
            preview := StrLen(item["content"]) > 60
                ? SubStr(item["content"], 1, 60) . "..."
                : item["content"]
            preview := StrReplace(preview, "`n", " ")

            lv.Add("", index, timeStr, preview)
        }

        btnPaste := gui.Add("Button", "w100", "Paste")
        btnPaste.OnEvent("Click", (*) => this.PasteItem(lv, gui))

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

        A_Clipboard := this.history[actualIndex]["content"]
        Send("^v")
        gui.Destroy()
    }
}

; Load history on startup
PersistentHistory.LoadFromDisk()

; Set up callback
OnClipboardChange(PersistentAdd)

PersistentAdd(DataType) {
    PersistentHistory.Add(DataType)
}

; Show persistent history
^!+h:: PersistentHistory.ShowHistory()

; ============================================================================
; Example 3: Clipboard History Search
; ============================================================================

/**
 * Demonstrates searching clipboard history.
 * 
 * @class HistorySearch
 * @description Search functionality for clipboard history
 */

class HistorySearch {

    /**
     * Searches history
     * @param {String} query - Search query
     * @param {Boolean} caseSensitive - Case sensitive search
     * @param {Boolean} regex - Use regex
     * @returns {Array} Matching items
     */
    static Search(query, caseSensitive := false, regex := false) {
        matches := []

        for index, item in AdvancedHistory.history {
            if (item["dataType"] != 1)  ; Only search text
                continue

            content := item["content"]
            matched := false

            if (regex) {
                matched := RegExMatch(content, (caseSensitive ? "" : "i)") . query)
            } else {
                if (!caseSensitive) {
                    content := StrLower(content)
                    query := StrLower(query)
                }
                matched := InStr(content, query)
            }

            if (matched) {
                item["index"] := index
                matches.Push(item)
            }
        }

        return matches
    }

    /**
     * Shows search GUI
     * @returns {void}
     */
    static ShowSearchGUI() {
        gui := Gui("+AlwaysOnTop", "Search Clipboard History")
        gui.SetFont("s10")

        gui.Add("Text", "w400", "Search query:")
        searchEdit := gui.Add("Edit", "w400 vSearchQuery")

        caseCB := gui.Add("Checkbox", "vCaseSensitive", "Case sensitive")
        regexCB := gui.Add("Checkbox", "vUseRegex", "Use regex")

        btnSearch := gui.Add("Button", "w100", "Search")
        btnSearch.OnEvent("Click", (*) => this.PerformSearch(gui, searchEdit, caseCB, regexCB))

        btnClose := gui.Add("Button", "x+10 w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }

    static PerformSearch(gui, searchEdit, caseCB, regexCB) {
        query := searchEdit.Value
        if (query = "") {
            MsgBox("Please enter a search query!", "Search", "Icon Warn")
            return
        }

        matches := this.Search(query, caseCB.Value, regexCB.Value)

        if (matches.Length = 0) {
            MsgBox("No matches found!", "Search Results", "Icon Info")
            return
        }

        gui.Destroy()
        this.ShowResults(matches, query)
    }

    static ShowResults(matches, query) {
        gui := Gui("+Resize", "Search Results: " . matches.Length . " match(es)")
        gui.SetFont("s9")

        gui.Add("Text", "w600", "Query: " . query)

        lv := gui.Add("ListView", "w600 h400", ["#", "Time", "Preview"])
        lv.ModifyCol(1, 50)
        lv.ModifyCol(2, 120)
        lv.ModifyCol(3, 410)

        for item in matches {
            timeStr := FormatTime(item["timestamp"], "HH:mm:ss")
            lv.Add("", item["index"], timeStr, item["preview"])
        }

        btnPaste := gui.Add("Button", "w100", "Paste")
        btnPaste.OnEvent("Click", (*) => this.PasteResult(lv, matches, gui))

        btnClose := gui.Add("Button", "x+10 w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }

    static PasteResult(lv, matches, gui) {
        rowNum := lv.GetNext()
        if (rowNum = 0) {
            MsgBox("Please select an item!", "No Selection", "Icon Warn")
            return
        }

        item := matches[rowNum]
        A_Clipboard := item["content"]
        Send("^v")
        gui.Destroy()
    }
}

; Show search GUI
^!f:: HistorySearch.ShowSearchGUI()

; ============================================================================
; Example 4: Multi-Format History Manager
; ============================================================================

/**
 * Demonstrates managing multiple clipboard formats in history.
 * 
 * @class MultiFormatHistory
 * @description Handles text, binary, and files
 */

class MultiFormatHistory {
    static history := []
    static maxHistory := 30

    /**
     * Adds item with full format preservation
     * @param {Integer} dataType - Data type
     * @returns {void}
     */
    static Add(dataType) {
        item := Map()
        item["timestamp"] := A_Now
        item["dataType"] := dataType

        ; Save all clipboard formats
        item["clipboardAll"] := ClipboardAll()

        ; Add type-specific info
        switch dataType {
            case 0:
                item["type"] := "Empty"
                item["preview"] := "[Empty]"
            case 1:
                item["type"] := "Text"
                item["content"] := A_Clipboard
                item["preview"] := StrLen(A_Clipboard) > 80
                    ? SubStr(A_Clipboard, 1, 80) . "..."
                    : A_Clipboard
                item["preview"] := StrReplace(item["preview"], "`n", " ")
            case 2:
                item["type"] := "Binary"
                item["size"] := item["clipboardAll"].Size
                item["preview"] := "[Binary - " . item["size"] . " bytes]"
        }

        this.history.Push(item)

        if (this.history.Length > this.maxHistory)
            this.history.RemoveAt(1)
    }

    /**
     * Shows multi-format history
     * @returns {void}
     */
    static ShowHistory() {
        if (this.history.Length = 0) {
            MsgBox("No history available!", "History", "Icon Info")
            return
        }

        gui := Gui("+Resize", "Multi-Format Clipboard History")
        gui.SetFont("s9")

        lv := gui.Add("ListView", "w700 h400", ["#", "Time", "Type", "Preview"])
        lv.ModifyCol(1, 50)
        lv.ModifyCol(2, 120)
        lv.ModifyCol(3, 80)
        lv.ModifyCol(4, 430)

        Loop this.history.Length {
            index := this.history.Length - A_Index + 1
            item := this.history[index]

            timeStr := FormatTime(item["timestamp"], "HH:mm:ss")
            lv.Add("", index, timeStr, item["type"], item["preview"])
        }

        btnRestore := gui.Add("Button", "w120", "Restore All Formats")
        btnRestore.OnEvent("Click", (*) => this.RestoreItem(lv, gui))

        btnClose := gui.Add("Button", "x+10 w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }

    static RestoreItem(lv, gui) {
        rowNum := lv.GetNext()
        if (rowNum = 0) {
            MsgBox("Please select an item!", "No Selection", "Icon Warn")
            return
        }

        index := lv.GetText(rowNum, 1)
        actualIndex := this.history.Length - index + 1
        item := this.history[actualIndex]

        ; Restore full clipboard with all formats
        A_Clipboard := item["clipboardAll"]
        ClipWait(1)

        MsgBox("All clipboard formats restored!", "Restored", "Icon Info T2")
        gui.Destroy()
    }
}

; Set up callback
OnClipboardChange(MultiFormatAdd)

MultiFormatAdd(DataType) {
    MultiFormatHistory.Add(DataType)
}

; Show multi-format history
^!m:: MultiFormatHistory.ShowHistory()

; ============================================================================
; Example 5: Clipboard Snippets Manager
; ============================================================================

/**
 * Demonstrates saving frequently used clipboard items as snippets.
 * 
 * @class SnippetsManager
 * @description Manages reusable clipboard snippets
 */

class SnippetsManager {
    static snippets := Map()
    static snippetsFile := A_ScriptDir . "\clipboard_snippets.ini"

    /**
     * Saves current clipboard as snippet
     * @param {String} name - Snippet name
     * @param {String} category - Snippet category
     * @returns {Boolean} Success
     */
    static SaveSnippet(name, category := "General") {
        if (A_Clipboard = "")
            return false

        this.snippets[name] := Map(
            "content", A_Clipboard,
            "category", category,
            "created", A_Now
        )

        this.SaveToDisk()
        return true
    }

    /**
     * Shows save snippet dialog
     * @returns {void}
     */
    static ShowSaveDialog() {
        if (A_Clipboard = "") {
            MsgBox("Clipboard is empty! Copy something first.", "Save Snippet", "Icon Warn")
            return
        }

        gui := Gui("+AlwaysOnTop", "Save Clipboard as Snippet")
        gui.SetFont("s10")

        gui.Add("Text", "w300", "Snippet name:")
        nameEdit := gui.Add("Edit", "w300 vSnippetName")

        gui.Add("Text", "w300", "Category:")
        categoryDDL := gui.Add("DDL", "w300 vCategory",
            ["General", "Code", "Email", "Addresses", "Passwords", "Other"])

        gui.Add("Text", "w300", "Preview:")
        preview := StrLen(A_Clipboard) > 100
            ? SubStr(A_Clipboard, 1, 100) . "..."
            : A_Clipboard
        gui.Add("Edit", "w300 h80 ReadOnly", preview)

        btnSave := gui.Add("Button", "w100", "Save")
        btnSave.OnEvent("Click", (*) => this.DoSave(gui, nameEdit, categoryDDL))

        btnClose := gui.Add("Button", "x+10 w100", "Cancel")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }

    static DoSave(gui, nameEdit, categoryDDL) {
        name := nameEdit.Value
        if (name = "") {
            MsgBox("Please enter a snippet name!", "Error", "Icon Warn")
            return
        }

        category := categoryDDL.Text

        if (this.SaveSnippet(name, category)) {
            MsgBox("Snippet saved!", "Success", "Icon Info T2")
            gui.Destroy()
        }
    }

    /**
     * Shows snippets manager
     * @returns {void}
     */
    static ShowManager() {
        if (this.snippets.Count = 0) {
            MsgBox("No snippets saved yet!", "Snippets", "Icon Info")
            return
        }

        gui := Gui("+Resize", "Clipboard Snippets Manager")
        gui.SetFont("s9")

        lv := gui.Add("ListView", "w600 h400", ["Name", "Category", "Date Created", "Preview"])
        lv.ModifyCol(1, 150)
        lv.ModifyCol(2, 100)
        lv.ModifyCol(3, 120)
        lv.ModifyCol(4, 210)

        for name, snippet in this.snippets {
            dateStr := FormatTime(snippet["created"], "yyyy-MM-dd")
            preview := StrLen(snippet["content"]) > 40
                ? SubStr(snippet["content"], 1, 40) . "..."
                : snippet["content"]
            preview := StrReplace(preview, "`n", " ")

            lv.Add("", name, snippet["category"], dateStr, preview)
        }

        btnPaste := gui.Add("Button", "w100", "Paste")
        btnPaste.OnEvent("Click", (*) => this.PasteSnippet(lv, gui))

        btnDelete := gui.Add("Button", "x+10 w100", "Delete")
        btnDelete.OnEvent("Click", (*) => this.DeleteSnippet(lv, gui))

        btnClose := gui.Add("Button", "x+10 w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }

    static PasteSnippet(lv, gui) {
        rowNum := lv.GetNext()
        if (rowNum = 0) {
            MsgBox("Please select a snippet!", "No Selection", "Icon Warn")
            return
        }

        name := lv.GetText(rowNum, 1)
        A_Clipboard := this.snippets[name]["content"]
        Send("^v")
        gui.Destroy()
    }

    static DeleteSnippet(lv, gui) {
        rowNum := lv.GetNext()
        if (rowNum = 0) {
            MsgBox("Please select a snippet!", "No Selection", "Icon Warn")
            return
        }

        name := lv.GetText(rowNum, 1)
        result := MsgBox("Delete snippet: " . name . "?", "Confirm", "YesNo Icon Question")

        if (result = "Yes") {
            this.snippets.Delete(name)
            this.SaveToDisk()
            gui.Destroy()
            this.ShowManager()
        }
    }

    static SaveToDisk() {
        for name, snippet in this.snippets {
            IniWrite(snippet["content"], this.snippetsFile, name, "content")
            IniWrite(snippet["category"], this.snippetsFile, name, "category")
            IniWrite(snippet["created"], this.snippetsFile, name, "created")
        }
    }

    static LoadFromDisk() {
        if (!FileExist(this.snippetsFile))
            return

        sections := IniRead(this.snippetsFile)
        Loop Parse, sections, "`n" {
            if (A_LoopField = "")
                continue

            name := A_LoopField
            this.snippets[name] := Map(
                "content", IniRead(this.snippetsFile, name, "content", ""),
                "category", IniRead(this.snippetsFile, name, "category", "General"),
                "created", IniRead(this.snippetsFile, name, "created", A_Now)
            )
        }
    }
}

; Load snippets on startup
SnippetsManager.LoadFromDisk()

; Save current clipboard as snippet
^!s:: SnippetsManager.ShowSaveDialog()

; Show snippets manager
^!+s:: SnippetsManager.ShowManager()

; ============================================================================
; Example 6: Smart Clipboard Manager
; ============================================================================

/**
 * Smart clipboard manager with automatic categorization and suggestions.
 * 
 * @class SmartClipboardManager
 * @description Intelligent clipboard management
 */

class SmartClipboardManager {
    static categories := Map(
        "URL", [],
        "Email", [],
        "Code", [],
        "Numbers", [],
        "Text", []
    )

    /**
     * Categorizes and stores clipboard item
     * @param {Integer} dataType - Data type
     * @returns {void}
     */
    static CategorizeAndStore(dataType) {
        if (dataType != 1)
            return

        content := A_Clipboard
        if (content = "")
            return

        category := this.DetermineCategory(content)
        item := Map("content", content, "timestamp", A_Now)

        this.categories[category].Push(item)

        ; Limit each category
        if (this.categories[category].Length > 10)
            this.categories[category].RemoveAt(1)
    }

    static DetermineCategory(content) {
        if (RegExMatch(content, "i)https?://"))
            return "URL"
        if (RegExMatch(content, "i)[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}"))
            return "Email"
        if (RegExMatch(content, "i)(function|class|def|var|const|let)\s+"))
            return "Code"
        if (RegExMatch(content, "^\d+\.?\d*$"))
            return "Numbers"
        return "Text"
    }

    /**
     * Shows smart manager
     * @returns {void}
     */
    static ShowManager() {
        gui := Gui("+Resize", "Smart Clipboard Manager")
        gui.SetFont("s9")

        ; Category tabs
        tab := gui.Add("Tab3", "w700 h450", ["URLs", "Emails", "Code", "Numbers", "Text"])

        for categoryName, items in this.categories {
            tabName := ""
            switch categoryName {
                case "URL": tabName := "URLs"
                case "Email": tabName := "Emails"
                case "Code": tabName := "Code"
                case "Numbers": tabName := "Numbers"
                case "Text": tabName := "Text"
            }

            tab.UseTab(tabName)

            lv := gui.Add("ListView", "w680 h380 v" . categoryName . "List",
                ["#", "Preview"])
            lv.ModifyCol(1, 50)
            lv.ModifyCol(2, 610)

            Loop items.Length {
                index := items.Length - A_Index + 1
                item := items[index]

                preview := StrLen(item["content"]) > 100
                    ? SubStr(item["content"], 1, 100) . "..."
                    : item["content"]
                preview := StrReplace(preview, "`n", " ")

                lv.Add("", index, preview)
            }
        }

        tab.UseTab()

        btnPaste := gui.Add("Button", "w100", "Paste")
        btnPaste.OnEvent("Click", (*) => this.PasteFromCategory(gui, tab))

        btnClose := gui.Add("Button", "x+10 w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }

    static PasteFromCategory(gui, tab) {
        currentTab := tab.Text

        categoryMap := Map(
            "URLs", "URL",
            "Emails", "Email",
            "Code", "Code",
            "Numbers", "Numbers",
            "Text", "Text"
        )

        category := categoryMap[currentTab]
        lv := gui[category . "List"]

        rowNum := lv.GetNext()
        if (rowNum = 0) {
            MsgBox("Please select an item!", "No Selection", "Icon Warn")
            return
        }

        items := this.categories[category]
        index := lv.GetText(rowNum, 1)
        actualIndex := items.Length - index + 1

        A_Clipboard := items[actualIndex]["content"]
        Send("^v")
        gui.Destroy()
    }
}

; Set up callback
OnClipboardChange(SmartCategorize)

SmartCategorize(DataType) {
    SmartClipboardManager.CategorizeAndStore(DataType)
}

; Show smart manager
^!+m:: SmartClipboardManager.ShowManager()

; ============================================================================
; Example 7: Complete Clipboard Manager System
; ============================================================================

/**
 * Complete clipboard manager with all features.
 * 
 * @class CompleteClipboardManager
 * @description Full-featured clipboard manager
 */

class CompleteClipboardManager {

    /**
     * Shows main control panel
     * @returns {void}
     */
    static ShowControlPanel() {
        gui := Gui("+AlwaysOnTop", "Clipboard Manager - Control Panel")
        gui.SetFont("s10")

        gui.Add("Text", "w400", "Clipboard Manager Control Panel")
        gui.Add("Text", "w400", "═════════════════════════════════")

        ; History section
        gui.Add("GroupBox", "w400 h80", "History")
        btnAdvHistory := gui.Add("Button", "xp+10 yp+25 w180", "Advanced History")
        btnAdvHistory.OnEvent("Click", (*) => AdvancedHistory.ShowHistory())

        btnPersHistory := gui.Add("Button", "x+10 w180", "Persistent History")
        btnPersHistory.OnEvent("Click", (*) => PersistentHistory.ShowHistory())

        btnMultiFormat := gui.Add("Button", "x20 y+5 w180", "Multi-Format History")
        btnMultiFormat.OnEvent("Click", (*) => MultiFormatHistory.ShowHistory())

        btnSearch := gui.Add("Button", "x+10 w180", "Search History")
        btnSearch.OnEvent("Click", (*) => HistorySearch.ShowSearchGUI())

        ; Snippets section
        gui.Add("GroupBox", "x10 y+20 w400 h80", "Snippets")
        btnSnippets := gui.Add("Button", "xp+10 yp+25 w180", "Manage Snippets")
        btnSnippets.OnEvent("Click", (*) => SnippetsManager.ShowManager())

        btnSaveSnippet := gui.Add("Button", "x+10 w180", "Save Snippet")
        btnSaveSnippet.OnEvent("Click", (*) => SnippetsManager.ShowSaveDialog())

        ; Smart features
        gui.Add("GroupBox", "x10 y+20 w400 h60", "Smart Features")
        btnSmartManager := gui.Add("Button", "xp+10 yp+25 w180", "Smart Manager")
        btnSmartManager.OnEvent("Click", (*) => SmartClipboardManager.ShowManager())

        ; Statistics
        stats := "History Items: " . AdvancedHistory.history.Length
            . " | Snippets: " . SnippetsManager.snippets.Count

        gui.Add("Text", "x10 y+20 w400", stats)

        btnClose := gui.Add("Button", "x160 y+10 w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }
}

; Show control panel
^!p:: CompleteClipboardManager.ShowControlPanel()

; ============================================================================
; HELP AND INFORMATION
; ============================================================================

F12:: {
    helpText := "
    (
    ╔════════════════════════════════════════════════════════════════╗
    ║     CLIPBOARD HISTORY & MANAGERS - HOTKEYS                     ║
    ╠════════════════════════════════════════════════════════════════╣
    ║ HISTORY:                                                       ║
    ║   Ctrl+Alt+H          Show advanced history                    ║
    ║   Ctrl+Alt+Shift+H    Show persistent history                  ║
    ║   Ctrl+Alt+M          Show multi-format history                ║
    ║   Ctrl+Alt+F          Search history                           ║
    ║                                                                ║
    ║ SNIPPETS:                                                      ║
    ║   Ctrl+Alt+S          Save snippet                             ║
    ║   Ctrl+Alt+Shift+S    Manage snippets                          ║
    ║                                                                ║
    ║ SMART FEATURES:                                                ║
    ║   Ctrl+Alt+Shift+M    Show smart manager                       ║
    ║                                                                ║
    ║ CONTROL PANEL:                                                 ║
    ║   Ctrl+Alt+P          Show control panel                       ║
    ║                                                                ║
    ║ F12                   Show this help                           ║
    ╚════════════════════════════════════════════════════════════════╝
    )"

    MsgBox(helpText, "Clipboard Manager Help", "Icon Info")
}
