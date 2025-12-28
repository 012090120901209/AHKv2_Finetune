#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Hotstring() Function - Text Replacement Examples
 * ============================================================================
 * 
 * This file demonstrates using the Hotstring() function for automatic text
 * replacement in AutoHotkey v2. Shows how to create dynamic text expanders
 * that improve typing efficiency and accuracy.
 * 
 * Features demonstrated:
 * - Basic text replacement
 * - Dynamic hotstring creation
 * - Case-sensitive/insensitive replacement
 * - Auto-correction functionality
 * - Common typing shortcuts
 * 
 * @author AutoHotkey v2 Documentation Team
 * @version 1.0.0
 * @see https://www.autohotkey.com/docs/v2/lib/Hotstring.htm
 */

; ============================================================================
; Example 1: Basic Text Replacement
; ============================================================================

/**
 * Demonstrates simple text replacement hotstrings that expand
 * abbreviations into full text.
 * 
 * @example
 * ; Type "btw" → "by the way"
 */
Example1_BasicReplacement() {
    ; Create basic replacement hotstrings
    Hotstring("::btw::", "by the way")
    Hotstring("::fyi::", "for your information")
    Hotstring("::asap::", "as soon as possible")
    Hotstring("::afaik::", "as far as I know")
    Hotstring("::imho::", "in my humble opinion")
    Hotstring("::iirc::", "if I recall correctly")

    ; Programming-related
    Hotstring("::func::", "function")
    Hotstring("::ret::", "return")
    Hotstring("::def::", "default")

    MsgBox(
        "Basic Text Replacement Hotstrings Created`n`n"
        "Common abbreviations:`n"
        "  btw → by the way`n"
        "  fyi → for your information`n"
        "  asap → as soon as possible`n"
        "  afaik → as far as I know`n"
        "  imho → in my humble opinion`n"
        "  iirc → if I recall correctly`n`n"
        "Programming:`n"
        "  func → function`n"
        "  ret → return`n"
        "  def → default`n`n"
        "Open a text editor and try typing these!",
        "Example 1: Basic Replacement"
    )
}

; ============================================================================
; Example 2: Dynamic Hotstring Creation
; ============================================================================

/**
 * Shows how to create hotstrings programmatically based on data
 * structures or user input.
 * 
 * @example
 * ; Create multiple hotstrings from a list
 */
