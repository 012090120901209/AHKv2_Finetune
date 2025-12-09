#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* String() - Convert to string
*
* Converts various types to string representation.
*/

num := 123
float := 45.67
bool := true

str1 := String(num)
str2 := String(float)
str3 := String(bool)

MsgBox("Integer to string: '" str1 "'`n"
. "Float to string: '" str2 "'`n"
. "Boolean to string: '" str3 "'")
