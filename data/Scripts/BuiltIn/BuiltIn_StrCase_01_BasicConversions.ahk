#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_StrCase_01_BasicConversions.ahk
 * 
 * DESCRIPTION:
 * Basic usage examples of StrLower(), StrUpper(), and StrTitle() functions
 * for string case conversion in AutoHotkey v2.
 * 
 * FEATURES:
 * - Convert strings to lowercase
 * - Convert strings to uppercase
 * - Convert strings to title case
 * - Handle special characters and numbers
 * - Preserve whitespace during conversion
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/StrLower.htm
 * https://www.autohotkey.com/docs/v2/lib/StrUpper.htm
 * https://www.autohotkey.com/docs/v2/lib/StrTitle.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - StrLower() function for lowercase conversion
 * - StrUpper() function for uppercase conversion
 * - StrTitle() function for title case conversion
 * - String manipulation in expressions
 * - MsgBox with formatted output
 * 
 * LEARNING POINTS:
 * 1. StrLower() converts all alphabetic characters to lowercase
 * 2. StrUpper() converts all alphabetic characters to uppercase
 * 3. StrTitle() capitalizes the first letter of each word
 * 4. Numbers and special characters remain unchanged
 * 5. All functions preserve whitespace and formatting
 */

; ============================================================
; Example 1: Basic Lowercase Conversion
; ============================================================

/**
 * Demonstrate basic StrLower() usage
 * Converts all uppercase and mixed case text to lowercase
 */

originalText := "HELLO WORLD"
lowerText := StrLower(originalText)

MsgBox("Original: " originalText "`n"
    . "Lowercase: " lowerText "`n`n"
    . "The StrLower() function converts all alphabetic`n"
    . "characters to lowercase.",
    "StrLower() - Basic Example", "Icon!")

; Mixed case example
mixedCase := "ThIs Is MiXeD CaSe"
lowerMixed := StrLower(mixedCase)

MsgBox("Original: " mixedCase "`n"
    . "Lowercase: " lowerMixed,
    "StrLower() - Mixed Case", "Icon!")

; ============================================================
; Example 2: Basic Uppercase Conversion
; ============================================================

/**
 * Demonstrate basic StrUpper() usage
 * Converts all lowercase and mixed case text to uppercase
 */

softText := "hello world"
loudText := StrUpper(softText)

MsgBox("Original: " softText "`n"
    . "Uppercase: " loudText "`n`n"
    . "The StrUpper() function converts all alphabetic`n"
    . "characters to UPPERCASE.",
    "StrUpper() - Basic Example", "Icon!")

; Mixed case example
mixedInput := "AutoHotkey Version 2.0"
upperMixed := StrUpper(mixedInput)

MsgBox("Original: " mixedInput "`n"
    . "Uppercase: " upperMixed,
    "StrUpper() - Mixed Case", "Icon!")

; ============================================================
; Example 3: Basic Title Case Conversion
; ============================================================

/**
 * Demonstrate basic StrTitle() usage
 * Capitalizes the first letter of each word
 */

plainText := "the quick brown fox jumps over the lazy dog"
titleText := StrTitle(plainText)

MsgBox("Original: " plainText "`n"
    . "Title Case: " titleText "`n`n"
    . "The StrTitle() function capitalizes the first`n"
    . "letter of each word.",
    "StrTitle() - Basic Example", "Icon!")

; All uppercase to title case
allCaps := "WELCOME TO AUTOHOTKEY"
titleFromCaps := StrTitle(allCaps)

MsgBox("Original: " allCaps "`n"
    . "Title Case: " titleFromCaps "`n`n"
    . "Note: StrTitle() also lowercases other characters",
    "StrTitle() - From Uppercase", "Icon!")

; ============================================================
; Example 4: Comparison of All Three Functions
; ============================================================

/**
 * Compare all three case conversion functions side-by-side
 * Shows how the same text appears in different cases
 */

baseText := "AutoHotkey is a Powerful Scripting Language"

results := "Original Text:`n"
    . baseText "`n`n"
    . "StrLower():`n"
    . StrLower(baseText) "`n`n"
    . "StrUpper():`n"
    . StrUpper(baseText) "`n`n"
    . "StrTitle():`n"
    . StrTitle(baseText)

