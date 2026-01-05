#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * DirMove() - Move/rename directory
 * 
 * Moves or renames a folder.
 */

oldDir := A_ScriptDir "\olddir"
newDir := A_ScriptDir "\newdir"

DirCreate(oldDir)
FileAppend("test", oldDir "\file.txt")

DirMove(oldDir, newDir)

MsgBox("Directory moved/renamed")

DirDelete(newDir, true)
