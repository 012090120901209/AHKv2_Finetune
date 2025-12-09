#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/MsgBox_ex3.ah2

msgResult := MsgBox("Do you want to continue? (Press YES or NO)", , 4)
if (msgResult = "No")
