#Requires AutoHotkey v2.0
#SingleInstance Force
; Source: String_Assignment_ex11.ah2

a := "var"
b := "1"
c := "2"
%a%%b% := "Hi"
%a%%c% := ""
v%a% := "abc"

MsgBox(var1)

if (var2 = "")
MsgBox("empty")
