#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_RegEx_Replace_03_Functions.ahk
 * 
 * DESCRIPTION:
 * Demonstrates using function callbacks in RegExReplace for dynamic replacements.
 * Shows how to pass a function reference to perform complex transformations that
 * cannot be achieved with simple backreference patterns.
 * 
 * FEATURES:
 * - Using function callbacks for replacement
 * - Accessing Match object in callback
 * - Dynamic transformations based on matched text
 * - Case conversion in replacements
 * - Mathematical operations on matched numbers
 * - Conditional replacement logic
 * - Complex text processing
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - RegEx
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Function references as replacement parameter
 * - Match object parameter in callbacks
 * - Modern function syntax
 * - Flexible replacement logic
 * - Integration with other functions
 * 
 * LEARNING POINTS:
 * 1. Pass a function reference as the replacement parameter
 * 2. Callback receives Match object with full match details
 * 3. Return value becomes the replacement text
 * 4. Enables transformations impossible with static replacements
 * 5. Can call other functions or perform calculations
 * 6. Useful for case conversion, formatting, lookups, etc.
 * 7. Callback is called once per match
 */

; ========================================
; EXAMPLE 1: Basic Function Callback
; ========================================
Example1_BasicCallback() {
    MsgBox "EXAMPLE 1: Basic Function Callback`n" .
        "==================================="

    ; Simple uppercase callback
    UpperCallback(match) {
        return StrUpper(match[0])
    }

    text := "hello world"
    result := RegExReplace(text, "\w+", UpperCallback)

    MsgBox "Uppercase Callback:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Add brackets around matches
    BracketCallback(match) {
        return "[" . match[0] . "]"
    }

    text := "one two three"
    result := RegExReplace(text, "\w+", BracketCallback)

    MsgBox "Bracket Callback:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Reverse matched text
    ReverseCallback(match) {
        text := match[0]
        reversed := ""
        Loop Parse, text {
            reversed := A_LoopField . reversed
        }
        return reversed
    }

    text := "Hello World"
    result := RegExReplace(text, "\w+", ReverseCallback)

    MsgBox "Reverse Words:`n" .
        "Original: " . text . "`n" .
        "Result: " . result
}

; ========================================
; EXAMPLE 2: Case Conversion
; ========================================
Example2_CaseConversion() {
    MsgBox "EXAMPLE 2: Case Conversion`n" .
        "==========================="

    ; Title case converter
    TitleCase(match) {
        word := match[0]
        return StrUpper(SubStr(word, 1, 1)) . StrLower(SubStr(word, 2))
    }

    text := "the quick BROWN fox JUMPS"
    result := RegExReplace(text, "\w+", TitleCase)

    MsgBox "Title Case:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Alternate case
    static toggle := true
    AlternateCase(match) {
        toggle := !toggle
        return toggle ? StrUpper(match[0]) : StrLower(match[0])
    }

    text := "word1 word2 word3 word4"
    result := RegExReplace(text, "\w+", AlternateCase)

    MsgBox "Alternate Case:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; camelCase to Title Case
    CamelToTitle(match) {
        return " " . StrUpper(match[1])
    }

    text := "userNameValue"
    result := RegExReplace(text, "([A-Z])", CamelToTitle)
    result := StrUpper(SubStr(result, 1, 1)) . SubStr(result, 2)  ; Fix first char

    MsgBox "camelCase to Title:`n" .
        "Original: " . text . "`n" .
        "Result: " . result
}

; ========================================
; EXAMPLE 3: Number Operations
; ========================================
Example3_NumberOperations() {
    MsgBox "EXAMPLE 3: Number Operations`n" .
        "============================="

    ; Double all numbers
    Double(match) {
        return String(Integer(match[0]) * 2)
    }

    text := "I have 5 apples and 10 oranges"
    result := RegExReplace(text, "\d+", Double)

    MsgBox "Double Numbers:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Add 100 to all numbers
    Add100(match) {
        return String(Integer(match[0]) + 100)
    }

    text := "Scores: 85, 90, 75"
    result := RegExReplace(text, "\d+", Add100)

    MsgBox "Add 100:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Convert percentage to decimal
    PercentToDecimal(match) {
        return String(Float(match[1]) / 100)
    }

    text := "Discount: 25%, Tax: 10%"
    result := RegExReplace(text, "(\d+)%", PercentToDecimal)

    MsgBox "Percent to Decimal:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Format currency
    FormatCurrency(match) {
        num := Float(match[0])
        return Format("${:.2f}", num)
    }

    text := "Prices: 19.9, 5.5, 100"
    result := RegExReplace(text, "\d+\.?\d*", FormatCurrency)

    MsgBox "Format Currency:`n" .
        "Original: " . text . "`n" .
        "Result: " . result
}

