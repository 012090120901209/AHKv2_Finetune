#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: _Directives/#Warn_ex1.ah2 ; Removed #Warn UseUnsetGlobal
x := y
MsgBox(x) ; Removed #Warn UseEnv
temp := ""
MsgBox(temp) ; Removed #Warn ClassOverwrite
class MyClass { prop := "Hello, I am a class property."
}
MyClass := MyClass()
