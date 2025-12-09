#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <adash>

/**
* _.last() - Get last element
*
* Gets the last element of array.
*/

result1 := _.last([1, 2, 3])
; => 3

result2 := _.last([])
; => ""

result3 := _.last("neo")
; => "o"

MsgBox("Last of [1,2,3]: " result1 "`n"
. "Last of []: " result2 "`n"
. "Last of 'neo': " result3)
