#Requires AutoHotkey v2.0
#SingleInstance Force

if MyFunc()
    MsgBox(var)

MyFunc() {
    global var := 777
    return true
}
