#Requires AutoHotkey v2.0

/**
 * BuiltIn_RegEx_Replace_05_Advanced.ahk
 * 
 * DESCRIPTION:
 * Advanced RegExReplace techniques including lookahead/lookbehind replacements,
 * recursive patterns, performance optimization, and complex multi-step transformations.
 * 
 * FEATURES:
 * - Lookbehind and lookahead in replacements
 * - Multiple chained replacements
 * - Performance optimization techniques
 * - Complex text refactoring
 * - Edge case handling
 * - Recursive pattern applications
 * - Advanced transformation pipelines
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - RegEx
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Advanced PCRE features in replacements
 * - Optimization strategies
 * - Complex pattern combinations
 * - Memory-efficient processing
 * - Error handling
 * 
 * LEARNING POINTS:
 * 1. Lookaheads/lookbehinds work in replacement patterns
 * 2. Chain multiple replacements for complex transformations
 * 3. Order of operations matters significantly
 * 4. Performance can be improved with specific patterns
 * 5. Edge cases require careful testing
 * 6. Sometimes multiple simple steps beat one complex pattern
 * 7. Always validate results after transformation
 */

; ========================================
; EXAMPLE 1: Lookahead/Lookbehind Replacements
; ========================================
Example1_LookaroundReplacements() {
    MsgBox "EXAMPLE 1: Lookaround Replacements`n" .
        "===================================="

    ; Replace numbers followed by specific units
    text := "Weight: 50kg, Height: 180cm, Age: 25"
    result := RegExReplace(text, "\d+(?=kg)", "$0.0")
    MsgBox "Add decimal to kg values:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Replace currency amounts
    text := "Price: $50, Cost: €40, Value: $100"
    result := RegExReplace(text, "(?<=\$)\d+", "$0.00")
    MsgBox "Format dollar amounts:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Replace words not at boundaries
    text := "The theater has theatrical performances"
    result := RegExReplace(text, "(?<!^|\s)the", "THE")
    MsgBox "Replace 'the' not at word start:`n" .
        "Original: " . text . "`n" .
        "Result: " . result

    ; Add comma to numbers
    AddCommas(num) {
        return RegExReplace(num, "(\d)(?=(\d{3})+$)", "$1,")
    }
    MsgBox "Number formatting:`n" .
        "1234567 -> " . AddCommas("1234567")
}

; ========================================
; EXAMPLE 2: Chained Transformations
; ========================================
Example2_ChainedTransformations() {
    MsgBox "EXAMPLE 2: Chained Transformations`n" .
        "===================================="

    ; Complete text cleanup pipeline
    CleanText(text) {
        text := RegExReplace(text, "<[^>]+>", "")           ; Remove HTML
        text := RegExReplace(text, "\s+", " ")               ; Normalize spaces
        text := RegExReplace(text, "^\s+|\s+$", "")         ; Trim
        text := RegExReplace(text, "[^\w\s.,!?-]", "")      ; Remove special chars
        text := RegExReplace(text, "\.{2,}", ".")           ; Fix ellipsis
        return text
    }

    dirty := "  <p>Hello...   World!</p>  @#$  "
    clean := CleanText(dirty)
    MsgBox "Text Cleanup Pipeline:`n" .
        "Original: '" . dirty . "'`n" .
        "Cleaned: '" . clean . "'"

    ; Code formatting pipeline
    FormatCode(code) {
        code := RegExReplace(code, "\s*([{}])\s*", " $1 ")  ; Space around braces
        code := RegExReplace(code, "\s*([,;])", "$1 ")      ; Space after punctuation
        code := RegExReplace(code, "\s{2,}", " ")           ; Normalize spaces
        return Trim(code)
    }

    code := "if(x>5){y=10;z=20;}"
    MsgBox "Code Formatting:`n" .
        "Original: " . code . "`n" .
        "Formatted: " . FormatCode(code)
}

