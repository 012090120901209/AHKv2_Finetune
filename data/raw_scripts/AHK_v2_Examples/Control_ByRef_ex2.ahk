#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Flow of Control/ByRef_ex2.ah2 MyFunc(&a, &b) {} MyFunc(&a, &b)
MyFunc(&a, &b), a = b ; Stripped
MyFunc(&a, &b) ; Stripped
