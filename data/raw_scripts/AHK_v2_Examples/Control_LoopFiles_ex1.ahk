#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Flow of Control/LoopFiles_ex1.ah2 Loop Files, A_ProgramFiles "\*.txt", "R" ; Recurse into subfolders.
{ msgResult := MsgBox("Filename = " A_LoopFilePath "`n`nContinue?", , 4) if (msgResult = "No") break
}
