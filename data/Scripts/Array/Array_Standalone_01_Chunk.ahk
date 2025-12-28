#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
 * Chunk() - Split array into chunks (Standalone Implementation)
 * 
 * Creates an array of elements split into groups the length of size.
 * Demonstrates pure AHK v2 array manipulation without external libraries.
 */

Chunk(array, size := 1) {
    result := []
    chunk := []

    for value in array {
        chunk.Push(value)

        if (chunk.Length = size) {
            result.Push(chunk)
            chunk := []
        }
    }

    ; Add remaining elements as final chunk
    if (chunk.Length > 0) {
        result.Push(chunk)
    }

    return result
}

; Examples
result1 := Chunk(["a", "b", "c", "d"], 2)
; => [["a", "b"], ["c", "d"]]

result2 := Chunk(["a", "b", "c", "d"], 3)
; => [["a", "b", "c"], ["d"]]

MsgBox("Chunk by 2: " JSON.stringify(result1) "`n`n"
    . "Chunk by 3: " JSON.stringify(result2))
