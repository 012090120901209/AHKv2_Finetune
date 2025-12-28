#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
 * FlattenDepth() - Flatten to specific depth
 * 
 * Demonstrates: Controlled recursion with depth parameter
 * Professional pattern for limited depth traversal
 */

ToArray(val) {
    if val is Array
        return val
    throw Error("Expected Array")
}

CloneArray(arr) {
    out := []
    for v in arr
        out.Push(v)
    return out
}

FlattenDepth(arr, depth := 1) {
    if depth <= 0
        return CloneArray(arr)

    arr := ToArray(arr)
    out := []

    for v in arr {
        if v is Array {
            ; Recursively flatten with decremented depth
            flat := FlattenDepth(v, depth - 1)
            for x in flat
                out.Push(x)
        } else {
            out.Push(v)
        }
    }
    return out
}

; Examples
result1 := FlattenDepth([1, [2, [3, [4]], 5]], 1)
; => [1, 2, [3, [4]], 5]

result2 := FlattenDepth([1, [2, [3, [4]], 5]], 2)
; => [1, 2, 3, [4], 5]

result3 := FlattenDepth([1, [2, [3, [4]], 5]], 3)
; => [1, 2, 3, 4, 5]

result4 := FlattenDepth([[1], [[2]], [[[3]]]], 2)
; => [1, 2, [3]]

MsgBox("Depth 1: " JSON.stringify(result1) "`n`n"
    . "Depth 2: " JSON.stringify(result2) "`n`n"
    . "Depth 3: " JSON.stringify(result3) "`n`n"
    . "Complex depth 2: " JSON.stringify(result4))
