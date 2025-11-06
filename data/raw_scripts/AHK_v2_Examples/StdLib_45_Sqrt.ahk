#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Sqrt() - Square root
 *
 * Calculates the square root of a number.
 */

numbers := [4, 9, 16, 25, 100]

output := "Square roots:`n`n"
for num in numbers
    output .= "√" num " = " Sqrt(num) "`n"

MsgBox(output)
