#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_Assignment_ex7.ah2

var := "`"" MyFunc() "`""
MsgBox(var) MyFunc() {
    return "Works"
}