Example2_DynamicCreation() {
    ; Define replacement pairs
    replacements := Map(
        "addr", "123 Main Street, City, State 12345",
        "phone", "(555) 123-4567",
        "email", "user@example.com",
        "sig", "Best regards,`n" . A_UserName,
        "lorem", "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    )

    ; Create hotstrings from the map
    for trigger, replacement in replacements {
        Hotstring("::" . trigger . "::", replacement)
    }

    ; Create numbered list hotstrings
    Loop 10 {
        num := A_Index
        Hotstring("::item" . num . "::", num . ". ")
    }

    ; Create date/time hotstrings
    Hotstring("::ddate::", (*) => SendText(FormatTime(, "yyyy-MM-dd")))
    Hotstring("::ttime::", (*) => SendText(FormatTime(, "HH:mm:ss")))
    Hotstring("::now::", (*) => SendText(FormatTime(, "yyyy-MM-dd HH:mm:ss")))

    ; Build info message
    info := "Dynamic Hotstrings Created`n`n"
    info .= "Personal info:`n"
    for trigger, replacement in replacements {
        info .= "  " . trigger . " → " . SubStr(replacement, 1, 30)
        if StrLen(replacement) > 30
            info .= "..."
        info .= "`n"
    }
    info .= "`nNumbered items:`n"
    info .= "  item1 through item10 → 1. through 10.`n"
    info .= "`nDate/Time:`n"
    info .= "  ddate → Current date`n"
    info .= "  ttime → Current time`n"
    info .= "  now → Current date and time"

    MsgBox(info, "Example 2: Dynamic Creation")
}

; ============================================================================
; Example 3: Case-Sensitive Replacement
; ============================================================================

/**
 * Demonstrates case-sensitive hotstrings and smart case handling.
 * 
 * @example
 * ; Different replacements based on capitalization
 */
Example3_CaseSensitive() {
    ; Case-sensitive hotstrings (C option)
    Hotstring(":C:SQL::", "Structured Query Language")
    Hotstring(":C:sql::", "structured query language")
    Hotstring(":C:HTML::", "HyperText Markup Language")
    Hotstring(":C:html::", "hypertext markup language")

    ; Case-conforming hotstrings (smart case)
    Hotstring("::ahk::", "AutoHotkey")
    Hotstring("::Ahk::", "Autohotkey")  ; First letter capitalized
    Hotstring("::AHK::", "AUTOHOTKEY")  ; All caps

    ; Programming language names
    Hotstring(":C:js::", "JavaScript")
    Hotstring(":C:JS::", "JAVASCRIPT")
    Hotstring(":C:py::", "Python")
    Hotstring(":C:PY::", "PYTHON")

    MsgBox(
        "Case-Sensitive Hotstrings Created`n`n"
        "Acronyms (case matters):`n"
        "  SQL → Structured Query Language`n"
        "  sql → structured query language`n"
        "  HTML → HyperText Markup Language`n"
        "  html → hypertext markup language`n`n"
        "Smart case:`n"
        "  ahk → AutoHotkey`n"
        "  Ahk → Autohotkey`n"
        "  AHK → AUTOHOTKEY`n`n"
        "Languages:`n"
        "  js → JavaScript`n"
        "  JS → JAVASCRIPT`n"
        "  py → Python`n"
        "  PY → PYTHON",
        "Example 3: Case-Sensitive"
    )
}

; ============================================================================
; Example 4: Math and Symbols Replacement
; ============================================================================

/**
 * Creates hotstrings for mathematical symbols and special characters.
 * 
 * @example
 * ; Type shortcuts for symbols
 */
Example4_MathSymbols() {
    ; Mathematical symbols
    Hotstring("::alpha::", "α")
    Hotstring("::beta::", "β")
    Hotstring("::gamma::", "γ")
    Hotstring("::delta::", "δ")
    Hotstring("::pi::", "π")
    Hotstring("::sigma::", "σ")
    Hotstring("::theta::", "θ")
    Hotstring("::omega::", "ω")

    ; Math operators and symbols
    Hotstring("::approx::", "≈")
    Hotstring("::neq::", "≠")
    Hotstring("::leq::", "≤")
    Hotstring("::geq::", "≥")
    Hotstring("::inf::", "∞")
    Hotstring("::sum::", "∑")
    Hotstring("::prod::", "∏")
    Hotstring("::int::", "∫")
    Hotstring("::sqrt::", "√")

    ; Arrows
    Hotstring("::rarr::", "→")
    Hotstring("::larr::", "←")
    Hotstring("::uarr::", "↑")
    Hotstring("::darr::", "↓")
    Hotstring("::harr::", "↔")
    Hotstring("::rArr::", "⇒")
    Hotstring("::lArr::", "⇐")

    ; Common symbols
    Hotstring("::deg::", "°")
    Hotstring("::copy::", "©")
    Hotstring("::reg::", "®")
    Hotstring("::tm::", "™")
    Hotstring("::euro::", "€")
    Hotstring("::pound::", "£")
    Hotstring("::yen::", "¥")

    MsgBox(
        "Math and Symbol Hotstrings Created`n`n"
        "Greek letters:`n"
        "  alpha → α, beta → β, gamma → γ, pi → π`n`n"
        "Math operators:`n"
        "  approx → ≈, neq → ≠, leq → ≤, inf → ∞`n"
        "  sum → ∑, sqrt → √, int → ∫`n`n"
        "Arrows:`n"
        "  rarr → →, larr → ←, rArr → ⇒`n`n"
        "Symbols:`n"
        "  deg → °, copy → ©, euro → €, tm → ™",
        "Example 4: Math & Symbols"
    )
}

; ============================================================================
; Example 5: Multi-Line Text Replacement
; ============================================================================

/**
 * Demonstrates replacing abbreviations with multi-line text blocks.
 * 
 * @example
 * ; Expand templates and formatted text
 */
Example5_MultiLine() {
    ; Email templates
    Hotstring("::emailpro::", "
    (
    Dear [Name],

    I hope this email finds you well.

    [Your message here]

    Best regards,
    " . A_UserName . "
    )")

    Hotstring("::emailcas::", "
    (
    Hi [Name],

    [Your message here]

    Thanks,
    " . A_UserName . "
    )")

    ; Code templates
    Hotstring("::functemplate::", "
    (
    /**
    * Function description
    * @param {type} paramName - Description
    * @returns {type} Description
    */
    function functionName(paramName) {
        // Implementation
        return result;
    }
    )")

    Hotstring("::classtemplate::", "
    (
    )")

    ; Document headers
    Hotstring("::header::", "
    (
    " . Repeat("=", 70) . "
    Document Title
    Author: " . A_UserName . "
    Date: " . FormatTime(, "yyyy-MM-dd") . "
    " . Repeat("=", 70) . "
    )")

    Hotstring("::section::", "
    (
    " . Repeat("-", 70) . "
    Section Title
    " . Repeat("-", 70) . "
    )")

    Repeat(char, count) {
        result := ""
        Loop count
            result .= char
        return result
    }

    MsgBox(
        "Multi-Line Hotstrings Created`n`n"
        "Email templates:`n"
        "  emailpro → Professional email template`n"
        "  emailcas → Casual email template`n`n"
        "Code templates:`n"
        "  functemplate → Function template`n"
        "  classtemplate → Class template`n`n"
        "Document formatting:`n"
        "  header → Document header`n"
        "  section → Section header`n`n"
        "Try them in a text editor!",
        "Example 5: Multi-Line"
    )
}

; ============================================================================
; Example 6: Context-Aware Replacement
; ============================================================================

/**
 * Creates hotstrings that use functions to generate context-aware
 * replacement text.
 * 
 * @example
 * ; Smart replacements based on current context
 */
Example6_ContextAware() {
    /**
     * Inserts current date in various formats
     */
    Hotstring("::date1::", (*) => SendText(FormatTime(, "MM/dd/yyyy")))
    Hotstring("::date2::", (*) => SendText(FormatTime(, "yyyy-MM-dd")))
    Hotstring("::date3::", (*) => SendText(FormatTime(, "MMMM d, yyyy")))
    Hotstring("::dateiso::", (*) => SendText(FormatTime(, "yyyy-MM-ddTHH:mm:ss")))

    /**
     * Inserts time in various formats
     */
    Hotstring("::time12::", (*) => SendText(FormatTime(, "h:mm tt")))
    Hotstring("::time24::", (*) => SendText(FormatTime(, "HH:mm")))

    /**
     * Inserts day names
     */
    Hotstring("::today::", (*) => SendText(FormatTime(, "dddd")))
    Hotstring("::month::", (*) => SendText(FormatTime(, "MMMM")))

    /**
     * Inserts greeting based on time of day
     */
    Hotstring("::greet::", (*) {
        hour := A_Hour + 0
        if (hour >= 5 && hour < 12)
            greeting := "Good morning"
        else if (hour >= 12 && hour < 17)
            greeting := "Good afternoon"
        else if (hour >= 17 && hour < 21)
            greeting := "Good evening"
        else
            greeting := "Good night"

        SendText(greeting)
    })

    /**
     * Inserts random number
     */
    Hotstring("::rand::", (*) => SendText(String(Random(1, 100))))

    /**
     * Inserts UUID-like string
     */
    Hotstring("::uuid::", (*) {
        uuid := Format("{:08X}-{:04X}-{:04X}-{:04X}-{:012X}",
            Random(0, 0xFFFFFFFF),
            Random(0, 0xFFFF),
            Random(0, 0xFFFF),
            Random(0, 0xFFFF),
            Random(0, 0xFFFFFFFFFFFF))
        SendText(uuid)
    })

    MsgBox(
        "Context-Aware Hotstrings Created`n`n"
        "Date formats:`n"
        "  date1 → MM/dd/yyyy`n"
        "  date2 → yyyy-MM-dd`n"
        "  date3 → Month day, year`n"
        "  dateiso → ISO 8601 format`n`n"
        "Time formats:`n"
        "  time12 → 12-hour format`n"
        "  time24 → 24-hour format`n`n"
        "Dynamic:`n"
        "  today → Day name`n"
        "  month → Month name`n"
        "  greet → Time-appropriate greeting`n"
        "  rand → Random number`n"
        "  uuid → UUID-like string",
        "Example 6: Context-Aware"
    )
}

; ============================================================================
; Example 7: Hotstring Management System
; ============================================================================

/**
 * Creates a comprehensive system for managing hotstrings with
 * enable/disable functionality.
 * 
 * @example
 * ; Manage groups of hotstrings
 */
Example7_ManagementSystem() {
    ; Hotstring registry
    global hotstringRegistry := Map()

    /**
     * Registers a hotstring with metadata
     */
    RegisterHotstring(trigger, replacement, category := "General") {
        global hotstringRegistry

        ; Create the hotstring
        if Type(replacement) = "Func" {
            Hotstring("::" . trigger . "::", replacement)
        } else {
            Hotstring("::" . trigger . "::", replacement)
        }

        ; Register it
        hotstringRegistry[trigger] := {
            replacement: replacement,
            category: category,
            enabled: true,
            created: A_Now
        }
    }

    /**
     * Lists all registered hotstrings
     */
    ListHotstrings(category := "") {
        global hotstringRegistry

        list := "Registered Hotstrings`n" . Repeat("=", 50) . "`n`n"

        ; Group by category
        categories := Map()

        for trigger, info in hotstringRegistry {
            if category != "" && info.category != category
                continue

            cat := info.category
            if !categories.Has(cat)
                categories[cat] := []

            categories[cat].Push(trigger)
        }

        ; Build list
        for cat, triggers in categories {
            list .= cat . ":`n"
            for trigger in triggers {
                info := hotstringRegistry[trigger]
                status := info.enabled ? "✓" : "✗"
                list .= "  " . status . " " . trigger
                if Type(info.replacement) != "Func" {
                    preview := SubStr(info.replacement, 1, 30)
                    if StrLen(info.replacement) > 30
                        preview .= "..."
                    list .= " → " . preview
                }
                list .= "`n"
            }
            list .= "`n"
        }

        MsgBox(list, "Hotstring Registry")
    }

    /**
     * Enables/disables a hotstring
     */
    ToggleHotstring(trigger) {
        global hotstringRegistry

        if !hotstringRegistry.Has(trigger)
            return false

        info := hotstringRegistry[trigger]
        newState := !info.enabled

        ; Toggle the hotstring
        Hotstring("::" . trigger . "::", newState ? "On" : "Off")
        info.enabled := newState

        MsgBox(
            "Hotstring: " . trigger . "`n"
            "Status: " . (newState ? "ENABLED" : "DISABLED"),
            "Toggle"
        )

        return true
    }

    Repeat(char, count) {
        result := ""
        Loop count
            result .= char
        return result
    }

    ; Register sample hotstrings
    RegisterHotstring("ex1", "Example 1", "Examples")
    RegisterHotstring("ex2", "Example 2", "Examples")
    RegisterHotstring("test1", "Test text 1", "Testing")
    RegisterHotstring("test2", "Test text 2", "Testing")
    RegisterHotstring("greet", "Hello there!", "Greetings")

    ; Create management hotkeys
    Hotkey("^!l", (*) => ListHotstrings())
    Hotkey("^!t", (*) {
        result := InputBox("Enter hotstring trigger to toggle:", "Toggle Hotstring")
        if result.Result = "OK" && result.Value != ""
            ToggleHotstring(result.Value)
    })

    ; Show initial list
    ListHotstrings()

    MsgBox(
        "Hotstring Management System`n`n"
        "Ctrl+Alt+L - List all hotstrings`n"
        "Ctrl+Alt+T - Toggle a hotstring`n`n"
        "Sample hotstrings registered in categories:`n"
        "• Examples (ex1, ex2)`n"
        "• Testing (test1, test2)`n"
        "• Greetings (greet)",
        "Example 7: Management"
    )
}

; ============================================================================
; Main Execution
; ============================================================================

ShowExampleMenu() {
    menu := "
    (
    Hotstring Text Replacement Examples
    ====================================

    Choose an example:

    1. Basic Replacement
    2. Dynamic Creation
    3. Case-Sensitive
    4. Math & Symbols
    5. Multi-Line Templates
    6. Context-Aware
    7. Management System

    Press Ctrl+Shift+Alt+[1-7] to run examples
    )"

    MsgBox(menu, "Examples Menu")
}

; Create example launcher hotkeys
Hotkey("^+!1", (*) => Example1_BasicReplacement())
Hotkey("^+!2", (*) => Example2_DynamicCreation())
Hotkey("^+!3", (*) => Example3_CaseSensitive())
Hotkey("^+!4", (*) => Example4_MathSymbols())
Hotkey("^+!5", (*) => Example5_MultiLine())
Hotkey("^+!6", (*) => Example6_ContextAware())
Hotkey("^+!7", (*) => Example7_ManagementSystem())

ShowExampleMenu()
