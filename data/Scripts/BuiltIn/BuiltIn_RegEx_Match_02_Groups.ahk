#Requires AutoHotkey v2.0

/**
 * BuiltIn_RegEx_Match_02_Groups.ahk
 * 
 * DESCRIPTION:
 * Demonstrates capturing groups in RegExMatch, including named groups, nested groups,
 * and using backreferences. Shows how to extract multiple pieces of information from
 * a single pattern match.
 * 
 * FEATURES:
 * - Parentheses for creating capture groups
 * - Accessing captured groups via Match object
 * - Named capture groups with (?P<name>...)
 * - Non-capturing groups with (?:...)
 * - Nested and optional groups
 * - Extracting structured data
 * - Multiple group patterns
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - RegEx
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Match object array indexing for groups
 * - Named group access via Match["name"]
 * - Match.Count property for group count
 * - Modern object syntax
 * - Map objects for storing extracted data
 * 
 * LEARNING POINTS:
 * 1. Parentheses () create capturing groups
 * 2. Match[0] is the full match, Match[1] is first group, etc.
 * 3. Named groups allow accessing captures by name: Match["groupname"]
 * 4. (?:...) creates non-capturing groups for grouping without capturing
 * 5. Groups can be nested and referenced individually
 * 6. Match.Count returns the number of capturing groups
 * 7. Groups are numbered left-to-right by opening parenthesis
 */

; ========================================
; EXAMPLE 1: Basic Capturing Groups
; ========================================
; Using parentheses to capture parts of a match
Example1_BasicGroups() {
    MsgBox "EXAMPLE 1: Basic Capturing Groups`n" .
        "=================================="

    ; Extract date components
    text := "Today's date is 2024-01-15"

    ; Pattern with three groups: year, month, day
    pattern := "(\d{4})-(\d{2})-(\d{2})"

    if RegExMatch(text, pattern, &match) {
        MsgBox "Full match: " . match[0] . "`n" .
            "Year (group 1): " . match[1] . "`n" .
            "Month (group 2): " . match[2] . "`n" .
            "Day (group 3): " . match[3] . "`n" .
            "Total groups: " . match.Count
    }

    ; Extract name parts
    fullName := "John Michael Doe"

    ; Capture first, middle, and last name
    pattern := "(\w+)\s+(\w+)\s+(\w+)"

    if RegExMatch(fullName, pattern, &match) {
        firstName := match[1]
        middleName := match[2]
        lastName := match[3]

        MsgBox "Parsed name:`n" .
            "First: " . firstName . "`n" .
            "Middle: " . middleName . "`n" .
            "Last: " . lastName . "`n`n" .
            "Reversed: " . lastName . ", " . firstName . " " . middleName
    }

    ; Extract time components
    timeText := "Meeting at 14:30:45"
    pattern := "(\d{2}):(\d{2}):(\d{2})"

    if RegExMatch(timeText, pattern, &match) {
        hours := match[1]
        minutes := match[2]
        seconds := match[3]

        ; Convert to 12-hour format
        ampm := (hours >= 12) ? "PM" : "AM"
        hours12 := Mod(hours, 12)
        hours12 := (hours12 = 0) ? 12 : hours12

        MsgBox "24-hour format: " . match[0] . "`n" .
            "12-hour format: " . hours12 . ":" . minutes . ":" . seconds . " " . ampm
    }

    ; Extract protocol and domain from URL
    url := "https://www.example.com/path"
    pattern := "(\w+)://([^/]+)"

    if RegExMatch(url, pattern, &match) {
        protocol := match[1]
        domain := match[2]

        MsgBox "URL Components:`n" .
            "Protocol: " . protocol . "`n" .
            "Domain: " . domain . "`n" .
            "Full match: " . match[0]
    }
}

