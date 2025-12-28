#Requires AutoHotkey v2.0

/**
 * BuiltIn_RegEx_Match_05_Advanced.ahk
 * 
 * DESCRIPTION:
 * Advanced RegExMatch techniques including lookaheads, lookbehinds, backreferences,
 * atomic groups, recursion, conditional patterns, and performance optimization.
 * Covers complex real-world scenarios and edge cases.
 * 
 * FEATURES:
 * - Positive and negative lookaheads (?=...) (?!...)
 * - Positive and negative lookbehinds (?<=...) (?<!...)
 * - Backreferences \1, \2, etc.
 * - Named backreferences
 * - Atomic groups (?>...)
 * - Conditional patterns (?(condition)yes|no)
 * - Performance optimization techniques
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - RegEx
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Advanced PCRE features
 * - Complex pattern composition
 * - Performance considerations
 * - Memory-efficient matching
 * - Error handling for complex patterns
 * 
 * LEARNING POINTS:
 * 1. Lookaheads check ahead without consuming characters
 * 2. Lookbehinds check behind the current position
 * 3. Backreferences match the same text as a previous group
 * 4. Atomic groups prevent backtracking for performance
 * 5. Conditionals allow if-then-else logic in patterns
 * 6. Pattern complexity affects performance significantly
 * 7. Sometimes multiple simple matches are faster than one complex match
 */

; ========================================
; EXAMPLE 1: Lookahead Assertions
; ========================================
; Using (?=...) and (?!...) for lookahead
Example1_Lookaheads() {
    MsgBox "EXAMPLE 1: Lookahead Assertions`n" .
        "================================"

    ; Positive lookahead (?=...)
    ; Match "window" only if followed by "s"
    text1 := "window windows windowed"

    matches := []
    pos := 1
    while (pos := RegExMatch(text1, "window(?=s)", &match, pos)) {
        matches.Push(match[0])
        pos := match.Pos + match.Len
    }

    MsgBox "Positive lookahead (?=...):`n" .
        "Pattern: window(?=s)`n" .
        "Matches 'window' only if followed by 's':`n" .
        StrJoin(matches, ", ") . "`n" .
        "(Note: 's' is not included in match)"

    ; Negative lookahead (?!...)
    ; Match "window" only if NOT followed by "s"
    matches := []
    pos := 1
    while (pos := RegExMatch(text1, "window(?!s)", &match, pos)) {
        matches.Push(match[0])
        pos := match.Pos + match.Len
    }

    MsgBox "Negative lookahead (?!...):`n" .
        "Pattern: window(?!s)`n" .
        "Matches 'window' NOT followed by 's':`n" .
        StrJoin(matches, ", ")

    ; Password validation with lookaheads
    ValidatePassword(pass) {
        ; Must have: length 8+, uppercase, lowercase, digit, special char
        hasLength := StrLen(pass) >= 8
        hasUpper := RegExMatch(pass, "(?=.*[A-Z])")
        hasLower := RegExMatch(pass, "(?=.*[a-z])")
        hasDigit := RegExMatch(pass, "(?=.*\d)")
        hasSpecial := RegExMatch(pass, "(?=.*[!@#$%^&*])")

        return Map(
            "valid", hasLength && hasUpper && hasLower && hasDigit && hasSpecial,
            "length", hasLength,
            "upper", hasUpper,
            "lower", hasLower,
            "digit", hasDigit,
            "special", hasSpecial
        )
    }

    passwords := ["weak", "Strong1", "Strong1!", "VerySecure123!"]

    result := "Password Validation:`n"
    for pass in passwords {
        v := ValidatePassword(pass)
        result .= pass . ": " . (v["valid"] ? "Valid" : "Invalid") . "`n"
        if !v["valid"] {
            missing := []
            if !v["length"], missing.Push("length")
                if !v["upper"], missing.Push("uppercase")
                    if !v["lower"], missing.Push("lowercase")
                        if !v["digit"], missing.Push("digit")
                            if !v["special"], missing.Push("special")
                                result .= "  Missing: " . StrJoin(missing, ", ") . "`n"
        }
    }
    MsgBox result

    ; Extract numbers not followed by units
    text2 := "5 apples, 10kg, 15 oranges, 20cm, 25"

    numbersWithoutUnits := []
    pos := 1
    while (pos := RegExMatch(text2, "\d+(?![a-z])", &match, pos)) {
        numbersWithoutUnits.Push(match[0])
        pos := match.Pos + match.Len
    }

    MsgBox "Numbers without units:`n" . StrJoin(numbersWithoutUnits, ", ")

    ; Multiple lookaheads (all must match)
    text3 := "test123"
    pattern := "^(?=.*[a-z])(?=.*\d)[a-z\d]+$"

    MsgBox "String: " . text3 . "`n" .
        "Pattern requires both letters AND digits:`n" .
        (RegExMatch(text3, pattern) ? "Valid" : "Invalid")
}

