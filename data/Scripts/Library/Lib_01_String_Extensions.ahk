#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* String Extensions - Enhanced String Operations
*
* Demonstrates the String library extensions that add powerful
* methods to the native String type including slicing, counting,
* wrapping, and functional operations.
*
* Source: nperovic-AHK-v2-Libraries/Lib/String.ahk
* Inspired by: https://github.com/nperovic/AHK-v2-Libraries
*/

#Include <String>

MsgBox("String Extensions Demo`n`n"
. "This demonstrates enhanced string operations:`n"
. "- Character/substring indexing`n"
. "- Reverse, center, wrap`n"
. "- Count occurrences`n"
. "- Remove duplicates`n"
. "- Contains checking", , "T5")

; ===============================================
; CHARACTER AND SUBSTRING INDEXING
; ===============================================

text := "Hello World"

; Get individual character (like Python)
MsgBox("Character indexing:`n`n"
. "text := 'Hello World'`n"
. "text[1] = '" text[1] "'`n"
. "text[7] = '" text[7] "'`n"
. "text[-1] = '" text[-1] "' (last char)", , "T4")

; Get substring with slice notation
MsgBox("Substring slicing:`n`n"
. "text[1, 5] = '" text[1, 5] "'`n"
. "text[7, 11] = '" text[7, 11] "'`n"
. "text[1, -1] = '" text[1, -1] "' (except last)", , "T4")

; ===============================================
; STRING MANIPULATION
; ===============================================

; Reverse string
reversed := text.Reverse()
MsgBox("Reverse:`n`n"
. "Original: " text "`n"
. "Reversed: " reversed, , "T3")

; Center text (pad with spaces)
centered := text.Center(21)  ; Total width 21
MsgBox("Center text:`n`n"
. "Original length: " StrLen(text) "`n"
. "Centered (21 width):`n"
. "[" centered "]", , "T3")

; Count occurrences
sentence := "The quick brown fox jumps over the lazy dog"
count_o := sentence.Count("o")
count_the := sentence.Count("the")
MsgBox("Count occurrences:`n`n"
. "Sentence: " sentence "`n`n"
. "Count 'o': " count_o "`n"
. "Count 'the': " count_the " (case-sensitive)", , "T4")

; ===============================================
; LINE OPERATIONS
; ===============================================

; Word wrap
longText := "This is a very long line of text that needs to be wrapped at a specific column width to make it more readable in a console or fixed-width display. Without wrapping it would extend far beyond the comfortable reading width."

wrapped := longText.LineWrap(40)
MsgBox("Line wrapping at 40 characters:`n`n" wrapped, , "T5")

; Remove duplicate lines
duplicateText := "Line 1`nLine 2`nLine 1`nLine 3`nLine 2`nLine 4"
unique := duplicateText.RemoveDuplicates()
MsgBox("Remove duplicate lines:`n`n"
. "Original:`n" duplicateText "`n`n"
. "Unique:`n" unique, , "T5")

; ===============================================
; CONTAINS CHECKING
; ===============================================

email := "user@example.com"
hasAt := email.Contains("@")
hasDomain := email.Contains("example")
hasMultiple := email.Contains("@", ".com")  ; Check multiple

MsgBox("Contains checking:`n`n"
. "Email: " email "`n`n"
. "Contains '@': " (hasAt ? "Yes" : "No") "`n"
. "Contains 'example': " (hasDomain ? "Yes" : "No") "`n"
. "Contains both '@' and '.com': " (hasMultiple ? "Yes" : "No"), , "T4")

; ===============================================
; PRACTICAL EXAMPLE: TEXT PROCESSOR
; ===============================================

; Open Notepad to demonstrate
Run("notepad.exe")
WinWait("ahk_exe notepad.exe", , 3)
WinActivate("ahk_exe notepad.exe")
Sleep(500)

; Type sample text
sampleText := "AutoHotkey is amazing! AutoHotkey makes automation easy. Try AutoHotkey today!"
Send(sampleText)

result := MsgBox("Text processing demo:`n`n"
. "Count 'AutoHotkey': " sampleText.Count("AutoHotkey") "`n"
. "Contains 'automation': " (sampleText.Contains("automation") ? "Yes" : "No") "`n`n"
. "Click OK to see reversed text", "OK")

; Show reversed
Send("^a")
Sleep(200)
reversed := sampleText.Reverse()
Send(reversed)

/*
* Key Concepts:
*
* 1. Character Indexing:
*    str[n] - Get nth character (1-based)
*    str[-1] - Last character
*    str[-2] - Second to last
*
* 2. Substring Slicing:
*    str[i, j] - Characters from i to j
*    str[1, 5] - First 5 characters
*    str[1, -1] - All except last
*
* 3. Reverse:
*    str.Reverse() - Reverse character order
*    Works with any text
*    Returns new string
*
* 4. Center:
*    str.Center(width) - Center in width
*    Pads with spaces
*    Useful for formatting
*
* 5. Count:
*    str.Count(needle) - Count occurrences
*    Case-sensitive by default
*    Can search for phrases
*
* 6. LineWrap:
*    str.LineWrap(column) - Wrap at column
*    Word-aware wrapping
*    Preserves word boundaries
*
* 7. RemoveDuplicates:
*    Removes duplicate lines
*    Preserves first occurrence
*    Case-sensitive
*
* 8. Contains:
*    str.Contains(needles*) - Check if contains
*    Multiple needles: all must match
*    Case-sensitive
*    Returns true/false
*
* 9. Performance:
*    All methods are efficient
*    Return new strings (immutable)
*    Can chain operations
*
* 10. Python-like Syntax:
*     Familiar for Python developers
*     Cleaner than traditional AHK
*     More readable code
*
* 11. Common Use Cases:
*     ✅ Text processing
*     ✅ Data validation
*     ✅ String manipulation
*     ✅ Formatting output
*     ✅ Parsing text files
*
* 12. Chaining Operations:
*     text.Reverse().Center(20)
*     Combine multiple operations
*     Cleaner than nested calls
*
* 13. Additional Methods:
*     - Split() - Enhanced split
*     - Join() - Array to string
*     - Strip() - Remove whitespace
*     - StartsWith() / EndsWith()
*     - IsUpper() / IsLower()
*     - Capitalize() - First char upper
*
* 14. Best Practices:
*     ✅ Use for text processing
*     ✅ Combine with loops
*     ✅ Validate before processing
*     ✅ Handle empty strings
*/
