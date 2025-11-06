#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <adash>

/**
 * _.initial() - Get all but last element
 *
 * Gets all but the last element of array.
 */

result1 := _.initial([1, 2, 3])
; => [1, 2]

result2 := _.initial("neo")
; => ["n", "e"]

MsgBox("Initial of [1,2,3]: " JSON.stringify(result1) "`n"
    . "Initial of 'neo': " JSON.stringify(result2))
