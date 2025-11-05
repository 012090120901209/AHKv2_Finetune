#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow x := "+plus"
x := SubStr(x, (1)+1) ; leading +x - > x
if (x = "plus") MsgBox(x)
