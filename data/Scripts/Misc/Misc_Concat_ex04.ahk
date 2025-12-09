#Requires AutoHotkey v2.0
#SingleInstance Force

Concat(5)

Concat(one, two := "hello, world") {
    MsgBox(one . two)
}
