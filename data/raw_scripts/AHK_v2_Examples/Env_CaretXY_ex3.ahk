#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Environment_CaretXY_ex3.ah2 CheckCaret := true
Sleep(1000) if CheckCaret CaretGetPos(&A_CaretX, &A_CaretY), MsgBox("A_CaretX: " A_CaretX "`nA_CaretY: " A_CaretY)
