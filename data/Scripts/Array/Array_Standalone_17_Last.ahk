#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Last() - Get last element (Standalone Implementation)
 * 
 * Gets the last element of array.
 */

Last(array) {
    if (array.Length > 0) {
        return array[array.Length]
    }
    return ""
}

; Examples
result1 := Last([1, 2, 3])
; => 3

result2 := Last(["Neo", "Morpheus", "Trinity"])
; => "Trinity"

result3 := Last([])
; => ""

MsgBox("Last of [1,2,3]: " result1 "`n"
    . "Last of names: " result2 "`n"
    . "Last of []: '" result3 "'")
