#Requires AutoHotkey v2.0

/**
 * BuiltIn_RegEx_Replace_01_BasicUsage.ahk
 *
 * DESCRIPTION:
 * Demonstrates basic RegExReplace usage for finding and replacing text patterns.
 * Covers simple replacements, case-insensitive replacements, and understanding
 * the return value and replacement count.
 *
 * FEATURES:
 * - Basic pattern replacement
 * - Case-sensitive and case-insensitive replacement
 * - Replace all vs replace first occurrence
 * - Counting replacements with OutputVar
 * - Limiting replacement count
 * - Removing text with empty replacement
 * - Simple text transformations
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - RegEx
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - RegExReplace function with v2 syntax
 * - OutputVar for replacement count
 * - Limit parameter for controlling replacements
 * - Modern string handling
 * - Clean return value handling
 *
 * LEARNING POINTS:
 * 1. RegExReplace returns the modified string
 * 2. Original string is not modified (strings are immutable)
 * 3. OutputVar receives the count of replacements made
 * 4. Without limit, all matches are replaced
 * 5. With limit, only first N matches are replaced
 * 6. Empty replacement string removes matched text
 * 7. Case sensitivity controlled by 'i' option like RegExMatch
 */

; ========================================
; EXAMPLE 1: Basic Replacement
; ========================================
; Simple find and replace operations
Example1_BasicReplacement() {
    MsgBox "EXAMPLE 1: Basic Replacement`n" .
           "============================="

    ; Simple word replacement
    text := "The cat sat on the mat"
    result := RegExReplace(text, "cat", "dog")

    MsgBox "Original: " . text . "`n" .
           "Pattern: 'cat' -> 'dog'`n" .
           "Result: " . result . "`n`n" .
           "Note: Original string unchanged (strings are immutable)"

    ; Replace multiple occurrences
    text := "test test test"
    result := RegExReplace(text, "test", "demo")

    MsgBox "Original: " . text . "`n" .
           "Pattern: 'test' -> 'demo'`n" .
           "Result: " . result . "`n" .
           "(All occurrences replaced by default)"

    ; Replace with count
    text := "apple apple orange apple"
    result := RegExReplace(text, "apple", "banana", &count)

    MsgBox "Original: " . text . "`n" .
           "Pattern: 'apple' -> 'banana'`n" .
           "Result: " . result . "`n" .
           "Replacements made: " . count

    ; No match scenario
    text := "Hello World"
    result := RegExReplace(text, "goodbye", "farewell", &count)

    MsgBox "Original: " . text . "`n" .
           "Pattern: 'goodbye' -> 'farewell'`n" .
           "Result: " . result . "`n" .
           "Replacements made: " . count . " (no match)"

    ; Replace digits
    text := "Room 123, Floor 4, Building 56"
    result := RegExReplace(text, "\d+", "XXX")

    MsgBox "Original: " . text . "`n" .
           "Pattern: \\d+ -> 'XXX'`n" .
           "Result: " . result . "`n" .
           "(All numbers replaced)"

    ; Replace special characters
    text := "Hello! How are you? I'm fine."
    result := RegExReplace(text, "[!?.]", "")

    MsgBox "Original: " . text . "`n" .
           "Pattern: [!?.] -> '' (remove)`n" .
           "Result: " . result

    ; Replace whitespace
    text := "Multiple    spaces   and`ttabs`nand newlines"
    result := RegExReplace(text, "\s+", " ")

    MsgBox "Original: " . text . "`n" .
           "Pattern: \\s+ -> ' '`n" .
           "Result: " . result . "`n" .
           "(Normalize whitespace)"
}

