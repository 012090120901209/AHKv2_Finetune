#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* FileSetAttrib() - Set file attributes
*
* Changes the attributes of one or more files.
*/

testFile := A_ScriptDir "\setattr.txt"
FileDelete(testFile)
FileAppend("test", testFile)

FileSetAttrib("+R", testFile)  ; Make read-only
MsgBox("File set to read-only")

FileSetAttrib("-R", testFile)  ; Remove read-only
MsgBox("Read-only removed")

FileDelete(testFile)
