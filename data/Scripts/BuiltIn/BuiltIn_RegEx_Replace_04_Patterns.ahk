#Requires AutoHotkey v2.0

/**
 * BuiltIn_RegEx_Replace_04_Patterns.ahk
 * 
 * DESCRIPTION:
 * Common replacement patterns for text transformation including URL slugification,
 * sanitization, formatting phone numbers, emails, dates, and other practical text
 * manipulation patterns.
 * 
 * FEATURES:
 * - URL slug creation
 * - Text sanitization and cleaning
 * - Phone number formatting
 * - Date/time reformatting
 * - Email obfuscation
 * - HTML entity encoding
 * - Common text transformations
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - RegEx
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Chained RegExReplace operations
 * - Complex pattern replacements
 * - Text normalization techniques
 * - Practical regex applications
 * - Multi-step transformations
 * 
 * LEARNING POINTS:
 * 1. Multiple replacements can be chained
 * 2. Order of replacements matters
 * 3. Pattern combinations solve complex problems
 * 4. Sanitization requires multiple steps
 * 5. Formatting often needs capture groups
 * 6. Case-insensitive options help normalization
 * 7. Testing edge cases is important
 */

; ========================================
; EXAMPLE 1: URL Slugification
; ========================================
Example1_URLSlug() {
    MsgBox "EXAMPLE 1: URL Slugification`n" .
        "============================="

    CreateSlug(text) {
        slug := StrLower(text)
        slug := RegExReplace(slug, "[àáâãäå]", "a")
        slug := RegExReplace(slug, "[èéêë]", "e")
        slug := RegExReplace(slug, "[ìíîï]", "i")
        slug := RegExReplace(slug, "[òóôõö]", "o")
        slug := RegExReplace(slug, "[ùúûü]", "u")
        slug := RegExReplace(slug, "[^a-z0-9]+", "-")
        slug := RegExReplace(slug, "^-|-$", "")
        return slug
    }

    titles := [
        "Hello World",
        "This is a Test!",
        "Café  Münchën",
        "Product #123 (New!)"
    ]

    result := "URL Slugs:`n"
    for title in titles {
        result .= title . "`n  -> " . CreateSlug(title) . "`n`n"
    }
    MsgBox result
}

; ========================================
; EXAMPLE 2: Text Sanitization
; ========================================
Example2_Sanitization() {
    MsgBox "EXAMPLE 2: Text Sanitization`n" .
        "============================="

    SanitizeHTML(text) {
        text := RegExReplace(text, "<script[^>]*>.*?</script>", "", , , 1)  ; Case-insensitive
        text := RegExReplace(text, "<[^>]+>", "")
        text := RegExReplace(text, "&lt;", "<")
        text := RegExReplace(text, "&gt;", ">")
        text := RegExReplace(text, "&amp;", "&")
        text := RegExReplace(text, "\s+", " ")
        return Trim(text)
    }

    dirty := '<p>Hello <b>World</b></p><script>alert("xss")</script>'
    clean := SanitizeHTML(dirty)

    MsgBox "HTML Sanitization:`n" .
        "Original: " . dirty . "`n" .
        "Sanitized: " . clean

    ; Sanitize filename
    SanitizeFilename(name) {
        name := RegExReplace(name, '[<>:"/\\|?*]', "")
        name := RegExReplace(name, "\s+", "_")
        name := RegExReplace(name, "_{2,}", "_")
        name := RegExReplace(name, "^_|_$", "")
        return name
    }

    files := ['File: "Test"', 'Path/To\\File', 'Name   With Spaces']
    result := "Filename Sanitization:`n"
    for file in files {
        result .= file . "`n  -> " . SanitizeFilename(file) . "`n"
    }
    MsgBox result
}

; ========================================
; EXAMPLE 3: Phone Number Formatting
; ========================================
Example3_PhoneFormatting() {
    MsgBox "EXAMPLE 3: Phone Number Formatting`n" .
        "===================================="

    FormatUSPhone(phone) {
        digits := RegExReplace(phone, "\D", "")

        if StrLen(digits) = 10
            return RegExReplace(digits, "(\d{3})(\d{3})(\d{4})", "($1) $2-$3")
        else if StrLen(digits) = 11 && SubStr(digits, 1, 1) = "1"
            return RegExReplace(digits, "1(\d{3})(\d{3})(\d{4})", "+1 ($1) $2-$3")
        return phone
    }

    phones := [
        "5551234567",
        "555-123-4567",
        "(555) 123-4567",
        "15551234567"
    ]

    result := "Phone Formatting:`n"
    for phone in phones {
        result .= phone . "`n  -> " . FormatUSPhone(phone) . "`n"
    }
    MsgBox result

    ; International format
    FormatInternational(phone) {
        phone := RegExReplace(phone, "^\+1\s*", "")  ; Remove +1
        phone := RegExReplace(phone, "[^\d]", "")     ; Keep only digits
        if StrLen(phone) = 10
            return RegExReplace(phone, "(\d{3})(\d{3})(\d{4})", "+1-$1-$2-$3")
        return phone
    }

    MsgBox "International Format:`n" .
        FormatUSPhone("5551234567") . "`n  -> " .
        FormatInternational("5551234567")
}

