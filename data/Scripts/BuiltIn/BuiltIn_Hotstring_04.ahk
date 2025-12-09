#Requires AutoHotkey v2.0

/**
* ============================================================================
* Hotstring() Function - Advanced Options
* ============================================================================
*
* Demonstrates all hotstring options and their combinations for precise
* control over text expansion behavior.
*
* Options covered:
* - * (no ending character), ? (trigger inside word)
* - C (case sensitive), C0/C1 (case conforming)
* - B0 (no backspacing), O (omit ending character)
* - SE (SendEvent), SI (SendInput), SP (SendPlay), ST (SendText)
* - T (text mode), R (raw mode), X (execute function)
* - Z (reset to defaults)
*
* @author AutoHotkey v2 Documentation Team
* @version 1.0.0
*/

; ============================================================================
; Example 1: Ending Character Options (* and O)
; ============================================================================

Example1_EndingOptions() {
    ; Standard hotstring - requires ending character (space, tab, enter, etc.)
    Hotstring("::std::", "Standard hotstring (needs ending char)")

    ; * option - triggers immediately without ending character
    Hotstring(":*:imm::", "Immediate expansion")

    ; O option - omits the ending character
    Hotstring(":O:omit::", "Omits ending")

    ; Combining * and O
    Hotstring(":*O:both::", "Immediate + Omit ending")

    MsgBox(
    "Ending Character Options`n`n"
    "std → Standard (needs Space/Enter/Tab)`n"
    "imm → Immediate (*)`n"
    "omit → Omits ending char (O)`n"
    "both → Immediate + Omit (*O)`n`n"
    "Try typing each in a text editor!",
    "Example 1"
    )
}

; ============================================================================
; Example 2: Case Sensitivity Options (C, C0, C1)
; ============================================================================

Example2_CaseOptions() {
    ; C0 = Case insensitive (default)
    Hotstring(":C0:hello::", "Hello! (case insensitive)")

    ; C = Case sensitive
    Hotstring(":C:CAPS::", "ALL CAPITALS")
    Hotstring(":C:caps::", "lowercase version")
    Hotstring(":C:Caps::", "First capital only")

    ; C1 = Case conforming (smart case)
    ; Matches the case pattern of what you type
    Hotstring(":C1:sql::", "Structured Query Language")
    ; SQL → STRUCTURED QUERY LANGUAGE
    ; Sql → Structured Query Language
    ; sql → structured query language

    MsgBox(
    "Case Sensitivity Options`n`n"
    "C0 (default): hello → case insensitive`n`n"
    "C (case sensitive):`n"
    "  CAPS → ALL CAPITALS`n"
    "  caps → lowercase version`n"
    "  Caps → First capital only`n`n"
    "C1 (case conforming):`n"
    "  SQL/Sql/sql → matches your case",
    "Example 2"
    )
}

; ============================================================================
; Example 3: Word Detection Option (?)
; ============================================================================

Example3_WordDetection() {
    ; Default - only triggers at word boundaries
    Hotstring("::test::", "Standard test")

    ; ? option - triggers even inside words
    Hotstring(":?:ing::", "ING")

    ; Practical examples with ?
    Hotstring(":?:addr::", "123 Main Street")
    Hotstring(":?:phone::", "(555) 123-4567")

    ; Without ? - only at word start
    Hotstring("::sig::", "Signature")

    ; With ? - anywhere
    Hotstring(":?:©::", "©")

    MsgBox(
    "Word Detection Option (?)`n`n"
    "Without ?:`n"
    "  test → Only at word start`n"
    "  sig → Only at word start`n`n"
    "With ?:`n"
    "  ing → Works inside words (runing → runING)`n"
    "  © → Works anywhere`n`n"
    "Try: 'testing' vs 'test'",
    "Example 3"
    )
}

; ============================================================================
; Example 4: Backspacing Option (B0)
; ============================================================================

Example4_BackspacingOption() {
    ; Default - backspaces the trigger text
    Hotstring("::brb::", "Be right back")

    ; B0 - doesn't backspace (appends to trigger)
    Hotstring(":B0:append::", " APPENDED")

    ; Practical use: expanding abbreviations while keeping them
    Hotstring(":B0:inc::", " (Incorporated)")
    Hotstring(":B0:ltd::", " (Limited)")

    ; Another example
    Hotstring("::expand::", "Expanded text replaces trigger")
    Hotstring(":B0:expand2::", " Added after trigger")

    MsgBox(
    "Backspacing Option (B0)`n`n"
    "Default (backspaces trigger):`n"
    "  brb → Be right back`n`n"
    "B0 (keeps trigger, appends):`n"
    "  append → append APPENDED`n"
    "  inc → inc (Incorporated)`n"
    "  ltd → ltd (Limited)`n`n"
    "Useful for annotations!",
    "Example 4"
    )
}

