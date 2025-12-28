#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <adash>

/**
 * _.join() - Join array elements
 * 
 * Converts all elements in array into a string separated by separator.
 */

result1 := _.join(["a", "b", "c"], "~")
; => "a~b~c"

result2 := _.join(["a", "b", "c"])
; => "a,b,c"

MsgBox("Join with '~': " result1 "`n"
    . "Join with default: " result2)
