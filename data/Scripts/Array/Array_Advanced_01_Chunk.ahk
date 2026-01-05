#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JSON.ahk

/**
 * Chunk() - Advanced implementation with Floor division
 * 
 * Splits array into chunks using mathematical index calculation.
 * Demonstrates: Floor(), dynamic array building, index math
 */

ToArray(val) {
    if val is Array
        return val
    throw Error("Expected Array")
}

Chunk(arr, size := 1) {
    arr := ToArray(arr)
    if size < 1
        return []
    out := []
    i := 0
    for v in arr {
        i++
        ; Calculate which chunk this element belongs to
        idx := Floor((i - 1) / size) + 1
        if out.Length < idx
            out.Push([])
        out[idx].Push(v)
    }
    return out
}

; Examples
result1 := Chunk(["a", "b", "c", "d"], 2)
; => [["a","b"], ["c","d"]]

result2 := Chunk(["a", "b", "c", "d"], 3)
; => [["a","b","c"], ["d"]]

result3 := Chunk([1, 2, 3, 4, 5, 6, 7], 3)
; => [[1,2,3], [4,5,6], [7]]

MsgBox("Chunk by 2: " JSON.stringify(result1) "`n`n"
    . "Chunk by 3: " JSON.stringify(result2) "`n`n"
    . "Chunk by 3 (7 items): " JSON.stringify(result3))
