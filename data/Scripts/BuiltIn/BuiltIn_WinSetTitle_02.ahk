#Requires AutoHotkey v2.0

/**
* ============================================================================
* WinSetTitle Examples - Part 2: Rename Windows
* ============================================================================
*
* This script demonstrates advanced window renaming techniques.
* Focuses on dynamic naming, conditional renaming, and automation.
*
* @description Advanced window renaming and title manipulation
* @author AutoHotkey Community
* @version 2.0.0
* @requires AutoHotkey v2.0+
*/

; ============================================================================
; Example 1: Dynamic Title Based on Content
; ============================================================================

/**
* Changes window title based on window content or state
* Useful for reflecting document state or content type
*
* @hotkey F1 - Set dynamic title
*/
F1:: {
    SetDynamicTitle()
}

/**
* Sets title dynamically based on context
*/
SetDynamicTitle() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    hwnd := WinGetID("A")
    process := WinGetProcessName(hwnd)
    currentTitle := WinGetTitle(hwnd)

    ; Determine dynamic title based on process
    newTitle := ""

    switch process {
        case "notepad.exe":
        newTitle := "[TEXT EDITOR] - " currentTitle
        case "chrome.exe", "firefox.exe", "msedge.exe":
        newTitle := "[BROWSER] - " currentTitle
        case "explorer.exe":
        newTitle := "[FILE MANAGER] - " currentTitle
        case "Code.exe":
        newTitle := "[IDE] - " currentTitle
        default:
        newTitle := "[" StrUpper(process) "] - " currentTitle
    }

    WinSetTitle(newTitle, hwnd)
    ToolTip("Title updated: " newTitle)
    SetTimer(() => ToolTip(), -2500)
}

; ============================================================================
; Example 2: Conditional Renaming System
; ============================================================================

/**
* Renames windows based on specific conditions
* Demonstrates rule-based title modification
*
* @hotkey F2 - Conditional rename
*/
F2:: {
    ConditionalRename()
}

/**
* Applies conditional renaming rules
*/
ConditionalRename() {
    static condGui := ""

    if condGui {
        try condGui.Destroy()
    }

    condGui := Gui("+AlwaysOnTop", "Conditional Rename")
    condGui.SetFont("s10", "Segoe UI")

    condGui.Add("Text", "w500", "Rename windows matching condition:")

    condGui.Add("Text", "w200", "If title contains:")
    containsEdit := condGui.Add("Edit", "w290 x+10 yp-3 vContains")

    condGui.Add("Text", "w200 xm", "Replace with:")
    replaceEdit := condGui.Add("Edit", "w290 x+10 yp-3 vReplace")

    condGui.Add("CheckBox", "xm vCaseSens", "Case sensitive")
    condGui.Add("CheckBox", "vWholeWord", "Whole word only")

    resultEdit := condGui.Add("Edit", "w500 h150 ReadOnly vResults")

    condGui.Add("Button", "w160 Default", "Preview").OnEvent("Click", PreviewRename)
    condGui.Add("Button", "w160 x+10 yp", "Apply").OnEvent("Click", ApplyRename)
    condGui.Add("Button", "w160 x+10 yp", "Cancel").OnEvent("Click", (*) => condGui.Destroy())

    condGui.Show()

    global renameQueue := []

    PreviewRename(*) {
        submitted := condGui.Submit(false)

        if submitted.Contains = "" {
            MsgBox("Please enter text to search for.", "Error", 16)
            return
        }

        renameQueue := []
        results := "Preview of changes:`n" StrRepeat("=", 50) "`n`n"
        count := 0

        allWindows := WinGetList()

        for hwnd in allWindows {
            try {
                title := WinGetTitle(hwnd)

                if title != "" {
                    matched := false

                    if submitted.CaseSens {
                        matched := InStr(title, submitted.Contains)
                    } else {
                        matched := InStr(StrLower(title), StrLower(submitted.Contains))
                    }

                    if matched {
                        count++
                        newTitle := StrReplace(title, submitted.Contains, submitted.Replace, submitted.CaseSens)
                        renameQueue.Push({hwnd: hwnd, oldTitle: title, newTitle: newTitle})
                        results .= count ". " title "`n   → " newTitle "`n`n"
                    }
                }
            }
        }

        if count = 0 {
            results := "No matching windows found."
        }

        resultEdit.Value := results
    }

    ApplyRename(*) {
        if renameQueue.Length = 0 {
            MsgBox("Please preview first.", "Error", 16)
            return
        }

        renamed := 0

        for item in renameQueue {
            try {
                WinSetTitle(item.newTitle, item.hwnd)
                renamed++
            }
        }

        condGui.Destroy()
        MsgBox("Renamed " renamed " of " renameQueue.Length " windows.", "Success", 64)
    }
}

