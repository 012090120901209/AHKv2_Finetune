#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Context-Sensitive Hotkeys - WinActive
 * Hotkeys that only work in specific windows
 */

; Ctrl+N only works in Notepad
#HotIf WinActive("ahk_exe notepad.exe")

^n:: MsgBox("Ctrl+N in Notepad!`n`nThis only works when Notepad is active")
F1:: MsgBox("F1 in Notepad - context-specific help")
#HotIf

; Ctrl+N works differently in Chrome/Edge
#HotIf WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe msedge.exe")

^n:: MsgBox("Ctrl+N in Browser!`n`nSame hotkey, different context")
#HotIf

; Reset context - these work everywhere
#HotIf

F2:: MsgBox("F2 works in ANY window")
#HotIf
