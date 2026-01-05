#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * FileSetTime() - Set file timestamp
 * 
 * Changes the datetime stamp of one or more files.
 */

testFile := A_ScriptDir "\settimetest.txt"
FileDelete(testFile)
FileAppend("test", testFile)

; Set to specific date/time
FileSetTime("20240101120000", testFile, "M")

newTime := FileGetTime(testFile, "M")
MsgBox("Modified time set to: " FormatTime(newTime, "yyyy-MM-dd HH:mm:ss"))

FileDelete(testFile)
