#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Context-Sensitive - WinExist
 * Hotkeys based on window existence (not just active)
 */

; F5 only works if Notepad exists anywhere
#HotIf WinExist("ahk_exe notepad.exe")

F5:: {
    WinActivate("ahk_exe notepad.exe")
    MsgBox("F5 activated Notepad`n`n(Only works if Notepad exists)")
}
#HotIf

; Ctrl+W closes Notepad if it exists
#HotIf WinExist("ahk_exe notepad.exe")

^w:: {
    if WinExist("ahk_exe notepad.exe") {
        WinClose("ahk_exe notepad.exe")
        MsgBox("Closed Notepad")
    }
}
#HotIf

; Works only when NO Notepad exists
#HotIf !WinExist("ahk_exe notepad.exe")

F6:: MsgBox("F6: No Notepad window found`n`nThis hotkey only works when Notepad is NOT open")
#HotIf
