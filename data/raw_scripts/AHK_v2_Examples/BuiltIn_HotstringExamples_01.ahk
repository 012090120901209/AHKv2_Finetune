#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Text Expander Systems - Practical Hotstring Applications
 * ============================================================================
 *
 * Comprehensive text expansion systems using hotstrings for productivity,
 * including personal information, coding shortcuts, documentation templates,
 * and specialized vocabulary expansions.
 *
 * @author AutoHotkey v2 Documentation Team
 * @version 1.0.0
 */

; ============================================================================
; Example 1: Personal Information Expander
; ============================================================================

Example1_PersonalInfo() {
    ; Contact information
    Hotstring("::myname::", "John Doe")
    Hotstring("::myemail::", "john.doe@example.com")
    Hotstring("::myphone::", "(555) 123-4567")
    Hotstring("::myaddr::", "123 Main Street, Apt 4B`nCity, State 12345")
    Hotstring("::myweb::", "https://www.example.com")
    Hotstring("::mylinkedin::", "https://linkedin.com/in/johndoe")
    Hotstring("::mygithub::", "https://github.com/johndoe")

    ; Professional information
    Hotstring("::mytitle::", "Senior Developer")
    Hotstring("::mycompany::", "Tech Corp Inc.")
    Hotstring("::myoffice::", "Office 305, Building A")

    ; Signatures
    Hotstring("::sig1::", "
    (
    Best regards,
    John Doe
    Senior Developer
    Tech Corp Inc.
    john.doe@example.com
    (555) 123-4567
    )")

    Hotstring("::sig2::", "
    (
    Thanks,
    John Doe
    )")

    Hotstring("::sig3::", "
    (
    Sincerely,

    John Doe
    Senior Developer
    )")

    MsgBox(
        "Personal Information Expander Loaded!`n`n"
        "Contact info:`n"
        "  myname, myemail, myphone, myaddr`n"
        "  myweb, mylinkedin, mygithub`n`n"
        "Professional:`n"
        "  mytitle, mycompany, myoffice`n`n"
        "Signatures:`n"
        "  sig1, sig2, sig3`n`n"
        "Customize with your own info!",
        "Example 1"
    )
}

; ============================================================================
; Example 2: Programming Code Snippets
; ============================================================================

Example2_CodeSnippets() {
    ; JavaScript/TypeScript
    Hotstring("::jsfunc::", "
    (
    function functionName(param) {
        // Implementation
        return result;
    }
    )")

    Hotstring("::jsarrow::", "(param) => {}")

    Hotstring("::jsclass::", "
    (
    class ClassName {
        constructor() {
            // Constructor
        }

        method() {
            // Method
        }
    }
    )")

    Hotstring("::jspromise::", "
    (
    new Promise((resolve, reject) => {
        // Async operation
        resolve(result);
    })
    )")

    Hotstring("::jsasync::", "
    (
    async function asyncFunction() {
        const result = await someAsyncOperation();
        return result;
    }
    )")

    ; Python
    Hotstring("::pydef::", "
    (
    def function_name(param):
        pass
    )")

    Hotstring("::pyclass::", "
    (
    class ClassName:
        def __init__(self):
            pass

        def method(self):
            pass
    )")

    Hotstring("::pytry::", "
    (
    try:
        # Code
        pass
    except Exception as e:
        # Error handling
        pass
    )")

    ; HTML/CSS
    Hotstring("::htmldoc::", "
    (
    <!DOCTYPE html>
    <html lang='en'>
    <head>
        <meta charset='UTF-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
        <title>Document</title>
    </head>
    <body>

    </body>
    </html>
    )")

    Hotstring("::htmldiv::", "<div class=''></div>")
    Hotstring("::htmlspan::", "<span class=''></span>")

    ; Common patterns
    Hotstring("::todo::", "// TODO: ")
    Hotstring("::fixme::", "// FIXME: ")
    Hotstring("::note::", "// NOTE: ")
    Hotstring("::hack::", "// HACK: ")

    ; Console logs
    Hotstring("::clog::", "console.log();")
    Hotstring("::cerr::", "console.error();")
    Hotstring("::cwarn::", "console.warn();")

    MsgBox(
        "Programming Code Snippets Loaded!`n`n"
        "JavaScript: jsfunc, jsarrow, jsclass, jspromise, jsasync`n"
        "Python: pydef, pyclass, pytry`n"
        "HTML: htmldoc, htmldiv, htmlspan`n"
        "Comments: todo, fixme, note, hack`n"
        "Console: clog, cerr, cwarn`n`n"
        "Type in your code editor!",
        "Example 2"
    )
}

; ============================================================================
; Example 3: Documentation Templates
; ============================================================================

Example3_DocTemplates() {
    ; JSDoc function documentation
    Hotstring("::jsdoc::", "
    (
    /**
     * Function description
     * @param {type} paramName - Parameter description
     * @returns {type} Return value description
     */
    )")

    ; JSDoc class documentation
    Hotstring("::jsdocclass::", "
    (
    /**
     * Class description
     * @class
     */
    )")

    ; Python docstring
    Hotstring("::pydoc::", '
    (
    """
    Function description.

    Args:
        param (type): Parameter description

    Returns:
        type: Return value description
    """
    )')

    ; README sections
    Hotstring("::readme::", "
    (
    # Project Name

    ## Description
    Brief project description

    ## Installation
    ```
    installation steps
    ```

    ## Usage
    ```
    usage examples
    ```

    ## Features
    - Feature 1
    - Feature 2

    ## License
    MIT License
    )")

    ; Markdown headers
    Hotstring("::mdh1::", "# ")
    Hotstring("::mdh2::", "## ")
    Hotstring("::mdh3::", "### ")

    ; Code blocks
    Hotstring("::mdcode::", "```javascript`n`n```")
    Hotstring("::mdbash::", "```bash`n`n```")
    Hotstring("::mdpy::", "```python`n`n```")

    MsgBox(
        "Documentation Templates Loaded!`n`n"
        "JSDoc: jsdoc, jsdocclass`n"
        "Python: pydoc`n"
        "README: readme`n"
        "Markdown: mdh1, mdh2, mdh3`n"
        "Code blocks: mdcode, mdbash, mdpy`n`n"
        "Perfect for documentation!",
        "Example 3"
    )
}

; ============================================================================
; Example 4: Email and Communication Templates
; ============================================================================

Example4_EmailTemplates() {
    ; Professional emails
    Hotstring("::emailmeet::", "
    (
    Dear [Name],

    I hope this email finds you well. I would like to schedule a meeting to discuss [topic].

    Would you be available for a call on [date/time]? Please let me know what works best for your schedule.

    Best regards,
    [Your Name]
    )")

    Hotstring("::emailfollow::", "
    (
    Hi [Name],

    Following up on my previous email regarding [topic].

    Please let me know if you have any questions or need additional information.

    Thanks,
    [Your Name]
    )")

    Hotstring("::emailthx::", "
    (
    Dear [Name],

    Thank you for [specific thing]. I really appreciate your [help/time/input].

    Best regards,
    [Your Name]
    )")

    ; Quick responses
    Hotstring("::emailack::", "Thank you for your email. I will review this and get back to you shortly.")
    Hotstring("::emailooo::", "Thank you for your email. I am currently out of office and will respond when I return on [date].")

    ; Meeting-related
    Hotstring("::meetagenda::", "
    (
    Meeting Agenda
    " . Repeat("=", 50) . "
    Date: [Date]
    Time: [Time]
    Attendees: [Names]

    Topics:
    1.
    2.
    3.

    Notes:
    )")

    Hotstring("::meetnotes::", "
    (
    Meeting Notes
    " . Repeat("=", 50) . "
    Date: {DATE}
    Attendees:

    Discussion:
    -

    Action Items:
    - [ ]

    Next Meeting:
    )")

    Repeat(char, count) {
        result := ""
        Loop count
            result .= char
        return result
    }

    MsgBox(
        "Email & Communication Templates Loaded!`n`n"
        "Emails:`n"
        "  emailmeet - Meeting request`n"
        "  emailfollow - Follow-up`n"
        "  emailthx - Thank you`n"
        "  emailack - Acknowledgment`n"
        "  emailooo - Out of office`n`n"
        "Meetings:`n"
        "  meetagenda - Meeting agenda`n"
        "  meetnotes - Meeting notes",
        "Example 4"
    )
}

; ============================================================================
; Example 5: Academic and Research Templates
; ============================================================================

Example5_AcademicTemplates() {
    ; Citation formats
    Hotstring("::citeapa::", "Author, A. A., & Author, B. B. (Year). Title of article. Journal Name, volume(issue), pages.")
    Hotstring("::citemla::", "Author Last Name, First Name. `"Title of Article.`" Journal Name, vol. #, no. #, Year, pp. #-#.")

    ; Research paper sections
    Hotstring("::abstract::", "
    (
    Abstract
    " . Repeat("-", 50) . "

    [Brief summary of research, methods, results, and conclusions]

    Keywords: keyword1, keyword2, keyword3
    )")

    Hotstring("::intro::", "
    (
    1. Introduction
    " . Repeat("-", 50) . "

    [Background and context]

    [Research question/hypothesis]

    [Significance of study]
    )")

    Hotstring("::methods::", "
    (
    2. Methodology
    " . Repeat("-", 50) . "

    2.1 Participants


    2.2 Materials


    2.3 Procedure

    )")

    Hotstring("::results::", "
    (
    3. Results
    " . Repeat("-", 50) . "

    [Present findings]

    [Include tables/figures]
    )")

    Hotstring("::discussion::", "
    (
    4. Discussion
    " . Repeat("-", 50) . "

    [Interpret results]

    [Limitations]

    [Future research]
    )")

    ; Lab report
    Hotstring("::labreport::", "
    (
    Lab Report
    " . Repeat("=", 60) . "

    Title:
    Date:
    Name:

    Objective:


    Materials:
    -

    Procedure:
    1.

    Observations:


    Results:


    Conclusion:

    )")

    Repeat(char, count) {
        result := ""
        Loop count
            result .= char
        return result
    }

    MsgBox(
        "Academic & Research Templates Loaded!`n`n"
        "Citations: citeapa, citemla`n`n"
        "Paper sections:`n"
        "  abstract, intro, methods`n"
        "  results, discussion`n`n"
        "Lab: labreport`n`n"
        "Perfect for students and researchers!",
        "Example 5"
    )
}

; ============================================================================
; Example 6: Date and Time Expanders
; ============================================================================

Example6_DateTimeExpanders() {
    ; ISO dates
    Hotstring("::diso::", (*) => SendText(FormatTime(, "yyyy-MM-dd")))
    Hotstring("::dtime::", (*) => SendText(FormatTime(, "yyyy-MM-dd HH:mm:ss")))

    ; US format
    Hotstring("::dus::", (*) => SendText(FormatTime(, "MM/dd/yyyy")))

    ; European format
    Hotstring("::deu::", (*) => SendText(FormatTime(, "dd/MM/yyyy")))

    ; Long format
    Hotstring("::dlong::", (*) => SendText(FormatTime(, "dddd, MMMM d, yyyy")))

    ; Time formats
    Hotstring("::time12::", (*) => SendText(FormatTime(, "h:mm tt")))
    Hotstring("::time24::", (*) => SendText(FormatTime(, "HH:mm")))
    Hotstring("::timenow::", (*) => SendText(FormatTime(, "HH:mm:ss")))

    ; Relative dates
    Hotstring("::today::", (*) => SendText(FormatTime(, "yyyy-MM-dd")))
    Hotstring("::tomorrow::", (*) {
        tomorrow := DateAdd(A_Now, 1, "Days")
        SendText(FormatTime(tomorrow, "yyyy-MM-dd"))
    })
    Hotstring("::yesterday::", (*) {
        yesterday := DateAdd(A_Now, -1, "Days")
        SendText(FormatTime(yesterday, "yyyy-MM-dd"))
    })

    ; Timestamps
    Hotstring("::stamp::", (*) => SendText("[" . FormatTime(, "yyyy-MM-dd HH:mm") . "]"))
    Hotstring("::stamp2::", (*) => SendText(FormatTime(, "yyyyMMdd-HHmmss")))

    MsgBox(
        "Date & Time Expanders Loaded!`n`n"
        "Dates:`n"
        "  diso → 2024-01-15`n"
        "  dus → 01/15/2024`n"
        "  deu → 15/01/2024`n"
        "  dlong → Monday, January 15, 2024`n`n"
        "Time:`n"
        "  time12 → 3:45 PM`n"
        "  time24 → 15:45`n"
        "  timenow → 15:45:30`n`n"
        "Relative: today, tomorrow, yesterday`n"
        "Stamps: stamp, stamp2",
        "Example 6"
    )
}

; ============================================================================
; Example 7: Specialized Vocabulary Expanders
; ============================================================================

Example7_SpecializedVocab() {
    ; Medical terminology
    Hotstring("::htn::", "hypertension")
    Hotstring("::dm::", "diabetes mellitus")
    Hotstring("::cad::", "coronary artery disease")
    Hotstring("::copd::", "chronic obstructive pulmonary disease")
    Hotstring("::mi::", "myocardial infarction")

    ; Legal terminology
    Hotstring("::plaintiff::", "plaintiff")
    Hotstring("::defendant::", "defendant")
    Hotstring("::tortfeasor::", "tortfeasor")
    Hotstring("::affiant::", "affiant")
    Hotstring("::wherefore::", "WHEREFORE, premises considered,")

    ; Scientific notation
    Hotstring("::h2o::", "H₂O")
    Hotstring("::co2::", "CO₂")
    Hotstring("::o2::", "O₂")
    Hotstring("::nacl::", "NaCl")

    ; Mathematical symbols (from Example 4 of Hotstring_01)
    Hotstring("::alpha::", "α")
    Hotstring("::beta::", "β")
    Hotstring("::pi::", "π")
    Hotstring("::sigma::", "σ")
    Hotstring("::delta::", "Δ")

    ; Technical abbreviations
    Hotstring("::rtos::", "Real-Time Operating System")
    Hotstring("::fifo::", "First In, First Out")
    Hotstring("::lifo::", "Last In, First Out")
    Hotstring("::uart::", "Universal Asynchronous Receiver/Transmitter")

    MsgBox(
        "Specialized Vocabulary Loaded!`n`n"
        "Medical: htn, dm, cad, copd, mi`n"
        "Legal: plaintiff, defendant, etc.`n"
        "Chemistry: h2o, co2, o2, nacl`n"
        "Math: alpha, beta, pi, sigma, delta`n"
        "Technical: rtos, fifo, lifo, uart`n`n"
        "Customize for your field!",
        "Example 7"
    )
}

; ============================================================================
; Main Execution
; ============================================================================

ShowExampleMenu() {
    menu := "
    (
    Text Expander Systems
    =====================

    1. Personal Information
    2. Programming Snippets
    3. Documentation Templates
    4. Email & Communication
    5. Academic & Research
    6. Date & Time Expanders
    7. Specialized Vocabulary

    Press Shift+F[1-7] to load
    )"

    MsgBox(menu, "Text Expanders")
}

Hotkey("+F1", (*) => Example1_PersonalInfo())
Hotkey("+F2", (*) => Example2_CodeSnippets())
Hotkey("+F3", (*) => Example3_DocTemplates())
Hotkey("+F4", (*) => Example4_EmailTemplates())
Hotkey("+F5", (*) => Example5_AcademicTemplates())
Hotkey("+F6", (*) => Example6_DateTimeExpanders())
Hotkey("+F7", (*) => Example7_SpecializedVocab())

ShowExampleMenu()