; ========================================
; EXAMPLE 2: Named Capturing Groups
; ========================================
; Using (?P<name>...) for readable group access
Example2_NamedGroups() {
    MsgBox "EXAMPLE 2: Named Capturing Groups`n" .
        "=================================="

    ; Parse date with named groups
    text := "Date: 2024-01-15"
    pattern := "(?P<year>\d{4})-(?P<month>\d{2})-(?P<day>\d{2})"

    if RegExMatch(text, pattern, &match) {
        MsgBox "Named group access:`n" .
            "Year: " . match["year"] . "`n" .
            "Month: " . match["month"] . "`n" .
            "Day: " . match["day"] . "`n`n" .
            "Also accessible by number:`n" .
            "Group 1: " . match[1] . " (year)`n" .
            "Group 2: " . match[2] . " (month)`n" .
            "Group 3: " . match[3] . " (day)"
    }

    ; Parse email address
    email := "user.name@example.com"
    pattern := "(?P<local>[^@]+)@(?P<domain>.+)"

    if RegExMatch(email, pattern, &match) {
        MsgBox "Email Components:`n" .
            "Local part: " . match["local"] . "`n" .
            "Domain: " . match["domain"] . "`n`n" .
            "Validation: " . (StrLen(match["local"]) > 0 && StrLen(match["domain"]) > 3 ? "Valid" : "Invalid")
    }

    ; Parse log entry with multiple named groups
    logLine := "[2024-01-15 10:30:45] ERROR: Database connection failed"
    pattern := "\[(?P<date>\d{4}-\d{2}-\d{2}) (?P<time>\d{2}:\d{2}:\d{2})\] (?P<level>\w+): (?P<message>.+)"

    if RegExMatch(logLine, pattern, &match) {
        MsgBox "Log Entry Details:`n" .
            "Date: " . match["date"] . "`n" .
            "Time: " . match["time"] . "`n" .
            "Level: " . match["level"] . "`n" .
            "Message: " . match["message"]
    }

    ; Parse phone number
    phone := "Phone: +1 (555) 123-4567"
    pattern := "\+(?P<country>\d+) \((?P<area>\d+)\) (?P<prefix>\d+)-(?P<line>\d+)"

    if RegExMatch(phone, pattern, &match) {
        MsgBox "Phone Number Components:`n" .
            "Country: " . match["country"] . "`n" .
            "Area: " . match["area"] . "`n" .
            "Prefix: " . match["prefix"] . "`n" .
            "Line: " . match["line"] . "`n`n" .
            "Formatted: +" . match["country"] . "-" . match["area"] . "-" . match["prefix"] . "-" . match["line"]
    }

    ; Parse price with currency
    priceText := "Total: $123.45"
    pattern := "(?P<currency>[$€£¥])(?P<amount>\d+\.\d{2})"

    if RegExMatch(priceText, pattern, &match) {
        amount := Float(match["amount"])
        tax := Round(amount * 0.10, 2)
        total := amount + tax

        MsgBox "Price Details:`n" .
            "Currency: " . match["currency"] . "`n" .
            "Amount: " . match["amount"] . "`n" .
            "Tax (10%): " . match["currency"] . tax . "`n" .
            "Total: " . match["currency"] . total
    }
}

; ========================================
; EXAMPLE 3: Non-Capturing Groups
; ========================================
; Using (?:...) for grouping without capturing
Example3_NonCapturingGroups() {
    MsgBox "EXAMPLE 3: Non-Capturing Groups`n" .
        "================================="

    ; Group for alternation without capturing
    text := "I like cats and dogs"

    ; Without non-capturing group - captures the animal
    pattern1 := "(cat|dog)s?"
    if RegExMatch(text, pattern1, &match) {
        MsgBox "With capturing group:`n" .
            "Full match: " . match[0] . "`n" .
            "Group 1: " . match[1] . "`n" .
            "Group count: " . match.Count
    }

    ; With non-capturing group - doesn't capture the alternation
    pattern2 := "(?:cat|dog)s?"
    if RegExMatch(text, pattern2, &match) {
        MsgBox "With non-capturing group:`n" .
            "Full match: " . match[0] . "`n" .
            "Group count: " . match.Count . " (no groups captured)"
    }

    ; Practical example: Extract number but not unit
    measurement := "Temperature: 25 degrees Celsius"

    ; Capture number, but group units without capturing
    pattern := "(\d+) (?:degrees|deg|°) (?:Celsius|C|Fahrenheit|F)"

    if RegExMatch(measurement, pattern, &match) {
        MsgBox "Temperature value: " . match[1] . "`n" .
            "Full match: " . match[0] . "`n" .
            "Only one group captured (the number)"
    }

    ; Complex example: URL parsing with mixed groups
    url := "https://www.example.com:8080/path/to/file.html"

    ; Capture protocol and path, but not www. or :port
    pattern := "(?P<protocol>\w+)://(?:www\.)?(?P<domain>[^:/]+)(?::\d+)?(?P<path>/.*)"

    if RegExMatch(url, pattern, &match) {
        MsgBox "URL Components (selective capturing):`n" .
            "Protocol: " . match["protocol"] . "`n" .
            "Domain: " . match["domain"] . "`n" .
            "Path: " . match["path"] . "`n" .
            "Groups captured: " . match.Count
    }

    ; Extract version number, ignore prefix
    version := "Version: v1.2.3-beta"
    pattern := "(?:Version: )?v?(\d+)\.(\d+)\.(\d+)"

    if RegExMatch(version, pattern, &match) {
        major := match[1]
        minor := match[2]
        patch := match[3]

        MsgBox "Version Components:`n" .
            "Major: " . major . "`n" .
            "Minor: " . minor . "`n" .
            "Patch: " . patch . "`n" .
            "Numeric: " . major . "." . minor . "." . patch
    }
}

