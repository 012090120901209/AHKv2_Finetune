#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Run() - Run program
 * 
 * Launches an external program or document.
 */

Run("notepad.exe")
MsgBox("Notepad launched")
Sleep(2000)
WinClose("ahk_class Notepad")
