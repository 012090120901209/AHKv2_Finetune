#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Sort() - Sort strings
*
* Arranges strings in alphabetical, numerical, or custom order.
*/

list := "banana`napple`ngrape`ncherry"

sorted := Sort(list)
sortedReverse := Sort(list, "R")  ; Reverse
sortedNumeric := Sort("10`n2`n30`n5", "N")  ; Numeric

MsgBox("Original:`n" list
. "`n`nSorted:`n" sorted
. "`n`nReverse:`n" sortedReverse
. "`n`nNumeric:`n" sortedNumeric)
