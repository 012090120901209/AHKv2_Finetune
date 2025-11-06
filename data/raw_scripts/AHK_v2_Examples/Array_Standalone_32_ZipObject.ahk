#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ZipObject() - Create object from arrays (Standalone Implementation)
 *
 * Accepts two arrays, one of property identifiers and one of corresponding values.
 */

ZipObject(keys, values) {
    result := {}
    
    loop Min(keys.Length, values.Length) {
        key := keys[A_Index]
        value := values[A_Index]
        result.%key% := value
    }
    
    return result
}

; Example
result := ZipObject(["a", "b", "c"], [1, 2, 3])
; => {a: 1, b: 2, c: 3}

MsgBox("ZipObject result:`n" JSON.stringify(result))
