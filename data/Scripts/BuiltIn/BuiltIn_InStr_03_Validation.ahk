#Requires AutoHotkey v2.0

/**
* BuiltIn_InStr_03_Validation.ahk
*
* DESCRIPTION:
* Using InStr() for input validation and format checking
*
* FEATURES:
* - Email validation
* - URL validation
* - Format verification
* - Content filtering
*
* SOURCE:
* AutoHotkey v2 Documentation - InStr()
*
* KEY V2 FEATURES DEMONSTRATED:
* - InStr() for validation logic
* - Multiple condition checking
* - Content screening
* - Format detection
*
* LEARNING POINTS:
* 1. InStr() perfect for quick format checks
* 2. Returns 0 if not found (false in boolean context)
* 3. Can validate multiple requirements
* 4. Fast and simple for basic validation
*/

; ============================================================
; Example 1: Basic Email Validation
; ============================================================

/**
* Simple email validation using InStr()
*
* @param {String} email - Email address
* @returns {Boolean} - Valid status
*/
ValidateEmail(email) {
    ; Must contain @
    if (!InStr(email, "@"))
    return false

    ; Must contain dot after @
    atPos := InStr(email, "@")
    if (!InStr(email, ".", , atPos))
    return false

    ; @ should not be first or last
    if (atPos = 1 || atPos = StrLen(email))
    return false

    return true
}

emails := [
"user@example.com",
"invalid.email",
"@example.com",
"user@",
"user@domain.co.uk"
]

output := "EMAIL VALIDATION:`n`n"
for email in emails {
    isValid := ValidateEmail(email)
    status := isValid ? "✓ Valid" : "✗ Invalid"
    output .= status ": " email "`n"
}

MsgBox(output, "Email Validation", "Icon!")

; ============================================================
; Example 2: URL Protocol Check
; ============================================================

/**
* Check if URL has valid protocol
*
* @param {String} url - URL to check
* @returns {String} - Protocol or empty
*/
GetURLProtocol(url) {
    protocols := ["http://", "https://", "ftp://", "file://"]

    for protocol in protocols {
        if (InStr(url, protocol) = 1)  ; At start
        return protocol
    }

    return ""
}

urls := [
"https://www.example.com",
"http://localhost:8080",
"ftp://files.server.com",
"www.example.com",
"file:///C:/path/to/file"
]

output := "URL PROTOCOL CHECK:`n`n"
for url in urls {
    protocol := GetURLProtocol(url)
    output .= url "`n"
    output .= "  Protocol: " (protocol = "" ? "None" : protocol) "`n`n"
}

MsgBox(output, "URL Protocol", "Icon!")

; ============================================================
; Example 3: Password Strength - Character Requirements
; ============================================================

/**
* Check password meets character requirements
*
* @param {String} password - Password to check
* @returns {Map} - Requirement checklist
*/
CheckPasswordRequirements(password) {
    req := Map()

    ; Check for digits
    req["hasDigit"] := false
    Loop Parse, "0123456789" {
        if (InStr(password, A_LoopField)) {
            req["hasDigit"] := true
            break
        }
    }

    ; Check for lowercase
    req["hasLower"] := false
    Loop Parse, "abcdefghijklmnopqrstuvwxyz" {
        if (InStr(password, A_LoopField)) {
            req["hasLower"] := true
            break
        }
    }

    ; Check for uppercase
    req["hasUpper"] := false
    Loop Parse, "ABCDEFGHIJKLMNOPQRSTUVWXYZ" {
        if (InStr(password, A_LoopField)) {
            req["hasUpper"] := true
            break
        }
    }

    ; Check for special characters
    req["hasSpecial"] := InStr(password, "!") || InStr(password, "@")
    || InStr(password, "#") || InStr(password, "$")

    ; Check length
    req["hasMinLength"] := StrLen(password) >= 8

    return req
}

passwords := ["password", "Pass123", "MyP@ss123"]

output := "PASSWORD REQUIREMENTS:`n`n"
for pwd in passwords {
    req := CheckPasswordRequirements(pwd)
    output .= "Password: '" pwd "'`n"
    output .= "  Digit: " (req["hasDigit"] ? "✓" : "✗") "`n"
    output .= "  Lowercase: " (req["hasLower"] ? "✓" : "✗") "`n"
    output .= "  Uppercase: " (req["hasUpper"] ? "✓" : "✗") "`n"
    output .= "  Special: " (req["hasSpecial"] ? "✓" : "✗") "`n"
    output .= "  Length 8+: " (req["hasMinLength"] ? "✓" : "✗") "`n`n"
}

