#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
* SortedUniq() - Remove duplicates from sorted array
*
* Demonstrates: State tracking (lastSet, lastVal), optimization for sorted data
* O(n) algorithm for sorted arrays vs O(n²) for unsorted
*/

ToArray(val) {
    if val is Array
    return val
    throw Error("Expected Array")
}

SortedUniq(arr) {
    arr := ToArray(arr)
    out := []
    lastSet := false
    lastVal := ""

    for v in arr {
        if !lastSet || v != lastVal
        out.Push(v), lastVal := v, lastSet := true
    }

    return out
}

; Examples
result1 := SortedUniq([1, 1, 2])
; => [1, 2]

result2 := SortedUniq([1, 1, 1, 2, 2, 3, 3, 3])
; => [1, 2, 3]

result3 := SortedUniq(["a", "a", "b", "b", "c"])
; => ["a", "b", "c"]

result4 := SortedUniq([1])
; => [1]

MsgBox("Remove dups [1,1,2]: " JSON.stringify(result1) "`n`n"
. "Many duplicates: " JSON.stringify(result2) "`n`n"
. "String duplicates: " JSON.stringify(result3) "`n`n"
. "Single element: " JSON.stringify(result4))
