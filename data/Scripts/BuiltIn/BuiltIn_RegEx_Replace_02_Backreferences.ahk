#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_RegEx_Replace_02_Backreferences.ahk
 * 
 * DESCRIPTION:
 * Demonstrates using backreferences in RegExReplace replacement strings to reuse
 * captured groups. Shows $1, $2 syntax, named backreferences, reordering captures,
 * and complex transformation patterns.
 * 
 * FEATURES:
 * - Using $1, $2, etc. for captured groups
 * - Named group backreferences with ${name}
 * - Reordering captured text
 * - Conditional replacements with backreferences
 * - Complex text transformations
 * - Pattern substitution tricks
 * - Escaping dollar signs in replacements
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - RegEx
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - $1-$9 backreference syntax
 * - ${name} named backreferences
 * - Modern regex replacement capabilities
 * - String manipulation with captured groups
 * - Complex pattern transformations
 * 
 * LEARNING POINTS:
 * 1. $1, $2, etc. reference captured groups in replacement
 * 2. $0 or $& represents the entire match
 * 3. ${name} accesses named capture groups
 * 4. Backreferences allow reordering and reformatting
 * 5. Use $$ to insert a literal dollar sign
 * 6. Captures can be used multiple times in replacement
 * 7. Backreferences enable powerful text transformations
 */

; ========================================
; EXAMPLE 1: Basic Backreferences ($1, $2)
; ========================================
; Using numbered backreferences in replacements
Example1_BasicBackreferences() {
    MsgBox "EXAMPLE 1: Basic Backreferences`n" .
        "================================"

    ; Swap two words
    text := "Hello World"
    result := RegExReplace(text, "(\w+) (\w+)", "$2 $1")

    MsgBox "Swap Words:`n" .
        "Original: " . text . "`n" .
        "Pattern: (\\w+) (\\w+) -> $2 $1`n" .
        "Result: " . result

    ; Extract and reformat date
    text := "Date: 2024-01-15"
    result := RegExReplace(text, "(\d{4})-(\d{2})-(\d{2})", "$2/$3/$1")

    MsgBox "Reformat Date:`n" .
        "Original: " . text . "`n" .
        "YYYY-MM-DD -> MM/DD/YYYY`n" .
        "Result: " . result

    ; Add parentheses around captured group
    text := "Error code: 404"
    result := RegExReplace(text, "(\d+)", "($1)")

    MsgBox "Wrap in Parentheses:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Reuse capture multiple times
    text := "x = 5"
    result := RegExReplace(text, "(\w+) = (\d+)", "$1 was $2, now $1 is $2")

    MsgBox "Reuse Captures:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Reorder name parts
    text := "Doe, John"
    result := RegExReplace(text, "(\w+), (\w+)", "$2 $1")

    MsgBox "Reorder Name:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Extract and format phone
    text := "5551234567"
    result := RegExReplace(text, "(\d{3})(\d{3})(\d{4})", "($1) $2-$3")

    MsgBox "Format Phone:`n" .
        "Original: " . text . "`n" .
        "Result: " . result
}