; ========================================
; EXAMPLE 2: Case-Insensitive Replacement
; ========================================
; Using 'i' option for case-insensitive replacement
Example2_CaseInsensitive() {
    MsgBox "EXAMPLE 2: Case-Insensitive Replacement`n" .
           "========================================="

    ; Case-sensitive (default)
    text := "HTML html Html HtMl"
    result := RegExReplace(text, "html", "XML")

    MsgBox "Case-Sensitive:`n" .
           "Original: " . text . "`n" .
           "Pattern: 'html' -> 'XML'`n" .
           "Result: " . result . "`n" .
           "(Only exact match replaced)"

    ; Case-insensitive with 'i' option
    result := RegExReplace(text, "i)html", "XML", &count)

    MsgBox "Case-Insensitive:`n" .
           "Original: " . text . "`n" .
           "Pattern: 'i)html' -> 'XML'`n" .
           "Result: " . result . "`n" .
           "Replacements: " . count

    ; Practical: Normalize file extensions
    files := "image.JPG photo.jpg picture.Jpg snapshot.JPEG"
    result := RegExReplace(files, "i)\.jpe?g\b", ".jpg")

    MsgBox "Normalize Extensions:`n" .
           "Original: " . files . "`n" .
           "Result: " . result . "`n" .
           "(All JPEG extensions normalized to .jpg)"

    ; Replace color names
    css := "color: RED; background: Blue; border: GREEN;"
    result := RegExReplace(css, "i)\bred\b", "#FF0000")
    result := RegExReplace(result, "i)\bblue\b", "#0000FF")
    result := RegExReplace(result, "i)\bgreen\b", "#00FF00")

    MsgBox "Color Name to Hex:`n" .
           "Original: " . css . "`n" .
           "Result: " . result

    ; Remove HTML tags (case-insensitive)
    html := "<DIV>Text in <span>mixed</SPAN> case <BR> tags</div>"
    result := RegExReplace(html, "i)<[^>]+>", "")

    MsgBox "Remove HTML Tags:`n" .
           "Original: " . html . "`n" .
           "Result: " . result

    ; Fix capitalization variations
    text := "the THE The tHe"
    result := RegExReplace(text, "i)\bthe\b", "the")

    MsgBox "Normalize Capitalization:`n" .
           "Original: " . text . "`n" .
           "Result: " . result . "`n" .
           "(All variations of 'the' normalized)"
}

; ========================================
; EXAMPLE 3: Limiting Replacements
; ========================================
; Using the limit parameter to control replacement count
Example3_LimitingReplacements() {
    MsgBox "EXAMPLE 3: Limiting Replacements`n" .
           "================================="

    ; Replace only first occurrence
    text := "test test test test test"

    result1 := RegExReplace(text, "test", "DEMO", &count1, 1)
    MsgBox "Limit = 1 (replace first only):`n" .
           "Original: " . text . "`n" .
           "Result: " . result1 . "`n" .
           "Replacements: " . count1

    ; Replace first 3 occurrences
    result3 := RegExReplace(text, "test", "DEMO", &count3, 3)
    MsgBox "Limit = 3 (replace first three):`n" .
           "Original: " . text . "`n" .
           "Result: " . result3 . "`n" .
           "Replacements: " . count3

    ; Replace all (default, limit = -1)
    resultAll := RegExReplace(text, "test", "DEMO", &countAll, -1)
    MsgBox "Limit = -1 (replace all):`n" .
           "Original: " . text . "`n" .
           "Result: " . resultAll . "`n" .
           "Replacements: " . countAll

    ; Practical: Replace first N errors
    log := "ERROR: Issue 1`nWARNING: Alert`nERROR: Issue 2`nERROR: Issue 3"

    fixed1 := RegExReplace(log, "ERROR", "FIXED", , 1)
    MsgBox "Fix First Error:`n" .
           "Original:`n" . log . "`n`n" .
           "After fixing first:`n" . fixed1

    fixed2 := RegExReplace(log, "ERROR", "FIXED", , 2)
    MsgBox "Fix First Two Errors:`n" .
           "Original:`n" . log . "`n`n" .
           "After fixing first two:`n" . fixed2

    ; Replace until condition
    numbers := "1 2 3 4 5 6 7 8 9 10"

    ; Replace first 5 numbers with X
    result := RegExReplace(numbers, "\d+", "X", , 5)
    MsgBox "Replace First 5 Numbers:`n" .
           "Original: " . numbers . "`n" .
           "Result: " . result

    ; Practical: Redact first N occurrences
    text := "My SSN is 123-45-6789 and my friend's is 987-65-4321"

    redacted := RegExReplace(text, "\d{3}-\d{2}-\d{4}", "XXX-XX-XXXX", , 1)
    MsgBox "Redact First SSN Only:`n" .
           "Original: " . text . "`n" .
           "Redacted: " . redacted
}

