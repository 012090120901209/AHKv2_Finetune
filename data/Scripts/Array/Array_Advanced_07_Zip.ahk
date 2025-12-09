#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
* Zip() - Combine multiple arrays into tuples
*
* Demonstrates: Variadic parameters, Min() for multiple values, row building
* Professional pattern for array transposition
*/

ToArray(val) {
    if val is Array
    return val
    throw Error("Expected Array")
}

Zip(a, b, rest*) {
    a := ToArray(a)
    b := ToArray(b)

    ; Find minimum length across all arrays
    minLen := Min(a.Length, b.Length)
    for each in rest
    minLen := Min(minLen, each.Length)

    out := []
    Loop minLen {
        row := [a[A_Index], b[A_Index]]
        for each in rest
        row.Push(each[A_Index])
        out.Push(row)
    }
    return out
}

; Examples
result1 := Zip(["a", "b"], [1, 2], [true, true])
; => [["a", 1, true], ["b", 2, true]]

result2 := Zip([1, 2, 3], ["a", "b", "c"])
; => [[1, "a"], [2, "b"], [3, "c"]]

result3 := Zip([1, 2], ["a", "b", "c"], [true, false, true])
; => [[1, "a", true], [2, "b", false]]  (stops at shortest)

MsgBox("Zip 3 arrays: " JSON.stringify(result1) "`n`n"
. "Zip numbers & letters: " JSON.stringify(result2) "`n`n"
. "Different lengths: " JSON.stringify(result3))
