#Requires AutoHotkey v2.0
#SingleInstance Force

var := 5
result := (var = 5) ? 5 : 0

Concat(one, two := "2") {
    FileAppend(one . two, "*")
}

Concat(result, "test")

