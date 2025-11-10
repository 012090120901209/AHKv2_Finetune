#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * IsNumber() - Check if numeric
 *
 * Tests whether a value can be interpreted as a number.
 */

test1 := "123"
test2 := "abc"
test3 := "12.34"

MsgBox("'123' is number: " IsNumber(test1) "`n"
    . "'abc' is number: " IsNumber(test2) "`n"
    . "'12.34' is number: " IsNumber(test3))