; ========================================
; EXAMPLE 4: Conditional Replacement
; ========================================
Example4_ConditionalReplacement() {
    MsgBox "EXAMPLE 4: Conditional Replacement`n" .
        "===================================="

    ; Replace only large numbers
    ReplaceIfLarge(match) {
        num := Integer(match[0])
        return num > 50 ? "LARGE" : match[0]
    }

    text := "Values: 25, 60, 30, 75, 15"
    result := RegExReplace(text, "\d+", ReplaceIfLarge)

    MsgBox "Replace Large Numbers:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Censor long words
    CensorLong(match) {
        word := match[0]
        return StrLen(word) > 5 ? StrRepeat("*", StrLen(word)) : word
    }

    text := "The quick brown fox jumps"
    result := RegExReplace(text, "\w+", CensorLong)

    MsgBox "Censor Long Words:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Conditional formatting
    FormatNumber(match) {
        num := Integer(match[0])
        if num < 0
            return "(" . Abs(num) . ")"
        else if num = 0
            return "-"
        else
            return "+" . num
    }

    text := "Values: 10, -5, 0, 25, -15"
    result := RegExReplace(text, "-?\d+", FormatNumber)

    MsgBox "Format Numbers:`n" .
        "Original: " . text . "`n" .
        "Result: " . result
}

; ========================================
; EXAMPLE 5: Using Captured Groups
; ========================================
Example5_UsingGroups() {
    MsgBox "EXAMPLE 5: Using Captured Groups`n" .
        "=================================="

    ; Reformat date with validation
    FormatDate(match) {
        year := match[1]
        month := match[2]
        day := match[3]

        ; Validate month
        if Integer(month) > 12 || Integer(month) < 1
            return match[0]  ; Return unchanged

        return month . "/" . day . "/" . year
    }

    text := "Dates: 2024-01-15, 2024-13-01, 2024-06-30"
    result := RegExReplace(text, "(\d{4})-(\d{2})-(\d{2})", FormatDate)

    MsgBox "Format & Validate Dates:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Create email links
    EmailToLink(match) {
        user := match[1]
        domain := match[2]
        return '<a href="mailto:' . user . '@' . domain . '">' . user . '@' . domain . '</a>'
    }

    text := "Contact: john@example.com or admin@test.org"
    result := RegExReplace(text, "(\w+)@([\w.]+)", EmailToLink)

    MsgBox "Email to Link:`n" .
        "Text: " . text . "`n`n" .
        "HTML: " . result

    ; Phone number formatting
    FormatPhone(match) {
        return "(" . match[1] . ") " . match[2] . "-" . match[3]
    }

    text := "Call 5551234567 or 8005559999"
    result := RegExReplace(text, "(\d{3})(\d{3})(\d{4})", FormatPhone)

    MsgBox "Format Phone:`n" .
        "Original: " . text . "`n" .
        "Result: " . result
}

