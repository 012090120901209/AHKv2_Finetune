#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Nth() - Access by positive or negative index
 * 
 * Demonstrates: Negative indexing, ternary operator, bounds checking
 * Python-style negative indexing in AHK v2
 */

ToArray(val) {
    if val is Array
        return val
    throw Error("Expected Array")
}

Nth(arr, n := 1) {
    arr := ToArray(arr)

    ; Convert negative indices to positive (count from end)
    idx := n >= 0 ? n : arr.Length + n + 1

    ; Return value if in bounds, empty string otherwise
    return (idx >= 1 && idx <= arr.Length) ? arr[idx] : ""
}

; Examples
result1 := Nth([1, 2, 3])
; => 1 (default first element)

result2 := Nth([1, 2, 3], -3)
; => 1 (third from end)

result3 := Nth([1, 2, 3], -1)
; => 3 (last element)

result4 := Nth(["a", "b", "c", "d"], -2)
; => "c" (second from end)

result5 := Nth([1, 2, 3], 5)
; => "" (out of bounds)

MsgBox("First element: " result1 "`n"
    . "Third from end: " result2 "`n"
    . "Last element: " result3 "`n"
    . "Second from end: " result4 "`n"
    . "Out of bounds: '" result5 "'")
