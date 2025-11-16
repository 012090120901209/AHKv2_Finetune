#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * BUILT-IN FUNCTION: StrReplace() - Advanced Replacement Techniques
 * ============================================================================
 *
 * DESCRIPTION:
 *   Advanced examples demonstrating sophisticated uses of the StrReplace()
 *   function in AutoHotkey v2. This file covers chain replacements, template
 *   variable substitution, bulk text operations, dynamic replacements, and
 *   complex text transformation scenarios.
 *
 * FEATURES DEMONSTRATED:
 *   - Chain replacement operations for complex transformations
 *   - Template variable substitution systems
 *   - Bulk find-and-replace operations
 *   - Dynamic placeholder replacement
 *   - Nested and recursive replacements
 *   - Configuration-driven text transformation
 *   - Multi-language text processing
 *
 * SOURCE:
 *   AutoHotkey v2 Documentation - StrReplace()
 *   https://www.autohotkey.com/docs/v2/lib/StrReplace.html
 *
 * KEY V2 FEATURES DEMONSTRATED:
 *   - Maps for configuration-driven replacements
 *   - Array iteration for bulk operations
 *   - Function composition and chaining
 *   - Modern parameter handling
 *   - Dynamic text processing patterns
 *
 * LEARNING POINTS:
 *   1. Chain multiple StrReplace calls for complex transformations
 *   2. Use Maps to store replacement rules for dynamic processing
 *   3. Build template systems using placeholder replacement
 *   4. Create reusable text transformation pipelines
 *   5. Handle order-dependent replacements carefully
 *   6. Combine StrReplace with other string functions for power
 *   7. Design maintainable bulk replacement systems
 *
 * ============================================================================
 */

; ============================================================================
; EXAMPLE 1: Chain Replacements for Complex Transformations
; ============================================================================
; Demonstrates building complex text transformations by chaining multiple
; StrReplace operations in sequence.

Example1_ChainReplacements() {
    ; Original code snippet that needs multiple transformations
    OriginalCode := "
    (
    function getUserData() {
        var userName = getUsername();
        var userEmail = getEmail();
        var userAge = getAge();
        return {name: userName, email: userEmail, age: userAge};
    }
    )"

    ; Transform JavaScript to more modern syntax through chained replacements
    ; Step 1: Replace 'var' with 'const'
    ModernCode := StrReplace(OriginalCode, "var ", "const ")

    ; Step 2: Replace snake_case function names with camelCase equivalents
    ModernCode := StrReplace(ModernCode, "function getUserData", "function getUserData")

    ; Step 3: Replace traditional function syntax with arrow function
    ModernCode := StrReplace(ModernCode, "function getUserData() {", "const getUserData = () => {")

    ; Another example: Text style transformation
    RawText := "The QUICK brown FOX jumps OVER the LAZY dog"

    ; Chain 1: Normalize case
    Step1 := StrLower(RawText)

    ; Chain 2: Capitalize first letter (simplified)
    Step2 := StrUpper(SubStr(Step1, 1, 1)) . SubStr(Step1, 2)

    ; Chain 3: Replace specific words
    Step3 := StrReplace(Step2, "fox", "cat")
    Step4 := StrReplace(Step3, "dog", "mouse")

    ; Complex example: Document formatting
    Document := "Chapter 1: Introduction\n\nThis is the first paragraph.\n\nThis is the second paragraph."

    ; Apply multiple formatting transformations
    Formatted := Document
    Formatted := StrReplace(Formatted, "Chapter ", "## Chapter ")  ; Markdown heading
    Formatted := StrReplace(Formatted, "\n\n", "`n`n")              ; Normalize line breaks
    Formatted := StrReplace(Formatted, "first", "**first**")        ; Bold
    Formatted := StrReplace(Formatted, "second", "*second*")        ; Italic

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 1: Chain Replacements
    ═══════════════════════════════════════════════════

    CODE TRANSFORMATION:
    ───────────────────────────────────────────────────
    Original JavaScript:
    " OriginalCode "

    After chained transformations:
    " ModernCode "

    ───────────────────────────────────────────────────
    TEXT TRANSFORMATION:
    Original: " RawText "
    Step 1 (lowercase): " Step1 "
    Step 2 (capitalize): " Step2 "
    Step 3 (fox→cat): " Step3 "
    Step 4 (dog→mouse): " Step4 "

    ───────────────────────────────────────────────────
    DOCUMENT FORMATTING:
    " Formatted "
    )", "StrReplace Example 1", 0)

    ; KEY LEARNING: Chain StrReplace calls to build complex transformations.
    ; Each step processes the output of the previous step.
}

