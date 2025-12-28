#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Text Wrapping Utility
 * 
 * Demonstrates wrapping selected text in quotes, brackets, or custom
 * symbols for quick formatting and code editing.
 * 
 * Source: xypha/AHK-v2-scripts - Showcase.ahk
 * Inspired by: https://github.com/xypha/AHK-v2-scripts
 */

MsgBox("Text Wrapping Demo`n`n"
    . "Hotkey: Alt+W`n`n"
    . "Select text and press Alt+W to wrap it in:`n"
    . '- "Quotes"`n'
    . "- 'Single quotes'`n"
    . "- (Parentheses)`n"
    . "- [Brackets]`n"
    . "- {Braces}`n"
    . "- <Angle brackets>`n"
    . "- ``Backticks``", , "T5")

; Open Notepad for demo
Run("notepad.exe")
WinWait("ahk_exe notepad.exe", , 3)
WinActivate("ahk_exe notepad.exe")
Sleep(500)

Send("Sample text for wrapping demo")
Send("^a")  ; Select all
MsgBox("Press Alt+W to wrap the selected text!", , "T3")

; Hotkey
!w:: ShowWrapMenu()

/**
 * Show text wrapping menu
 */
ShowWrapMenu() {
    ; Save clipboard
    clipSaved := ClipboardAll()

    ; Get selected text
    A_Clipboard := ""
    Send("^c")
    if (!ClipWait(1)) {
        MsgBox("No text selected", "Text Wrapper", "T2")
        return
    }

    text := A_Clipboard

    ; Create menu with wrap options
    wrapMenu := Menu()
    wrapMenu.Add('"Double quotes"', (*) => WrapText(text, '"', '"'))
    wrapMenu.Add("'Single quotes'", (*) => WrapText(text, "'", "'"))
    wrapMenu.Add("(Parentheses)", (*) => WrapText(text, "(", ")"))
    wrapMenu.Add("[Square brackets]", (*) => WrapText(text, "[", "]"))
    wrapMenu.Add("{Curly braces}", (*) => WrapText(text, "{", "}"))
    wrapMenu.Add("<Angle brackets>", (*) => WrapText(text, "<", ">"))
    wrapMenu.Add("``Backticks``", (*) => WrapText(text, "``", "``"))
    wrapMenu.Add()
    wrapMenu.Add("*Asterisks*", (*) => WrapText(text, "*", "*"))
    wrapMenu.Add("_Underscores_", (*) => WrapText(text, "_", "_"))
    wrapMenu.Add("~Tildes~", (*) => WrapText(text, "~", "~"))
    wrapMenu.Add()
    wrapMenu.Add("Custom...", (*) => WrapCustom(text))

    wrapMenu.Show()

    ; Restore clipboard
    SetTimer(() => A_Clipboard := clipSaved, -500)
}

/**
 * Wrap text with leading and trailing characters
 */
WrapText(text, leadChar, trailChar) {
    result := leadChar text trailChar

    ; Replace selection
    A_Clipboard := result
    Send("^v")

    ; Show notification
    ToolTip("Wrapped with " leadChar "..." trailChar)
    SetTimer(() => ToolTip(), -1000)
}

/**
 * Wrap with custom characters
 */
WrapCustom(text) {
    ; Get custom wrapper
    ib := InputBox("Enter wrapper character(s):`n(e.g. ** for bold, __ for italic)", "Custom Wrapper")
    if (ib.Result == "Cancel")
        return

    wrapper := ib.Value
    if (wrapper == "")
        return

    WrapText(text, wrapper, wrapper)
}

/*
* Key Concepts:
*
* 1. Text Wrapping:
*    leadChar + text + trailChar
*    Common in coding and formatting
*    Quick formatting tool
*
* 2. Symmetric Pairs:
*    Quotes: " "
*    Parentheses: ( )
*    Brackets: [ ] { } < >
*    Backticks: ` `
*
* 3. Asymmetric Symbols:
*    Asterisks: * *
*    Underscores: _ _
*    Markdown formatting
*
* 4. Menu Pattern:
*    Common options in menu
*    Custom option for flexibility
*    One hotkey, many choices
*
* 5. Use Cases:
*    ✅ Code editing (strings, arrays)
*    ✅ Markdown formatting
*    ✅ JSON/XML editing
*    ✅ Mathematical notation
*    ✅ Comments and quotes
*
* 6. Common Wrappers:
*    Code:
*    - "string literals"
*    - (function calls)
*    - [array access]
*    - {object literals}
*
*    Markdown:
*    - *italic*
*    - **bold**
*    - `code`
*    - [link text]
*
* 7. Custom Wrappers:
*    User-defined symbols
*    Language-specific
*    Project conventions
*
* 8. Best Practices:
*    ✅ Preserve clipboard
*    ✅ Check for selection
*    ✅ Show feedback
*    ✅ Common pairs first
*
* 9. Enhancements:
*    - Auto-detect language
*    - Remember recent wrappers
*    - Multi-line support
*    - Escape special chars
*    - Unwrap function
*
* 10. Keyboard Shortcuts:
*     Consider dedicated keys:
*     Alt+' - Single quotes
*     Alt+" - Double quotes
*     Alt+( - Parentheses
*     Alt+[ - Brackets
*
* 11. Related Operations:
*     - Unwrap (remove wrappers)
*     - Change wrapper type
*     - Toggle wrapper
*     - Multi-cursor wrapping
*
* 12. Language-Specific:
*     Python: ', ", '''
*     JavaScript: ', ", `
*     HTML: <>, ""
*     Markdown: *, **, `, []
*/

