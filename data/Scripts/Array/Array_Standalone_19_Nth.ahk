#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Nth() - Get nth element (Standalone Implementation)
 * 
 * Gets the element at index n of array.
 * If n is negative, the nth element from the end is returned.
 */

Nth(array, n := 1) {
    if (n < 0) {
        ; Negative index counts from end
        index := array.Length + n + 1
    } else if (n = 0) {
        ; Treat 0 as 1 (first element)
        index := 1
    } else {
        index := n
    }

    if (index >= 1 && index <= array.Length) {
        return array[index]
    }

    return ""
}

; Examples
result1 := Nth([1, 2, 3])
; => 1

result2 := Nth([1, 2, 3], -3)
; => 1 (third from end)

result3 := Nth([1, 2, 3], 5)
; => "" (out of bounds)

MsgBox("Nth at 1: " result1 "`n"
    . "Nth at -3: " result2 "`n"
    . "Nth at 5: '" result3 "'")
