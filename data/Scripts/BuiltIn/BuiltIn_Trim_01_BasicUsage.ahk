#Requires AutoHotkey v2.0

/**
* BuiltIn_Trim_01_BasicUsage.ahk
*
* DESCRIPTION:
* Basic usage of Trim(), LTrim(), and RTrim() for whitespace removal
*
* FEATURES:
* - Remove leading and trailing whitespace
* - Remove only leading whitespace (left trim)
* - Remove only trailing whitespace (right trim)
* - Handle various whitespace types (spaces, tabs, newlines)
* - Compare all three trim functions
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/Trim.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - Trim() function for both ends
* - LTrim() function for left side only
* - RTrim() function for right side only
* - Whitespace character handling
* - String cleaning operations
*
* LEARNING POINTS:
* 1. Trim() removes spaces and tabs from both ends by default
* 2. LTrim() removes only from the beginning (left)
* 3. RTrim() removes only from the end (right)
* 4. Can specify custom characters to remove
* 5. Whitespace includes spaces, tabs, newlines, carriage returns
* 6. Original string is not modified (returns new string)
*/

; ============================================================
; Example 1: Basic Trim() Usage
; ============================================================

/**
* Demonstrates basic Trim() to remove leading and trailing whitespace
*/

; String with spaces on both ends
text1 := "   Hello World   "
trimmed1 := Trim(text1)

; String with tabs
text2 := "`tTabbed Text`t"
trimmed2 := Trim(text2)

; String with mixed whitespace
text3 := "  `t  Mixed Whitespace  `t  "
trimmed3 := Trim(text3)

MsgBox("TRIM() - Remove Both Ends:`n`n"
. "Original: '" text1 "'`n"
. "Trimmed: '" trimmed1 "'`n`n"
. "Original: '" text2 "'`n"
. "Trimmed: '" trimmed2 "'`n`n"
. "Original: '" text3 "'`n"
. "Trimmed: '" trimmed3 "'",
"Basic Trim()", "Icon!")

; ============================================================
; Example 2: LTrim() - Left Side Only
; ============================================================

/**
* Demonstrates LTrim() to remove only leading whitespace
*/

; String with leading spaces
text1 := "   Leading spaces only   "
ltrimmed1 := LTrim(text1)

; String with leading tabs
text2 := "`t`tLeading tabs`t`t"
ltrimmed2 := LTrim(text2)

; Indented text (preserve trailing)
text3 := "    Indented line    "
ltrimmed3 := LTrim(text3)

MsgBox("LTRIM() - Remove Left Only:`n`n"
. "Original: '" text1 "'`n"
. "LTrimmed: '" ltrimmed1 "'`n`n"
. "Original: '" text2 "'`n"
. "LTrimmed: '" ltrimmed2 "'`n`n"
. "Original: '" text3 "'`n"
. "LTrimmed: '" ltrimmed3 "'",
"LTrim() Usage", "Icon!")

; ============================================================
; Example 3: RTrim() - Right Side Only
; ============================================================

/**
* Demonstrates RTrim() to remove only trailing whitespace
*/

; String with trailing spaces
text1 := "   Trailing spaces only   "
rtrimmed1 := RTrim(text1)

; String with trailing tabs
text2 := "`t`tTrailing tabs`t`t"
rtrimmed2 := RTrim(text2)

; Line with trailing whitespace (common in text files)
text3 := "    Text with trailing spaces    "
rtrimmed3 := RTrim(text3)

MsgBox("RTRIM() - Remove Right Only:`n`n"
. "Original: '" text1 "'`n"
. "RTrimmed: '" rtrimmed1 "'`n`n"
. "Original: '" text2 "'`n"
. "RTrimmed: '" rtrimmed2 "'`n`n"
. "Original: '" text3 "'`n"
. "RTrimmed: '" rtrimmed3 "'",
"RTrim() Usage", "Icon!")

; ============================================================
; Example 4: Comparing All Three Functions
; ============================================================

/**
* Side-by-side comparison of Trim(), LTrim(), and RTrim()
*/

testString := "   Text with whitespace on both sides   "

result_trim := Trim(testString)
result_ltrim := LTrim(testString)
result_rtrim := RTrim(testString)

MsgBox("COMPARISON OF TRIM FUNCTIONS:`n`n"
. "Original (" StrLen(testString) " chars):`n"
. "'" testString "'`n`n"
. "Trim() (" StrLen(result_trim) " chars):`n"
. "'" result_trim "'`n`n"
. "LTrim() (" StrLen(result_ltrim) " chars):`n"
. "'" result_ltrim "'`n`n"
. "RTrim() (" StrLen(result_rtrim) " chars):`n"
. "'" result_rtrim "'",
"Function Comparison", "Icon!")

; ============================================================
; Example 5: Newlines and Line Endings
; ============================================================

/**
* Trim handles newlines, carriage returns, and line endings
*/

; Text with newlines
text1 := "`n`nText with newlines`n`n"
trimmed1 := Trim(text1)

; Text with carriage returns
text2 := "`r`nWindows line ending`r`n"
trimmed2 := Trim(text2)

; Multi-line with mixed endings
text3 := "`n`r  Mixed line endings  `r`n"
trimmed3 := Trim(text3)

MsgBox("NEWLINE AND LINE ENDING REMOVAL:`n`n"
. "With newlines:`n"
. "Before: '" text1 "' (len: " StrLen(text1) ")`n"
. "After: '" trimmed1 "' (len: " StrLen(trimmed1) ")`n`n"
. "Windows CR+LF:`n"
. "Before: '" text2 "' (len: " StrLen(text2) ")`n"
. "After: '" trimmed2 "' (len: " StrLen(trimmed2) ")`n`n"
. "Mixed endings:`n"
. "Before: '" text3 "' (len: " StrLen(text3) ")`n"
. "After: '" trimmed3 "' (len: " StrLen(trimmed3) ")",
"Line Endings", "Icon!")

