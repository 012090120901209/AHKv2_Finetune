#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* IsInteger() - Check if integer
*
* Tests whether a value is an integer type.
*/

test1 := 123
test2 := 12.34
test3 := "456"

MsgBox("123 is integer: " IsInteger(test1) "`n"
. "12.34 is integer: " IsInteger(test2) "`n"
. "'456' is integer: " IsInteger(test3))
