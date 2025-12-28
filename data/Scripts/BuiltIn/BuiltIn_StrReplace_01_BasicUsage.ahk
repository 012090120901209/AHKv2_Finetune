#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * BUILT-IN FUNCTION: StrReplace() - Basic Usage Examples
 * ============================================================================
 * 
 * DESCRIPTION:
 *   Comprehensive examples demonstrating the fundamental usage of the
 *   StrReplace() function in AutoHotkey v2. This file covers basic string
 *   replacement operations, case sensitivity options, and counting
 *   replacements made.
 * 
 * FEATURES DEMONSTRATED:
 *   - Simple string replacement (single occurrence)
 *   - Replace all occurrences of a substring
 *   - Case-sensitive vs case-insensitive replacement
 *   - Counting the number of replacements made
 *   - Using the OutputVar parameter for replacement count
 *   - Empty string handling
 *   - Replacement with identical strings
 * 
 * SOURCE:
 *   AutoHotkey v2 Documentation - StrReplace()
 *   https://www.autohotkey.com/docs/v2/lib/StrReplace.html
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 *   - Pure function-based string manipulation (no legacy commands)
 *   - Optional OutputVar parameter for operation metadata
 *   - Consistent return value behavior
 *   - Named parameters for clarity
 *   - Modern case sensitivity control
 * 
 * LEARNING POINTS:
 *   1. StrReplace() replaces all occurrences by default (unlike v1 StringReplace)
 *   2. Case sensitivity is controlled via the CaseSense parameter (default: case-sensitive)
 *   3. The function returns the modified string (original remains unchanged)
 *   4. OutputVar parameter provides count of replacements made
 *   5. Empty search string returns original string unchanged
 *   6. Replacing with empty string effectively removes the search string
 * 
 * SYNTAX:
 *   NewStr := StrReplace(Haystack, Needle, ReplaceText := "", CaseSense := true, &OutputVarCount := 0, Limit := -1)
 * 
 * PARAMETERS:
 *   Haystack      - The string whose content is searched and replaced
 *   Needle        - The string to search for
 *   ReplaceText   - The string to replace Needle with (default: empty string)
 *   CaseSense     - true (default) or false for case sensitivity
 *   OutputVarCount- Variable to receive count of replacements made
 *   Limit         - Maximum number of replacements (-1 = all)
 * 
 * ============================================================================
 */

; ============================================================================
; EXAMPLE 1: Basic Single Word Replacement
; ============================================================================
; Demonstrates the most basic usage of StrReplace() - replacing all
; occurrences of one word with another in a simple string.

Example1_BasicReplacement() {
    ; Original string containing repeated words
    OriginalText := "The quick brown fox jumps over the lazy fox."

    ; Replace all occurrences of "fox" with "cat"
    ; By default, StrReplace is case-sensitive and replaces ALL occurrences
    NewText := StrReplace(OriginalText, "fox", "cat")

    ; Display the results
    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 1: Basic Single Word Replacement
    ═══════════════════════════════════════════════════

    Original Text:
    " OriginalText "

    After replacing 'fox' with 'cat':
    " NewText "

    Note: Both occurrences of 'fox' were replaced!
    )", "StrReplace Example 1", 0)

    ; KEY LEARNING: StrReplace replaces ALL occurrences by default
    ; This is different from some other string functions that only
    ; replace the first occurrence
}

; ============================================================================
; EXAMPLE 2: Case Sensitivity Demonstration
; ============================================================================
; Shows the difference between case-sensitive (default) and case-insensitive
; replacement operations.

Example2_CaseSensitivity() {
    ; Test string with mixed case
    TestString := "Hello World! hello world! HELLO WORLD!"

    ; Case-sensitive replacement (default behavior)
    ; Only replaces exact matches of "hello"
    CaseSensitiveResult := StrReplace(TestString, "hello", "hi")

    ; Case-insensitive replacement
    ; The fourth parameter (false) makes the search case-insensitive
    CaseInsensitiveResult := StrReplace(TestString, "hello", "hi", false)

    ; Display comparison
    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 2: Case Sensitivity Comparison
    ═══════════════════════════════════════════════════

    Original String:
    " TestString "

    Case-Sensitive Replacement (default):
    " CaseSensitiveResult "
    → Only lowercase 'hello' was replaced

    Case-Insensitive Replacement:
    " CaseInsensitiveResult "
    → All variations (hello, Hello, HELLO) replaced

    Syntax Difference:
    • Case-sensitive:   StrReplace(str, 'hello', 'hi')
    • Case-insensitive: StrReplace(str, 'hello', 'hi', false)
    )", "StrReplace Example 2", 0)

    ; KEY LEARNING: The CaseSense parameter (4th parameter) controls
    ; case sensitivity. true = case-sensitive (default), false = case-insensitive
}

