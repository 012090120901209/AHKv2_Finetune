#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * FileCopy() - Copy files
 * 
 * Copies one or more files.
 */

source := A_ScriptDir "\source.txt"
dest := A_ScriptDir "\destination.txt"

FileDelete(source)
FileDelete(dest)
FileAppend("Original content", source)

FileCopy(source, dest, true)  ; true = overwrite if exists

MsgBox("Source: " FileRead(source) "`nDestination: " FileRead(dest))

FileDelete(source)
FileDelete(dest)
