#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow MsgBox(MyFunc()) MyFunc() { var := "hi" return OtherFunc(var, "world", 3)
} OtherFunc(one, two, three) { return one . two
}
