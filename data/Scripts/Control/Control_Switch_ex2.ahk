#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Flow of Control/Switch_ex2.ah2

MyFunc() {
    return 1
}

Switch MyFunc() {
    Case 1:
        MsgBox()
}
