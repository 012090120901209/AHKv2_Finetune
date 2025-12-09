#Requires AutoHotkey v2.0
#SingleInstance Force

Concat(one, two := "hello, world") {
    FileAppend(one . two, "*")
}
