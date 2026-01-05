#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Context-Sensitive - Caret Position
 * Hotkeys based on text cursor location
 */

; Function to check if caret is in top half of screen
CaretInTopHalf() {
    try {
        ; Try to get caret position
        CaretGetPos(&caretX, &caretY)
        return (caretY < A_ScreenHeight / 2)
    } catch {
        return false
    }
}

; Function to check if text is selected
TextIsSelected() {
    ; Save current clipboard
    savedClip := A_Clipboard
    A_Clipboard := ""

    ; Try to copy selection
    Send("^c")
    ClipWait(0.1)

    result := (A_Clipboard != "")

    ; Restore clipboard
    A_Clipboard := savedClip

    return result
}

; Different behavior based on caret position
#HotIf CaretInTopHalf()

^!Up:: MsgBox("Caret in TOP half of screen")
#HotIf

; Only when text is selected
#HotIf TextIsSelected()

^!c:: MsgBox("Text is selected!`n`nCustom copy operation")
#HotIf

#HotIf  ; Reset

