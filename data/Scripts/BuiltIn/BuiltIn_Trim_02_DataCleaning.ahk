#Requires AutoHotkey v2.0

/**
* BuiltIn_Trim_02_DataCleaning.ahk
*
* DESCRIPTION:
* Using Trim functions for data cleaning and input sanitization
*
* FEATURES:
* - Clean user input from forms and dialogs
* - Remove specific unwanted characters
* - Sanitize data for processing
* - Clean CSV and delimited data
* - Remove formatting characters
* - Validate and normalize input
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/Trim.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - Trim() with custom characters
* - LTrim() and RTrim() for specific cleaning
* - Chaining trim operations
* - Input validation and sanitization
* - Data normalization techniques
*
* LEARNING POINTS:
* 1. Always clean user input before processing
* 2. Trim can remove any specified characters, not just whitespace
* 3. Combine trim operations for thorough cleaning
* 4. Use trim to normalize data formats
* 5. Important for security and data integrity
* 6. Prevents issues with extra whitespace in data
*/

; ============================================================
; Example 1: Clean User Input from Forms
; ============================================================

/**
* Simulate cleaning input from user forms
*/

/**
* Clean form input field
*
* @param {String} input - Raw input from form
* @returns {String} - Cleaned input
*/
CleanFormInput(input) {
    ; Remove leading/trailing whitespace
    input := Trim(input)

    ; Remove multiple spaces
    while InStr(input, "  ")
    input := StrReplace(input, "  ", " ")

    return input
}

; Simulated form inputs with common issues
rawInputs := Map(
"Name", "  John  Doe   ",
"Email", "`t`tuser@example.com  `n",
"Phone", "   555-123-4567`t",
"Address", "  123   Main   Street  ",
"ZipCode", "  12345  "
)

cleanedInputs := Map()
output := "FORM INPUT CLEANING:`n`n"

for fieldName, rawValue in rawInputs {
    cleanedValue := CleanFormInput(rawValue)
    cleanedInputs[fieldName] := cleanedValue

    output .= fieldName ":`n"
    output .= "  Raw: '" rawValue "' (len: " StrLen(rawValue) ")`n"
    output .= "  Clean: '" cleanedValue "' (len: " StrLen(cleanedValue) ")`n`n"
}

MsgBox(output, "Form Input Cleaning", "Icon!")

; ============================================================
; Example 2: Remove Specific Characters (Quotes, Brackets)
; ============================================================

/**
* Clean strings by removing common formatting characters
*/

/**
* Remove quotes from string
*/
RemoveQuotes(text) {
    ; Remove both single and double quotes
    text := Trim(text, '"' . "'")
    return text
}

/**
* Remove brackets from string
*/
RemoveBrackets(text) {
    ; Remove [], {}, (), <>
    text := Trim(text, "[]{}()<>")
    return text
}

/**
* Remove all formatting characters
*/
RemoveFormatting(text) {
    ; Remove common formatting chars
    text := Trim(text, '"' . "'" . '[]{}()<>*_~`')
    return text
}

; Test data with various formatting
testStrings := [
'"Quoted text"',
"'Single quoted'",
"[Bracketed text]",
"{Curly braces}",
"(Parentheses)",
"<Angle brackets>",
"***Bold text***",
"_Underscored_"
]

output := "CHARACTER REMOVAL:`n`n"
for str in testStrings {
    cleaned := RemoveFormatting(str)
    output .= "Original: " str "`n"
    output .= "Cleaned: " cleaned "`n`n"
}

MsgBox(output, "Remove Formatting Characters", "Icon!")

; ============================================================
; Example 3: Sanitize Filenames
; ============================================================

/**
* Clean filename by removing invalid characters
*/

