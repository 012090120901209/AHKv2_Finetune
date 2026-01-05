#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinGetActiveStats_ex1.ah2

Title := WinGetTitle("A")
WinGetPos(&X, &Y, &Width, &Height, "A")
MsgBox("The active window `"" Title "`" is " Width " wide, " Height " tall, and positioned at " X ", " Y ".")
