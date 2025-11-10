#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <adash>

/**
 * _.indexOf() - Find index of value
 *
 * Gets the index at which the first occurrence of value is found in array.
 * If fromIndex is negative, it's used as the offset from the end.
 */

result1 := _.indexOf([1, 2, 1, 2], 2)
; => 2

result2 := _.indexOf([1, 2, 1, 2], 2, 3)
; => 4 (search from index 3)

MsgBox("IndexOf 2 in [1,2,1,2]: " result1 "`n"
    . "IndexOf 2 from position 3: " result2)
