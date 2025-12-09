#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* ControlSend() - Send text to control
*
* Sends keystrokes directly to a control.
*/

Run("notepad.exe")
WinWait("ahk_class Notepad", , 2)

ControlSend("Hello from AHK!{Enter}Line 2{Enter}Line 3", "Edit1", "ahk_class Notepad")
MsgBox("Text sent to Notepad")
Sleep(2000)

WinClose("ahk_class Notepad")
Sleep(500)
Send("{Tab}{Enter}")  ; Don't save
