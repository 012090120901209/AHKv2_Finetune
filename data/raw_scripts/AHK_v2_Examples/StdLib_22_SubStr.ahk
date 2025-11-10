#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * SubStr() - Extract substring
 *
 * Retrieves one or more characters from the specified position in a string.
 */

text := "AutoHotkey v2.0"

sub1 := SubStr(text, 1, 10)  ; First 10 chars
sub2 := SubStr(text, 12)     ; From position 12 to end
sub3 := SubStr(text, -3)     ; Last 3 chars

MsgBox("Original: " text
    . "`nFirst 10: " sub1
    . "`nFrom 12: " sub2
    . "`nLast 3: " sub3)
