#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * FileGetSize() - Get file size
 * 
 * Returns the size of a file in bytes.
 */

testFile := A_ScriptDir "\sizetest.txt"
FileDelete(testFile)
FileAppend("This is a test file with some content.", testFile)

sizeBytes := FileGetSize(testFile)
sizeKB := Round(sizeBytes / 1024, 2)

MsgBox("File size: " sizeBytes " bytes (" sizeKB " KB)")

FileDelete(testFile)