; ========================================
; EXAMPLE 2: Named Backreferences
; ========================================
; Using ${name} for named group backreferences
Example2_NamedBackreferences() {
    MsgBox "EXAMPLE 2: Named Backreferences`n" .
        "================================"

    ; Parse and reformat date
    text := "2024-01-15"
    pattern := "(?P<year>\d{4})-(?P<month>\d{2})-(?P<day>\d{2})"
    result := RegExReplace(text, pattern, "${month}/${day}/${year}")

    MsgBox "Named Date Reformat:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Parse email and create display
    email := "john.doe@example.com"
    pattern := "(?P<user>[^@]+)@(?P<domain>.+)"
    result := RegExReplace(email, pattern, "${user} at ${domain}")

    MsgBox "Format Email:`n" .
        "Original: " . email . "`n" .
        "Result: " . result

    ; Create mailto link
    result := RegExReplace(email, pattern, '<a href="mailto:${user}@${domain}">${user}@${domain}</a>')

    MsgBox "Create mailto Link:`n" .
        "Email: " . email . "`n" .
        "HTML: " . result

    ; Parse URL components
    url := "https://www.example.com:8080/path"
    pattern := "(?P<protocol>\w+)://(?:www\.)?(?P<domain>[^:/]+)(?::(?P<port>\d+))?(?P<path>/.*)"
    result := RegExReplace(url, pattern, "Domain: ${domain}, Port: ${port}, Path: ${path}")

    MsgBox "Parse URL:`n" .
        "URL: " . url . "`n" .
        "Result: " . result

    ; Reformat log entry
    log := "[2024-01-15 10:30:45] ERROR: Connection failed"
    pattern := "\[(?P<date>[^\s]+) (?P<time>[^\]]+)\] (?P<level>\w+): (?P<message>.+)"
    result := RegExReplace(log, pattern, "[${level}] ${date} ${time} - ${message}")

    MsgBox "Reformat Log:`n" .
        "Original: " . log . "`n" .
        "Result: " . result
}

; ========================================
; EXAMPLE 3: Whole Match Reference ($0)
; ========================================
; Using $0 or $& to reference the entire match
Example3_WholeMatch() {
    MsgBox "EXAMPLE 3: Whole Match Reference`n" .
        "================================="

    ; Wrap all numbers in brackets
    text := "There are 5 apples and 10 oranges"
    result := RegExReplace(text, "\d+", "[$0]")

    MsgBox "Wrap Numbers:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Add quotes around words
    text := "Hello World Test"
    result := RegExReplace(text, "\w+", "'$0'")

    MsgBox "Quote Words:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Uppercase matched text (using callback would be better, but showing $0)
    text := "error warning info"
    result := RegExReplace(text, "error|warning", "[$0]")

    MsgBox "Highlight Keywords:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Duplicate matched text
    text := "test"
    result := RegExReplace(text, "\w+", "$0-$0")

    MsgBox "Duplicate:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Add prefix and suffix
    text := "Item1 Item2 Item3"
    result := RegExReplace(text, "Item\d+", "<$0>")

    MsgBox "Tag Items:`n" .
        "Original: " . text . "`n" .
        "Result: " . result
}

; ========================================
; EXAMPLE 4: Complex Reordering
; ========================================
; Advanced reordering and reformatting
Example4_ComplexReordering() {
    MsgBox "EXAMPLE 4: Complex Reordering`n" .
        "=============================="

    ; Reverse name order with title
    text := "Dr. John Michael Doe"
    result := RegExReplace(text, "(\w+)\. (\w+) (\w+) (\w+)", "$4, $2 $3, $1.")

    MsgBox "Reverse Name:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Reorder CSV columns
    csv := "Smith,John,30,Engineer"
    result := RegExReplace(csv, "([^,]+),([^,]+),([^,]+),([^,]+)", "$2 $1 ($4, age $3)")

    MsgBox "Reorder CSV:`n" .
        "Original: " . csv . "`n" .
        "Result: " . result

    ; Swap assignment
    code := "x = y"
    result := RegExReplace(code, "(\w+) = (\w+)", "$2 = $1")

    MsgBox "Swap Assignment:`n" .
        "Original: " . code . "`n" .
        "Result: " . result

    ; Reformat datetime
    text := "15/01/2024 14:30:45"
    result := RegExReplace(text, "(\d{2})/(\d{2})/(\d{4}) (\d{2}):(\d{2}):(\d{2})", "$3-$2-$1T$4:$5:$6")

    MsgBox "Datetime Format:`n" .
        "Original: " . text . "`n" .
        "ISO: " . result

    ; Extract and reorder path components
    path := "C:\Users\John\Documents\file.txt"
    result := RegExReplace(path, ".*\\([^\\]+)\\([^\\]+)$", "$2 from $1")

    MsgBox "Path Components:`n" .
        "Original: " . path . "`n" .
        "Result: " . result
}

