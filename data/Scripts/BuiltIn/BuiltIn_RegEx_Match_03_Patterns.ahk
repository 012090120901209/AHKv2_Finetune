#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_RegEx_Match_03_Patterns.ahk
 * 
 * DESCRIPTION:
 * Comprehensive guide to common regex patterns and character classes used with
 * RegExMatch. Covers digits, word characters, whitespace, anchors, quantifiers,
 * and alternation patterns.
 * 
 * FEATURES:
 * - Character classes (\d, \w, \s and their negations)
 * - Anchors (^, $, \b, \B)
 * - Quantifiers (*, +, ?, {n}, {n,m})
 * - Alternation with |
 * - Custom character classes [...]
 * - Common pattern combinations
 * - Real-world pattern examples
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - RegEx
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Pattern matching with various metacharacters
 * - Greedy vs lazy quantifiers
 * - Boundary matching
 * - Character class ranges
 * - Negated character classes
 * 
 * LEARNING POINTS:
 * 1. \d matches digits [0-9], \D matches non-digits
 * 2. \w matches word chars [a-zA-Z0-9_], \W matches non-word chars
 * 3. \s matches whitespace, \S matches non-whitespace
 * 4. ^ matches start of string, $ matches end
 * 5. \b matches word boundary, \B matches non-boundary
 * 6. * means 0 or more, + means 1 or more, ? means 0 or 1
 * 7. {n} means exactly n, {n,m} means between n and m
 */

