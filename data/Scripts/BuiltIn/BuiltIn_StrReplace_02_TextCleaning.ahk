#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * BUILT-IN FUNCTION: StrReplace() - Text Cleaning & Sanitization Examples
 * ============================================================================
 * 
 * DESCRIPTION:
 *   Comprehensive examples demonstrating text cleaning, sanitization, and
 *   format conversion using the StrReplace() function in AutoHotkey v2.
 *   This file focuses on practical data cleaning scenarios commonly
 *   encountered in text processing and data validation.
 * 
 * FEATURES DEMONSTRATED:
 *   - Removing unwanted characters from user input
 *   - Sanitizing filenames for filesystem compatibility
 *   - Cleaning HTML/XML content
 *   - Normalizing whitespace and line endings
 *   - Converting between different text formats
 *   - Removing special characters and symbols
 *   - Data validation and cleaning
 * 
 * SOURCE:
 *   AutoHotkey v2 Documentation - StrReplace()
 *   https://www.autohotkey.com/docs/v2/lib/StrReplace.html
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 *   - Function-based string manipulation
 *   - Chaining operations for complex cleaning
 *   - Modern parameter syntax
 *   - Integration with other v2 string functions
 *   - Practical data sanitization patterns
 * 
 * LEARNING POINTS:
 *   1. StrReplace() is ideal for removing unwanted characters (replace with "")
 *   2. Multiple sequential replacements can clean complex text
 *   3. Case-insensitive mode useful for normalizing input
 *   4. Combine with other string functions for robust cleaning
 *   5. Always validate output after sanitization
 *   6. Different scenarios require different cleaning strategies
 * 
 * ============================================================================
 */

; ============================================================================
; EXAMPLE 1: Removing Unwanted Characters
; ============================================================================
; Demonstrates how to remove specific unwanted characters from strings,
; which is useful for data cleaning and validation.

Example1_RemoveUnwantedCharacters() {
    ; Sample input with various unwanted characters
    DirtyInput := "Hello@#$World! This%^& is* a (test)."

    ; Remove specific special characters one by one
    Step1 := StrReplace(DirtyInput, "@", "")
    Step2 := StrReplace(Step1, "#", "")
    Step3 := StrReplace(Step2, "$", "")
    Step4 := StrReplace(Step3, "%", "")
    Step5 := StrReplace(Step4, "^", "")
    Step6 := StrReplace(Step5, "&", "")
    Step7 := StrReplace(Step6, "*", "")
    CleanedManually := Step7

    ; More efficient: Use a loop with an array
    DirtyInput2 := "Price: $49.99 (30% off!)"
    Cleaned := DirtyInput2
    UnwantedChars := ["$", "(", ")", "%", "!"]
    for char in UnwantedChars {
        Cleaned := StrReplace(Cleaned, char, "")
    }

    ; Remove all digits from text
    TextWithNumbers := "Call 555-1234 or visit us at 123 Main St."
    NoNumbers := TextWithNumbers
    Loop 10 {
        NoNumbers := StrReplace(NoNumbers, String(A_Index - 1), "")
    }

    ; Remove punctuation marks
    PunctuationText := "Hello, World! How are you? I'm fine."
    NoPunctuation := PunctuationText
    Punctuation := [",", ".", "!", "?", "'", '"', ";", ":"]
    for mark in Punctuation {
        NoPunctuation := StrReplace(NoPunctuation, mark, "")
    }

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 1: Removing Unwanted Characters
    ═══════════════════════════════════════════════════

    REMOVE SPECIAL CHARACTERS:
    Original: " DirtyInput "
    Cleaned:  " CleanedManually "

    ───────────────────────────────────────────────────
    REMOVE PRICE SYMBOLS:
    Original: " DirtyInput2 "
    Cleaned:  " Cleaned "

    ───────────────────────────────────────────────────
    REMOVE ALL DIGITS:
    Original: " TextWithNumbers "
    No Numbers: " NoNumbers "

    ───────────────────────────────────────────────────
    REMOVE PUNCTUATION:
    Original: " PunctuationText "
    No Punctuation: " NoPunctuation "
    )", "StrReplace Example 1", 0)

    ; KEY LEARNING: Replace unwanted characters with empty string ""
    ; to effectively remove them. Use loops for efficiency when
    ; removing multiple characters.
}

