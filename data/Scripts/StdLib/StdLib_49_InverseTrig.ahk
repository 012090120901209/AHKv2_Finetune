#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ASin(), ACos(), ATan() - Inverse trigonometric functions
 * 
 * Returns angles in radians from trigonometric ratios.
 */

value := 0.5

MsgBox("Value: " value "`n`n"
    . "ASin (radians): " Round(ASin(value), 4) "`n"
    . "ACos (radians): " Round(ACos(value), 4) "`n"
    . "ATan (radians): " Round(ATan(value), 4))
