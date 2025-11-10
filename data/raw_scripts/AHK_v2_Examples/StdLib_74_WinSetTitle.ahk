#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * WinSetTitle() - Set window title
 *
 * Changes the title of a window.
 */

Run("notepad.exe")
WinWait("ahk_class Notepad", , 2)

WinSetTitle("My Custom Notepad Title", "ahk_class Notepad")
MsgBox("Window title changed")
Sleep(2000)

WinClose("ahk_class Notepad")
