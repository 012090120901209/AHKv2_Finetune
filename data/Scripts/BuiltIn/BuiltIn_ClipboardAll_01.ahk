#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 - ClipboardAll Save and Restore
 * ============================================================================
 * 
 * This file demonstrates using ClipboardAll to save and restore the entire
 * clipboard contents including all formats (text, images, files, etc.).
 * 
 * ClipboardAll creates a binary snapshot of everything on the clipboard,
 * allowing you to save and restore the complete clipboard state, not just text.
 * 
 * @file BuiltIn_ClipboardAll_01.ahk
 * @version 2.0.0
 * @author AHK v2 Examples Collection
 * @date 2024-11-16
 * 
 * TABLE OF CONTENTS:
 * ──────────────────────────────────────────────────────────────────────────
 * 1. Basic Save and Restore
 * 2. Multiple Clipboard Slots
 * 3. Clipboard Swap Operations
 * 4. Temporary Clipboard Operations
 * 5. Clipboard History System
 * 6. Clipboard Backup Manager
 * 7. Advanced Clipboard Preserver
 * 
 * EXAMPLES SUMMARY:
 * ──────────────────────────────────────────────────────────────────────────
 * - Saving complete clipboard state with ClipboardAll
 * - Restoring saved clipboard state
 * - Managing multiple clipboard slots
 * - Swapping clipboard contents
 * - Preserving clipboard during operations
 * - Building clipboard history with binary data
 * - Creating a comprehensive backup system
 * 
 * ============================================================================
 */

; ============================================================================
; Example 1: Basic Save and Restore
; ============================================================================

/**
 * Demonstrates basic ClipboardAll save and restore operations.
 * 
 * @class BasicClipboardSaver
 * @description Handles basic save/restore of entire clipboard
 */

class BasicClipboardSaver {
    static savedClipboard := ""

    /**
     * Saves current clipboard state
     * @returns {Boolean} Success status
     */
    static Save() {
        this.savedClipboard := ClipboardAll()
        return true
    }

    /**
     * Restores previously saved clipboard state
     * @returns {Boolean} Success status
     */
    static Restore() {
        if (Type(this.savedClipboard) = "ClipboardAll") {
            A_Clipboard := this.savedClipboard
            ClipWait(2)  ; Wait for clipboard to be ready
            return true
        }
        return false
    }

    /**
     * Checks if a backup exists
     * @returns {Boolean}
     */
    static HasBackup() {
        return Type(this.savedClipboard) = "ClipboardAll"
    }

    /**
     * Clears the saved backup
     * @returns {void}
     */
    static ClearBackup() {
        this.savedClipboard := ""
    }
}

; Save clipboard
F1:: {
    BasicClipboardSaver.Save()
    TrayTip("Clipboard Saved", "Complete clipboard state has been saved",
        "Icon Info")
}

; Restore clipboard
F2:: {
    if (BasicClipboardSaver.HasBackup()) {
        BasicClipboardSaver.Restore()
        TrayTip("Clipboard Restored", "Clipboard has been restored from backup",
            "Icon Info")
    } else {
        MsgBox("No clipboard backup available!", "Restore", "Icon Warn")
    }
}

; Clear backup
F3:: {
    if (BasicClipboardSaver.HasBackup()) {
        result := MsgBox("Clear clipboard backup?", "Confirm", "YesNo Icon Question")
        if (result = "Yes") {
            BasicClipboardSaver.ClearBackup()
            TrayTip("Backup Cleared", "Clipboard backup has been cleared",
                "Icon Info")
        }
    } else {
        MsgBox("No backup to clear!", "Clear Backup", "Icon Info")
    }
}

; ============================================================================
; Example 2: Multiple Clipboard Slots
; ============================================================================

/**
 * Demonstrates managing multiple clipboard save slots.
 * 
 * @class MultiSlotClipboard
 * @description Manages multiple clipboard save slots
 */

class MultiSlotClipboard {
    static slots := Map()
    static maxSlots := 5

