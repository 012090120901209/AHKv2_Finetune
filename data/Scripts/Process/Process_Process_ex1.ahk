#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Process_Process_ex1.ah2

Run("notepad.exe", , , &NewPID)
ProcessSetPriority("High", NewPID)
MsgBox("The newly launched Notepad's PID is " NewPID ".")
