#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; FileAppend(MyFunc(), "*") MyFunc() { var := "hi" return OtherFunc(var, "world", 3)
} OtherFunc(one, two, three) { return one . two
}
