#Requires AutoHotkey v2.0

/**
* ============================================================================
* WinSetTitle Examples - Part 1: Set Window Title
* ============================================================================
*
* This script demonstrates how to change window titles using WinSetTitle.
* Useful for organizing windows, marking states, and improving identification.
*
* @description Comprehensive examples of setting window titles
* @author AutoHotkey Community
* @version 2.0.0
* @requires AutoHotkey v2.0+
*/

; ============================================================================
; Example 1: Basic Window Title Change
; ============================================================================

/**
* Changes the title of the active window
* Most basic use case for WinSetTitle
*
* @hotkey F1 - Change active window title
*/
F1:: {
    try {
        if !WinExist("A") {
            MsgBox("No active window found.", "Error", 16)
            return
        }

        originalTitle := WinGetTitle("A")

        result := InputBox("Enter new window title:", "Change Window Title", "w300 h150", originalTitle)

        if result.Result = "OK" && result.Value != "" {
            WinSetTitle(result.Value, "A")
            MsgBox("Window title changed successfully!`n`nOld: " originalTitle "`nNew: " result.Value, "Success", 64)
        }
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 2: Add Prefix/Suffix to Window Title
; ============================================================================

/**
* Adds prefix or suffix to existing window titles
* Useful for marking or categorizing windows
*
* @hotkey F2 - Add prefix/suffix to title
*/
F2:: {
    ModifyWindowTitle()
}

/**
* Creates GUI for adding prefix/suffix
*/
ModifyWindowTitle() {
    static modGui := ""

    if modGui {
        try modGui.Destroy()
    }

    modGui := Gui("+AlwaysOnTop", "Modify Window Title")
    modGui.SetFont("s10", "Segoe UI")

    if !WinExist("A") {
        MsgBox("No active window found.", "Error", 16)
        return
    }

    currentTitle := WinGetTitle("A")

    modGui.Add("Text", "w400", "Current title:")
    modGui.Add("Edit", "w400 ReadOnly", currentTitle)

    modGui.Add("Text", "w400", "Prefix (optional):")
    prefixEdit := modGui.Add("Edit", "w400 vPrefix", "[MODIFIED] ")

    modGui.Add("Text", "w400", "Suffix (optional):")
    suffixEdit := modGui.Add("Edit", "w400 vSuffix", "")

    modGui.Add("Text", "w400", "Preview:")
    previewEdit := modGui.Add("Edit", "w400 ReadOnly vPreview", "[MODIFIED] " currentTitle)

    ; Update preview in real-time
    prefixEdit.OnEvent("Change", UpdatePreview)
    suffixEdit.OnEvent("Change", UpdatePreview)

    modGui.Add("Button", "w195 Default", "Apply").OnEvent("Click", Apply)
    modGui.Add("Button", "w195 x+10 yp", "Cancel").OnEvent("Click", (*) => modGui.Destroy())

    modGui.Show()

    UpdatePreview(*) {
        submitted := modGui.Submit(false)
        newTitle := submitted.Prefix currentTitle submitted.Suffix
        previewEdit.Value := newTitle
    }

    Apply(*) {
        submitted := modGui.Submit()
        newTitle := submitted.Prefix currentTitle submitted.Suffix

        WinSetTitle(newTitle, "A")
        MsgBox("Title updated successfully!", "Success", 64)
        modGui.Destroy()
    }
}

; ============================================================================
; Example 3: Batch Rename Windows
; ============================================================================

/**
* Renames multiple windows at once
* Useful for organizing multiple instances
*
* @hotkey F3 - Batch rename windows
*/
F3:: {
    BatchRenameWindows()
}

/**
* Creates GUI for batch renaming
*/
BatchRenameWindows() {
    static batchGui := ""

    if batchGui {
        try batchGui.Destroy()
    }

    batchGui := Gui("+AlwaysOnTop", "Batch Rename Windows")
    batchGui.SetFont("s10", "Segoe UI")

    batchGui.Add("Text", "w600", "Select windows to rename:")

    lv := batchGui.Add("ListView", "w600 h250 Checked vWindowList", ["Title", "Process"])

    ; Get all windows
    windows := []
    allWindows := WinGetList()

    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                process := WinGetProcessName(hwnd)
                lv.Add("", title, process)
                windows.Push(hwnd)
            }
        }
    }

    lv.ModifyCol(1, 400)
    lv.ModifyCol(2, "AutoHdr")

    batchGui.Add("Text", "w600", "Rename pattern (use {N} for number, {ORIG} for original):")
    patternEdit := batchGui.Add("Edit", "w600 vPattern", "Window {N} - {ORIG}")

    batchGui.Add("Button", "w195 Default", "Preview").OnEvent("Click", Preview)
    batchGui.Add("Button", "w195 x+10 yp", "Apply").OnEvent("Click", Apply)
    batchGui.Add("Button", "w195 x+10 yp", "Cancel").OnEvent("Click", (*) => batchGui.Destroy())

    batchGui.Show()

    Preview(*) {
        submitted := batchGui.Submit(false)
        pattern := submitted.Pattern

        previewText := "Preview of renamed windows:`n" StrRepeat("=", 50) "`n`n"
        count := 0

        Loop lv.GetCount() {
            if lv.GetNext(A_Index - 1, "Checked") = A_Index {
                count++
                originalTitle := lv.GetText(A_Index, 1)
                newTitle := StrReplace(pattern, "{N}", count)
                newTitle := StrReplace(newTitle, "{ORIG}", originalTitle)
                previewText .= count ". " newTitle "`n"
            }
        }

        if count = 0 {
            MsgBox("Please select at least one window to rename.", "Error", 16)
            return
        }

        MsgBox(previewText, "Preview", 64)
    }

    Apply(*) {
        submitted := batchGui.Submit()
        pattern := submitted.Pattern

        count := 0
        renamed := 0

        Loop lv.GetCount() {
            if lv.GetNext(A_Index - 1, "Checked") = A_Index {
                count++
                originalTitle := lv.GetText(A_Index, 1)
                newTitle := StrReplace(pattern, "{N}", count)
                newTitle := StrReplace(newTitle, "{ORIG}", originalTitle)

                try {
                    WinSetTitle(newTitle, windows[A_Index])
                    renamed++
                } catch {
                    ; Skip windows that can't be renamed
                }
            }
        }

        batchGui.Destroy()
        MsgBox("Successfully renamed " renamed " of " count " selected windows.", "Complete", 64)
    }
}