; ========================================
; EXAMPLE 4: Nested Groups
; ========================================
; Working with groups inside other groups
Example4_NestedGroups() {
    MsgBox "EXAMPLE 4: Nested Groups`n" .
        "========================="

    ; Groups are numbered by opening parenthesis from left to right
    text := "Name: John Doe"
    pattern := "((\w+) (\w+))"

    if RegExMatch(text, pattern, &match) {
        MsgBox "Nested groups:`n" .
            "Group 0 (full): " . match[0] . "`n" .
            "Group 1 (outer): " . match[1] . "`n" .
            "Group 2 (first name): " . match[2] . "`n" .
            "Group 3 (last name): " . match[3]
    }

    ; Parse nested structure: function call
    code := "print('Hello, World!')"
    pattern := "(\w+)\(('([^']*)')\)"

    if RegExMatch(code, pattern, &match) {
        MsgBox "Function call parsing:`n" .
            "Function name (1): " . match[1] . "`n" .
            "Full argument (2): " . match[2] . "`n" .
            "String content (3): " . match[3]
    }

    ; Complex nested date/time
    datetime := "2024-01-15T10:30:45"
    pattern := "((\d{4})-(\d{2})-(\d{2}))T((\d{2}):(\d{2}):(\d{2}))"

    if RegExMatch(datetime, pattern, &match) {
        MsgBox "ISO DateTime Parsing:`n" .
            "Full date (1): " . match[1] . "`n" .
            "  Year (2): " . match[2] . "`n" .
            "  Month (3): " . match[3] . "`n" .
            "  Day (4): " . match[4] . "`n" .
            "Full time (5): " . match[5] . "`n" .
            "  Hour (6): " . match[6] . "`n" .
            "  Minute (7): " . match[7] . "`n" .
            "  Second (8): " . match[8]
    }

    ; Named nested groups
    email := "John Doe <john.doe@example.com>"
    pattern := "(?P<display>(?P<first>\w+) (?P<last>\w+)) <(?P<email>.+)>"

    if RegExMatch(email, pattern, &match) {
        MsgBox "Email with display name:`n" .
            "Display name: " . match["display"] . "`n" .
            "  First: " . match["first"] . "`n" .
            "  Last: " . match["last"] . "`n" .
            "Email: " . match["email"]
    }
}