    /**
     * Saves clipboard to a specific slot
     * @param {Integer} slotNum - Slot number (1-5)
     * @returns {Boolean} Success status
     */
    static SaveToSlot(slotNum) {
        if (slotNum < 1 || slotNum > this.maxSlots) {
            return false
        }

        this.slots[slotNum] := ClipboardAll()
        return true
    }

    /**
     * Restores clipboard from a specific slot
     * @param {Integer} slotNum - Slot number (1-5)
     * @returns {Boolean} Success status
     */
    static RestoreFromSlot(slotNum) {
        if (!this.slots.Has(slotNum)) {
            return false
        }

        A_Clipboard := this.slots[slotNum]
        ClipWait(2)
        return true
    }

    /**
     * Checks if a slot has data
     * @param {Integer} slotNum - Slot number
     * @returns {Boolean}
     */
    static HasSlot(slotNum) {
        return this.slots.Has(slotNum)
    }

    /**
     * Clears a specific slot
     * @param {Integer} slotNum - Slot number
     * @returns {void}
     */
    static ClearSlot(slotNum) {
        if (this.slots.Has(slotNum)) {
            this.slots.Delete(slotNum)
        }
    }

    /**
     * Clears all slots
     * @returns {void}
     */
    static ClearAllSlots() {
        this.slots := Map()
    }

    /**
     * Gets list of occupied slots
     * @returns {Array}
     */
    static GetOccupiedSlots() {
        occupied := []
        for slotNum, _ in this.slots {
            occupied.Push(slotNum)
        }
        return occupied
    }