; ========================================
; EXAMPLE 3: Performance Optimization
; ========================================
Example3_PerformanceOptimization() {
    MsgBox "EXAMPLE 3: Performance Optimization`n" .
        "====================================="

    ; Inefficient: Multiple passes
    SlowClean(text) {
        text := RegExReplace(text, " the ", " a ")
        text := RegExReplace(text, " and ", " & ")
        text := RegExReplace(text, " or ", " | ")
        return text
    }

    ; Efficient: Single pass with alternation
    FastClean(text) {
        return RegExReplace(text, " (the|and|or) ", ReplaceWord)
    }

    ReplaceWord(match) {
        replacements := Map("the", "a", "and", "&", "or", "|")
        return " " . replacements[match[1]] . " "
    }

    text := "the cat and the dog or the bird"
    MsgBox "Performance Comparison:`n" .
        "Single pass is faster than multiple passes`n`n" .
        "Original: " . text . "`n" .
        "Result: " . FastClean(text)

    ; Atomic groups for efficiency
    text := StrRepeat("a", 20) . "b"
    start := A_TickCount
    RegExReplace(text, "(?>a+)b", "X")
    time1 := A_TickCount - start

    MsgBox "Atomic groups prevent backtracking`n" .
        "Process time: " . time1 . "ms"
}

; ========================================
; EXAMPLE 4: Complex Refactoring
; ========================================
Example4_ComplexRefactoring() {
    MsgBox "EXAMPLE 4: Complex Refactoring`n" .
        "================================"

    ; Refactor variable names
    RefactorCode(code) {
        ; Old style: m_variableName -> new style: variableName_
        code := RegExReplace(code, "\bm_(\w+)", "$1_")

        ; Old function call: oldFunc() -> newFunc()
        code := RegExReplace(code, "\boldFunc\b", "newFunc")

        ; Add type hints: var x = -> int x =
        code := RegExReplace(code, "\bvar\s+(\w+)\s*=\s*(\d+)", "int $1 = $2")

        return code
    }

    oldCode := "var m_count = 5`noldFunc(m_value)"
    newCode := RefactorCode(oldCode)

    MsgBox "Code Refactoring:`n" .
        "Original:`n" . oldCode . "`n`n" .
        "Refactored:`n" . newCode

    ; Restructure data format
    csvLine := "John,Doe,30,Engineer"
    jsonLine := RegExReplace(csvLine, "([^,]+),([^,]+),([^,]+),([^,]+)",
        '{"first":"$1","last":"$2","age":$3,"job":"$4"}')

    MsgBox "CSV to JSON:`n" .
        "CSV: " . csvLine . "`n" .
        "JSON: " . jsonLine
}

; ========================================
; EXAMPLE 5: Edge Case Handling
; ========================================
Example5_EdgeCases() {
    MsgBox "EXAMPLE 5: Edge Case Handling`n" .
        "=============================="

    ; Safe division in calculations
    SafeReplace(text) {
        ; Only replace if it's a valid number
        return RegExReplace(text, "\b\d+\b", MultiplyIfValid)
    }

    MultiplyIfValid(match) {
        try {
            num := Integer(match[0])
            return String(num * 2)
        } catch {
            return match[0]
        }
    }

    text := "Values: 10, 20, 99999999999999999999, 30"
    MsgBox "Safe Numeric Operations:`n" .
        "Original: " . text . "`n" .
        "Result: " . SafeReplace(text)

    ; Handle empty matches
    text := "word1  word2   word3"
    result := RegExReplace(text, "\s+", " ")
    MsgBox "Handle multiple spaces:`n" .
        "Original: '" . text . "'`n" .
        "Result: '" . result . "'"

    ; Preserve intentional formatting
    PreserveCode(text) {
        ; Don't collapse spaces in quoted strings
        inQuote := false
        ; This is simplified - real implementation would be more complex
        return RegExReplace(text, "\s+", " ")
    }
}

