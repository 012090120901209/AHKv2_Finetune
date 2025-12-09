#Requires AutoHotkey v2.0

/**
* BuiltIn_SubStr_03_DataExtraction.ahk
*
* DESCRIPTION:
* Extract structured data from strings using SubStr()
*
* FEATURES:
* - Log file parsing
* - Data record extraction
* - Timestamp parsing
* - Column-based data reading
*
* SOURCE:
* AutoHotkey v2 Documentation - SubStr()
*
* KEY V2 FEATURES DEMONSTRATED:
* - SubStr() for structured data
* - Combined with RegExMatch for validation
* - Array and Map for storing extracted data
* - Class-based extractors
*
* LEARNING POINTS:
* 1. SubStr() excels at fixed-position extraction
* 2. Useful for parsing logs and reports
* 3. Combine with string search for flexible parsing
* 4. Handle different data formats systematically
*/

; ============================================================
; Example 1: Log Entry Parser
; ============================================================

/**
* Parse standard log entry format
* Format: [TIMESTAMP] [LEVEL] Message
*/
class LogParser {
    static Parse(logLine) {
        entry := Map()

        ; Extract timestamp (between first [ and ])
        timestampStart := InStr(logLine, "[")
        timestampEnd := InStr(logLine, "]")

        if (timestampStart > 0 && timestampEnd > 0) {
            entry["timestamp"] := SubStr(logLine, timestampStart + 1, timestampEnd - timestampStart - 1)

            ; Find level (between second [ and ])
            levelStart := InStr(logLine, "[", , timestampEnd + 1)
            levelEnd := InStr(logLine, "]", , levelStart + 1)

            if (levelStart > 0 && levelEnd > 0) {
                entry["level"] := SubStr(logLine, levelStart + 1, levelEnd - levelStart - 1)

                ; Message is everything after second ]
                entry["message"] := Trim(SubStr(logLine, levelEnd + 1))
            }
        }

        return entry
    }
}

; Sample log entries
logLines := [
"[2024-11-16 10:30:45] [INFO] Application started successfully",
"[2024-11-16 10:31:12] [ERROR] Failed to connect to database",
"[2024-11-16 10:31:15] [WARNING] Retrying connection..."
]

output := "LOG PARSING:`n`n"
for line in logLines {
    entry := LogParser.Parse(line)
    output .= "Time: " entry["timestamp"] "`n"
    output .= "Level: " entry["level"] "`n"
    output .= "Message: " entry["message"] "`n`n"
}

MsgBox(output, "Log Parser", "Icon!")

; ============================================================
; Example 2: Credit Card Number Formatter
; ============================================================

/**
* Format credit card number with spaces
*
* @param {String} cardNumber - Raw card number
* @returns {String} - Formatted card number
*/
FormatCardNumber(cardNumber) {
    ; Remove existing spaces
    clean := StrReplace(cardNumber, " ", "")

    ; Format as XXXX XXXX XXXX XXXX
    formatted := ""
    Loop (StrLen(clean)) {
        if (A_Index > 1 && Mod(A_Index - 1, 4) = 0)
        formatted .= " "
        formatted .= SubStr(clean, A_Index, 1)
    }

    return formatted
}

rawCard := "4532123456789012"
formatted := FormatCardNumber(rawCard)

MsgBox("Raw: " rawCard "`n"
. "Formatted: " formatted,
"Card Formatting", "Icon!")

; ============================================================
; Example 3: Extract Initials from Name
; ============================================================

/**
* Get initials from full name
*
* @param {String} fullName - Full name
* @returns {String} - Initials
*/
GetInitials(fullName) {
    initials := ""
    words := StrSplit(fullName, " ")

    for word in words {
        if (StrLen(word) > 0)
        initials .= SubStr(word, 1, 1) . "."
    }

    return initials
}

names := [
"John Doe",
"Mary Jane Watson",
"Dr. Robert Smith Jr."
]

output := "NAME INITIALS:`n`n"
for name in names
output .= name " → " GetInitials(name) "`n"

MsgBox(output, "Initials Extractor", "Icon!")

; ============================================================
; Example 4: ISBN Parser
; ============================================================

/**
* Parse ISBN-13 number
* Format: 978-3-16-148410-0
*
* @param {String} isbn - ISBN string
* @returns {Map} - ISBN components
*/
ParseISBN(isbn) {
    ; Remove hyphens
    clean := StrReplace(isbn, "-", "")

    parts := Map()

    if (StrLen(clean) = 13) {
        parts["prefix"] := SubStr(clean, 1, 3)      ; 978 or 979
        parts["group"] := SubStr(clean, 4, 1)       ; Group/country
        parts["publisher"] := SubStr(clean, 5, 2)   ; Publisher
        parts["title"] := SubStr(clean, 7, 6)       ; Title
        parts["check"] := SubStr(clean, 13, 1)      ; Check digit
    }

    return parts
}

isbn := "978-3-16-148410-0"
parts := ParseISBN(isbn)

