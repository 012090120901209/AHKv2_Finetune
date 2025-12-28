#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: File, Directory and Disk/FileGetShortcut.ah2

file2 := FileSelect(32, "", "Pick a shortcut to analyze.", "Shortcuts (*.lnk)")
if (file2 = "")
    FileGetShortcut(file2, &OutTarget, &OutDir, &OutArgs, &OutDesc, &OutIcon, &OutIconNum, &OutRunState)
MsgBox(OutTarget "`n" OutDir "`n" OutArgs "`n" OutDesc "`n" OutIcon "`n" OutIconNum "`n" OutRunState)
