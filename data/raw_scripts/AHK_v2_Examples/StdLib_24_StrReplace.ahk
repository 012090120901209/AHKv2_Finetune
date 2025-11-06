#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * StrReplace() - Replace text
 *
 * Replaces the specified substring with a new string.
 */

text := "The quick brown fox"

replaced1 := StrReplace(text, "fox", "dog")
replaced2 := StrReplace(text, "quick", "slow", , &count)

MsgBox("Original: " text
    . "`nReplace fox: " replaced1
    . "`nReplace quick: " replaced2
    . "`nReplacements made: " count)
