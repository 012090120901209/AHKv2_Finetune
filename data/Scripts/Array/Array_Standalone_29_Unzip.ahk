#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
* Unzip() - Unzip grouped elements (Standalone Implementation)
*
* The inverse of Zip; accepts an array of grouped elements and creates
* an array regrouping the elements to their pre-zip configuration.
*/

Unzip(zippedArray) {
    if (zippedArray.Length = 0) {
        return []
    }

    ; Determine the maximum length
    maxLength := 0
    for group in zippedArray {
        if (group.Length > maxLength) {
            maxLength := group.Length
        }
    }

    ; Create result arrays
    result := []
    loop maxLength {
        result.Push([])
    }

    ; Regroup elements
    for group in zippedArray {
        loop maxLength {
            if (A_Index <= group.Length) {
                result[A_Index].Push(group[A_Index])
            }
        }
    }

    return result
}

; Example
zipped := [["a", 1, true], ["b", 2, false]]
result := Unzip(zipped)
; => [["a", "b"], [1, 2], [true, false]]

MsgBox("Unzipped:`n" JSON.stringify(result))
