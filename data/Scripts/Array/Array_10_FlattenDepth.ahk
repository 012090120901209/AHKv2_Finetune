#Requires AutoHotkey v2.0
#SingleInstance Force
#Include .\JSON.ahk .\JSON.ahk
#Include <adash>

/**
* _.flattenDepth() - Flatten array to depth
*
* Recursively flatten array up to depth times.
*/

result1 := _.flattenDepth([1, [2, [3, [4]], 5]], 1)
; => [1, 2, [3, [4]], 5]

result2 := _.flattenDepth([1, [2, [3, [4]], 5]], 2)
; => [1, 2, 3, [4], 5]

MsgBox("Flatten depth 1: " JSON.stringify(result1) "`n`n"
. "Flatten depth 2: " JSON.stringify(result2))
