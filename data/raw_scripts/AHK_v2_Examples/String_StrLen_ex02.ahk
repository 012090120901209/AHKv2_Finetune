#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow InputVar := "The Quick Brown Fox Jumps Over the Lazy Dog"
length := StrLen(InputVar)
MsgBox("The length of InputVar is " length ".")