; ============================================================================
; EXAMPLE 3: Counting Replacements Made
; ============================================================================
; Demonstrates how to track the number of replacements performed using
; the OutputVarCount parameter.

Example3_CountingReplacements() {
    ; Sample text with multiple occurrences
    EmailText := "Contact us at support@example.com or sales@example.com. " .
        "For urgent matters, email admin@example.com directly."

    ; Initialize counter variable
    ReplaceCount := 0

    ; Replace email domain and count replacements
    ; The &ReplaceCount passes the variable by reference to receive the count
    UpdatedEmail := StrReplace(EmailText, "example.com", "newdomain.com", true, &ReplaceCount)

    ; Another example: Count case-insensitive replacements
    TechText := "Python is great. I love Python programming. PYTHON rocks!"
    PythonCount := 0
    UpdatedTech := StrReplace(TechText, "python", "JavaScript", false, &PythonCount)

    ; Display results with counts
    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 3: Counting Replacements Made
    ═══════════════════════════════════════════════════

    EMAIL REPLACEMENT:
    Original:
    " EmailText "

    After replacing 'example.com' → 'newdomain.com':
    " UpdatedEmail "

    Replacements Made: " ReplaceCount "

    ───────────────────────────────────────────────────

    TECH TEXT REPLACEMENT (Case-Insensitive):
    Original:
    " TechText "

    After replacing 'Python' → 'JavaScript':
    " UpdatedTech "

    Replacements Made: " PythonCount "
    )", "StrReplace Example 3", 0)

    ; KEY LEARNING: Use &VariableName as the 5th parameter to receive
    ; the count of replacements made. The & passes by reference.
}

; ============================================================================
; EXAMPLE 4: Using Limit Parameter
; ============================================================================
; Shows how to limit the number of replacements using the Limit parameter.

Example4_LimitedReplacements() {
    ; Sample text with many occurrences
    RepeatText := "apple apple apple apple apple"

    ; Replace all occurrences (default behavior, Limit = -1)
    Count1 := 0
    AllReplaced := StrReplace(RepeatText, "apple", "orange", true, &Count1, -1)

    ; Replace only the first occurrence (Limit = 1)
    Count2 := 0
    FirstOnly := StrReplace(RepeatText, "apple", "orange", true, &Count2, 1)

    ; Replace first three occurrences (Limit = 3)
    Count3 := 0
    FirstThree := StrReplace(RepeatText, "apple", "orange", true, &Count3, 3)

    ; Practical example: Replace first two tags in HTML
    HTMLText := "<div>Content1</div><div>Content2</div><div>Content3</div>"
    TagCount := 0
    ModifiedHTML := StrReplace(HTMLText, "<div>", "<section>", true, &TagCount, 2)

    ; Display all results
    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 4: Limited Replacements
    ═══════════════════════════════════════════════════

    Original Text:
    " RepeatText "

    Replace All (Limit = -1):
    " AllReplaced "
    Count: " Count1 "

    Replace First Only (Limit = 1):
    " FirstOnly "
    Count: " Count2 "

    Replace First Three (Limit = 3):
    " FirstThree "
    Count: " Count3 "

    ───────────────────────────────────────────────────
    HTML TAG REPLACEMENT (First 2 only):

    Original:
    " HTMLText "

    Modified:
    " ModifiedHTML "
    Count: " TagCount "
    )", "StrReplace Example 4", 0)

    ; KEY LEARNING: The Limit parameter (6th parameter) controls how many
    ; replacements are made. -1 (default) = all, 1 = first only, N = first N
}

; ============================================================================
; EXAMPLE 5: Empty String Handling
; ============================================================================
; Demonstrates various edge cases involving empty strings in StrReplace.

