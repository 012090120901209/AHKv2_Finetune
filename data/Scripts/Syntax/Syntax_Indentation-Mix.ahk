#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: #Usage_and_Syntax/Indentation-Mix.ah2

if (1) { var := "val" if (var = "hello") ToolTip("this line starts with 2 tab characters") else { if (var = "val") pos := InStr(var, "al") - 1 }
}
FileAppend("pos = " pos, "*")
