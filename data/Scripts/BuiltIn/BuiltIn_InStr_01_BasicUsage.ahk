#Requires AutoHotkey v2.0

/**
 * BuiltIn_InStr_01_BasicUsage.ahk
 * 
 * DESCRIPTION:
 * Basic usage of InStr() to find substring positions
 * 
 * FEATURES:
 * - Find position of substring in string
 * - Case-sensitive and case-insensitive searching
 * - Find nth occurrence
 * - Search from right to left
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/InStr.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - InStr() function syntax
 * - CaseSense parameter
 * - Occurrence parameter
 * - StartingPos parameter
 * 
 * LEARNING POINTS:
 * 1. InStr() returns position of first character of match
 * 2. Returns 0 if not found
 * 3. Position counting starts at 1
 * 4. Can search case-sensitively or insensitively
 * 5. Can find nth occurrence or search backwards
 */

; ============================================================
; Example 1: Basic String Search
; ============================================================

text := "Hello, World! Welcome to AutoHotkey"

; Find "World"
pos := InStr(text, "World")

if (pos > 0) {
    MsgBox("Text: '" text "'`n`n"
        . "Searching for: 'World'`n"
        . "Found at position: " pos "`n"
        . "Character at that position: '" SubStr(text, pos, 5) "'",
        "Basic InStr()", "Icon!")
} else {
    MsgBox("Not found", "Basic InStr()", "Icon!")
}

; ============================================================
; Example 2: Case-Sensitive vs Case-Insensitive
; ============================================================

text := "AutoHotkey is AWESOME"

; Case-insensitive search (default)
pos1 := InStr(text, "awesome")

; Case-sensitive search
pos2 := InStr(text, "awesome", true)

MsgBox("Text: '" text "'`n`n"
    . "Search for 'awesome' (case-insensitive):`n"
    . "Position: " pos1 " (found: " (pos1 > 0 ? "Yes" : "No") ")`n`n"
    . "Search for 'awesome' (case-sensitive):`n"
    . "Position: " pos2 " (found: " (pos2 > 0 ? "Yes" : "No") ")",
    "Case Sensitivity", "Icon!")

; ============================================================
; Example 3: Not Found (Returns 0)
; ============================================================

text := "The quick brown fox"

search1 := "fox"
search2 := "cat"

pos1 := InStr(text, search1)
pos2 := InStr(text, search2)

MsgBox("Text: '" text "'`n`n"
    . "'" search1 "' found: " (pos1 ? "Yes (pos " pos1 ")" : "No (0)") "`n"
    . "'" search2 "' found: " (pos2 ? "Yes (pos " pos2 ")" : "No (0)") "`n`n"
    . "InStr() returns 0 when substring not found",
    "Not Found Example", "Icon!")

; ============================================================
; Example 4: Find Nth Occurrence
; ============================================================

text := "the cat and the dog and the bird"

; Find first "the"
first := InStr(text, "the")

; Find second "the"
second := InStr(text, "the", , , 2)

; Find third "the"
third := InStr(text, "the", , , 3)

MsgBox("Text: '" text "'`n`n"
    . "1st 'the' at position: " first "`n"
    . "2nd 'the' at position: " second "`n"
    . "3rd 'the' at position: " third,
    "Multiple Occurrences", "Icon!")

; ============================================================
; Example 5: Search from Specific Position
; ============================================================

text := "apple banana apple cherry apple"

; Find first "apple"
first := InStr(text, "apple")

; Find "apple" starting from position 10
second := InStr(text, "apple", , 10)

; Find "apple" starting from position 20
third := InStr(text, "apple", , 20)

MsgBox("Text: '" text "'`n`n"
    . "First 'apple': position " first "`n"
    . "'apple' from pos 10: position " second "`n"
    . "'apple' from pos 20: position " third,
    "Starting Position", "Icon!")

; ============================================================
; Example 6: Search from Right (Backwards)
; ============================================================

filePath := "C:\Users\John\Documents\report.pdf"

; Find last backslash (search backwards)
lastSlash := InStr(filePath, "\", , -1)

; Extract filename
filename := SubStr(filePath, lastSlash + 1)

MsgBox("Path: '" filePath "'`n`n"
    . "Last backslash at: position " lastSlash "`n"
    . "Filename: '" filename "'",
    "Backward Search", "Icon!")
    ; ============================================================
    ; Example 7: Check if String Contains Substring
    ; ============================================================

    /**
     * Check if text contains substring
     * 
     * @param {String} text - Text to search
     * @param {String} substring - Substring to find
     * @returns {Boolean} - True if found
     */
    Contains (text, substring) {
    return InStr(text, substring) > 0
}

email := "user@example.com"

hasAt := Contains (email, "@")
hasDot := Contains (email, ".")
hasSpace := Contains (email, " ")

MsgBox("Email: '" email "'`n`n"
    . "Contains '@': " (hasAt ? "Yes" : "No") "`n"
    . "Contains '.': " (hasDot ? "Yes" : "No") "`n"
    . "Contains space: " (hasSpace ? "Yes" : "No"),
    "Contains Check", "Icon!")

; ============================================================
; Example 8: Find All Occurrences
; ============================================================

/**
 * Find all positions of substring
 * 
 * @param {String} text - Text to search
 * @param {String} substring - Substring to find
 * @returns {Array} - Array of positions
 */
FindAllOccurrences(text, substring) {
    positions := []
    startPos := 1

    Loop {
        pos := InStr(text, substring, , startPos)
        if (pos = 0)
            break

        positions.Push(pos)
        startPos := pos + 1
    }

    return positions
}

text := "She sells sea shells by the sea shore"
positions := FindAllOccurrences(text, "se")

output := "Text: '" text "'`n"
    . "Searching for: 'se'`n`n"
    . "Found at positions: "

for pos in positions
    output .= pos (A_Index < positions.Length ? ", " : "")

MsgBox(output, "Find All Occurrences", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
INSTR() FUNCTION REFERENCE:

Syntax:
FoundPos := InStr(Haystack, Needle, CaseSense?, StartingPos?, Occurrence?)

Parameters:
Haystack - The string to search in
Needle - The substring to search for
CaseSense - true/false (default: false)
StartingPos - Where to start (default: 1)
Positive: Search left to right
Negative: Search right to left
Occurrence - Which occurrence to find (default: 1)

Return Value:
Integer - Position where Needle starts (1-based)
0 - If Needle not found

Examples:
InStr("Hello World", "World")        → 7
InStr("Hello", "HELLO", true)        → 0 (case-sensitive)
InStr("Hello", "HELLO", false)       → 1 (case-insensitive)
InStr("a-b-c-d", "-", , , 2)        → 4 (2nd occurrence)
InStr("C:\Dir\File.txt", "\", , -1) → 7 (last backslash)

Common Use Cases:
✓ Check if substring exists
✓ Find character/delimiter position
✓ Extract text before/after marker
✓ Validate string format
✓ Parse structured data
✓ Split strings manually
)"

MsgBox(info, "InStr() Reference", "Icon!")
