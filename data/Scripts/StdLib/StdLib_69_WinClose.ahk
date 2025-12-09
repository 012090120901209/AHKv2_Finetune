#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* WinClose() - Close window
*
* Sends a close command to a window.
*/

Run("notepad.exe")
WinWait("ahk_class Notepad", , 2)

MsgBox("Notepad opened. Click OK to close it.")

WinClose("ahk_class Notepad")
MsgBox("Notepad closed")
