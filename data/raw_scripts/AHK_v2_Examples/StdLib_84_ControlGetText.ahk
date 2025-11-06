#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ControlGetText() - Get control text
 *
 * Retrieves text from a control.
 */

Run("notepad.exe")
WinWait("ahk_class Notepad", , 2)

ControlSend("Sample text", "Edit1", "ahk_class Notepad")
Sleep(500)

text := ControlGetText("Edit1", "ahk_class Notepad")
MsgBox("Text in Notepad: '" text "'")

WinClose("ahk_class Notepad")
Sleep(500)
Send("{Tab}{Enter}")
