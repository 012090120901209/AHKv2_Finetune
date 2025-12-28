#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Flow of Control/Return_ex1-2.ah2

MyFunc() {
    ToReturn := "TestError"
    return Trim(ToReturn, "Error")
}

MsgBox(MyFunc())
MsgBox("Return, Test")
