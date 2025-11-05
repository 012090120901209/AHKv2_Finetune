#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Graphical User Interfaces/MsgBox_ex10.ah2 Msgbox_Number := 4
Title := "e"
Text := "o"
var := 1
MsgBox(Text, Title, Msgbox_Number " T" 1)
MsgBox(Text, Title, "4 T1")
MsgBox(Text, Title, "4 T" var)
