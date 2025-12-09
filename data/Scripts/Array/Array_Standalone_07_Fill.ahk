#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
* Fill() - Fill array with value (Standalone Implementation)
*
* Fills elements of array with value from start up to, but not including, end.
* Note: This mutates the original array.
*/

Fill(array, value, start := 1, end := -1) {
    if (end = -1) {
        end := array.Length
    }

    loop end - start + 1 {
        index := start + A_Index - 1
        if (index <= array.Length) {
            array[index] := value
        }
    }

    return array
}

; Examples
arr1 := [1, 2, 3]
Fill(arr1, "a")
; => ["a", "a", "a"]

arr2 := [4, 6, 8, 10]
Fill(arr2, "*", 2, 3)
; => [4, "*", "*", 10]

MsgBox("Fill all with 'a': " JSON.stringify(arr1) "`n"
. "Fill positions 2-3 with '*': " JSON.stringify(arr2))
