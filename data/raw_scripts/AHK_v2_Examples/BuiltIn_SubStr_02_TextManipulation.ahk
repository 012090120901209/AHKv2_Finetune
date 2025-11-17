#Requires AutoHotkey v2.0
/**
 * BuiltIn_SubStr_02_TextManipulation.ahk
 *
 * DESCRIPTION:
 * Advanced text manipulation using SubStr() for parsing and transformation
 *
 * FEATURES:
 * - Parse structured data
 * - Extract tokens and fields
 * - String transformation
 * - Data cleaning and formatting
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - SubStr()
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - SubStr() with InStr() for parsing
 * - Loop Parse with SubStr()
 * - String slicing techniques
 * - Class-based parsers
 *
 * LEARNING POINTS:
 * 1. Combine SubStr() with InStr() for flexible parsing
 * 2. Use in loops for multi-part extraction
 * 3. Negative indexing simplifies end-based operations
 * 4. Essential for fixed-width format parsing
 */

; ============================================================
; Example 1: Parse CSV-like Data
; ============================================================

/**
 * Parse simple CSV row using SubStr()
 *
 * @param {String} row - CSV row
 * @param {String} delimiter - Field delimiter
 * @returns {Array} - Array of fields
 */
ParseCSV(row, delimiter := ",") {
    fields := []
    remaining := row

    Loop {
        pos := InStr(remaining, delimiter)

        if (pos = 0) {
            ; Last field
            if (StrLen(remaining) > 0)
                fields.Push(Trim(remaining))
            break
        }

        ; Extract field
        field := SubStr(remaining, 1, pos - 1)
        fields.Push(Trim(field))

        ; Remove processed part
        remaining := SubStr(remaining, pos + 1)
    }

    return fields
}

csvData := "John Doe,30,New York,Engineer"
fields := ParseCSV(csvData)

output := "CSV: '" csvData "'`n`n"
output .= "Parsed Fields:`n"
output .= "1. Name: " fields[1] "`n"
output .= "2. Age: " fields[2] "`n"
output .= "3. City: " fields[3] "`n"
output .= "4. Job: " fields[4]

MsgBox(output, "CSV Parsing", "Icon!")

; ============================================================
; Example 2: Fixed-Width Format Parser
; ============================================================

/**
 * Parse fixed-width format data
 */
class FixedWidthParser {
    /**
     * Parse line according to field definitions
     *
     * @param {String} line - Data line
     * @param {Array} fieldDefs - Field definitions [{start, length, name}]
     * @returns {Map} - Parsed data
     */
    static Parse(line, fieldDefs) {
        data := Map()

        for def in fieldDefs {
            value := SubStr(line, def.start, def.length)
            data[def.name] := Trim(value)
        }

        return data
    }
}

; Example: Parse bank statement line
; Format: Date(10) | Description(30) | Amount(12)
fieldDefinitions := [
    {start: 1, length: 10, name: "date"},
    {start: 11, length: 30, name: "description"},
    {start: 41, length: 12, name: "amount"}
]

statementLine := "2024-11-16Payment to Electric Company     -125.50"

parsed := FixedWidthParser.Parse(statementLine, fieldDefinitions)

MsgBox("Fixed-Width Line:`n'" statementLine "'`n`n"
     . "Parsed Data:`n"
     . "Date: " parsed["date"] "`n"
     . "Description: " parsed["description"] "`n"
     . "Amount: " parsed["amount"],
     "Fixed-Width Parsing", "Icon!")

; ============================================================
; Example 3: URL Parser
; ============================================================

/**
 * Parse URL components
 */
class URLParser {
    static Parse(url) {
        components := Map()
        remaining := url

        ; Extract protocol
        protocolEnd := InStr(remaining, "://")
        if (protocolEnd > 0) {
            components["protocol"] := SubStr(remaining, 1, protocolEnd - 1)
            remaining := SubStr(remaining, protocolEnd + 3)
        }

        ; Extract domain and path
        pathStart := InStr(remaining, "/")
        if (pathStart > 0) {
            components["domain"] := SubStr(remaining, 1, pathStart - 1)
            components["path"] := SubStr(remaining, pathStart)
        } else {
            components["domain"] := remaining
            components["path"] := "/"
        }

        ; Extract query string if present
        queryStart := InStr(components["path"], "?")
        if (queryStart > 0) {
            components["query"] := SubStr(components["path"], queryStart + 1)
            components["path"] := SubStr(components["path"], 1, queryStart - 1)
        }

        ; Extract fragment
        if (components.Has("query")) {
            fragmentStart := InStr(components["query"], "#")
            if (fragmentStart > 0) {
                components["fragment"] := SubStr(components["query"], fragmentStart + 1)
                components["query"] := SubStr(components["query"], 1, fragmentStart - 1)
            }
        }

        return components
    }
}

testURL := "https://www.example.com/path/to/page?id=123&name=test#section"
urlParts := URLParser.Parse(testURL)

output := "URL: " testURL "`n`n"
output .= "Components:`n"
for key, value in urlParts
    output .= key ": " value "`n"

MsgBox(output, "URL Parsing", "Icon!")

; ============================================================
; Example 4: Extract Email Parts
; ============================================================

/**
 * Parse email address into components
 *
 * @param {String} email - Email address
 * @returns {Map} - Email components
 */
ParseEmail(email) {
    parts := Map()

    ; Find @ symbol
    atPos := InStr(email, "@")
    if (atPos = 0)
        return parts

    ; Extract username and domain
    parts["username"] := SubStr(email, 1, atPos - 1)
    parts["domain"] := SubStr(email, atPos + 1)

    ; Extract domain parts
    dotPos := InStr(parts["domain"], ".", , -1)  ; Last dot
    if (dotPos > 0) {
        parts["domainName"] := SubStr(parts["domain"], 1, dotPos - 1)
        parts["tld"] := SubStr(parts["domain"], dotPos + 1)
    }

    return parts
}

