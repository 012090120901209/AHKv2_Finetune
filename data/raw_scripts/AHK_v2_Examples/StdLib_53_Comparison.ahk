#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Comparison operators
 *
 * Compare values and return true (1) or false (0).
 */

a := 10
b := 20

MsgBox("a = " a ", b = " b "`n`n"
    . "a = b: " (a = b) "`n"
    . "a != b: " (a != b) "`n"
    . "a < b: " (a < b) "`n"
    . "a > b: " (a > b) "`n"
    . "a <= b: " (a <= b) "`n"
    . "a >= b: " (a >= b))
