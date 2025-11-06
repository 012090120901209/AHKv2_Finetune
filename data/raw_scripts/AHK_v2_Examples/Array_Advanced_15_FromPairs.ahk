#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force

/**
 * FromPairs() - Create object from [key, value] pairs
 *
 * Demonstrates: Nested array access, dynamic property assignment
 * Inverse operation of Object.entries() style operations
 */

ToArray(val) {
    if val is Array
        return val
    throw Error("Expected Array")
}

FromPairs(pairs) {
    pairs := ToArray(pairs)
    obj := {}
    
    for p in pairs
        obj[p[1]] := p[2]
    
    return obj
}

; Examples
result1 := FromPairs([["a", 1], ["b", 2]])
; => {a: 1, b: 2}

result2 := FromPairs([["name", "Bob"], ["age", 25], ["active", true]])
; => {name: "Bob", age: 25, active: true}

result3 := FromPairs([["x", 10], ["y", 20], ["x", 30]])
; => {x: 30, y: 20} (last x wins)

MsgBox("Simple pairs: " JSON.stringify(result1) "`n`n"
    . "Person from pairs: " JSON.stringify(result2) "`n`n"
    . "Duplicate keys: " JSON.stringify(result3))
