#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Flow of Control/LoopParse_ex3.ah2

Loop Parse, A_Clipboard, "`n", "`r"
{
    msgResult := MsgBox("File number " A_Index " is " A_LoopField ".`n`nContinue?", , 4)
    if (msgResult = "No")
        break
}
