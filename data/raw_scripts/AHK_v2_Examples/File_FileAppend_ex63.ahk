#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Loop Files, "Yunit\*.*"
{ FileAppend(A_LoopFilePath "`n" A_LoopFileFullPath, "*") break
}