; ========================================
; EXAMPLE 5: Escaping Dollar Signs
; ========================================
; Using $$ to insert literal dollar signs
Example5_EscapingDollars() {
    MsgBox "EXAMPLE 5: Escaping Dollar Signs`n" .
        "================================="

    ; Insert literal dollar sign
    text := "Price: 19.99"
    result := RegExReplace(text, "(\d+\.\d+)", "$$$1")

    MsgBox "Add Dollar Sign:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Create price template
    text := "19.99"
    result := RegExReplace(text, "(\d+)\.(\d+)", "Price: $$$1.$2")

    MsgBox "Price Format:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Mix literal and backreference
    text := "Cost is 50"
    result := RegExReplace(text, "(\d+)", "$$$1.00 USD")

    MsgBox "Add Currency:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Multiple dollar signs
    text := "100"
    result := RegExReplace(text, "(\d+)", "$$$$$ $1")  ; $$$ = $$ + $

    MsgBox "Multiple Dollars:`n" .
        "Original: " . text . "`n" .
        "Result: " . result
}

; ========================================
; EXAMPLE 6: Conditional Transformations
; ========================================
; Using backreferences for conditional logic
Example6_ConditionalTransformations() {
    MsgBox "EXAMPLE 6: Conditional Transformations`n" .
        "======================================="

    ; Convert markdown links to HTML
    markdown := "Check [link text](https://example.com) for info"
    result := RegExReplace(markdown, "\[([^\]]+)\]\(([^)]+)\)", '<a href="$2">$1</a>')

    MsgBox "Markdown to HTML:`n" .
        "Markdown: " . markdown . "`n" .
        "HTML: " . result

    ; Convert markdown bold to HTML
    markdown := "This is **bold** text"
    result := RegExReplace(markdown, "\*\*([^*]+)\*\*", "<b>$1</b>")

    MsgBox "Bold Markdown:`n" .
        "Markdown: " . markdown . "`n" .
        "HTML: " . result

    ; Convert markdown italic to HTML
    markdown := "This is *italic* text"
    result := RegExReplace(markdown, "\*([^*]+)\*", "<i>$1</i>")

    MsgBox "Italic Markdown:`n" .
        "Markdown: " . markdown . "`n" .
        "HTML: " . result

    ; Create variable substitution
    text := "Hello {{name}}, welcome to {{place}}"
    result := RegExReplace(text, "\{\{(\w+)\}\}", "$$$1")  ; Create $name, $place

    MsgBox "Template Variables:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; SQL to prepared statement
    sql := "SELECT * FROM users WHERE id = 123"
    result := RegExReplace(sql, "= (\d+)", "= ?")

    MsgBox "Parameterize SQL:`n" .
        "Original: " . sql . "`n" .
        "Result: " . result
}

