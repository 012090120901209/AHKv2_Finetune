#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * WinMinimize() and WinMaximize() - Window state
 * 
 * Minimize or maximize a window.
 */

Run("notepad.exe")
WinWait("ahk_class Notepad", , 2)

MsgBox("Notepad opened. Click OK to minimize it.")
WinMinimize("ahk_class Notepad")
Sleep(1000)

MsgBox("Click OK to maximize it.")
WinMaximize("ahk_class Notepad")
Sleep(1000)

WinClose("ahk_class Notepad")
