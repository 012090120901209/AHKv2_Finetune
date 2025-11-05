#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Flow of Control/Return_ex1-2.ah2 MyFunc() { ToReturn := "TestError" Return Trim(ToReturn, "Error")
} MsgBox(MyFunc()) MsgBox("Return, Test")
