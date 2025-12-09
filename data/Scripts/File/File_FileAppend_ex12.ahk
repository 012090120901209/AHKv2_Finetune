#Requires AutoHotkey v2.0
#SingleInstance Force

MyVar := "joe"
MyVar2 := ""
if (MyVar = MyVar2) FileAppend("The contents of MyVar and MyVar2 are identical.", "*")
else if (MyVar = "") FileAppend("MyVar is empty/blank", "*")