; ========================================
; EXAMPLE 1: Character Classes
; ========================================
; Using \d, \w, \s and their negations
Example1_CharacterClasses() {
    MsgBox "EXAMPLE 1: Character Classes`n" .
        "============================="

    ; \d - Digits [0-9]
    text1 := "Order #12345 contains 3 items"

    ; Find first digit
    if RegExMatch(text1, "\d", &match)
        MsgBox "First digit: " . match[0] . " at position " . match.Pos

    ; Find sequence of digits
    if RegExMatch(text1, "\d+", &match)
        MsgBox "First number: " . match[0]

    ; Find all numbers
    numbers := []
    pos := 1
    while (pos := RegExMatch(text1, "\d+", &match, pos)) {
        numbers.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "All numbers: " . StrJoin(numbers, ", ")

    ; \D - Non-digits (opposite of \d)
    text2 := "abc123def456"
    if RegExMatch(text2, "\D+", &match)
        MsgBox "First non-digit sequence: " . match[0]

    ; \w - Word characters [a-zA-Z0-9_]
    text3 := "variable_name123 = value"
    if RegExMatch(text3, "\w+", &match)
        MsgBox "First word/identifier: " . match[0]

    ; Extract all identifiers
    identifiers := []
    pos := 1
    while (pos := RegExMatch(text3, "\w+", &match, pos)) {
        identifiers.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "All identifiers: " . StrJoin(identifiers, ", ")

    ; \W - Non-word characters (opposite of \w)
    text4 := "Hello, World! How are you?"
    punctuation := []
    pos := 1
    while (pos := RegExMatch(text4, "\W", &match, pos)) {
        if match[0] != " "  ; Exclude spaces for clarity
            punctuation.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "Punctuation found: " . StrJoin(punctuation, " ")

    ; \s - Whitespace (space, tab, newline)
    text5 := "Word1    Word2`tWord3`nWord4"
    spaces := 0
    pos := 1
    while (pos := RegExMatch(text5, "\s+", &match, pos)) {
        spaces++
        pos := match.Pos + match.Len
    }
    MsgBox "Whitespace sequences: " . spaces

    ; \S - Non-whitespace (opposite of \s)
    words := []
    pos := 1
    while (pos := RegExMatch(text5, "\S+", &match, pos)) {
        words.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "Words extracted: " . StrJoin(words, ", ")

    ; Combining character classes
    text6 := "Username: user_123, Age: 25, ID: ABC-456"

    ; Find alphanumeric with underscores: \w+
    if RegExMatch(text6, "\w+", &match)
        MsgBox "First identifier: " . match[0]

    ; Find only letters followed by digits: [a-z]+\d+
    if RegExMatch(text6, "i)[a-z]+_\d+", &match)
        MsgBox "Username pattern: " . match[0]
}

; ========================================
; EXAMPLE 2: Anchors and Boundaries
; ========================================
; Using ^, $, \b, \B for position matching
Example2_AnchorsAndBoundaries() {
    MsgBox "EXAMPLE 2: Anchors and Boundaries`n" .
        "==================================="

    ; ^ - Start of string
    text1 := "Hello World"
    MsgBox "Starts with 'Hello': " . (RegExMatch(text1, "^Hello") ? "Yes" : "No") . "`n" .
        "Starts with 'World': " . (RegExMatch(text1, "^World") ? "Yes" : "No")

    ; $ - End of string
    MsgBox "Ends with 'World': " . (RegExMatch(text1, "World$") ? "Yes" : "No") . "`n" .
        "Ends with 'Hello': " . (RegExMatch(text1, "Hello$") ? "Yes" : "No")

    ; ^...$ - Exact match (whole string)
    input := "12345"
    MsgBox "Is exactly 5 digits: " . (RegExMatch(input, "^\d{5}$") ? "Yes" : "No") . "`n" .
        "String: " . input

    input2 := "123456"
    MsgBox "Is exactly 5 digits: " . (RegExMatch(input2, "^\d{5}$") ? "Yes" : "No") . "`n" .
        "String: " . input2

    ; \b - Word boundary
    text2 := "The theater has great theatrical performances"

    ; Find "the" as complete word
    matches := []
    pos := 1
    while (pos := RegExMatch(text2, "\bthe\b", &match, pos)) {
        matches.Push(Map("pos", match.Pos, "text", match[0]))
        pos := match.Pos + match.Len
    }
    MsgBox "Complete word 'the': Found " . matches.Length . " time(s)"

    ; Find "the" anywhere (including in words)
    matches := []
    pos := 1
    while (pos := RegExMatch(text2, "the", &match, pos)) {
        matches.Push(Map("pos", match.Pos, "text", match[0]))
        pos := match.Pos + match.Len
    }
    MsgBox "Pattern 'the' anywhere: Found " . matches.Length . " time(s)"

    ; \B - Non-word boundary (opposite of \b)
    text3 := "cat concatenate catalog"

    ; Find "cat" NOT at word boundaries
    matches := []
    pos := 1
    while (pos := RegExMatch(text3, "\Bcat", &match, pos)) {
        matches.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "Pattern 'cat' at non-boundaries: " . StrJoin(matches, ", ")

    ; Practical: Extract whole words only
    sentence := "The quick brown fox jumps"
    wordPattern := "\b\w+\b"

    words := []
    pos := 1
    while (pos := RegExMatch(sentence, wordPattern, &match, pos)) {
        words.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "Words: " . StrJoin(words, ", ")

    ; Validate username (must start/end with word char)
    ValidateUsername(name) {
        ; Must be 3-16 chars, start and end with word char
        return RegExMatch(name, "^\w{3,16}$") ? true : false
    }

    testNames := ["user", "ab", "user_name_123", "_username", "username_", "a-b"]
    result := "Username Validation:`n"
    for name in testNames {
        result .= name . ": " . (ValidateUsername(name) ? "Valid" : "Invalid") . "`n"
    }
    MsgBox result
}

; ========================================
; EXAMPLE 3: Quantifiers
; ========================================
; Using *, +, ?, {n}, {n,m}
Example3_Quantifiers() {
    MsgBox "EXAMPLE 3: Quantifiers`n" .
        "======================="

    ; * - Zero or more
    text1 := "Color and Colour are both correct"
    if RegExMatch(text1, "Colou*r", &match)
        MsgBox "* quantifier (zero or more):`n" .
            "Pattern 'Colou*r' matches: " . match[0]

    ; Both color and colour match
    MsgBox "Matches 'Color': " . (RegExMatch("Color", "Colou*r") ? "Yes" : "No") . "`n" .
        "Matches 'Colour': " . (RegExMatch("Colour", "Colou*r") ? "Yes" : "No") . "`n" .
        "Matches 'Colouur': " . (RegExMatch("Colouur", "Colou*r") ? "Yes" : "No")

    ; + - One or more
    text2 := "Numbers: 1, 12, 123, 1234"
    numbers := []
    pos := 1
    while (pos := RegExMatch(text2, "\d+", &match, pos)) {
        numbers.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "+ quantifier (one or more):`n" .
        "All numbers: " . StrJoin(numbers, ", ")

    ; ? - Zero or one (optional)
    text3 := "I have 1 apple and 2 apples"
    if RegExMatch(text3, "apples?", &match)
        MsgBox "? quantifier (zero or one):`n" .
            "Pattern 'apples?' matches: " . match[0]

    ; Matches both singular and plural
    matches := []
    pos := 1
    while (pos := RegExMatch(text3, "apples?", &match, pos)) {
        matches.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "All matches: " . StrJoin(matches, ", ")

    ; {n} - Exactly n times
    text4 := "Phone: 123-4567 or 1234-5678"

    ; Find exactly 4 digits
    fourDigit := []
    pos := 1
    while (pos := RegExMatch(text4, "\d{4}", &match, pos)) {
        fourDigit.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "{n} quantifier (exactly n):`n" .
        "4-digit sequences: " . StrJoin(fourDigit, ", ")

    ; {n,m} - Between n and m times
    text5 := "ZIP codes: 12345, 123456, 1234, 123"

    ; Find 5 or 6 digits (ZIP or ZIP+4)
    zips := []
    pos := 1
    while (pos := RegExMatch(text5, "\b\d{5,6}\b", &match, pos)) {
        zips.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "{n,m} quantifier (between n and m):`n" .
        "Valid ZIP codes (5-6 digits): " . StrJoin(zips, ", ")

    ; {n,} - n or more times
    text6 := "Repeat: aaa, aaaa, aaaaa"
    longA := []
    pos := 1
    while (pos := RegExMatch(text6, "a{3,}", &match, pos)) {
        longA.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "{n,} quantifier (n or more):`n" .
        "3+ 'a' sequences: " . StrJoin(longA, ", ")

    ; Greedy vs Lazy quantifiers
    html := "<div>Content 1</div><div>Content 2</div>"

    ; Greedy (default) - matches as much as possible
    if RegExMatch(html, "<div>.*</div>", &match)
        MsgBox "Greedy quantifier (.*):`n" . match[0]

    ; Lazy (with ?) - matches as little as possible
    if RegExMatch(html, "<div>.*?</div>", &match)
        MsgBox "Lazy quantifier (.*?):`n" . match[0]

    ; Extract all tags with lazy quantifier
    tags := []
    pos := 1
    while (pos := RegExMatch(html, "<div>.*?</div>", &match, pos)) {
        tags.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "All div tags (lazy): " . tags.Length . " found`n" .
        StrJoin(tags, "`n")
}

; ========================================
; EXAMPLE 4: Alternation
; ========================================
; Using | for OR patterns
Example4_Alternation() {
    MsgBox "EXAMPLE 4: Alternation`n" .
        "======================"

    ; Simple alternation
    text1 := "I like cats and dogs"
    if RegExMatch(text1, "cat|dog", &match)
        MsgBox "Simple alternation (cat|dog):`n" .
            "Matched: " . match[0]

    ; Find all occurrences
    pets := []
    pos := 1
    while (pos := RegExMatch(text1, "cat|dog", &match, pos)) {
        pets.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "All pets: " . StrJoin(pets, ", ")

    ; Multiple alternatives
    text2 := "Colors: red, blue, green, yellow, red"
    pattern := "red|blue|green"

    colors := []
    pos := 1
    while (pos := RegExMatch(text2, pattern, &match, pos)) {
        colors.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "Primary colors found: " . StrJoin(colors, ", ")

    ; Alternation with groups
    text3 := "Files: document.pdf, image.jpg, spreadsheet.xlsx"
    pattern := "\w+\.(pdf|jpg|xlsx)"

    files := []
    pos := 1
    while (pos := RegExMatch(text3, pattern, &match, pos)) {
        files.Push(Map("full", match[0], "ext", match[1]))
        pos := match.Pos + match.Len
    }

    result := "Files found:`n"
    for index, file in files {
        result .= file["full"] . " (extension: " . file["ext"] . ")`n"
    }
    MsgBox result

    ; Alternation with word boundaries
    code := "var variable = value;"
    pattern := "\b(var|let|const)\b"

    if RegExMatch(code, pattern, &match)
        MsgBox "JavaScript keyword: " . match[1]

    ; Practical: Detect file types
    DetectFileType(filename) {
        if RegExMatch(filename, "i)\.(jpg|jpeg|png|gif|bmp)$")
            return "Image"
        else if RegExMatch(filename, "i)\.(mp4|avi|mkv|mov)$")
            return "Video"
        else if RegExMatch(filename, "i)\.(mp3|wav|flac|aac)$")
            return "Audio"
        else if RegExMatch(filename, "i)\.(pdf|doc|docx|txt)$")
            return "Document"
        else
            return "Unknown"
    }

    testFiles := ["photo.jpg", "video.mp4", "song.mp3", "report.pdf", "data.csv"]
    result := "File Type Detection:`n"
    for file in testFiles {
        result .= file . " -> " . DetectFileType(file) . "`n"
    }
    MsgBox result

    ; Priority in alternation (first match wins)
    text4 := "testing"
    MsgBox "Pattern 'test|testing' on 'testing': " .
        (RegExMatch(text4, "test|testing", &match) ? match[0] : "No match") . "`n" .
        "Pattern 'testing|test' on 'testing': " .
        (RegExMatch(text4, "testing|test", &match) ? match[0] : "No match") . "`n" .
        "(Order matters - first match is used!)"
}

; ========================================
; EXAMPLE 5: Custom Character Classes
; ========================================
; Using [...] for custom character sets
Example5_CustomCharacterClasses() {
    MsgBox "EXAMPLE 5: Custom Character Classes`n" .
        "===================================="

    ; [abc] - Matches any of a, b, or c
    text1 := "The cat sat on the mat"
    matches := []
    pos := 1
    while (pos := RegExMatch(text1, "[cms]at", &match, pos)) {
        matches.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "[cms]at pattern:`n" .
        "Matches: " . StrJoin(matches, ", ")

    ; [a-z] - Range (all lowercase letters)
    text2 := "Product Code: ABC-123-xyz"
    if RegExMatch(text2, "[a-z]+", &match)
        MsgBox "First lowercase sequence: " . match[0]

    ; [A-Z] - All uppercase letters
    if RegExMatch(text2, "[A-Z]+", &match)
        MsgBox "First uppercase sequence: " . match[0]

    ; [0-9] - All digits (same as \d)
    if RegExMatch(text2, "[0-9]+", &match)
        MsgBox "First number sequence: " . match[0]

    ; Combining ranges: [a-zA-Z0-9]
    text3 := "user_name123 = value"
    if RegExMatch(text3, "[a-zA-Z0-9]+", &match)
        MsgBox "Alphanumeric (no underscore): " . match[0]

    ; [^abc] - Negated class (anything BUT a, b, or c)
    text4 := "Hello World!"
    if RegExMatch(text4, "[^a-zA-Z ]+", &match)
        MsgBox "Non-letter, non-space: " . match[0]

    ; Practical: Extract hex color
    css := "color: #FF5733; background: #00A0E3;"
    pattern := "#[0-9A-Fa-f]{6}"

    colors := []
    pos := 1
    while (pos := RegExMatch(css, pattern, &match, pos)) {
        colors.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "Hex colors found: " . StrJoin(colors, ", ")

    ; Vowels and consonants
    text5 := "Programming"

    ; Count vowels
    vowelCount := 0
    pos := 1
    while (pos := RegExMatch(text5, "[aeiouAEIOU]", , pos)) {
        vowelCount++
        pos++
    }

    ; Count consonants
    consonantCount := 0
    pos := 1
    while (pos := RegExMatch(text5, "[bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ]", , pos)) {
        consonantCount++
        pos++
    }

    MsgBox "Text: " . text5 . "`n" .
        "Vowels: " . vowelCount . "`n" .
        "Consonants: " . consonantCount

    ; Special characters in character class
    text6 := "Math: 2+2=4, 5-3=2, 10*2=20"
    operators := []
    pos := 1
    while (pos := RegExMatch(text6, "[+\-*/=]", &match, pos)) {
        operators.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "Operators found: " . StrJoin(operators, " ")

    ; Literal characters in character class
    filename := "file[1].txt"
    MsgBox "Contains literal bracket: " .
        (RegExMatch(filename, "\[") ? "Yes" : "No")
}

; ========================================
; EXAMPLE 6: Common Pattern Combinations
; ========================================
; Practical pattern combinations
Example6_CommonPatterns() {
    MsgBox "EXAMPLE 6: Common Pattern Combinations`n" .
        "======================================="

    ; Integer pattern: -?\d+
    numbers := ["-123", "456", "0", "-0"]
    result := "Integer Pattern (-?\\d+):`n"
    for num in numbers {
        result .= num . ": " . (RegExMatch(num, "^-?\d+$") ? "Valid" : "Invalid") . "`n"
    }
    MsgBox result

    ; Decimal pattern: -?\d+\.\d+
    decimals := ["123.45", "-67.89", "0.1", "123", ".45"]
    result := "Decimal Pattern (-?\\d+\\.\\d+):`n"
    for num in decimals {
        result .= num . ": " . (RegExMatch(num, "^-?\d+\.\d+$") ? "Valid" : "Invalid") . "`n"
    }
    MsgBox result

    ; Optional decimal: -?\d+\.?\d*
    flexNumbers := ["123", "123.45", "-67", "-67.89"]
    result := "Flexible Number (-?\\d+\\.?\\d*):`n"
    for num in flexNumbers {
        result .= num . ": " . (RegExMatch(num, "^-?\d+\.?\d*$") ? "Valid" : "Invalid") . "`n"
    }
    MsgBox result

    ; Alphanumeric identifier: [a-zA-Z_]\w*
    ; (starts with letter or underscore, followed by word chars)
    identifiers := ["variable", "_private", "var123", "123invalid", "my-var"]
    result := "Identifier Pattern ([a-zA-Z_]\\w*):`n"
    for id in identifiers {
        result .= id . ": " . (RegExMatch(id, "^[a-zA-Z_]\w*$") ? "Valid" : "Invalid") . "`n"
    }
    MsgBox result

    ; Whitespace-trimmed text: ^\s*(.+?)\s*$
    texts := ["  hello  ", "no spaces", "`thello`t"]
    result := "Trimmed Text:`n"
    for text in texts {
        if RegExMatch(text, "^\s*(.+?)\s*$", &match)
            result .= "'" . text . "' -> '" . match[1] . "'`n"
    }
    MsgBox result

    ; Lines ending with semicolon: .*;$
    code := "
    (
    var x = 5;
    var y = 10
    var z = 15;
    )"

    linesWithSemicolon := 0
    Loop Parse, code, "`n", "`r" {
        if RegExMatch(Trim(A_LoopField), ";$")
            linesWithSemicolon++
    }
    MsgBox "Lines ending with semicolon: " . linesWithSemicolon

    ; Repeated words: \b(\w+)\s+\1\b (uses backreference)
    text := "This is is a test test of repeated repeated words"
    repeated := []
    pos := 1
    while (pos := RegExMatch(text, "\b(\w+)\s+\1\b", &match, pos)) {
        repeated.Push(match[1])
        pos := match.Pos + match.Len
    }
    MsgBox "Repeated words: " . StrJoin(repeated, ", ")
}

; ========================================
; EXAMPLE 7: Advanced Pattern Recipes
; ========================================
; Complex real-world patterns
Example7_AdvancedRecipes() {
    MsgBox "EXAMPLE 7: Advanced Pattern Recipes`n" .
        "===================================="

    ; IPv4 address: \d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}
    text1 := "Server: 192.168.1.1, Gateway: 10.0.0.1"
    pattern := "\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b"

    ips := []
    pos := 1
    while (pos := RegExMatch(text1, pattern, &match, pos)) {
        ips.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "IP Addresses: " . StrJoin(ips, ", ")

    ; Time (24-hour): [01]\d|2[0-3]):[0-5]\d
    times := ["10:30", "23:59", "25:00", "12:75"]
    result := "Time Validation (24-hour):`n"
    for time in times {
        result .= time . ": " .
            (RegExMatch(time, "^([01]\d|2[0-3]):[0-5]\d$") ? "Valid" : "Invalid") . "`n"
    }
    MsgBox result

    ; Hex color: #[0-9A-Fa-f]{6}|#[0-9A-Fa-f]{3}
    colors := ["#FF5733", "#F00", "#GGGGGG", "FF5733"]
    result := "Hex Color Validation:`n"
    for color in colors {
        result .= color . ": " .
            (RegExMatch(color, "^#([0-9A-Fa-f]{6}|[0-9A-Fa-f]{3})$") ? "Valid" : "Invalid") . "`n"
    }
    MsgBox result

    ; Semantic version: \d+\.\d+\.\d+
    versions := ["1.2.3", "10.0.1", "1.2", "v1.2.3"]
    result := "Version Number Validation:`n"
    for version in versions {
        result .= version . ": " .
            (RegExMatch(version, "^\d+\.\d+\.\d+$") ? "Valid" : "Invalid") . "`n"
    }
    MsgBox result

    ; Extract quoted strings: "([^"]*)"
    code := 'var name = "John"; var msg = "Hello World";'
    quoted := []
    pos := 1
    while (pos := RegExMatch(code, '"([^"]*)"', &match, pos)) {
        quoted.Push(match[1])
        pos := match.Pos + match.Len
    }
    MsgBox "Quoted strings: " . StrJoin(quoted, ", ")

    ; HTML tag: <(\w+)[^>]*>
    html := '<div class="container"><span id="title">Hello</span></div>'
    tags := []
    pos := 1
    while (pos := RegExMatch(html, "<(\w+)[^>]*>", &match, pos)) {
        tags.Push(match[1])
        pos := match.Pos + match.Len
    }
    MsgBox "HTML Tags: " . StrJoin(tags, ", ")

    ; Variable assignment: (\w+)\s*=\s*(.+)
    code := "name = John`nage = 30`ncity = NewYork"
    vars := Map()
    Loop Parse, code, "`n" {
        if RegExMatch(A_LoopField, "(\w+)\s*=\s*(.+)", &match)
            vars[match[1]] := match[2]
    }

    result := "Variables:`n"
    for key, value in vars {
        result .= key . " = " . value . "`n"
    }
    MsgBox result
}

; ========================================
; Helper Functions
; ========================================

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
    RegExMatch Common Patterns
    ==========================

    1. Character Classes (\d, \w, \s)
    2. Anchors and Boundaries (^, $, \b)
    3. Quantifiers (*, +, ?, {n})
    4. Alternation (|)
    5. Custom Character Classes [...]
    6. Common Pattern Combinations
    7. Advanced Pattern Recipes

    Press Ctrl+1-7 to run examples
    Press Ctrl+H for menu
    )"

    MsgBox menu
}

^1:: Example1_CharacterClasses()
^2:: Example2_AnchorsAndBoundaries()
^3:: Example3_Quantifiers()
^4:: Example4_Alternation()
^5:: Example5_CustomCharacterClasses()
^6:: Example6_CommonPatterns()
^7:: Example7_AdvancedRecipes()

^h:: ShowMenu()

ShowMenu()