; ========================================
; EXAMPLE 4: Removing Text
; ========================================
; Using empty replacement to remove text
Example4_RemovingText() {
    MsgBox "EXAMPLE 4: Removing Text`n" .
           "========================="

    ; Remove specific words
    text := "The quick brown fox jumps"
    result := RegExReplace(text, "brown ", "")

    MsgBox "Remove Word:`n" .
           "Original: " . text . "`n" .
           "Result: " . result

    ; Remove all digits
    text := "Order #12345 for $67.89"
    result := RegExReplace(text, "\d", "")

    MsgBox "Remove All Digits:`n" .
           "Original: " . text . "`n" .
           "Result: " . result

    ; Remove special characters
    text := "Hello! How are you? I'm fine."
    result := RegExReplace(text, "[!?'.]", "")

    MsgBox "Remove Punctuation:`n" .
           "Original: " . text . "`n" .
           "Result: " . result

    ; Remove HTML tags
    html := "<p>This is <b>bold</b> and <i>italic</i> text.</p>"
    result := RegExReplace(html, "<[^>]+>", "")

    MsgBox "Remove HTML Tags:`n" .
           "Original: " . html . "`n" .
           "Result: " . result

    ; Remove extra whitespace
    text := "Too    many     spaces"
    result := RegExReplace(text, " +", " ")

    MsgBox "Remove Extra Spaces:`n" .
           "Original: " . text . "`n" .
           "Result: " . result

    ; Remove leading/trailing whitespace
    text := "   Trim me   "
    result := RegExReplace(text, "^\s+|\s+$", "")

    MsgBox "Trim Whitespace:`n" .
           "Original: '" . text . "'`n" .
           "Result: '" . result . "'"

    ; Remove comments from code
    code := "var x = 5; // This is a comment`nvar y = 10; // Another comment"
    result := RegExReplace(code, "//.*", "")

    MsgBox "Remove Comments:`n" .
           "Original:`n" . code . "`n`n" .
           "Result:`n" . result

    ; Remove duplicate spaces
    text := "One  two   three    four"
    result := RegExReplace(text, "\s+", " ")

    MsgBox "Normalize Spaces:`n" .
           "Original: " . text . "`n" .
           "Result: " . result

    ; Remove non-alphanumeric
    text := "User@Name#123!"
    result := RegExReplace(text, "[^a-zA-Z0-9]", "")

    MsgBox "Keep Alphanumeric Only:`n" .
           "Original: " . text . "`n" .
           "Result: " . result
}

