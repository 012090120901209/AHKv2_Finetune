#Requires AutoHotkey v2.0

/**
 * BuiltIn_StrSplit_01_BasicUsage.ahk
 * 
 * DESCRIPTION:
 * Basic usage examples of StrSplit() function for splitting strings into arrays
 * 
 * FEATURES:
 * - Split strings by single character delimiters
 * - Split by comma, space, tab, and custom delimiters
 * - Handle empty elements in results
 * - Traverse and process split arrays
 * - Remove empty elements from results
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/StrSplit.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - StrSplit() function with various delimiters
 * - Array iteration with for loops
 * - Array.Length property
 * - Array element access
 * - OmitChars parameter usage
 * 
 * LEARNING POINTS:
 * 1. StrSplit() returns an Array object in v2
 * 2. First parameter is the string to split
 * 3. Second parameter is the delimiter(s)
 * 4. Third parameter can omit characters from results
 * 5. Empty elements are included by default
 * 6. Multiple delimiters can be specified
 * 7. Arrays are 1-indexed in AutoHotkey v2
 */

; ============================================================
; Example 1: Basic Comma-Separated Split
; ============================================================

/**
 * Demonstrates basic comma-separated string splitting
 */
csvData := "Apple,Banana,Cherry,Date,Elderberry"
fruits := StrSplit(csvData, ",")

output := "Original String:`n" csvData "`n`n"
output .= "Split into " fruits.Length " elements:`n`n"

for index, fruit in fruits {
    output .= index ". " fruit "`n"
}

MsgBox(output, "Basic Comma Split", "Icon!")

; ============================================================
; Example 2: Space-Separated Split
; ============================================================

/**
 * Split a sentence into words using space delimiter
 */
sentence := "The quick brown fox jumps over the lazy dog"
words := StrSplit(sentence, " ")

output := "Original Sentence:`n'" sentence "'`n`n"
output .= "Word Count: " words.Length "`n`n"
output .= "Words:`n"

for index, word in words {
    output .= index ". " word " (" StrLen(word) " chars)`n"
}

MsgBox(output, "Space-Separated Words", "Icon!")

; ============================================================
; Example 3: Tab-Separated Values (TSV)
; ============================================================

/**
 * Parse tab-separated data (common in spreadsheet exports)
 */
tsvLine := "ID`tName`tAge`tCity"  ; Using `t for tab
columns := StrSplit(tsvLine, "`t")

output := "TSV Data:`n" StrReplace(tsvLine, "`t", " | ") "`n`n"
output .= "Columns:`n"

for index, column in columns {
    output .= "Column " index ": " column "`n"
}

; Parse a data row
dataRow := "101`tJohn Smith`t35`tNew York"
dataFields := StrSplit(dataRow, "`t")

output .= "`nData Row:`n"
for index, field in dataFields {
    output .= columns[index] ": " field "`n"
}

MsgBox(output, "Tab-Separated Values", "Icon!")

; ============================================================
; Example 4: Multiple Delimiters
; ============================================================

/**
 * Split using multiple delimiter characters
 * Any character in the delimiter string will split the text
 */
mixedData := "apple,banana;cherry:date|elderberry"
items := StrSplit(mixedData, ",;:|")  ; Split on comma, semicolon, colon, or pipe

output := "Original Data:`n" mixedData "`n`n"
output .= "Used delimiters: , ; : |`n`n"
output .= "Results (" items.Length " items):`n"

for index, item in items {
    output .= index ". " item "`n"
}

MsgBox(output, "Multiple Delimiters", "Icon!")

; ============================================================
; Example 5: Handling Empty Elements
; ============================================================

/**
 * Demonstrates how StrSplit handles consecutive delimiters
 * Empty elements are preserved in the array
 */
dataWithEmpties := "apple,,banana,,,cherry"
result := StrSplit(dataWithEmpties, ",")

output := "Original: " dataWithEmpties "`n`n"
output .= "Array Length: " result.Length "`n`n"
output .= "Elements (empty shown as ''):`n"

for index, item in result {
    if (item = "")
        output .= index ". (empty)`n"
    else
        output .= index ". '" item "'`n"
}

; Count non-empty elements
nonEmptyCount := 0
for item in result {
    if (item != "")
        nonEmptyCount++
}

output .= "`nNon-empty items: " nonEmptyCount

MsgBox(output, "Empty Elements", "Icon!")

; ============================================================
; Example 6: Remove Empty Elements with OmitChars
; ============================================================

/**
 * Remove unwanted characters and empty elements
 * Third parameter removes specified characters from results
 * 
 * @example StrSplit(string, delimiters, omitChars)
 */
RemoveEmptyElements(array) {
    result := []
    for item in array {
        if (item != "")
            result.Push(item)
    }
    return result
}

messyData := "  apple  ,  banana  ,  ,  cherry  ,  "
rawSplit := StrSplit(messyData, ",")
cleanSplit := StrSplit(messyData, ",", " ")  ; Omit spaces

output := "Original:`n'" messyData "'`n`n"

output .= "Raw Split (" rawSplit.Length " elements):`n"
for index, item in rawSplit {
    output .= index ". '" item "'`n"
}

output .= "`nWith OmitChars=' ' (" cleanSplit.Length " elements):`n"
for index, item in cleanSplit {
    if (item = "")
        output .= index ". (empty)`n"
    else
        output .= index ". '" item "'`n"
}

