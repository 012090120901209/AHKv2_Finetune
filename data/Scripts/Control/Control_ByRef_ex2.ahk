#Requires AutoHotkey v2.0
#SingleInstance Force

; Demonstrates ByRef parameters mutating their callers' variables.
MyFunc(&a, &b) {
    a .= "!"
    b := a . b
}

a := "first"
b := "second"
MyFunc(&a, &b)

MsgBox("After MyFunc()`n`na = " a "`nb = " b)
