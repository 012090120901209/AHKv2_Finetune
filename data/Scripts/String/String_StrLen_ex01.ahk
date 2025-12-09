#Requires AutoHotkey v2.0
#SingleInstance Force

InputVar := "The Quick Brown Fox Jumps Over the Lazy Dog"
length := StrLen(InputVar)
FileAppend("The length of InputVar is " length ".", "*")
