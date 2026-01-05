#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Basic arithmetic operators
 * 
 * Demonstrates addition, subtraction, multiplication, division, and more.
 */

a := 10
b := 3

MsgBox("a = " a ", b = " b "`n`n"
    . "Addition: " (a + b) "`n"
    . "Subtraction: " (a - b) "`n"
    . "Multiplication: " (a * b) "`n"
    . "Division: " (a / b) "`n"
    . "Floor Division: " (a // b) "`n"
    . "Modulo: " Mod(a, b) "`n"
    . "Power: " (a ** b))
