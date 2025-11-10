#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Round(), Floor(), Ceil() - Rounding functions
 *
 * Different methods for rounding numbers.
 */

number := 3.7

MsgBox("Number: " number "`n`n"
    . "Round: " Round(number) "`n"
    . "Floor: " Floor(number) "`n"
    . "Ceil: " Ceil(number) "`n`n"
    . "Round to 2 decimals: " Round(3.14159, 2))
