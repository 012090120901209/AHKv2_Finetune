#Requires AutoHotkey v2.0 AutoHotkey v2.0
#SingleInstance Force ; Source: Flow of Control/ByRef_ex1.ah2

a := 1
b := 2
MsgBox(a "" b)
Swap(&a, &b)
MsgBox(a " " b)

Swap(&Left, &Right) {
    temp := Left
    Left := Right
    Right := temp
}
