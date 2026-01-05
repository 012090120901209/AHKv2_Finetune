#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * DepthOf() - Get array depth (Standalone Implementation)
 * 
 * Recursively explores the array and returns the maximum depth.
 */

DepthOf(array, currentDepth := 1) {
    maxDepth := currentDepth

    for value in array {
        if (IsObject(value) && value is Array) {
            ; Recursively check nested array depth
            nestedDepth := DepthOf(value, currentDepth + 1)
            if (nestedDepth > maxDepth) {
                maxDepth := nestedDepth
            }
        }
    }

    return maxDepth
}

; Examples
depth1 := DepthOf([1])
; => 1

depth2 := DepthOf([1, [2]])
; => 2

depth3 := DepthOf([1, [[2]]])
; => 3

depth4 := DepthOf([1, [2, [3, [4]], 5]])
; => 4

MsgBox("Depth of [1]: " depth1 "`n"
    . "Depth of [1, [2]]: " depth2 "`n"
    . "Depth of [1, [[2]]]: " depth3 "`n"
    . "Depth of [1, [2, [3, [4]], 5]]: " depth4)
