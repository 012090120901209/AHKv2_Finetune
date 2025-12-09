#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_PrePostXcrement-Ordering.ah2

i := 0
e := i++ . i
MsgBox(e) i := 0
j := 0
e := i++ . j
MsgBox(e)
