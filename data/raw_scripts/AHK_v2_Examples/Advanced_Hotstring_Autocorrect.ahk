#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Advanced Hotstring Example: Auto-Correct and Text Expansion
; Demonstrates: Hotstrings with various options, dynamic replacement

; Common typo corrections (case-insensitive, automatic)
#Hotstring C0 * ?

::teh::the
::adn::and
::waht::what
::recieve::receive
::seperate::separate
::definately::definitely
::occured::occurred
::untill::until
::wich::which
::woudl::would

; Reset hotstring options for next section
#Hotstring C * ?

; Text expansion with formatted output
::@gmail::
{
    SendText("@gmail.com")
}

::@outlook::
{
    SendText("@outlook.com")
}

; Date/time stamps
::ddate::
{
    SendText(FormatTime(, "yyyy-MM-dd"))
}

::ttime::
{
    SendText(FormatTime(, "HH:mm:ss"))
}

::dts::
{
    SendText(FormatTime(, "yyyy-MM-dd HH:mm:ss"))
}

; Code snippets
::ahkif::
{
    SendText("if () {`n`t`n}")
    Send("{Up}{End}{Left 3}")
}

::ahkloop::
{
    SendText("Loop  {`n`t`n}")
    Send("{Up}{Home}{Right 5}")
}

::ahkfunc::
{
    SendText("FunctionName() {`n`t`n`treturn`n}")
    Send("{Up 2}{Home}{Shift Down}{End}{Shift Up}")
}

; Multi-line templates
::signature::
{
    sig := "
    (
    Best regards,
    John Doe
    Software Developer
    Email: john.doe@example.com
    Phone: (555) 123-4567
    )"
    SendText(sig)
}

::disclaimer::
{
    disc := "
    (
    CONFIDENTIAL NOTICE:
    This message contains confidential information and is intended only
    for the individual named. If you are not the named addressee, you
    should not disseminate, distribute or copy this e-mail.
    )"
    SendText(disc)
}

; Smart replacements with clipboard
::lorem::
{
    lorem := "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    SendText(lorem)
}

; Case-sensitive expansions
#Hotstring C

::CEO::Chief Executive Officer
::CFO::Chief Financial Officer
::CTO::Chief Technology Officer
::API::Application Programming Interface
::SQL::Structured Query Language
::HTML::HyperText Markup Language
::CSS::Cascading Style Sheets

; Show help hotkey
^!h::
{
    help := "
    (
    AutoHotkey Text Expansion Help
    ===============================

    Auto-Corrections:
    - teh → the
    - adn → and
    - recieve → receive
    (and many more common typos)

    Email:
    - @gmail → @gmail.com
    - @outlook → @outlook.com

    Date/Time:
    - ddate → Current date (YYYY-MM-DD)
    - ttime → Current time (HH:MM:SS)
    - dts → Date and time stamp

    Code Snippets:
    - ahkif → if statement template
    - ahkloop → loop template
    - ahkfunc → function template

    Templates:
    - signature → Email signature
    - lorem → Lorem ipsum text

    Press Ctrl+Alt+H to see this help again.
    )"

    MsgBox(help, "Hotstring Help")
}