; ========================================
; EXAMPLE 4: Date Reformatting
; ========================================
Example4_DateFormatting() {
    MsgBox "EXAMPLE 4: Date Reformatting`n" .
        "============================="

    ; YYYY-MM-DD to MM/DD/YYYY
    ToUSDate(dateStr) {
        return RegExReplace(dateStr, "(\d{4})-(\d{2})-(\d{2})", "$2/$3/$1")
    }

    ; MM/DD/YYYY to YYYY-MM-DD
    ToISODate(dateStr) {
        return RegExReplace(dateStr, "(\d{2})/(\d{2})/(\d{4})", "$3-$1-$2")
    }

    isoDate := "2024-01-15"
    usDate := "01/15/2024"

    MsgBox "Date Conversion:`n" .
        "ISO: " . isoDate . " -> US: " . ToUSDate(isoDate) . "`n" .
        "US: " . usDate . " -> ISO: " . ToISODate(usDate)

    ; Add day suffix
    AddDaySuffix(match) {
        day := Integer(match[1])
        if day >= 11 && day <= 13
            return day . "th"
        switch Mod(day, 10) {
            case 1: return day . "st"
            case 2: return day . "nd"
            case 3: return day . "rd"
            default: return day . "th"
        }
    }

    dates := ["January 1", "March 22", "April 3", "May 11"]
    result := "Day Suffixes:`n"
    for date in dates {
        formatted := RegExReplace(date, "(\d+)", AddDaySuffix)
        result .= date . " -> " . formatted . "`n"
    }
    MsgBox result
}

; ========================================
; EXAMPLE 5: Email Patterns
; ========================================
Example5_EmailPatterns() {
    MsgBox "EXAMPLE 5: Email Patterns`n" .
        "=========================="

    ; Obfuscate email
    ObfuscateEmail(email) {
        return RegExReplace(email, "([^@]{1,3})[^@]*(@)", "$1***$2")
    }

    ; Email to mailto link
    EmailToLink(email) {
        return RegExReplace(email, "(.+)", '<a href="mailto:$1">$1</a>')
    }

    ; Extract domain
    GetDomain(email) {
        if RegExMatch(email, "@(.+)", &m)
            return m[1]
        return ""
    }

    emails := ["john.doe@example.com", "admin@test.org"]

    result := "Email Transformations:`n`n"
    for email in emails {
        result .= "Original: " . email . "`n" .
            "Obfuscated: " . ObfuscateEmail(email) . "`n" .
            "Domain: " . GetDomain(email) . "`n" .
            "Link: " . EmailToLink(email) . "`n`n"
    }
    MsgBox result

    ; Validate and normalize
    NormalizeEmail(email) {
        email := StrLower(Trim(email))
        email := RegExReplace(email, "\s+", "")
        return email
    }

    testEmails := ["  USER@EXAMPLE.COM  ", "admin@TEST.org"]
    result := "Email Normalization:`n"
    for email in testEmails {
        result .= "'" . email . "' -> '" . NormalizeEmail(email) . "'`n"
    }
    MsgBox result
}

; ========================================
; EXAMPLE 6: HTML Entity Encoding
; ========================================
Example6_HTMLEntities() {
    MsgBox "EXAMPLE 6: HTML Entity Encoding`n" .
        "================================="

    EncodeHTMLEntities(text) {
        text := RegExReplace(text, "&", "&amp;")
        text := RegExReplace(text, "<", "&lt;")
        text := RegExReplace(text, ">", "&gt;")
        text := RegExReplace(text, '"', "&quot;")
        text := RegExReplace(text, "'", "&#39;")
        return text
    }

    DecodeHTMLEntities(text) {
        text := RegExReplace(text, "&lt;", "<")
        text := RegExReplace(text, "&gt;", ">")
        text := RegExReplace(text, "&quot;", '"')
        text := RegExReplace(text, "&#39;", "'")
        text := RegExReplace(text, "&amp;", "&")
        return text
    }

    raw := "Hello <b>World</b> & 'Test'"
    encoded := EncodeHTMLEntities(raw)
    decoded := DecodeHTMLEntities(encoded)

    MsgBox "HTML Entities:`n" .
        "Raw: " . raw . "`n" .
        "Encoded: " . encoded . "`n" .
        "Decoded: " . decoded

    ; Special characters
    ReplaceSpecialChars(text) {
        replacements := Map(
            "©", "&copy;",
            "®", "&reg;",
            "™", "&trade;",
            "€", "&euro;",
            "£", "&pound;"
        )

        for char, entity in replacements {
            text := StrReplace(text, char, entity)
        }
        return text
    }

    text := "Copyright © 2024, Price: £19.99"
    MsgBox "Special Characters:`n" .
        "Original: " . text . "`n" .
        "Encoded: " . ReplaceSpecialChars(text)
}

