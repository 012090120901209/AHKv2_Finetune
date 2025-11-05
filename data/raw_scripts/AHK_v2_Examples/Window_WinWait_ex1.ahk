#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Window_WinWait_ex1.ah2 Run("notepad.exe")
ErrorLevel := ! WinWait("Untitled - Notepad", , 3)
if ErrorLevel
{ MsgBox("WinWait timed out.")
}
else WinMinimize() ; Use the window found by WinWait.
