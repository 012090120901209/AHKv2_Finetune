#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; InputVar := "The Quick Brown Fox Jumps Over the Lazy Dog"
length := StrLen(InputVar)
FileAppend("The length of InputVar is " length ".", "*")
