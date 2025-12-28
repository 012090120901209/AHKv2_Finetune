#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinWaitActive_ex1.ah2

Run("notepad.exe")
ErrorLevel := !WinWaitActive("Untitled - Notepad", , 2)
if ErrorLevel
{
    MsgBox("WinWait timed out.")
}
else WinMinimize() ; Use the window found by WinWaitActive.

