#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Number() - Convert to number
 *
 * Converts strings to numeric values (int or float).
 */

str1 := "42"
str2 := "3.14"
str3 := "invalid"

num1 := Number(str1)
num2 := Number(str2)
num3 := Number(str3)  ; Returns 0 for invalid

MsgBox("'42' to number: " num1 "`n"
    . "'3.14' to number: " num2 "`n"
    . "'invalid' to number: " num3)