; ============================================================================
; EXAMPLE 2: Sanitizing Filenames
; ============================================================================
; Shows how to clean user-provided strings to create valid, safe filenames
; that work across different operating systems.

Example2_SanitizeFilenames() {
    ; User inputs that need to be converted to valid filenames
    UserTitle1 := "My Document: Version 2.0 (Final).txt"
    UserTitle2 := "Report for Q4/2023 - Sales & Marketing.xlsx"
    UserTitle3 := "Meeting Notes | Jan 15th, 2024.docx"

    ; Windows forbidden characters: \ / : * ? " < > |
    ; Also replace spaces with underscores for better compatibility

    ; Sanitize function
    SanitizeFilename(filename) {
        ; Remove or replace forbidden characters
        clean := StrReplace(filename, "\", "_")
        clean := StrReplace(clean, "/", "_")
        clean := StrReplace(clean, ":", "-")
        clean := StrReplace(clean, "*", "")
        clean := StrReplace(clean, "?", "")
        clean := StrReplace(clean, '"', "'")
        clean := StrReplace(clean, "<", "(")
        clean := StrReplace(clean, ">", ")")
        clean := StrReplace(clean, "|", "-")

        ; Replace spaces with underscores
        clean := StrReplace(clean, " ", "_")

        ; Remove multiple consecutive underscores
        Loop {
            prev := clean
            clean := StrReplace(clean, "__", "_")
            if (clean = prev)
                break
        }

        ; Trim leading/trailing underscores and hyphens
        clean := Trim(clean, "_-")

        return clean
    }

    ; Apply sanitization
    Safe1 := SanitizeFilename(UserTitle1)
    Safe2 := SanitizeFilename(UserTitle2)
    Safe3 := SanitizeFilename(UserTitle3)

    ; Alternative: Keep spaces but remove only forbidden chars
    CleanButReadable(filename) {
        clean := filename
        ForbiddenChars := ["\", "/", ":", "*", "?", '"', "<", ">", "|"]
        for char in ForbiddenChars {
            clean := StrReplace(clean, char, "")
        }
        ; Clean up multiple spaces
        Loop {
            prev := clean
            clean := StrReplace(clean, "  ", " ")
            if (clean = prev)
                break
        }
        return Trim(clean)
    }

    Readable1 := CleanButReadable(UserTitle1)
    Readable2 := CleanButReadable(UserTitle2)
    Readable3 := CleanButReadable(UserTitle3)

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 2: Sanitizing Filenames
    ═══════════════════════════════════════════════════

    METHOD 1: Replace spaces with underscores
    ───────────────────────────────────────────────────
    Original: " UserTitle1 "
    Sanitized: " Safe1 "

    Original: " UserTitle2 "
    Sanitized: " Safe2 "

    Original: " UserTitle3 "
    Sanitized: " Safe3 "

    METHOD 2: Keep spaces, remove only forbidden chars
    ───────────────────────────────────────────────────
    Original: " UserTitle1 "
    Readable: " Readable1 "

    Original: " UserTitle2 "
    Readable: " Readable2 "

    Original: " UserTitle3 "
    Readable: " Readable3 "

    Forbidden Windows chars removed: \ / : * ? " < > |
    )", "StrReplace Example 2", 0)

    ; KEY LEARNING: Sanitize user input for filenames by removing
    ; or replacing OS-forbidden characters. Consider readability vs
    ; compatibility when choosing replacement strategy.
}

; ============================================================================
; EXAMPLE 3: HTML/XML Content Cleaning
; ============================================================================
; Demonstrates cleaning HTML and XML content by removing tags and
; converting entities to readable text.

Example3_CleanHTMLContent() {
    ; Sample HTML content
    HTMLContent := "<div class='article'><h1>Welcome!</h1><p>This is a <strong>test</strong> paragraph.</p></div>"

    ; Remove all HTML tags (simple approach)
    NoTags := HTMLContent
    ; This is a simple removal - for robust HTML parsing, use proper HTML parser
    Loop {
        StartPos := InStr(NoTags, "<")
        if (!StartPos)
            break
        EndPos := InStr(NoTags, ">", , StartPos)
        if (!EndPos)
            break
        ; Remove the tag
        TagToRemove := SubStr(NoTags, StartPos, EndPos - StartPos + 1)
        NoTags := StrReplace(NoTags, TagToRemove, "")
    }

    ; Convert common HTML entities
    HTMLWithEntities := "AT&amp;T's new product costs &lt;$50&gt; &quot;Amazing!&quot;"
    CleanEntities := HTMLWithEntities
    ; Common HTML entities
    CleanEntities := StrReplace(CleanEntities, "&amp;", "&")
    CleanEntities := StrReplace(CleanEntities, "&lt;", "<")
    CleanEntities := StrReplace(CleanEntities, "&gt;", ">")
    CleanEntities := StrReplace(CleanEntities, "&quot;", '"')
    CleanEntities := StrReplace(CleanEntities, "&#39;", "'")
    CleanEntities := StrReplace(CleanEntities, "&nbsp;", " ")

    ; Remove inline styles and scripts
    DirtyHTML := '<p style="color: red;">Text</p><script>alert("bad");</script>More text'
    ; Remove style attributes (simplified)
    CleanHTML := DirtyHTML
    CleanHTML := StrReplace(CleanHTML, '<script>', '<REMOVESCRIPT>')
    CleanHTML := StrReplace(CleanHTML, '</script>', '</REMOVESCRIPT>')
    ; Then remove the marked sections
    Loop {
        StartPos := InStr(CleanHTML, "<REMOVESCRIPT>")
        if (!StartPos)
            break
        EndPos := InStr(CleanHTML, "</REMOVESCRIPT>", , StartPos)
        if (!EndPos)
            break
        ScriptSection := SubStr(CleanHTML, StartPos, EndPos - StartPos + 16)
        CleanHTML := StrReplace(CleanHTML, ScriptSection, "")
    }

    ; XML cleaning example
    XMLContent := '<?xml version="1.0"?><root><item id="1">Data</item></root>'
    NoXMLDeclaration := StrReplace(XMLContent, '<?xml version="1.0"?>', "")

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 3: HTML/XML Content Cleaning
    ═══════════════════════════════════════════════════

    REMOVE HTML TAGS:
    Original HTML:
    " HTMLContent "

    After tag removal:
    " NoTags "

    ───────────────────────────────────────────────────
    CONVERT HTML ENTITIES:
    Original:
    " HTMLWithEntities "

    Converted:
    " CleanEntities "

    ───────────────────────────────────────────────────
    REMOVE XML DECLARATION:
    Original:
    " XMLContent "

    Cleaned:
    " NoXMLDeclaration "

    Note: For robust HTML/XML parsing, use dedicated
    parsers. These examples show basic cleaning.
    )", "StrReplace Example 3", 0)

    ; KEY LEARNING: StrReplace can handle basic HTML/XML cleaning.
    ; For complex HTML parsing, consider specialized tools.
}

