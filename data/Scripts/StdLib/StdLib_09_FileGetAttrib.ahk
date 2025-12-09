#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* FileGetAttrib() - Get file attributes
*
* Returns a file's attributes (R=readonly, H=hidden, A=archive, etc.).
*/

testFile := A_ScriptDir "\attrtest.txt"
FileDelete(testFile)
FileAppend("test", testFile)

attrib := FileGetAttrib(testFile)

output := "File attributes: " attrib "`n`n"
output .= "Read-only: " (InStr(attrib, "R") ? "Yes" : "No") "`n"
output .= "Hidden: " (InStr(attrib, "H") ? "Yes" : "No") "`n"
output .= "Archive: " (InStr(attrib, "A") ? "Yes" : "No")

MsgBox(output)

FileDelete(testFile)
