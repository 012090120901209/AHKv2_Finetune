#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JSON.ahk

/**
 * BuiltIn_RegEx_Match_04_Options.ahk
 * 
 * DESCRIPTION:
 * Demonstrates regex options and modifiers that control matching behavior.
 * Covers case-insensitive matching, multiline mode, single-line mode,
 * ungreedy mode, and other PCRE options available in AutoHotkey v2.
 * 
 * FEATURES:
 * - Case-insensitive matching with 'i' option
 * - Multiline mode with 'm' option
 * - Single-line mode with 's' option (dot matches newline)
 * - Ungreedy mode with 'U' option
 * - Extended mode with 'x' option (ignore whitespace)
 * - Combining multiple options
 * - Option scoping with (?i), (?-i), etc.
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - RegEx
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - PCRE options in pattern strings
 * - Inline option modifiers
 * - Option inheritance and scoping
 * - Modern regex capabilities
 * - Performance considerations
 * 
 * LEARNING POINTS:
 * 1. Options are specified at the start of the pattern: "i)pattern"
 * 2. Multiple options can be combined: "im)pattern"
 * 3. Inline modifiers affect only part of pattern: "(?i)case(?-i)SENSITIVE"
 * 4. 'm' makes ^ and $ match line boundaries, not just string boundaries
 * 5. 's' makes . match newlines (normally it doesn't)
 * 6. 'U' makes quantifiers ungreedy by default
 * 7. 'x' allows whitespace and comments in patterns for readability
 */

