#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* LastIndexOf() - Find last index of value (Standalone Implementation)
*
* Like IndexOf except that it iterates from right to left.
*/

LastIndexOf(array, searchValue, fromIndex := -1) {
    if (fromIndex = -1) {
        fromIndex := array.Length
    }

    ; Search backwards from fromIndex
    loop fromIndex {
        index := fromIndex - A_Index + 1
        if (array[index] = searchValue) {
            return index
        }
    }

    return -1
}

; Examples
result1 := LastIndexOf([1, 2, 1, 2], 2)
; => 4

result2 := LastIndexOf([1, 2, 1, 2], 1, 3)
; => 3 (search from index 3 backwards)

result3 := LastIndexOf([1, 2, 3], 99)
; => -1 (not found)

MsgBox("LastIndexOf 2: " result1 "`n"
. "LastIndexOf 1 from position 3: " result2 "`n"
. "LastIndexOf 99 (not found): " result3)
