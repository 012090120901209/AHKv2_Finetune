#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinGet_ex3.ah2

oActiveControlList := WinGetControls("A")
for v in oActiveControlList {
    ActiveControlList .= (A_Index = 1) ? v : "`r`n" v
}
loop parse, ActiveControlList, "`n" {
    msgResult := MsgBox("Control #" A_Index " is `"" A_LoopField "`". Continue?", , 4)
    if (msgResult = "No")
    break
}
return