; ============================================================================
; Example 5: Send Mode Options (SE, SI, SP, ST)
; ============================================================================

Example5_SendModes() {
    ; SendInput mode (default, fastest and most reliable)
    Hotstring(":SI:sendinput::", "Sent via SendInput (fastest)")

    ; SendEvent mode (slower, compatible with more games/apps)
    Hotstring(":SE:sendevent::", "Sent via SendEvent (compatible)")

    ; SendPlay mode (for games)
    Hotstring(":SP:sendplay::", "Sent via SendPlay (for games)")

    ; SendText mode (sends text literally, no special chars)
    Hotstring(":ST:sendtext::", "Send{Tab}Text{Enter}Literally")

    ; Demonstrating SendText vs SendInput with special chars
    Hotstring("::normalkeys::", "These: {Enter} {Tab} are sent as keys")
    Hotstring(":ST:literalkeys::", "These: {Enter} {Tab} are literal text")

    MsgBox(
    "Send Mode Options`n`n"
    "SI: SendInput (default, fastest)`n"
    "SE: SendEvent (compatible)`n"
    "SP: SendPlay (for games)`n"
    "ST: SendText (literal text)`n`n"
    "Try:`n"
    "  normalkeys → {Enter} sends Enter key`n"
    "  literalkeys → {Enter} as literal text",
    "Example 5"
    )
}

; ============================================================================
; Example 6: Text Mode vs Execute Mode (T, X)
; ============================================================================

Example6_TextVsExecute() {
    ; Text mode (T) - sends replacement as text
    Hotstring(":T:txtmode::", "Simple text replacement")

    ; Execute mode (X) - replacement is code to execute
    Hotstring(":X:execmode::", (*) => SendText("Executed at: " . FormatTime()))

    ; More execute mode examples
    Hotstring(":X:rand100::", (*) => SendText(String(Random(1, 100))))

    Hotstring(":X:timestamp::", (*) {
        SendText(FormatTime(, "yyyy-MM-dd HH:mm:ss"))
    })

    Hotstring(":X:clipboard::", (*) {
        SendText("Clipboard: " . A_Clipboard)
    })

    ; Complex execute example
    Hotstring(":X:calc::", (*) {
        result := InputBox("Enter calculation (e.g., 5+3):", "Calculator")
        if result.Result = "OK" {
            try {
                ; Simple calculation (be careful with user input!)
                value := result.Value
                ; For safety, only allow numbers and basic operators
                if RegExMatch(value, "^[\d\s\+\-\*\/\(\)\.]+$") {
                    calc := value
                    SendText("= " . String(Eval(calc)))
                } else {
                    SendText("[Invalid calculation]")
                }
            } catch {
                SendText("[Error in calculation]")
            }
        }
    })

    ; Simple eval function (limited for safety)
    Eval(expr) {
        ; In real use, implement proper expression parsing
        ; This is just a demonstration
        return expr . " (calculation here)"
    }

    MsgBox(
    "Text vs Execute Mode`n`n"
    "Text mode (T):`n"
    "  txtmode → Static text`n`n"
    "Execute mode (X):`n"
    "  execmode → Dynamic timestamp`n"
    "  rand100 → Random number`n"
    "  timestamp → Current time`n"
    "  clipboard → Clipboard content`n"
    "  calc → Interactive calculator",
    "Example 6"
    )
}

; ============================================================================
; Example 7: Advanced Option Combinations
; ============================================================================

