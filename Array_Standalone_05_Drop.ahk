#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Drop() - Drop elements from beginning (Standalone Implementation)
 *
 * Creates a slice of array with n elements dropped from the beginning.
 */

Drop(array, n := 1) {
    result := []
    
    ; Start from position n+1
    loop array.Length - n {
        if (A_Index + n <= array.Length) {
            result.Push(array[A_Index + n])
        }
    }
    
    return result
}

; Examples
result1 := Drop([1, 2, 3])
; => [2, 3]

result2 := Drop([1, 2, 3], 2)
; => [3]

result3 := Drop([1, 2, 3], 5)
; => []

result4 := Drop([1, 2, 3], 0)
; => [1, 2, 3]

MsgBox("Drop 1: " JSON.stringify(result1) "`n"
    . "Drop 2: " JSON.stringify(result2) "`n"
    . "Drop 5: " JSON.stringify(result3) "`n"
    . "Drop 0: " JSON.stringify(result4))
