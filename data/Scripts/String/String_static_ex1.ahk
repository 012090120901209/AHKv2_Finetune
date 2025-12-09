#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_static_ex1.ah2

MyFunc() { static var := 1 static var1 := 1, var2, var3 := 3 MsgBox(var)
}
MyFunc()