; ========================================
; EXAMPLE 5: Pattern-Based Transformations
; ========================================
; Common text transformation patterns
Example5_Transformations() {
    MsgBox "EXAMPLE 5: Pattern-Based Transformations`n" .
           "========================================="

    ; Convert underscores to spaces
    text := "hello_world_test_case"
    result := RegExReplace(text, "_", " ")

    MsgBox "Underscores to Spaces:`n" .
           "Original: " . text . "`n" .
           "Result: " . result

    ; Convert spaces to hyphens (URL slugify basic)
    text := "This is a Title"
    result := RegExReplace(text, " ", "-")

    MsgBox "Spaces to Hyphens:`n" .
           "Original: " . text . "`n" .
           "Result: " . result

    ; Normalize line endings (CRLF to LF)
    text := "Line1`r`nLine2`r`nLine3"
    result := RegExReplace(text, "`r`n", "`n")

    MsgBox "CRLF to LF:`n" .
           "Converted Windows line endings to Unix"

    ; Remove duplicate words
    text := "The the quick quick brown fox"
    result := RegExReplace(text, "\b(\w+)\s+\1\b", "$1")

    MsgBox "Remove Duplicate Words:`n" .
           "Original: " . text . "`n" .
           "Result: " . result

    ; Mask credit card (show last 4)
    card := "1234-5678-9012-3456"
    result := RegExReplace(card, "\d(?=\d{4})", "*")

    MsgBox "Mask Credit Card:`n" .
           "Original: " . card . "`n" .
           "Result: " . result

    ; Censor profanity (simple)
    text := "This damn thing is broken"
    result := RegExReplace(text, "i)\b(damn|hell|crap)\b", "****")

    MsgBox "Censor Words:`n" .
           "Original: " . text . "`n" .
           "Result: " . result

    ; Convert tabs to spaces
    text := "Column1`tColumn2`tColumn3"
    result := RegExReplace(text, "\t", "    ")  ; 4 spaces

    MsgBox "Tabs to Spaces:`n" .
           "Original: " . text . "`n" .
           "Result: " . result

    ; Remove multiple newlines
    text := "Paragraph 1`n`n`n`nParagraph 2"
    result := RegExReplace(text, "\n{3,}", "`n`n")

    MsgBox "Normalize Line Breaks:`n" .
           "Original: (multiple newlines)`n" .
           "Result: (max 2 newlines)"

    ; Obfuscate email
    email := "user@example.com"
    result := RegExReplace(email, "@", " [at] ")
    result := RegExReplace(result, "\.", " [dot] ")

    MsgBox "Obfuscate Email:`n" .
           "Original: " . email . "`n" .
           "Result: " . result
}

; ========================================
; EXAMPLE 6: Replacement Count Usage
; ========================================
; Using the count parameter effectively
Example6_ReplacementCount() {
    MsgBox "EXAMPLE 6: Replacement Count Usage`n" .
           "==================================="

    ; Count and report replacements
    text := "The cat and the dog and the bird"
    result := RegExReplace(text, "\bthe\b", "a", &count)

    MsgBox "Replacement Statistics:`n" .
           "Original: " . text . "`n" .
           "Result: " . result . "`n" .
           "Replacements made: " . count

    ; Conditional logic based on count
    ProcessText(input) {
        output := RegExReplace(input, "error", "warning", &count)

        if count = 0
            return Map("result", output, "message", "No errors found")
        else if count = 1
            return Map("result", output, "message", "1 error fixed")
        else
            return Map("result", output, "message", count . " errors fixed")
    }

    tests := [
        "All good here",
        "One error occurred",
        "Multiple error and error messages"
    ]

    result := "Processing Results:`n`n"
    for test in tests {
        processed := ProcessText(test)
        result .= "Input: " . test . "`n" .
                  "Result: " . processed["result"] . "`n" .
                  "Message: " . processed["message"] . "`n`n"
    }
    MsgBox result

    ; Count replacements per pattern
    text := "Contact: user@example.com or admin@test.org"

    emailCount := 0
    result := RegExReplace(text, "\b\w+@\w+\.\w+\b", "[EMAIL]", &emailCount)

    MsgBox "Email Detection:`n" .
           "Original: " . text . "`n" .
           "Result: " . result . "`n" .
           "Emails found: " . emailCount

    ; Validation through replacement count
    ValidateFormat(input, pattern, expectedCount) {
        RegExReplace(input, pattern, "", &count)
        return count = expectedCount
    }

    ; Expect exactly 3 numbers separated by dots (version number)
    version := "1.2.3"
    isValid := ValidateFormat(version, "\d+", 3)

    MsgBox "Version Validation:`n" .
           "Input: " . version . "`n" .
           "Valid format: " . (isValid ? "Yes" : "No")

    ; Track multiple replacement operations
    log := "ERROR: Issue 1`nERROR: Issue 2`nWARNING: Alert"

    totalFixed := 0
    result := RegExReplace(log, "ERROR", "RESOLVED", &errCount)
    totalFixed += errCount

    result := RegExReplace(result, "WARNING", "NOTED", &warnCount)
    totalFixed += warnCount

    MsgBox "Multi-Pattern Replacement:`n" .
           "Errors fixed: " . errCount . "`n" .
           "Warnings addressed: " . warnCount . "`n" .
           "Total replacements: " . totalFixed
}

