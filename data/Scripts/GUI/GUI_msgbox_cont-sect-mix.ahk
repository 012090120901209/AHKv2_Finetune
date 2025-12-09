#Requires AutoHotkey v2.0
#SingleInstance Force
; Source: Graphical User Interfaces/msgbox_cont-sect-mix.ah2

var := "val"
if (var = "val")
MsgBox("1p simple")

if (var = "val")
MsgBox(" 1p forced")

if (var = "val")
MsgBox("4p simple only text", "title", 1)

if (var = "val")
MsgBox(" 4p forced only text", "title", 1)

if (var = "val")
MsgBox("4p simple with timeout", "title", "T4")

if (var = "val")
MsgBox(" 4p forced with timeout", "title", "T4")
