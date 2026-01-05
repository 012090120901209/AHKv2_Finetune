#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Flow of Control/ifVarContains_ex1.ah2

var := "exe"
if (var ~= "^(?i:exe|bat|com)$")
    MsgBox("The file extension is an executable type.")
