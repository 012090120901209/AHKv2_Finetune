#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Environment_CaretXY_ex1.ah2 Sleep(1000)
CaretGetPos(&A_CaretX, &A_CaretY), MsgBox("X: " A_CaretX " Y: " A_CaretY) Sleep(1000)
CaretGetPos(&A_CaretX), MsgBox("X: " A_CaretX) Sleep(1000)
CaretGetPos(, &A_CaretY), MsgBox("Y: " A_CaretY)
