#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Tail() - Get all but first element (Standalone Implementation)
 *
 * Gets all but the first element of array.
 */

Tail(array) {
    result := []
    
    loop array.Length - 1 {
        result.Push(array[A_Index + 1])
    }
    
    return result
}

; Examples
result1 := Tail([1, 2, 3])
; => [2, 3]

result2 := Tail(["a", "b", "c", "d"])
; => ["b", "c", "d"]

MsgBox("Tail of [1,2,3]: " JSON.stringify(result1) "`n"
    . "Tail of ['a','b','c','d']: " JSON.stringify(result2))
