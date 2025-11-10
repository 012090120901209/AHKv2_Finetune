#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * FromPairs() - Create object from pairs (Standalone Implementation)
 *
 * Returns an object composed from key-value pairs.
 */

FromPairs(pairs) {
    result := {}
    
    for pair in pairs {
        if (pair.Length >= 2) {
            key := pair[1]
            value := pair[2]
            result.%key% := value
        }
    }
    
    return result
}

; Example
result := FromPairs([["a", 1], ["b", 2]])
; => {a: 1, b: 2}

MsgBox("FromPairs result:`n" JSON.stringify(result))
