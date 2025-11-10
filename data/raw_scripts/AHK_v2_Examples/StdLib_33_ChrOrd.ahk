#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Chr() and Ord() - Character conversions
 *
 * Convert between characters and their numeric codes.
 */

; Ord() - Get character code
code := Ord("A")

; Chr() - Get character from code
char := Chr(65)

MsgBox("Ord('A') = " code
    . "`nChr(65) = '" char "'")
