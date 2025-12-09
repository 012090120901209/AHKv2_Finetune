#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* IsFloat() - Check if float
*
* Tests whether a value is a floating-point type.
*/

test1 := 3.14
test2 := 42
test3 := "2.5"

MsgBox("3.14 is float: " IsFloat(test1) "`n"
. "42 is float: " IsFloat(test2) "`n"
. "'2.5' is float: " IsFloat(test3))