; ============================================================================
; EXAMPLE 2: Template Variable Substitution
; ============================================================================
; Shows how to create a template system that replaces placeholders with
; actual values using StrReplace.

Example2_TemplateSubstitution() {
    ; Email template with placeholders
    EmailTemplate := "
    (
    Dear {{NAME}},

    Thank you for your order #{{ORDER_ID}}. Your total is ${{AMOUNT}}.

    Your items will be shipped to:
    {{ADDRESS}}
    {{CITY}}, {{STATE}} {{ZIP}}

    Expected delivery: {{DELIVERY_DATE}}

    Best regards,
    {{COMPANY_NAME}}
    )"

    ; Template data
    TemplateData := Map(
        "NAME", "John Smith",
        "ORDER_ID", "12345",
        "AMOUNT", "99.99",
        "ADDRESS", "123 Main Street",
        "CITY", "Springfield",
        "STATE", "IL",
        "ZIP", "62701",
        "DELIVERY_DATE", "2024-01-20",
        "COMPANY_NAME", "Acme Corporation"
    )

    ; Process template by replacing all placeholders
    ProcessedEmail := EmailTemplate
    for placeholder, value in TemplateData {
        ProcessedEmail := StrReplace(ProcessedEmail, "{{" . placeholder . "}}", value)
    }

    ; HTML template example
    HTMLTemplate := "
    (
    <div class='user-card'>
        <h2>{{user_name}}</h2>
        <p>Email: <a href='mailto:{{user_email}}'>{{user_email}}</a></p>
        <p>Role: {{user_role}}</p>
        <p>Member since: {{member_since}}</p>
    </div>
    )"

    UserData := Map(
        "user_name", "Alice Johnson",
        "user_email", "alice@example.com",
        "user_role", "Administrator",
        "member_since", "January 2020"
    )

    ProcessedHTML := HTMLTemplate
    for key, value in UserData {
        ProcessedHTML := StrReplace(ProcessedHTML, "{{" . key . "}}", value)
    }

    ; SQL query template
    SQLTemplate := "SELECT * FROM {{table}} WHERE {{column}} = '{{value}}' AND status = '{{status}}'"

    QueryData := Map(
        "table", "users",
        "column", "email",
        "value", "user@example.com",
        "status", "active"
    )

    ProcessedSQL := SQLTemplate
    for key, value in QueryData {
        ProcessedSQL := StrReplace(ProcessedSQL, "{{" . key . "}}", value)
    }

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 2: Template Variable Substitution
    ═══════════════════════════════════════════════════

    EMAIL TEMPLATE RESULT:
    " ProcessedEmail "

    ───────────────────────────────────────────────────
    HTML TEMPLATE RESULT:
    " ProcessedHTML "

    ───────────────────────────────────────────────────
    SQL QUERY RESULT:
    " ProcessedSQL "
    )", "StrReplace Example 2", 0)

    ; KEY LEARNING: Use Maps to store template data and iterate
    ; through them to replace all placeholders. This creates a
    ; flexible, reusable template system.
}

; ============================================================================
; EXAMPLE 3: Bulk Find-and-Replace Operations
; ============================================================================
; Demonstrates performing multiple find-and-replace operations on text
; using configuration-driven approaches.

