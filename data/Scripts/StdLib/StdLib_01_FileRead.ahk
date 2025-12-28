#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * FileRead() - Read entire file
 * 
 * Reads the entire contents of a file into a variable.
 */

testFile := A_ScriptDir "\test.txt"
FileDelete(testFile)
FileAppend("Line 1`nLine 2`nLine 3", testFile)

content := FileRead(testFile)
MsgBox("File content:`n" content)

FileDelete(testFile)
