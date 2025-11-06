#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * StrSplit() - Split string into array
 *
 * Separates a string into an array of substrings using specified delimiters.
 */

csv := "apple,banana,orange,grape"

parts := StrSplit(csv, ",")

output := "Original: " csv "`n`nParts:`n"
for index, value in parts
    output .= index ". " value "`n"

MsgBox(output)
