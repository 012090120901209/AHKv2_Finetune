#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * StrPtr() - Get string pointer
 *
 * Returns the memory address of a string (for DllCall).
 */

text := "Hello"
ptr := StrPtr(text)

MsgBox("String: " text
    . "`nPointer: " ptr
    . "`n`nUseful for DllCall and API functions")
