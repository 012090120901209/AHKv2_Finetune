#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JSON.ahk

/**
 * Uniq() - Remove duplicates (Standalone Implementation)
 * 
 * Creates a duplicate-free version of an array.
 * Keeps only the first occurrence of each element.
 */

Uniq(array) {
    result := []
    seen := Map()

    for value in array {
        ; Add only if not seen before
        if (!seen.Has(value)) {
            seen[value] := true
            result.Push(value)
        }
    }

    return result
}

; Example
result := Uniq([2, 1, 2, 3, 1, 4])
; => [2, 1, 3, 4]

MsgBox("Uniq of [2,1,2,3,1,4]:`n" JSON.stringify(result))
