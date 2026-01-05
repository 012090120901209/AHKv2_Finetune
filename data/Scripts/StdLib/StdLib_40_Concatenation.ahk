#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * String concatenation techniques
 * 
 * Multiple ways to combine strings in AHK v2.
 */

; Method 1: Dot operator
result1 := "Hello" . " " . "World"

; Method 2: Variable substitution
word1 := "Hello"
word2 := "World"
result2 := word1 " " word2

; Method 3: Format
result3 := Format("{1} {2}", word1, word2)

MsgBox("Method 1 (dot): " result1
    . "`nMethod 2 (substitution): " result2
    . "`nMethod 3 (Format): " result3)