; ========================================
; EXAMPLE 7: Real-World Applications
; ========================================
; Practical backreference use cases
Example7_RealWorld() {
    MsgBox "EXAMPLE 7: Real-World Applications`n" .
        "==================================="

    ; Format credit card display
    FormatCreditCard(number) {
        ; 1234567890123456 -> 1234 5678 9012 3456
        return RegExReplace(number, "(\d{4})(\d{4})(\d{4})(\d{4})", "$1 $2 $3 $4")
    }

    card := "1234567890123456"
    MsgBox "Credit Card Format:`n" .
        "Input: " . card . "`n" .
        "Output: " . FormatCreditCard(card)

    ; Convert snake_case to camelCase
    SnakeToCamel(text) {
        ; First pass: remove underscores and capitalize next letter
        return RegExReplace(text, "_(\w)", "$U$1")  ; $U uppercases next char
    }

    snake := "user_name_value"
    MsgBox "snake_case to camelCase:`n" .
        "Input: " . snake . "`n" .
        "Output: " . SnakeToCamel(snake)

    ; Obfuscate email addresses
    ObfuscateEmail(email) {
        return RegExReplace(email, "([^@]{2})[^@]+(@[^.]+)", "$1***$2")
    }

    emails := ["john.doe@example.com", "admin@test.org"]
    result := "Obfuscated Emails:`n"
    for email in emails {
        result .= email . " -> " . ObfuscateEmail(email) . "`n"
    }
    MsgBox result

    ; Create CSV from space-separated
    SpacesToCSV(text) {
        return RegExReplace(text, "(\w+)\s+(\w+)\s+(\w+)", '"$1","$2","$3"')
    }

    data := "John Doe 30"
    MsgBox "Space to CSV:`n" .
        "Input: " . data . "`n" .
        "Output: " . SpacesToCSV(data)

    ; Format SQL query
    FormatSQL(sql) {
        ; Add line breaks before keywords
        result := RegExReplace(sql, "\s+(SELECT|FROM|WHERE|ORDER BY)", "`n$1")
        return result
    }

    sql := "SELECT * FROM users WHERE age > 18 ORDER BY name"
    MsgBox "Format SQL:`n" .
        "Original: " . sql . "`n`n" .
        "Formatted:`n" . FormatSQL(sql)

    ; Extract initials from name
    GetInitials(name) {
        initials := ""
        pos := 1
        while (pos := RegExMatch(name, "\b(\w)", &match, pos)) {
            initials .= match[1]
            pos := match.Pos + match.Len
        }
        return initials
    }

    names := ["John Doe", "Mary Jane Smith", "Bob"]
    result := "Initials:`n"
    for name in names {
        result .= name . " -> " . GetInitials(name) . "`n"
    }
    MsgBox result

    ; Convert URL to anchor tag
    URLToLink(text) {
        return RegExReplace(text, "(https?://[^\s]+)", '<a href="$1">$1</a>')
    }

    text := "Visit https://example.com for more info"
    MsgBox "URL to Link:`n" .
        "Text: " . text . "`n`n" .
        "HTML: " . URLToLink(text)

    ; Reverse domain parts
    ReverseDomain(domain) {
        parts := StrSplit(domain, ".")
        reversed := ""
        Loop parts.Length {
            reversed .= parts[parts.Length - A_Index + 1]
            if A_Index < parts.Length
                reversed .= "."
        }
        return reversed
    }

    ; Or using regex
    ReverseDomainRegex(domain) {
        if RegExMatch(domain, "(\w+)\.(\w+)\.(\w+)", &m)
            return m[3] . "." . m[2] . "." . m[1]
        else if RegExMatch(domain, "(\w+)\.(\w+)", &m)
            return m[2] . "." . m[1]
        return domain
    }

    domains := ["www.example.com", "test.org"]
    result := "Reverse Domain:`n"
    for domain in domains {
        result .= domain . " -> " . ReverseDomainRegex(domain) . "`n"
    }
    MsgBox result
}

; ========================================
; Main Menu
; ========================================

ShowMenu() {
    menu := "
    (
    RegExReplace Backreferences
    ===========================

    1. Basic Backreferences ($1, $2)
    2. Named Backreferences (${name})
    3. Whole Match Reference ($0)
    4. Complex Reordering
    5. Escaping Dollar Signs ($$)
    6. Conditional Transformations
    7. Real-World Applications

    Press Ctrl+1-7 to run examples
    )"

    MsgBox menu
}

^1:: Example1_BasicBackreferences()
^2:: Example2_NamedBackreferences()
^3:: Example3_WholeMatch()
^4:: Example4_ComplexReordering()
^5:: Example5_EscapingDollars()
^6:: Example6_ConditionalTransformations()
^7:: Example7_RealWorld()

^h:: ShowMenu()

ShowMenu()