MsgBox("ISBN: " isbn "`n`n"
. "Prefix: " parts["prefix"] "`n"
. "Group: " parts["group"] "`n"
. "Publisher: " parts["publisher"] "`n"
. "Title: " parts["title"] "`n"
. "Check Digit: " parts["check"],
"ISBN Parser", "Icon!")

; ============================================================
; Example 5: Phone Number Formatter
; ============================================================

/**
* Format phone number
*
* @param {String} phone - Raw phone number
* @returns {String} - Formatted phone
*/
FormatPhoneNumber(phone) {
    ; Remove non-digits
    digits := ""
    Loop Parse, phone {
        if (RegExMatch(A_LoopField, "\d"))
        digits .= A_LoopField
    }

    ; Format based on length
    if (StrLen(digits) = 10) {
        ; (XXX) XXX-XXXX
        return "(" SubStr(digits, 1, 3) ") "
        . SubStr(digits, 4, 3) "-"
        . SubStr(digits, 7, 4)
    } else if (StrLen(digits) = 11) {
        ; +X (XXX) XXX-XXXX
        return "+" SubStr(digits, 1, 1) " ("
        . SubStr(digits, 2, 3) ") "
        . SubStr(digits, 5, 3) "-"
        . SubStr(digits, 8, 4)
    }

    return phone
}

phones := [
"5551234567",
"15551234567",
"555-123-4567"
]

output := "PHONE FORMATTING:`n`n"
for phone in phones
output .= phone " → " FormatPhoneNumber(phone) "`n"

MsgBox(output, "Phone Formatter", "Icon!")

; ============================================================
; Example 6: Extract Time Components
; ============================================================

/**
* Parse time string (HH:MM:SS)
*
* @param {String} timeStr - Time string
* @returns {Map} - Time components
*/
ParseTime(timeStr) {
    parts := Map()

    ; Format: HH:MM:SS
    if (StrLen(timeStr) >= 8) {
        parts["hours"] := SubStr(timeStr, 1, 2)
        parts["minutes"] := SubStr(timeStr, 4, 2)
        parts["seconds"] := SubStr(timeStr, 7, 2)

        ; Convert to 12-hour format
        hours := Integer(parts["hours"])
        if (hours = 0) {
            parts["hours12"] := "12"
            parts["period"] := "AM"
        } else if (hours < 12) {
            parts["hours12"] := String(hours)
            parts["period"] := "AM"
        } else if (hours = 12) {
            parts["hours12"] := "12"
            parts["period"] := "PM"
        } else {
            parts["hours12"] := String(hours - 12)
            parts["period"] := "PM"
        }
    }

    return parts
}

times := ["09:30:45", "14:15:00", "00:05:30", "23:59:59"]

output := "TIME PARSING:`n`n"
for timeStr in times {
    parts := ParseTime(timeStr)
    output .= timeStr " → "
    output .= parts["hours12"] ":" parts["minutes"] ":" parts["seconds"] " " parts["period"]
    output .= "`n"
}

MsgBox(output, "Time Parser", "Icon!")

; ============================================================
; Example 7: MAC Address Formatter
; ============================================================

/**
* Format MAC address
*
* @param {String} mac - MAC address
* @param {String} separator - Separator character
* @returns {String} - Formatted MAC
*/
FormatMAC(mac, separator := ":") {
    ; Remove existing separators
    clean := StrReplace(mac, ":", "")
    clean := StrReplace(clean, "-", "")
    clean := StrReplace(clean, ".", "")

    ; Format as XX:XX:XX:XX:XX:XX
    formatted := ""
    Loop (StrLen(clean) // 2) {
        if (A_Index > 1)
        formatted .= separator
        formatted .= SubStr(clean, (A_Index - 1) * 2 + 1, 2)
    }

    return formatted
}

macAddresses := [
"001122334455",
"00-11-22-33-44-55",
"0011.2233.4455"
]

output := "MAC ADDRESS FORMATTING:`n`n"
for mac in macAddresses {
    output .= "Original: " mac "`n"
    output .= "Colon: " FormatMAC(mac, ":") "`n"
    output .= "Dash: " FormatMAC(mac, "-") "`n`n"
}

MsgBox(output, "MAC Formatter", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
DATA EXTRACTION WITH SUBSTR():

Common Data Formats:

1. Fixed-Width Records:
name := SubStr(line, 1, 20)
age := SubStr(line, 21, 3)
city := SubStr(line, 24, 15)

2. Delimited Data:
pos := InStr(data, delimiter)
field := SubStr(data, 1, pos - 1)

3. Positional Data:
year := SubStr(date, 1, 4)
month := SubStr(date, 6, 2)
day := SubStr(date, 9, 2)

4. Pattern-Based:
start := InStr(text, marker)
value := SubStr(text, start + len, fieldLen)

Extraction Strategies:
• Know your data format
• Validate before extracting
• Handle edge cases
• Trim extracted values
• Convert types when needed

Real-World Applications:
✓ Log file parsing
✓ Report processing
✓ Data format conversion
✓ Number formatting
✓ Identifier extraction
✓ Structured data reading
)"

MsgBox(info, "Data Extraction Reference", "Icon!")