; ========================================
; EXAMPLE 6: Lookup Tables
; ========================================
Example6_LookupTables() {
    MsgBox "EXAMPLE 6: Lookup Tables`n" .
        "========================="

    ; Month name to number
    monthMap := Map(
        "January", "01", "February", "02", "March", "03",
        "April", "04", "May", "05", "June", "06",
        "July", "07", "August", "08", "September", "09",
        "October", "10", "November", "11", "December", "12"
    )

    MonthToNumber(match) {
        return monthMap.Has(match[0]) ? monthMap[match[0]] : match[0]
    }

    text := "January 15, 2024 and March 20, 2024"
    result := RegExReplace(text, "\b[A-Z][a-z]+\b", MonthToNumber)

    MsgBox "Month to Number:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Emoticon to emoji
    emoticonMap := Map(
        ":)", "😊",
        ":(", "😞",
        ":D", "😄",
        ";)", "😉"
    )

    EmoticonToEmoji(match) {
        return emoticonMap.Has(match[0]) ? emoticonMap[match[0]] : match[0]
    }

    text := "Hello :) How are you? :D"
    result := RegExReplace(text, ":\)|:\(|:D|;\)", EmoticonToEmoji)

    MsgBox "Emoticon to Emoji:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Status code to message
    statusMap := Map(
        "200", "OK",
        "404", "Not Found",
        "500", "Server Error"
    )

    StatusMessage(match) {
        code := match[0]
        return code . " " . (statusMap.Has(code) ? statusMap[code] : "Unknown")
    }

    text := "Status: 200, 404, 500, 999"
    result := RegExReplace(text, "\b\d{3}\b", StatusMessage)

    MsgBox "Status Codes:`n" .
        "Original: " . text . "`n" .
        "Result: " . result
}

; ========================================
; EXAMPLE 7: Advanced Applications
; ========================================
Example7_AdvancedApplications() {
    MsgBox "EXAMPLE 7: Advanced Applications`n" .
        "=================================="

    ; Markdown code blocks to HTML
    CodeToHTML(match) {
        code := match[1]
        return "<pre><code>" . code . "</code></pre>"
    }

    markdown := "Here is `code` and `more code`"
    result := RegExReplace(markdown, "`([^`]+)`", CodeToHTML)
        MsgBox "Markdown Code:`n" .
        "Markdown: " . markdown . "`n`n" .
        "HTML: " . result
        ; Smart quotes
        static quoteOpen := true
        SmartQuote(match) {
            quoteOpen := !quoteOpen
            return quoteOpen ? "" " : " ""
                }

            text := 'He said "Hello" and she said "Goodbye"'
            result := RegExReplace(text, '"', SmartQuote)

            MsgBox "Smart Quotes:`n" .
                "Original: " . text . "`n" .
                "Result: " . result

            ; Calculate math expressions
            Calculate(match) {
                try {
                    ; Simple evaluation (be careful with security!)
                    expr := match[0]
                    ; Only handle simple cases for safety
                    if RegExMatch(expr, "(\d+)\+(\d+)", &m)
                        return String(Integer(m[1]) + Integer(m[2]))
                    else if RegExMatch(expr, "(\d+)\*(\d+)", &m)
                        return String(Integer(m[1]) * Integer(m[2]))
                }
                return match[0]
            }

            text := "Results: 5+3, 4*6, 10+20"
            result := RegExReplace(text, "\d+[+*]\d+", Calculate)

            MsgBox "Calculate:`n" .
                "Original: " . text . "`n" .
                "Result: " . result

            ; ROT13 cipher
            ROT13(match) {
                char := match[0]
                code := Ord(char)
                if code >= 65 && code <= 90  ; A-Z
                    return Chr(((code - 65 + 13) mod 26) + 65)
                else if code >= 97 && code <= 122  ; a-z
                    return Chr(((code - 97 + 13) mod 26) + 97)
                return char
            }

            text := "Hello World"
            result := RegExReplace(text, "[a-zA-Z]", ROT13)

            MsgBox "ROT13 Cipher:`n" .
                "Original: " . text . "`n" .
                "Encoded: " . result . "`n" .
                "Decoded: " . RegExReplace(result, "[a-zA-Z]", ROT13)
        }
        ; Helper function
        StrRepeat(str, count) {
            result := ""
            Loop count
                result .= str
            return result
        }
        ; Main Menu
        ShowMenu() {
            MsgBox "
    (
    RegExReplace Function Callbacks
    ================================

    1. Basic Function Callback
    2. Case Conversion
    3. Number Operations
    4. Conditional Replacement
    5. Using Captured Groups
    6. Lookup Tables
    7. Advanced Applications

    Press Ctrl+1-7 to run examples
    )"
        }
        ^1:: Example1_BasicCallback()
        ^2:: Example2_CaseConversion()
        ^3:: Example3_NumberOperations()
        ^4:: Example4_ConditionalReplacement()
        ^5:: Example5_UsingGroups()
        ^6:: Example6_LookupTables()
        ^7:: Example7_AdvancedApplications()
        ^h:: ShowMenu()
        ShowMenu()