/**
* Helper to repeat strings
*/
StrRepeat(str, count) {
    result := ""
    Loop count {
        result .= str
    }
    return result
}

; ============================================================================
; Example 4: Timestamp Window Titles
; ============================================================================

/**
* Adds timestamps to window titles
* Useful for tracking when windows were opened or modified
*
* @hotkey F4 - Add timestamp to title
*/
F4:: {
    AddTimestampToTitle()
}

/**
* Adds timestamp to active window title
*/
AddTimestampToTitle() {
    static tsGui := ""

    if tsGui {
        try tsGui.Destroy()
    }

    tsGui := Gui("+AlwaysOnTop", "Add Timestamp")
    tsGui.SetFont("s10", "Segoe UI")

    if !WinExist("A") {
        MsgBox("No active window found.", "Error", 16)
        return
    }

    currentTitle := WinGetTitle("A")

    tsGui.Add("Text", "w400", "Current title:")
    tsGui.Add("Edit", "w400 ReadOnly", currentTitle)

    tsGui.Add("Text", "w400", "Timestamp format:")
    formatDrop := tsGui.Add("DropDownList", "w400 vFormat Choose1", [
    "[YYYY-MM-DD HH:MM:SS]",
    "[HH:MM:SS]",
    "[YYYY-MM-DD]",
    "[YYYYMMDD_HHMMSS]",
    "Custom..."
    ])

    customEdit := tsGui.Add("Edit", "w400 vCustom Hidden", "")

    formatDrop.OnEvent("Change", (*) => customEdit.Visible := (formatDrop.Value = 5))

    tsGui.Add("Text", "w400", "Position:")
    posDrop := tsGui.Add("DropDownList", "w400 vPosition Choose1", ["Beginning", "End"])

    previewEdit := tsGui.Add("Edit", "w400 ReadOnly vPreview")

    ; Update preview button
    tsGui.Add("Button", "w400", "Update Preview").OnEvent("Click", UpdatePrev)

    tsGui.Add("Button", "w195 Default", "Apply").OnEvent("Click", Apply)
    tsGui.Add("Button", "w195 x+10 yp", "Cancel").OnEvent("Click", (*) => tsGui.Destroy())

    tsGui.Show()

    UpdatePrev(*) {
        submitted := tsGui.Submit(false)

        ; Generate timestamp
        timestamp := ""
        switch submitted.Format {
            case 1: timestamp := "[" A_YYYY "-" A_MM "-" A_DD " " A_Hour ":" A_Min ":" A_Sec "]"
            case 2: timestamp := "[" A_Hour ":" A_Min ":" A_Sec "]"
            case 3: timestamp := "[" A_YYYY "-" A_MM "-" A_DD "]"
            case 4: timestamp := "[" A_YYYY A_MM A_DD "_" A_Hour A_Min A_Sec "]"
            case 5: timestamp := submitted.Custom
        }

        ; Apply position
        newTitle := submitted.Position = 1 ? timestamp " " currentTitle : currentTitle " " timestamp

        previewEdit.Value := newTitle
    }

    Apply(*) {
        submitted := tsGui.Submit()

        ; Generate timestamp
        timestamp := ""
        switch submitted.Format {
            case 1: timestamp := "[" A_YYYY "-" A_MM "-" A_DD " " A_Hour ":" A_Min ":" A_Sec "]"
            case 2: timestamp := "[" A_Hour ":" A_Min ":" A_Sec "]"
            case 3: timestamp := "[" A_YYYY "-" A_MM "-" A_DD "]"
            case 4: timestamp := "[" A_YYYY A_MM A_DD "_" A_Hour A_Min A_Sec "]"
            case 5: timestamp := submitted.Custom
        }

        ; Apply position
        newTitle := submitted.Position = 1 ? timestamp " " currentTitle : currentTitle " " timestamp

        WinSetTitle(newTitle, "A")
        MsgBox("Timestamp added successfully!", "Success", 64)
        tsGui.Destroy()
    }
}