Example3_BulkReplacements() {
    ; Sample document with coding terminology
    Document := "
    (
    In JavaScript, we use var to declare variables.
    The var keyword has function scope, not block scope.
    Modern JavaScript prefers let and const over var.
    Always use var sparingly in legacy code.
    )"

    ; Define bulk replacements as a Map
    Replacements := Map(
        "var", "let",
        "function scope", "function-level scope",
        "block scope", "block-level scope",
        "JavaScript", "ECMAScript"
    )

    ; Apply all replacements
    UpdatedDoc := Document
    for oldText, newText in Replacements {
        UpdatedDoc := StrReplace(UpdatedDoc, oldText, newText)
    }

    ; Example 2: Standardize terminology across documentation
    TechDoc := "
    (
    Users can login to the system. After login, they can
    access their dashboard. The log-in process is secure.
    Remember to log in before accessing protected resources.
    )"

    ; Standardize variations of "login"
    LoginFixes := Map(
        "login", "log in",
        "log-in", "log in"
    )

    StandardizedDoc := TechDoc
    for old, new in LoginFixes {
        StandardizedDoc := StrReplace(StandardizedDoc, old, new, false)  ; case-insensitive
    }

    ; Example 3: Brand name changes across website content
    WebContent := "
    (
    Welcome to OldBrand! OldBrand provides quality service.
    Visit OldBrand.com for more information about OldBrand products.
    Contact OldBrand support at support@oldbrand.com.
    )"

    BrandChanges := Map(
        "OldBrand", "NewBrand",
        "oldbrand.com", "newbrand.com",
        "oldbrand", "newbrand"
    )

    RebrandedContent := WebContent
    ; Note: Order matters! Replace more specific terms first
    RebrandedContent := StrReplace(RebrandedContent, "oldbrand.com", "newbrand.com", false)
    RebrandedContent := StrReplace(RebrandedContent, "OldBrand", "NewBrand", false)

    ; Example 4: Autocorrect common typos
    TypoText := "The quick borwn fox jumps over teh lazy dog. Thsi is a tset."

    CommonTypos := Map(
        "borwn", "brown",
        "teh", "the",
        "thsi", "this",
        "tset", "test"
    )

    CorrectedText := TypoText
    for typo, correct in CommonTypos {
        ; Count corrections
        count := 0
        CorrectedText := StrReplace(CorrectedText, typo, correct, false, &count)
    }

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 3: Bulk Find-and-Replace Operations
    ═══════════════════════════════════════════════════

    TERMINOLOGY UPDATE:
    ───────────────────────────────────────────────────
    Original:
    " Document "

    Updated:
    " UpdatedDoc "

    ───────────────────────────────────────────────────
    STANDARDIZATION:
    Original:
    " TechDoc "

    Standardized:
    " StandardizedDoc "

    ───────────────────────────────────────────────────
    REBRANDING:
    Original:
    " WebContent "

    Rebranded:
    " RebrandedContent "

    ───────────────────────────────────────────────────
    AUTOCORRECT:
    Original: " TypoText "
    Corrected: " CorrectedText "
    )", "StrReplace Example 3", 0)

    ; KEY LEARNING: Use Maps to define bulk replacements.
    ; Be careful of replacement order when terms overlap.
}

; ============================================================================
; EXAMPLE 4: Dynamic Placeholder Replacement
; ============================================================================
; Shows how to dynamically replace placeholders with computed values,
; including dates, times, and calculated data.

Example4_DynamicPlaceholders() {
    ; Template with dynamic placeholders
    Template := "
    (
    Report Generated: {{CURRENT_DATE}} at {{CURRENT_TIME}}
    Report Period: {{START_DATE}} to {{END_DATE}}
    Total Days: {{DAYS_ELAPSED}}
    Generated by: {{USERNAME}}
    Computer: {{COMPUTERNAME}}
    )"

    ; Generate dynamic values
    CurrentDate := FormatTime(, "yyyy-MM-dd")
    CurrentTime := FormatTime(, "HH:mm:ss")
    StartDate := "2024-01-01"
    EndDate := "2024-01-31"
    DaysElapsed := "31"  ; In real scenario, calculate this
    UserName := A_UserName
    ComputerName := A_ComputerName

    ; Create data map
    DynamicData := Map(
        "CURRENT_DATE", CurrentDate,
        "CURRENT_TIME", CurrentTime,
        "START_DATE", StartDate,
        "END_DATE", EndDate,
        "DAYS_ELAPSED", DaysElapsed,
        "USERNAME", UserName,
        "COMPUTERNAME", ComputerName
    )

    ; Process template
    Report := Template
    for placeholder, value in DynamicData {
        Report := StrReplace(Report, "{{" . placeholder . "}}", value)
    }

    ; Example 2: Configuration file generation
    ConfigTemplate := "
    (
    [Settings]
    InstallPath={{INSTALL_PATH}}
    DataPath={{DATA_PATH}}
    LogPath={{LOG_PATH}}
    TempPath={{TEMP_PATH}}
    Version={{VERSION}}
    BuildDate={{BUILD_DATE}}
    )"

    ; Generate paths dynamically
    InstallPath := A_ProgramFiles . "\MyApp"
    DataPath := A_AppData . "\MyApp\Data"
    LogPath := A_AppData . "\MyApp\Logs"
    TempPath := A_Temp . "\MyApp"
    Version := "1.0.0"
    BuildDate := FormatTime(, "yyyy-MM-dd")

    ConfigData := Map(
        "INSTALL_PATH", InstallPath,
        "DATA_PATH", DataPath,
        "LOG_PATH", LogPath,
        "TEMP_PATH", TempPath,
        "VERSION", Version,
        "BUILD_DATE", BuildDate
    )

    ConfigFile := ConfigTemplate
    for key, value in ConfigData {
        ConfigFile := StrReplace(ConfigFile, "{{" . key . "}}", value)
    }

    ; Example 3: URL builder with query parameters
    URLTemplate := "https://api.example.com/{{ENDPOINT}}?user={{USER_ID}}&token={{TOKEN}}&timestamp={{TIMESTAMP}}"

    URLData := Map(
        "ENDPOINT", "data/export",
        "USER_ID", "12345",
        "TOKEN", "abc123xyz",
        "TIMESTAMP", String(A_TickCount)
    )

    GeneratedURL := URLTemplate
    for key, value in URLData {
        GeneratedURL := StrReplace(GeneratedURL, "{{" . key . "}}", value)
    }

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 4: Dynamic Placeholder Replacement
    ═══════════════════════════════════════════════════

    GENERATED REPORT:
    " Report "

    ───────────────────────────────────────────────────
    GENERATED CONFIG FILE:
    " ConfigFile "

    ───────────────────────────────────────────────────
    GENERATED URL:
    " GeneratedURL "
    )", "StrReplace Example 4", 0)

    ; KEY LEARNING: Combine StrReplace with system variables and
    ; functions to create dynamic content generation systems.
}