; ========================================
; EXAMPLE 6: Recursive Applications
; ========================================
Example6_RecursiveApplications() {
    MsgBox "EXAMPLE 6: Recursive Applications`n" .
        "=================================="

    ; Remove nested parentheses
    RemoveNested(text) {
        loop {
            newText := RegExReplace(text, "\([^()]*\)", "")
            if newText = text
                break
            text := newText
        }
        return text
    }

    text := "Text (with (nested (deep) parentheses) here) end"
    MsgBox "Remove Nested Parentheses:`n" .
        "Original: " . text . "`n" .
        "Result: " . RemoveNested(text)

    ; Flatten nested tags
    FlattenTags(html) {
        loop 5 {  ; Limit iterations
            newHtml := RegExReplace(html, "<b>([^<]*)</b>", "$1")
            if newHtml = html
                break
            html := newHtml
        }
        return html
    }

    html := "<b><b><b>Bold</b></b></b>"
    MsgBox "Flatten Tags:`n" .
        "Original: " . html . "`n" .
        "Result: " . FlattenTags(html)
}

; ========================================
; EXAMPLE 7: Advanced Pipelines
; ========================================
Example7_AdvancedPipelines() {
    MsgBox "EXAMPLE 7: Advanced Pipelines`n" .
        "=============================="

    ; Markdown to HTML converter
    MarkdownToHTML(md) {
        html := md

        ; Headers
        html := RegExReplace(html, "^### (.+)$", "<h3>$1</h3>", , , 1)
        html := RegExReplace(html, "^## (.+)$", "<h2>$1</h2>", , , 1)
        html := RegExReplace(html, "^# (.+)$", "<h1>$1</h1>", , , 1)

        ; Bold and italic
        html := RegExReplace(html, "\*\*([^*]+)\*\*", "<b>$1</b>")
        html := RegExReplace(html, "\*([^*]+)\*", "<i>$1</i>")

        ; Links
        html := RegExReplace(html, "\[([^\]]+)\]\(([^)]+)\)", '<a href="$2">$1</a>')

        ; Code
        html := RegExReplace(html, "`([^`]+)`", " < code > $1 < / code > ")
            return html
        }

        md := "# Title`n**Bold** and *italic* with [link](http://example.com)"
        MsgBox "Markdown to HTML:`n" .
            "Markdown:`n" . md . "`n`n" .
            "HTML:`n" . MarkdownToHTML(md)

        ; Advanced sanitization
        SecuritySanitize(text) {
            ; Remove scripts
            text := RegExReplace(text, "i)<script[^>]*>.*?</script>", "")
            ; Remove event handlers
            text := RegExReplace(text, 'i)\s*on\w+\s*=\s*"[^"]*"', "")
            ; Remove javascript: protocol
            text := RegExReplace(text, 'i)javascript:', "")
            ; Clean remaining HTML
            text := RegExReplace(text, "<(?!/?[biu]>)[^>]*>", "")
            return text
        }

        dangerous := '<p onclick="alert()">Text<script>bad()</script></p>'
        safe := SecuritySanitize(dangerous)

        MsgBox "Security Sanitization:`n" .
            "Dangerous: " . dangerous . "`n" .
            "Safe: " . safe
    }

    ; Helper Functions
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
    RegExReplace Advanced Techniques
    =================================

    1. Lookaround Replacements
    2. Chained Transformations
    3. Performance Optimization
    4. Complex Refactoring
    5. Edge Case Handling
    6. Recursive Applications
    7. Advanced Pipelines

    Press Ctrl+1-7 to run examples
    )"
    }

    ^1:: Example1_LookaroundReplacements()
    ^2:: Example2_ChainedTransformations()
    ^3:: Example3_PerformanceOptimization()
    ^4:: Example4_ComplexRefactoring()
    ^5:: Example5_EdgeCases()
    ^6:: Example6_RecursiveApplications()
    ^7:: Example7_AdvancedPipelines()
    ^h:: ShowMenu()

    ShowMenu()
