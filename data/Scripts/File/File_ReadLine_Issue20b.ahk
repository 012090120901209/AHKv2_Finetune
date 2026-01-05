#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: File, Directory and Disk/FileReadLine_Issue20b.ah2

LineCount := Random(1, 250)
try {
    ErrorLevel := 0
    line := StrSplit(FileRead(A_Desktop "\List.txt"), "`n", "`r")[LineCount]
} catch {
    line := ""
    ErrorLevel := 1
}

if ErrorLevel {
    MsgBox("Failed to read line")
} else {
    MsgBox(line)
}
