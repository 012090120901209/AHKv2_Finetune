#Requires AutoHotkey v2.0
#SingleInstance Force

Concat("joe, says, ")

Concat(one, two := "hello, world") {
    MsgBox(one . two)
}
