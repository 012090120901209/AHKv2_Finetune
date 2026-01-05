#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * FileGetTime() - Get file timestamp
 * 
 * Returns a file's timestamp (modification, creation, or access time).
 */

testFile := A_ScriptDir "\timetest.txt"
FileDelete(testFile)
FileAppend("test", testFile)

modTime := FileGetTime(testFile, "M")  ; M = modified
createTime := FileGetTime(testFile, "C")  ; C = created

MsgBox("Created: " FormatTime(createTime, "yyyy-MM-dd HH:mm:ss")
    . "`nModified: " FormatTime(modTime, "yyyy-MM-dd HH:mm:ss"))

FileDelete(testFile)