; ============================================================================
; EXAMPLE 5: Order-Dependent Replacements
; ============================================================================
; Demonstrates the importance of replacement order and how to handle
; situations where order matters.

Example5_OrderDependentReplacements() {
    ; Example showing why order matters
    Text := "I have 1 apple and 1 orange."

    ; Wrong order - second replacement affects first
    WrongOrder1 := StrReplace(Text, "1", "one")      ; "I have one apple and one orange."
    WrongOrder2 := StrReplace(WrongOrder1, "one", "1") ; Back to original!

    ; Correct approach: Use unique temporary placeholders
    CorrectOrder1 := StrReplace(Text, "1 apple", "TEMP_APPLE")
    CorrectOrder2 := StrReplace(CorrectOrder1, "1 orange", "TEMP_ORANGE")
    CorrectOrder3 := StrReplace(CorrectOrder2, "TEMP_APPLE", "one apple")
    CorrectOrder4 := StrReplace(CorrectOrder3, "TEMP_ORANGE", "two oranges")

    ; Example 2: Swapping values
    SwapText := "A=1, B=2, C=3"

    ; Naive approach (WRONG) - values get mixed up
    Wrong1 := StrReplace(SwapText, "1", "2")  ; A=2, B=2, C=3
    Wrong2 := StrReplace(Wrong1, "2", "1")    ; A=1, B=1, C=3 (Not what we want!)

    ; Correct approach using temporary placeholders
    Correct1 := StrReplace(SwapText, "1", "TEMP1")    ; A=TEMP1, B=2, C=3
    Correct2 := StrReplace(Correct1, "2", "TEMP2")    ; A=TEMP1, B=TEMP2, C=3
    Correct3 := StrReplace(Correct2, "3", "TEMP3")    ; A=TEMP1, B=TEMP2, C=TEMP3
    ; Now swap
    Correct4 := StrReplace(Correct3, "TEMP1", "3")    ; A=3, B=TEMP2, C=TEMP3
    Correct5 := StrReplace(Correct4, "TEMP2", "1")    ; A=3, B=1, C=TEMP3
    Correct6 := StrReplace(Correct5, "TEMP3", "2")    ; A=3, B=1, C=2

    ; Example 3: Expanding abbreviations in specific order
    Abbreviations := "Dr. Smith met Prof. Johnson at St. Mary's"

    ; Expand from most specific to least specific
    Expanded := Abbreviations
    Expanded := StrReplace(Expanded, "St. Mary's", "Saint Mary's")  ; Specific first
    Expanded := StrReplace(Expanded, "St.", "Street")                ; Then general
    Expanded := StrReplace(Expanded, "Dr.", "Doctor")
    Expanded := StrReplace(Expanded, "Prof.", "Professor")

    ; Example 4: Path separator replacement (needs careful ordering)
    MixedPath := "C:\Users\John\Documents\file.txt"

    ; Replace backslash with forward slash
    ; Need to escape the backslash in the replacement
    UnixPath := StrReplace(MixedPath, "\", "/")

    ; Now replace drive letter
    UnixPath := StrReplace(UnixPath, "C:/", "/mnt/c/")

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 5: Order-Dependent Replacements
    ═══════════════════════════════════════════════════

    WRONG ORDER (values overwrite each other):
    Original: " Text "
    After wrong replacements: " WrongOrder2 "
    ❌ Values got confused!

    CORRECT ORDER (using temp placeholders):
    Final result: " CorrectOrder4 "
    ✓ Correct result!

    ───────────────────────────────────────────────────
    SWAPPING VALUES:
    Original: " SwapText "
    Wrong approach: " Wrong2 "
    Correct approach: " Correct6 "

    ───────────────────────────────────────────────────
    ABBREVIATION EXPANSION (specific → general):
    Original: " Abbreviations "
    Expanded: " Expanded "

    ───────────────────────────────────────────────────
    PATH CONVERSION:
    Original: " MixedPath "
    Unix path: " UnixPath "
    )", "StrReplace Example 5", 0)

    ; KEY LEARNING: Order matters! Use temporary placeholders to
    ; prevent replacements from interfering with each other.
    ; Replace most specific terms before general ones.
}

