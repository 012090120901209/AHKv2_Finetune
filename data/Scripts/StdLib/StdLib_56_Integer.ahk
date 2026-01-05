#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Integer() - Convert to integer
 * 
 * Converts strings and floats to integer values.
 */

str := "123"
float := 45.67

int1 := Integer(str)
int2 := Integer(float)

MsgBox("String '123' to int: " int1 "`n"
    . "Float 45.67 to int: " int2)
