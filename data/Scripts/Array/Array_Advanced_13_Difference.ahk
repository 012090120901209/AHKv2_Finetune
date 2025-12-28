#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
 * Difference() - Set difference operation
 * 
 * Demonstrates: Multiple exclusion arrays, nested iteration
 * Professional set difference implementation
 */

ToArray(val) {
    if val is Array
        return val
    throw Error("Expected Array")
}

SeenSet() => Map()

Difference(a, b*) {
    a := ToArray(a)

    ; Build exclusion set from all provided arrays
    ban := SeenSet()
    for each in b
        for _, v in each
            ban[v] := true

    ; Keep values not in exclusion set
    out := []
    for _, v in a
        if !ban.Has(v)
            out.Push(v)

    return out
}

; Examples
result1 := Difference([2, 1], [2, 3])
; => [1]

result2 := Difference([1, 2, 3, 4], [2], [3])
; => [1, 4]

result3 := Difference([1, 2, 3, 4, 5], [2, 4, 6], [1, 3, 5])
; => []

MsgBox("Diff [2,1] - [2,3]: " JSON.stringify(result1) "`n`n"
    . "Diff [1,2,3,4] - [2] - [3]: " JSON.stringify(result2) "`n`n"
    . "Diff removes all: " JSON.stringify(result3))