; ============================================================================
; Example 5: Title Template System
; ============================================================================

/**
* Uses templates to standardize window titles
* Great for organizing workflow
*
* @hotkey F5 - Apply title template
*/
F5:: {
    ApplyTitleTemplate()
}

/**
* Applies predefined templates to window titles
*/
ApplyTitleTemplate() {
    static tempGui := ""

    if tempGui {
        try tempGui.Destroy()
    }

    tempGui := Gui("+AlwaysOnTop", "Title Templates")
    tempGui.SetFont("s10", "Segoe UI")

    if !WinExist("A") {
        MsgBox("No active window found.", "Error", 16)
        return
    }

    currentTitle := WinGetTitle("A")
    process := WinGetProcessName("A")

    tempGui.Add("Text", "w500", "Current: " currentTitle)
    tempGui.Add("Text", "w500", "Process: " process)

    tempGui.Add("Text", "w500", "Select template:")

    ; Define templates
    templates := Map(
    "[WORK] - {TITLE}", "Work prefix",
    "[PERSONAL] - {TITLE}", "Personal prefix",
    "[PROJECT: {PROJECT}] - {TITLE}", "Project template",
    "[TODO] - {TITLE}", "Todo marker",
    "[DONE] - {TITLE}", "Done marker",
    "{TITLE} - [IMPORTANT]", "Important suffix",
    "{DATE} - {TITLE}", "Date prefix"
    )

    templateList := tempGui.Add("ListBox", "w500 h150 vTemplate")
    for template, desc in templates {
        templateList.Add([desc ": " template])
    }
    templateList.Choose(1)

    ; Additional input for custom values
    tempGui.Add("Text", "w500", "Project name (if using project template):")
    projectEdit := tempGui.Add("Edit", "w500 vProject", "MyProject")

    previewEdit := tempGui.Add("Edit", "w500 ReadOnly vPreview")

    tempGui.Add("Button", "w160 Default", "Preview").OnEvent("Click", Preview)
    tempGui.Add("Button", "w160 x+10 yp", "Apply").OnEvent("Click", Apply)
    tempGui.Add("Button", "w160 x+10 yp", "Cancel").OnEvent("Click", (*) => tempGui.Destroy())

    tempGui.Show()

    Preview(*) {
        selectedIdx := templateList.Value

        if selectedIdx = 0 {
            MsgBox("Please select a template.", "Error", 16)
            return
        }

        templateKeys := []
        for template in templates {
            templateKeys.Push(template)
        }

        template := templateKeys[selectedIdx]
        submitted := tempGui.Submit(false)

        newTitle := StrReplace(template, "{TITLE}", currentTitle)
        newTitle := StrReplace(newTitle, "{PROJECT}", submitted.Project)
        newTitle := StrReplace(newTitle, "{DATE}", A_YYYY "-" A_MM "-" A_DD)
        newTitle := StrReplace(newTitle, "{TIME}", A_Hour ":" A_Min)

        previewEdit.Value := newTitle
    }

    Apply(*) {
        if previewEdit.Value = "" {
            MsgBox("Please preview first.", "Error", 16)
            return
        }

        WinSetTitle(previewEdit.Value, "A")
        MsgBox("Template applied successfully!", "Success", 64)
        tempGui.Destroy()
    }
}

; ============================================================================
; Example 6: Incremental Window Numbering
; ============================================================================

/**
* Numbers windows of the same application sequentially
* Helps distinguish between multiple instances
*
* @hotkey F6 - Number windows
*/
F6:: {
    NumberWindows()
}

/**
* Adds sequential numbers to windows
*/
NumberWindows() {
    static numGui := ""

    if numGui {
        try numGui.Destroy()
    }

    numGui := Gui("+AlwaysOnTop", "Number Windows")
    numGui.SetFont("s10", "Segoe UI")

    numGui.Add("Text", "w400", "Select application to number:")

    ; Get unique processes
    processes := Map()
    allWindows := WinGetList()

    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                process := WinGetProcessName(hwnd)
                if !processes.Has(process) {
                    processes[process] := 0
                }
                processes[process]++
            }
        }
    }

    procList := numGui.Add("ListBox", "w400 h200 vProcess")
    procArray := []

    for process, count in processes {
        if count > 1 {  ; Only show processes with multiple windows
        procList.Add([process " (" count " windows)"])
        procArray.Push(process)
    }
}

