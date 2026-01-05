#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Number formatting with Format()
 * 
 * Format numbers in various ways (decimals, hex, binary, etc.).
 */

num := 1234567.89

MsgBox("Number: " num "`n`n"
    . "2 decimals: " Format("{:.2f}", num) "`n"
    . "Scientific: " Format("{:e}", num) "`n"
    . "Hex: " Format("{:#x}", Integer(num)) "`n"
    . "Binary: " Format("{:#b}", 255))
