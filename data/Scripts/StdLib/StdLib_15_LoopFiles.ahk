#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Loop Files - Iterate through files
*
* Retrieves files or folders one at a time.
*/

; Create test files
testDir := A_ScriptDir "\testfiles"
DirCreate(testDir)

Loop 5
FileAppend("test" A_Index, testDir "\file" A_Index ".txt")

; List all files
output := "Files in folder:`n`n"
Loop Files testDir "\*.txt" {
    output .= A_LoopFileName " (" A_LoopFileSize " bytes)`n"
}

MsgBox(output)

; Cleanup
Loop Files testDir "\*.*"
FileDelete(A_LoopFilePath)
DirDelete(testDir)
