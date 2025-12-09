#Requires AutoHotkey v2.0 AutoHotkey v2.0
#SingleInstance Force
; Advanced Hotstring Example: Smart Quotes and Punctuation
; Demonstrates: Context-aware replacements, smart typography

; Smart quotes - convert straight quotes to curly quotes
#Hotstring ? *

; Opening and closing double quotes
::"::
{
    static lastQuote := false

    if (!lastQuote) {
        SendText('"')  ; Opening quote
        lastQuote := true
    } else {
        SendText('"')  ; Closing quote
        lastQuote := false
    }
}

; Opening and closing single quotes
::'::
{
    static lastSingleQuote := false

    if (!lastSingleQuote) {
        SendText("'")  ; Opening quote
        lastSingleQuote := true
    } else {
        SendText("'")  ; Closing quote
        lastSingleQuote := false
    }
}

; Em dash (---)
::---::
{
    Send("{Backspace 3}")
    SendText("—")
}

; En dash (--)
::--::
{
    Send("{Backspace 2}")
    SendText("–")
}

; Ellipsis (...)
::...::
{
    Send("{Backspace 3}")
    SendText("…")
}

; Multiplication sign
::xx::
{
    SendText("×")
}

; Division sign
::/:>::
{
    Send("{Backspace 3}")
    SendText("÷")
}

; Plus-minus
::+/-::
{
    Send("{Backspace 3}")
    SendText("±")
}

; Degrees
::deg::
{
    SendText("°")
}

; Copyright
::(c)::
{
    Send("{Backspace 3}")
    SendText("©")
}

; Registered trademark
::(r)::
{
    Send("{Backspace 3}")
    SendText("®")
}

; Trademark
::(tm)::
{
    Send("{Backspace 4}")
    SendText("™")
}

; Arrows
::->:::
{
    Send("{Backspace 2}")
    SendText("→")
}

::<-:::
{
    Send("{Backspace 2}")
    SendText("←")
}

::<->:::
{
    Send("{Backspace 3}")
    SendText("↔")
}

::=>:::
{
    Send("{Backspace 2}")
    SendText("⇒")
}

; Fractions
::1/2::
{
    Send("{Backspace 3}")
    SendText("½")
}

::1/4::
{
    Send("{Backspace 3}")
    SendText("¼")
}

::3/4::
{
    Send("{Backspace 3}")
    SendText("¾")
}

; Mathematical symbols
::<=:::
{
    Send("{Backspace 2}")
    SendText("≤")
}

::>=:::
{
    Send("{Backspace 2}")
    SendText("≥")
}

::!=:::
{
    Send("{Backspace 2}")
    SendText("≠")
}

::~=:::
{
    Send("{Backspace 2}")
    SendText("≈")
}

::inf::
{
    SendText("∞")
}

; Greek letters (common ones)
::alpha::
{
    SendText("α")
}

::beta::
{
    SendText("β")
}

::gamma::
{
    SendText("γ")
}

::delta::
{
    SendText("δ")
}

::theta::
{
    SendText("θ")
}

::lambda::
{
    SendText("λ")
}

::pi::
{
    SendText("π")
}

::sigma::
{
    SendText("σ")
}

; Currency
::eur::
{
    SendText("€")
}

::gbp::
{
    SendText("£")
}

::yen::
{
    SendText("¥")
}

; Superscripts
::^2::
{
    Send("{Backspace 2}")
    SendText("²")
}

::^3::
{
    Send("{Backspace 2}")
    SendText("³")
}

; Bullets
::*::
{
    SendText("•")
}

; Check mark
::check::
{
    SendText("✓")
}

; Cross mark
::xmark::
{
    SendText("✗")
}

; Common emoticons to emoji
::)::
{
    SendText("🙂")
}

::D::
{
    SendText("😃")
}

:::'(::
{
    SendText("☹")
}

; Reference guide
^!+p::
{
    guide := "
    (
    Smart Typography Reference
    ==========================

    PUNCTUATION:
    " → Curly double quotes
    ' → Curly single quotes
    --- → Em dash (—)
    -- → En dash (–)
    ... → Ellipsis (…)

    SYMBOLS:
    xx → × (multiply)
    /:> → ÷ (divide)
    +/- → ± (plus-minus)
    deg → ° (degrees)
    (c) → © (copyright)
    (r) → ® (registered)
    (tm) → ™ (trademark)

    ARROWS:
    -> → →
    <- → ←
    <-> → ↔
    => → ⇒

    FRACTIONS:
    1/2 → ½
    1/4 → ¼
    3/4 → ¾

    MATH:
    <= → ≤
    >= → ≥
    != → ≠
    ~= → ≈
    inf → ∞

    GREEK:
    alpha, beta, gamma, delta
    theta, lambda, pi, sigma

    CURRENCY:
    eur → €
    gbp → £
    yen → ¥

    Press Ctrl+Alt+Shift+P for this guide.
    )"

    MsgBox(guide, "Typography Guide")
}