emails := [
    "john.doe@example.com",
    "admin@mail.company.co.uk",
    "support@service.io"
]

output := "EMAIL PARSING:`n`n"
for email in emails {
    parts := ParseEmail(email)
    output .= "Email: " email "`n"
    output .= "  Username: " parts["username"] "`n"
    output .= "  Domain: " parts["domain"] "`n"
    if (parts.Has("tld"))
        output .= "  TLD: " parts["tld"] "`n"
    output .= "`n"
}

MsgBox(output, "Email Parsing", "Icon!")

; ============================================================
; Example 5: Remove Prefix/Suffix
; ============================================================

/**
 * Remove prefix from string
 *
 * @param {String} text - Original text
 * @param {String} prefix - Prefix to remove
 * @returns {String} - Text without prefix
 */
RemovePrefix(text, prefix) {
    prefixLen := StrLen(prefix)

    if (SubStr(text, 1, prefixLen) = prefix)
        return SubStr(text, prefixLen + 1)

    return text
}

/**
 * Remove suffix from string
 *
 * @param {String} text - Original text
 * @param {String} suffix - Suffix to remove
 * @returns {String} - Text without suffix
 */
RemoveSuffix(text, suffix) {
    suffixLen := StrLen(suffix)

    if (SubStr(text, -suffixLen + 1) = suffix)
        return SubStr(text, 1, StrLen(text) - suffixLen)

    return text
}

filename := "document.txt"
noExtension := RemoveSuffix(filename, ".txt")

prefixedText := "Mr. John Smith"
noPrefix := RemovePrefix(prefixedText, "Mr. ")

MsgBox("Suffix Removal:`n"
     . "Original: '" filename "'`n"
     . "Without .txt: '" noExtension "'`n`n"
     . "Prefix Removal:`n"
     . "Original: '" prefixedText "'`n"
     . "Without 'Mr. ': '" noPrefix "'",
     "Remove Prefix/Suffix", "Icon!")

; ============================================================
; Example 6: Extract Quoted Text
; ============================================================

/**
 * Extract text between quotes
 *
 * @param {String} text - Text containing quotes
 * @returns {String} - Quoted text or empty
 */
ExtractQuoted(text) {
    firstQuote := InStr(text, '"')
    if (firstQuote = 0)
        return ""

    ; Find closing quote
    secondQuote := InStr(text, '"', , firstQuote + 1)
    if (secondQuote = 0)
        return ""

    ; Extract between quotes
    return SubStr(text, firstQuote + 1, secondQuote - firstQuote - 1)
}

examples := [
    'He said "Hello World" to everyone',
    'The book title is "AutoHotkey Guide"',
    'Error: "File not found"'
]

output := "EXTRACT QUOTED TEXT:`n`n"
for text in examples {
    quoted := ExtractQuoted(text)
    output .= "Original: " text "`n"
    output .= "Quoted: '" quoted "'`n`n"
}

MsgBox(output, "Quote Extraction", "Icon!")

; ============================================================
; Example 7: Version Number Parser
; ============================================================

/**
 * Parse version number (major.minor.patch)
 *
 * @param {String} version - Version string
 * @returns {Map} - Version components
 */
ParseVersion(version) {
    parts := Map(
        "major", 0,
        "minor", 0,
        "patch", 0
    )

    ; Find first dot
    firstDot := InStr(version, ".")
    if (firstDot = 0)
        return parts

    parts["major"] := SubStr(version, 1, firstDot - 1)

    ; Find second dot
    secondDot := InStr(version, ".", , firstDot + 1)
    if (secondDot = 0) {
        parts["minor"] := SubStr(version, firstDot + 1)
        return parts
    }

    parts["minor"] := SubStr(version, firstDot + 1, secondDot - firstDot - 1)
    parts["patch"] := SubStr(version, secondDot + 1)

    return parts
}

versions := ["2.0", "2.0.15", "1.2.3"]

output := "VERSION PARSING:`n`n"
for ver in versions {
    parts := ParseVersion(ver)
    output .= ver ": "
    output .= "Major=" parts["major"]
    output .= ", Minor=" parts["minor"]
    output .= ", Patch=" parts["patch"] "`n"
}

MsgBox(output, "Version Parsing", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
ADVANCED SUBSTR() TECHNIQUES:

Parsing Patterns:
1. Find-and-Extract:
   pos := InStr(text, delimiter)
   part := SubStr(text, 1, pos - 1)
   remaining := SubStr(text, pos + 1)

2. Remove Prefix:
   if (SubStr(text, 1, len) = prefix)
       text := SubStr(text, len + 1)

3. Remove Suffix:
   if (SubStr(text, -len + 1) = suffix)
       text := SubStr(text, 1, StrLen(text) - len)

4. Extract Between Markers:
   start := InStr(text, startMarker)
   end := InStr(text, endMarker, , start)
   result := SubStr(text, start + len, end - start - len)

Best Practices:
• Validate positions before extracting
• Handle edge cases (empty strings, not found)
• Combine with Trim() for clean results
• Use negative positions for end-relative operations
• Cache string lengths in loops

Common Applications:
✓ CSV/TSV parsing
✓ Fixed-width format reading
✓ URL/email parsing
✓ Token extraction
✓ Data cleaning
✓ Format conversion
)"

MsgBox(info, "Advanced SubStr() Reference", "Icon!")
