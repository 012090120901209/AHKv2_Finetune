#Requires AutoHotkey v2.0

/**
* BuiltIn_SubStr_01_BasicUsage.ahk
*
* DESCRIPTION:
* Basic usage of SubStr() to extract portions of strings
*
* FEATURES:
* - Extract substrings from specific positions
* - Specify length of extraction
* - Negative positions (count from end)
* - Extract from middle, start, or end
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/SubStr.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - SubStr() function syntax
* - Positive and negative indexing
* - Optional length parameter
* - String manipulation
*
* LEARNING POINTS:
* 1. SubStr(String, StartPos, Length) extracts substring
* 2. Position 1 is first character (not 0)
* 3. Negative position counts from end
* 4. Omitting length extracts to end of string
* 5. Length parameter controls how many characters
*/

; ============================================================
; Example 1: Basic Substring Extraction
; ============================================================

text := "AutoHotkey Version 2.0"

; Extract from position 1 (first character)
first5 := SubStr(text, 1, 5)  ; "AutoH"

; Extract from position 5
middle := SubStr(text, 5, 6)  ; "Hotkey"

; Extract to end (omit length)
fromPos12 := SubStr(text, 12)  ; "Version 2.0"

MsgBox("Original: '" text "'`n`n"
. "First 5 chars: '" first5 "'`n"
. "Chars 5-10: '" middle "'`n"
. "From pos 12 to end: '" fromPos12 "'",
"Basic SubStr()", "Icon!")

; ============================================================
; Example 2: Negative Positions (from end)
; ============================================================

text := "document.txt"

; Extract last 3 characters
last3 := SubStr(text, -3)  ; "txt"

; Extract 4 characters starting from 4th-to-last
last4to7 := SubStr(text, -7, 4)  ; "ment"

; Get file extension (last 4 chars)
extension := SubStr(text, -3)  ; "txt"

MsgBox("Filename: '" text "'`n`n"
. "Last 3 chars: '" last3 "'`n"
. "4 chars from -7: '" last4to7 "'`n"
. "Extension: '" extension "'",
"Negative Positions", "Icon!")

; ============================================================
; Example 3: Extract File Components
; ============================================================

filePath := "C:\Users\John\Documents\report.pdf"

; Extract drive letter (first 2 chars)
drive := SubStr(filePath, 1, 2)  ; "C:"

; Extract extension (last 4 chars including dot)
extension := SubStr(filePath, -3)  ; "pdf"

; Extract filename (after last backslash)
lastSlash := InStr(filePath, "\", , -1)
filename := SubStr(filePath, lastSlash + 1)  ; "report.pdf"

MsgBox("Path: '" filePath "'`n`n"
. "Drive: '" drive "'`n"
. "Filename: '" filename "'`n"
. "Extension: '" extension "'",
"File Path Extraction", "Icon!")

; ============================================================
; Example 4: Extract Date Components
; ============================================================

dateString := "2024-11-16"

; Extract year (positions 1-4)
year := SubStr(dateString, 1, 4)  ; "2024"

; Extract month (positions 6-7)
month := SubStr(dateString, 6, 2)  ; "11"

; Extract day (positions 9-10)
day := SubStr(dateString, 9, 2)  ; "16"

MsgBox("Date: '" dateString "'`n`n"
. "Year: " year "`n"
. "Month: " month "`n"
. "Day: " day,
"Date Parsing", "Icon!")

; ============================================================
; Example 5: Truncate Text
; ============================================================

/**
* Truncate string to maximum length
*
* @param {String} text - Text to truncate
* @param {Integer} maxLength - Maximum length
* @returns {String} - Truncated text
*/
Truncate(text, maxLength) {
    if (StrLen(text) <= maxLength)
    return text

    return SubStr(text, 1, maxLength)
}

longText := "This is a very long string that needs truncation"

MsgBox("Original (" StrLen(longText) " chars):`n"
. "'" longText "'`n`n"
. "Truncated to 20:`n"
. "'" Truncate(longText, 20) "'`n`n"
. "Truncated to 30:`n"
. "'" Truncate(longText, 30) "'",
"Truncation", "Icon!")

; ============================================================
; Example 6: Get First/Last Words
; ============================================================

sentence := "The quick brown fox jumps"

; Get first word (up to first space)
firstSpace := InStr(sentence, " ")
firstWord := SubStr(sentence, 1, firstSpace - 1)  ; "The"

; Get last word (from last space)
lastSpace := InStr(sentence, " ", , -1)
lastWord := SubStr(sentence, lastSpace + 1)  ; "jumps"

MsgBox("Sentence: '" sentence "'`n`n"
. "First word: '" firstWord "'`n"
. "Last word: '" lastWord "'",
"Word Extraction", "Icon!")

; ============================================================
; Example 7: Credit Card Masking
; ============================================================

/**
* Mask credit card number showing only last 4 digits
*
* @param {String} cardNumber - Card number
* @returns {String} - Masked number
*/
MaskCardNumber(cardNumber) {
    ; Remove spaces
    cardNumber := StrReplace(cardNumber, " ", "")

    ; Get last 4 digits
    last4 := SubStr(cardNumber, -3)

    ; Create masked string
    maskCount := StrLen(cardNumber) - 4
    mask := ""
    Loop maskCount
    mask .= "*"

    return mask . last4
}

cardNumbers := [
"4532123456789012",
"5425 2334 3010 9903",
"378282246310005"
]

output := "MASKED CREDIT CARDS:`n`n"
for card in cardNumbers {
    output .= "Original: " card "`n"
    output .= "Masked: " MaskCardNumber(card) "`n`n"
}

MsgBox(output, "Card Masking", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
SUBSTR() FUNCTION REFERENCE:

Syntax:
NewStr := SubStr(String, StartPos, Length?)

Parameters:
String - The string to extract from
StartPos - Starting position (1-based)
Length - Number of characters (optional)

Position Rules:
• Positive: Count from start (1 = first char)
• Negative: Count from end (-1 = last char)
• 0: Treated as length of string

Length Rules:
• Positive: Extract that many characters
• Negative: Omit that many from end
• Omitted: Extract to end of string

Examples:
SubStr("Hello", 1, 3)   → "Hel"
SubStr("Hello", 2)      → "ello"
SubStr("Hello", -2)     → "lo"
SubStr("Hello", 2, 2)   → "el"

Common Use Cases:
✓ Extract file extensions
✓ Parse dates and times
✓ Get first/last N characters
✓ Extract tokens from formatted strings
✓ Truncate long text
✓ Remove prefixes/suffixes
)"

MsgBox(info, "SubStr() Reference", "Icon!")
