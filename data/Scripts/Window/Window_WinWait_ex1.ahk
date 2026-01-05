#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinWait_ex1.ah2

Run("notepad.exe")
ErrorLevel := !WinWait("Untitled - Notepad", , 3)
if ErrorLevel
{
    MsgBox("WinWait timed out.")
}
else WinMinimize() ; Use the window found by WinWait.

