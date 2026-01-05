#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * String Handling - Parsing and Formatting
 * 
 * Demonstrates common string operations: parsing, formatting,
 * extraction, transformation, and validation.
 * 
 * Source: AHK_Notes/Concepts/string-handling-in-ahk-v2.md
 */

; Test 1: String concatenation
firstName := "John"
lastName := "Doe"
fullName := firstName " " lastName  ; Implicit concatenation

MsgBox("Concatenation:`n`n"
    . "First: " firstName "`n"
    . "Last: " lastName "`n"
    . "Full: " fullName, , "T3")

; Test 2: String parsing
csvLine := "Alice,30,Engineer,New York"
parts := ParseCSV(csvLine)

MsgBox("CSV Parsing:`n`n"
    . "Input: " csvLine "`n`n"
    . "Name: " parts[1] "`n"
    . "Age: " parts[2] "`n"
    . "Job: " parts[3] "`n"
    . "City: " parts[4], , "T3")

; Test 3: Email extraction with RegEx
text := "Contact us at support@example.com or sales@company.org for help."
emails := ExtractEmails(text)

MsgBox("Email Extraction:`n`n"
    . "Found " emails.Length " emails:`n"
    . emails.Join("`n"), , "T3")

; Test 4: String formatting
template := "Hello {name}, you have {count} new messages."
formatted := FormatString(template, Map("name", "Alice", "count", 5))

MsgBox("String Formatting:`n`n"
    . "Template: " template "`n`n"
    . "Result: " formatted, , "T3")

; Test 5: Case transformation and manipulation
original := "  Hello World!  "
MsgBox("String Manipulation:`n`n"
    . "Original: '" original "'`n"
    . "Trim: '" Trim(original) "'`n"
    . "Upper: '" StrUpper(original) "'`n"
    . "Lower: '" StrLower(original) "'`n"
    . "Length: " StrLen(original) "`n"
    . "Reverse: '" ReverseString(Trim(original)) "'", , "T5")

/**
 * ParseCSV - Split CSV line into array
 * @param {string} line - CSV line to parse
 * @return {array} Array of values
 */
ParseCSV(line) {
    parts := []
    Loop Parse, line, "," {
        parts.Push(Trim(A_LoopField))
    }
    return parts
}

/**
 * ExtractEmails - Find all email addresses in text
 * @param {string} text - Text to search
 * @return {array} Array of email addresses
 */
ExtractEmails(text) {
    emails := []
    pattern := "i)[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}"

    pos := 1
    while (pos := RegExMatch(text, pattern, &match, pos)) {
        emails.Push(match[0])
        pos += StrLen(match[0])
    }

    return emails
}

/**
 * FormatString - Replace {key} with values from map
 * @param {string} template - Template string with {placeholders}
 * @param {map} values - Map of placeholder values
 * @return {string} Formatted string
 */
FormatString(template, values) {
    result := template

    for key, value in values {
        placeholder := "{" key "}"
        result := StrReplace(result, placeholder, value)
    }

    return result
}

/**
 * ReverseString - Reverse a string
 * @param {string} str - String to reverse
 * @return {string} Reversed string
 */
ReverseString(str) {
    reversed := ""
    Loop Parse, str
        reversed := A_LoopField reversed
    return reversed
}

/**
 * WordCount - Count words in text
 * @param {string} text - Text to analyze
 * @return {int} Word count
 */
WordCount(text) {
    count := 0
    Loop Parse, text, " `t`n`r"
        if (StrLen(Trim(A_LoopField)) > 0)
            count++
    return count
}

/*
* Key Concepts:
*
* 1. String Concatenation:
*    str1 := "Hello" " " "World"  ; Implicit
*    str2 := var1 " " var2        ; Variables adjacent
*    str3 := "Text: " value       ; Mixed
*
* 2. Loop Parse:
*    Loop Parse, string, delimiter {
    *        A_LoopField  ; Current element
    *    }
    *    Split string into parts
    *
    * 3. RegEx Operations:
    *    RegExMatch(text, pattern, &match, startPos)
    *    RegExReplace(text, pattern, replacement)
    *    Powerful pattern matching
    *
    * 4. String Functions:
    *    StrLen(str)           ; Length
    *    StrUpper/StrLower()   ; Case conversion
    *    SubStr(str, pos, len) ; Extract substring
    *    InStr(str, needle)    ; Find position
    *    StrReplace()          ; Replace text
    *    Trim()                ; Remove whitespace
    *
    * 5. Escape Sequences:
    *    `n  ; Newline
    *    `t  ; Tab
    *    `r  ; Carriage return
    *    ``  ; Literal backtick
    *
    * 6. Template Strings:
    *    "Hello {name}, you have {count} messages"
    *    StrReplace with placeholders
    *    Simple string formatting
    *
    * 7. Common Patterns:
    *    ✅ CSV parsing (Loop Parse with comma)
    *    ✅ Email extraction (RegEx)
    *    ✅ String templating (StrReplace)
    *    ✅ Case transformation
    *    ✅ Whitespace handling
    *
    * 8. Performance Tips:
    *    ⚠ Avoid string concatenation in loops
    *    ⚠ Use array.Join() for multiple parts
    *    ✅ RegEx is fast for complex patterns
    *    ✅ Loop Parse is efficient for splitting
*/
