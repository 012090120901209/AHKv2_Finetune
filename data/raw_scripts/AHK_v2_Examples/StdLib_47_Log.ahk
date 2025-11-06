#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Log() - Logarithm base 10
 *
 * Returns the base-10 logarithm of a number.
 */

numbers := [10, 100, 1000]

output := "Logarithm base 10:`n`n"
for num in numbers
    output .= "log(" num ") = " Log(num) "`n"

MsgBox(output)
