#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Colors := "red, green, blue"
Loop Parse, Colors, ", "
{ MsgBox("Color number " A_Index " is " A_LoopField ".")
}
