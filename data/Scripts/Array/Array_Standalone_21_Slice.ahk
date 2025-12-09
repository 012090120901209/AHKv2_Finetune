#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
* Slice() - Slice array (Standalone Implementation)
*
* Creates a slice of array from start up to end.
*/

Slice(array, start := 1, end := -1) {
    result := []

    if (end = -1) {
        end := array.Length
    }

    loop end - start + 1 {
        index := start + A_Index - 1
        if (index >= 1 && index <= array.Length) {
            result.Push(array[index])
        }
    }

    return result
}

; Examples
result1 := Slice([1, 2, 3], 1, 2)
; => [1, 2]

result2 := Slice([1, 2, 3], 2)
; => [2, 3]

result3 := Slice(["a", "b", "c", "d"], 2, 3)
; => ["b", "c"]

MsgBox("Slice 1-2: " JSON.stringify(result1) "`n"
. "Slice from 2: " JSON.stringify(result2) "`n"
. "Slice 2-3: " JSON.stringify(result3))
