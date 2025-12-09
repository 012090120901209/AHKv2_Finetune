#Requires AutoHotkey v2.0

/**
* BuiltIn_RegEx_Match_01_BasicUsage.ahk
*
* DESCRIPTION:
* Demonstrates basic RegExMatch usage including finding patterns, extracting text,
* and understanding return values. This file covers fundamental regex matching
* operations that form the foundation for more advanced pattern matching.
*
* FEATURES:
* - Basic pattern matching with RegExMatch
* - Understanding return values and positions
* - Simple pattern syntax
* - Case-sensitive and case-insensitive matching
* - Finding multiple matches
* - Working with Match objects
* - Basic validation patterns
*
* SOURCE:
* AutoHotkey v2 Documentation - RegEx
*
* KEY V2 FEATURES DEMONSTRATED:
* - RegExMatch function with v2 syntax
* - Match object properties (Pos, Len, Count)
* - Array-like access to Match object
* - Modern error handling with try/catch
* - String interpolation in messages
*
* LEARNING POINTS:
* 1. RegExMatch returns the position (1-based) of the first match, or 0 if no match
* 2. The optional OutputVar receives a Match object with details
* 3. Match[0] contains the entire matched text
* 4. Match.Pos contains the starting position of the match
* 5. Match.Len contains the length of the matched text
* 6. Case sensitivity can be controlled with the 'i' option
* 7. The third parameter specifies where to start searching
*/

; ========================================
; EXAMPLE 1: Basic Pattern Matching
; ========================================
; Finding if a pattern exists in text
Example1_BasicMatching() {
    MsgBox "EXAMPLE 1: Basic Pattern Matching`n" .
    "===================================="

    ; Simple word matching
    text := "The quick brown fox jumps over the lazy dog"

    ; Find the word "fox"
    pos := RegExMatch(text, "fox")
    if pos
    MsgBox "Found 'fox' at position " . pos . "`n" .
    "Text: " . text

    ; Find a word that doesn't exist
    pos := RegExMatch(text, "cat")
    if !pos
    MsgBox "'cat' not found in text (returns 0)"

    ; Case-sensitive search (default)
    text2 := "Hello World HELLO world"
    pos1 := RegExMatch(text2, "Hello")  ; Finds first "Hello"
    pos2 := RegExMatch(text2, "HELLO")  ; Finds "HELLO"
    pos3 := RegExMatch(text2, "hello")  ; Not found (case-sensitive)

    MsgBox "Case-Sensitive Matching:`n" .
    "Text: " . text2 . "`n`n" .
    "'Hello' found at position: " . pos1 . "`n" .
    "'HELLO' found at position: " . pos2 . "`n" .
    "'hello' found at position: " . pos3 . " (not found)"

    ; Using literal text patterns
    text3 := "Price: $19.99 or €15.50"
    if RegExMatch(text3, "$")  ; $ has special meaning in regex!
    MsgBox "This won't work as expected - $ is regex anchor"

    ; Need to escape special characters
    if RegExMatch(text3, "\$")
    MsgBox "Correctly found dollar sign using \$"

    ; Common special characters that need escaping: . * + ? [ ] { } ( ) ^ $ | \
    specialText := "File.txt or File*.txt?"
    MsgBox "Finding literal dot: " . (RegExMatch(specialText, "\.") ? "Found" : "Not found") . "`n" .
    "Finding literal asterisk: " . (RegExMatch(specialText, "\*") ? "Found" : "Not found") . "`n" .
    "Finding literal question mark: " . (RegExMatch(specialText, "\?") ? "Found" : "Not found")
}

