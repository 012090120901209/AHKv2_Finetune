#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
 * Without() - Filter using variadic exclusion list
 * 
 * Demonstrates: Variadic parameters (values*), Map as Set
 * Efficient O(n) filtering with Map lookups
 */

ToArray(val) {
    if val is Array
        return val
    throw Error("Expected Array")
}

SeenSet() => Map()

Without(arr, values*) {
    arr := ToArray(arr)

    ; Build exclusion set for O(1) lookups
    ban := SeenSet()
    for v in values
        ban[v] := true

    ; Filter out banned values
    out := []
    for v in arr
        if !ban.Has(v)
            out.Push(v)

    return out
}

; Examples
result1 := Without([2, 1, 2, 3], 1, 2)
; => [3]

result2 := Without([1, 2, 3, 4, 5], 2, 4)
; => [1, 3, 5]

result3 := Without(["a", "b", "c", "a", "b"], "a", "b")
; => ["c"]

MsgBox("Without 1,2 from [2,1,2,3]: " JSON.stringify(result1) "`n`n"
    . "Without 2,4 from [1,2,3,4,5]: " JSON.stringify(result2) "`n`n"
    . "Without 'a','b': " JSON.stringify(result3))
