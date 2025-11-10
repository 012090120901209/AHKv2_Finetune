#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Text Case Converter
 *
 * Demonstrates converting selected text to different cases: lowercase,
 * UPPERCASE, Sentence case, Title Case, and iNVERT cASE.
 *
 * Source: xypha/AHK-v2-scripts - Showcase.ahk
 * Inspired by: https://github.com/xypha/AHK-v2-scripts
 */

; Display instructions
MsgBox("Text Case Converter Demo`n`n"
     . "Hotkey: Alt+C`n`n"
     . "1. Select some text`n"
     . "2. Press Alt+C`n"
     . "3. Choose conversion type`n`n"
     . "Try it in Notepad or any text editor!", , "T5")

; Open Notepad for testing
Run("notepad.exe")
WinWait("ahk_exe notepad.exe", , 3)
WinActivate("ahk_exe notepad.exe")

Sleep(1000)
Send("this is SAMPLE text for TESTING the Case Converter!`nTry selecting THIS text and press Alt+C.")
Sleep(500)
Send("^a")  ; Select all

MsgBox("Text selected! Press Alt+C to see the menu", , "T3")

; Hotkey to show case conversion menu
!c::ShowCaseMenu()

/**
 * Show case conversion menu
 */
ShowCaseMenu() {
    ; Save clipboard
    clipSaved := ClipboardAll()

    ; Copy selected text
    A_Clipboard := ""
    Send("^c")
    if (!ClipWait(1)) {
        MsgBox("No text selected", "Case Converter", "T2")
        return
    }

    text := A_Clipboard

    ; Create menu
    caseMenu := Menu()
    caseMenu.Add("lowercase", (*) => ConvertCase(text, "lower"))
    caseMenu.Add("UPPERCASE", (*) => ConvertCase(text, "upper"))
    caseMenu.Add("Sentence case", (*) => ConvertCase(text, "sentence"))
    caseMenu.Add("Title Case", (*) => ConvertCase(text, "title"))
    caseMenu.Add("iNVERT cASE", (*) => ConvertCase(text, "invert"))

    ; Show menu
    caseMenu.Show()

    ; Restore clipboard after delay
    SetTimer(() => A_Clipboard := clipSaved, -500)
}

/**
 * Convert text case
 */
ConvertCase(text, caseType) {
    result := ""

    switch caseType {
        case "lower":
            result := StrLower(text)

        case "upper":
            result := StrUpper(text)

        case "sentence":
            result := ConvertToSentenceCase(text)

        case "title":
            result := ConvertToTitleCase(text)

        case "invert":
            result := InvertCase(text)
    }

    ; Replace selection with converted text
    A_Clipboard := result
    Send("^v")

    ; Show notification
    ToolTip("Converted to " caseType " case")
    SetTimer(() => ToolTip(), -1500)
}

/**
 * Convert to Sentence case
 * First letter of each sentence is capitalized
 */
ConvertToSentenceCase(text) {
    text := StrLower(text)
    result := ""
    capitalize := true

    Loop Parse, text {
        char := A_LoopField

        if (capitalize && RegExMatch(char, "[a-z]")) {
            result .= StrUpper(char)
            capitalize := false
        } else {
            result .= char
        }

        ; Capitalize after sentence-ending punctuation
        if (InStr(".!?", char))
            capitalize := true
    }

    return result
}

/**
 * Convert to Title Case
 * First letter of each word is capitalized
 */
ConvertToTitleCase(text) {
    ; Words that should stay lowercase (articles, prepositions, conjunctions)
    smallWords := ["a", "an", "and", "as", "at", "but", "by", "for", "in", "of", "on", "or", "the", "to", "with"]

    words := StrSplit(text, " ")
    result := []

    for index, word in words {
        ; Always capitalize first and last word
        if (index == 1 || index == words.Length) {
            result.Push(StrUpper(SubStr(word, 1, 1)) . StrLower(SubStr(word, 2)))
            continue
        }

        ; Check if word should stay lowercase
        wordLower := StrLower(word)
        isSmallWord := false

        for smallWord in smallWords {
            if (wordLower == smallWord) {
                isSmallWord := true
                break
            }
        }

        if (isSmallWord) {
            result.Push(wordLower)
        } else {
            result.Push(StrUpper(SubStr(word, 1, 1)) . StrLower(SubStr(word, 2)))
        }
    }

    return JoinArray(result, " ")
}

/**
 * Invert case (upper <-> lower)
 */
InvertCase(text) {
    result := ""

    Loop Parse, text {
        char := A_LoopField

        if (RegExMatch(char, "[a-z]"))
            result .= StrUpper(char)
        else if (RegExMatch(char, "[A-Z]"))
            result .= StrLower(char)
        else
            result .= char
    }

    return result
}

/**
 * Join array helper
 */
JoinArray(arr, delimiter) {
    result := ""
    for index, value in arr {
        result .= value
        if (index < arr.Length)
            result .= delimiter
    }
    return result
}

/*
 * Key Concepts:
 *
 * 1. Case Types:
 *    lowercase - all letters lowercase
 *    UPPERCASE - all letters uppercase
 *    Sentence case - First letter of sentences
 *    Title Case - First letter of words
 *    iNVERT cASE - Swap upper/lower
 *
 * 2. Selection Processing:
 *    Copy with Ctrl+C
 *    ClipWait() to ensure copied
 *    Process in memory
 *    Paste with Ctrl+V
 *
 * 3. Clipboard Management:
 *    Save: clipSaved := ClipboardAll()
 *    Restore: A_Clipboard := clipSaved
 *    Preserve user's clipboard
 *
 * 4. Sentence Case Algorithm:
 *    Start with lowercase
 *    Capitalize after .!?
 *    Handle spaces properly
 *
 * 5. Title Case Rules:
 *    Always capitalize first/last
 *    Lowercase articles/prepositions
 *    Capitalize other words
 *
 * 6. Invert Case:
 *    RegExMatch for letter detection
 *    Swap case for each letter
 *    Keep non-letters unchanged
 *
 * 7. Use Cases:
 *    ✅ Fix CAPS LOCK text
 *    ✅ Format titles
 *    ✅ Clean pasted text
 *    ✅ Standardize formatting
 *    ✅ Quick corrections
 *
 * 8. Menu Pattern:
 *    Context-sensitive menu
 *    One hotkey, multiple actions
 *    User-friendly interface
 *
 * 9. Best Practices:
 *    ✅ Preserve clipboard
 *    ✅ Check for selection
 *    ✅ Show feedback
 *    ✅ Handle edge cases
 *
 * 10. Enhancements:
 *     - Custom word lists
 *     - Language-specific rules
 *     - Preserve formatting
 *     - Undo functionality
 *     - Preview before apply
 *
 * 11. Common Applications:
 *     Email formatting
 *     Document editing
 *     Code comments
 *     Social media posts
 *     Translation cleanup
 *
 * 12. Performance:
 *     Fast for normal text (<10KB)
 *     Character-by-character for invert
 *     Word-by-word for title case
 */
