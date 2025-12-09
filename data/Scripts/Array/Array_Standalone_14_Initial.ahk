#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
* Initial() - Get all but last element (Standalone Implementation)
*
* Gets all but the last element of array.
*/

Initial(array) {
    result := []

    loop array.Length - 1 {
        result.Push(array[A_Index])
    }

    return result
}

; Examples
result1 := Initial([1, 2, 3])
; => [1, 2]

result2 := Initial(["a", "b", "c", "d"])
; => ["a", "b", "c"]

MsgBox("Initial of [1,2,3]: " JSON.stringify(result1) "`n"
. "Initial of ['a','b','c','d']: " JSON.stringify(result2))
