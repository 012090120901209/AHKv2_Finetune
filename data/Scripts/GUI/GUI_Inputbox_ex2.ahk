#Requires AutoHotkey v2.0
#SingleInstance Force
; Source: Graphical User Interfaces/Inputbox_ex2.ah2

IB := InputBox("Please enter a phone number.", "Phone Number", "w640 h480")
UserInput := IB.Value
ErrorLevel := IB.Result = "OK" ? 0 : IB.Result = "CANCEL" ? 1 : IB.Result = "Timeout" ? 2 : "ERROR"

if ErrorLevel
    MsgBox("CANCEL was pressed.")
else
    MsgBox("You entered `"" UserInput "`"")
