#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* WinSetTransparent() - Set transparency
*
* Makes a window semi-transparent (0-255).
*/

Run("notepad.exe")
WinWait("ahk_class Notepad", , 2)

WinSetTransparent(150, "ahk_class Notepad")  ; 0-255
MsgBox("Notepad transparency set to 150")
Sleep(2000)

WinSetTransparent("Off", "ahk_class Notepad")
WinClose("ahk_class Notepad")
