#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
* Union() - Create array union (Standalone Implementation)
*
* Creates an array of unique values, in order, from all given arrays.
*/

Union(arrays*) {
    result := []
    seen := Map()

    for array in arrays {
        for value in array {
            ; Add only if not seen before
            if (!seen.Has(value)) {
                seen[value] := true
                result.Push(value)
            }
        }
    }

    return result
}

; Example
result := Union([2], [1, 2], [3, 2, 1])
; => [2, 1, 3]

MsgBox("Union of [2], [1,2], [3,2,1]:`n" JSON.stringify(result))
