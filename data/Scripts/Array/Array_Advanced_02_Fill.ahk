#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
* Fill() - Mutating array operation with by-reference parameter
*
* Demonstrates: &arr (by-reference), mutating arrays, Min/Max bounds
* This is the proper way to modify an array in-place in AHK v2
*/

ToArray(val) {
    if val is Array
    return val
    throw Error("Expected Array")
}

Fill(&arr, value, start := 1, end := "") {
    arr := ToArray(arr)
    if (end = "")
    end := arr.Length
    ; Clamp to valid bounds
    start := Max(1, start)
    end := Min(end, arr.Length)

    Loop end - start + 1
    arr[start + A_Index - 1] := value
    return arr
}

; Examples - note the & before variable names
a := [1, 2, 3]
Fill(&a, "a")
; a is now ["a", "a", "a"]

b := [4, 6, 8, 10]
Fill(&b, "*", 2, 4)
; b is now [4, "*", "*", 10]

c := [1, 2, 3, 4, 5]
Fill(&c, 0, 3)
; c is now [1, 2, 0, 0, 0]

MsgBox("Fill all with 'a': " JSON.stringify(a) "`n"
. "Fill positions 2-4 with '*': " JSON.stringify(b) "`n"
. "Fill from position 3 with 0: " JSON.stringify(c))
