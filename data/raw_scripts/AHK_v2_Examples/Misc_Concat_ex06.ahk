#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force

Concat(one, two := "+5 = 10") {
    FileAppend(one . two, "*")
}
