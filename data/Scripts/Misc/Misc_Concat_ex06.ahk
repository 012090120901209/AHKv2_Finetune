#Requires AutoHotkey v2.0
#SingleInstance Force

Concat(one, two := "+5 = 10") {
    FileAppend(one . two, "*")
}
