#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinActive_ex1.ah2

if WinActive("Untitled - Notepad") {
    WinMaximize() ; Use the window found by IfWinActive. Send("Some text.{Enter}")
}
