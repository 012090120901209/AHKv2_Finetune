#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * MultiClip - Clipboard History Manager
 * 
 * Demonstrates a clipboard history system with multiple slots,
 * persistent storage, and quick paste functionality.
 * 
 * Source: xypha/AHK-v2-scripts - MultiClip.ahk
 * Inspired by: https://github.com/xypha/AHK-v2-scripts
 */

; Initialize clipboard manager
global MultiClip_arr := []  ; Clipboard history array
global MultiClip_maxSlots := 10  ; Maximum number of slots
global MultiClip_fileBackup := A_ScriptDir "\multiclip_backup.txt"

; Initialize empty slots
MultiClip_Initialize()

; Load previous session
MultiClip_LoadFromFile()

; Monitor clipboard changes
OnClipboardChange(MultiClip_OnChange)

; Display instructions
MsgBox("MultiClip Manager Demo`n`n"
    . "Copy some text to see it saved to clipboard history.`n`n"
    . "Hotkeys:`n"
    . "Ctrl+Shift+V - Show clipboard history`n"
    . "Ctrl+1 to Ctrl+9 - Paste from slot`n"
    . "Ctrl+0 - Paste from slot 10`n`n"
    . "Try copying different text snippets...", , "T5")

; Example hotkeys for accessing clipboard slots
^+v:: MultiClip_ShowMenu()  ; Show menu
^1:: MultiClip_Paste(1)
^2:: MultiClip_Paste(2)
^3:: MultiClip_Paste(3)
^4:: MultiClip_Paste(4)
^5:: MultiClip_Paste(5)
^6:: MultiClip_Paste(6)
^7:: MultiClip_Paste(7)
^8:: MultiClip_Paste(8)
^9:: MultiClip_Paste(9)
^0:: MultiClip_Paste(10)

; Save on exit
OnExit((*) => MultiClip_SaveToFile())

/**
 * Initialize clipboard slots
 */
MultiClip_Initialize() {
    global MultiClip_arr, MultiClip_maxSlots

    Loop MultiClip_maxSlots {
        MultiClip_arr.Push({
            text: "",
            timestamp: "",
            length: 0
        })
    }
}

/**
 * Handle clipboard changes
 */
MultiClip_OnChange(DataType) {
    global MultiClip_arr

    ; Only process text
    if (DataType != 1)
        return

    text := A_Clipboard
    if (text == "" || StrLen(text) > 10000)
        return

    ; Check if already in history (avoid duplicates)
    for slot in MultiClip_arr {
        if (slot.text == text)
            return
    }

    ; Add to history (shift array)
    newSlot := {
        text: text,
        timestamp: FormatTime(, "yyyy-MM-dd HH:mm:ss"),
        length: StrLen(text)
    }

    ; Insert at beginning, remove last
    MultiClip_arr.InsertAt(1, newSlot)
    MultiClip_arr.RemoveAt(MultiClip_maxSlots + 1)

    ; Show notification
    preview := StrLen(text) > 50 ? SubStr(text, 1, 50) "..." : text
    ToolTip("Saved to clipboard history:`n" preview)
    SetTimer(() => ToolTip(), -2000)
}

/**
 * Show clipboard history menu
 */
MultiClip_ShowMenu() {
    global MultiClip_arr

    ; Create menu
    clipMenu := Menu()

    ; Add items
    for index, slot in MultiClip_arr {
        if (slot.text == "")
            continue

        ; Create preview
        preview := StrReplace(slot.text, "`n", " ")
        preview := StrReplace(preview, "`r", "")
        preview := StrLen(preview) > 60 ? SubStr(preview, 1, 60) "..." : preview

        ; Add menu item
        clipMenu.Add(index ". " preview " [" slot.length " chars]", (*) => MultiClip_Paste(index))
    }

    if (clipMenu.GetCount() == 0) {
        MsgBox("Clipboard history is empty", "MultiClip", "T2")
        return
    }

    ; Add separator and options
    clipMenu.Add()
    clipMenu.Add("Clear History", (*) => MultiClip_Clear())

    ; Show menu at mouse position
    clipMenu.Show()
}