; ========================================
; EXAMPLE 2: Lookbehind Assertions
; ========================================
; Using (?<=...) and (?<!...) for lookbehind
Example2_Lookbehinds() {
    MsgBox "EXAMPLE 2: Lookbehind Assertions`n" .
        "================================="

    ; Positive lookbehind (?<=...)
    ; Match currency amounts (number after $)
    text1 := "Price: $19.99, Cost: €15.50, Value: $50.00"

    prices := []
    pos := 1
    while (pos := RegExMatch(text1, "(?<=\$)\d+\.\d+", &match, pos)) {
        prices.Push(match[0])
        pos := match.Pos + match.Len
    }

    MsgBox "Positive lookbehind (?<=...):`n" .
        "Pattern: (?<=\\$)\\d+\\.\\d+`n" .
        "Matches numbers preceded by $:`n" .
        StrJoin(prices, ", ")

    ; Negative lookbehind (?<!...)
    ; Match words NOT preceded by "not "
    text2 := "I like apples but not oranges and not bananas"

    liked := []
    pos := 1
    while (pos := RegExMatch(text2, "(?<!not )(apples|oranges|bananas)", &match, pos)) {
        liked.Push(match[0])
        pos := match.Pos + match.Len
    }

    MsgBox "Negative lookbehind (?<!...):`n" .
        "Pattern: (?<!not )(apples|oranges|bananas)`n" .
        "Fruits NOT preceded by 'not ':`n" .
        StrJoin(liked, ", ")

    ; Extract file names without path
    paths := [
        "C:\Folder\file.txt",
        "/home/user/document.pdf",
        ".\local\image.jpg"
    ]

    result := "Filenames (lookbehind removes path):`n"
    for path in paths {
        if RegExMatch(path, "(?<=[/\\])[^/\\]+$", &match)
            result .= match[0] . "`n"
    }
    MsgBox result

    ; Combining lookahead and lookbehind
    ; Extract word between square brackets
    text3 := "Normal text [special] more text [another]"

    bracketed := []
    pos := 1
    while (pos := RegExMatch(text3, "(?<=\[)\w+(?=\])", &match, pos)) {
        bracketed.Push(match[0])
        pos := match.Pos + match.Len
    }

    MsgBox "Combined lookahead + lookbehind:`n" .
        "Pattern: (?<=\\[)\\w+(?=\\])`n" .
        "Words between brackets:`n" .
        StrJoin(bracketed, ", ")

    ; Extract @mentions but not email addresses
    text4 := "Contact @john or email john@example.com or @jane"

    mentions := []
    pos := 1
    while (pos := RegExMatch(text4, "(?<![\w.])@\w+", &match, pos)) {
        mentions.Push(match[0])
        pos := match.Pos + match.Len
    }

    MsgBox "@ mentions (not email):`n" . StrJoin(mentions, ", ")

    ; Variable-length lookbehind (PCRE2 feature)
    log := "INFO: Message 1`nERROR: Message 2`nWARNING: Message 3"

    messages := []
    pos := 1
    while (pos := RegExMatch(log, "(?<=ERROR: ).+", &match, pos)) {
        messages.Push(match[0])
        pos := match.Pos + match.Len
    }

    MsgBox "Messages after ERROR:`n" . StrJoin(messages, "`n")
}

