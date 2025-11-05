#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; x := "+plus"
x := SubStr(x, (1)+1) ; leading +x - > x
if (x = "plus") FileAppend(x, "*")
