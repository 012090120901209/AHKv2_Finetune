#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Flow of Control/LoopParse_ex1.ah2 Colors := "red, green, blue"
Loop Parse, Colors, ", "
{ MsgBox("Color number " A_Index " is " A_LoopField ".")
}
