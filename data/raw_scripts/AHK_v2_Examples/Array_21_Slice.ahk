#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <adash>

/**
 * _.slice() - Slice array
 *
 * Creates a slice of array from start up to end.
 */

result1 := _.slice([1, 2, 3], 1, 2)
; => [1, 2]

result2 := _.slice([1, 2, 3], 1)
; => [1, 2, 3]

result3 := _.slice([1, 2, 3], 5)
; => []

MsgBox("Slice 1-2: " JSON.stringify(result1) "`n"
    . "Slice from 1: " JSON.stringify(result2) "`n"
    . "Slice from 5: " JSON.stringify(result3))
