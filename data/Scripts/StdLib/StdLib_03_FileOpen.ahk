#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * FileOpen() - File object for reading/writing
 * 
 * Opens a file and returns a file object with methods like ReadLine(), WriteLine(), etc.
 */

dataFile := A_ScriptDir "\data.txt"

; Write mode
file := FileOpen(dataFile, "w")
file.WriteLine("First line")
file.WriteLine("Second line")
file.Write("Third line without newline")
file.Close()

; Read mode
file := FileOpen(dataFile, "r")
MsgBox("Line 1: " file.ReadLine()
    . "`nLine 2: " file.ReadLine()
    . "`nRemaining: " file.Read())
file.Close()

FileDelete(dataFile)
