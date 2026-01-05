#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Environment_CaretXY_ex2.ah2

Persistent
Sleep(1000)
SetTimer(WatchCaret, 100)
WatchCaret()
WatchCaret() {
    CaretGetPos(&A_CaretX, &A_CaretY), ToolTip("X" A_CaretX " Y" A_CaretY, A_CaretX, A_CaretY - 20)
}