; ============================================================================
; EXAMPLE 6: Configuration-Driven Text Transformation
; ============================================================================
; Shows how to build a flexible text transformation system driven by
; external configuration data.

Example6_ConfigurationDriven() {
    ; Create a flexible text transformer class
    class TextTransformer {
        __New() {
            this.rules := []
        }

        AddRule(find, replace, caseSensitive := true) {
            this.rules.Push(Map(
                "find", find,
                "replace", replace,
                "caseSensitive", caseSensitive
            ))
        }

        Transform(text) {
            result := text
            for rule in this.rules {
                result := StrReplace(result, rule["find"], rule["replace"], rule["caseSensitive"])
            }
            return result
        }

        ClearRules() {
            this.rules := []
        }
    }

    ; Example 1: Code style transformer
    CodeStyleTransformer := TextTransformer()
    CodeStyleTransformer.AddRule("var ", "let ")
    CodeStyleTransformer.AddRule("==", "===")
    CodeStyleTransformer.AddRule("!=", "!==")

    CodeBefore := "var x = 5; if (x == 5) { var y = 10; if (y != 5) { } }"
    CodeAfter := CodeStyleTransformer.Transform(CodeBefore)

    ; Example 2: Documentation formatter
    DocTransformer := TextTransformer()
    DocTransformer.AddRule("TODO:", "**TODO:**")
    DocTransformer.AddRule("NOTE:", "**NOTE:**")
    DocTransformer.AddRule("FIXME:", "**FIXME:**")
    DocTransformer.AddRule("IMPORTANT:", "⚠️ **IMPORTANT:**")

    DocBefore := "TODO: Fix this bug. NOTE: This is important. FIXME: Refactor later. IMPORTANT: Security issue!"
    DocAfter := DocTransformer.Transform(DocBefore)

    ; Example 3: Text sanitizer with configurable rules
    SanitizerTransformer := TextTransformer()
    SanitizerTransformer.AddRule("damn", "****", false)
    SanitizerTransformer.AddRule("hell", "****", false)
    SanitizerTransformer.AddRule("crap", "****", false)

    ProfaneText := "This damn thing is hell! What crap!"
    CleanText := SanitizerTransformer.Transform(ProfaneText)

    ; Example 4: Multi-language text processor
    LangTransformer := TextTransformer()
    ; Replace English with Spanish
    LangTransformer.AddRule("Hello", "Hola")
    LangTransformer.AddRule("World", "Mundo")
    LangTransformer.AddRule("Good", "Bueno")
    LangTransformer.AddRule("Morning", "Mañana")

    EnglishText := "Hello World! Good Morning!"
    SpanishText := LangTransformer.Transform(EnglishText)

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 6: Configuration-Driven Transformation
    ═══════════════════════════════════════════════════

    CODE STYLE TRANSFORMER:
    Before: " CodeBefore "
    After:  " CodeAfter "

    ───────────────────────────────────────────────────
    DOCUMENTATION FORMATTER:
    Before: " DocBefore "
    After:  " DocAfter "

    ───────────────────────────────────────────────────
    TEXT SANITIZER:
    Before: " ProfaneText "
    After:  " CleanText "

    ───────────────────────────────────────────────────
    LANGUAGE TRANSLATOR:
    English: " EnglishText "
    Spanish: " SpanishText "
    )", "StrReplace Example 6", 0)

    ; KEY LEARNING: Build reusable transformer classes that can be
    ; configured with different rule sets for different purposes.
}

