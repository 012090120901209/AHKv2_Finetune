; Title: Hotkeys - Keyboard Shortcuts
; Category: Hotkey
; Source: https://www.autohotkey.com/docs/v2/Hotkeys.htm
; Description: Various hotkey and hotstring examples including context-sensitive hotkeys and dynamic hotkey creation.

#Requires AutoHotkey v2.0

; Simple hotkey - Press Ctrl+J to trigger
^j::MsgBox "You pressed Ctrl+J"

; Hotkey with multiple lines
^k:: {
    MsgBox "Starting process..."
    ; Do something
    MsgBox "Process complete!"
}

; Hotstring - Type "btw" and it expands to "by the way"
::btw::by the way

; Context-sensitive hotkey - Only works in Notepad
#HotIf WinActive("ahk_exe notepad.exe")

^s:: {
    MsgBox "Saving in Notepad with custom behavior"
    Send "^s"  ; Still send the normal Save
}
#HotIf

; Dynamic hotkey creation
Hotkey "^!n", NotePadHandler

NotePadHandler(*) {
    Run "notepad.exe"
}

; Mouse hotkey
MButton::MsgBox "You clicked the middle mouse button"
