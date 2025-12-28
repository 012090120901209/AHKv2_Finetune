#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <JSON>

FlattenDeep(array) {
    result := []

    for value in array {
        if (IsObject(value) && value is Array) {
            ; Recursively flatten nested arrays
            flattened := FlattenDeep(value)
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
result1 := FlattenDeep([1])
; => [1]

result2 := FlattenDeep([1, [2]])
; => [1, 2]

result3 := FlattenDeep([1, [2, [3, [4]], 5]])
; => [1, 2, 3, 4, 5]

MsgBox("FlattenDeep [1]: " JSON.stringify(result1) "`n"
    . "FlattenDeep [1, [2]]: " JSON.stringify(result2) "`n"
    . "FlattenDeep deeply nested: " JSON.stringify(result3))
