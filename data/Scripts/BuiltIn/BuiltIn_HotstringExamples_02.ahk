#Requires AutoHotkey v2.0

/**
* ============================================================================
* Auto-Correct and Advanced Templates - Intelligent Text Expansion
* ============================================================================
*
* Advanced hotstring systems including intelligent auto-correction, context-aware
* templates, smart formatting, and dynamic content generation.
*
* @author AutoHotkey v2 Documentation Team
* @version 1.0.0
*/

; ============================================================================
; Example 1: Comprehensive Auto-Correct System
; ============================================================================

Example1_AutoCorrect() {
    ; Common typos
    Hotstring("::teh::", "the")
    Hotstring("::nad::", "and")
    Hotstring("::adn::", "and")
    Hotstring("::taht::", "that")
    Hotstring("::thsi::", "this")
    Hotstring("::waht::", "what")
    Hotstring("::woudl::", "would")
    Hotstring("::coudl::", "could")
    Hotstring("::shoudl::", "should")
    Hotstring("::wiht::", "with")
    Hotstring("::recieve::", "receive")
    Hotstring("::acheive::", "achieve")
    Hotstring("::occured::", "occurred")
    Hotstring("::seperate::", "separate")
    Hotstring("::definately::", "definitely")
    Hotstring("::untill::", "until")
    Hotstring("::simmilar::", "similar")

    ; Two words that should be one
    Hotstring("::alot::", "a lot")
    Hotstring("::infact::", "in fact")
    Hotstring("::inspite::", "in spite")
    Hotstring("::eachother::", "each other")
    Hotstring("::neverthless::", "nevertheless")

    ; Capitalization errors
    Hotstring(":C:i::", "I")
    Hotstring(":C:i'm::", "I'm")
    Hotstring(":C:i've::", "I've")
    Hotstring(":C:i'd::", "I'd")
    Hotstring(":C:i'll::", "I'll")

    ; Common abbreviation mistakes
    Hotstring("::cant::", "can't")
    Hotstring("::dont::", "don't")
    Hotstring("::doesnt::", "doesn't")
    Hotstring("::didnt::", "didn't")
    Hotstring("::wont::", "won't")
    Hotstring("::wouldnt::", "wouldn't")
    Hotstring("::shouldnt::", "shouldn't")
    Hotstring("::couldnt::", "couldn't")
    Hotstring("::isnt::", "isn't")
    Hotstring("::arent::", "aren't")
    Hotstring("::wasnt::", "wasn't")
    Hotstring("::werent::", "weren't")
    Hotstring("::hasnt::", "hasn't")
    Hotstring("::havent::", "haven't")
    Hotstring("::hadnt::", "hadn't")

    MsgBox(
    "Comprehensive Auto-Correct Loaded!`n`n"
    "Common typos: teh→the, adn→and, etc.`n"
    "Spacing: alot→a lot, infact→in fact`n"
    "Capitalization: i→I, i'm→I'm`n"
    "Contractions: cant→can't, dont→don't`n`n"
    "Over 30 corrections active!`n`n"
    "Type naturally and let it fix mistakes!",
    "Example 1"
    )
}

; ============================================================================
; Example 2: Smart Punctuation and Typography
; ============================================================================

Example2_SmartPunctuation() {
    ; Smart quotes
    Hotstring(":?*:```::", '"') ; Opening smart quote
    Hotstring(":?*:''::", '"') ; Closing smart quote (two single quotes)

    ; Dashes
    Hotstring("::--::", "—") ; Em dash
    Hotstring("::-.::", "–") ; En dash

    ; Ellipsis
    Hotstring("::...::", "…")

    ; Arrows
    Hotstring("::->::", "→")
    Hotstring("::<-::", "←")
    Hotstring("::<=>::", "↔")
    Hotstring("::=>::", "⇒")

    ; Math and symbols
    Hotstring("::+-::", "±")
    Hotstring("::!=::", "≠")
    Hotstring("::<=::", "≤")
    Hotstring("::>=::", "≥")
    Hotstring("::~~::", "≈")
    Hotstring("::xx::", "×")
    Hotstring("::///::", "÷")
    Hotstring("::deg::", "°")

    ; Fractions
    Hotstring("::1/2::", "½")
    Hotstring("::1/4::", "¼")
    Hotstring("::3/4::", "¾")

    ; Currency
    Hotstring("::eur::", "€")
    Hotstring("::gbp::", "£")
    Hotstring("::yen::", "¥")
    Hotstring("::cent::", "¢")

    ; Copyright and trademark
    Hotstring("::(c)::", "©")
    Hotstring("::(r)::", "®")
    Hotstring("::(tm)::", "™")

    ; Checkmarks and bullets
    Hotstring("::check::", "✓")
    Hotstring("::cross::", "✗")
    Hotstring("::star::", "★")
    Hotstring("::bullet::", "•")

    MsgBox(
    "Smart Punctuation & Typography Loaded!`n`n"
    "Dashes: -- → em dash, -. → en dash`n"
    "Arrows: -> ← => ↔ ⇒`n"
    "Math: ± ≠ ≤ ≥ ≈ × ÷ °`n"
    "Fractions: 1/2 1/4 3/4`n"
    "Currency: eur gbp yen cent`n"
    "Marks: (c) (r) (tm)`n"
    "Symbols: check cross star bullet`n`n"
    "Professional typography made easy!",
    "Example 2"
    )
}