; ========================================
; EXAMPLE 5: Optional Groups
; ========================================
; Using ? quantifier with groups
Example5_OptionalGroups() {
    MsgBox "EXAMPLE 5: Optional Groups`n" .
        "==========================="

    ; Optional middle name
    ParseName(fullname) {
        ; Pattern: First (Middle)? Last
        pattern := "(?P<first>\w+)(?:\s+(?P<middle>\w+))?\s+(?P<last>\w+)"

        if RegExMatch(fullname, pattern, &match) {
            result := Map()
            result["first"] := match["first"]
            result["middle"] := match.Count >= 2 && match[2] != "" ? match[2] : "N/A"
            result["last"] := match["last"]
            return result
        }
        return false
    }

    name1 := "John Doe"
    name2 := "John Michael Doe"

    parsed1 := ParseName(name1)
    parsed2 := ParseName(name2)

    MsgBox "Name 1: " . name1 . "`n" .
        "  First: " . parsed1["first"] . "`n" .
        "  Middle: " . parsed1["middle"] . "`n" .
        "  Last: " . parsed1["last"] . "`n`n" .
        "Name 2: " . name2 . "`n" .
        "  First: " . parsed2["first"] . "`n" .
        "  Middle: " . parsed2["middle"] . "`n" .
        "  Last: " . parsed2["last"]

    ; Optional protocol in URL
    ParseURL(url) {
        pattern := "(?:(?P<protocol>\w+)://)?(?P<domain>[^/]+)(?P<path>/.*)?"

        if RegExMatch(url, pattern, &match) {
            return Map(
                "protocol", match["protocol"] != "" ? match["protocol"] : "http",
                "domain", match["domain"],
                "path", match["path"] != "" ? match["path"] : "/"
            )
        }
        return false
    }

    url1 := "https://example.com/page"
    url2 := "example.com"

    parsed1 := ParseURL(url1)
    parsed2 := ParseURL(url2)

    MsgBox "URL 1: " . url1 . "`n" .
        "  Protocol: " . parsed1["protocol"] . "`n" .
        "  Domain: " . parsed1["domain"] . "`n" .
        "  Path: " . parsed1["path"] . "`n`n" .
        "URL 2: " . url2 . "`n" .
        "  Protocol: " . parsed2["protocol"] . " (default)`n" .
        "  Domain: " . parsed2["domain"] . "`n" .
        "  Path: " . parsed2["path"] . " (default)"

    ; Optional decimal places
    ParseNumber(numStr) {
        pattern := "^(?P<sign>-)?(?P<integer>\d+)(?:\.(?P<decimal>\d+))?$"

        if RegExMatch(numStr, pattern, &match) {
            return Map(
                "sign", match["sign"] != "" ? "-" : "+",
                "integer", match["integer"],
                "decimal", match["decimal"] != "" ? match["decimal"] : "0",
                "isDecimal", match["decimal"] != "" ? true : false
            )
        }
        return false
    }

    num1 := "123"
    num2 := "123.456"
    num3 := "-789.12"

    p1 := ParseNumber(num1)
    p2 := ParseNumber(num2)
    p3 := ParseNumber(num3)

    MsgBox "Number: " . num1 . " -> " . p1["sign"] . p1["integer"] . "." . p1["decimal"] . " (Decimal: " . p1["isDecimal"] . ")`n" .
        "Number: " . num2 . " -> " . p2["sign"] . p2["integer"] . "." . p2["decimal"] . " (Decimal: " . p2["isDecimal"] . ")`n" .
        "Number: " . num3 . " -> " . p3["sign"] . p3["integer"] . "." . p3["decimal"] . " (Decimal: " . p3["isDecimal"] . ")"
}

; ========================================
; EXAMPLE 6: Extracting Multiple Items
; ========================================
; Using groups to extract multiple pieces of data
Example6_MultipleExtractions() {
    MsgBox "EXAMPLE 6: Extracting Multiple Items`n" .
        "====================================="

    ; Extract all email addresses with names
    text := "Contact john@example.com or jane@test.org for more info"
    pattern := "(\w+)@([\w.]+)"

    emails := []
    pos := 1
    while (pos := RegExMatch(text, pattern, &match, pos)) {
        emails.Push(Map("user", match[1], "domain", match[2], "full", match[0]))
        pos := match.Pos + match.Len
    }

    result := "Found " . emails.Length . " email addresses:`n`n"
    for index, email in emails {
        result .= index . ". " . email["full"] . "`n" .
            "   User: " . email["user"] . "`n" .
            "   Domain: " . email["domain"] . "`n"
    }
    MsgBox result

    ; Extract all hashtags with text
    tweet := "Loving this #AutoHotkey #Programming and #Automation!"
    pattern := "#(\w+)"

    hashtags := []
    pos := 1
    while (pos := RegExMatch(tweet, pattern, &match, pos)) {
        hashtags.Push(match[1])
        pos := match.Pos + match.Len
    }

    MsgBox "Tweet: " . tweet . "`n`n" .
        "Hashtags found: " . StrJoin(hashtags, ", ")

    ; Parse multiple key=value pairs
    config := "name=John;age=30;city=NewYork;country=USA"
    pattern := "(\w+)=(\w+)"

    settings := Map()
    pos := 1
    while (pos := RegExMatch(config, pattern, &match, pos)) {
        settings[match[1]] := match[2]
        pos := match.Pos + match.Len
    }

    result := "Configuration Settings:`n"
    for key, value in settings {
        result .= key . " = " . value . "`n"
    }
    MsgBox result

    ; Extract HTML-style attributes
    html := '<div class="container" id="main" data-value="123">'
    pattern := '(\w+)="([^"]+)"'

    attributes := Map()
    pos := 1
    while (pos := RegExMatch(html, pattern, &match, pos)) {
        attributes[match[1]] := match[2]
        pos := match.Pos + match.Len
    }

    result := "HTML Attributes:`n"
    for attr, value in attributes {
        result .= attr . ' = "' . value . '"`n'
    }
    MsgBox result
}

