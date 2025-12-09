#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_StringSplit_ex1.ah2

TestString := "This is a test."
word_array := StrSplit(TestString, A_Space, ".") ; Omits periods.
MsgBox("The 4th word is " word_array[4] ".")