/**
* Sanitize filename for Windows
*
* @param {String} filename - Raw filename
* @returns {String} - Safe filename
*/
SanitizeFilename(filename) {
    ; Windows invalid chars: \ / : * ? " < > |
    invalidChars := '\/:*?"<>|'

    ; Replace invalid chars with underscore
    for i, char in StrSplit(invalidChars) {
        filename := StrReplace(filename, char, "_")
    }

    ; Trim spaces and dots from ends
    filename := Trim(filename, " .")

    ; Remove leading/trailing whitespace
    filename := Trim(filename)

    return filename
}

/**
* Clean filename and ensure extension
*/
CleanFilenameWithExtension(filename, defaultExt := "txt") {
    ; First sanitize
    filename := SanitizeFilename(filename)

    ; Check for extension
    if !InStr(filename, ".") {
        filename .= "." . defaultExt
    }

    return filename
}

; Test filenames with issues
testFilenames := [
"  My File.txt  ",
"Report: Q4 2024.pdf",
"Data*File?.csv",
'File"with"quotes.doc',
"path/to/file.txt",
"  ...Leading dots...",
"No Extension"
]

output := "FILENAME SANITIZATION:`n`n"
for filename in testFilenames {
    cleaned := SanitizeFilename(filename)
    withExt := CleanFilenameWithExtension(filename)

    output .= "Original: '" filename "'`n"
    output .= "Sanitized: '" cleaned "'`n"
    output .= "With .txt: '" withExt "'`n`n"
}

MsgBox(output, "Filename Cleaning", "Icon!")

; ============================================================
; Example 4: Clean CSV Data
; ============================================================

/**
* Clean CSV fields by trimming whitespace and quotes
*/

/**
* Parse and clean CSV line
*
* @param {String} csvLine - Raw CSV line
* @returns {Array} - Array of cleaned fields
*/
ParseCleanCSV(csvLine) {
    fields := StrSplit(csvLine, ",")
    cleanedFields := []

    for field in fields {
        ; Trim whitespace
        field := Trim(field)

        ; Remove surrounding quotes
        field := Trim(field, '"')

        ; Trim again after quote removal
        field := Trim(field)

        cleanedFields.Push(field)
    }

    return cleanedFields
}

; Sample CSV data with various formatting issues
csvLines := [
'  "John Doe"  ,  "john@email.com"  ,  "555-1234"  ',
'Jane Smith, jane@email.com  ,555-5678',
'  "Bob Johnson"  ,bob@email.com,"555-9012"',
'"Alice Brown", " alice@email.com " , " 555-3456 " '
]

output := "CSV DATA CLEANING:`n`n"
for index, line in csvLines {
    output .= "Line " index ":`n"
    output .= "Raw: " line "`n"

    fields := ParseCleanCSV(line)
    output .= "Cleaned Fields:`n"
    output .= "  Name: '" fields[1] "'`n"
    output .= "  Email: '" fields[2] "'`n"
    output .= "  Phone: '" fields[3] "'`n`n"
}

MsgBox(output, "CSV Data Cleaning", "Icon!")

; ============================================================
; Example 5: Clean and Validate Email Addresses
; ============================================================

/**
* Clean and validate email addresses
*/

/**
* Clean email address
*
* @param {String} email - Raw email input
* @returns {String} - Cleaned email
*/
CleanEmail(email) {
    ; Remove all whitespace (not just ends)
    email := StrReplace(email, " ", "")
    email := StrReplace(email, "`t", "")

    ; Trim any remaining chars
    email := Trim(email)

    ; Remove quotes and brackets
    email := Trim(email, '"' . "'<>")

    ; Convert to lowercase
    email := StrLower(email)

    return email
}

/**
* Validate email format (basic)
*/
IsValidEmail(email) {
    ; Must contain @ and .
    if !InStr(email, "@")
    return false
    if !InStr(email, ".")
    return false

    ; @ must come before last .
    atPos := InStr(email, "@")
    dotPos := InStr(email, ".", , -1)
    if (atPos >= dotPos)
    return false

    return true
}

