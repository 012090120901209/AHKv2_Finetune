#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JSON.ahk

/**
 * SortedUniq() - Remove duplicates from sorted array (Standalone Implementation)
 * 
 * Optimized for sorted arrays - only checks adjacent elements.
 */

SortedUniq(array) {
    if (array.Length = 0) {
        return []
    }

    result := [array[1]]

    loop array.Length - 1 {
        index := A_Index + 1
        ; Only add if different from previous element
        if (array[index] != array[index - 1]) {
            result.Push(array[index])
        }
    }

    return result
}

; Example
result := SortedUniq([1, 1, 2, 2, 2, 3])
; => [1, 2, 3]

MsgBox("SortedUniq [1,1,2,2,2,3]:`n" JSON.stringify(result))