if procArray.Length = 0 {
    MsgBox("No applications with multiple windows found.", "Info", 64)
    return
}

procList.Choose(1)

numGui.Add("Text", "w400", "Number format:")
formatEdit := numGui.Add("Edit", "w400 vFormat", "[{N}] {TITLE}")

numGui.Add("Button", "w195 Default", "Apply").OnEvent("Click", Apply)
numGui.Add("Button", "w195 x+10 yp", "Cancel").OnEvent("Click", (*) => numGui.Destroy())

numGui.Show()

Apply(*) {
    selectedIdx := procList.Value

    if selectedIdx = 0 || selectedIdx > procArray.Length {
        MsgBox("Please select a process.", "Error", 16)
        return
    }

    selectedProcess := procArray[selectedIdx]
    submitted := numGui.Submit()

    ; Number all windows of this process
    count := 0
    allWindows := WinGetList("ahk_exe " selectedProcess)

    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                count++
                newTitle := StrReplace(submitted.Format, "{N}", count)
                newTitle := StrReplace(newTitle, "{TITLE}", title)
                WinSetTitle(newTitle, hwnd)
            }
        }
    }

    numGui.Destroy()
    MsgBox("Numbered " count " windows of " selectedProcess, "Success", 64)
}
}

; ============================================================================
; Example 7: Title Cleanup and Formatting
; ============================================================================

/**
* Cleans and formats window titles
* Removes extra spaces, special characters, etc.
*
* @hotkey F7 - Clean window title
*/
F7:: {
    CleanWindowTitle()
}

/**
* Cleans and formats the active window title
*/
CleanWindowTitle() {
    static cleanGui := ""

    if cleanGui {
        try cleanGui.Destroy()
    }

    if !WinExist("A") {
        MsgBox("No active window found.", "Error", 16)
        return
    }

    cleanGui := Gui("+AlwaysOnTop", "Clean Window Title")
    cleanGui.SetFont("s10", "Segoe UI")

    currentTitle := WinGetTitle("A")

    cleanGui.Add("Text", "w450", "Original title:")
    cleanGui.Add("Edit", "w450 ReadOnly", currentTitle)

    cleanGui.Add("Text", "w450", "Cleanup options:")
    trimSpaces := cleanGui.Add("CheckBox", "vTrim Checked", "Trim extra spaces")
    removeSpecial := cleanGui.Add("CheckBox", "vSpecial", "Remove special characters (keep alphanumeric and spaces)")
    capitalize := cleanGui.Add("CheckBox", "vCapitalize", "Capitalize first letter of each word")
    removeNumbers := cleanGui.Add("CheckBox", "vNumbers", "Remove numbers")

    previewEdit := cleanGui.Add("Edit", "w450 ReadOnly vPreview")

    cleanGui.Add("Button", "w145 Default", "Preview").OnEvent("Click", Preview)
    cleanGui.Add("Button", "w145 x+10 yp", "Apply").OnEvent("Click", Apply)
    cleanGui.Add("Button", "w145 x+10 yp", "Cancel").OnEvent("Click", (*) => cleanGui.Destroy())

    cleanGui.Show()

    Preview(*) {
        submitted := cleanGui.Submit(false)
        cleaned := currentTitle

        if submitted.Trim {
            cleaned := Trim(cleaned)
            cleaned := RegExReplace(cleaned, "\s+", " ")  ; Multiple spaces to single
        }

        if submitted.Special {
            cleaned := RegExReplace(cleaned, "[^a-zA-Z0-9\s]", "")
        }

        if submitted.Numbers {
            cleaned := RegExReplace(cleaned, "\d", "")
        }

        if submitted.Capitalize {
            cleaned := StrTitle(cleaned)
        }

        previewEdit.Value := cleaned
    }

    Apply(*) {
        if previewEdit.Value = "" {
            MsgBox("Please preview first.", "Error", 16)
            return
        }

        WinSetTitle(previewEdit.Value, "A")
        MsgBox("Title cleaned successfully!", "Success", 64)
        cleanGui.Destroy()
    }
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc::ExitApp()

^F1:: {
    help := "
    (
    WinSetTitle Examples - Part 1 (Set Title)
    ==========================================

    Hotkeys:
    F1 - Change active window title
    F2 - Add prefix/suffix to title
    F3 - Batch rename windows
    F4 - Add timestamp to title
    F5 - Apply title template
    F6 - Number windows sequentially
    F7 - Clean window title
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(help, "Help", 64)
}