MsgBox(results, "Case Conversion Comparison", "Icon!")

; Compare with different starting text
sampleTexts := [
    "SYSTEM ERROR OCCURRED",
    "user authentication required",
    "tHiS iS wEiRd CaSiNg"
]

for index, text in sampleTexts {
    comparison := "Sample #" index "`n"
        . "Original: " text "`n"
        . "Lower: " StrLower(text) "`n"
        . "Upper: " StrUpper(text) "`n"
        . "Title: " StrTitle(text)

    MsgBox(comparison, "Comparison Sample " index, "Icon!")
}

; ============================================================
; Example 5: Handling Special Characters and Numbers
; ============================================================

/**
 * Demonstrate how case functions handle non-alphabetic characters
 * Numbers, punctuation, and symbols remain unchanged
 */

specialText := "Product-123: $49.99 (50% OFF!)"

MsgBox("Original: " specialText "`n"
    . "Lower: " StrLower(specialText) "`n"
    . "Upper: " StrUpper(specialText) "`n"
    . "Title: " StrTitle(specialText) "`n`n"
    . "Numbers, symbols, and punctuation are preserved!",
    "Special Characters", "Icon!")

; Email address example
emailAddr := "User.Name@Example.COM"

MsgBox("Original Email: " emailAddr "`n"
    . "Lowercase: " StrLower(emailAddr) "`n"
    . "Uppercase: " StrUpper(emailAddr) "`n"
    . "Title Case: " StrTitle(emailAddr) "`n`n"
    . "Note: Case conversion works on all parts",
    "Email Case Conversion", "Icon!")

; Mixed content
mixedContent := "Error #404: Page Not Found! @2024"

MsgBox("Original: " mixedContent "`n"
    . "Lower: " StrLower(mixedContent) "`n"
    . "Upper: " StrUpper(mixedContent) "`n"
    . "Title: " StrTitle(mixedContent),
    "Mixed Content Example", "Icon!")

; ============================================================
; Example 6: Case Conversion Functions
; ============================================================

/**
 * Helper function to demonstrate all case conversions at once
 * 
 * @param {String} text - Input text to convert
 * @returns {String} - Formatted string with all conversions
 */
ShowAllCases(text) {
    return "Original: " text "`n"
        . "Lower: " StrLower(text) "`n"
        . "Upper: " StrUpper(text) "`n"
        . "Title: " StrTitle(text)
}

/**
 * Toggle case between lower and upper
 * 
 * @param {String} text - Input text
 * @param {Boolean} toUpper - If true, convert to upper, else to lower
 * @returns {String} - Converted text
 */
ToggleCase(text, toUpper := true) {
    if (toUpper)
        return StrUpper(text)
    else
        return StrLower(text)
}

; Test the helper functions
testText := "Testing Helper Functions"

MsgBox(ShowAllCases(testText), "All Cases Helper", "Icon!")

; Toggle examples
originalState := "toggle me"
MsgBox("Original: " originalState "`n"
    . "Toggled Upper: " ToggleCase(originalState, true) "`n"
    . "Toggled Lower: " ToggleCase(originalState, false),
    "Toggle Case Helper", "Icon!")

; ============================================================
; Example 7: Practical Applications
; ============================================================

/**
 * Convert command string to consistent case for processing
 * 
 * @param {String} command - User input command
 * @returns {String} - Normalized lowercase command
 */
NormalizeCommand(command) {
    return StrLower(Trim(command))
}

/**
 * Format display name from raw input
 * 
 * @param {String} name - Raw name input
 * @returns {String} - Properly formatted title case name
 */
FormatDisplayName(name) {
    return StrTitle(Trim(name))
}

/**
 * Generate acronym from phrase
 * 
 * @param {String} phrase - Multi-word phrase
 * @returns {String} - Uppercase acronym
 */
GenerateAcronym(phrase) {
    acronym := ""
    Loop Parse, phrase, " " {
        if (A_LoopField != "")
            acronym .= SubStr(A_LoopField, 1, 1)
    }
    return StrUpper(acronym)
}