; ========================================
; EXAMPLE 3: Backreferences
; ========================================
; Using \1, \2 to match previously captured text
Example3_Backreferences() {
    MsgBox "EXAMPLE 3: Backreferences`n" .
        "========================="

    ; Find repeated words
    text1 := "This is is a test test of repeated repeated words words"

    repeated := []
    pos := 1
    while (pos := RegExMatch(text1, "\b(\w+)\s+\1\b", &match, pos)) {
        repeated.Push(match[1])
        pos := match.Pos + match.Len
    }

    MsgBox "Backreference \\1:`n" .
        "Pattern: \\b(\\w+)\\s+\\1\\b`n" .
        "Finds repeated words:`n" .
        StrJoin(repeated, ", ")

    ; Match HTML-like tags
    html := "<div>Content</div> <span>Text</span> <div>Wrong</span>"

    ; Match opening and closing tags that match
    validTags := []
    pos := 1
    while (pos := RegExMatch(html, "<(\w+)>.*?</\1>", &match, pos)) {
        validTags.Push(match[0])
        pos := match.Pos + match.Len
    }

    MsgBox "Matching HTML tags (backreference):`n" .
        StrJoin(validTags, "`n")

    ; Find quoted strings (same quote type)
    text2 := "He said 'Hello' and she said `"World`""

    quotes := []
    pos := 1
    while (pos := RegExMatch(text2, "(['\"`]). * ? \1 ", &match, pos)) {
        quotes.Push(match[0])
        pos := match.Pos + match.Len
            }
        MsgBox "Quoted strings (matching quotes):`n" .
            StrJoin(quotes, "`n")

    ; Named backreferences
    text3 := "<b>Bold</b> <i>Italic</i> <b>Wrong</i>"

    pattern := "<(?P<tag>\w+)>.*?</(?P=tag)>"

    validTags := []
    pos := 1
    while (pos := RegExMatch(text3, pattern, &match, pos)) {
        validTags.Push(match[0] . " (tag: " . match["tag"] . ")")
        pos := match.Pos + match.Len
    }

    MsgBox "Named backreferences (?P=tag):`n" .
        StrJoin(validTags, "`n")

    ; Palindrome detection (simplified)
    DetectPalindrome(word) {
        len := StrLen(word)
        if len <= 1
            return true

        ; Build pattern dynamically for short words
        if len <= 5 {
            pattern := "^(\w)"
            if len >= 3
                pattern .= "(\w)"
            if len >= 5
                pattern .= "(\w)"

            pattern .= "\w?"  ; Middle char (odd length)

            if len >= 5
                pattern .= "\3"
            if len >= 3
                pattern .= "\2"
            pattern .= "\1$"

            return RegExMatch(word, pattern) ? true : false
        }
        return false
    }

    words := ["radar", "level", "hello", "noon", "test"]
    result := "Palindrome Detection:`n"
    for word in words {
        result .= word . ": " . (DetectPalindrome(word) ? "Palindrome" : "Not palindrome") . "`n"
    }
    MsgBox result

    ; Find duplicate consecutive characters
    text4 := "Hello, Wooorld! Goood mooooorning!"

    duplicates := []
    pos := 1
    while (pos := RegExMatch(text4, "(\w)\1+", &match, pos)) {
        duplicates.Push(match[0])
        pos := match.Pos + match.Len
    }

    MsgBox "Duplicate consecutive characters:`n" .
        StrJoin(duplicates, ", ")
}

; ========================================
; EXAMPLE 4: Atomic Groups
; ========================================
; Using (?>...) to prevent backtracking
Example4_AtomicGroups() {
    MsgBox "EXAMPLE 4: Atomic Groups`n" .
        "========================="

    ; Performance comparison: with and without atomic groups
    text := "aaaaaaaaaaaaaaaaaaaaab"  ; Many 'a's followed by 'b'

    ; Regular pattern (backtracks)
    pattern1 := "a+b"
    start := A_TickCount
    result1 := RegExMatch(text, pattern1)
    time1 := A_TickCount - start

    ; Atomic group (no backtracking)
    pattern2 := "(?>a+)b"
    start := A_TickCount
    result2 := RegExMatch(text, pattern2)
    time2 := A_TickCount - start

    MsgBox "Performance Test:`n" .
        "Pattern a+b: " . time1 . "ms (Result: " . result1 . ")`n" .
        "Pattern (?>a+)b: " . time2 . "ms (Result: " . result2 . ")`n`n" .
        "Atomic groups can improve performance!"

    ; Practical use: efficient word boundaries
    text2 := "The quick brown fox jumps"

    ; Without atomic group
    pattern1 := "\b\w+\b"

    ; With atomic group (more efficient)
    pattern2 := "\b(?>\w+)\b"

    words := []
    pos := 1
    while (pos := RegExMatch(text2, pattern2, &match, pos)) {
        words.Push(match[0])
        pos := match.Pos + match.Len
    }

    MsgBox "Words extracted with atomic group:`n" .
        StrJoin(words, ", ")

    ; Atomic groups prevent unwanted matches
    text3 := "test123abc"

    ; Regular group might backtrack
    if RegExMatch(text3, "(\w+)\d+", &match)
        MsgBox "Regular group: " . match[0] . " (captured: " . match[1] . ")"

    ; Atomic group commits immediately
    if RegExMatch(text3, "(?>test)\d+", &match)
        MsgBox "Atomic group: " . match[0]

    ; Efficient number parsing
    numbers := "123.456.789"

    parsed := []
    pos := 1
    while (pos := RegExMatch(numbers, "(?>\d+)", &match, pos)) {
        parsed.Push(match[0])
        pos := match.Pos + match.Len
    }

    MsgBox "Numbers parsed efficiently:`n" . StrJoin(parsed, ", ")
}

