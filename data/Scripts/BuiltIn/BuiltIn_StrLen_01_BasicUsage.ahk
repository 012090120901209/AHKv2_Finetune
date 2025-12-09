#Requires AutoHotkey v2.0

/**
* BuiltIn_StrLen_01_BasicUsage.ahk
*
* DESCRIPTION:
* Basic usage examples of StrLen() function to get string length
*
* FEATURES:
* - Get character count of strings
* - Unicode character handling
* - Empty string handling
* - Variable string length
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/StrLen.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - StrLen() function
* - String concatenation
* - MsgBox with formatted output
* - Type() function for verification
*
* LEARNING POINTS:
* 1. StrLen() returns the number of characters in a string
* 2. Returns 0 for empty strings
* 3. Counts Unicode characters correctly
* 4. Works with variables and literal strings
* 5. Can be used in expressions and conditionals
*/

; ============================================================
; Example 1: Basic String Length
; ============================================================

text := "Hello, World!"
length := StrLen(text)

MsgBox("Text: '" text "'`n"
. "Length: " length " characters",
"Basic StrLen Example", "Icon!")

; ============================================================
; Example 2: Empty String
; ============================================================

emptyString := ""
emptyLength := StrLen(emptyString)

MsgBox("Empty string length: " emptyLength "`n"
. "Expected: 0",
"Empty String", "Icon!")

; ============================================================
; Example 3: Unicode Characters
; ============================================================

unicodeText := "Hello 世界 🌍"
unicodeLength := StrLen(unicodeText)

MsgBox("Text: '" unicodeText "'`n"
. "Length: " unicodeLength " characters`n`n"
. "Note: Unicode characters are counted correctly",
"Unicode String Length", "Icon!")

; ============================================================
; Example 4: Length Comparison
; ============================================================

short := "Hi"
medium := "Hello there"
long := "This is a much longer string with many characters"

MsgBox("Short: '" short "' = " StrLen(short) " chars`n"
. "Medium: '" medium "' = " StrLen(medium) " chars`n"
. "Long: '" long "' = " StrLen(long) " chars",
"Length Comparison", "Icon!")

; ============================================================
; Example 5: Using in Conditionals
; ============================================================

userInput := "AutoHotkey"

if (StrLen(userInput) > 10) {
    result := "String is longer than 10 characters"
} else if (StrLen(userInput) > 5) {
    result := "String is between 6 and 10 characters"
} else {
    result := "String is 5 characters or less"
}

MsgBox("Input: '" userInput "'`n"
. "Length: " StrLen(userInput) "`n"
. "Result: " result,
"Conditional Example", "Icon!")

; ============================================================
; Example 6: Password Strength Checker
; ============================================================

/**
* Check password strength based on length
*
* @param {String} password - Password to check
* @returns {String} - Strength rating
*/
CheckPasswordStrength(password) {
    length := StrLen(password)

    if (length < 6)
    return "Weak (less than 6 characters)"
    else if (length < 10)
    return "Medium (6-9 characters)"
    else if (length < 15)
    return "Strong (10-14 characters)"
    else
    return "Very Strong (15+ characters)"
}

; Test passwords
passwords := ["abc", "hello123", "MySecurePass", "VeryLongAndComplexPassword!2024"]

output := "Password Strength Analysis:`n`n"
for password in passwords {
    output .= "'" password "' (" StrLen(password) " chars): "
    output .= CheckPasswordStrength(password) "`n"
}

MsgBox(output, "Password Strength Checker", "Icon!")

; ============================================================
; Example 7: Character Counter
; ============================================================

/**
* Display detailed character statistics
*
* @param {String} text - Text to analyze
* @returns {String} - Formatted statistics
*/
GetCharacterStats(text) {
    totalLength := StrLen(text)

    ; Count spaces
    spaceCount := 0
    Loop Parse, text {
        if (A_LoopField = " ")
        spaceCount++
    }

    nonSpaceCount := totalLength - spaceCount

    return "Total Characters: " totalLength "`n"
    . "Non-Space Characters: " nonSpaceCount "`n"
    . "Spaces: " spaceCount
}

sampleText := "The quick brown fox jumps over the lazy dog"

MsgBox("Text: '" sampleText "'`n`n"
. GetCharacterStats(sampleText),
"Character Statistics", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
STRLEN() FUNCTION REFERENCE:

Syntax:
Length := StrLen(String)

Parameters:
String - The string to measure

Return Value:
Integer - Number of characters in the string

Key Points:
• Returns 0 for empty strings
• Counts all characters including spaces
• Properly handles Unicode characters
• Can be used in expressions
• Useful for validation and text processing

Common Use Cases:
✓ Input validation
✓ Password strength checking
✓ Text truncation decisions
✓ Display formatting
✓ Data validation
✓ String comparison preparation
)"

MsgBox(info, "StrLen() Reference", "Icon!")
