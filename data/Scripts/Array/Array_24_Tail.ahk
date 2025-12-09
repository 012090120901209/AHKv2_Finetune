#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk
#Include <adash>

/**
* _.tail() - Get all but first element
*
* Gets all but the first element of array.
*/

result1 := _.tail([1, 2, 3])
; => [2, 3]

result2 := _.tail("neo")
; => ["e", "o"]

MsgBox("Tail of [1,2,3]: " JSON.stringify(result1) "`n"
. "Tail of 'neo': " JSON.stringify(result2))
