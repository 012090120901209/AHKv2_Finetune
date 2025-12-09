#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk
#Include <adash>

/**
* _.flattenDeep() - Recursively flatten array
*
* Recursively flattens array to a single level.
*/

result1 := _.flattenDeep([1])
; => [1]

result2 := _.flattenDeep([1, [2]])
; => [1, 2]

result3 := _.flattenDeep([1, [2, [3, [4]], 5]])
; => [1, 2, 3, 4, 5]

MsgBox("FlattenDeep [1]: " JSON.stringify(result1) "`n"
. "FlattenDeep [1, [2]]: " JSON.stringify(result2) "`n"
. "FlattenDeep deeply nested: " JSON.stringify(result3))
