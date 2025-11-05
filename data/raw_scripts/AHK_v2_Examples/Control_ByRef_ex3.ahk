#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Flow of Control/ByRef_ex3.ah2 MyFunc(&a, &b) {} MyFunc(&a, &b)
MyFunc(&a, &b), a = b ; Stripped
MyFunc(&a, &b) ; Stripped ; MyFunc(a, b), Ord(1)
; MyFunc(a, b), MyFunc(a, b)