; Test emails with various issues
testEmails := [
"  user@example.com  ",
"USER@EXAMPLE.COM",
'  "email@test.com"  ',
"<admin@site.org>",
"  support @ company . com  ",
"invalid.email",
"@no-user.com",
"no-at-sign.com"
]

output := "EMAIL CLEANING & VALIDATION:`n`n"
for email in testEmails {
    cleaned := CleanEmail(email)
    valid := IsValidEmail(cleaned) ? "✓ Valid" : "✗ Invalid"

    output .= "Original: '" email "'`n"
    output .= "Cleaned: '" cleaned "'`n"
    output .= "Status: " valid "`n`n"
}

MsgBox(output, "Email Validation", "Icon!")

; ============================================================
; Example 6: Clean Phone Numbers
; ============================================================

/**
* Clean and format phone numbers
*/

/**
* Extract digits from phone number
*
* @param {String} phone - Raw phone input
* @returns {String} - Digits only
*/
ExtractPhoneDigits(phone) {
    ; Trim whitespace first
    phone := Trim(phone)

    ; Remove all non-digits
    digits := ""
    Loop Parse, phone {
        if (A_LoopField >= "0" && A_LoopField <= "9")
        digits .= A_LoopField
    }

    return digits
}

/**
* Format phone number as (XXX) XXX-XXXX
*/
FormatPhoneUS(phone) {
    digits := ExtractPhoneDigits(phone)

    ; Need exactly 10 digits for US format
    if (StrLen(digits) != 10)
    return phone  ; Return original if invalid

    ; Format as (XXX) XXX-XXXX
    formatted := "(" SubStr(digits, 1, 3) ") "
    .  SubStr(digits, 4, 3) "-"
    .  SubStr(digits, 7, 4)

    return formatted
}

; Test phone numbers with various formats
testPhones := [
"  555-123-4567  ",
"(555) 123-4567",
"555.123.4567",
"5551234567",
"+1 (555) 123-4567",
"  1-555-123-4567  ",
"555 123 4567",
"invalid phone"
]

output := "PHONE NUMBER CLEANING:`n`n"
for phone in testPhones {
    digits := ExtractPhoneDigits(phone)
    formatted := FormatPhoneUS(phone)

    output .= "Original: '" phone "'`n"
    output .= "Digits: '" digits "' (len: " StrLen(digits) ")`n"
    output .= "Formatted: '" formatted "'`n`n"
}

MsgBox(output, "Phone Number Cleaning", "Icon!")

; ============================================================
; Example 7: Comprehensive Data Sanitization System
; ============================================================

/**
* Complete data sanitization class
*/
class DataSanitizer {
    /**
    * Sanitize general text input
    */
    static Text(input) {
        ; Remove control characters
        input := RegExReplace(input, "[\x00-\x1F\x7F]", "")

        ; Trim whitespace
        input := Trim(input)

        ; Normalize spaces
        while InStr(input, "  ")
        input := StrReplace(input, "  ", " ")

        return input
    }

    /**
    * Sanitize numeric input
    */
    static Number(input) {
        ; Trim and keep only digits and decimal point
        input := Trim(input)

        result := ""
        decimalFound := false

        Loop Parse, input {
            char := A_LoopField

            ; Allow digits
            if (char >= "0" && char <= "9") {
                result .= char
            }
            ; Allow one decimal point
            else if (char = "." && !decimalFound) {
                result .= char
                decimalFound := true
            }
        }

        return result
    }

    /**
    * Sanitize alphanumeric input (letters and numbers only)
    */
    static AlphaNumeric(input) {
        input := Trim(input)

        result := ""
        Loop Parse, input {
            char := A_LoopField

            ; Keep letters, numbers, and spaces
            if (char >= "A" && char <= "Z")
            || (char >= "a" && char <= "z")
            || (char >= "0" && char <= "9")
            || (char = " ") {
                result .= char
            }
        }

        ; Normalize spaces
        while InStr(result, "  ")
        result := StrReplace(result, "  ", " ")

        return Trim(result)
    }

