#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
* Zip() - Zip arrays together (Standalone Implementation)
*
* Creates an array of grouped elements, the first of which contains
* the first elements of the given arrays, and so on.
*/

Zip(arrays*) {
    if (arrays.Length = 0) {
        return []
    }

    ; Find maximum length
    maxLength := 0
    for array in arrays {
        if (array.Length > maxLength) {
            maxLength := array.Length
        }
    }

    ; Build zipped result
    result := []
    loop maxLength {
        index := A_Index
        group := []

        for array in arrays {
            if (index <= array.Length) {
                group.Push(array[index])
            }
        }

        result.Push(group)
    }

    return result
}

; Example
result := Zip(["a", "b"], [1, 2], [true, true])
; => [["a", 1, true], ["b", 2, true]]

MsgBox("Zip result:`n" JSON.stringify(result))
