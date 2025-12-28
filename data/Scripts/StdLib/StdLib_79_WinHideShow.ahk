#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * WinHide() and WinShow() - Hide/show window
 * 
 * Makes a window invisible or visible.
 */

Run("notepad.exe")
WinWait("ahk_class Notepad", , 2)

MsgBox("Click OK to hide Notepad")
WinHide("ahk_class Notepad")
Sleep(2000)

MsgBox("Click OK to show Notepad")
WinShow("ahk_class Notepad")
Sleep(2000)

WinClose("ahk_class Notepad")
