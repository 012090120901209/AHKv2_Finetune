#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * LastIndexOf() - Search from end (reverse search)
 * 
 * Demonstrates: Reverse iteration, optional parameter defaults
 * Efficient last occurrence finding
 */

ToArray(val) {
    if val is Array
        return val
    throw Error("Expected Array")
}

LastIndexOf(arr, value, fromIndex := "") {
    arr := ToArray(arr)
    i := (fromIndex = "" ? arr.Length : Min(fromIndex, arr.Length))

    ; Search backwards
    Loop i {
        idx := i - A_Index + 1
        if arr[idx] == value
            return idx
    }

    return -1
}

; Examples
result1 := LastIndexOf([1, 2, 1, 2], 2)
; => 4

result2 := LastIndexOf([1, 2, 1, 2], 1, 3)
; => 3 (search from position 3 backwards)

result3 := LastIndexOf([1, 2, 3], 99)
; => -1 (not found)

result4 := LastIndexOf(["a", "b", "a", "c", "a"], "a")
; => 5 (last occurrence)

MsgBox("Last 2 in [1,2,1,2]: " result1 "`n"
    . "Last 1 up to index 3: " result2 "`n"
    . "Not found: " result3 "`n"
    . "Last 'a': " result4)
