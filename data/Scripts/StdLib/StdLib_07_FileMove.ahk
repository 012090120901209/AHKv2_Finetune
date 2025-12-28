#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * FileMove() - Move/rename files
 * 
 * Moves or renames one or more files.
 */

oldName := A_ScriptDir "\oldname.txt"
newName := A_ScriptDir "\newname.txt"

FileDelete(oldName)
FileDelete(newName)
FileAppend("test content", oldName)

FileMove(oldName, newName, true)

exists := FileExist(newName) ? "Yes" : "No"
MsgBox("File moved/renamed`nNew file exists: " exists)

FileDelete(newName)