; ============================================================================
; EXAMPLE 4: Whitespace Normalization
; ============================================================================
; Shows various techniques for normalizing and cleaning whitespace in text,
; including spaces, tabs, and line endings.

Example4_NormalizeWhitespace() {
    ; Text with excessive spaces
    ExcessiveSpaces := "This    has     too      many       spaces"

    ; Normalize to single spaces
    NormalSpaces := ExcessiveSpaces
    Loop {
        prev := NormalSpaces
        NormalSpaces := StrReplace(NormalSpaces, "  ", " ")
        if (NormalSpaces = prev)
            break
    }

    ; Mixed tabs and spaces
    MixedWhitespace := "Name:`t`tJohn`t`tDoe`n" .
        "Age:`t`t`t30`n" .
        "City:`t`tNew York"

    ; Convert tabs to spaces
    TabsToSpaces := StrReplace(MixedWhitespace, "`t", "    ")  ; 4 spaces per tab

    ; Remove all tabs
    NoTabs := StrReplace(MixedWhitespace, "`t", "")

    ; Normalize line endings (Windows CRLF to Unix LF)
    WindowsText := "Line 1`r`nLine 2`r`nLine 3`r`n"
    UnixText := StrReplace(WindowsText, "`r`n", "`n")

    ; Remove all line breaks
    MultiLine := "First line`nSecond line`nThird line"
    SingleLine := StrReplace(MultiLine, "`n", " ")

    ; Clean text with mixed issues
    MessyText := "  Hello   World`t`tHow  are`tyou?  `n`n  "
    ; Trim ends
    CleanText := Trim(MessyText)
    ; Replace tabs with spaces
    CleanText := StrReplace(CleanText, "`t", " ")
    ; Normalize spaces
    Loop {
        prev := CleanText
        CleanText := StrReplace(CleanText, "  ", " ")
        if (CleanText = prev)
            break
    }
    ; Normalize line breaks
    CleanText := StrReplace(CleanText, "`n`n", "`n")

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 4: Whitespace Normalization
    ═══════════════════════════════════════════════════

    NORMALIZE EXCESSIVE SPACES:
    Original: '" ExcessiveSpaces "'
    Normalized: '" NormalSpaces "'

    ───────────────────────────────────────────────────
    TABS TO SPACES (4 per tab):
    Lines shown with [TAB] marker:

    Original has mixed tabs and spaces
    Converted all tabs to 4 spaces

    ───────────────────────────────────────────────────
    LINE ENDING NORMALIZATION:
    Windows (CRLF) → Unix (LF)
    All `r`n converted to `n

    ───────────────────────────────────────────────────
    REMOVE LINE BREAKS:
    Original: " MultiLine "
    Single Line: " SingleLine "

    ───────────────────────────────────────────────────
    COMPLETE CLEANUP:
    Messy: '" MessyText "'
    Clean: '" CleanText "'
    )", "StrReplace Example 4", 0)

    ; KEY LEARNING: Use loop-based replacement for normalizing
    ; variable amounts of whitespace. Combine with Trim() for
    ; complete whitespace cleanup.
}

; ============================================================================
; EXAMPLE 5: Format Conversion
; ============================================================================
; Demonstrates converting text between different formats using StrReplace.

Example5_FormatConversion() {
    ; Convert spaces to underscores (common for URLs, filenames)
    Title := "My Awesome Blog Post Title"
    URLSlug := StrReplace(Title, " ", "-")
    URLSlug := StrLower(URLSlug)  ; Convert to lowercase too

    ; Convert underscores to spaces (reverse operation)
    VariableName := "my_variable_name"
    ReadableText := StrReplace(VariableName, "_", " ")

    ; Convert camelCase to snake_case (simplified)
    CamelCase := "myVariableName"
    ; This is simplified - real conversion needs regex
    SnakeCase := CamelCase
    SnakeCase := StrReplace(SnakeCase, "V", "_v")
    SnakeCase := StrReplace(SnakeCase, "N", "_n")

    ; Convert CSV to TSV (comma to tab)
    CSVLine := "Name,Age,City,Country"
    TSVLine := StrReplace(CSVLine, ",", "`t")

    ; Convert Windows path to Unix path
    WindowsPath := "C:\Users\John\Documents\file.txt"
    UnixStylePath := StrReplace(WindowsPath, "\", "/")
    UnixStylePath := StrReplace(UnixStylePath, "C:/", "/mnt/c/")

    ; Convert between quote styles
    SingleQuotes := "It's a 'beautiful' day"
    DoubleQuotes := StrReplace(SingleQuotes, "'", '"')

    ; Phone number formatting
    PlainPhone := "5551234567"
    ; Format as (555) 123-4567
    if (StrLen(PlainPhone) = 10) {
        FormattedPhone := "(" . SubStr(PlainPhone, 1, 3) . ") " .
            SubStr(PlainPhone, 4, 3) . "-" .
            SubStr(PlainPhone, 7, 4)
    }

    ; Remove phone formatting (reverse)
    FormattedPhone2 := "(555) 123-4567"
    PlainPhone2 := FormattedPhone2
    PlainPhone2 := StrReplace(PlainPhone2, "(", "")
    PlainPhone2 := StrReplace(PlainPhone2, ")", "")
    PlainPhone2 := StrReplace(PlainPhone2, " ", "")
    PlainPhone2 := StrReplace(PlainPhone2, "-", "")

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 5: Format Conversion
    ═══════════════════════════════════════════════════

    SPACES TO URL SLUG:
    Original: " Title "
    URL Slug: " URLSlug "

    ───────────────────────────────────────────────────
    UNDERSCORES TO SPACES:
    Variable: " VariableName "
    Readable: " ReadableText "

    ───────────────────────────────────────────────────
    CSV TO TSV:
    CSV: " CSVLine "
    TSV: " TSVLine "

    ───────────────────────────────────────────────────
    WINDOWS PATH TO UNIX:
    Windows: " WindowsPath "
    Unix: " UnixStylePath "

    ───────────────────────────────────────────────────
    QUOTE CONVERSION:
    Single: " SingleQuotes "
    Double: " DoubleQuotes "

    ───────────────────────────────────────────────────
    PHONE NUMBER:
    Plain: " PlainPhone "
    Formatted: " FormattedPhone "
    Reverse: " PlainPhone2 "
    )", "StrReplace Example 5", 0)

    ; KEY LEARNING: StrReplace is perfect for simple format conversions.
    ; Chain operations for complex transformations.
}