; ============================================================================
; EXAMPLE 7: Advanced Multi-Step Text Processing Pipeline
; ============================================================================
; Demonstrates building a sophisticated text processing pipeline that
; combines multiple techniques for complex document transformation.

Example7_ProcessingPipeline() {
    ; Create a comprehensive document processor
    ProcessDocument(rawText) {
        ; Stage 1: Clean whitespace
        text := Trim(rawText)
        Loop {
            prev := text
            text := StrReplace(text, "  ", " ")
            if (text = prev)
                break
        }

        ; Stage 2: Normalize line endings
        text := StrReplace(text, "`r`n", "`n")
        text := StrReplace(text, "`r", "`n")

        ; Stage 3: Replace smart quotes with regular quotes
        text := StrReplace(text, """, '"')  ; Left double quote
        text := StrReplace(text, """, '"')  ; Right double quote
        text := StrReplace(text, "'", "'")  ; Left single quote
        text := StrReplace(text, "'", "'")  ; Right single quote

        ; Stage 4: Convert special characters
        text := StrReplace(text, "—", "--")  ; Em dash
        text := StrReplace(text, "–", "-")   ; En dash
        text := StrReplace(text, "…", "...") ; Ellipsis

        ; Stage 5: Standardize formatting
        text := StrReplace(text, " ,", ",")
        text := StrReplace(text, " .", ".")
        text := StrReplace(text, " !", "!")
        text := StrReplace(text, " ?", "?")

        return text
    }

    ; Test document with various issues
    RawDocument := "
    (
      The  quick   brown  fox—how  amazing—jumps over  the  lazy  dog.
      "Hello  World,"  she  said  .  'This  is  a  test…'
      Multiple   spaces    everywhere   !
    )"

    ProcessedDocument := ProcessDocument(RawDocument)

    ; Example 2: Markdown to HTML converter (simplified)
    MarkdownToHTML(markdown) {
        html := markdown

        ; Convert headers
        html := StrReplace(html, "### ", "<h3>")
        html := StrReplace(html, "## ", "<h2>")
        html := StrReplace(html, "# ", "<h1>")

        ; Convert emphasis
        html := StrReplace(html, "**", "<strong>", , , 1)
        html := StrReplace(html, "**", "</strong>", , , 1)
        html := StrReplace(html, "*", "<em>", , , 1)
        html := StrReplace(html, "*", "</em>", , , 1)

        ; Convert line breaks
        html := StrReplace(html, "`n`n", "</p><p>")
        html := "<p>" . html . "</p>"

        return html
    }

    MarkdownText := "# Welcome`n`nThis is **bold** and this is *italic* text."
    HTMLText := MarkdownToHTML(MarkdownText)

    ; Example 3: Log file anonymizer
    AnonymizeLog(logText) {
        anonymized := logText

        ; Replace IP addresses (simplified pattern)
        Loop 256 {
            anonymized := StrReplace(anonymized, "192.168.1." . (A_Index - 1), "XXX.XXX.X.XXX")
        }

        ; Replace email addresses (simplified)
        anonymized := StrReplace(anonymized, "@example.com", "@XXX.com")

        ; Replace user IDs
        Loop 100 {
            anonymized := StrReplace(anonymized, "user" . A_Index, "userXXX")
        }

        return anonymized
    }

    LogSample := "User user42 logged in from 192.168.1.100. Email: user42@example.com"
    AnonymizedLog := AnonymizeLog(LogSample)

    ; Example 4: Code snippet formatter
    FormatCodeSnippet(code) {
        formatted := code

        ; Add syntax highlighting markers (simplified)
        formatted := StrReplace(formatted, "function", "[KEYWORD]function[/KEYWORD]")
        formatted := StrReplace(formatted, "return", "[KEYWORD]return[/KEYWORD]")
        formatted := StrReplace(formatted, "const", "[KEYWORD]const[/KEYWORD]")
        formatted := StrReplace(formatted, "let", "[KEYWORD]let[/KEYWORD]")

        ; Format strings
        formatted := StrReplace(formatted, '"', '[STRING]"')

        return formatted
    }

    CodeSnippet := 'function test() { const x = "hello"; return x; }'
    FormattedCode := FormatCodeSnippet(CodeSnippet)

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 7: Advanced Processing Pipeline
    ═══════════════════════════════════════════════════

    DOCUMENT PROCESSOR:
    ───────────────────────────────────────────────────
    Raw:
    " RawDocument "

    Processed:
    " ProcessedDocument "

    ───────────────────────────────────────────────────
    MARKDOWN TO HTML:
    Markdown:
    " MarkdownText "

    HTML:
    " HTMLText "

    ───────────────────────────────────────────────────
    LOG ANONYMIZER:
    Original: " LogSample "
    Anonymized: " AnonymizedLog "

    ───────────────────────────────────────────────────
    CODE FORMATTER:
    Original: " CodeSnippet "
    Formatted: " FormattedCode "
    )", "StrReplace Example 7", 0)

    ; KEY LEARNING: Build comprehensive processing pipelines by
    ; combining multiple transformation stages. Each stage should
    ; have a single, clear responsibility.
}

