#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Trim/LTrim/RTrim() - Remove whitespace
 * 
 * Removes spaces and tabs from the beginning/end of a string.
 */

text := "   Hello World   "

trimmed := Trim(text)
ltrimmed := LTrim(text)
rtrimmed := RTrim(text)

MsgBox("Original: '" text "'`n"
    . "Trim: '" trimmed "'`n"
    . "LTrim: '" ltrimmed "'`n"
    . "RTrim: '" rtrimmed "'")
