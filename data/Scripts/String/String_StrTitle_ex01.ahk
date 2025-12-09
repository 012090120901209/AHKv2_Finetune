#Requires AutoHotkey v2.0
#SingleInstance Force

var := "chris mallet"
newvar := StrTitle(var)
if (newvar == "Chris Mallet") FileAppend("it worked", "*")