/**
* Helper function
*/
StrRepeat(str, count) {
    result := ""
    Loop count {
        result .= str
    }
    return result
}

; ============================================================================
; Example 3: Auto-Rename on Window Creation
; ============================================================================

/**
* Monitors and automatically renames new windows
* Demonstrates event-driven renaming
*
* @hotkey F3 - Start auto-rename monitor
*/
F3:: {
    static monitoring := false

    if !monitoring {
        monitoring := true
        StartAutoRename()
    } else {
        monitoring := false
    }
}

/**
* Automatically renames windows as they appear
*/
StartAutoRename() {
    static autoGui := ""
    static knownWindows := Map()

    if autoGui {
        try autoGui.Destroy()
    }

    autoGui := Gui("+AlwaysOnTop", "Auto-Rename Monitor")
    autoGui.SetFont("s9", "Consolas")

    autoGui.Add("Text", "w600", "Monitoring for new windows. Configure rename rules:")

    autoGui.Add("Text", "w200", "Process name:")
    processEdit := autoGui.Add("Edit", "w390 x+10 yp-3 vProcess", "notepad.exe")

    autoGui.Add("Text", "w200 xm", "New title pattern:")
    patternEdit := autoGui.Add("Edit", "w390 x+10 yp-3 vPattern", "[AUTO] {ORIG}")

    logEdit := autoGui.Add("Edit", "w600 h250 ReadOnly vLog")

    autoGui.Add("Button", "w290 Default", "Stop Monitor").OnEvent("Click", StopMon)
    autoGui.Add("Button", "w290 x+20 yp", "Clear Log").OnEvent("Click", ClearLog)

    autoGui.Show()

    knownWindows := Map()
    LogRename("Auto-rename monitor started at " A_Hour ":" A_Min ":" A_Sec)

    SetTimer(CheckNewWindows, 1000)

    CheckNewWindows() {
        submitted := autoGui.Submit(false)
        targetProcess := submitted.Process

        if targetProcess = "" {
            return
        }

        allWindows := WinGetList("ahk_exe " targetProcess)

        for hwnd in allWindows {
            try {
                hwndKey := Format("0x{:X}", hwnd)

                if !knownWindows.Has(hwndKey) {
                    title := WinGetTitle(hwnd)

                    if title != "" {
                        newTitle := StrReplace(submitted.Pattern, "{ORIG}", title)
                        newTitle := StrReplace(newTitle, "{TIME}", A_Hour ":" A_Min)
                        newTitle := StrReplace(newTitle, "{DATE}", A_YYYY "-" A_MM "-" A_DD)

                        WinSetTitle(newTitle, hwnd)
                        knownWindows[hwndKey] := true

                        LogRename("[" A_Hour ":" A_Min ":" A_Sec "] Renamed: " title " → " newTitle)
                    }
                }
            }
        }
    }

    LogRename(message) {
        logEdit.Value := message "`n" logEdit.Value
    }

    StopMon(*) {
        SetTimer(CheckNewWindows, 0)
        LogRename("Monitor stopped at " A_Hour ":" A_Min ":" A_Sec)
        autoGui.Destroy()
    }

    ClearLog(*) {
        logEdit.Value := ""
    }
}

; ============================================================================
; Example 4: Title Rotation System
; ============================================================================

