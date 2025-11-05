#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: String_StringSplit_ex2.ah2 Colors := "red, green, blue"
ColorArray := StrSplit(Colors, ", ")
Loop ColorArray.Length
{ this_color := ColorArray[A_Index] MsgBox("Color number " A_Index " is " this_color ".")
}
