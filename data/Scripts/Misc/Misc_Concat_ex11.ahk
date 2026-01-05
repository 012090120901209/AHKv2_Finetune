#Requires AutoHotkey v2.0
#SingleInstance Force

Basic AHK v2 example demonstrating variable assignment and control flow var := 5
Concat((var = 5) ? 5 : 0) Concat(one, two := "hello, world", three := 3, four := "does 2+2 = 4?") {
    MsgBox(one . two . three . four)
}
