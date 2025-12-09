#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* StrUpper/StrLower/StrTitle() - Change case
*
* Converts a string to uppercase, lowercase, or title case.
*/

text := "Hello World"

upper := StrUpper(text)
lower := StrLower(text)
title := StrTitle(text)

MsgBox("Original: " text
. "`nUpper: " upper
. "`nLower: " lower
. "`nTitle: " title)