; ============================================================
; Example 6: Trimming Custom Characters
; ============================================================

/**
* Trim specific characters instead of just whitespace
* Syntax: Trim(String, OmitChars)
*/

; Remove dots from both ends
text1 := "...Example..."
trimmed1 := Trim(text1, ".")

; Remove asterisks
text2 := "***Important***"
trimmed2 := Trim(text2, "*")

; Remove multiple character types
text3 := "###---Title---###"
trimmed3 := Trim(text3, "#-")

; Remove quotes
text4 := '"""Quoted Text"""'
trimmed4 := Trim(text4, '"')

MsgBox("CUSTOM CHARACTER TRIMMING:`n`n"
. "Remove dots:`n"
. "'" text1 "' → '" trimmed1 "'`n`n"
. "Remove asterisks:`n"
. "'" text2 "' → '" trimmed2 "'`n`n"
. "Remove # and -:`n"
. "'" text3 "' → '" trimmed3 "'`n`n"
. "Remove quotes:`n"
. "'" text4 "' → '" trimmed4 "'",
"Custom Characters", "Icon!")

; ============================================================
; Example 7: Practical String Cleaning Function
; ============================================================

/**
* Clean string by removing all types of whitespace
*
* @param {String} text - Text to clean
* @param {String} mode - "both", "left", "right"
* @returns {String} - Cleaned text
*/
CleanString(text, mode := "both") {
    switch mode {
        case "both":
        return Trim(text)
        case "left":
        return LTrim(text)
        case "right":
        return RTrim(text)
        default:
        return text
    }
}

/**
* Normalize whitespace: trim ends and collapse internal spaces
*
* @param {String} text - Text to normalize
* @returns {String} - Normalized text
*/
NormalizeWhitespace(text) {
    ; First trim both ends
    text := Trim(text)

    ; Replace multiple spaces with single space
    while InStr(text, "  ")
    text := StrReplace(text, "  ", " ")

    ; Replace tabs with spaces
    text := StrReplace(text, "`t", " ")

    return text
}

; Test the cleaning functions
messyText := "   This  has    too   much    whitespace   "

cleaned_both := CleanString(messyText, "both")
cleaned_left := CleanString(messyText, "left")
cleaned_right := CleanString(messyText, "right")
normalized := NormalizeWhitespace(messyText)

MsgBox("STRING CLEANING FUNCTIONS:`n`n"
. "Original:`n'" messyText "'`n`n"
. "Clean Both:`n'" cleaned_both "'`n`n"
. "Clean Left:`n'" cleaned_left "'`n`n"
. "Clean Right:`n'" cleaned_right "'`n`n"
. "Normalized:`n'" normalized "'",
"Cleaning Functions", "Icon!")

; ============================================================
; Example 8: Processing Multiple Lines
; ============================================================

/**
* Trim each line in a multi-line string
*/

multilineText := "
(
Line 1 with spaces
Line 2 indented
Line 3 with tabs`t`t
Line 4 mixed   `t
)"

/**
* Trim all lines in multi-line text
*
* @param {String} text - Multi-line text
* @returns {String} - Text with all lines trimmed
*/
TrimAllLines(text) {
    lines := StrSplit(text, "`n")
    trimmedLines := []

    for line in lines {
        trimmedLine := Trim(line, " `t`r")
        if (trimmedLine != "")  ; Skip empty lines
        trimmedLines.Push(trimmedLine)
    }

    return JoinArray(trimmedLines, "`n")
}

/**
* Join array elements with delimiter
*/
JoinArray(arr, delimiter := "") {
    result := ""
    for index, value in arr {
        result .= value
        if (index < arr.Length)
        result .= delimiter
    }
    return result
}

trimmedMultiline := TrimAllLines(multilineText)

MsgBox("MULTI-LINE TRIMMING:`n`n"
. "Original:`n" multilineText "`n`n"
. "All Lines Trimmed:`n" trimmedMultiline,
"Multi-line Processing", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
TRIM FUNCTIONS REFERENCE:

Trim() - Remove from both ends:
NewStr := Trim(String, OmitChars?)
Default OmitChars: spaces and tabs

LTrim() - Remove from left (beginning):
NewStr := LTrim(String, OmitChars?)
Default OmitChars: spaces and tabs

RTrim() - Remove from right (end):
NewStr := RTrim(String, OmitChars?)
Default OmitChars: spaces and tabs

Parameters:
String - The string to trim
OmitChars - Characters to remove (optional)

Default Whitespace Characters:
• Space ( )
• Tab (`t)

Additional Whitespace (use in OmitChars):
• Newline (`n)
• Carriage Return (`r)
• Vertical Tab (`v)
• Form Feed (`f)

Examples:
Trim("  Hello  ")           → "Hello"
LTrim("  Hello  ")          → "Hello  "
RTrim("  Hello  ")          → "  Hello"
Trim("...Test...", ".")     → "Test"
Trim("`n`nText`n`n", " `n") → "Text"

Common Use Cases:
✓ Clean user input from forms
✓ Remove indentation from code
✓ Strip line endings from file data
✓ Remove unwanted prefix/suffix characters
✓ Normalize text spacing
✓ Clean CSV or data file entries
✓ Process clipboard content

Important Notes:
• Returns a new string (doesn't modify original)
• OmitChars specifies ALL characters to remove
• Removes characters until a non-matching char is found
• Case-sensitive when specifying OmitChars
)"

MsgBox(info, "Trim Functions Reference", "Icon!")
