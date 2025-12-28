#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * FileAppend() - Append to file
 * 
 * Appends text to the end of a file (creates it if it doesn't exist).
 */

logFile := A_ScriptDir "\log.txt"
FileDelete(logFile)

FileAppend("Log entry 1`n", logFile)
FileAppend("Log entry 2`n", logFile)
FileAppend("Log entry 3`n", logFile)

content := FileRead(logFile)
MsgBox("Log file:`n" content)

FileDelete(logFile)
