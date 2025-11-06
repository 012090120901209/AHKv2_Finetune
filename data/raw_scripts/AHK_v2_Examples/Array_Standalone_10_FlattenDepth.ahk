#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * FlattenDepth() - Flatten array to depth (Standalone Implementation)
 *
 * Recursively flatten array up to depth times.
 */

FlattenDepth(array, depth := 1) {
    if (depth <= 0) {
        return array
    }
    
    result := []
    
    for value in array {
        if (IsObject(value) && value is Array && depth > 0) {
            ; Flatten one level and recurse with depth-1
            flattened := FlattenDepth(value, depth - 1)
            for item in flattened {
                result.Push(item)
            }
        } else {
            result.Push(value)
        }
    }
    
    return result
}

; Examples
result1 := FlattenDepth([1, [2, [3, [4]], 5]], 1)
; => [1, 2, [3, [4]], 5]

result2 := FlattenDepth([1, [2, [3, [4]], 5]], 2)
; => [1, 2, 3, [4], 5]

MsgBox("Flatten depth 1: " JSON.stringify(result1) "`n`n"
    . "Flatten depth 2: " JSON.stringify(result2))
