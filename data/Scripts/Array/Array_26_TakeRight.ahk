#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JSON.ahk
#Include ../Lib/adash.ahk

/**
 * _.takeRight() - Take elements from end
 * 
 * Creates a slice of array with n elements taken from the end.
 */

result1 := _.takeRight([1, 2, 3])
; => [3]

result2 := _.takeRight([1, 2, 3], 2)
; => [2, 3]

result3 := _.takeRight([1, 2, 3], 5)
; => [1, 2, 3]

result4 := _.takeRight([1, 2, 3], 0)
; => []

MsgBox("TakeRight 1: " JSON.stringify(result1) "`n"
    . "TakeRight 2: " JSON.stringify(result2) "`n"
    . "TakeRight 5: " JSON.stringify(result3) "`n"
    . "TakeRight 0: " JSON.stringify(result4))
