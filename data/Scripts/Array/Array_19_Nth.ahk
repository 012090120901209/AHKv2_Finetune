#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../Lib/adash.ahk

/**
 * _.nth() - Get nth element
 * 
 * Gets the element at index n of array.
 * If n is negative, the nth element from the end is returned.
 */

result1 := _.nth([1, 2, 3])
; => 1

result2 := _.nth([1, 2, 3], -3)
; => 1

result3 := _.nth([1, 2, 3], 5)
; => ""

MsgBox("Nth at 1: " result1 "`n"
    . "Nth at -3: " result2 "`n"
    . "Nth at 5: '" result3 "'")