; ============================================================================
; RUN ALL EXAMPLES
; ============================================================================

RunAllExamples() {
    Example1_ChainReplacements()
    Example2_TemplateSubstitution()
    Example3_BulkReplacements()
    Example4_DynamicPlaceholders()
    Example5_OrderDependentReplacements()
    Example6_ConfigurationDriven()
    Example7_ProcessingPipeline()

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    All Advanced Replacement Examples Completed!
    ═══════════════════════════════════════════════════

    You have reviewed all 7 advanced replacement examples for StrReplace().

    Key Takeaways:
    • Chain replacements for complex transformations
    • Use Maps for template systems
    • Order matters - use temp placeholders
    • Build reusable transformer classes
    • Create multi-stage processing pipelines
    • Combine StrReplace with other functions
    • Configuration-driven approaches are flexible
    )", "Examples Complete", 0)
}

; Create example menu
CreateExampleMenu() {
    MyMenu := Menu()
    MyMenu.Add("Example 1: Chain Replacements", (*) => Example1_ChainReplacements())
    MyMenu.Add("Example 2: Template Substitution", (*) => Example2_TemplateSubstitution())
    MyMenu.Add("Example 3: Bulk Replacements", (*) => Example3_BulkReplacements())
    MyMenu.Add("Example 4: Dynamic Placeholders", (*) => Example4_DynamicPlaceholders())
    MyMenu.Add("Example 5: Order-Dependent Replacements", (*) => Example5_OrderDependentReplacements())
    MyMenu.Add("Example 6: Configuration-Driven", (*) => Example6_ConfigurationDriven())
    MyMenu.Add("Example 7: Processing Pipeline", (*) => Example7_ProcessingPipeline())
    MyMenu.Add()
    MyMenu.Add("Run All Examples", (*) => RunAllExamples())
    return MyMenu
}

; Main execution
MainMenu := CreateExampleMenu()
TraySetIcon("shell32.dll", 166)  ; Set a gear/settings icon
A_TrayMenu.Add()
A_TrayMenu.Add("Advanced Replacement Examples", (*) => MainMenu.Show())