Example5_EmptyStringHandling() {
    TestText := "Hello World"

    ; Case 1: Replacing with empty string (deletion)
    ; This effectively removes all occurrences of the search string
    RemoveSpace := StrReplace(TestText, " ", "")

    ; Case 2: Searching for empty string
    ; Returns original string unchanged
    SearchEmpty := StrReplace(TestText, "", "X")

    ; Case 3: Both search and replace are empty
    ; Returns original string unchanged
    BothEmpty := StrReplace(TestText, "", "")

    ; Practical example: Remove all vowels
    SentenceText := "The quick brown fox jumps over the lazy dog"
    NoA := StrReplace(SentenceText, "a", "")
    NoE := StrReplace(NoA, "e", "")
    NoI := StrReplace(NoE, "i", "")
    NoO := StrReplace(NoI, "o", "")
    NoVowels := StrReplace(NoO, "u", "")

    ; Count spaces in a string
    SpaceCount := 0
    StrReplace(SentenceText, " ", "", true, &SpaceCount)

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 5: Empty String Handling
    ═══════════════════════════════════════════════════

    Original Text: '" TestText "'

    1. Replace space with empty string (remove spaces):
    Result: '" RemoveSpace "'

    2. Search for empty string:
    Result: '" SearchEmpty "'
    Note: Returns original unchanged

    3. Both search and replace empty:
    Result: '" BothEmpty "'
    Note: Returns original unchanged

    ───────────────────────────────────────────────────
    PRACTICAL EXAMPLE - Remove All Vowels:

    Original: " SentenceText "
    No Vowels: " NoVowels "

    ───────────────────────────────────────────────────
    COUNT SPACES:

    Text: " SentenceText "
    Number of spaces: " SpaceCount "
    )", "StrReplace Example 5", 0)

    ; KEY LEARNING: Replacing with "" removes the search string.
    ; Searching for "" returns the original string unchanged.
}

; ============================================================================
; EXAMPLE 6: Multiple Sequential Replacements
; ============================================================================
; Shows how to chain multiple StrReplace operations to perform complex
; text transformations.

Example6_ChainedReplacements() {
    ; Original messy text
    MessyText := "The  quick    brown   fox     jumps"

    ; Remove multiple spaces step by step
    ; Keep replacing double spaces with single space until no more exist
    CleanText := MessyText
    Loop {
        ; Save previous state
        PrevText := CleanText
        ; Replace double space with single space
        CleanText := StrReplace(CleanText, "  ", " ")
        ; If no change was made, we're done
        if (CleanText = PrevText)
            break
    }

    ; Alternative: Multiple different replacements
    CodeSnippet := "var myVariable = getValue();"

    ; Convert JavaScript to more verbose style
    Step1 := StrReplace(CodeSnippet, "var ", "let ")
    Step2 := StrReplace(Step1, "myVariable", "my_variable")
    Step3 := StrReplace(Step2, "getValue", "get_value")
    FinalCode := Step3

    ; Track each transformation
    Transform1 := CodeSnippet
    Count1 := 0
    Transform2 := StrReplace(Transform1, "var", "let", true, &Count1)
    Count2 := 0
    Transform3 := StrReplace(Transform2, "myVariable", "my_variable", true, &Count2)
    Count3 := 0
    Transform4 := StrReplace(Transform3, "getValue", "get_value", true, &Count3)

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 6: Multiple Sequential Replacements
    ═══════════════════════════════════════════════════

    CLEANING MULTIPLE SPACES:
    Original: '" MessyText "'
    Cleaned:  '" CleanText "'

    ───────────────────────────────────────────────────
    CODE TRANSFORMATION CHAIN:

    Original:
    " CodeSnippet "

    Step 1 - Replace 'var' with 'let' (Count: " Count1 "):
    " Transform2 "

    Step 2 - Replace 'myVariable' with 'my_variable' (Count: " Count2 "):
    " Transform3 "

    Step 3 - Replace 'getValue' with 'get_value' (Count: " Count3 "):
    " Transform4 "

    Final Result:
    " FinalCode "
    )", "StrReplace Example 6", 0)

    ; KEY LEARNING: You can chain StrReplace calls to perform multiple
    ; transformations. Each call works on the result of the previous one.
}

; ============================================================================
; EXAMPLE 7: Real-World Practical Applications
; ============================================================================
; Demonstrates practical, real-world uses of StrReplace in common scenarios.

