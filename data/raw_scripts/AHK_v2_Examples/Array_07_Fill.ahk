#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <adash>

/**
 * _.fill() - Fill array with value
 *
 * Fills elements of array with value from start up to, but not including, end.
 * Note: This method mutates the array.
 */

arr1 := [1, 2, 3]
_.fill(arr1, "a")
; => ["a", "a", "a"]

arr2 := [4, 6, 8, 10]
result := _.fill(arr2, "*", 2, 4)
; => [4, "*", "*", 10]

MsgBox("Fill all with 'a': " JSON.stringify(arr1) "`n"
    . "Fill positions 2-3 with '*': " JSON.stringify(result))
