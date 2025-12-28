#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * StrLen() - Get string length
 * 
 * Returns the number of characters in a string.
 */

text := "Hello World"
length := StrLen(text)
MsgBox("Text: '" text "'`nLength: " length " characters")