    /**
    * Sanitize for SQL (basic - remove dangerous chars)
    */
    static SQL(input) {
        input := Trim(input)

        ; Remove quotes and dangerous characters
        dangerous := ["'", '"', ";", "--", "/*", "*/", "xp_", "sp_"]

        for char in dangerous {
            input := StrReplace(input, char, "")
        }

        return input
    }

    /**
    * Sanitize URL
    */
    static URL(input) {
        ; Trim and remove spaces
        input := Trim(input)
        input := StrReplace(input, " ", "")

        ; Convert to lowercase
        input := StrLower(input)

        return input
    }
}

; Test the sanitization system
testData := Map(
"Text", "  Hello   World!  `n`t  ",
"Number", "  $1,234.56  ",
"AlphaNum", "  User@123#Name  ",
"SQL", "Robert'; DROP TABLE users--",
"URL", "  HTTPS://Example.COM/Page "
)

output := "COMPREHENSIVE SANITIZATION:`n`n"

output .= "Text Sanitization:`n"
output .= "Input: '" testData["Text"] "'`n"
output .= "Output: '" DataSanitizer.Text(testData["Text"]) "'`n`n"

output .= "Number Sanitization:`n"
output .= "Input: '" testData["Number"] "'`n"
output .= "Output: '" DataSanitizer.Number(testData["Number"]) "'`n`n"

output .= "AlphaNumeric Sanitization:`n"
output .= "Input: '" testData["AlphaNum"] "'`n"
output .= "Output: '" DataSanitizer.AlphaNumeric(testData["AlphaNum"]) "'`n`n"

output .= "SQL Sanitization:`n"
output .= "Input: '" testData["SQL"] "'`n"
output .= "Output: '" DataSanitizer.SQL(testData["SQL"]) "'`n`n"

output .= "URL Sanitization:`n"
output .= "Input: '" testData["URL"] "'`n"
output .= "Output: '" DataSanitizer.URL(testData["URL"]) "'`n`n"

MsgBox(output, "Data Sanitization System", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
DATA CLEANING WITH TRIM FUNCTIONS:

Common Cleaning Operations:
═══════════════════════════════════

1. Form Input:
• Trim(input) - Remove leading/trailing whitespace
• Normalize internal spacing
• Remove control characters

2. Remove Specific Characters:
• Trim(text, chars) - Specify chars to remove
• Common: quotes, brackets, asterisks
• Chain operations for thorough cleaning

3. Filename Sanitization:
• Remove invalid filesystem characters
• Trim dots and spaces from ends
• Ensure proper extension

4. CSV/Delimited Data:
• Trim each field
• Remove surrounding quotes
• Normalize spacing

5. Email Addresses:
• Remove ALL whitespace (not just ends)
• Trim quotes and brackets
• Convert to lowercase
• Validate format

6. Phone Numbers:
• Extract digits only
• Remove formatting characters
• Validate length
• Reformat consistently

Security Considerations:
═══════════════════════════════
⚠ Always sanitize user input
⚠ Remove SQL injection characters
⚠ Validate after cleaning
⚠ Use whitelist approach when possible
⚠ Clean before storage and display

Best Practices:
══════════════════
✓ Clean immediately after input
✓ Validate after cleaning
✓ Document cleaning rules
✓ Test edge cases
✓ Preserve original for logging
✓ Use consistent cleaning methods

Common Patterns:
══════════════════
; Remove quotes and trim
text := Trim(Trim(text, '"'), "'")

; Clean and normalize
text := Trim(text)
while InStr(text, "  ")
text := StrReplace(text, "  ", " ")

; Remove all whitespace
text := StrReplace(StrReplace(text, " ", ""), "`t", "")

; Chain cleaning operations
text := RemoveQuotes(RemoveBrackets(Trim(text)))
)"

MsgBox(info, "Data Cleaning Reference", "Icon!")
