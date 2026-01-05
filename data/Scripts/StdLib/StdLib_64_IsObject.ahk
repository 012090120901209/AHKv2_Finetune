#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * IsObject() - Check if object
 * 
 * Tests whether a value is an object (Array, Map, etc.).
 */

test1 := [1, 2, 3]
test2 := Map("a", 1)
test3 := "string"
test4 := 123

MsgBox("Array is object: " IsObject(test1) "`n"
    . "Map is object: " IsObject(test2) "`n"
    . "String is object: " IsObject(test3) "`n"
    . "Number is object: " IsObject(test4))
