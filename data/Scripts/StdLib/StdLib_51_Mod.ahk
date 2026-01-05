#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Mod() - Modulo operation
 * 
 * Returns the remainder after division.
 */

MsgBox("10 mod 3 = " Mod(10, 3) "`n"
    . "15 mod 4 = " Mod(15, 4) "`n"
    . "7 mod 2 = " Mod(7, 2) " (odd)`n"
    . "8 mod 2 = " Mod(8, 2) " (even)")
