#Requires AutoHotkey v2.0
#SingleInstance Force

Basic AHK v2 example demonstrating variable assignment and control flow five := MyFunc()
MsgBox(five)
MyFunc(var := 5) {
    return var
}
