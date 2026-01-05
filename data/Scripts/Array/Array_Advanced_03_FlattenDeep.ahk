#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JSON.ahk

/**
 * FlattenDeep() - Recursive deep flattening
 * 
 * Demonstrates: Recursion, type checking with 'is Array', nested loops
 * Professional pattern for deep array traversal
 */

ToArray(val) {
    if val is Array
        return val
    throw Error("Expected Array")
}

FlattenDeep(arr) {
    arr := ToArray(arr)
    out := []
    for v in arr {
        if v is Array {
            ; Recursive call to flatten nested arrays
            for x in FlattenDeep(v)
                out.Push(x)
        } else {
            out.Push(v)
        }
    }
    return out
}

; Examples
result1 := FlattenDeep([1])
; => [1]

result2 := FlattenDeep([1, [2]])
; => [1, 2]

result3 := FlattenDeep([1, [2, [3, [4]], 5]])
; => [1, 2, 3, 4, 5]

result4 := FlattenDeep([[1, 2], [[3]], [[[4, 5]]]])
; => [1, 2, 3, 4, 5]

MsgBox("Flatten [1]: " JSON.stringify(result1) "`n"
    . "Flatten [1, [2]]: " JSON.stringify(result2) "`n"
    . "Flatten deeply nested: " JSON.stringify(result3) "`n"
    . "Flatten complex: " JSON.stringify(result4))
