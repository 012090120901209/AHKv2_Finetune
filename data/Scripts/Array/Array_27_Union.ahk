#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JSON.ahk
#Include ../Lib/adash.ahk

/**
 * _.union() - Create array union
 * 
 * Creates an array of unique values, in order, from all given arrays.
 */

result := _.union([2], [1, 2])
; => [2, 1]

MsgBox("Union of [2] and [1,2]:`n" JSON.stringify(result))
