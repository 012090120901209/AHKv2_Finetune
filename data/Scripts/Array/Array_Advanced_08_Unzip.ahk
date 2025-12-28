#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
 * Unzip() - Transpose rows to columns
 * 
 * Demonstrates: Matrix transposition, nested array manipulation
 * Inverse operation of Zip()
 */

ToArray(val) {
    if val is Array
        return val
    throw Error("Expected Array")
}

Unzip(grouped) {
    grouped := ToArray(grouped)
    if !grouped.Length
        return []

    ; Get width from first row
    width := grouped[1].Length

    ; Create empty output columns
    out := []
    Loop width
        out.Push([])

    ; Transpose rows to columns
    for row in grouped
        for i, v in row
            out[i].Push(v)

    return out
}

; Examples
zipped := [["a", 1, true], ["b", 2, false]]
result1 := Unzip(zipped)
; => [["a", "b"], [1, 2], [true, false]]

zipped2 := [[1, "x"], [2, "y"], [3, "z"]]
result2 := Unzip(zipped2)
; => [[1, 2, 3], ["x", "y", "z"]]

MsgBox("Unzip to columns: " JSON.stringify(result1) "`n`n"
    . "Unzip 3 rows: " JSON.stringify(result2))
