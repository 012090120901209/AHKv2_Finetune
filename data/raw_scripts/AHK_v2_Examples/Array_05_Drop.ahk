#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <adash>

/**
 * _.drop() - Drop elements from beginning
 *
 * Creates a slice of array with n elements dropped from the beginning.
 */

result1 := _.drop([1, 2, 3])
; => [2, 3]

result2 := _.drop([1, 2, 3], 2)
; => [3]

result3 := _.drop([1, 2, 3], 5)
; => []

result4 := _.drop([1, 2, 3], 0)
; => [1, 2, 3]

MsgBox("Drop 1: " JSON.stringify(result1) "`n"
    . "Drop 2: " JSON.stringify(result2) "`n"
    . "Drop 5: " JSON.stringify(result3) "`n"
    . "Drop 0: " JSON.stringify(result4))
