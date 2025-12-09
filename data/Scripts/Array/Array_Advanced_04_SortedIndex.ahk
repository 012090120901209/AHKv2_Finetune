#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* SortedIndex() - Binary search implementation
*
* Demonstrates: Binary search algorithm, bit shift (>>), efficient search
* Professional pattern for finding insertion point in sorted array
*/

ToArray(val) {
    if val is Array
    return val
    throw Error("Expected Array")
}

SortedIndex(arr, value) {
    arr := ToArray(arr)
    lo := 1
    hi := arr.Length + 1

    ; Binary search
    while lo < hi {
        mid := (lo + hi) >> 1  ; Bit shift right = divide by 2 (faster)

        if (arr.Length >= mid && arr[mid] < value)
        lo := mid + 1
        else
        hi := mid
    }
    return lo
}

; Examples - finding where to insert values in sorted arrays
result1 := SortedIndex([30, 50], 40)
; => 2 (insert 40 between 30 and 50)

result2 := SortedIndex([30, 50], 20)
; => 1 (insert 20 before 30)

result3 := SortedIndex([30, 50], 99)
; => 3 (insert 99 after 50)

result4 := SortedIndex([10, 20, 30, 40, 50], 35)
; => 4 (insert 35 between 30 and 40)

MsgBox("Insert 40 in [30,50] at index: " result1 "`n"
. "Insert 20 in [30,50] at index: " result2 "`n"
. "Insert 99 in [30,50] at index: " result3 "`n"
. "Insert 35 in [10,20,30,40,50] at index: " result4)