; ========================================
; EXAMPLE 7: Advanced Group Patterns
; ========================================
; Complex real-world group usage
Example7_AdvancedGroupPatterns() {
    MsgBox "EXAMPLE 7: Advanced Group Patterns`n" .
        "==================================="

    ; Parse credit card (with masking)
    ParseCreditCard(cardText) {
        ; Pattern: XXXX-XXXX-XXXX-XXXX or XXXX XXXX XXXX XXXX
        pattern := "(\d{4})[-\s](\d{4})[-\s](\d{4})[-\s](\d{4})"

        if RegExMatch(cardText, pattern, &match) {
            masked := "****-****-****-" . match[4]
            return Map(
                "masked", masked,
                "last4", match[4],
                "valid", true
            )
        }
        return Map("valid", false)
    }

    card1 := "Card: 1234-5678-9012-3456"
    card2 := "Card: 9876 5432 1098 7654"

    p1 := ParseCreditCard(card1)
    p2 := ParseCreditCard(card2)

    MsgBox "Card 1: " . (p1["valid"] ? p1["masked"] : "Invalid") . "`n" .
        "Card 2: " . (p2["valid"] ? p2["masked"] : "Invalid")

    ; Parse complex log entry
    logEntry := '192.168.1.100 - admin [15/Jan/2024:10:30:45 +0000] "GET /api/users HTTP/1.1" 200 1234'
    pattern := '(?P<ip>[\d.]+) - (?P<user>\w+) \[(?P<date>[^\]]+)\] "(?P<method>\w+) (?P<path>\S+) (?P<protocol>[^"]+)" (?P<status>\d+) (?P<size>\d+)'

    if RegExMatch(logEntry, pattern, &match) {
        MsgBox "Apache Log Entry:`n" .
            "IP: " . match["ip"] . "`n" .
            "User: " . match["user"] . "`n" .
            "Date: " . match["date"] . "`n" .
            "Method: " . match["method"] . "`n" .
            "Path: " . match["path"] . "`n" .
            "Protocol: " . match["protocol"] . "`n" .
            "Status: " . match["status"] . "`n" .
            "Size: " . match["size"] . " bytes"
    }

    ; Parse semantic version with metadata
    version := "v1.2.3-beta.1+build.123"
    pattern := "v?(?P<major>\d+)\.(?P<minor>\d+)\.(?P<patch>\d+)(?:-(?P<prerelease>[^+]+))?(?:\+(?P<build>.+))?"

    if RegExMatch(version, pattern, &match) {
        MsgBox "Semantic Version:`n" .
            "Major: " . match["major"] . "`n" .
            "Minor: " . match["minor"] . "`n" .
            "Patch: " . match["patch"] . "`n" .
            "Pre-release: " . (match["prerelease"] != "" ? match["prerelease"] : "N/A") . "`n" .
            "Build: " . (match["build"] != "" ? match["build"] : "N/A")
    }

    ; Parse SQL-like query
    query := "SELECT name, email FROM users WHERE age > 25 LIMIT 10"
    pattern := "SELECT (?P<fields>.+?) FROM (?P<table>\w+)(?: WHERE (?P<condition>.+?))?(?: LIMIT (?P<limit>\d+))?"

    if RegExMatch(query, pattern, &match) {
        MsgBox "SQL Query Components:`n" .
            "Fields: " . match["fields"] . "`n" .
            "Table: " . match["table"] . "`n" .
            "Condition: " . (match["condition"] != "" ? match["condition"] : "None") . "`n" .
            "Limit: " . (match["limit"] != "" ? match["limit"] : "No limit")
    }
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
    RegExMatch Capturing Groups
    ============================

    1. Basic Capturing Groups
    2. Named Capturing Groups
    3. Non-Capturing Groups
    4. Nested Groups
    5. Optional Groups
    6. Extracting Multiple Items
    7. Advanced Group Patterns

    Press Ctrl+1-7 to run examples
    Press Ctrl+H for this menu
    )"

    MsgBox menu
}

^1:: Example1_BasicGroups()
^2:: Example2_NamedGroups()
^3:: Example3_NonCapturingGroups()
^4:: Example4_NestedGroups()
^5:: Example5_OptionalGroups()
^6:: Example6_MultipleExtractions()
^7:: Example7_AdvancedGroupPatterns()

^h:: ShowMenu()

ShowMenu()