MsgBox(output, "Password Requirements", "Icon!")

; ============================================================
; Example 4: File Type Validation
; ============================================================

/**
* Check if file is allowed type
*
* @param {String} filename - Filename
* @param {Array} allowedExts - Allowed extensions
* @returns {Boolean} - Is allowed
*/
IsAllowedFileType(filename, allowedExts) {
    for ext in allowedExts {
        if (InStr(filename, "." ext, , -1) > 0)  ; Check from end
        return true
    }
    return false
}

allowedImages := ["jpg", "jpeg", "png", "gif", "webp"]
allowedDocs := ["pdf", "doc", "docx", "txt"]

files := [
"photo.jpg",
"document.pdf",
"script.ahk",
"image.png",
"data.xlsx"
]

output := "FILE TYPE VALIDATION:`n`n"
output .= "Allowed Images: " StrJoin(allowedImages, ", ") "`n`n"

for file in files {
    isImage := IsAllowedFileType(file, allowedImages)
    isDoc := IsAllowedFileType(file, allowedDocs)
    output .= file ": "
    output .= isImage ? "Image" : (isDoc ? "Document" : "Other")
    output .= "`n"
}

StrJoin(arr, delimiter) {
    result := ""
    for item in arr
    result .= item (A_Index < arr.Length ? delimiter : "")
    return result
}

MsgBox(output, "File Type Validation", "Icon!")

; ============================================================
; Example 5: Content Filtering - Profanity Check
; ============================================================

/**
* Check text for blocked words
*
* @param {String} text - Text to check
* @param {Array} blockedWords - Words to block
* @returns {Map} - Check results
*/
CheckContent(text, blockedWords) {
    result := Map(
    "isClean", true,
    "foundWords", []
    )

    textLower := StrLower(text)

    for word in blockedWords {
        if (InStr(textLower, StrLower(word))) {
            result["isClean"] := false
            result["foundWords"].Push(word)
        }
    }

    return result
}

blockedWords := ["spam", "prohibited", "illegal"]

comments := [
"This is a great product!",
"This is spam and prohibited content",
"I found illegal activities here"
]

output := "CONTENT FILTERING:`n`n"
output .= "Blocked Words: " StrJoin(blockedWords, ", ") "`n`n"

for comment in comments {
    check := CheckContent(comment, blockedWords)
    output .= (check["isClean"] ? "✓" : "✗") " " comment "`n"
    if (!check["isClean"])
    output .= "  Found: " StrJoin(check["foundWords"], ", ") "`n"
}

MsgBox(output, "Content Filtering", "Icon!")

; ============================================================
; Example 6: SQL Injection Prevention (Basic)
; ============================================================

/**
* Check for common SQL injection patterns
*
* @param {String} input - User input
* @returns {Boolean} - Contains suspicious content
*/
HasSQLInjectionPatterns(input) {
    dangerousPatterns := [
    "'",
    "--",
    "/*",
    "*/",
    "DROP",
    "DELETE",
    "INSERT",
    "UPDATE",
    "UNION",
    "SELECT"
    ]

    inputUpper := StrUpper(input)

    for pattern in dangerousPatterns {
        if (InStr(inputUpper, StrUpper(pattern)))
        return true
    }

    return false
}

inputs := [
"john_doe",
"admin' OR '1'='1",
"user123",
"test'; DROP TABLE users--"
]

output := "SQL INJECTION CHECK:`n`n"
for input in inputs {
    isSafe := !HasSQLInjectionPatterns(input)
    status := isSafe ? "✓ Safe" : "✗ Suspicious"
    output .= status ": " input "`n"
}

MsgBox(output, "SQL Injection Check", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
VALIDATION WITH INSTR():

Quick Checks:
• Email: InStr(email, '@') && InStr(email, '.')
• URL: InStr(url, '://') = 4 or 5
• Extension: InStr(file, '.ext', , -1)
• Contains: InStr(text, required) > 0

Advantages:
✓ Simple and fast
✓ No regex needed for basic checks
✓ Easy to understand
✓ Good for quick validation

Limitations:
✗ Not comprehensive (use RegEx for complete)
✗ Can't validate complex patterns
✗ May have false positives

Best Practices:
• Combine with other checks
• Use for preliminary validation
• Follow with comprehensive validation
• Consider security implications

Use InStr() For:
✓ Quick format checks
✓ Required character presence
✓ Simple pattern detection
✓ Content screening
)"

MsgBox(info, "Validation Reference", "Icon!")
