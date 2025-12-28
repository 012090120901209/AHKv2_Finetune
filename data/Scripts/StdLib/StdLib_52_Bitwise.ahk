#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Bitwise operations
 * 
 * Performs bit-level operations on integers.
 */

a := 12  ; Binary: 1100
b := 10  ; Binary: 1010

MsgBox("a = " a " (1100)`n"
    . "b = " b " (1010)`n`n"
    . "AND: " (a & b) " (" Format("{:b}", a & b) ")`n"
    . "OR: " (a | b) " (" Format("{:b}", a | b) ")`n"
    . "XOR: " (a ^ b) " (" Format("{:b}", a ^ b) ")`n"
    . "NOT a: " (~a & 0xFF) "`n"
    . "Left shift: " (a << 1) "`n"
    . "Right shift: " (a >> 1))
