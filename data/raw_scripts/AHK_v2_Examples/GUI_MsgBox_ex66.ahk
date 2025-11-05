#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow Loop Files, "Yunit\*.*"
{ MsgBox(A_LoopFilePath "`n" A_LoopFileFullPath) break
}