; ============================================================================
; EXAMPLE 6: Data Validation and Sanitization
; ============================================================================
; Shows how to sanitize and validate various types of user input.

Example6_DataValidation() {
    ; Email sanitization
    EmailInput := "  User@EXAMPLE.COM  "
    CleanEmail := Trim(EmailInput)
    CleanEmail := StrLower(CleanEmail)  ; Emails are case-insensitive

    ; Username sanitization
    UsernameInput := "User Name 123!@#"
    CleanUsername := UsernameInput
    ; Remove spaces
    CleanUsername := StrReplace(CleanUsername, " ", "")
    ; Remove special characters
    SpecialChars := ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "+", "="]
    for char in SpecialChars {
        CleanUsername := StrReplace(CleanUsername, char, "")
    }

    ; Credit card number sanitization (remove formatting)
    CCInput := "1234-5678-9012-3456"
    CleanCC := CCInput
    CleanCC := StrReplace(CleanCC, "-", "")
    CleanCC := StrReplace(CleanCC, " ", "")
    ; Mask for display (keep last 4 digits)
    if (StrLen(CleanCC) >= 4) {
        MaskedCC := "****-****-****-" . SubStr(CleanCC, -3)
    }

    ; SQL injection prevention (basic escaping)
    UserInput := "Robert'); DROP TABLE users;--"
    SafeInput := UserInput
    ; Escape dangerous characters
    SafeInput := StrReplace(SafeInput, "'", "''")  ; Escape single quotes
    SafeInput := StrReplace(SafeInput, ";", "")     ; Remove semicolons
    SafeInput := StrReplace(SafeInput, "--", "")    ; Remove SQL comments

    ; URL parameter cleaning
    URLParam := "search term with spaces & symbols!"
    CleanParam := URLParam
    CleanParam := StrReplace(CleanParam, " ", "+")
    CleanParam := StrReplace(CleanParam, "&", "%26")
    CleanParam := StrReplace(CleanParam, "!", "%21")

    ; Alphanumeric only (remove all non-alphanumeric)
    MixedInput := "Product123-ABC_xyz!@#"
    AlphaNumeric := MixedInput
    RemoveChars := ["-", "_", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "+", "="]
    for char in RemoveChars {
        AlphaNumeric := StrReplace(AlphaNumeric, char, "")
    }

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 6: Data Validation and Sanitization
    ═══════════════════════════════════════════════════

    EMAIL SANITIZATION:
    Input: '" EmailInput "'
    Clean: '" CleanEmail "'

    ───────────────────────────────────────────────────
    USERNAME SANITIZATION:
    Input: '" UsernameInput "'
    Clean: '" CleanUsername "'

    ───────────────────────────────────────────────────
    CREDIT CARD:
    Input: " CCInput "
    Clean: " CleanCC "
    Masked: " MaskedCC "

    ───────────────────────────────────────────────────
    SQL INJECTION PREVENTION:
    Dangerous: " UserInput "
    Sanitized: " SafeInput "

    ───────────────────────────────────────────────────
    URL PARAMETER:
    Input: " URLParam "
    Encoded: " CleanParam "

    ───────────────────────────────────────────────────
    ALPHANUMERIC ONLY:
    Input: " MixedInput "
    Clean: " AlphaNumeric "
    )", "StrReplace Example 6", 0)

    ; KEY LEARNING: Always sanitize user input. Use StrReplace to
    ; remove or escape dangerous characters. Combine with validation.
}

