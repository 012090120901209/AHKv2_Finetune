#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JSON.ahk
#Include ../Lib/adash.ahk

/**
 * _.dropRight() - Drop elements from end
 * 
 * Creates a slice of array with n elements dropped from the end.
 */

result1 := _.dropRight([1, 2, 3])
; => [1, 2]

result2 := _.dropRight([1, 2, 3], 2)
; => [1]

result3 := _.dropRight([1, 2, 3], 5)
; => []

result4 := _.dropRight([1, 2, 3], 0)
; => [1, 2, 3]

MsgBox("Drop right 1: " JSON.stringify(result1) "`n"
    . "Drop right 2: " JSON.stringify(result2) "`n"
    . "Drop right 5: " JSON.stringify(result3) "`n"
    . "Drop right 0: " JSON.stringify(result4))
