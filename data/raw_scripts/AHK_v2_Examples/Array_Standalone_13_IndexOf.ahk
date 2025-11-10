#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * IndexOf() - Find index of value (Standalone Implementation)
 *
 * Gets the index at which the first occurrence of value is found.
 */

IndexOf(array, searchValue, fromIndex := 1) {
    loop array.Length {
        index := A_Index
        if (index >= fromIndex) {
            if (array[index] = searchValue) {
                return index
            }
        }
    }
    return -1
}

; Examples
result1 := IndexOf([1, 2, 1, 2], 2)
; => 2

result2 := IndexOf([1, 2, 1, 2], 2, 3)
; => 4 (search from index 3)

result3 := IndexOf([1, 2, 3], 99)
; => -1 (not found)

MsgBox("IndexOf 2: " result1 "`n"
    . "IndexOf 2 from position 3: " result2 "`n"
    . "IndexOf 99 (not found): " result3)