; Test practical functions
userCommand := "  SAVE FILE  "
processedCommand := NormalizeCommand(userCommand)

MsgBox("User Input: '" userCommand "'`n"
    . "Normalized: '" processedCommand "'`n`n"
    . "Commands are normalized to lowercase for processing",
    "Command Normalization", "Icon!")

; Name formatting
rawName := "JOHN MICHAEL SMITH"
displayName := FormatDisplayName(rawName)

MsgBox("Raw Input: " rawName "`n"
    . "Display Name: " displayName "`n`n"
    . "Names are formatted in title case for display",
    "Name Formatting", "Icon!")

; Acronym generation
organizationName := "United Nations Educational Scientific and Cultural Organization"
acronym := GenerateAcronym(organizationName)

MsgBox("Organization: " organizationName "`n`n"
    . "Acronym: " acronym "`n`n"
    . "Acronyms are generated by taking first letters",
    "Acronym Generator", "Icon!")

; Multiple examples
phrases := [
    "frequently asked questions",
    "graphical user interface",
    "portable document format"
]

output := "Acronym Generation Examples:`n`n"
for phrase in phrases {
    output .= phrase " → " GenerateAcronym(phrase) "`n"
}

MsgBox(output, "Acronym Examples", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
STRING CASE CONVERSION FUNCTIONS:

STRLOWER():
Syntax: LowerStr := StrLower(String)
• Converts all alphabetic characters to lowercase
• Preserves numbers, symbols, and whitespace
• Returns new string (original unchanged)

STRUPPER():
Syntax: UpperStr := StrUpper(String)
• Converts all alphabetic characters to UPPERCASE
• Preserves numbers, symbols, and whitespace
• Returns new string (original unchanged)

STRTITLE():
Syntax: TitleStr := StrTitle(String)
• Capitalizes First Letter Of Each Word
• Lowercases all other letters
• Words are separated by whitespace
• Preserves numbers and symbols

Key Points:
✓ All functions return a new string
✓ Original string is not modified
✓ Non-alphabetic characters are preserved
✓ Functions work with Unicode characters
✓ Empty strings return empty strings
✓ Whitespace is maintained

Common Use Cases:
• StrLower() - Email addresses, database keys, URLs
• StrUpper() - Constants, acronyms, emphasis
• StrTitle() - Names, titles, headings

Performance Notes:
• All functions are fast and efficient
• Safe to use in loops and frequent operations
• No side effects or state changes
)"

MsgBox(info, "Case Conversion Reference", "Icon!")

; ============================================================
; Additional Examples: Unicode Support
; ============================================================

/**
 * Demonstrate Unicode character support
 * Case conversion works with international characters
 */

; Various languages
unicodeExamples := Map(
    "German", "SCHÖN GRÜßEN",
    "French", "ÊTRE OU NE PAS ÊTRE",
    "Spanish", "MAÑANA ESPAÑA",
    "Turkish", "İSTANBUL TÜRKİYE"
)

unicodeOutput := "Unicode Case Conversion Examples:`n`n"
for language, text in unicodeExamples {
    unicodeOutput .= language ":`n"
        . "  Original: " text "`n"
        . "  Lower: " StrLower(text) "`n"
        . "  Title: " StrTitle(text) "`n`n"
}

MsgBox(unicodeOutput, "Unicode Support", "Icon!")

; ============================================================
; Final Summary
; ============================================================

summary := "
(
CASE CONVERSION SUMMARY:

Functions Covered:
1. StrLower() - Convert to lowercase
2. StrUpper() - Convert to UPPERCASE
3. StrTitle() - Convert To Title Case

What You've Learned:
✓ Basic case conversion syntax
✓ How each function handles text
✓ Special character preservation
✓ Practical application examples
✓ Unicode support
✓ Helper function creation

Next Steps:
• Explore text formatting applications
• Learn about data normalization
• Practice with real-world scenarios
• Combine with other string functions

See the next files:
• BuiltIn_StrCase_02_TextFormatting.ahk
• BuiltIn_StrCase_03_DataNormalization.ahk
)"

MsgBox(summary, "Learning Summary", "Icon!")