Example7_PracticalApplications() {
    ; Application 1: Clean user input
    UserInput := "  Hello,   this  is   a    test!  "
    ; Trim leading/trailing spaces then clean internal spaces
    CleanInput := Trim(UserInput)
    Loop {
        PrevInput := CleanInput
        CleanInput := StrReplace(CleanInput, "  ", " ")
        if (CleanInput = PrevInput)
            break
    }

    ; Application 2: Normalize line endings
    MixedLineEndings := "Line 1`r`nLine 2`nLine 3`rLine 4"
    ; Convert all line endings to `n (LF)
    UnixEndings := StrReplace(MixedLineEndings, "`r`n", "`n")
    UnixEndings := StrReplace(UnixEndings, "`r", "`n")

    ; Application 3: Censor profanity
    CommentText := "This damn thing is crap and hell to use!"
    CensoredText := CommentText
    BadWords := ["damn", "crap", "hell"]
    for word in BadWords {
        CensoredText := StrReplace(CensoredText, word, "****", false)
    }

    ; Application 4: Format phone number
    PhoneInput := "1234567890"
    ; Insert formatting characters
    FormattedPhone := PhoneInput
    ; This is simplified - real formatting would be more complex
    if (StrLen(PhoneInput) = 10) {
        FormattedPhone := SubStr(PhoneInput, 1, 3) . "-" .
            SubStr(PhoneInput, 4, 3) . "-" .
            SubStr(PhoneInput, 7, 4)
    }

    ; Application 5: Count word occurrences
    ArticleText := "Python is great. I use Python daily. Python Python Python!"
    PythonOccurrences := 0
    StrReplace(ArticleText, "Python", "Python", true, &PythonOccurrences)

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    EXAMPLE 7: Real-World Practical Applications
    ═══════════════════════════════════════════════════

    1. CLEAN USER INPUT:
    Original: '" UserInput "'
    Cleaned:  '" CleanInput "'

    2. NORMALIZE LINE ENDINGS:
    Had mixed line endings (CRLF, LF, CR)
    Normalized to Unix-style (LF only)

    3. CENSOR PROFANITY:
    Original: " CommentText "
    Censored: " CensoredText "

    4. FORMAT PHONE NUMBER:
    Input:     " PhoneInput "
    Formatted: " FormattedPhone "

    5. COUNT WORD OCCURRENCES:
    Text: " ArticleText "
    Word 'Python' appears: " PythonOccurrences " times
    )", "StrReplace Example 7", 0)

    ; KEY LEARNING: StrReplace is versatile for many text processing tasks:
    ; cleaning input, normalizing data, censoring content, and analyzing text.
}

; ============================================================================
; RUN ALL EXAMPLES
; ============================================================================
; Execute all examples in sequence