/**
* Rotates through different title variations
* Useful for testing or cycling through states
*
* @hotkey F4 - Rotate window title
*/
F4:: {
    RotateWindowTitle()
}

; Track rotation state
global rotationIndex := 0

/**
* Cycles through predefined title variations
*/
RotateWindowTitle() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    hwnd := WinGetID("A")
    baseTitle := WinGetTitle(hwnd)

    ; Define rotation titles
    titles := [
    "[STATUS: Ready] " baseTitle,
    "[STATUS: Working] " baseTitle,
    "[STATUS: Processing] " baseTitle,
    "[STATUS: Complete] " baseTitle,
    baseTitle  ; Reset to original
    ]

    rotationIndex := Mod(rotationIndex, titles.Length) + 1
    WinSetTitle(titles[rotationIndex], hwnd)

    ToolTip("Rotated to state " rotationIndex "/" titles.Length)
    SetTimer(() => ToolTip(), -1500)
}

; ============================================================================
; Example 5: Multi-Language Title Support
; ============================================================================

/**
* Translates or adds multi-language support to titles
* Demonstrates internationalization
*
* @hotkey F5 - Add language tag
*/
F5:: {
    AddLanguageTag()
}

/**
* Adds language indicators to window titles
*/
AddLanguageTag() {
    static langGui := ""

    if langGui {
        try langGui.Destroy()
    }

    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    langGui := Gui("+AlwaysOnTop", "Language Tag")
    langGui.SetFont("s10", "Segoe UI")

    currentTitle := WinGetTitle("A")

    langGui.Add("Text", "w400", "Current title:")
    langGui.Add("Edit", "w400 ReadOnly", currentTitle)

    langGui.Add("Text", "w400", "Select language:")
    langDrop := langGui.Add("DropDownList", "w400 vLang Choose1", [
    "English [EN]",
    "Spanish [ES]",
    "French [FR]",
    "German [DE]",
    "Chinese [ZH]",
    "Japanese [JA]"
    ])

    previewEdit := langGui.Add("Edit", "w400 ReadOnly vPreview")

    langDrop.OnEvent("Change", UpdatePreview)

    langGui.Add("Button", "w195 Default", "Apply").OnEvent("Click", Apply)
    langGui.Add("Button", "w195 x+10 yp", "Cancel").OnEvent("Click", (*) => langGui.Destroy())

    langGui.Show()

    UpdatePreview(*) {
        langText := langDrop.Text
        tag := RegExReplace(langText, ".*\[([A-Z]+)\]", "$1")
        previewEdit.Value := "[" tag "] " currentTitle
    }

    Apply(*) {
        if previewEdit.Value = "" {
            MsgBox("Please select a language.", "Error", 16)
            return
        }

        WinSetTitle(previewEdit.Value, "A")
        MsgBox("Language tag applied!", "Success", 64)
        langGui.Destroy()
    }
}

; ============================================================================
; Example 6: Smart Title Suggester
; ============================================================================

/**
* Suggests improved titles based on window content
* Uses heuristics to generate better names
*
* @hotkey F6 - Suggest title
*/
F6:: {
    SuggestTitle()
}

/**
* Generates title suggestions
*/
SuggestTitle() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    hwnd := WinGetID("A")
    currentTitle := WinGetTitle(hwnd)
    process := WinGetProcessName(hwnd)
    class := WinGetClass(hwnd)

    ; Generate suggestions
    suggestions := []

    ; Suggestion 1: Clean version
    cleaned := Trim(currentTitle)
    cleaned := RegExReplace(cleaned, " - .*$", "")  ; Remove common suffixes
    suggestions.Push("Simplified: " cleaned)

    ; Suggestion 2: With process info
    suggestions.Push("With Process: " currentTitle " [" process "]")

    ; Suggestion 3: Timestamped
    suggestions.Push("Timestamped: " currentTitle " (" A_Hour ":" A_Min ")")

    ; Suggestion 4: Category based on class
    category := DetermineCategory(class)
    suggestions.Push("Categorized: [" category "] " currentTitle)

    ; Suggestion 5: Shortened
    if StrLen(currentTitle) > 40 {
        shortened := SubStr(currentTitle, 1, 37) "..."
        suggestions.Push("Shortened: " shortened)
    }

    ; Show suggestions
    result := ""
    Loop suggestions.Length {
        result .= A_Index ". " suggestions[A_Index] "`n"
    }

    MsgBox("Title Suggestions:`n`n" result "`n(Use F7 to apply a specific suggestion)", "Suggestions", 64)
}