; ========================================
; EXAMPLE 2: Case-Insensitive Matching
; ========================================
; Using the 'i' option for case-insensitive searches
Example2_CaseInsensitive() {
    MsgBox "EXAMPLE 2: Case-Insensitive Matching`n" .
    "======================================="

    text := "Hello World HELLO world HeLLo WoRLd"

    ; Default case-sensitive
    count := 0
    pos := 1
    while (pos := RegExMatch(text, "Hello", , pos)) {
        count++
        pos += 5  ; Move past "Hello"
    }
    MsgBox "Case-sensitive search for 'Hello': Found " . count . " time(s)"

    ; Case-insensitive with 'i' option
    count := 0
    pos := 1
    while (pos := RegExMatch(text, "i)Hello", , pos)) {
        count++
        pos++  ; Move forward by 1 to find overlapping matches if any
    }
    MsgBox "Case-insensitive search for 'Hello': Found " . count . " time(s)"

    ; Practical example: Checking file extensions
    filename := "Document.PDF"

    ; Case-sensitive check (wrong approach for file extensions)
    if RegExMatch(filename, "\.pdf$")
    MsgBox "Found .pdf extension (case-sensitive)"
    else
    MsgBox "Didn't find .pdf extension (case-sensitive)"

    ; Case-insensitive check (correct approach)
    if RegExMatch(filename, "i)\.pdf$")
    MsgBox "Found PDF extension (case-insensitive)"

    ; Multiple variations
    files := ["image.JPG", "photo.jpg", "picture.Jpg", "snapshot.PNG"]
    jpgFiles := []

    for file in files {
        if RegExMatch(file, "i)\.jpg$")
        jpgFiles.Push(file)
    }

    MsgBox "JPG files found: " . jpgFiles.Length . "`n" .
    "Files: " . (jpgFiles.Length > 0 ? StrJoin(jpgFiles, ", ") : "None")
}

; ========================================
; EXAMPLE 3: Working with Match Objects
; ========================================
; Extracting detailed information about matches
Example3_MatchObjects() {
    MsgBox "EXAMPLE 3: Working with Match Objects`n" .
    "======================================="

    text := "The quick brown fox jumps over the lazy dog"

    ; Get Match object with details
    pos := RegExMatch(text, "brown fox", &match)

    if pos {
        MsgBox "Match Details:`n" .
        "=============`n" .
        "Matched text: " . match[0] . "`n" .
        "Position: " . match.Pos . "`n" .
        "Length: " . match.Len . "`n" .
        "Original text: " . text . "`n`n" .
        "Text before match: " . SubStr(text, 1, match.Pos - 1) . "`n" .
        "Text after match: " . SubStr(text, match.Pos + match.Len)
    }

    ; Finding word boundaries
    text2 := "The theater has great theatrical performances"

    ; Find "the" as a complete word
    pos := RegExMatch(text2, "\bthe\b", &match)
    if pos
    MsgBox "Found standalone 'the' at position " . match.Pos . "`n" .
    "Context: ..." . SubStr(text2, Max(1, match.Pos - 5), match.Len + 10) . "..."

    ; Find "the" anywhere (including within words)
    pos := RegExMatch(text2, "the", &match)
    if pos
    MsgBox "Found 'the' (anywhere) at position " . match.Pos . "`n" .
    "Matched in context: " . SubStr(text2, Max(1, match.Pos - 3), match.Len + 6)

    ; Using Match object properties for highlighting
    text3 := "Error on line 42: Unexpected token"
    if RegExMatch(text3, "Error", &match) {
        before := SubStr(text3, 1, match.Pos - 1)
        matched := match[0]
        after := SubStr(text3, match.Pos + match.Len)

        MsgBox "Highlighted text:`n" .
        before . "[" . matched . "]" . after
    }
}

