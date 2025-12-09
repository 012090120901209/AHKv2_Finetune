#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Prototype Extension - String Methods
*
* Extends String with Reverse, Truncate, Pad, Repeat, IsEmpty methods.
* Provides utility functions for common string operations.
*
* Source: AHK_Notes/Snippets/extending-builtin-objects.md
*/

; Define String prototype extensions
String.Prototype.DefineProp("Reverse", {Call: string_reverse})
String.Prototype.DefineProp("Truncate", {Call: string_truncate})
String.Prototype.DefineProp("PadLeft", {Call: string_pad_left})
String.Prototype.DefineProp("PadRight", {Call: string_pad_right})
String.Prototype.DefineProp("Repeat", {Call: string_repeat})
String.Prototype.DefineProp("IsEmpty", {Call: string_is_empty})

; Test string methods
text := "Hello, World!"

MsgBox("String: '" text "'`n`n"
. "Reverse(): '" text.Reverse() "'`n"
. "Truncate(8): '" text.Truncate(8) "'`n"
. "IsEmpty(): " text.IsEmpty(), , "T5")

MsgBox("Padding Examples:`n`n"
. "'42'.PadLeft(5, '0'): '" "42".PadLeft(5, "0") "'`n"
. "'Hi'.PadRight(5): '" "Hi".PadRight(5) "'`n"
. "'-'.Repeat(10): '" "-".Repeat(10) "'", , "T5")

MsgBox("IsEmpty Tests:`n`n"
. "''.IsEmpty(): " "".IsEmpty() "`n"
. "' '.IsEmpty(): " " ".IsEmpty() "`n"
. "'text'.IsEmpty(): " "text".IsEmpty(), , "T5")

/**
* String.Reverse Implementation
*/
string_reverse(str) {
    reversed := ""
    Loop Parse, str
    reversed := A_LoopField reversed
    return reversed
}

/**
* String.Truncate Implementation
*/
string_truncate(str, maxLength := 10, ellipsis := "...") {
    if (StrLen(str) <= maxLength)
    return str
    return SubStr(str, 1, maxLength) ellipsis
}

/**
* String.PadLeft Implementation
*/
string_pad_left(str, totalWidth, padChar := " ") {
    if (StrLen(str) >= totalWidth)
    return str
    return padChar.Repeat(totalWidth - StrLen(str)) str
}

/**
* String.PadRight Implementation
*/
string_pad_right(str, totalWidth, padChar := " ") {
    if (StrLen(str) >= totalWidth)
    return str
    return str padChar.Repeat(totalWidth - StrLen(str))
}

/**
* String.Repeat Implementation
*/
string_repeat(str, count) {
    result := ""
    Loop count
    result .= str
    return result
}

/**
* String.IsEmpty Implementation
*/
string_is_empty(str) {
    return str = "" || RegExMatch(str, "^\s*$")
}

/*
* Key Concepts:
*
* 1. String Extensions:
*    - Reverse(): Reverse string
*    - Truncate(): Limit length with ellipsis
*    - PadLeft/PadRight(): Add padding
*    - Repeat(): Repeat N times
*    - IsEmpty(): Check for empty/whitespace
*
* 2. Method Chaining:
*    "-".Repeat(10)  ; "----------"
*    "42".PadLeft(5, "0")  ; "00042"
*
* 3. Use Cases:
*    - Formatting output
*    - Text alignment
*    - Input validation
*    - String manipulation
*/
