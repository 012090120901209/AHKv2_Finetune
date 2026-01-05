#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JSON.ahk

/**
 * ZipObject() - Create object from key-value arrays
 * 
 * Demonstrates: Dynamic object property assignment, Min() for bounds
 * Professional pattern for array-to-object conversion
 */

ToArray(val) {
    if val is Array
        return val
    throw Error("Expected Array")
}

ZipObject(props, values) {
    props := ToArray(props)
    values := ToArray(values)

    obj := {}
    len := Min(props.Length, values.Length)

    Loop len
        obj[props[A_Index]] := values[A_Index]

    return obj
}

; Examples
result1 := ZipObject(["a", "b"], [1, 2])
; => {a: 1, b: 2}

result2 := ZipObject(["name", "age", "city"], ["Alice", 30, "NYC"])
; => {name: "Alice", age: 30, city: "NYC"}

result3 := ZipObject(["x", "y"], [10, 20, 30])
; => {x: 10, y: 20} (extra value ignored)

MsgBox("Simple object: " JSON.stringify(result1) "`n`n"
    . "Person object: " JSON.stringify(result2) "`n`n"
    . "Mismatched lengths: " JSON.stringify(result3))
