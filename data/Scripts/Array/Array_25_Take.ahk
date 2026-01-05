#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JSON.ahk
#Include ../Lib/adash.ahk

/**
 * _.take() - Take elements from beginning
 * 
 * Creates a slice of array with n elements taken from the beginning.
 */

result1 := _.take([1, 2, 3])
; => [1]

result2 := _.take([1, 2, 3], 2)
; => [1, 2]

result3 := _.take([1, 2, 3], 5)
; => [1, 2, 3]

result4 := _.take([1, 2, 3], 0)
; => []

MsgBox("Take 1: " JSON.stringify(result1) "`n"
    . "Take 2: " JSON.stringify(result2) "`n"
    . "Take 5: " JSON.stringify(result3) "`n"
    . "Take 0: " JSON.stringify(result4))
