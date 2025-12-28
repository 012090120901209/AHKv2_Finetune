#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * FileDelete() and FileRecycle() - Delete files
 * 
 * FileDelete permanently deletes files, FileRecycle sends them to the recycle bin.
 */

temp1 := A_ScriptDir "\temp1.txt"
temp2 := A_ScriptDir "\temp2.txt"

FileAppend("temp", temp1)
FileAppend("temp", temp2)

FileDelete(temp1)  ; Permanently delete
FileRecycle(temp2)  ; Send to recycle bin

MsgBox("temp1 deleted permanently`ntemp2 sent to recycle bin")
