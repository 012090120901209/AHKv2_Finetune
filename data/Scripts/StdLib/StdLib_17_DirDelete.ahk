#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* DirDelete() - Delete directory
*
* Deletes a folder.
*/

testDir := A_ScriptDir "\tempdir"
DirCreate(testDir)
FileAppend("test", testDir "\file.txt")

DirDelete(testDir, true)  ; true = delete even if not empty
MsgBox("Directory deleted")
