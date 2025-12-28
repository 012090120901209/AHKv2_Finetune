#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Float() - Convert to float
 * 
 * Converts strings and integers to floating-point values.
 */

str := "123.45"
int := 100

float1 := Float(str)
float2 := Float(int)

MsgBox("String '123.45' to float: " float1 "`n"
    . "Integer 100 to float: " float2)
