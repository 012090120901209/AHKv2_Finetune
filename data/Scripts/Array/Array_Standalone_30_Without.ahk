#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
* Without() - Exclude values from array (Standalone Implementation)
*
* Creates an array excluding all given values.
*/

Without(array, excludeValues*) {
    result := []

    ; Create lookup map for excluded values
    excludeMap := Map()
    for value in excludeValues {
        excludeMap[value] := true
    }

    ; Add only non-excluded values
    for value in array {
        if (!excludeMap.Has(value)) {
            result.Push(value)
        }
    }

    return result
}

; Example
result := Without([2, 1, 2, 3], 1, 2)
; => [3]

MsgBox("Without 1 and 2 from [2,1,2,3]:`n" JSON.stringify(result))
