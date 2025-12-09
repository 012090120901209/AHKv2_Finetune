#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* RegExReplace() - Pattern replacement
*
* Replaces occurrences of a pattern (regular expression) within a string.
*/

phone := "123-456-7890"

; Remove dashes
cleaned := RegExReplace(phone, "-", "")

; Format differently
formatted := RegExReplace(phone, "(\d{3})-(\d{3})-(\d{4})", "($1) $2-$3")

MsgBox("Original: " phone
. "`nNo dashes: " cleaned
. "`nReformatted: " formatted)
