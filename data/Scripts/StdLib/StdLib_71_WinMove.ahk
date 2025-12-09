#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* WinMove() - Move and resize window
*
* Changes window position and size.
*/

Run("notepad.exe")
WinWait("ahk_class Notepad", , 2)

MsgBox("Moving window to (100, 100) with size 600x400")
WinMove(100, 100, 600, 400, "ahk_class Notepad")
Sleep(2000)

WinClose("ahk_class Notepad")
