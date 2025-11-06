#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <adash>

/**
 * _.intersection() - Array intersection
 *
 * Creates an array of unique values that are included in all given arrays.
 * The order of result values are determined by the first array.
 */

result := _.intersection([2, 1], [2, 3])
; => [2]

MsgBox("Intersection of [2,1] and [2,3]:`n"
    . JSON.stringify(result))
