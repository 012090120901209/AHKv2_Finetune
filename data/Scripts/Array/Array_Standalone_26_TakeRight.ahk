#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
 * TakeRight() - Take elements from end (Standalone Implementation)
 * 
 * Creates a slice of array with n elements taken from the end.
 */

TakeRight(array, n := 1) {
    result := []

    takeCount := Min(n, array.Length)
    startIndex := array.Length - takeCount + 1

    loop takeCount {
        result.Push(array[startIndex + A_Index - 1])
    }

    return result
}

; Examples
result1 := TakeRight([1, 2, 3])
; => [3]

result2 := TakeRight([1, 2, 3], 2)
; => [2, 3]

result3 := TakeRight([1, 2, 3], 5)
; => [1, 2, 3]

result4 := TakeRight([1, 2, 3], 0)
; => []

MsgBox("TakeRight 1: " JSON.stringify(result1) "`n"
    . "TakeRight 2: " JSON.stringify(result2) "`n"
    . "TakeRight 5: " JSON.stringify(result3) "`n"
    . "TakeRight 0: " JSON.stringify(result4))