; ============================================================================
; EXAMPLE 7: Advanced Text Cleaning Pipeline
; ============================================================================
; Demonstrates building a comprehensive text cleaning pipeline that
; combines multiple cleaning operations.

Example7_CleaningPipeline() {
    ; Create a comprehensive text cleaner function
    CleanText(text, options := Map()) {
        ; Set default options
        if (!options.Has("trimWhitespace"))
            options["trimWhitespace"] := true
        if (!options.Has("normalizeSpaces"))
            options["normalizeSpaces"] := true
        if (!options.Has("normalizeLineEndings"))
            options["normalizeLineEndings"] := true
        if (!options.Has("removeTabs"))
            options["removeTabs"] := true
        if (!options.Has("removeSpecialChars"))
            options["removeSpecialChars"] := false
        if (!options.Has("toLowerCase"))
            options["toLowerCase"] := false

        result := text

        ; 1. Trim leading/trailing whitespace
        if (options["trimWhitespace"])
            result := Trim(result)

        ; 2. Remove tabs
        if (options["removeTabs"])
            result := StrReplace(result, "`t", " ")

        ; 3. Normalize line endings to LF
        if (options["normalizeLineEndings"]) {
            result := StrReplace(result, "`r`n", "`n")
            result := StrReplace(result, "`r", "`n")
        }

        ; 4. Normalize spaces
        if (options["normalizeSpaces"]) {
            Loop {
                prev := result
                result := StrReplace(result, "  ", " ")
                if (result = prev)
                    break
            }
        }

        ; 5. Remove special characters
        if (options["removeSpecialChars"]) {
            specialChars := ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "+", "=", "[", "]", "{", "}", "|", "\", "/", ":", ";", "'", '"', "<", ">", ",", ".", "?"]
            for char in specialChars {
                result := StrReplace(result, char, "")
            }
        }

        ; 6. Convert to lowercase
        if (options["toLowerCase"])
            result := StrLower(result)

        return result
    }

    ; Test data with multiple issues
    MessyData := "
    (
    URGENT!!!   This    is   a    TEST`t`tMessage.
    It  has   multiple    issues:`r`n
    - Extra   spaces`t`t`t`r`n
    - Mixed   line endings`r`n
    - INCONSISTENT   capitalization
    - Special@#$ characters!!!
    )"

    ; Apply different cleaning levels
    ; Level 1: Basic cleaning
    Options1 := Map()
    Options1["trimWhitespace"] := true
    Options1["normalizeSpaces"] := true
    Options1["normalizeLineEndings"] := true
    Options1["removeTabs"] := true
    Level1 := CleanText(MessyData, Options1)

    ; Level 2: Aggressive cleaning
    Options2 := Map()
    Options2["trimWhitespace"] := true
    Options2["normalizeSpaces"] := true
    Options2["normalizeLineEndings"] := true
    Options2["removeTabs"] := true
    Options2["removeSpecialChars"] := true
    Level2 := CleanText(MessyData, Options2)

    ; Level 3: Maximum cleaning
    Options3 := Map()
    Options3["trimWhitespace"] := true
    Options3["normalizeSpaces"] := true
    Options3["normalizeLineEndings"] := true
    Options3["removeTabs"] := true
    Options3["removeSpecialChars"] := true
    Options3["toLowerCase"] := true
    Level3 := CleanText(MessyData, Options3)

    ; Real-world example: Clean extracted web content
    WebContent := "   Welcome to    Our   Site!!!`r`n`r`n" .
        "Special   offer:   50% OFF!!!`t`t`t`r`n" .
        "Click  <HERE>  @@@   NOW!!!   "

    CleanWebOptions := Map()
    CleanWebOptions["trimWhitespace"] := true
    CleanWebOptions["normalizeSpaces"] := true
    CleanWebOptions["removeTabs"] := true
    CleanedWeb := CleanText(WebContent, CleanWebOptions)

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 7: Advanced Text Cleaning Pipeline
    ═══════════════════════════════════════════════════

    ORIGINAL MESSY DATA:
    '" MessyData "'

    ───────────────────────────────────────────────────
    LEVEL 1 (Basic cleaning):
    " Level1 "

    ───────────────────────────────────────────────────
    LEVEL 2 (Aggressive cleaning):
    " Level2 "

    ───────────────────────────────────────────────────
    LEVEL 3 (Maximum cleaning):
    " Level3 "

    ───────────────────────────────────────────────────
    WEB CONTENT CLEANING:
    Original: '" WebContent "'

    Cleaned: '" CleanedWeb "'
    )", "StrReplace Example 7", 0)

    ; KEY LEARNING: Build reusable cleaning functions that combine
    ; multiple StrReplace operations. Use options to control cleaning level.
}