RunAllExamples() {
    Example1_BasicReplacement()
    Example2_CaseSensitivity()
    Example3_CountingReplacements()
    Example4_LimitedReplacements()
    Example5_EmptyStringHandling()
    Example6_ChainedReplacements()
    Example7_PracticalApplications()

    MsgBox("
    (
    ═══════════════════════════════════════════════════
    All Examples Completed!
    ═══════════════════════════════════════════════════

    You have reviewed all 7 basic usage examples for StrReplace().

    Key Takeaways:
    • StrReplace replaces ALL occurrences by default
    • Case sensitivity controlled by 4th parameter
    • Use &VarName for replacement count
    • Limit parameter controls max replacements
    • Empty string replacement removes text
    • Chain multiple StrReplace for complex transformations
    )", "Examples Complete", 0)
}

; Create a simple menu to run examples
CreateExampleMenu() {
    MyMenu := Menu()
    MyMenu.Add("Example 1: Basic Replacement", (*) => Example1_BasicReplacement())
    MyMenu.Add("Example 2: Case Sensitivity", (*) => Example2_CaseSensitivity())
    MyMenu.Add("Example 3: Counting Replacements", (*) => Example3_CountingReplacements())
    MyMenu.Add("Example 4: Limited Replacements", (*) => Example4_LimitedReplacements())
    MyMenu.Add("Example 5: Empty String Handling", (*) => Example5_EmptyStringHandling())
    MyMenu.Add("Example 6: Chained Replacements", (*) => Example6_ChainedReplacements())
    MyMenu.Add("Example 7: Practical Applications", (*) => Example7_PracticalApplications())
    MyMenu.Add()  ; Separator
    MyMenu.Add("Run All Examples", (*) => RunAllExamples())

    return MyMenu
}

; Main execution
MainMenu := CreateExampleMenu()
TraySetIcon("shell32.dll", 147)  ; Set a document icon
A_TrayMenu.Add()
A_TrayMenu.Add("StrReplace Examples", (*) => MainMenu.Show())

; Show welcome message
MsgBox("
(
═══════════════════════════════════════════════════
StrReplace() - Basic Usage Examples
AutoHotkey v2.0
═══════════════════════════════════════════════════

This script contains 7 comprehensive examples demonstrating
the basic usage of the StrReplace() function.

Right-click the tray icon and select 'StrReplace Examples'
to access the example menu.

Or run all examples now by clicking OK.
═══════════════════════════════════════════════════
)", "StrReplace Examples Ready", 0)

RunAllExamples()

/*
═══════════════════════════════════════════════════
REFERENCE SECTION
═══════════════════════════════════════════════════

FUNCTION SIGNATURE:
NewStr := StrReplace(Haystack, Needle, ReplaceText := "", CaseSense := true, &OutputVarCount := 0, Limit := -1)

PARAMETERS:
1. Haystack (String)
- The string whose content is searched and replaced
- Required parameter
- Can be a literal string or variable

2. Needle (String)
- The string to search for
- Required parameter
- If empty, returns Haystack unchanged

3. ReplaceText (String, Optional)
- The string to replace Needle with
- Default: "" (empty string)
- Empty string effectively removes Needle

4. CaseSense (Boolean, Optional)
- Controls case sensitivity of the search
- Default: true (case-sensitive)
- true: "Hello" ≠ "hello"
- false: "Hello" = "hello"

5. OutputVarCount (Variable Reference, Optional)
- Variable to receive the count of replacements made
- Default: 0
- Must use & prefix: &MyCount
- Passed by reference

6. Limit (Integer, Optional)
- Maximum number of replacements to make
- Default: -1 (replace all occurrences)
- Positive number: replace first N occurrences
- 0: no replacements (returns original)

RETURN VALUE:
- Returns a new string with replacements made
- Original Haystack remains unchanged
- If Needle not found, returns Haystack unchanged
- Always returns a string value

COMMON USE CASES:
1. Replace all occurrences:
NewStr := StrReplace(OldStr, "old", "new")

2. Case-insensitive replacement:
NewStr := StrReplace(OldStr, "old", "new", false)

3. Remove all occurrences:
NewStr := StrReplace(OldStr, "remove", "")

4. Count occurrences without replacing:
Count := 0
StrReplace(Text, "search", "search", true, &Count)

5. Replace first occurrence only:
NewStr := StrReplace(OldStr, "old", "new", true, , 1)

6. Chain multiple replacements:
Result := StrReplace(StrReplace(Str, "a", "b"), "c", "d")

IMPORTANT NOTES:
• StrReplace replaces ALL occurrences by default (unlike v1 StringReplace)
• The search is performed left to right
• Replacement text can contain the search string (won't cause infinite loop)
• Empty Needle returns Haystack unchanged
• Function is pure - doesn't modify the original string
• For regex replacement, use RegExReplace() instead

PERFORMANCE CONSIDERATIONS:
• StrReplace is very fast for simple string operations
• For multiple different replacements, consider if StrReplace is appropriate
• For complex patterns, RegExReplace might be more efficient
• Chaining many StrReplace calls can impact performance

COMPARISON WITH V1:
AutoHotkey v1:
StringReplace, OutputVar, InputVar, SearchText, ReplaceText, All

AutoHotkey v2:
OutputVar := StrReplace(InputVar, SearchText, ReplaceText)

Key Differences:
• v2 is a function, v1 is a command
• v2 replaces all by default, v1 needs "All" parameter
• v2 returns value, v1 sets variable
• v2 uses modern parameters, v1 uses command syntax

RELATED FUNCTIONS:
• RegExReplace() - Replace using regular expressions
• SubStr() - Extract substring
• StrSplit() - Split string into array
• InStr() - Find position of substring
• StrLen() - Get string length
• Trim() - Remove leading/trailing whitespace

VERSION COMPATIBILITY:
• Requires AutoHotkey v2.0 or later
• Not compatible with AutoHotkey v1.1

═══════════════════════════════════════════════════
END OF REFERENCE
═══════════════════════════════════════════════════
*/

