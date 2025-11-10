#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <adash>

/**
 * _.lastIndexOf() - Find last index of value
 *
 * Like _.indexOf except that it iterates from right to left.
 */

result1 := _.lastIndexOf([1, 2, 1, 2], 2)
; => 4

result2 := _.lastIndexOf([1, 2, 1, 2], 1, 3)
; => 3 (search from index 3)

MsgBox("LastIndexOf 2: " result1 "`n"
    . "LastIndexOf 1 from position 3: " result2)