; ============================================================================
; Example 3: Context-Aware Templates
; ============================================================================

Example3_ContextAwareTemplates() {
    /**
    * Smart greeting based on time of day
    */
    Hotstring("::greeting::", (*) {
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
    * Smart date signature
    */
    Hotstring("::dated::", (*) {
        text := "Dated this " . FormatTime(, "d")
        day := A_DD + 0

        ; Add ordinal suffix
        if (day >= 11 && day <= 13)
        suffix := "th"
        else {
            switch Mod(day, 10) {
                case 1: suffix := "st"
                case 2: suffix := "nd"
                case 3: suffix := "rd"
                default: suffix := "th"
            }
        }

        text .= suffix . " day of " . FormatTime(, "MMMM, yyyy")
        SendText(text)
    })

    /**
    * Meeting notes with auto-fill
    */
    Hotstring("::mnotes::", (*) {
        dayName := FormatTime(, "dddd")
        date := FormatTime(, "MMMM d, yyyy")
        time := FormatTime(, "h:mm tt")

        notes := "Meeting Notes - " . dayName . "`n"
        notes .= Repeat("=", 60) . "`n"
        notes .= "Date: " . date . "`n"
        notes .= "Time: " . time . "`n"
        notes .= "Attendees: `n`n"
        notes .= "Agenda:`n1. `n`n"
        notes .= "Discussion:`n`n"
        notes .= "Action Items:`n- [ ] `n`n"
        notes .= "Next Steps:`n"

        SendText(notes)
    })

    /**
    * Project status report
    */
    Hotstring("::pstatus::", (*) {
        weekNum := FormatTime(, "WW")
        date := FormatTime(, "yyyy-MM-dd")

        report := "Project Status Report - Week " . weekNum . "`n"
        report .= Repeat("=", 60) . "`n"
        report .= "Date: " . date . "`n"
        report .= "Reporting Period: [Start] to [End]`n`n"
        report .= "Completed:`n- `n`n"
        report .= "In Progress:`n- `n`n"
        report .= "Blocked:`n- `n`n"
        report .= "Next Week:`n- `n"

        SendText(report)
    })

    Repeat(char, count) {
        result := ""
        Loop count
        result .= char
        return result
    }

    MsgBox(
    "Context-Aware Templates Loaded!`n`n"
    "greeting → Time-based greeting`n"
    "dated → Formal date with ordinals`n"
    "mnotes → Meeting notes (auto-filled)`n"
    "pstatus → Project status report`n`n"
    "Templates adapt to current context!",
    "Example 3"
    )
}

; ============================================================================
; Example 4: Form Fill Accelerators
; ============================================================================

Example4_FormFillAccelerators() {
    ; Common form fields with placeholders
    Hotstring("::fname::", "[First Name]")
    Hotstring("::lname::", "[Last Name]")
    Hotstring("::company::", "[Company Name]")
    Hotstring("::jobtitle::", "[Job Title]")

    ; Address components
    Hotstring("::street::", "[Street Address]")
    Hotstring("::city::", "[City]")
    Hotstring("::state::", "[State]")
    Hotstring("::zip::", "[ZIP Code]")
    Hotstring("::country::", "[Country]")

    ; Contact fields
    Hotstring("::phone::", "[Phone Number]")
    Hotstring("::mobile::", "[Mobile Number]")
    Hotstring("::fax::", "[Fax Number]")
    Hotstring("::email::", "[Email Address]")
    Hotstring("::website::", "[Website URL]")

    ; Account/ID fields
    Hotstring("::accnum::", "[Account Number]")
    Hotstring("::custid::", "[Customer ID]")
    Hotstring("::ordernum::", "[Order Number]")
    Hotstring("::refnum::", "[Reference Number]")

    ; Interactive form filler
    Hotstring("::fillform::", (*) {
        result := InputBox("Enter your full name:", "Form Fill")
        if result.Result != "OK"
        return

        fullName := result.Value
        parts := StrSplit(fullName, " ")

        if parts.Length >= 2 {
            firstName := parts[1]
            lastName := parts[parts.Length]
            SendText("First Name: " . firstName . "`n")
            SendText("Last Name: " . lastName . "`n")
        } else {
            SendText("Name: " . fullName . "`n")
        }
    })

    MsgBox(
    "Form Fill Accelerators Loaded!`n`n"
    "Personal: fname, lname, company, jobtitle`n"
    "Address: street, city, state, zip, country`n"
    "Contact: phone, mobile, fax, email, website`n"
    "Account: accnum, custid, ordernum, refnum`n`n"
    "Interactive: fillform`n`n"
    "Quick placeholders for forms!",
    "Example 4"
    )
}

; ============================================================================
; Example 5: Markdown and Formatting Helpers
; ============================================================================

Example5_MarkdownHelpers() {
    ; Headers
    Hotstring("::h1::", "# ")
    Hotstring("::h2::", "## ")
    Hotstring("::h3::", "### ")
    Hotstring("::h4::", "#### ")

    ; Text formatting
    Hotstring("::bold::", "****") ; User types between **
    Hotstring("::italic::", "__") ; User types between _
    Hotstring("::code::", "``````") ; Inline code

    ; Links and images
    Hotstring("::mdlink::", "[Link Text](URL)")
    Hotstring("::mdimg::", "![Alt Text](image-url)")

    ; Lists
    Hotstring("::ul::", "- ")
    Hotstring("::ol::", "1. ")
    Hotstring("::task::", "- [ ] ")
    Hotstring("::taskdone::", "- [x] ")

    ; Code blocks
    Hotstring("::codeblock::", "```javascript`n`n```")
    Hotstring("::codepy::", "```python`n`n```")
    Hotstring("::codejs::", "```javascript`n`n```")

    ; Tables
    Hotstring("::mdtable::", "
    (
    | Column 1 | Column 2 | Column 3 |
    |----------|----------|----------|
    | Data 1   | Data 2   | Data 3   |
    )")

    ; Horizontal rule
    Hotstring("::hr::", "`n---`n")

    ; Blockquote
    Hotstring("::quote::", "> ")

    ; Footnote
    Hotstring("::footnote::", "[^1]`n`n[^1]: Footnote text")

    MsgBox(
    "Markdown & Formatting Helpers Loaded!`n`n"
    "Headers: h1, h2, h3, h4`n"
    "Format: bold, italic, code`n"
    "Links: mdlink, mdimg`n"
    "Lists: ul, ol, task, taskdone`n"
    "Code: codeblock, codepy, codejs`n"
    "Other: mdtable, hr, quote, footnote`n`n"
    "Markdown made easy!",
    "Example 5"
    )
}

; ============================================================================
; Example 6: Dynamic Content Generators
; ============================================================================

Example6_DynamicContent() {
    /**
    * Generates Lorem Ipsum text
    */
    Hotstring("::lorem::", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")

    Hotstring("::lorem2::", "
    (
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
    )")

    /**
    * Random number generator
    */
    Hotstring("::rand::", (*) => SendText(String(Random(1, 100))))
    Hotstring("::rand1000::", (*) => SendText(String(Random(1, 1000))))

    /**
    * UUID generator
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

    /**
    * Password generator
    */
    Hotstring("::genpass::", (*) {
        chars := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
        password := ""

        Loop 12 {
            pos := Random(1, StrLen(chars))
            password .= SubStr(chars, pos, 1)
        }

        SendText(password)
    })

    /**
    * Line separator
    */
    Hotstring("::sep::", (*) => SendText(Repeat("=", 60)))
    Hotstring("::sep2::", (*) => SendText(Repeat("-", 60)))
    Hotstring("::sep3::", (*) => SendText(Repeat("*", 60)))

    Repeat(char, count) {
        result := ""
        Loop count
        result .= char
        return result
    }

    /**
    * Numbered list generator
    */
    Hotstring("::numlist::", (*) {
        result := InputBox("How many items?", "List Generator")
        if result.Result != "OK"
        return

        count := Integer(result.Value)
        list := ""

        Loop count {
            list .= A_Index . ". `n"
        }

        SendText(list)
    })

    MsgBox(
    "Dynamic Content Generators Loaded!`n`n"
    "Text: lorem, lorem2`n"
    "Random: rand, rand1000`n"
    "IDs: uuid, genpass`n"
    "Separators: sep, sep2, sep3`n"
    "Lists: numlist`n`n"
    "Generate content on the fly!",
    "Example 6"
    )
}

; ============================================================================
; Example 7: Professional Templates Library
; ============================================================================

Example7_ProfessionalTemplates() {
    /**
    * Invoice template
    */
    Hotstring("::invoice::", (*) {
        invoice := "INVOICE`n"
        invoice .= Repeat("=", 60) . "`n`n"
        invoice .= "Invoice #: [NUMBER]`n"
        invoice .= "Date: " . FormatTime(, "MMMM d, yyyy") . "`n"
        invoice .= "Due Date: [DUE DATE]`n`n"
        invoice .= "Bill To:`n[CLIENT NAME]`n[ADDRESS]`n`n"
        invoice .= "Description                 Qty    Rate      Amount`n"
        invoice .= Repeat("-", 60) . "`n"
        invoice .= "`n`n"
        invoice .= "                           Subtotal: $[AMOUNT]`n"
        invoice .= "                                Tax: $[TAX]`n"
        invoice .= "                              Total: $[TOTAL]`n"

        SendText(invoice)
    })

    /**
    * Business letter
    */
    Hotstring("::bizletter::", (*) {
        letter := FormatTime(, "MMMM d, yyyy") . "`n`n"
        letter .= "[Recipient Name]`n"
        letter .= "[Title]`n"
        letter .= "[Company]`n"
        letter .= "[Address]`n`n"
        letter .= "Dear [Name]:`n`n"
        letter .= "[Body]`n`n"
        letter .= "Sincerely,`n`n"
        letter .= "[Your Name]`n"
        letter .= "[Your Title]`n"

        SendText(letter)
    })

    /**
    * Contract template
    */
    Hotstring("::contract::", (*) {
        contract := "SERVICE AGREEMENT`n"
        contract .= Repeat("=", 60) . "`n`n"
        contract .= "This Agreement is entered into on " . FormatTime(, "MMMM d, yyyy")
        contract .= " between:`n`n"
        contract .= "Service Provider: [NAME]`n"
        contract .= "Client: [NAME]`n`n"
        contract .= "1. SERVICES`n[Description]`n`n"
        contract .= "2. COMPENSATION`n[Payment terms]`n`n"
        contract .= "3. TERM`n[Duration]`n`n"
        contract .= "4. TERMINATION`n[Conditions]`n`n"
        contract .= "Signatures:`n`n"
        contract .= "Service Provider: _________________ Date: _______`n`n"
        contract .= "Client: _________________ Date: _______`n"

        SendText(contract)
    })

    /**
    * Press release
    */
    Hotstring("::pressrel::", (*) {
        release := "FOR IMMEDIATE RELEASE`n"
        release .= Repeat("=", 60) . "`n`n"
        release .= "[HEADLINE]`n`n"
        release .= "[City, State] – " . FormatTime(, "MMMM d, yyyy") . " – `n`n"
        release .= "[First paragraph - Who, What, When, Where, Why]`n`n"
        release .= "[Second paragraph - Additional details]`n`n"
        release .= "[Quote from key stakeholder]`n`n"
        release .= "[Closing paragraph - Call to action]`n`n"
        release .= "###`n`n"
        release .= "About [Company]:`n[Boilerplate]`n`n"
        release .= "Contact:`n[Name]`n[Email]`n[Phone]`n"

        SendText(release)
    })

    Repeat(char, count) {
        result := ""
        Loop count
        result .= char
        return result
    }

    MsgBox(
    "Professional Templates Library Loaded!`n`n"
    "invoice → Invoice template`n"
    "bizletter → Business letter`n"
    "contract → Service agreement`n"
    "pressrel → Press release`n`n"
    "Professional documents made easy!",
    "Example 7"
    )
}

; ============================================================================
; Main Execution
; ============================================================================

ShowExampleMenu() {
    menu := "
    (
    Auto-Correct & Advanced Templates
    ==================================

    1. Comprehensive Auto-Correct
    2. Smart Punctuation
    3. Context-Aware Templates
    4. Form Fill Accelerators
    5. Markdown Helpers
    6. Dynamic Content Generators
    7. Professional Templates

    Press Win+F[1-7] to load
    )"

    MsgBox(menu, "Auto-Correct & Templates")
}

Hotkey("#F1", (*) => Example1_AutoCorrect())
Hotkey("#F2", (*) => Example2_SmartPunctuation())
Hotkey("#F3", (*) => Example3_ContextAwareTemplates())
Hotkey("#F4", (*) => Example4_FormFillAccelerators())
Hotkey("#F5", (*) => Example5_MarkdownHelpers())
Hotkey("#F6", (*) => Example6_DynamicContent())
Hotkey("#F7", (*) => Example7_ProfessionalTemplates())

ShowExampleMenu()
