#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Flow of Control/ByRef_ex4.ah2 Join(a, &b) { b . = a
} Str := 123 Join("abc", &Str) MsgBox(Str)
