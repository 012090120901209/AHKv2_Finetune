#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force

var := 5
result := (var = 5) ? 5 : 0

Concat(one, two := "hello, world", three := 3, four := "does 2+2 = 4?") {
    FileAppend(one . two . three . four, "*")
}

Concat(result, "test", 1, "end")