; ========================================
; EXAMPLE 1: Case-Insensitive Matching (i)
; ========================================
; Using 'i' option for case-insensitive searches
Example1_CaseInsensitive() {
    MsgBox "EXAMPLE 1: Case-Insensitive Matching (i)`n" .
        "=========================================="

    text := "The HTML, html, Html, and HtMl all refer to the same thing"

    ; Case-sensitive (default)
    matches := []
    pos := 1
    while (pos := RegExMatch(text, "html", &match, pos)) {
        matches.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "Case-sensitive 'html':`n" .
        "Found: " . matches.Length . " matches`n" .
        "Matches: " . (matches.Length > 0 ? StrJoin(matches, ", ") : "None")

    ; Case-insensitive with 'i' option
    matches := []
    pos := 1
    while (pos := RegExMatch(text, "i)html", &match, pos)) {
        matches.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "Case-insensitive 'i)html':`n" .
        "Found: " . matches.Length . " matches`n" .
        "Matches: " . StrJoin(matches, ", ")

    ; Practical: File extension checking
    CheckFileType(filename) {
        if RegExMatch(filename, "i)\.(jpg|jpeg|png|gif)$", &match)
            return "Image (" . match[1] . ")"
        else if RegExMatch(filename, "i)\.(mp4|avi|mkv)$", &match)
            return "Video (" . match[1] . ")"
        else if RegExMatch(filename, "i)\.(txt|doc|pdf)$", &match)
            return "Document (" . match[1] . ")"
        return "Unknown"
    }

    files := ["Photo.JPG", "video.Mp4", "document.PDF", "data.csv"]
    result := "File Type Detection (case-insensitive):`n"
    for file in files {
        result .= file . " -> " . CheckFileType(file) . "`n"
    }
    MsgBox result

    ; Inline case modifier
    text2 := "The word STOP must be uppercase, but stop can be lowercase"

    ; Match "STOP" only in uppercase
    if RegExMatch(text2, "\bSTOP\b", &match)
        MsgBox "Found uppercase STOP: " . match[0]

    ; Match "stop" in any case
    matches := []
    pos := 1
    while (pos := RegExMatch(text2, "i)\bstop\b", &match, pos)) {
        matches.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "All variations of 'stop':`n" . StrJoin(matches, ", ")

    ; Partial case-insensitive matching
    text3 := "UserID=12345 or userId=67890 or USERID=11111"

    ; Only "ID" is case-insensitive
    pattern := "user(?i)id(?-i)=(\d+)"
    matches := []
    pos := 1
    while (pos := RegExMatch(text3, pattern, &match, pos)) {
        matches.Push(Map("full", match[0], "id", match[1]))
        pos := match.Pos + match.Len
    }

    result := "Partial case-insensitive ('user' sensitive, 'ID' insensitive):`n"
    for index, m in matches {
        result .= m["full"] . " -> ID: " . m["id"] . "`n"
    }
    MsgBox result
}

; ========================================
; EXAMPLE 2: Multiline Mode (m)
; ========================================
; Using 'm' to make ^ and $ match line boundaries
Example2_MultilineMode() {
    MsgBox "EXAMPLE 2: Multiline Mode (m)`n" .
        "==============================="

    text := "Line 1: First line`nLine 2: Second line`nLine 3: Third line"

    ; Without multiline mode: ^ matches only start of entire string
    if RegExMatch(text, "^Line", &match)
        MsgBox "Without 'm' option:`n" .
            "'^Line' matches: " . match[0] . "`n" .
            "(Only matches at very start of string)"

    ; With multiline mode: ^ matches start of any line
    matches := []
    pos := 1
    while (pos := RegExMatch(text, "m)^Line \d+", &match, pos)) {
        matches.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "With 'm)' option:`n" .
        "'^Line \\d+' matches all lines:`n" .
        StrJoin(matches, "`n")

    ; $ without multiline: matches end of string only
    if RegExMatch(text, "line$", &match)
        MsgBox "Without 'm' option:`n" .
            "'line$' matches: " . match[0] . "`n" .
            "(Only at very end of string)"

    ; $ with multiline: matches end of any line
    matches := []
    pos := 1
    while (pos := RegExMatch(text, "m)line$", &match, pos)) {
        matches.Push(match[0])
        pos := match.Pos + match.Len
    }
    MsgBox "With 'm)' option:`n" .
        "'line$' matches: " . matches.Length . " times"

    ; Practical: Extract log entries by line
    log := "
    (
    ERROR: Connection failed
    INFO: Retrying connection
    ERROR: Timeout occurred
    INFO: Connection successful
    )"

    ; Extract all ERROR lines
    errors := []
    pos := 1
    while (pos := RegExMatch(log, "m)^ERROR:.*$", &match, pos)) {
        errors.Push(match[0])
        pos := match.Pos + match.Len
    }

    MsgBox "Error Log Entries:`n" . StrJoin(errors, "`n")

    ; Extract line numbers with content
    code := "
    (
    function test() {
        var x = 5;
        return x;
    }
    )"

    lines := []
    lineNum := 0
    Loop Parse, code, "`n", "`r" {
        lineNum++
        line := Trim(A_LoopField)
        if line != "" && RegExMatch(line, "m)^(function|var|return)\b", &match)
            lines.Push(lineNum . ": " . match[0] . "...")
    }

    MsgBox "Lines with keywords:`n" . StrJoin(lines, "`n")

    ; Validate indentation
    pythonCode := "
    (
    def function():
    if condition:
    do_something()
    else:
    do_other()
    )"

    indentedLines := 0
    Loop Parse, pythonCode, "`n", "`r" {
        if RegExMatch(A_LoopField, "m)^    ")  ; 4 spaces
            indentedLines++
    }

    MsgBox "Lines with 4-space indentation: " . indentedLines
}

; ========================================
; EXAMPLE 3: Single-Line Mode (s)
; ========================================
; Using 's' to make . match newlines
Example3_SingleLineMode() {
    MsgBox "EXAMPLE 3: Single-Line Mode (s)`n" .
        "================================="

    text := "Start`nMiddle`nEnd"

    ; Without 's': . doesn't match newlines
    if RegExMatch(text, "Start.+End", &match)
        MsgBox "Without 's)' option:`n" .
            "Pattern 'Start.+End': " . (match ? match[0] : "No match") . "`n" .
            "(. doesn't match newlines)"
    else
        MsgBox "Without 's)' option:`n" .
            "Pattern 'Start.+End': No match`n" .
            "(. doesn't match newlines)"

    ; With 's': . matches newlines
    if RegExMatch(text, "s)Start.+End", &match)
        MsgBox "With 's)' option:`n" .
            "Pattern 'Start.+End' matches:`n" .
            match[0] . "`n`n" .
            "(. now matches newlines)"

    ; Practical: Extract HTML content including newlines
    html := "
    (
    <div>
    <p>First paragraph</p>
    <p>Second paragraph</p>
    </div>
    )"

    ; Without 's': won't match across lines
    if RegExMatch(html, "<div>.+</div>", &match)
        MsgBox "Without 's)': Matched (unexpected!)"
    else
        MsgBox "Without 's)':`n<div>.+</div> - No match (expected)"

    ; With 's': matches across lines
    if RegExMatch(html, "s)<div>(.+)</div>", &match)
        MsgBox "With 's)':`n<div>(.+)</div> matches:`n" . match[1]

    ; Lazy quantifier with single-line mode
    multiDiv := "<div>Content 1</div>`n<div>Content 2</div>"

    ; Greedy with 's'
    if RegExMatch(multiDiv, "s)<div>.+</div>", &match)
        MsgBox "Greedy with 's)': " . match[0] . "`n(Matches entire string)"

    ; Lazy with 's'
    if RegExMatch(multiDiv, "s)<div>.+?</div>", &match)
        MsgBox "Lazy with 's)': " . match[0] . "`n(Matches first div only)"

    ; Extract JavaScript multi-line comments
    code := "
    (
    /* This is a
    multi-line
    comment */
    var x = 5;
    )"

    if RegExMatch(code, "s)/\*(.+?)\*/", &match)
        MsgBox "Multi-line comment extracted:`n" . match[1]

    ; Extract code blocks
    markdown := "
    (
    Some text here
    ```
    code line 1
    code line 2
    ```
    More text
    )"

    if RegExMatch(markdown, "s)```(.+?)```", &match)
        MsgBox "Code block extracted:`n" . match[1]
    }
        ; ========================================
        ; EXAMPLE 4: Ungreedy Mode (U)
        ; ========================================
        ; Using 'U' to make quantifiers ungreedy by default
        Example4_UngreedyMode() {
        MsgBox "EXAMPLE 4: Ungreedy Mode (U)`n" .
            "=============================="

        html := "<b>Bold 1</b> and <b>Bold 2</b>"

        ; Normal (greedy) mode
        if RegExMatch(html, "<b>.*</b>", &match)
            MsgBox "Greedy (default):`n" . match[0] . "`n`n" .
                "Matches from first <b> to last </b>"

        ; Lazy quantifier (manual)
        if RegExMatch(html, "<b>.*?</b>", &match)
            MsgBox "Lazy quantifier (.*?):`n" . match[0] . "`n`n" .
                "Matches first <b>...</b> only"

        ; Ungreedy mode with 'U'
        if RegExMatch(html, "U)<b>.*</b>", &match)
            MsgBox "Ungreedy mode U):`n" . match[0] . "`n`n" .
                "Quantifiers are ungreedy by default"

        ; Extract all tags in ungreedy mode
        matches := []
        pos := 1
        while (pos := RegExMatch(html, "U)<b>.*</b>", &match, pos)) {
            matches.Push(match[0])
            pos := match.Pos + match.Len
        }
        MsgBox "All <b> tags (ungreedy):`n" . StrJoin(matches, "`n")

        ; Making quantifiers greedy again with +
        text := "aaa bbb ccc"
        if RegExMatch(text, "U)\w+", &match)
            MsgBox "Ungreedy \\w+: " . match[0] . " (matches minimum)"

        if RegExMatch(text, "U)\w++", &match)
            MsgBox "Possessive \\w++ in ungreedy mode: " . match[0] . " (greedy)"

        ; Practical: Parse key-value pairs
        config := "key1=value1, key2=value2, key3=value3"

        pairs := []
        pos := 1
        while (pos := RegExMatch(config, "U)(\w+)=([^,]+)", &match, pos)) {
            pairs.Push(Map("key", match[1], "value", Trim(match[2])))
            pos := match.Pos + match.Len
        }

        result := "Key-Value Pairs:`n"
        for pair in pairs {
            result .= pair["key"] . " = " . pair["value"] . "`n"
        }
        MsgBox result

        ; Extract quoted strings ungreedy
        json := '{"name":"John","age":"30","city":"NYC"}'

        values := []
        pos := 1
        while (pos := RegExMatch(json, 'U)".*"', &match, pos)) {
            values.Push(match[0])
            pos := match.Pos + match.Len
        }
        MsgBox "JSON values (ungreedy):`n" . StrJoin(values, "`n")
    }

    ; ========================================
    ; EXAMPLE 5: Extended Mode (x)
    ; ========================================
    ; Using 'x' for readable patterns with whitespace and comments
    Example5_ExtendedMode() {
        MsgBox "EXAMPLE 5: Extended Mode (x)`n" .
            "=============================="

        ; Complex pattern without 'x' (hard to read)
        pattern1 := "^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})$"

        ; Same pattern with 'x' mode (readable)
        pattern2 := "
        (x)
        ^ #Start of string
        (\d { 4 })#Year (4 digits)
        - #Separator
        (\d { 2 })#Month (2 digits)
        - #Separator
        (\d { 2 })#Day (2 digits)
        T#Time separator
        (\d { 2 })#Hour (2 digits)
        : #Separator
        (\d { 2 })#Minute (2 digits)
        : #Separator
        (\d { 2 })#Second (2 digits)
        $#End of string
    ) "

    datetime := "2024-01-15T10:30:45"

    if RegExMatch(datetime, pattern2, &match) {
        MsgBox "Extended pattern matched!`n" .
            "Year: " . match[1] . "`n" .
            "Month: " . match[2] . "`n" .
            "Day: " . match[3] . "`n" .
            "Hour: " . match[4] . "`n" .
            "Minute: " . match[5] . "`n" .
            "Second: " . match[6]
    }

    ; Complex email pattern with comments
    emailPattern := "
    (x)
    ^ #Start
    ([a - zA - Z0 - 9_\.\ -] +)#Local part (username)
    @#At symbol
    ([a - zA - Z0 - 9\ -] +)#Domain name
    \.#Dot
    ([a - zA - Z] { 2, 6 })#TLD (2 - 6 letters)
    $#End
) "

email := "user.name@example.com"

if RegExMatch(email, emailPattern, &match) {
    MsgBox "Email parsed (extended pattern):`n" .
        "Local: " . match[1] . "`n" .
        "Domain: " . match[2] . "`n" .
        "TLD: " . match[3]
}

; Phone number pattern with documentation
phonePattern := "
(x)
\ + ? #Optional plus
    (\d { 1, 3 })#Country code (1 - 3 digits)\s ? #Optional space\( ? #Optional opening paren
        (\d { 3 })#Area code (3 digits)\) ? #Optional closing paren
            [-\s] ? #Optional separator
                (\d { 3 })#Prefix (3 digits)
                    [-\s] ? #Optional separator
                        (\d { 4 })#Line number (4 digits)) "
                        phones := ["+1 (555) 123-4567", "1-555-123-4567", "555-123-4567"]
                        result := "Phone Number Parsing:`n"
                        for phone in phones {
                            if RegExMatch(phone, phonePattern, &match) {
                                result .= phone . "`n" .
                                    "  Country: " . (match[1] || "N/A") . "`n" .
                                    "  Area: " . match[2] . "`n" .
                                    "  Prefix: " . match[3] . "`n" .
                                    "  Line: " . match[4] . "`n"
                            }
                        }
                        MsgBox result
                        ; To match literal spaces in 'x' mode, use \ or \s
                        pattern := "
                        (x)
                        hello\world#Literal space with backslash
                        | hello\sworld# Or use\s
                    ) "
                    MsgBox "Matches 'hello world': " . (RegExMatch("hello world", pattern) ? "Yes" : "No")
                }
                ; ========================================
                ; EXAMPLE 6: Combining Multiple Options
                ; ========================================
                ; Using multiple options together
                Example6_CombinedOptions() {
                    MsgBox "EXAMPLE 6: Combining Multiple Options`n" .
                        "======================================="

                    ; Case-insensitive + Multiline
                    log := "
    (
    ERROR: First error
    INFO: Some info
    error: Second error
    Error: Third error
    )"

                    errors := []
                    pos := 1
                    while (pos := RegExMatch(log, "im)^error:.*$", &match, pos)) {
                        errors.Push(match[0])
                        pos := match.Pos + match.Len
                    }

                    MsgBox "Case-insensitive + Multiline (im):`n" .
                        "All error lines:`n" . StrJoin(errors, "`n")

                    ; Single-line + Case-insensitive + Ungreedy
                    html := "
    (
    <DIV>
    Content 1
    </div>
    <div>
    Content 2
    </DIV>
    )"

                    divs := []
                    pos := 1
                    while (pos := RegExMatch(html, "siU)<div>.*</div>", &match, pos)) {
                        divs.Push(match[0])
                        pos := match.Pos + match.Len
                    }

                    MsgBox "Single-line + Case-insensitive + Ungreedy (siU):`n" .
                        "Found " . divs.Length . " div(s)"

                    ; Multiline + Extended
                    config := "
    (
    Setting1 = Value1
    Setting2 = Value2
    Setting3 = Value3
    )"

                    pattern := "
                    (mx)
                    ^ #Start of line
                    (\w +)#Setting name
                    \s * = \s * #Equals with optional spaces
                    (. +)#Value
                    $#End of line
                ) "
                settings := Map()
                pos := 1
                while (pos := RegExMatch(config, pattern, &match, pos)) {
                    settings[match[1]] := match[2]
                    pos := match.Pos + match.Len
                }
                result := "Settings (multiline + extended):`n"
                for key, value in settings {
                    result .= key . " = " . value . "`n"
                }
                MsgBox result
                ; All options: imsx
                complexText := "
    (
    <HTML>
    <HEAD><TITLE>Test</TITLE></head>
    <BODY>
    Content here
    </body>
    </HTML>
    )"
                pattern := "
                (imsxU)
                < head > #Head tag (
                    case -insensitive). * #Any content (crosses lines, ungreedy)
                < / head > #Closing tag
    ) "
        if RegExMatch(complexText, pattern, &match)
            MsgBox "All options (imsxU):`nMatched: " . match[0]
                ; Practical: Parse markdown headers with options
                markdown := "
    (
    # Main Title
    ## Subtitle
    ### Section
    # Another Title

    )"
        pattern := "
        (mx)
        ^ #Start of line
        (\# { 1, 6 })#1 - 6 hash symbols\s#Space
        (. +)#Title text$#End of line
        ) "
        headers := []
        pos := 1
        while (pos := RegExMatch(markdown, pattern, &match, pos)) {
            level := StrLen(match[1])
            headers.Push(Map("level", level, "text", match[2]))
            pos := match.Pos + match.Len
        }
        result := "Markdown Headers:`n"
        for header in headers {
            result .= "H" . header["level"] . ": " . header["text"] . "`n"
        }
        MsgBox result
    }

    ; ========================================
    ; EXAMPLE 7: Option Scoping
    ; ========================================
    ; Inline option modifiers for parts of patterns
    Example7_OptionScoping() {
        MsgBox "EXAMPLE 7: Option Scoping`n" .
            "========================="

        ; Turn on/off options mid-pattern
        text := "UserID and userId and USERID"

        ; Case-sensitive "User", case-insensitive "ID"
        pattern := "User(?i)ID(?-i)"

        matches := []
        pos := 1
        while (pos := RegExMatch(text, pattern, &match, pos)) {
            matches.Push(match[0])
            pos := match.Pos + match.Len
        }

        MsgBox "Pattern: User(?i)ID(?-i)`n" .
            "Matches 'User' (case-sensitive) + 'ID' (any case):`n" .
            StrJoin(matches, ", ")

        ; Case-insensitive for specific group
        code := "VAR x = 5; var y = 10; Var z = 15;"

        pattern := "(?i:var)\s+(\w+)"  ; 'var' insensitive, rest normal

        vars := []
        pos := 1
        while (pos := RegExMatch(code, pattern, &match, pos)) {
            vars.Push(match[1])
            pos := match.Pos + match.Len
        }

        MsgBox "Variables found (case-insensitive 'var'):`n" .
            StrJoin(vars, ", ")

        ; Multiple scoped options
        text2 := "ERROR: First`nerror: Second`nERROR: Third"

        pattern := "(?im)^error:.*$"  ; Scoped to this group

        errors := []
        pos := 1
        while (pos := RegExMatch(text2, pattern, &match, pos)) {
            errors.Push(match[0])
            pos := match.Pos + match.Len
        }

        MsgBox "Scoped options (?im):`n" . StrJoin(errors, "`n")

        ; Option groups
        mixed := "ABC123def456GHI789"

        ; Different options for different parts
        pattern := "([A-Z]+)(?i)(\d+[a-z]+)"

        matches := []
        pos := 1
        while (pos := RegExMatch(mixed, pattern, &match, pos)) {
            matches.Push(Map("upper", match[1], "mixed", match[2]))
            pos := match.Pos + match.Len
        }

        result := "Pattern with scoped options:`n"
        for m in matches {
            result .= "Upper: " . m["upper"] . ", Mixed: " . m["mixed"] . "`n"
        }
        MsgBox result

        ; Reset options
        text3 := "Test TEST test"

        ; Start case-insensitive, then turn off
        pattern := "(?i)test(?-i).*TEST"

        if RegExMatch(text3, pattern, &match)
            MsgBox "Pattern (?i)test(?-i).*TEST:`n" . match[0]

        ; Option inheritance
        pattern := "(?i)(user|admin)(?-i)_(\w+)"

        testStrings := ["USER_john", "Admin_Jane", "user_MIKE", "guest_bob"]

        result := "Option inheritance test:`n"
        for str in testStrings {
            result .= str . ": " . (RegExMatch(str, pattern) ? "Match" : "No match") . "`n"
        }
        MsgBox result
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
    RegExMatch Options and Modifiers
    =================================

    1. Case-Insensitive (i)
    2. Multiline Mode (m)
    3. Single-Line Mode (s)
    4. Ungreedy Mode (U)
    5. Extended Mode (x)
    6. Combining Options
    7. Option Scoping

    Press Ctrl+1-7 to run examples
    )"

        MsgBox menu
    }

    ^1:: Example1_CaseInsensitive()
    ^2:: Example2_MultilineMode()
    ^3:: Example3_SingleLineMode()
    ^4:: Example4_UngreedyMode()
    ^5:: Example5_ExtendedMode()
    ^6:: Example6_CombinedOptions()
    ^7:: Example7_OptionScoping()

    ^h:: ShowMenu()

    ShowMenu()