; ========================================
; EXAMPLE 7: Common Transformations
; ========================================
Example7_CommonTransformations() {
    MsgBox "EXAMPLE 7: Common Transformations`n" .
        "=================================="

    ; Remove extra whitespace
    NormalizeWhitespace(text) {
        text := RegExReplace(text, "\s+", " ")
        text := RegExReplace(text, "^\s+|\s+$", "")
        return text
    }

    ; Remove duplicate lines
    RemoveDuplicateLines(text) {
        seen := Map()
        result := ""
        Loop Parse, text, "`n", "`r" {
            line := Trim(A_LoopField)
            if line != "" && !seen.Has(line) {
                seen[line] := true
                result .= line . "`n"
            }
        }
        return RegExReplace(result, "\n+$", "")
    }

    ; Strip HTML tags but keep content
    StripHTML(html) {
        text := RegExReplace(html, "<br\s*/?>", "`n")
        text := RegExReplace(text, "<p[^>]*>", "`n")
        text := RegExReplace(text, "</p>", "`n")
        text := RegExReplace(text, "<[^>]+>", "")
        text := RegExReplace(text, "\n+", "`n")
        return Trim(text)
    }

    html := "<p>Hello</p><br/><p>World</p>"
    MsgBox "Strip HTML:`n" .
        "HTML: " . html . "`n" .
        "Text: " . StripHTML(html)

    ; Convert camelCase to snake_case
    CamelToSnake(text) {
        text := RegExReplace(text, "([A-Z])", "_$L$1")
        text := RegExReplace(text, "^_", "")
        return StrLower(text)
    }

    ; Convert snake_case to camelCase
    SnakeToCamel(text) {
        return RegExReplace(text, "_(.)", "$U$1")
    }

    camel := "userName Value"
    snake := "user_name_value"

    MsgBox "Case Conversion:`n" .
        "camelCase: " . camel . " -> " . CamelToSnake(camel) . "`n" .
        "snake_case: " . snake . " -> " . SnakeToCamel(snake)

    ; Extract numbers from text
    ExtractNumbers(text) {
        numbers := []
        pos := 1
        while (pos := RegExMatch(text, "\d+", &m, pos)) {
            numbers.Push(m[0])
            pos := m.Pos + m.Len
        }
        return numbers
    }

    text := "Order #123, Qty: 5, Total: $67"
    nums := ExtractNumbers(text)
    MsgBox "Extract Numbers:`n" .
        "Text: " . text . "`n" .
        "Numbers: " . StrJoin(nums, ", ")

    ; Mask sensitive data
    MaskCreditCard(card) {
        return RegExReplace(card, "\d(?=\d{4})", "*")
    }

    card := "1234-5678-9012-3456"
    MsgBox "Mask Card:`n" .
        "Original: " . card . "`n" .
        "Masked: " . MaskCreditCard(card)
}

; Helper Functions
StrJoin(arr, delim := ",") {
    result := ""
    for index, value in arr {
        result .= value
        if index < arr.Length
            result .= delim
    }
    return result
}

; Main Menu
ShowMenu() {
    MsgBox "
    (
    RegExReplace Pattern Recipes
    =============================

    1. URL Slugification
    2. Text Sanitization
    3. Phone Number Formatting
    4. Date Reformatting
    5. Email Patterns
    6. HTML Entity Encoding
    7. Common Transformations

    Press Ctrl+1-7 to run examples
    )"
}

^1:: Example1_URLSlug()
^2:: Example2_Sanitization()
^3:: Example3_PhoneFormatting()
^4:: Example4_DateFormatting()
^5:: Example5_EmailPatterns()
^6:: Example6_HTMLEntities()
^7:: Example7_CommonTransformations()
^h:: ShowMenu()

ShowMenu()
