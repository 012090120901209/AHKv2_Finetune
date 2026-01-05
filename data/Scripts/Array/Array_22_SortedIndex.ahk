#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../Lib/adash.ahk

/**
 * _.sortedIndex() - Find insertion index
 * 
 * Uses binary search to determine the lowest index at which value
 * should be inserted into array in order to maintain its sort order.
 */

result1 := _.sortedIndex([30, 50], 40)
; => 2

result2 := _.sortedIndex([30, 50], 20)
; => 1

result3 := _.sortedIndex([30, 50], 99)
; => 3

MsgBox("Insert 40 in [30,50] at: " result1 "`n"
    . "Insert 20 in [30,50] at: " result2 "`n"
    . "Insert 99 in [30,50] at: " result3)
