#Requires AutoHotkey v2.0
#SingleInstance Force

; Basic AHK v2 example demonstrating variable assignment and control flow
MyVar := "joe"
MyVar2 := "joe2"

if (MyVar = MyVar2)
{
    MsgBox("The contents of MyVar and MyVar2 are identical.")
}
else if (MyVar != "")
{
    MsgBox("MyVar is not empty/blank")
}
