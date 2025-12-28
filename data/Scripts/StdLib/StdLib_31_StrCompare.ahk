#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * StrCompare() - Compare strings
 * 
 * Compares two strings (case-sensitive or case-insensitive).
 */

str1 := "apple"
str2 := "Apple"
str3 := "banana"

; Case-sensitive comparison
result1 := StrCompare(str1, str2)  ; != 0 (different)
result2 := StrCompare(str1, str2, false)  ; Case-insensitive, = 0 (same)
result3 := StrCompare(str1, str3)  ; < 0 (str1 comes before str3)

MsgBox("'apple' vs 'Apple' (sensitive): " result1
    . "`n'apple' vs 'Apple' (insensitive): " result2
    . "`n'apple' vs 'banana': " result3)
