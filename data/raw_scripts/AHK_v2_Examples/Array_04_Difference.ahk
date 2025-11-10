#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <adash>

/**
 * _.difference() - Array difference
 *
 * Creates an array of values not included in the other given arrays.
 * The order of result values are determined by the first array.
 */

result := _.difference([2, 1], [2, 3])
; => [1]

MsgBox("Difference between [2, 1] and [2, 3]:`n"
    . JSON.stringify(result))
