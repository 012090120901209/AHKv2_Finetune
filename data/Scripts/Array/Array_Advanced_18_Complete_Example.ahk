#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
 * Complete Advanced Example - Combining Multiple Patterns
 * 
 * Demonstrates how to combine multiple advanced techniques:
 * - Helper functions (ToArray, SeenSet, CloneArray)
 * - Recursion (FlattenDeep, DepthOf)
 * - Map-based Sets (Union, Intersection)
 * - Binary search (SortedIndex)
 * - By-reference parameters (Fill)
 * - Variadic parameters (Zip, Without)
 */

; === Helper Functions ===
ToArray(val) {
    if val is Array
        return val
    throw Error("Expected Array")
}

SeenSet() => Map()

CloneArray(arr) {
    out := []
    for v in arr
        out.Push(v)
    return out
}

; === Core Functions ===
FlattenDeep(arr) {
    arr := ToArray(arr)
    out := []
    for v in arr {
        if v is Array {
            for x in FlattenDeep(v)
                out.Push(x)
        } else {
            out.Push(v)
        }
    }
    return out
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

SortedIndex(arr, value) {
    arr := ToArray(arr)
    lo := 1, hi := arr.Length + 1
    while lo < hi {
        mid := (lo + hi) >> 1
        if (arr.Length >= mid && arr[mid] < value)
            lo := mid + 1
        else
            hi := mid
    }
    return lo
}

; === Real-World Example ===
; Process user data: flatten, deduplicate, and find insertion points

; Raw user data with nesting and duplicates
userData := [
    [1, 2, [3, 4]],
    [5, 2, 1],
    [[6, 7], 8]
]

; Step 1: Flatten all nested arrays
flat := FlattenDeep(userData)
; => [1, 2, 3, 4, 5, 2, 1, 6, 7, 8]

; Step 2: Remove duplicates
unique := Uniq(flat)
; => [1, 2, 3, 4, 5, 6, 7, 8]

; Step 3: Find where to insert new values
insertPos := SortedIndex([1, 2, 3, 4, 5, 6, 7, 8], 4.5)
; => 5 (between 4 and 5)

MsgBox("Original data: " JSON.stringify(userData) "`n`n"
    . "After flatten: " JSON.stringify(flat) "`n`n"
    . "After unique: " JSON.stringify(unique) "`n`n"
    . "Insert 4.5 at index: " insertPos)
