#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
* Reverse() - Reverse array (Standalone Implementation)
*
* Reverses array so that the first element becomes the last.
*/

Reverse(array) {
    result := []

    loop array.Length {
        result.Push(array[array.Length - A_Index + 1])
    }

    return result
}

; Examples
result1 := Reverse(["a", "b", "c"])
; => ["c", "b", "a"]

result2 := Reverse([1, 2, 3, 4, 5])
; => [5, 4, 3, 2, 1]

MsgBox("Reverse ['a','b','c']: " JSON.stringify(result1) "`n"
. "Reverse [1,2,3,4,5]: " JSON.stringify(result2))
