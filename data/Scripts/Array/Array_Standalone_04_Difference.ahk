#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
 * Difference() - Array difference (Standalone Implementation)
 * 
 * Creates an array of values not included in the other given arrays.
 */

Difference(array, excludeArrays*) {
    result := []

    ; Flatten all exclude values into a single lookup map
    excludeMap := Map()
    for excludeArray in excludeArrays {
        for value in excludeArray {
            excludeMap[value] := true
        }
    }

    ; Add values from original array that aren't in exclude map
    for value in array {
        if (!excludeMap.Has(value)) {
            result.Push(value)
        }
    }

    return result
}

; Example
result := Difference([2, 1], [2, 3])
; => [1]

MsgBox("Difference between [2, 1] and [2, 3]:`n"
    . JSON.stringify(result))
