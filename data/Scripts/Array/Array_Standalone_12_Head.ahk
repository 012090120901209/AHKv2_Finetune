#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Head() - Get first element (Standalone Implementation)
 * 
 * Gets the first element of array.
 */

Head(array) {
    if (array.Length > 0) {
        return array[1]
    }
    return ""
}

; Examples
result1 := Head([1, 2, 3])
; => 1

result2 := Head(["Neo", "Morpheus", "Trinity"])
; => "Neo"

result3 := Head([])
; => ""

MsgBox("Head of [1, 2, 3]: " result1 "`n"
    . "Head of names: " result2 "`n"
    . "Head of []: '" result3 "'")
