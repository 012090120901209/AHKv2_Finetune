#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JSON.ahk

/**
 * Take() - Take elements from beginning (Standalone Implementation)
 * 
 * Creates a slice of array with n elements taken from the beginning.
 */

Take(array, n := 1) {
    result := []

    takeCount := Min(n, array.Length)

    loop takeCount {
        result.Push(array[A_Index])
    }

    return result
}

; Examples
result1 := Take([1, 2, 3])
; => [1]

result2 := Take([1, 2, 3], 2)
; => [1, 2]

result3 := Take([1, 2, 3], 5)
; => [1, 2, 3]

result4 := Take([1, 2, 3], 0)
; => []

MsgBox("Take 1: " JSON.stringify(result1) "`n"
    . "Take 2: " JSON.stringify(result2) "`n"
    . "Take 5: " JSON.stringify(result3) "`n"
    . "Take 0: " JSON.stringify(result4))
