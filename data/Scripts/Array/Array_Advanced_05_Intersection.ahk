#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
 * Intersection() - Set intersection using Map for O(1) lookups
 * 
 * Demonstrates: Map as Set, variadic parameters (a, b*), nested loops
 * Professional pattern for efficient set operations
 */

ToArray(val) {
    if val is Array
        return val
    throw Error("Expected Array")
}

SeenSet() => Map()

IndexOf(arr, value, fromIndex := 1) {
    arr := ToArray(arr)
    from := Max(1, fromIndex)
    Loop arr.Length - from + 1 {
        i := from + A_Index - 1
        if arr[i] == value
            return i
    }
    return -1
}

Uniq(arr) {
    arr := ToArray(arr)
    out := []
    seen := SeenSet()
    for v in arr
        if !seen.Has(v)
            seen[v] := true, out.Push(v)
    return out
}

Intersection(a, b*) {
    a := ToArray(a)
    if b.Length = 0
        return Uniq(a)

    out := []
    seen := SeenSet()

    for _, v in a {
        keep := true
        ; Check if value exists in ALL other arrays
        for _, other in b {
            if IndexOf(other, v) = -1 {
                keep := false
                break
            }
        }
        ; Add if found in all arrays and not already added
        if keep && !seen.Has(v)
            seen[v] := true, out.Push(v)
    }
    return out
}

; Examples
result1 := Intersection([2, 1], [2, 3])
; => [2]

result2 := Intersection([1, 2, 3], [2, 3, 4], [3, 2, 5])
; => [2, 3]

result3 := Intersection([1, 2, 2, 3], [2, 2, 4])
; => [2]

MsgBox("Intersection [2,1] & [2,3]: " JSON.stringify(result1) "`n`n"
    . "Intersection of 3 arrays: " JSON.stringify(result2) "`n`n"
    . "With duplicates: " JSON.stringify(result3))