    /**
     * Shows slot manager GUI
     * @returns {void}
     */
    static ShowManager() {
        gui := Gui("+AlwaysOnTop", "Multi-Slot Clipboard Manager")
        gui.SetFont("s10")

        gui.Add("Text", "w400", "Save current clipboard to slot:")

        ; Save buttons
        Loop this.maxSlots {
            slotNum := A_Index
            if (A_Index = 1)
                btn := gui.Add("Button", "w70", "Slot " . slotNum)
            else
                btn := gui.Add("Button", "x+5 w70", "Slot " . slotNum)

            btn.OnEvent("Click", (*) => this.SaveSlotClick(slotNum, gui))
        }

        gui.Add("Text", "x10 y+20 w400", "Restore clipboard from slot:")

        ; Restore buttons
        Loop this.maxSlots {
            slotNum := A_Index
            if (A_Index = 1)
                btn := gui.Add("Button", "w70", "Slot " . slotNum)
            else
                btn := gui.Add("Button", "x+5 w70", "Slot " . slotNum)

            btn.OnEvent("Click", (*) => this.RestoreSlotClick(slotNum, gui))

            ; Disable if slot is empty
            if (!this.HasSlot(slotNum))
                btn.Enabled := false
        }

        ; Status
        occupied := this.GetOccupiedSlots()
        statusText := "Occupied slots: "
        if (occupied.Length = 0) {
            statusText .= "None"
        } else {
            for slot in occupied {
                statusText .= slot . " "
            }
        }
        gui.Add("Text", "x10 y+20 w400", statusText)

        ; Clear All button
        btnClear := gui.Add("Button", "x10 y+10 w100", "Clear All")
        btnClear.OnEvent("Click", (*) => this.ClearAllClick(gui))

        ; Close button
        btnClose := gui.Add("Button", "x+10 w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }

    static SaveSlotClick(slotNum, gui) {
        if (this.SaveToSlot(slotNum)) {
            MsgBox("Clipboard saved to slot " . slotNum . "!",
                "Saved", "Icon Info T2")
            gui.Destroy()
            this.ShowManager()  ; Refresh
        }
    }

    static RestoreSlotClick(slotNum, gui) {
        if (this.RestoreFromSlot(slotNum)) {
            MsgBox("Clipboard restored from slot " . slotNum . "!",
                "Restored", "Icon Info T2")
            gui.Destroy()
        }
    }

    static ClearAllClick(gui) {
        result := MsgBox("Clear all clipboard slots?", "Confirm", "YesNo Icon Question")
        if (result = "Yes") {
            this.ClearAllSlots()
            gui.Destroy()
            MsgBox("All slots cleared!", "Cleared", "Icon Info T2")
        }
    }
}

; Show multi-slot manager
^!m:: MultiSlotClipboard.ShowManager()

; Quick save to slots 1-5
^!1:: MultiSlotClipboard.SaveToSlot(1)
^!2:: MultiSlotClipboard.SaveToSlot(2)
^!3:: MultiSlotClipboard.SaveToSlot(3)
^!4:: MultiSlotClipboard.SaveToSlot(4)
^!5:: MultiSlotClipboard.SaveToSlot(5)

; Quick restore from slots 1-5
^+1:: MultiSlotClipboard.RestoreFromSlot(1)
^+2:: MultiSlotClipboard.RestoreFromSlot(2)
^+3:: MultiSlotClipboard.RestoreFromSlot(3)
^+4:: MultiSlotClipboard.RestoreFromSlot(4)
^+5:: MultiSlotClipboard.RestoreFromSlot(5)

; ============================================================================
; Example 3: Clipboard Swap Operations
; ============================================================================

/**
 * Demonstrates swapping clipboard contents.
 * 
 * @class ClipboardSwapper
 * @description Swaps between current and saved clipboard
 */

class ClipboardSwapper {
    static swapBuffer := ""

    /**
     * Swaps current clipboard with saved buffer
     * @returns {void}
     */
    static Swap() {
        currentClip := ClipboardAll()

        if (Type(this.swapBuffer) = "ClipboardAll") {
            A_Clipboard := this.swapBuffer
            ClipWait(2)
            this.swapBuffer := currentClip
            TrayTip("Swapped", "Clipboard contents swapped", "Icon Info")
        } else {
            ; First time - just save current
            this.swapBuffer := currentClip
            TrayTip("Saved", "Clipboard saved to swap buffer", "Icon Info")
        }
    }

    /**
     * Clears swap buffer
     * @returns {void}
     */
    static Clear() {
        this.swapBuffer := ""
        TrayTip("Cleared", "Swap buffer cleared", "Icon Info")
    }
}

; Swap clipboard
^!s:: ClipboardSwapper.Swap()

; ============================================================================
; Example 4: Temporary Clipboard Operations
; ============================================================================

/**
 * Demonstrates preserving clipboard during temporary operations.
 * 
 * @class TempClipboardOperation
 * @description Preserves clipboard during operations
 */

class TempClipboardOperation {

    /**
     * Executes a function while preserving clipboard
     * @param {Func} callback - Function to execute
     * @returns {Any} Return value of callback
     */
    static PreserveClipboard(callback) {
        ; Save current clipboard
        savedClip := ClipboardAll()

        try {
            ; Execute the callback
            result := callback()
            return result
        } finally {
            ; Always restore clipboard
            A_Clipboard := savedClip
            ClipWait(2)
        }
    }

    /**
     * Copies text temporarily without affecting clipboard
     * @param {String} text - Text to copy temporarily
     * @param {Func} callback - Function to execute with temp clipboard
     * @returns {Any} Return value of callback
     */
    static WithTempClipboard(text, callback) {
        savedClip := ClipboardAll()

        try {
            A_Clipboard := text
            ClipWait(2)
            result := callback()
            return result
        } finally {
            A_Clipboard := savedClip
            ClipWait(2)
        }
    }
}

; Example: Copy window title without affecting clipboard
^!t:: {
    TempClipboardOperation.PreserveClipboard(() {
        ; Get active window title
        title := WinGetTitle("A")

        ; Copy it temporarily
        A_Clipboard := title
        ClipWait(1)

        ; Paste it
        Send("^v")

        ; Clipboard will be restored automatically
        return true
    })
}

; ============================================================================
; Example 5: Clipboard History System
; ============================================================================

/**
 * Demonstrates a clipboard history system using ClipboardAll.
 * 
 * @class ClipboardHistory
 * @description Maintains history of clipboard states
 */

class ClipboardHistory {
    static history := []
    static maxHistory := 20
    static enabled := true

    /**
     * Adds current clipboard to history
     * @returns {void}
     */
    static AddToHistory() {
        if (!this.enabled)
            return

        ; Save current clipboard
        clipData := ClipboardAll()

        ; Don't add if clipboard is empty
        if (A_Clipboard = "" && !Type(clipData) = "ClipboardAll")
            return

        ; Add to history
        this.history.Push(clipData)

        ; Limit history size
        if (this.history.Length > this.maxHistory) {
            this.history.RemoveAt(1)
        }
    }

    /**
     * Gets history count
     * @returns {Integer}
     */
    static GetCount() {
        return this.history.Length
    }

    /**
     * Restores clipboard from history index
     * @param {Integer} index - History index (1 = oldest)
     * @returns {Boolean}
     */
    static RestoreFromHistory(index) {
        if (index < 1 || index > this.history.Length)
            return false

        A_Clipboard := this.history[index]
        ClipWait(2)
        return true
    }

    /**
     * Clears history
     * @returns {void}
     */
    static ClearHistory() {
        this.history := []
    }

    /**
     * Shows history GUI
     * @returns {void}
     */
    static ShowHistory() {
        if (this.history.Length = 0) {
            MsgBox("No clipboard history available!",
                "Clipboard History", "Icon Info")
            return
        }

        gui := Gui("+Resize", "Clipboard History (Binary)")
        gui.SetFont("s10")

        ; Info
        gui.Add("Text", "w500",
            "History Items: " . this.history.Length . " / " . this.maxHistory)

        ; List
        lv := gui.Add("ListView", "w500 h300", ["#", "Type", "Preview"])
        lv.ModifyCol(1, 40)
        lv.ModifyCol(2, 100)
        lv.ModifyCol(3, 340)

        ; Populate list (newest first)
        Loop this.history.Length {
            index := this.history.Length - A_Index + 1
            itemData := this.history[index]

            ; Try to get preview
            preview := "Binary Data"
            itemType := "Unknown"

            try {
                ; Temporarily set clipboard to get preview
                savedClip := ClipboardAll()
                A_Clipboard := itemData
                ClipWait(0.5)

                if (A_Clipboard != "") {
                    itemType := "Text"
                    preview := StrLen(A_Clipboard) > 50
                        ? SubStr(A_Clipboard, 1, 50) . "..."
                        : A_Clipboard
                    preview := StrReplace(preview, "`n", " ")
                } else {
                    itemType := "Binary"
                }

                A_Clipboard := savedClip
            }

            lv.Add("", index, itemType, preview)
        }

        ; Buttons
        btnRestore := gui.Add("Button", "w100", "Restore")
        btnRestore.OnEvent("Click", (*) => this.RestoreClick(lv, gui))

        btnClear := gui.Add("Button", "x+10 w100", "Clear History")
        btnClear.OnEvent("Click", (*) => this.ClearClick(gui))

        btnClose := gui.Add("Button", "x+10 w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }

    static RestoreClick(lv, gui) {
        rowNum := lv.GetNext()
        if (rowNum = 0) {
            MsgBox("Please select an item to restore!",
                "No Selection", "Icon Warn")
            return
        }

        index := lv.GetText(rowNum, 1)
        actualIndex := this.history.Length - index + 1

        if (this.RestoreFromHistory(actualIndex)) {
            MsgBox("Clipboard restored from history!",
                "Restored", "Icon Info T2")
            gui.Destroy()
        }
    }

    static ClearClick(gui) {
        result := MsgBox("Clear all clipboard history?",
            "Confirm", "YesNo Icon Question")
        if (result = "Yes") {
            this.ClearHistory()
            gui.Destroy()
            MsgBox("History cleared!", "Cleared", "Icon Info T2")
        }
    }
}

; Add current clipboard to history
^!h:: ClipboardHistory.AddToHistory()

; Show clipboard history
^!+h:: ClipboardHistory.ShowHistory()

; ============================================================================
; Example 6: Clipboard Backup Manager
; ============================================================================

/**
 * Demonstrates saving clipboard backups to disk.
 * 
 * @class ClipboardBackupManager
 * @description Saves/loads clipboard to/from files
 */

class ClipboardBackupManager {
    static backupFolder := A_ScriptDir . "\ClipboardBackups"

    /**
     * Saves clipboard to file
     * @param {String} filename - Name for backup file
     * @returns {Boolean}
     */
    static SaveToFile(filename := "") {
        ; Create backup folder if it doesn't exist
        if (!DirExist(this.backupFolder))
            DirCreate(this.backupFolder)

        ; Generate filename if not provided
        if (filename = "") {
            filename := "Backup_" . A_Now . ".clip"
        }

        filepath := this.backupFolder . "\" . filename

        try {
            clipData := ClipboardAll()
            FileObj := FileOpen(filepath, "w")
            FileObj.RawWrite(clipData)
            FileObj.Close()
            return true
        } catch as err {
            MsgBox("Error saving clipboard: " . err.Message,
                "Error", "Icon Error")
            return false
        }
    }

    /**
     * Loads clipboard from file
     * @param {String} filepath - Path to backup file
     * @returns {Boolean}
     */
    static LoadFromFile(filepath) {
        if (!FileExist(filepath))
            return false

        try {
            FileObj := FileOpen(filepath, "r")
            clipData := ClipboardAll()
            clipData := FileObj.RawRead()
            FileObj.Close()

            A_Clipboard := clipData
            ClipWait(2)
            return true
        } catch as err {
            MsgBox("Error loading clipboard: " . err.Message,
                "Error", "Icon Error")
            return false
        }
    }

    /**
     * Shows backup manager GUI
     * @returns {void}
     */
    static ShowManager() {
        gui := Gui("+Resize", "Clipboard Backup Manager")
        gui.SetFont("s10")

        ; Save section
        gui.Add("GroupBox", "w500 h80", "Save Current Clipboard")
        gui.Add("Text", "xp+10 yp+25", "Filename:")
        filenameEdit := gui.Add("Edit", "x+10 w300", "Backup_" . A_Now . ".clip")
        btnSave := gui.Add("Button", "x+10 w80", "Save")
        btnSave.OnEvent("Click", (*) => this.SaveClick(filenameEdit, gui))

        ; Load section
        gui.Add("GroupBox", "x10 y+20 w500 h300", "Load Clipboard Backup")

        lv := gui.Add("ListView", "xp+10 yp+25 w480 h220",
            ["Filename", "Size", "Date"])
        lv.ModifyCol(1, 250)
        lv.ModifyCol(2, 100)
        lv.ModifyCol(3, 110)

        ; Populate backups
        if (DirExist(this.backupFolder)) {
            Loop Files, this.backupFolder . "\*.clip" {
                size := Round(A_LoopFileSize / 1024, 1) . " KB"
                lv.Add("", A_LoopFileName, size, A_LoopFileTimeModified)
            }
        }

        btnLoad := gui.Add("Button", "xp yp+230 w100", "Load")
        btnLoad.OnEvent("Click", (*) => this.LoadClick(lv, gui))

        btnDelete := gui.Add("Button", "x+10 w100", "Delete")
        btnDelete.OnEvent("Click", (*) => this.DeleteClick(lv, gui))

        btnClose := gui.Add("Button", "x+10 w100", "Close")
        btnClose.OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }

    static SaveClick(filenameEdit, gui) {
        filename := filenameEdit.Value
        if (filename = "") {
            MsgBox("Please enter a filename!", "Error", "Icon Warn")
            return
        }

        if (this.SaveToFile(filename)) {
            MsgBox("Clipboard saved to:`n" . this.backupFolder . "\" . filename,
                "Saved", "Icon Info T3")
            gui.Destroy()
            this.ShowManager()  ; Refresh
        }
    }

    static LoadClick(lv, gui) {
        rowNum := lv.GetNext()
        if (rowNum = 0) {
            MsgBox("Please select a backup to load!",
                "No Selection", "Icon Warn")
            return
        }

        filename := lv.GetText(rowNum, 1)
        filepath := this.backupFolder . "\" . filename

        if (this.LoadFromFile(filepath)) {
            MsgBox("Clipboard loaded from backup!",
                "Loaded", "Icon Info T2")
            gui.Destroy()
        }
    }

    static DeleteClick(lv, gui) {
        rowNum := lv.GetNext()
        if (rowNum = 0) {
            MsgBox("Please select a backup to delete!",
                "No Selection", "Icon Warn")
            return
        }

        filename := lv.GetText(rowNum, 1)
        filepath := this.backupFolder . "\" . filename

        result := MsgBox("Delete backup: " . filename . "?",
            "Confirm Delete", "YesNo Icon Question")
        if (result = "Yes") {
            FileDelete(filepath)
            gui.Destroy()
            this.ShowManager()  ; Refresh
        }
    }
}

; Show backup manager
^!b:: ClipboardBackupManager.ShowManager()

; ============================================================================
; Example 7: Advanced Clipboard Preserver
; ============================================================================

/**
 * Advanced clipboard preservation for automation tasks.
 * 
 * @class AdvancedClipboardPreserver
 * @description Automatically preserves clipboard during copy operations
 */

class AdvancedClipboardPreserver {
    static autoPreserve := false
    static preservedClip := ""

    /**
     * Enables auto-preserve mode
     * @returns {void}
     */
    static Enable() {
        this.autoPreserve := true
        TrayTip("Auto-Preserve Enabled",
            "Clipboard will be automatically preserved",
            "Icon Info")
    }

    /**
     * Disables auto-preserve mode
     * @returns {void}
     */
    static Disable() {
        this.autoPreserve := false
        TrayTip("Auto-Preserve Disabled",
            "Clipboard preservation turned off",
            "Icon Info")
    }

    /**
     * Toggles auto-preserve mode
     * @returns {void}
     */
    static Toggle() {
        this.autoPreserve := !this.autoPreserve
        status := this.autoPreserve ? "Enabled" : "Disabled"
        TrayTip("Auto-Preserve " . status, "", "Icon Info")
    }
}

; Toggle auto-preserve
^!p:: AdvancedClipboardPreserver.Toggle()

; ============================================================================
; HELP AND INFORMATION
; ============================================================================

F12:: {
    helpText := "
    (
    ╔════════════════════════════════════════════════════════════════╗
    ║         CLIPBOARDALL SAVE AND RESTORE - HOTKEYS                ║
    ╠════════════════════════════════════════════════════════════════╣
    ║ BASIC OPERATIONS:                                              ║
    ║   F1                  Save clipboard                           ║
    ║   F2                  Restore clipboard                        ║
    ║   F3                  Clear backup                             ║
    ║                                                                ║
    ║ MULTI-SLOT:                                                    ║
    ║   Ctrl+Alt+M          Show slot manager                        ║
    ║   Ctrl+Alt+1-5        Save to slot 1-5                         ║
    ║   Ctrl+Shift+1-5      Restore from slot 1-5                    ║
    ║                                                                ║
    ║ SWAP:                                                          ║
    ║   Ctrl+Alt+S          Swap clipboard contents                  ║
    ║                                                                ║
    ║ HISTORY:                                                       ║
    ║   Ctrl+Alt+H          Add to history                           ║
    ║   Ctrl+Alt+Shift+H    Show history                             ║
    ║                                                                ║
    ║ BACKUP:                                                        ║
    ║   Ctrl+Alt+B          Show backup manager                      ║
    ║                                                                ║
    ║ PRESERVE:                                                      ║
    ║   Ctrl+Alt+P          Toggle auto-preserve                     ║
    ║   Ctrl+Alt+T          Copy window title (demo)                 ║
    ║                                                                ║
    ║ F12                   Show this help                           ║
    ╚════════════════════════════════════════════════════════════════╝
    )"

    MsgBox(helpText, "ClipboardAll Help", "Icon Info")
}