; ============================================================================
; RUN ALL EXAMPLES
; ============================================================================

RunAllExamples() {
    Example1_RemoveUnwantedCharacters()
    Example2_SanitizeFilenames()
    Example3_CleanHTMLContent()
    Example4_NormalizeWhitespace()
    Example5_FormatConversion()
    Example6_DataValidation()
    Example7_CleaningPipeline()

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    All Text Cleaning Examples Completed!
    ═══════════════════════════════════════════════════

    You have reviewed all 7 text cleaning examples for StrReplace().

    Key Takeaways:
    • Replace with '' to remove unwanted characters
    • Sanitize filenames by removing OS-forbidden chars
    • Use loops for normalizing variable whitespace
    • Chain operations for complex cleaning
    • Build reusable cleaning functions
    • Always validate after sanitization
    )", "Examples Complete", 0)
}

; Create example menu
CreateExampleMenu() {
    MyMenu := Menu()
    MyMenu.Add("Example 1: Remove Unwanted Characters", (*) => Example1_RemoveUnwantedCharacters())
    MyMenu.Add("Example 2: Sanitize Filenames", (*) => Example2_SanitizeFilenames())
    MyMenu.Add("Example 3: Clean HTML Content", (*) => Example3_CleanHTMLContent())
    MyMenu.Add("Example 4: Normalize Whitespace", (*) => Example4_NormalizeWhitespace())
    MyMenu.Add("Example 5: Format Conversion", (*) => Example5_FormatConversion())
    MyMenu.Add("Example 6: Data Validation", (*) => Example6_DataValidation())
    MyMenu.Add("Example 7: Cleaning Pipeline", (*) => Example7_CleaningPipeline())
    MyMenu.Add()
    MyMenu.Add("Run All Examples", (*) => RunAllExamples())
    return MyMenu
}

