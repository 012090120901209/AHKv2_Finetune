#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <adash>

/**
 * _.flatten() - Flatten array one level
 *
 * Flattens array a single level deep.
 */

result1 := _.flatten([1, [2, [3, [4]], 5]])
; => [1, 2, [3, [4]], 5]

result2 := _.flatten([[1, 2, 3], [4, 5, 6]])
; => [1, 2, 3, 4, 5, 6]

MsgBox("Flatten nested: " JSON.stringify(result1) "`n`n"
    . "Flatten 2D: " JSON.stringify(result2))
