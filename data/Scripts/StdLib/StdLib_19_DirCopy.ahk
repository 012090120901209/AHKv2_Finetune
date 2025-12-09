#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* DirCopy() - Copy directory
*
* Copies a folder along with all its sub-folders and files.
*/

sourceDir := A_ScriptDir "\sourcedir"
destDir := A_ScriptDir "\destdir"

; Create source with files
DirCreate(sourceDir)
FileAppend("file1", sourceDir "\file1.txt")
FileAppend("file2", sourceDir "\file2.txt")

; Copy
DirCopy(sourceDir, destDir, true)

MsgBox("Directory copied")

; Cleanup
DirDelete(sourceDir, true)
DirDelete(destDir, true)
