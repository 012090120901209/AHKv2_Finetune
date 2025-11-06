#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * FileExist() - Check if file exists
 *
 * Returns the file's attributes if it exists, otherwise returns an empty string.
 */

file1 := A_ScriptDir "\exists.txt"
FileDelete(file1)
FileAppend("test", file1)

result1 := FileExist(file1) ? "File exists" : "File not found"
result2 := FileExist(A_ScriptDir "\nonexistent.txt") ? "Exists" : "Not found"

MsgBox(result1 "`n" result2)

FileDelete(file1)
