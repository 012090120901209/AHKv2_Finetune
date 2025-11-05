#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: String_Assignment_ex13.ah2 ; % should be removed from assignment
var1 := "foo"
var2 := var1 "bar"
Global var3 := var2 " test"
MsgBox(var3)
