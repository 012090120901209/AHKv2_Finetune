#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* WinWait() - Wait for window
*
* Pauses until a window appears.
*/

MsgBox("Open Notepad within 5 seconds...")

if WinWait("ahk_class Notepad", , 5)
MsgBox("Notepad found!")
else
MsgBox("Timeout - Notepad not found")