Example7_AdvancedCombinations() {
    ; Multiple options combined for specific behaviors

    ; Case-sensitive, immediate, inside words
    Hotstring(":C*?:CEO::", "Chief Executive Officer")

    ; Case-conforming, no backspace, omit ending
    Hotstring(":C1B0O:sql::", " (Structured Query Language)")

    ; Immediate, text mode, inside words
    Hotstring(":*T?:...::", "…")  ; Ellipsis

    ; Send as text, omit ending, inside words
    Hotstring(":ST?O:->::", "→")

    ; Execute mode, immediate, case-sensitive
    Hotstring(":X*C:NOW::", (*) => SendText(FormatTime(, "HH:mm:ss")))

    ; Complex example: Smart email expander
    Hotstring(":X*:email::", (*) {
        static emailIndex := 0
        emails := ["work@example.com", "personal@example.com", "contact@example.com"]
        emailIndex := Mod(emailIndex, emails.Length) + 1
        SendText(emails[emailIndex])
    })

    ; Smart signature based on time
    Hotstring(":X*:sig::", (*) {
        hour := A_Hour + 0
        if (hour >= 5 && hour < 12)
        greeting := "Good morning,`n"
        else if (hour >= 12 && hour < 17)
        greeting := "Good afternoon,`n"
        else
        greeting := "Good evening,`n"

        SendText(greeting . A_UserName)
    })

    ; Reset example - Z option
    Hotstring(":Z:reset::", "Options reset to default")

    MsgBox(
    "Advanced Option Combinations`n`n"
    "C*?: CEO → Immediate, case-sensitive, inside words`n"
    "C1B0O: sql → Smart case, no backspace, omit end`n"
    "*T?: ... → Immediate ellipsis (…)`n"
    "ST?O: -> → Arrow (→)`n"
    "X*C: NOW → Immediate time (execute)`n`n"
    "Smart examples:`n"
    "  email → Cycles through email addresses`n"
    "  sig → Time-aware signature",
    "Example 7"
    )
}

; ============================================================================
; Example 8: Option Reference and Testing
; ============================================================================

Example8_OptionReference() {
    /**
    * Interactive option tester
    */
    ShowOptionReference() {
        refText := "
        (
        HOTSTRING OPTIONS REFERENCE
        ============================

        Ending & Triggering:
        * = No ending char required (immediate)
        O = Omit ending character from output
        ? = Trigger inside words

        Case Handling:
        C  = Case sensitive
        C0 = Case insensitive (default)
        C1 = Case conforming (smart case)

        Backspacing:
        B0 = Don't backspace trigger text

        Send Modes:
        SI = SendInput (default)
        SE = SendEvent
        SP = SendPlay
        ST = SendText (literal)

        Execution:
        T = Text mode (default)
        X = Execute function

        Other:
        Z = Reset to defaults
        Kn = Key delay (n milliseconds)
        Pn = Priority (n value)
        )"

        MsgBox(refText, "Option Reference")
    }

    /**
    * Creates test hotstrings for each option
    */
    CreateTestHotstrings() {
        ; Test each option individually
        tests := Map(
        "*", ":*:tstar::",
        "O", ":O:tomit::",
        "?", ":?:tquest::",
        "C", ":C:TCASE::",
        "C0", ":C0:tcase0::",
        "C1", ":C1:tcase1::",
        "B0", ":B0:tb0::",
        "ST", ":ST:tst::"
        )

        for option, trigger in tests {
            Hotstring(trigger, "TEST-" . option)
        }

        MsgBox(
        "Test hotstrings created!`n`n"
        "Try these triggers:`n"
        "tstar (no end char)`n"
        "tomit (omit end)`n"
        "tquest (inside word)`n"
        "TCASE (case sensitive)`n"
        "tb0 (no backspace)`n"
        "tst (send text mode)",
        "Test Mode"
        )
    }

    ; Hotkeys for reference
    Hotkey("^!r", (*) => ShowOptionReference())
    Hotkey("^!t", (*) => CreateTestHotstrings())

    ; Show initial reference
    ShowOptionReference()

    MsgBox(
    "Option Reference & Testing`n`n"
    "Ctrl+Alt+R - Show option reference`n"
    "Ctrl+Alt+T - Create test hotstrings`n`n"
    "Use the reference to learn all options!",
    "Example 8"
    )
}

; ============================================================================
; Main Execution
; ============================================================================

ShowExampleMenu() {
    menu := "
    (
    Hotstring Advanced Options
    ===========================

    1. Ending Options (*, O)
    2. Case Options (C, C0, C1)
    3. Word Detection (?)
    4. Backspacing (B0)
    5. Send Modes (SE, SI, SP, ST)
    6. Text vs Execute (T, X)
    7. Advanced Combinations
    8. Option Reference & Testing

    Press Ctrl+Win+[1-8]
    )"

    MsgBox(menu, "Hotstring Options")
}

Hotkey("^#1", (*) => Example1_EndingOptions())
Hotkey("^#2", (*) => Example2_CaseOptions())
Hotkey("^#3", (*) => Example3_WordDetection())
Hotkey("^#4", (*) => Example4_BackspacingOption())
Hotkey("^#5", (*) => Example5_SendModes())
Hotkey("^#6", (*) => Example6_TextVsExecute())
Hotkey("^#7", (*) => Example7_AdvancedCombinations())
Hotkey("^#8", (*) => Example8_OptionReference())

ShowExampleMenu()
