#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Context-Sensitive - Custom Functions
* Use any custom function to determine hotkey context
*/

; Custom function to check if current app is a text editor
IsTextEditor() {
    return WinActive("ahk_exe notepad.exe")
    or WinActive("ahk_exe Code.exe")
    or WinActive("ahk_exe sublime_text.exe")
    or WinActive("ahk_exe notepad++.exe")
}

; Custom function to check clipboard content
ClipboardHasText() {
    return (A_Clipboard != "" and !InStr(A_Clipboard, "..."))
}

; Only works in text editors
#HotIf IsTextEditor()

^!f::MsgBox("Ctrl+Alt+F in a text editor!")
#HotIf

; Only when clipboard has text
#HotIf ClipboardHasText()

^!v::MsgBox("Enhanced paste!`n`nClipboard: " SubStr(A_Clipboard, 1, 50))
#HotIf

; Complex condition: Text editor AND clipboard has content
#HotIf IsTextEditor() and ClipboardHasText()

F9::MsgBox("F9: In editor with clipboard content")
#HotIf

#HotIf  ; Reset