; ========================================
; EXAMPLE 5: Conditional Patterns
; ========================================
; Using (?(condition)yes|no) for if-then-else
Example5_ConditionalPatterns() {
    MsgBox "EXAMPLE 5: Conditional Patterns`n" .
        "================================"

    ; Match optional area code in phone numbers
    ; If starts with (, must end with )
    pattern := "^(\()?\d{3}(?(1)\))\s?\d{3}-\d{4}$"

    phones := [
        "(555) 123-4567",  ; Valid: has both parens
        "555 123-4567",    ; Valid: no parens
        "(555 123-4567",   ; Invalid: opening paren only
        "555) 123-4567"    ; Invalid: closing paren only
    ]

    result := "Phone Number Validation (conditional):`n"
    for phone in phones {
        result .= phone . ": " .
            (RegExMatch(phone, pattern) ? "Valid" : "Invalid") . "`n"
    }
    MsgBox result

    ; Optional protocol in URL
    ; If has protocol, must have ://
    pattern := "^(https?://)?(?(1)[\w.-]+|[\w.-]+)$"

    urls := [
        "https://example.com",
        "example.com",
        "http://",
        "://example.com"
    ]

    result := "URL Validation (conditional):`n"
    for url in urls {
        result .= url . ": " .
            (RegExMatch(url, pattern) ? "Valid" : "Invalid") . "`n"
    }
    MsgBox result

    ; Named group conditionals
    pattern := "(?P<quote>['\"` "])?(?P<content>\w+)(?(quote)(?P=quote))"

    texts := ["'quoted'", "`"quoted`"", "unquoted", "'unclosed"]

    result := "Quote Matching (named conditional):`n"
    for text in texts {
        if RegExMatch(text, pattern, &match)
            result .= text . ": Valid (content: " . match["content"] . ")`n"
        else
            result .= text . ": Invalid`n"
    }
    MsgBox result

    ; Conditional for different formats
    ; Match either "Name: Value" or just "Value"
    pattern := "^(Name: )?(?(1)\w+|\w+)$"

    inputs := ["Name: John", "John", "Name:", ": John"]

    result := "Format Validation:`n"
    for input in inputs {
        result .= input . ": " .
            (RegExMatch(input, pattern) ? "Valid" : "Invalid") . "`n"
    }
    MsgBox result
}

