#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Flow of Control/Switch_ex1.ah2

num := Random(0, 5)

Switch num {
    Case 0:
        MsgBox("Chose letter A")
    Case 1:
        MsgBox("Chose letter B")
    Case 2:
        MsgBox("Chose letter C")
    Case 3:
        MsgBox("Chose letter D")
    Case 4:
        MsgBox("Chose letter E")
    Default:
        MsgBox("Chose letter F")
}
