#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk
#Include <adash>

/**
* _.without() - Exclude values from array
*
* Creates an array excluding all given values.
*/

result := _.without([2, 1, 2, 3], 1, 2)
; => [3]

MsgBox("Without 1 and 2 from [2,1,2,3]:`n" JSON.stringify(result))
