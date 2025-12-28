#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * ControlSend_02 - Text Entry and Special Characters
 * ============================================================================
 * 
 * Demonstrates advanced text entry including special characters, Unicode,
 * escape sequences, and formatted text sending.
 * 
 * @description
 * ControlSend supports various text formats and special characters:
 * - Unicode text
 * - Escape sequences
 * - Special characters
 * - Formatted text with line breaks
 * - Tab characters and spacing
 * 
 * Key Features:
 * - Unicode character support
 * - Escape sequence handling
 * - Special character sending
 * - Multi-line text formatting
 * - Raw vs processed text modes
 * 
 * @syntax ControlSend Keys, Control, WinTitle, WinText
 * 
 * @author AutoHotkey Community
 * @version 1.0.0
 * @since 2024-01-16
 * 
 * @example
 * ; Send Unicode text
 * ControlSend "Hello 世界!", "Edit1", "Notepad"
 * 
 * @see https://www.autohotkey.com/docs/v2/lib/ControlSend.htm
 */

; ============================================================================
; Example 1: Special Characters and Escape Sequences
; ============================================================================

/**
 * @function Example1_SpecialCharacters
 * @description Demonstrates sending special characters
 * Shows escape sequences and special character handling
 */
Example1_SpecialCharacters() {
    MsgBox("Example 1: Special Characters`n`n" .
        "Send special characters and escape sequences.",
        "Special Characters", "OK Icon!")

    ; Create output GUI
    myGui := Gui("+AlwaysOnTop", "Special Characters Demo")
    myGui.Add("Text", "w500", "Output Area:")

    outputEdit := myGui.Add("Edit", "w500 h350 Multi", "")

    myGui.Add("Text", "w500 y+10", "Test Special Characters:")

    newlineBtn := myGui.Add("Button", "w95 y+10", "Newlines")
    newlineBtn.OnEvent("Click", (*) => SendNewlines())

    tabBtn := myGui.Add("Button", "w95 x+10", "Tabs")
    tabBtn.OnEvent("Click", (*) => SendTabs())

    quotesBtn := myGui.Add("Button", "w95 x+10", "Quotes")
    quotesBtn.OnEvent("Click", (*) => SendQuotes())

    symbolsBtn := myGui.Add("Button", "w95 x+10", "Symbols")
    symbolsBtn.OnEvent("Click", (*) => SendSymbols())

    bracketsBtn := myGui.Add("Button", "w95 x+10", "Brackets")
    bracketsBtn.OnEvent("Click", (*) => SendBrackets())

    clearBtn := myGui.Add("Button", "w245 y+20", "Clear Output")
    clearBtn.OnEvent("Click", (*) => outputEdit.Value := "")

    closeBtn := myGui.Add("Button", "w245 x+10", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    winTitle := "Special Characters Demo"

    ; Send newlines
    SendNewlines() {
        text := "`n=== Newline Test ===`n"
        text .= "Line 1`n"
        text .= "Line 2`n"
        text .= "Line 3`n`n"
        text .= "Double newline above^`n`n"

        ControlSend(text, "Edit1", winTitle)
    }

    ; Send tabs
    SendTabs() {
        text := "`n=== Tab Test ===`n"
        text .= "Column1`tColumn2`tColumn3`n"
        text .= "Data1`tData2`tData3`n"
        text .= "`tIndented line`n"
        text .= "`t`tDouble indented`n`n"

        ControlSend(text, "Edit1", winTitle)
    }

    ; Send quotes
    SendQuotes() {
        text := "`n=== Quote Test ===`n"
        text .= "Single quotes: 'text'`n"
        text .= "Double quotes: `"text`"`n"
        text .= "Mixed: `"It's great!`"`n"
        text .= "Escaped: ``` backtick`n`n"

        ControlSend(text, "Edit1", winTitle)
    }

    ; Send symbols
    SendSymbols() {
        text := "`n=== Symbol Test ===`n"
        text .= "Math: + - * / = < > <= >=`n"
        text .= "Logic: & | ! ^ ~ %`n"
        text .= "Currency: $ € £ ¥`n"
        text .= "Misc: @ # $ % ^ & * ( )`n`n"

        ControlSend(text, "Edit1", winTitle)
    }

    ; Send brackets
    SendBrackets() {
        text := "`n=== Bracket Test ===`n"
        text .= "Round: (text)`n"
        text .= "Square: [text]`n"
        text .= "Curly: " . Chr(123) . "text" . Chr(125) . "`n"
        text .= "Angle: <text>`n"
        text .= "Nested: {[(<text>)]}`n`n"

        ControlSend(text, "Edit1", winTitle)
    }

    MsgBox("Special characters demo started!", "Info", "OK Icon! T2")
}

; ============================================================================
; Example 2: Unicode and International Characters
; ============================================================================

/**
 * @function Example2_Unicode
 * @description Demonstrates Unicode text sending
 * Shows international characters and emoji support
 */
Example2_Unicode() {
    MsgBox("Example 2: Unicode Characters`n`n" .
        "Send Unicode and international text.",
        "Unicode Demo", "OK Icon!")

    ; Create output GUI
    myGui := Gui("+AlwaysOnTop", "Unicode Demo")
    myGui.Add("Text", "w500", "Unicode Output Area:")

    outputEdit := myGui.Add("Edit", "w500 h350 Multi", "")

    myGui.Add("Text", "w500 y+10", "Unicode Character Sets:")

    europeanBtn := myGui.Add("Button", "w95 y+10", "European")
    europeanBtn.OnEvent("Click", (*) => SendEuropean())

    asianBtn := myGui.Add("Button", "w95 x+10", "Asian")
    asianBtn.OnEvent("Click", (*) => SendAsian())

    arabicBtn := myGui.Add("Button", "w95 x+10", "Arabic")
    arabicBtn.OnEvent("Click", (*) => SendArabic())

    symbolsBtn := myGui.Add("Button", "w95 x+10", "Symbols")
    symbolsBtn.OnEvent("Click", (*) => SendUnicodeSymbols())

    mathBtn := myGui.Add("Button", "w95 x+10", "Math")
    mathBtn.OnEvent("Click", (*) => SendMath())

    clearBtn := myGui.Add("Button", "w245 y+20", "Clear Output")
    clearBtn.OnEvent("Click", (*) => outputEdit.Value := "")

    closeBtn := myGui.Add("Button", "w245 x+10", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    winTitle := "Unicode Demo"

    ; European languages
    SendEuropean() {
        text := "`n=== European Languages ===`n"
        text .= "English: Hello World!`n"
        text .= "Spanish: ¡Hola Mundo! ñáéíóú`n"
        text .= "French: Bonjour! àâæçéèêëïîôùûü`n"
        text .= "German: Hallo! äöüß`n"
        text .= "Portuguese: Olá! ãõâêôç`n"
        text .= "Nordic: Hej! åäö øæå`n`n"

        ControlSend(text, "Edit1", winTitle)
    }

    ; Asian languages
    SendAsian() {
        text := "`n=== Asian Languages ===`n"
        text .= "Chinese (Simplified): 你好世界`n"
        text .= "Chinese (Traditional): 你好世界`n"
        text .= "Japanese: こんにちは世界 カタカナ`n"
        text .= "Korean: 안녕하세요 세계`n"
        text .= "Thai: สวัสดีชาวโลก`n"
        text .= "Hindi: नमस्ते दुनिया`n`n"

        ControlSend(text, "Edit1", winTitle)
    }

    ; Arabic and RTL
    SendArabic() {
        text := "`n=== Arabic & Hebrew ===`n"
        text .= "Arabic: مرحبا بالعالم`n"
        text .= "Hebrew: שלום עולם`n"
        text .= "Persian: سلام دنیا`n`n"

        ControlSend(text, "Edit1", winTitle)
    }

    ; Unicode symbols
    SendUnicodeSymbols() {
        text := "`n=== Unicode Symbols ===`n"
        text .= "Arrows: → ← ↑ ↓ ⇒ ⇐ ⇑ ⇓`n"
        text .= "Check: ✓ ✔ ✗ ✘`n"
        text .= "Stars: ★ ☆ ✪ ✫ ✬ ✭ ✮ ✯`n"
        text .= "Hearts: ♥ ♡ ❤ ❥ ❦ ❧`n"
        text .= "Music: ♩ ♪ ♫ ♬ ♭ ♮ ♯`n"
        text .= "Weather: ☀ ☁ ☂ ☃ ❄ ⚡`n`n"

        ControlSend(text, "Edit1", winTitle)
    }

    ; Math symbols
    SendMath() {
        text := "`n=== Mathematical Symbols ===`n"
        text .= "Operators: ± × ÷ ∓ ∔ ∕`n"
        text .= "Relations: ≠ ≈ ≡ ≤ ≥ ∞`n"
        text .= "Set Theory: ∈ ∉ ⊂ ⊃ ∩ ∪`n"
        text .= "Logic: ∧ ∨ ¬ ∀ ∃`n"
        text .= "Greek: α β γ δ ε π σ ω Ω`n"
        text .= "Superscripts: x² x³ xⁿ`n"
        text .= "Subscripts: H₂O CO₂`n`n"

        ControlSend(text, "Edit1", winTitle)
    }

    MsgBox("Unicode demo started!", "Info", "OK Icon! T2")
}

; ============================================================================
; Example 3: Formatted Text and Templates
; ============================================================================

/**
 * @function Example3_FormattedText
 * @description Send formatted text templates
 * Shows practical text formatting and template usage
 */
Example3_FormattedText() {
    MsgBox("Example 3: Formatted Text Templates`n`n" .
        "Send pre-formatted text templates.",
        "Formatted Text", "OK Icon!")

    ; Create GUI
    myGui := Gui("+AlwaysOnTop", "Text Templates Demo")
    myGui.Add("Text", "w500", "Output Area:")

    outputEdit := myGui.Add("Edit", "w500 h350 Multi", "")

    myGui.Add("Text", "w500 y+10", "Template Selection:")

    emailBtn := myGui.Add("Button", "w95 y+10", "Email")
    emailBtn.OnEvent("Click", (*) => SendEmail())

    reportBtn := myGui.Add("Button", "w95 x+10", "Report")
    reportBtn.OnEvent("Click", (*) => SendReport())

    tableBtn := myGui.Add("Button", "w95 x+10", "Table")
    tableBtn.OnEvent("Click", (*) => SendTable())

    codeBtn := myGui.Add("Button", "w95 x+10", "Code")
    codeBtn.OnEvent("Click", (*) => SendCode())

    listBtn := myGui.Add("Button", "w95 x+10", "List")
    listBtn.OnEvent("Click", (*) => SendList())

    clearBtn := myGui.Add("Button", "w245 y+20", "Clear Output")
    clearBtn.OnEvent("Click", (*) => outputEdit.Value := "")

    closeBtn := myGui.Add("Button", "w245 x+10", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    winTitle := "Text Templates Demo"

    ; Email template
    SendEmail() {
        template := "
        (
        From: sender@example.com
        To: recipient@example.com
        Subject: Meeting Confirmation
        Date: " . FormatTime(, "yyyy-MM-dd") . "

        Dear Recipient,

        This is to confirm our meeting scheduled for next week.

        Details:
        - Date: Next Tuesday
        - Time: 2:00 PM
        - Location: Conference Room A
        - Duration: 1 hour

        Please let me know if you need to reschedule.

        Best regards,
        Sender Name

        )"

        ControlSend("`n" . template . "`n", "Edit1", winTitle)
    }

    ; Report template
    SendReport() {
        template := "
        (
        ===============================================
        MONTHLY STATUS REPORT
        ===============================================

        Report Period: " . FormatTime(, "MMMM yyyy") . "
        Generated: " . FormatTime(, "yyyy-MM-dd HH:mm:ss") . "

        EXECUTIVE SUMMARY
        -----------------
        This report provides an overview of activities
        and accomplishments for the reporting period.

        KEY METRICS
        -----------
        - Tasks Completed: 42
        - Tasks In Progress: 15
        - Tasks Pending: 8
        - Overall Progress: 85%

        ACCOMPLISHMENTS
        ---------------
        1. Project Alpha completed on schedule
        2. Beta testing initiated successfully
        3. Customer satisfaction improved by 12%

        CHALLENGES
        ----------
        - Resource constraints in Q3
        - Technical issues with deployment

        NEXT STEPS
        ----------
        → Finalize remaining deliverables
        → Prepare for next phase
        → Schedule review meeting

        ===============================================

        )"

        ControlSend("`n" . template . "`n", "Edit1", winTitle)
    }

    ; Table template
    SendTable() {
        template := "
        (
        ╔══════════════╦══════════╦══════════╦══════════╗
        ║ Product      ║ Quantity ║ Price    ║ Total    ║
        ╠══════════════╬══════════╬══════════╬══════════╣
        ║ Widget A     ║    10    ║  $25.00  ║  $250.00 ║
        ║ Widget B     ║    5     ║  $45.00  ║  $225.00 ║
        ║ Widget C     ║    8     ║  $30.00  ║  $240.00 ║
        ╠══════════════╩══════════╩══════════╬══════════╣
        ║                         Subtotal   ║  $715.00 ║
        ║                              Tax   ║   $57.20 ║
        ║                            Total   ║  $772.20 ║
        ╚════════════════════════════════════╩══════════╝

        )"

        ControlSend("`n" . template . "`n", "Edit1", winTitle)
    }

    ; Code template
    SendCode() {
        template := "
        (
        // ===============================================
        // Example Function: Calculate Factorial
        // ===============================================

        /**
        * Calculate factorial of a number
        * @param {Integer} n - Input number
        * @returns {Integer} Factorial result
        */
        function Factorial(n) {
            if (n <= 1) {
                return 1
            }
            return n * Factorial(n - 1)
        }

        // Usage example:
        result := Factorial(5)  // Returns: 120

        // Test cases:
        MsgBox(Factorial(0))  // Expected: 1
        MsgBox(Factorial(5))  // Expected: 120
        MsgBox(Factorial(10)) // Expected: 3628800

        )"

        ControlSend("`n" . template . "`n", "Edit1", winTitle)
    }

    ; List template
    SendList() {
        template := "
        (
        PROJECT CHECKLIST
        =================

        Phase 1: Planning
        □ Define requirements
        □ Create timeline
        □ Assign resources
        □ Set milestones

        Phase 2: Development
        □ Design architecture
        □ Implement features
        □ Write tests
        □ Code review

        Phase 3: Testing
        □ Unit testing
        □ Integration testing
        □ User acceptance testing
        □ Performance testing

        Phase 4: Deployment
        □ Prepare environment
        □ Deploy to staging
        □ Final verification
        □ Deploy to production

        Phase 5: Post-Launch
        □ Monitor performance
        □ Gather feedback
        □ Plan improvements
        □ Document lessons learned

        )"

        ControlSend("`n" . template . "`n", "Edit1", winTitle)
    }

    MsgBox("Text templates demo started!", "Info", "OK Icon! T2")
}

; ============================================================================
; Example 4: Escape Sequence Handling
; ============================================================================

/**
 * @function Example4_EscapeSequences
 * @description Demonstrates escape sequence handling
 * Shows how to send literal special characters
 */
Example4_EscapeSequences() {
    MsgBox("Example 4: Escape Sequences`n`n" .
        "Handle escape sequences and literal characters.",
        "Escape Sequences", "OK Icon!")

    ; Create GUI
    myGui := Gui("+AlwaysOnTop", "Escape Sequences Demo")
    myGui.Add("Text", "w500", "Test Output:")

    outputEdit := myGui.Add("Edit", "w500 h300 Multi", "")

    myGui.Add("Text", "w500 y+10", "Comparison Tests:")

    ; Info panel
    infoEdit := myGui.Add("Edit", "w500 h100 y+10 ReadOnly Multi",
        "Escape Sequences:`n" .
        "``n = newline    ``t = tab    ``r = carriage return`n" .
        "``` = backtick   `"" = double quote ")
        literalBtn := myGui.Add("Button", "w160 y+20", "Send Literal {}")
        literalBtn.OnEvent("Click", (*) => SendLiteral())
        escapedBtn := myGui.Add("Button", "w160 x+10", "Send Escaped Text")
        escapedBtn.OnEvent("Click", (*) => SendEscaped())
        rawBtn := myGui.Add("Button", "w160 x+10", "Send Raw Block")
        rawBtn.OnEvent("Click", (*) => SendRaw())
        clearBtn := myGui.Add("Button", "w245 y+20", "Clear Output")
        clearBtn.OnEvent("Click", (*) => outputEdit.Value := "")
        closeBtn := myGui.Add("Button", "w245 x+10", "Close Demo")
        closeBtn.OnEvent("Click", (*) => myGui.Destroy())
        myGui.Show()
        winTitle := "Escape Sequences Demo"
        ; Send literal brackets
        SendLiteral() {
        ; Use Chr() to send literal curly braces
        text := "`n=== Literal Brackets ===`n"
        text .= "Round brackets: (test)`n"
        text .= "Square brackets: [test]`n"
        text .= "Curly brackets: " . Chr(123) . "test" . Chr(125) . "`n"
        text .= "Angle brackets: <test>`n`n"

        ControlSend(text, "Edit1", winTitle)
    }
        ; Send escaped text
        SendEscaped() {
        text := "`n=== Escaped Characters ===`n"
        text .= "Newline: ``n`n"
        text .= "Tab: ``t`n"
        text .= "Backtick: ``` `n"
        text .= "Quote: `"`n"
        text .= "Actual newline follows:`n`n"
        text .= "See? New line!`n`n"

        ControlSend(text, "Edit1", winTitle)
    }
        ; Send raw block
        SendRaw() {
        text := "
        (
        === Raw Text Block ===
        This is a raw block of text.
        It preserves all formatting.
        Including:
        - Indentation
        - Multiple    spaces
        - Empty lines

        And special characters: !@#$%^&*()
        )"

        ControlSend("`n" . text . "`n`n", "Edit1", winTitle)
    }
        MsgBox("Escape sequences demo started!", "Info", "OK Icon! T2")
    }

    ; ============================================================================
    ; Example 5: Multi-Line Text Formatting
    ; ============================================================================

    /**
     * @function Example5_MultiLineFormatting
     * @description Advanced multi-line text formatting
     * Shows complex text structure and alignment
     */
    Example5_MultiLineFormatting() {
        MsgBox("Example 5: Multi-Line Formatting`n`n" .
            "Create complex formatted multi-line text.",
            "Multi-Line Formatting", "OK Icon!")

        ; Create GUI
        myGui := Gui("+AlwaysOnTop", "Multi-Line Formatting Demo")
        myGui.Add("Text", "w550", "Formatted Output:")

        outputEdit := myGui.Add("Edit", "w550 h400 Multi", "")

        myGui.Add("Text", "w550 y+10", "Format Examples:")

        boxBtn := myGui.Add("Button", "w105 y+10", "Box Drawing")
        boxBtn.OnEvent("Click", (*) => SendBox())

        asciiBtn := myGui.Add("Button", "w105 x+10", "ASCII Art")
        asciiBtn.OnEvent("Click", (*) => SendAscii())

        chartBtn := myGui.Add("Button", "w105 x+10", "Bar Chart")
        chartBtn.OnEvent("Click", (*) => SendChart())

        menuBtn := myGui.Add("Button", "w105 x+10", "Menu")
        menuBtn.OnEvent("Click", (*) => SendMenu())

        treeBtn := myGui.Add("Button", "w105 x+10", "Tree View")
        treeBtn.OnEvent("Click", (*) => SendTree())

        clearBtn := myGui.Add("Button", "w270 y+20", "Clear Output")
        clearBtn.OnEvent("Click", (*) => outputEdit.Value := "")

        closeBtn := myGui.Add("Button", "w270 x+10", "Close Demo")
        closeBtn.OnEvent("Click", (*) => myGui.Destroy())

        myGui.Show()

        winTitle := "Multi-Line Formatting Demo"

        ; Box drawing
        SendBox() {
            box := "
        (
        ┌─────────────────────────────────────────┐
        │                                         │
        │        Welcome to the System!           │
        │                                         │
        │  ╔═══════════════════════════════╗     │
        │  ║  Status: Online               ║     │
        │  ║  Users: 42                    ║     │
        │  ║  Uptime: 99.9%                ║     │
        │  ╚═══════════════════════════════╝     │
        │                                         │
        └─────────────────────────────────────────┘

        )"

            ControlSend("`n" . box . "`n", "Edit1", winTitle)
        }

        ; ASCII art
        SendAscii() {
            art := "
        (
        _   _   _ _  __
        /_\ | | | | |/ /
        / _ \| |_| | ' <
        /_/ \_\\___/|_|\_\

        Version 2.0

        ╔═══════════════╗
        ║   WELCOME!    ║
        ╚═══════════════╝

        )"

            ControlSend("`n" . art . "`n", "Edit1", winTitle)
        }

        ; Bar chart
        SendChart() {
            chart := "
        (
        Performance Metrics
        ═══════════════════════════════════════

        Q1: ████████████████░░░░ 80%
        Q2: ██████████████████░░ 90%
        Q3: ██████████░░░░░░░░░░ 50%
        Q4: ████████████████████ 100%

        ═══════════════════════════════════════
        Average: 80%

        )"

            ControlSend("`n" . chart . "`n", "Edit1", winTitle)
        }

        ; Menu
        SendMenu() {
            menu := "
        (
        ╔══════════════════════════════════════╗
        ║         MAIN MENU                    ║
        ╠══════════════════════════════════════╣
        ║                                      ║
        ║  1. New Document          Ctrl+N    ║
        ║  2. Open File             Ctrl+O    ║
        ║  3. Save                  Ctrl+S    ║
        ║  4. Save As...            Ctrl+Shift+S
        ║  ──────────────────────────────────  ║
        ║  5. Print                 Ctrl+P    ║
        ║  6. Print Preview                   ║
        ║  ──────────────────────────────────  ║
        ║  7. Settings              Ctrl+,    ║
        ║  8. Help                  F1        ║
        ║  ──────────────────────────────────  ║
        ║  9. Exit                  Alt+F4    ║
        ║                                      ║
        ╚══════════════════════════════════════╝

        )"

            ControlSend("`n" . menu . "`n", "Edit1", winTitle)
        }

        ; Tree view
        SendTree() {
            tree := "
        (
        Project Structure
        │
        ├── src/
        │   ├── main.ahk
        │   ├── utils/
        │   │   ├── helpers.ahk
        │   │   └── validators.ahk
        │   └── modules/
        │       ├── module1.ahk
        │       └── module2.ahk
        │
        ├── lib/
        │   ├── external.ahk
        │   └── vendor/
        │       └── library.ahk
        │
        ├── tests/
        │   ├── unit/
        │   │   └── test_main.ahk
        │   └── integration/
        │       └── test_flow.ahk
        │
        └── docs/
        ├── README.md
        └── API.md

        )"

            ControlSend("`n" . tree . "`n", "Edit1", winTitle)
        }

        MsgBox("Multi-line formatting demo started!", "Info", "OK Icon! T2")
    }

    ; ============================================================================
    ; Main Menu
    ; ============================================================================

    ShowMainMenu() {
        menuText := "
    (
    ControlSend Examples - Text Entry
    ==================================

    1. Special Characters & Escape Sequences
    2. Unicode & International Characters
    3. Formatted Text Templates
    4. Escape Sequence Handling
    5. Multi-Line Formatting

    Select an example (1-5) or press Esc to exit
    )"

        choice := InputBox(menuText, "ControlSend Text Entry Examples", "w400 h280")

        if (choice.Result = "Cancel")
            return

        switch choice.Value {
            case "1": Example1_SpecialCharacters()
            case "2": Example2_Unicode()
            case "3": Example3_FormattedText()
            case "4": Example4_EscapeSequences()
            case "5": Example5_MultiLineFormatting()
            default:
                MsgBox("Invalid choice! Please select 1-5.", "Error", "OK IconX")
        }

        ; Show menu again
        SetTimer(() => ShowMainMenu(), -500)
    }

    ; Start the demo
    ShowMainMenu()