/**
 * Paste from clipboard slot
 */
MultiClip_Paste(slotNumber) {
    global MultiClip_arr

    if (slotNumber < 1 || slotNumber > MultiClip_maxSlots)
        return

    slot := MultiClip_arr[slotNumber]
    if (slot.text == "")
        return

    ; Set clipboard and paste
    A_Clipboard := slot.text

    ; Send paste command
    Send("^v")

    ; Show notification
    preview := StrLen(slot.text) > 50 ? SubStr(slot.text, 1, 50) "..." : slot.text
    ToolTip("Pasted from slot " slotNumber ":`n" preview)
    SetTimer(() => ToolTip(), -1500)
}

/**
 * Clear clipboard history
 */
MultiClip_Clear() {
    global MultiClip_arr

    result := MsgBox("Clear all clipboard history?", "MultiClip", "YesNo Icon?")
    if (result == "No")
        return

    MultiClip_Initialize()
    MsgBox("Clipboard history cleared", "MultiClip", "T2")
}

/**
 * Save clipboard history to file
 */
MultiClip_SaveToFile() {
    global MultiClip_arr, MultiClip_fileBackup

    try {
        content := ""
        for slot in MultiClip_arr {
            if (slot.text == "")
                continue

            ; Use delimiter to separate entries
            content .= "===CLIP===`n"
            content .= slot.timestamp "`n"
            content .= slot.text "`n"
        }

        FileDelete(MultiClip_fileBackup)
        FileAppend(content, MultiClip_fileBackup, "UTF-8")
    }
}

/**
 * Load clipboard history from file
 */
MultiClip_LoadFromFile() {
    global MultiClip_arr, MultiClip_fileBackup

    if (!FileExist(MultiClip_fileBackup))
        return

    try {
        content := FileRead(MultiClip_fileBackup, "UTF-8")
        entries := StrSplit(content, "===CLIP===`n")

        index := 1
        for entry in entries {
            if (Trim(entry) == "")
                continue

            lines := StrSplit(entry, "`n", , 2)
            if (lines.Length < 2)
                continue

            MultiClip_arr[index] := {
                text: lines[2],
                timestamp: lines[1],
                length: StrLen(lines[2])
            }

            index++
            if (index > MultiClip_maxSlots)
                break
        }
    }
}

/*
* Key Concepts:
*
* 1. Clipboard Monitoring:
*    OnClipboardChange(callback)
*    DataType: 1=text, 2=non-text
*    Automatic capturing
*
* 2. Array Management:
*    InsertAt(1, item) - Add to front
*    RemoveAt(last) - Remove from end
*    FIFO queue behavior
*
* 3. Slot Storage:
*    text - Clipboard content
*    timestamp - When captured
*    length - Character count
*
* 4. Duplicate Prevention:
*    Check existing entries
*    Don't add same text twice
*    Save storage space
*
* 5. Persistent Storage:
*    Save to file on exit
*    Load on startup
*    UTF-8 encoding
*
* 6. Quick Access:
*    Ctrl+1 to Ctrl+0 - Direct paste
*    Ctrl+Shift+V - Show menu
*    Number key convenience
*
* 7. Menu Display:
*    Preview long text
*    Show character count
*    Click to paste
*
* 8. Use Cases:
*    ✅ Copy multiple items
*    ✅ Paste previous clips
*    ✅ Form filling
*    ✅ Code snippets
*    ✅ Frequently used text
*
* 9. Best Practices:
*    ✅ Limit slot count
*    ✅ Limit text length
*    ✅ Show previews
*    ✅ Save on exit
*    ✅ Handle duplicates
*
* 10. Enhancements:
*     - Search history
*     - Pin favorites
*     - Categories
*     - Image support
*     - Sync across devices
*
* 11. Performance:
*     Keep max slots reasonable (10-25)
*     Limit text size (10,000 chars)
*     Efficient array operations
*
* 12. File Format:
*     ===CLIP=== delimiter
*     Timestamp on first line
*     Text content follows
*     UTF-8 for unicode
*/

