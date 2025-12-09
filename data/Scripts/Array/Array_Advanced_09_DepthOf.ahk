#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* DepthOf() - Calculate maximum nesting depth
*
* Demonstrates: Recursion, Max() with recursive calls, type checking
* Elegant recursive algorithm for depth calculation
*/

DepthOf(arr) {
    if !(arr is Array)
    return 0

    d := 1
    for v in arr
    d := Max(d, 1 + DepthOf(v))  ; Recursive depth check

    return d
}

; Examples
result1 := DepthOf([1])
; => 1

result2 := DepthOf([1, [2]])
; => 2

result3 := DepthOf([1, [[2]]])
; => 3

result4 := DepthOf([1, [2, [3, [4]], 5]])
; => 4

result5 := DepthOf([1, 2, 3])
; => 1 (all at same level)

MsgBox("Depth of [1]: " result1 "`n"
. "Depth of [1, [2]]: " result2 "`n"
. "Depth of [1, [[2]]]: " result3 "`n"
. "Depth of [1, [2, [3, [4]], 5]]: " result4 "`n"
. "Depth of [1, 2, 3]: " result5)
