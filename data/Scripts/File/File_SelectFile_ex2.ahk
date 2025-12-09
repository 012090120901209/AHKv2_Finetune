#Requires AutoHotkey v2.0
#SingleInstance Force
; Source: File, Directory and Disk/FileSelectFile_ex2.ah2

MyVar := FileSelect()
if (MyVar = "") {
    ErrorLevel := 1
} else {
    ErrorLevel := 0
}
if not ErrorLevel
MsgBox(MyVar)
MsgBox(ErrorLevel)

oMyVar := FileSelect("M")
MyVar := ""
for FileName in oMyVar
 {
    MyVar .= A_Index = 1 ? RegExReplace(FileName, "(.+)\\(.*)", "$1`r`n$2`r`n") : RegExReplace(FileName, ".+\\(.*)",
    "$1`r`n")
}
if (MyVar = "") {
    ErrorLevel := 1
} else {
    ErrorLevel := 0
}
if not ErrorLevel
MsgBox(MyVar)
MsgBox(ErrorLevel)