; ========================================
; EXAMPLE 4: Finding Patterns with Metacharacters
; ========================================
; Using basic regex metacharacters
Example4_Metacharacters() {
    MsgBox "EXAMPLE 4: Finding Patterns with Metacharacters`n" .
    "================================================"

    ; Dot (.) matches any single character except newline
    text := "cat, bat, hat, mat, rat"
    if RegExMatch(text, ".at", &match)
    MsgBox "Pattern '.at' matched: " . match[0] . "`n" .
    "The dot matches any character before 'at'"

    ; Find all 3-letter words ending in 'at'
    allMatches := []
    pos := 1
    while (pos := RegExMatch(text, ".at", &match, pos)) {
        allMatches.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "All '.at' patterns: " . StrJoin(allMatches, ", ")

    ; Using character classes
    text2 := "The numbers are 5, 15, 25, 35, 45"

    ; [0-9] matches any digit
    if RegExMatch(text2, "[0-9]", &match)
    MsgBox "First digit found: " . match[0] . " at position " . match.Pos

    ; \d is shorthand for [0-9]
    if RegExMatch(text2, "\d+", &match)  ; + means one or more
    MsgBox "First number found: " . match[0]

    ; Find two-digit numbers
    pos := 1
    twoDigitNumbers := []
    while (pos := RegExMatch(text2, "\b\d{2}\b", &match, pos)) {
        twoDigitNumbers.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "Two-digit numbers: " . StrJoin(twoDigitNumbers, ", ")

    ; Word characters \w matches [a-zA-Z0-9_]
    text3 := "user_name123 is valid, but user-name is not standard"
    if RegExMatch(text3, "\w+", &match)
    MsgBox "First word/identifier: " . match[0]

    ; Whitespace \s matches spaces, tabs, newlines
    text4 := "Word1    Word2`tWord3`nWord4"
    spaces := 0
    pos := 1
    while (pos := RegExMatch(text4, "\s+", &match, pos)) {
        spaces++
        pos := match.Pos + match.Len
    }
    MsgBox "Found " . spaces . " whitespace sequences in text"
}

; ========================================
; EXAMPLE 5: Using Start Position Parameter
; ========================================
; Searching from specific positions
Example5_StartPosition() {
    MsgBox "EXAMPLE 5: Using Start Position Parameter`n" .
    "=========================================="

    text := "The word 'test' appears multiple times. This is a test. Another test here."

    ; Find first occurrence
    pos1 := RegExMatch(text, "test", &match1)
    MsgBox "First 'test' at position: " . pos1 . "`n" .
    "Context: " . SubStr(text, pos1 - 5, 15)

    ; Find second occurrence by starting after the first
    pos2 := RegExMatch(text, "test", &match2, pos1 + match1.Len)
    if pos2
    MsgBox "Second 'test' at position: " . pos2 . "`n" .
    "Context: " . SubStr(text, pos2 - 5, 15)

    ; Find all occurrences
    allPositions := []
    pos := 1
    while (pos := RegExMatch(text, "test", &match, pos)) {
        allPositions.Push(pos)
        pos := match.Pos + match.Len
    }

    result := "All occurrences of 'test':`n"
    for index, position in allPositions {
        result .= index . ". Position " . position . "`n"
    }
    MsgBox result

    ; Practical example: Find and replace all but first
    original := "error error error"
    firstPos := RegExMatch(original, "error", &match)

    if firstPos {
        ; Keep first, replace others
        modified := SubStr(original, 1, match.Pos + match.Len - 1)
        remaining := SubStr(original, match.Pos + match.Len)
        remaining := StrReplace(remaining, "error", "warning")
        modified .= remaining

        MsgBox "Original: " . original . "`n" .
        "Modified: " . modified . "`n" .
        "(First 'error' kept, others changed to 'warning')"
    }

    ; Skip matches using start position
    text2 := "Skip this first match but find this second match"
    skipCount := 2  ; Skip first 2 matches of "match"

    pos := 1
    found := 0
    while (found < skipCount && pos := RegExMatch(text2, "match", , pos)) {
        pos++
        found++
    }

    ; Now find the next one
    finalPos := RegExMatch(text2, "match", &match, pos)
    if finalPos
    MsgBox "After skipping " . skipCount . " matches:`n" .
    "Found at position " . finalPos . ": " . match[0]
}

; ========================================
; EXAMPLE 6: Basic Validation Patterns
; ========================================
; Simple validation using regex
Example6_BasicValidation() {
    MsgBox "EXAMPLE 6: Basic Validation Patterns`n" .
    "====================================="

    ; Validate username (letters, numbers, underscore, 3-16 chars)
    ValidateUsername(username) {
        return RegExMatch(username, "^[a-zA-Z0-9_]{3,16}$") ? true : false
    }

    testUsers := ["john_doe", "ab", "valid_user_123", "invalid-user", "user@name", "a_very_long_username_that_exceeds_limit"]

    result := "Username Validation:`n"
    for user in testUsers {
        result .= user . ": " . (ValidateUsername(user) ? "Valid" : "Invalid") . "`n"
    }
    MsgBox result

    ; Validate simple numeric input
    ValidateNumber(input) {
        ; Matches optional minus, followed by digits
        return RegExMatch(input, "^-?\d+$") ? true : false
    }

    testNumbers := ["123", "-456", "12.34", "abc", "12a3", ""]

    result := "Number Validation:`n"
    for num in testNumbers {
        result .= "'" . num . "': " . (ValidateNumber(num) ? "Valid" : "Invalid") . "`n"
    }
    MsgBox result

    ; Validate yes/no input (case-insensitive)
    ValidateYesNo(input) {
        return RegExMatch(input, "i)^(yes|no)$") ? true : false
    }

    testInputs := ["yes", "Yes", "YES", "no", "No", "maybe", "y", ""]

    result := "Yes/No Validation:`n"
    for input in testInputs {
        result .= "'" . input . "': " . (ValidateYesNo(input) ? "Valid" : "Invalid") . "`n"
    }
    MsgBox result

    ; Check if string contains only letters
    ContainsOnlyLetters(text) {
        return RegExMatch(text, "^[a-zA-Z]+$") ? true : false
    }

    testTexts := ["Hello", "Hello123", "Hello World", "Test_Case", ""]

    result := "Letters-Only Validation:`n"
    for text in testTexts {
        result .= "'" . text . "': " . (ContainsOnlyLetters(text) ? "Only letters" : "Contains other chars") . "`n"
    }
    MsgBox result
}

; ========================================
; EXAMPLE 7: Return Value Patterns
; ========================================
; Understanding different return scenarios
Example7_ReturnValues() {
    MsgBox "EXAMPLE 7: Return Value Patterns`n" .
    "================================="

    ; Return value = 0 means no match
    text := "Hello World"
    pos := RegExMatch(text, "Goodbye")
    MsgBox "Search for 'Goodbye': " . (pos = 0 ? "Not found (returns 0)" : "Found at " . pos)

    ; Return value > 0 is the position (1-based indexing)
    pos := RegExMatch(text, "World")
    MsgBox "Search for 'World': Found at position " . pos . "`n" .
    "(Position is 1-based, not 0-based)"

    ; Using return value in if conditions
    text2 := "Error: File not found"
    if RegExMatch(text2, "Error") {
        MsgBox "Text contains an error message"
    }

    if !RegExMatch(text2, "Warning") {
        MsgBox "Text does not contain a warning"
    }

    ; Chaining matches
    logLine := "[2024-01-15 10:30:45] INFO: Application started"

    hasDate := RegExMatch(logLine, "\d{4}-\d{2}-\d{2}")
    hasTime := RegExMatch(logLine, "\d{2}:\d{2}:\d{2}")
    hasLevel := RegExMatch(logLine, "INFO|WARNING|ERROR")

    MsgBox "Log line validation:`n" .
    "Has date: " . (hasDate ? "Yes" : "No") . "`n" .
    "Has time: " . (hasTime ? "Yes" : "No") . "`n" .
    "Has level: " . (hasLevel ? "Yes" : "No") . "`n`n" .
    "Valid log format: " . (hasDate && hasTime && hasLevel ? "Yes" : "No")

    ; Match object only populated when provided
    pos1 := RegExMatch(text, "World")  ; No match object
    pos2 := RegExMatch(text, "World", &match)  ; With match object

    MsgBox "Without match object: pos = " . pos1 . "`n" .
    "With match object: pos = " . pos2 . ", matched = '" . match[0] . "'"

    ; Testing multiple patterns
    userInput := "test@example.com"

    isEmail := RegExMatch(userInput, "@")  ; Simplified check
    isPhone := RegExMatch(userInput, "\d{3}-\d{4}")  ; Simplified pattern
    isURL := RegExMatch(userInput, "https?://")

    inputType := "Unknown"
    if isEmail
    inputType := "Possible email"
    else if isPhone
    inputType := "Possible phone"
    else if isURL
    inputType := "Possible URL"

    MsgBox "Input: " . userInput . "`n" .
    "Detected type: " . inputType
}

; ========================================
; Helper Functions
; ========================================

; Join array elements with delimiter
StrJoin(arr, delim := ",") {
    result := ""
    for index, value in arr {
        result .= value
        if index < arr.Length
        result .= delim
    }
    return result
}

; ========================================
; Main Menu
; ========================================

ShowMenu() {
    menu := "
    (
    RegExMatch Basic Usage Examples
    ================================

    1. Basic Pattern Matching
    2. Case-Insensitive Matching
    3. Working with Match Objects
    4. Finding Patterns with Metacharacters
    5. Using Start Position Parameter
    6. Basic Validation Patterns
    7. Return Value Patterns

    Press 1-7 to run an example
    Press ESC to exit
    )"

    MsgBox menu, "RegExMatch Basic Usage"
}

; Hotkeys to run examples
^1::Example1_BasicMatching()
^2::Example2_CaseInsensitive()
^3::Example3_MatchObjects()
^4::Example4_Metacharacters()
^5::Example5_StartPosition()
^6::Example6_BasicValidation()
^7::Example7_ReturnValues()

^h::ShowMenu()

; Show menu on startup
ShowMenu()
