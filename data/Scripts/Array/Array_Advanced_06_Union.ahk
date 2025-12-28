#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk JSON.ahk

/**
 * Union() - Set union with nested function definition
 * 
 * Demonstrates: Nested function, arrow functions, closures, Set pattern
 * Advanced functional programming pattern in AHK v2
 */

ToArray(val) {
    if val is Array
        return val
    throw Error("Expected Array")
}

SeenSet() => Map()

Union(a, b*) {
    out := []
    seen := SeenSet()

    ; Nested function to add unique values
    add(arr) {
        arr := ToArray(arr)
        for _, v in arr {
            if !seen.Has(v) {
                seen[v] := true
                out.Push(v)
            }
        }
    }

    add(a)
    for each in b
        add(each)

    return out
}

; Examples
result1 := Union([2], [1, 2])
; => [2, 1]

result2 := Union([1, 2], [2, 3], [3, 4])
; => [1, 2, 3, 4]

result3 := Union([1, 1, 2], [2, 3, 3], [4])
; => [1, 2, 3, 4]

MsgBox("Union [2] & [1,2]: " JSON.stringify(result1) "`n`n"
    . "Union of 3 arrays: " JSON.stringify(result2) "`n`n"
    . "With duplicates: " JSON.stringify(result3))
