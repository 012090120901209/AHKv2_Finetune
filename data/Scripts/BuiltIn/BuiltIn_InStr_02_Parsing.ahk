#Requires AutoHotkey v2.0

/**
 * BuiltIn_InStr_02_Parsing.ahk
 * 
 * DESCRIPTION:
 * Using InStr() for string parsing and text extraction
 * 
 * FEATURES:
 * - Extract text between delimiters
 * - Parse structured data
 * - Find and replace preparation
 * - Token extraction
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - InStr()
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - InStr() combined with SubStr()
 * - Multiple delimiter handling
 * - Iterative parsing with InStr()
 * - Position-based extraction
 * 
 * LEARNING POINTS:
 * 1. InStr() is essential for parsing
 * 2. Combine with SubStr() for extraction
 * 3. Use in loops for multiple delimiters
 * 4. Handle nested structures carefully
 */

; ============================================================
; Example 1: Extract Text Between Delimiters
; ============================================================

/**
 * Extract text between two delimiters
 * 
 * @param {String} text - Source text
 * @param {String} startDel - Start delimiter
 * @param {String} endDel - End delimiter
 * @returns {String} - Extracted text
 */
ExtractBetween(text, startDel, endDel) {
    startPos := InStr(text, startDel)
    if (startPos = 0)
        return ""

    startPos += StrLen(startDel)

    endPos := InStr(text, endDel, , startPos)
    if (endPos = 0)
        return ""

    return SubStr(text, startPos, endPos - startPos)
}

; Example uses
html := "<div>Hello World</div>"
content := ExtractBetween(html, "<div>", "</div>")

json := '{"name": "John Doe"}'
name := ExtractBetween(json, '"name": "', '"')

MsgBox("HTML: " html "`nExtracted: '" content "'`n`n"
    . "JSON: " json "`nName: '" name "'",
    "Extract Between Delimiters", "Icon!")

; ============================================================
; Example 2: Split String Manually
; ============================================================

/**
 * Split string by delimiter using InStr()
 * 
 * @param {String} text - Text to split
 * @param {String} delimiter - Delimiter
 * @returns {Array} - Array of parts
 */
ManualSplit(text, delimiter) {
    parts := []
    startPos := 1

    Loop {
        pos := InStr(text, delimiter, , startPos)

        if (pos = 0) {
            ; Last part
            if (startPos <= StrLen(text))
                parts.Push(SubStr(text, startPos))
            break
        }

        ; Extract part
        parts.Push(SubStr(text, startPos, pos - startPos))
        startPos := pos + StrLen(delimiter)
    }

    return parts
}

path := "C:\Users\John\Documents\file.txt"
parts := ManualSplit(path, "\")

output := "Path: " path "`n`nParts:`n"
for part in parts
    output .= A_Index ". " part "`n"

MsgBox(output, "Manual Split", "Icon!")

; ============================================================
; Example 3: Parse Key-Value Pairs
; ============================================================

/**
 * Parse key=value format
 */
class KeyValueParser {
    static Parse(text, pairDelimiter := "&", kvDelimiter := "=") {
        data := Map()
        pairs := ManualSplit(text, pairDelimiter)

        for pair in pairs {
            eqPos := InStr(pair, kvDelimiter)
            if (eqPos > 0) {
                key := Trim(SubStr(pair, 1, eqPos - 1))
                value := Trim(SubStr(pair, eqPos + 1))
                data[key] := value
            }
        }

        return data
    }
}

queryString := "name=John&age=30&city=NewYork"
params := KeyValueParser.Parse(queryString)

output := "Query String: " queryString "`n`nParsed:`n"
for key, value in params
    output .= key " = " value "`n"

MsgBox(output, "Key-Value Parser", "Icon!")

; ============================================================
; Example 4: Extract File Extension
; ============================================================

/**
 * Get file extension from filename
 * 
 * @param {String} filename - Filename
 * @returns {String} - Extension without dot
 */
GetExtension(filename) {
    dotPos := InStr(filename, ".", , -1)  ; Last dot

    if (dotPos = 0)
        return ""

    return SubStr(filename, dotPos + 1)
}

/**
 * Get filename without extension
 */
GetFilenameWithoutExt(filename) {
    dotPos := InStr(filename, ".", , -1)

    if (dotPos = 0)
        return filename

    return SubStr(filename, 1, dotPos - 1)
}

files := [
    "document.txt",
    "archive.tar.gz",
    "script.ahk",
    "README"
]

output := "FILE EXTENSIONS:`n`n"
for file in files {
    ext := GetExtension(file)
    name := GetFilenameWithoutExt(file)
    output .= file " → Name: '" name "', Ext: '" ext "'`n"
}

MsgBox(output, "Extension Extraction", "Icon!")

; ============================================================
; Example 5: Count Substring Occurrences
; ============================================================

/**
 * Count how many times substring appears
 * 
 * @param {String} text - Text to search
 * @param {String} substring - Substring to count
 * @returns {Integer} - Count
 */
CountOccurrences(text, substring) {
    count := 0
    startPos := 1

    Loop {
        pos := InStr(text, substring, , startPos)
        if (pos = 0)
            break

        count++
        startPos := pos + 1
    }

    return count
}

text := "How much wood would a woodchuck chuck if a woodchuck could chuck wood?"

countWood := CountOccurrences(text, "wood")
countChuck := CountOccurrences(text, "chuck")
countThe := CountOccurrences(text, "the")

MsgBox("Text: " text "`n`n"
    . "'wood' appears: " countWood " times`n"
    . "'chuck' appears: " countChuck " times`n"
    . "'the' appears: " countThe " times",
    "Count Occurrences", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
PARSING WITH INSTR():

Common Patterns:

1. Extract Between:
start := InStr(text, startMarker)
end := InStr(text, endMarker, , start)
result := SubStr(text, start + len, end - start - len)

2. Split String:
pos := InStr(text, delimiter)
part1 := SubStr(text, 1, pos - 1)
part2 := SubStr(text, pos + StrLen(delimiter))

3. Count Occurrences:
count := 0, pos := 1
while (pos := InStr(text, needle, , pos))
count++, pos++

4. Find Last Occurrence:
pos := InStr(text, needle, , -1)

Best Practices:
• Check return value (0 = not found)
• Account for delimiter length
• Use Trim() on extracted parts
• Handle edge cases (empty, not found)

Common Applications:
✓ URL parsing
✓ CSV/TSV parsing
✓ Configuration file reading
✓ Log file analysis
✓ Data extraction
)"

MsgBox(info, "InStr() Parsing Reference", "Icon!")
