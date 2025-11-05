#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force

Concat(one, two := "hello, world") {
    FileAppend(one . two, "*")
}
