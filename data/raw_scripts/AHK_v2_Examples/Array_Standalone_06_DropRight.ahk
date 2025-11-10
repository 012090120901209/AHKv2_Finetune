#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * DropRight() - Drop elements from end (Standalone Implementation)
 *
 * Creates a slice of array with n elements dropped from the end.
 */

DropRight(array, n := 1) {
    result := []
    
    ; Take all elements except the last n
    keepCount := Max(0, array.Length - n)
    
    loop keepCount {
        result.Push(array[A_Index])
    }
    
    return result
}

; Examples
result1 := DropRight([1, 2, 3])
; => [1, 2]

result2 := DropRight([1, 2, 3], 2)
; => [1]

result3 := DropRight([1, 2, 3], 5)
; => []

result4 := DropRight([1, 2, 3], 0)
; => [1, 2, 3]

MsgBox("DropRight 1: " JSON.stringify(result1) "`n"
    . "DropRight 2: " JSON.stringify(result2) "`n"
    . "DropRight 5: " JSON.stringify(result3) "`n"
    . "DropRight 0: " JSON.stringify(result4))
