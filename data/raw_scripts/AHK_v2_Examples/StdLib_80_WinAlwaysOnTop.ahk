#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * WinSetAlwaysOnTop() - Set always on top
 *
 * Makes a window stay above other windows.
 */

Run("notepad.exe")
WinWait("ahk_class Notepad", , 2)

WinSetAlwaysOnTop(true, "ahk_class Notepad")
MsgBox("Notepad set to always on top")
Sleep(2000)

WinSetAlwaysOnTop(false, "ahk_class Notepad")
MsgBox("Always on top removed")

WinClose("ahk_class Notepad")