/**
* Determines category from window class
*/
DetermineCategory(class) {
    if InStr(class, "Notepad") {
        return "TEXT"
    } else if InStr(class, "Chrome") || InStr(class, "Mozilla") {
        return "WEB"
    } else if InStr(class, "Cabinet") {
        return "FILES"
    } else {
        return "APP"
    }
}

; ============================================================================
; Example 7: Title Backup and Restore
; ============================================================================

/**
* Backs up and restores window titles
* Allows reverting changes
*
* @hotkey F7 - Backup/restore titles
*/
F7:: {
    TitleBackupRestore()
}

; Global backup storage
global titleBackup := Map()

/**
* Manages title backups
*/
TitleBackupRestore() {
    static brGui := ""

    if brGui {
        try brGui.Destroy()
    }

    brGui := Gui("+AlwaysOnTop", "Title Backup & Restore")
    brGui.SetFont("s10", "Segoe UI")

    brGui.Add("Text", "w500", "Backup and restore window titles:")

    brGui.Add("Button", "w240 Default", "Backup All Titles").OnEvent("Click", BackupAll)
    brGui.Add("Button", "w240 x+20 yp", "Restore All Titles").OnEvent("Click", RestoreAll)

    brGui.Add("Text", "w500", "Backed up windows:")
    lv := brGui.Add("ListView", "w500 h250 vBackupList", ["HWND", "Original Title", "Current Title"])

    brGui.Add("Button", "w160", "Refresh List").OnEvent("Click", RefreshList)
    brGui.Add("Button", "w160 x+10 yp", "Clear Backup").OnEvent("Click", ClearBackup)
    brGui.Add("Button", "w160 x+10 yp", "Close").OnEvent("Click", (*) => brGui.Destroy())

    brGui.Show()

    RefreshList()

    BackupAll(*) {
        titleBackup := Map()
        allWindows := WinGetList()

        for hwnd in allWindows {
            try {
                title := WinGetTitle(hwnd)
                if title != "" {
                    titleBackup[hwnd] := title
                }
            }
        }

        RefreshList()
        MsgBox("Backed up " titleBackup.Count " window titles.", "Success", 64)
    }

    RestoreAll(*) {
        if titleBackup.Count = 0 {
            MsgBox("No backup available. Please backup first.", "Error", 16)
            return
        }

        restored := 0

        for hwnd, title in titleBackup {
            try {
                if WinExist(hwnd) {
                    WinSetTitle(title, hwnd)
                    restored++
                }
            }
        }

        RefreshList()
        MsgBox("Restored " restored " window titles.", "Success", 64)
    }

    RefreshList(*) {
        lv.Delete()

        for hwnd, originalTitle in titleBackup {
            try {
                if WinExist(hwnd) {
                    currentTitle := WinGetTitle(hwnd)
                    lv.Add("", Format("0x{:X}", hwnd), originalTitle, currentTitle)
                }
            }
        }

        lv.ModifyCol()
    }

    ClearBackup(*) {
        titleBackup := Map()
        RefreshList()
    }
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc::ExitApp()

^F1:: {
    help := "
    (
    WinSetTitle Examples - Part 2 (Rename Windows)
    ===============================================

    Hotkeys:
    F1 - Set dynamic title based on process
    F2 - Conditional rename system
    F3 - Start/stop auto-rename monitor
    F4 - Rotate window title through states
    F5 - Add language tag to title
    F6 - Suggest improved titles
    F7 - Backup/restore window titles
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(help, "Help", 64)
}