; ========================================
; EXAMPLE 6: Complex Real-World Patterns
; ========================================
; Combining multiple advanced techniques
Example6_ComplexPatterns() {
    MsgBox "EXAMPLE 6: Complex Real-World Patterns`n" .
        "======================================"

    ; Advanced email validation
    EmailPattern := "
    (x)
    ^
    ( ? = [a - zA - Z0 - 9@._%+-] { 6, 254 }$)#Length check via lookahead
        ( ? = [a - zA - Z0 - 9._%+-] { 1, 64 }@)#Local part length check
            [a - zA - Z0 - 9._%+-] + #Local part@
                ( ? = . { 1, 253 }$)#Domain length check
                    ( ? : [a - zA - Z0 - 9]( ? : [a - zA - Z0 - 9 -] { 0, 61 }[a - zA - Z0 - 9]) ? \.) +
                        [a - zA - Z] { 2, 63 }#TLD$
                        ) "
                        emails := [
                            "user@example.com",
                            "user.name+tag@example.co.uk",
                            "invalid@",
                            "@invalid.com",
                            "toolong" . StrRepeat("x", 100) . "@example.com"
                        ]
                        result := "Advanced Email Validation:`n"
                        for email in emails {
                            result .= email . ": " .
                                (RegExMatch(email, EmailPattern) ? "Valid" : "Invalid") . "`n"
                        }
                        MsgBox result
                        ; Password strength meter
                        CheckPasswordStrength(pass) {
                            score := 0
                            feedback := []

                            ; Length points
                            len := StrLen(pass)
                            if len >= 8
                                score += 1, feedback.Push("✓ Length 8+")
                            else
                                feedback.Push("✗ Too short")

                            if len >= 12
                                score += 1, feedback.Push("✓ Length 12+")

                            ; Character variety
                            if RegExMatch(pass, "[a-z]")
                                score += 1, feedback.Push("✓ Lowercase")
                            if RegExMatch(pass, "[A-Z]")
                                score += 1, feedback.Push("✓ Uppercase")
                            if RegExMatch(pass, "\d")
                                score += 1, feedback.Push("✓ Numbers")
                            if RegExMatch(pass, "[!@#$%^&*()_+\-=\[\]{};':\"\\ |, . < > / ?] ")
                                score += 1, feedback.Push("✓ Special chars")
                                ; Complexity patterns
                                if RegExMatch(pass, "(?=.*[a-z])(?=.*[A-Z])(?=.*\d)")
                                    score += 1, feedback.Push("✓ Good mix")
                                        ; Penalties
                                if RegExMatch(pass, "(\w)\1{2,}")
                                    score -= 1, feedback.Push("✗ Repeated chars")
                                if RegExMatch(pass, "i)(password|123456|qwerty)")
                                    score -= 2, feedback.Push("✗ Common password")
                                        strength := "Weak"
                                if score >= 6
                                    strength := "Strong"
                                else if score >= 4
                                    strength := "Medium"
                                return Map("score", score, "strength", strength, "feedback", feedback)
                            }
                                passwords := ["pass", "Password1", "MyP@ssw0rd123", "Str0ng!P@ssw0rd"]

                            result := "Password Strength Analysis:`n`n"
                            for pass in passwords {
                                analysis := CheckPasswordStrength(pass)
                                result .= pass . ": " . analysis["strength"] . " (Score: " . analysis["score"] . ")`n"
                                for fb in analysis["feedback"] {
                                    result .= "  " . fb . "`n"
                                }
                                result .= "`n"
                            }
                            MsgBox result

                            ; Advanced log parser
                            logLine := '192.168.1.100 - admin [15/Jan/2024:10:30:45 +0000] "GET /api/users?id=123 HTTP/1.1" 200 1234 "https://example.com" "Mozilla/5.0"'

                            pattern := '
                            (x)
                            ( ? P < ip > [\d.] +)#IP address\s - \s
                                ( ? P < user > \w +)#Username\s\[
                                    ( ? P < timestamp > [ ^ \]] +)#Timestamp\]\s "
                                    ( ? P < method > \w +)#HTTP method\s
                                        ( ? P < path > \S +)#Request path\s
                                            ( ? P < protocol > [ ^ "]+)                     # Protocol
                                                " \s
                                                ( ? P < status > \d +)#Status code\s
                                                    ( ? P < size > \d +)#Response size
                                                        ( ? : \s "(?P<referrer>[^"]*) ")?          # Optional referrer
                                                        ( ? : \s "(?P<agent>[^"]*) ")?             # Optional user agent
                                                '
                                                if RegExMatch(logLine, pattern, &match) {
                                                    MsgBox "Log Entry Parsed:`n" .
                                                        "IP: " . match["ip"] . "`n" .
                                                        "User: " . match["user"] . "`n" .
                                                        "Timestamp: " . match["timestamp"] . "`n" .
                                                        "Method: " . match["method"] . "`n" .
                                                        "Path: " . match["path"] . "`n" .
                                                        "Status: " . match["status"] . "`n" .
                                                        "Size: " . match["size"] . " bytes"
                                                }
                                            }
                                                ; ========================================
                                                ; EXAMPLE 7: Performance Optimization
                                                ; ========================================
                                                ; Techniques for optimizing regex performance
                                                Example7_PerformanceOptimization() {
                                                    MsgBox "EXAMPLE 7: Performance Optimization`n" .
                                                        "===================================="

                                                    ; 1. Use anchors when possible
                                                    text := "test123test456test789"

                                                    MsgBox "Optimization Tip 1: Use Anchors`n" .
                                                        "Pattern: ^\w+ (anchored) is faster than \w+ (unanchored)`n" .
                                                        "Anchors prevent unnecessary searching"

                                                    ; 2. Use atomic groups to prevent backtracking
                                                    longText := StrRepeat("a", 50) . "b"

                                                    pattern1 := "a+b"       ; Can backtrack
                                                    pattern2 := "(?>a+)b"   ; Cannot backtrack

                                                    MsgBox "Optimization Tip 2: Atomic Groups`n" .
                                                        "Use (?>...) to prevent backtracking`n" .
                                                        "Especially important with quantifiers"

                                                    ; 3. Be specific instead of greedy
                                                    html := "<div>Content 1</div><div>Content 2</div>"

                                                    pattern1 := "<div>.*</div>"      ; Greedy, matches everything
                                                    pattern2 := "<div>.*?</div>"     ; Lazy, better
                                                    pattern3 := "<div>[^<]*</div>"   ; Most specific, fastest

                                                    MsgBox "Optimization Tip 3: Be Specific`n" .
                                                        "Pattern [^<]* is faster than .*?`n" .
                                                        "Use specific character classes when possible"

                                                    ; 4. Limit alternation
                                                    pattern1 := "cat|dog|bird|fish|mouse"  ; Slower
                                                    pattern2 := "(?:cat|dog|bird|fish|mouse)"  ; Better (non-capturing)
                                                    pattern3 := "[cdbfm](?:at|og|ird|ish|ouse)"  ; Even better if applicable

                                                    MsgBox "Optimization Tip 4: Optimize Alternation`n" .
                                                        "Use non-capturing groups`n" .
                                                        "Factor out common prefixes when possible"

                                                    ; 5. Use possessive quantifiers when applicable
                                                    text2 := "test123abc"

                                                    pattern1 := "\w+\d+"    ; Can backtrack
                                                    pattern2 := "\w++\d+"   ; Possessive, no backtrack

                                                    MsgBox "Optimization Tip 5: Possessive Quantifiers`n" .
                                                        "Use ++ instead of + when no backtracking needed`n" .
                                                        "Also: *+, ?+, {n,m}+"

                                                    ; 6. Compile patterns outside loops
                                                    testData := ["test1", "test2", "test3", "test4", "test5"]

                                                    MsgBox "Optimization Tip 6: Reuse Patterns`n" .
                                                        "Define pattern once, reuse in loop`n" .
                                                        "AutoHotkey caches patterns automatically"

                                                    ; 7. Use simple tests before complex regex
                                                    ValidateEmailOptimized(email) {
                                                        ; Quick checks first (faster than regex)
                                                        if !InStr(email, "@")
                                                            return false
                                                        if !InStr(email, ".")
                                                            return false
                                                        if StrLen(email) < 5
                                                            return false

                                                        ; Now run complex regex
                                                        return RegExMatch(email, "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                                    }

                                                    MsgBox "Optimization Tip 7: Pre-validate`n" .
                                                        "Use simple string checks before complex regex`n" .
                                                        "InStr() and StrLen() are much faster"

                                                    ; Performance summary
                                                    tips := "
    (
    REGEX PERFORMANCE TIPS:
    =======================

    1. Use anchors (^, $, \b) when possible
    2. Use atomic groups (?>...) to prevent backtracking
    3. Be specific: [^<]* instead of .*?
    4. Use non-capturing groups (?:...)
    5. Use possessive quantifiers (++, *+, ?+)
    6. Reuse compiled patterns
    7. Pre-validate with simple string functions
    8. Avoid nested quantifiers (e.g., (a+)+)
    9. Use character classes instead of alternation
    10. Profile and test with real data
    )"

                                                    MsgBox tips
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
                                                StrRepeat(str, count) {
                                                    result := ""
                                                    Loop count {
                                                        result .= str
                                                    }
                                                    return result
                                                }
                                                ; ========================================
                                                ; Main Menu
                                                ; ========================================
                                                ShowMenu() {
                                                    menu := "
    (
    RegExMatch Advanced Techniques
    ==============================

    1. Lookahead Assertions
    2. Lookbehind Assertions
    3. Backreferences
    4. Atomic Groups
    5. Conditional Patterns
    6. Complex Real-World Patterns
    7. Performance Optimization

    Press Ctrl+1-7 to run examples
    )"

                                                    MsgBox menu
                                                }
                                                ^1:: Example1_Lookaheads()
                                                ^2:: Example2_Lookbehinds()
                                                ^3:: Example3_Backreferences()
                                                ^4:: Example4_AtomicGroups()
                                                ^5:: Example5_ConditionalPatterns()
                                                ^6:: Example6_ComplexPatterns()
                                                ^7:: Example7_PerformanceOptimization()
                                                ^h:: ShowMenu()
                                                ShowMenu()