; Main execution
MainMenu := CreateExampleMenu()
TraySetIcon("shell32.dll", 70)  ; Set a cleaning/broom icon
A_TrayMenu.Add()
A_TrayMenu.Add("Text Cleaning Examples", (*) => MainMenu.Show())

; Welcome message
MsgBox("
(
═══════════════════════════════════════════════════
StrReplace() - Text Cleaning & Sanitization Examples
AutoHotkey v2.0
═══════════════════════════════════════════════════

This script demonstrates 7 comprehensive examples of using
StrReplace() for text cleaning and sanitization.

Right-click the tray icon and select 'Text Cleaning Examples'
to access the example menu.

Or run all examples now by clicking OK.
═══════════════════════════════════════════════════
)", "Text Cleaning Examples Ready", 0)

RunAllExamples()

/*
═══════════════════════════════════════════════════
REFERENCE SECTION: TEXT CLEANING WITH StrReplace()
═══════════════════════════════════════════════════

COMMON CLEANING PATTERNS:

1. REMOVE CHARACTER:
Clean := StrReplace(Text, "x", "")

2. REMOVE MULTIPLE CHARACTERS:
Clean := Text
for char in ["a", "b", "c"]
Clean := StrReplace(Clean, char, "")

3. NORMALIZE SPACES:
Loop {
    prev := Text
    Text := StrReplace(Text, "  ", " ")
    if (Text = prev)
    break
}

4. CLEAN WHITESPACE:
Clean := Trim(Text)
Clean := StrReplace(Clean, "`t", " ")
; Then normalize spaces

5. SANITIZE FILENAME:
Safe := Text
for char in ["\", "/", ":", "*", "?", '"', "<", ">", "|"]
Safe := StrReplace(Safe, char, "_")

6. CONVERT FORMAT:
URLSlug := StrReplace(Title, " ", "-")
URLSlug := StrLower(URLSlug)

7. NORMALIZE LINE ENDINGS:
Unix := StrReplace(Text, "`r`n", "`n")
Unix := StrReplace(Unix, "`r", "`n")

BEST PRACTICES:

✓ Always validate output after sanitization
✓ Use loops for repetitive replacements
✓ Chain operations in logical order
✓ Create reusable cleaning functions
✓ Document what each cleaning step does
✓ Test with edge cases
✓ Consider performance for large texts
✓ Preserve data integrity when possible

COMMON USE CASES:

• User Input Sanitization
- Remove potentially dangerous characters
- Normalize formatting
- Validate against requirements

• Filename Creation
- Remove OS-forbidden characters
- Replace spaces with underscores/hyphens
- Ensure filesystem compatibility

• Data Import/Export
- Normalize line endings
- Convert between formats (CSV/TSV)
- Clean extracted web content

• Text Normalization
- Standardize whitespace
- Convert case consistently
- Remove formatting artifacts

• Security
- Escape SQL injection attempts
- Sanitize HTML/XML input
- Clean URL parameters

PERFORMANCE TIPS:

1. For many replacements, use a loop:
for char in CharsToRemove
Text := StrReplace(Text, char, "")

2. For whitespace normalization, use a loop:
Loop {
    prev := Text
    Text := StrReplace(Text, "  ", " ")
    if (Text = prev)
    break
}

3. Combine operations when possible:
Clean := Trim(StrReplace(Text, "`t", " "))

4. For complex patterns, consider RegExReplace()

SECURITY CONSIDERATIONS:

⚠ StrReplace is NOT sufficient for:
- Complete SQL injection prevention
- XSS attack prevention
- Comprehensive input validation

✓ StrReplace IS good for:
- Basic character removal
- Format standardization
- Simple sanitization
- Data cleanup

Always use proper security libraries and practices
for production applications.

RELATED FUNCTIONS:

• RegExReplace() - Pattern-based replacement
• Trim() - Remove leading/trailing whitespace
• StrLower()/StrUpper() - Case conversion
• SubStr() - Extract portions
• InStr() - Find positions
• StrSplit() - Split into array

COMMON MISTAKES TO AVOID:

✗ Not validating output
✗ Removing too many characters
✗ Breaking data integrity
✗ Infinite loops in normalization
✗ Not handling edge cases
✗ Over-sanitizing readable text
✗ Ignoring performance impact

═══════════════════════════════════════════════════
END OF REFERENCE
═══════════════════════════════════════════════════
*/