; ========================================
; EXAMPLE 7: Common Use Cases
; ========================================
; Real-world replacement scenarios
Example7_CommonUseCases() {
    MsgBox "EXAMPLE 7: Common Use Cases`n" .
           "============================"

    ; Clean filename
    CleanFilename(name) {
        ; Remove invalid characters
        result := RegExReplace(name, '[<>:"/\\|?*]', "")
        ; Remove multiple spaces
        result := RegExReplace(result, " +", " ")
        ; Trim
        result := RegExReplace(result, "^\s+|\s+$", "")
        return result
    }

    dirtyName := 'File: "Name" <Test> | Version 2.0'
    cleanName := CleanFilename(dirtyName)

    MsgBox "Clean Filename:`n" .
           "Original: " . dirtyName . "`n" .
           "Cleaned: " . cleanName

    ; Format phone number
    FormatPhone(number) {
        ; Remove all non-digits
        digits := RegExReplace(number, "\D", "")

        ; Format as (XXX) XXX-XXXX
        if StrLen(digits) = 10
            return "(" . SubStr(digits, 1, 3) . ") " .
                   SubStr(digits, 4, 3) . "-" .
                   SubStr(digits, 7, 4)
        return number  ; Return as-is if invalid
    }

    phones := ["5551234567", "555-123-4567", "(555) 123-4567"]
    result := "Phone Formatting:`n"
    for phone in phones {
        result .= phone . " -> " . FormatPhone(phone) . "`n"
    }
    MsgBox result

    ; Sanitize user input
    SanitizeInput(input) {
        ; Remove HTML tags
        result := RegExReplace(input, "<[^>]+>", "")
        ; Remove script tags and content
        result := RegExReplace(result, "i)<script.*?</script>", "")
        ; Remove excessive whitespace
        result := RegExReplace(result, "\s+", " ")
        ; Trim
        result := RegExReplace(result, "^\s+|\s+$", "")
        return result
    }

    userInput := "  Hello <b>World</b> <script>alert('xss')</script>  "
    sanitized := SanitizeInput(userInput)

    MsgBox "Sanitize Input:`n" .
           "Original: " . userInput . "`n" .
           "Sanitized: " . sanitized

    ; Convert markdown bold to HTML
    markdown := "This is **bold** and this is **also bold** text"
    html := RegExReplace(markdown, "\*\*([^*]+)\*\*", "<b>$1</b>")

    MsgBox "Markdown to HTML:`n" .
           "Markdown: " . markdown . "`n" .
           "HTML: " . html

    ; Extract and normalize URLs
    text := "Visit example.com or https://test.org or www.site.net"
    normalized := RegExReplace(text, "\b(www\.|(?:https?://)?)([a-z0-9.-]+)", "https://$2")

    MsgBox "Normalize URLs:`n" .
           "Original: " . text . "`n" .
           "Result: " . normalized

    ; Redact sensitive data
    log := "User john.doe logged in with password secret123"
    redacted := RegExReplace(log, "\bpassword \w+", "password [REDACTED]")

    MsgBox "Redact Sensitive Data:`n" .
           "Original: " . log . "`n" .
           "Redacted: " . redacted
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
    RegExReplace Basic Usage
    ========================

    1. Basic Replacement
    2. Case-Insensitive Replacement
    3. Limiting Replacements
    4. Removing Text
    5. Pattern-Based Transformations
    6. Replacement Count Usage
    7. Common Use Cases

    Press Ctrl+1-7 to run examples
    )"

    MsgBox menu
}

^1::Example1_BasicReplacement()
^2::Example2_CaseInsensitive()
^3::Example3_LimitingReplacements()
^4::Example4_RemovingText()
^5::Example5_Transformations()
^6::Example6_ReplacementCount()
^7::Example7_CommonUseCases()

^h::ShowMenu()

ShowMenu()