; Further cleanup: remove empty elements
filtered := RemoveEmptyElements(cleanSplit)
output .= "`nFiltered (" filtered.Length " elements):`n"
for index, item in filtered {
    output .= index ". '" item "'`n"
}

MsgBox(output, "Removing Unwanted Characters", "Icon!")

; ============================================================
; Example 7: Split Every Character
; ============================================================

/**
 * Split string into individual characters
 * Use empty string as delimiter
 */
text := "Hello"
characters := StrSplit(text)  ; Empty delimiter = split each character

output := "Original Text: '" text "'`n`n"
output .= "Individual Characters:`n"

for index, char in characters {
    output .= "Position " index ": '" char "'`n"
}

; Reverse a string using character split
reversed := ""
Loop characters.Length {
    reversed .= characters[characters.Length - A_Index + 1]
}

output .= "`nReversed: '" reversed "'"

MsgBox(output, "Character Split", "Icon!")

; ============================================================
; Example 8: Practical Use - Email Validator
; ============================================================

/**
 * Validate and parse email addresses
 * 
 * @param {String} email - Email address to validate
 * @returns {Object} - Map with validation results
 */
ParseEmail(email) {
    result := Map()
    result["valid"] := false
    result["username"] := ""
    result["domain"] := ""
    result["tld"] := ""

    ; Check for @ symbol
    parts := StrSplit(email, "@")
    if (parts.Length != 2) {
        result["error"] := "Invalid format: must contain exactly one @"
        return result
    }

    username := parts[1]
    domain := parts[2]

    ; Validate username
    if (StrLen(username) = 0) {
        result["error"] := "Username cannot be empty"
        return result
    }

    ; Parse domain
    domainParts := StrSplit(domain, ".")
    if (domainParts.Length < 2) {
        result["error"] := "Domain must have at least one dot"
        return result
    }

    result["valid"] := true
    result["username"] := username
    result["domain"] := domain
    result["tld"] := domainParts[domainParts.Length]

    return result
}

; Test email addresses
testEmails := [
    "john.doe@example.com",
    "invalid.email",
    "@example.com",
    "user@domain",
    "contact@company.co.uk"
]

output := "EMAIL VALIDATION:`n`n"
for email in testEmails {
    info := ParseEmail(email)
    output .= "Email: " email "`n"

    if (info["valid"]) {
        output .= "  ✓ Valid`n"
        output .= "  Username: " info["username"] "`n"
        output .= "  Domain: " info["domain"] "`n"
        output .= "  TLD: " info["tld"] "`n"
    } else {
        output .= "  ✗ Invalid`n"
        output .= "  Error: " info["error"] "`n"
    }
    output .= "`n"
}

MsgBox(output, "Email Parser", "Icon!")

; ============================================================
; Example 9: Join Array Back Together
; ============================================================

/**
 * Join array elements back into a string
 * (Reverse of StrSplit)
 * 
 * @param {Array} array - Array to join
 * @param {String} separator - Separator to use
 * @returns {String} - Joined string
 */
JoinArray(array, separator := ",") {
    result := ""
    for index, item in array {
        result .= item
        if (index < array.Length)
            result .= separator
    }
    return result
}

; Original string
original := "Red,Green,Blue,Yellow,Purple"
colors := StrSplit(original, ",")

; Join with different separators
commaJoined := JoinArray(colors, ", ")
pipeJoined := JoinArray(colors, " | ")
dashJoined := JoinArray(colors, " - ")
spaceJoined := JoinArray(colors, " ")

output := "Original:`n" original "`n`n"
output .= "Split into " colors.Length " elements`n`n"
output .= "Rejoined with different separators:`n`n"
output .= "Comma-space: " commaJoined "`n"
output .= "Pipe: " pipeJoined "`n"
output .= "Dash: " dashJoined "`n"
output .= "Space: " spaceJoined

MsgBox(output, "Array Join", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
STRSPLIT() FUNCTION REFERENCE:

Syntax:
Array := StrSplit(String, Delimiters, OmitChars, MaxParts)

Parameters:
String     - The string to split
Delimiters - One or more delimiter characters (optional)
Empty = split every character
OmitChars  - Characters to remove from results (optional)
MaxParts   - Maximum number of parts to return (optional)

Return Value:
Array - Array object containing the parts

Key Points:
• Returns an Array object (v2 feature)
• Arrays are 1-indexed in AutoHotkey
• Empty elements are preserved
• Multiple delimiters can be specified
• OmitChars removes characters from results
• No delimiter = split every character
• Use .Length property to get array size

Common Use Cases:
✓ Parse CSV/TSV data
✓ Split sentences into words
✓ Parse configuration values
✓ Break down file paths
✓ Process command-line arguments
✓ Extract data from formatted text

Best Practices:
• Check array length before accessing
• Handle empty elements appropriately
• Use OmitChars to clean whitespace
• Combine with Trim() for cleaner results
• Use for loops to iterate arrays
• Remember: arrays start at index 1

Examples of Delimiters:
","      - Comma
" "      - Space
"`t"     - Tab
"`n"     - Newline
",;:"    - Multiple delimiters
""       - Split every character
)"

MsgBox(info, "StrSplit() Reference", "Icon!")
