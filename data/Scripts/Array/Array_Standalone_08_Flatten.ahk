#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk JSON.ahk

/**
 * Flatten() - Flatten array one level (Standalone Implementation)
 * 
 * Flattens array a single level deep.
 */

Flatten(array) {
    result := []

    for value in array {
        if (IsObject(value) && value is Array) {
            ; Flatten one level by adding each nested element
            for nestedValue in value {
                result.Push(nestedValue)
            }
        } else {
            result.Push(value)
        }
    }

    return result
}

; Examples
result1 := Flatten([1, [2, [3, [4]], 5]])
; => [1, 2, [3, [4]], 5]

result2 := Flatten([[1, 2, 3], [4, 5, 6]])
; => [1, 2, 3, 4, 5, 6]

MsgBox("Flatten nested: " JSON.stringify(result1) "`n`n"
    . "Flatten 2D: " JSON.stringify(result2))
