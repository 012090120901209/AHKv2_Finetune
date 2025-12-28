#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Type() - Get variable type
 * 
 * Returns the type name of a value.
 */

var1 := "Hello"
var2 := 123
var3 := 3.14
var4 := [1, 2, 3]
var5 := Map("a", 1)

MsgBox("Type of 'Hello': " Type(var1) "`n"
    . "Type of 123: " Type(var2) "`n"
    . "Type of 3.14: " Type(var3) "`n"
    . "Type of [1,2,3]: " Type(var4) "`n"
    . "Type of Map: " Type(var5))