; Welcome message
MsgBox("
(
═══════════════════════════════════════════════════
StrReplace() - Advanced Replacement Techniques
AutoHotkey v2.0
═══════════════════════════════════════════════════

This script demonstrates 7 advanced examples of using
StrReplace() for complex text transformations.

Topics covered:
• Chain replacements
• Template systems
• Bulk operations
• Dynamic placeholders
• Order-dependent replacements
• Configuration-driven transformations
• Processing pipelines

Right-click the tray icon and select 'Advanced Replacement
Examples' to access the example menu.

Or run all examples now by clicking OK.
═══════════════════════════════════════════════════
)", "Advanced Replacement Examples Ready", 0)

RunAllExamples()

/*
═══════════════════════════════════════════════════
REFERENCE SECTION: ADVANCED StrReplace() TECHNIQUES
═══════════════════════════════════════════════════

PATTERN 1: CHAIN REPLACEMENTS
────────────────────────────────────────────────────
result := text
result := StrReplace(result, "old1", "new1")
result := StrReplace(result, "old2", "new2")
result := StrReplace(result, "old3", "new3")

Use when: Multiple sequential transformations needed
Benefit: Clear, maintainable code
Warning: Watch for order dependencies


PATTERN 2: MAP-BASED BULK REPLACEMENTS
────────────────────────────────────────────────────
replacements := Map(
    "find1", "replace1",
    "find2", "replace2"
)

result := text
for find, replace in replacements {
    result := StrReplace(result, find, replace)
}

Use when: Many similar replacements
Benefit: Easy to configure and maintain
Warning: Order of iteration matters


PATTERN 3: TEMPLATE SUBSTITUTION
────────────────────────────────────────────────────
template := "Hello {{NAME}}, welcome to {{PLACE}}"
data := Map("NAME", "John", "PLACE", "Earth")

result := template
for key, value in data {
    result := StrReplace(result, "{{" . key . "}}", value)
}

Use when: Generating text from templates
Benefit: Separation of template and data
Warning: Ensure all placeholders are replaced


PATTERN 4: TEMPORARY PLACEHOLDERS
────────────────────────────────────────────────────
; When order matters, use temp placeholders
text := StrReplace(text, "A", "TEMP_A")
text := StrReplace(text, "B", "TEMP_B")
text := StrReplace(text, "TEMP_A", "B")
text := StrReplace(text, "TEMP_B", "A")

Use when: Swapping values or order-dependent replacements
Benefit: Prevents replacement conflicts
Warning: Choose unique placeholder names


PATTERN 5: ITERATIVE NORMALIZATION
────────────────────────────────────────────────────
Loop {
    prev := text
    text := StrReplace(text, "  ", " ")
    if (text = prev)
        break
}

Use when: Normalizing variable amounts (spaces, etc.)
Benefit: Handles any number of repetitions
Warning: Ensure loop can terminate


PATTERN 6: TRANSFORMER CLASS
────────────────────────────────────────────────────
class Transformer {
    __New() {
        this.rules := []
    }

    AddRule(find, replace) {
        this.rules.Push(Map("find", find, "replace", replace))
    }

    Transform(text) {
        result := text
        for rule in this.rules {
            result := StrReplace(result, rule["find"], rule["replace"])
        }
        return result
    }
}

Use when: Reusable, configurable transformations
Benefit: Object-oriented, testable design
Warning: Consider performance for large rule sets


PATTERN 7: MULTI-STAGE PIPELINE
────────────────────────────────────────────────────
ProcessText(text) {
    ; Stage 1: Normalize
    text := Stage1_Normalize(text)
    ; Stage 2: Clean
    text := Stage2_Clean(text)
    ; Stage 3: Format
    text := Stage3_Format(text)
    return text
}

Use when: Complex transformations with distinct phases
Benefit: Modular, testable, maintainable
Warning: Each stage should have clear responsibility


BEST PRACTICES:

✓ Use descriptive variable names
✓ Document complex replacement logic
✓ Test with edge cases
✓ Consider performance for large texts
✓ Use Maps for configuration
✓ Handle empty strings appropriately
✓ Validate output after transformation
✓ Use functions for reusable logic
✓ Consider order dependencies
✓ Use temp placeholders when swapping


PERFORMANCE OPTIMIZATION:

1. Minimize passes over large texts
2. Combine related replacements
3. Use specific searches (avoid wildcards)
4. Cache compiled replacement rules
5. Consider RegExReplace() for complex patterns
6. Profile before optimizing
7. Use appropriate data structures


COMMON PITFALLS:

✗ Not considering replacement order
✗ Creating infinite loops in normalization
✗ Not handling edge cases (empty strings, etc.)
✗ Over-complicating simple replacements
✗ Not testing with realistic data
✗ Forgetting case sensitivity
✗ Not escaping special characters when needed
✗ Creating circular replacements


TESTING CHECKLIST:

□ Empty strings
□ Very long strings
□ Special characters
□ Unicode characters
□ Multiple consecutive matches
□ No matches found
□ Overlapping matches
□ Case variations
□ Edge whitespace
□ Null/undefined values


INTEGRATION WITH OTHER FUNCTIONS:

Combine StrReplace() with:
• RegExReplace() - Complex patterns
• Trim() - Clean edges
• StrLower()/StrUpper() - Case normalization
• SubStr() - Extract portions
• StrSplit() - Parse then transform
• InStr() - Conditional replacement
• Format() - String interpolation


REAL-WORLD APPLICATIONS:

1. Template Engines
   - Email templates
   - Code generation
   - Report generation

2. Data Sanitization
   - User input cleaning
   - Log anonymization
   - PII removal

3. Format Conversion
   - CSV ↔ TSV
   - Path normalization
   - Quote style conversion

4. Content Management
   - Rebranding
   - Link updates
   - Terminology standardization

5. Code Transformation
   - Syntax conversion
   - Style enforcement
   - Refactoring assistance

6. Localization
   - Text replacement
   - Number formatting
   - Date/time formatting


VERSION COMPATIBILITY:

• Requires AutoHotkey v2.0+
• Maps require v2.0+
• Class syntax shown is v2.0
• Fat arrow functions (=>) require v2.0

═══════════════════════════════════════════════════
END OF REFERENCE
═══════════════════════════════════════════════════
*/
