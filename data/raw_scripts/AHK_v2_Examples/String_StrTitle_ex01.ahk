#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; var := "chris mallet"
newvar := StrTitle(var)
if (newvar == "Chris Mallet") FileAppend("it worked", "*")
