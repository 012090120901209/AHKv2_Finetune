#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Intersection() - Array intersection (Standalone Implementation)
 *
 * Creates an array of unique values that are included in all given arrays.
 */

Intersection(arrays*) {
    if (arrays.Length = 0) {
        return []
    }
    
    result := []
    firstArray := arrays[1]
    
    ; Check each value in first array
    for value in firstArray {
        foundInAll := true
        
        ; Check if value exists in all other arrays
        loop arrays.Length - 1 {
            otherArray := arrays[A_Index + 1]
            found := false
            
            for otherValue in otherArray {
                if (otherValue = value) {
                    found := true
                    break
                }
            }
            
            if (!found) {
                foundInAll := false
                break
            }
        }
        
        ; Add to result if found in all arrays and not already added
        if (foundInAll) {
            alreadyAdded := false
            for existing in result {
                if (existing = value) {
                    alreadyAdded := true
                    break
                }
            }
            if (!alreadyAdded) {
                result.Push(value)
            }
        }
    }
    
    return result
}

; Example
result := Intersection([2, 1], [2, 3])
; => [2]

MsgBox("Intersection of [2,1] and [2,3]:`n" JSON.stringify(result))
