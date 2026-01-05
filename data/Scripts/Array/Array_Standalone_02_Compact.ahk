#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JSON.ahk

/**
 * Compact() - Remove falsey values (Standalone Implementation)
 * 
 * Creates an array with all falsey values removed.
 * Falsey values: false, 0, "", and unset
 */

Compact(array) {
    result := []

    for value in array {
        ; Check if value is truthy (not false, not 0, not empty string)
        if (value != false && value != 0 && value != "") {
            result.Push(value)
        }
    }

    return result
}

; Example
original := [0, 1, false, 2, "", 3]
result := Compact(original)
; => [1, 2, 3]

MsgBox("Original: " JSON.stringify(original) "`n"
    . "Compacted: " JSON.stringify(result))
