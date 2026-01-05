#Requires AutoHotkey v2.0
#SingleInstance Force

; Source: Failed_Conversions_MsgBox_ex11.ah2

; Note: This is a failed conversion example - msgbox with switch statement

Var := 1

switch (Var) {
    case 1:
        msgResult := MsgBox("Test1")
    case 2:
        msgResult := MsgBox("Test2")
}

if (msgResult = "Ok")
    MsgBox()
