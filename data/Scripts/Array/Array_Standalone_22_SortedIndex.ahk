#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* SortedIndex() - Find insertion index (Standalone Implementation)
*
* Uses binary search to determine the lowest index at which value
* should be inserted into array to maintain its sort order.
*/

SortedIndex(array, value) {
    low := 1
    high := array.Length + 1

    ; Binary search
    while (low < high) {
        mid := Floor((low + high) / 2)

        if (mid <= array.Length && array[mid] < value) {
            low := mid + 1
        } else {
            high := mid
        }
    }

    return low
}

; Examples
result1 := SortedIndex([30, 50], 40)
; => 2

result2 := SortedIndex([30, 50], 20)
; => 1

result3 := SortedIndex([30, 50], 99)
; => 3

MsgBox("Insert 40 in [30,50] at: " result1 "`n"
. "Insert 20 in [30,50] at: " result2 "`n"
. "Insert 99 in [30,50] at: " result3)
