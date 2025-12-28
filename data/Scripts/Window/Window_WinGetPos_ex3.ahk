#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinGetPos_ex3.ah2

if WinExist("Untitled - Notepad") {
    WinGetPos(&Xpos, &Ypos) ; Use the window found by WinExist. MsgBox("Notepad is at " Xpos ", " Ypos)
}
