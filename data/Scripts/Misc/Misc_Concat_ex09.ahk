#Requires AutoHotkey v2.0
#SingleInstance Force

Basic AHK v2 example demonstrating variable assignment and control flow var := 1
Concat((var = 5) ? 5 : 0) Concat(one, two := "2") { MsgBox(one + two)
}
