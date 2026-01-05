#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 - A_Clipboard Text Manipulation
 * ============================================================================
 * 
 * This file demonstrates advanced text manipulation operations using
 * A_Clipboard in AutoHotkey v2, focusing on practical text processing tasks.
 * 
 * @file BuiltIn_Clipboard_02.ahk
 * @version 2.0.0
 * @author AHK v2 Examples Collection
 * @date 2024-11-16
 * 
 * TABLE OF CONTENTS:
 * ──────────────────────────────────────────────────────────────────────────
 * 1. Text Formatting Operations
 * 2. Find and Replace in Clipboard
 * 3. Text Extraction and Filtering
 * 4. Line Manipulation
 * 5. Quote and Bracket Handling
 * 6. Code Formatting
 * 7. Advanced Text Processors
 * 
 * EXAMPLES SUMMARY:
 * ──────────────────────────────────────────────────────────────────────────
 * - Formatting text (indentation, wrapping, alignment)
 * - Find and replace operations
 * - Extracting URLs, emails, numbers from text
 * - Sorting, deduplicating, and filtering lines
 * - Adding/removing quotes and brackets
 * - Code beautification and formatting
 * - Building text processing utilities
 * 
 * ============================================================================
 */

; ============================================================================
; Example 1: Text Formatting Operations
; ============================================================================

/**
 * Demonstrates various text formatting operations on clipboard content.
 * 
 * @class TextFormatter
 * @description Provides text formatting utilities for clipboard
 */

class TextFormatter {

    /**
     * Adds indentation to each line
     * @param {String} indentChar - Character to use for indentation
     * @param {Integer} count - Number of indentation characters
     * @returns {void}
     */
    static AddIndentation(indentChar := " ", count := 4) {
        if (A_Clipboard = "")
            return

        indent := ""
        Loop count {
            indent .= indentChar
        }

        lines := StrSplit(A_Clipboard, "`n")
        indentedLines := []

        for line in lines {
            indentedLines.Push(indent . line)
        }

        A_Clipboard := ""
        for line in indentedLines {
            A_Clipboard .= line . "`n"
        }
        A_Clipboard := RTrim(A_Clipboard, "`n")

        TrayTip("Formatted", "Indentation added", "Icon Info")
    }

    /**
     * Removes indentation from each line
     * @param {Integer} count - Number of characters to remove
     * @returns {void}
     */
    static RemoveIndentation(count := 4) {
        if (A_Clipboard = "")
            return

        lines := StrSplit(A_Clipboard, "`n")
        unindentedLines := []

        for line in lines {
            ; Remove leading spaces/tabs
            processed := line
            removed := 0
            Loop count {
                if (SubStr(processed, 1, 1) = " " || SubStr(processed, 1, 1) = "`t") {
                    processed := SubStr(processed, 2)
                    removed++
                } else {
                    break
                }
            }
            unindentedLines.Push(processed)
        }

        A_Clipboard := ""
        for line in unindentedLines {
            A_Clipboard .= line . "`n"
        }
        A_Clipboard := RTrim(A_Clipboard, "`n")

        TrayTip("Formatted", "Indentation removed", "Icon Info")
    }

    /**
     * Wraps text to specified line length
     * @param {Integer} maxLength - Maximum line length
     * @returns {void}
     */
    static WrapText(maxLength := 80) {
        if (A_Clipboard = "")
            return

        words := StrSplit(A_Clipboard, " ")
        wrappedLines := []
        currentLine := ""

        for word in words {
            ; Handle newlines in words
            word := StrReplace(word, "`n", " ")
            word := StrReplace(word, "`r", "")

            testLine := currentLine = "" ? word : currentLine . " " . word

            if (StrLen(testLine) > maxLength && currentLine != "") {
                wrappedLines.Push(currentLine)
                currentLine := word
            } else {
                currentLine := testLine
            }
        }

        if (currentLine != "")
            wrappedLines.Push(currentLine)

        A_Clipboard := ""
        for line in wrappedLines {
            A_Clipboard .= line . "`n"
        }
        A_Clipboard := RTrim(A_Clipboard, "`n")

        TrayTip("Formatted", "Text wrapped to " . maxLength . " characters", "Icon Info")
    }

    /**
     * Centers text within specified width
     * @param {Integer} width - Width to center within
     * @returns {void}
     */
    static CenterText(width := 80) {
        if (A_Clipboard = "")
            return

        lines := StrSplit(A_Clipboard, "`n")
        centeredLines := []

        for line in lines {
            lineLen := StrLen(line)
            if (lineLen < width) {
                padding := (width - lineLen) // 2
                paddedLine := ""
                Loop padding {
                    paddedLine .= " "
                }
                paddedLine .= line
                centeredLines.Push(paddedLine)
            } else {
                centeredLines.Push(line)
            }
        }

        A_Clipboard := ""
        for line in centeredLines {
            A_Clipboard .= line . "`n"
        }
        A_Clipboard := RTrim(A_Clipboard, "`n")

        TrayTip("Formatted", "Text centered", "Icon Info")
    }
}

; Hotkeys for text formatting
^!+i:: TextFormatter.AddIndentation(" ", 4)    ; Add 4 spaces
^!+u:: TextFormatter.RemoveIndentation(4)      ; Remove 4 spaces
^!+w:: TextFormatter.WrapText(80)              ; Wrap at 80 chars
^!+c:: TextFormatter.CenterText(80)            ; Center in 80 chars

; ============================================================================
; Example 2: Find and Replace in Clipboard
; ============================================================================

/**
 * Demonstrates find and replace operations on clipboard content.
 * 
 * @class FindReplace
 * @description Provides find and replace functionality
 */

class FindReplace {

    /**
     * Simple find and replace
     * @param {String} findText - Text to find
     * @param {String} replaceText - Text to replace with
     * @param {Boolean} caseSensitive - Case sensitive search
     * @returns {Integer} Number of replacements made
     */
    static Replace(findText, replaceText, caseSensitive := false) {
        if (A_Clipboard = "" || findText = "")
            return 0

        oldText := A_Clipboard
        A_Clipboard := StrReplace(A_Clipboard, findText, replaceText,
            caseSensitive, &count)

        return count
    }

    /**
     * Replace with regex pattern
     * @param {String} pattern - Regex pattern to find
     * @param {String} replacement - Replacement text
     * @returns {Integer} Number of replacements made
     */
    static ReplaceRegex(pattern, replacement) {
        if (A_Clipboard = "" || pattern = "")
            return 0

        oldText := A_Clipboard
        A_Clipboard := RegExReplace(A_Clipboard, pattern, replacement, &count)

        return count
    }

    /**
     * Shows interactive find and replace dialog
     * @returns {void}
     */
    static ShowDialog() {
        ; Create GUI
        frGui := Gui("+AlwaysOnTop", "Find and Replace")
        frGui.SetFont("s10")

        frGui.Add("Text", "w300", "Find what:")
        findEdit := frGui.Add("Edit", "w300 vFindText")

        frGui.Add("Text", "w300", "Replace with:")
        replaceEdit := frGui.Add("Edit", "w300 vReplaceText")

        caseCB := frGui.Add("Checkbox", "vCaseSensitive", "Case sensitive")
        regexCB := frGui.Add("Checkbox", "vUseRegex", "Use regex")

        btnReplace := frGui.Add("Button", "w100", "Replace All")
        btnReplace.OnEvent("Click", (*) => this.DoReplace(frGui, findEdit, replaceEdit, caseCB, regexCB))

        btnClose := frGui.Add("Button", "x+10 w100", "Close")
        btnClose.OnEvent("Click", (*) => frGui.Destroy())

        frGui.Show()
    }

    /**
     * Performs the replacement operation
     * @private
     */
    static DoReplace(gui, findEdit, replaceEdit, caseCB, regexCB) {
        findText := findEdit.Value
        replaceText := replaceEdit.Value
        caseSensitive := caseCB.Value
        useRegex := regexCB.Value

        if (findText = "") {
            MsgBox("Please enter text to find!", "Error", "Icon Warn")
            return
        }

        count := useRegex
            ? this.ReplaceRegex(findText, replaceText)
            : this.Replace(findText, replaceText, caseSensitive)

        MsgBox("Replaced " . count . " occurrence(s).", "Complete", "Icon Info T3")
        gui.Destroy()
    }
}

; Show find and replace dialog
^h:: FindReplace.ShowDialog()

; ============================================================================
; Example 3: Text Extraction and Filtering
; ============================================================================

/**
 * Demonstrates extracting and filtering specific content from clipboard.
 * 
 * @class TextExtractor
 * @description Extracts specific patterns from clipboard text
 */

class TextExtractor {

    /**
     * Extracts all URLs from clipboard
     * @returns {Array} Array of URLs
     */
    static ExtractURLs() {
        if (A_Clipboard = "")
            return []

        urls := []
        pattern := "i)(https?://[^\s]+)"

        pos := 1
        while (RegExMatch(A_Clipboard, pattern, &match, pos)) {
            urls.Push(match[1])
            pos := match.Pos + match.Len
        }

        return urls
    }

    /**
     * Extracts all email addresses from clipboard
     * @returns {Array} Array of email addresses
     */
    static ExtractEmails() {
        if (A_Clipboard = "")
            return []

        emails := []
        pattern := "i)([a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,})"

        pos := 1
        while (RegExMatch(A_Clipboard, pattern, &match, pos)) {
            emails.Push(match[1])
            pos := match.Pos + match.Len
        }

        return emails
    }

    /**
     * Extracts all numbers from clipboard
     * @returns {Array} Array of numbers
     */
    static ExtractNumbers() {
        if (A_Clipboard = "")
            return []

        numbers := []
        pattern := "(-?\d+\.?\d*)"

        pos := 1
        while (RegExMatch(A_Clipboard, pattern, &match, pos)) {
            numbers.Push(match[1])
            pos := match.Pos + match.Len
        }

        return numbers
    }

    /**
     * Extracts lines matching a pattern
     * @param {String} pattern - Pattern to match
     * @returns {Array} Matching lines
     */
    static ExtractMatchingLines(pattern) {
        if (A_Clipboard = "")
            return []

        lines := StrSplit(A_Clipboard, "`n")
        matches := []

        for line in lines {
            if (RegExMatch(line, pattern))
                matches.Push(line)
        }

        return matches
    }
}

; Extract URLs and show them
^!+e:: {
    urls := TextExtractor.ExtractURLs()

    if (urls.Length = 0) {
        MsgBox("No URLs found in clipboard!", "URL Extractor", "Icon Info")
        return
    }

    result := "Found " . urls.Length . " URL(s):`n`n"
    for url in urls {
        result .= url . "`n"
    }

    A_Clipboard := ""
    for url in urls {
        A_Clipboard .= url . "`n"
    }
    A_Clipboard := RTrim(A_Clipboard, "`n")

    MsgBox(result, "URLs Extracted", "Icon Info")
}

; Extract emails and show them
^!+m:: {
    emails := TextExtractor.ExtractEmails()

    if (emails.Length = 0) {
        MsgBox("No email addresses found in clipboard!", "Email Extractor", "Icon Info")
        return
    }

    result := "Found " . emails.Length . " email(s):`n`n"
    for email in emails {
        result .= email . "`n"
    }

    A_Clipboard := ""
    for email in emails {
        A_Clipboard .= email . "`n"
    }
    A_Clipboard := RTrim(A_Clipboard, "`n")

    MsgBox(result, "Emails Extracted", "Icon Info")
}

; ============================================================================
; Example 4: Line Manipulation
; ============================================================================

/**
 * Demonstrates line-level manipulation of clipboard content.
 * 
 * @class LineProcessor
 * @description Processes clipboard content line by line
 */

class LineProcessor {

    /**
     * Sorts lines alphabetically
     * @param {Boolean} descending - Sort in descending order
     * @returns {void}
     */
    static SortLines(descending := false) {
        if (A_Clipboard = "")
            return

        lines := StrSplit(A_Clipboard, "`n")

        ; Bubble sort
        Loop lines.Length - 1 {
            i := A_Index
            Loop lines.Length - i {
                j := A_Index + i
                if (descending) {
                    if (lines[j - 1] < lines[j]) {
                        temp := lines[j - 1]
                        lines[j - 1] := lines[j]
                        lines[j] := temp
                    }
                } else {
                    if (lines[j - 1] > lines[j]) {
                        temp := lines[j - 1]
                        lines[j - 1] := lines[j]
                        lines[j] := temp
                    }
                }
            }
        }

        A_Clipboard := ""
        for line in lines {
            A_Clipboard .= line . "`n"
        }
        A_Clipboard := RTrim(A_Clipboard, "`n")

        TrayTip("Sorted", "Lines sorted " . (descending ? "descending" : "ascending"), "Icon Info")
    }

    /**
     * Removes duplicate lines
     * @returns {void}
     */
    static RemoveDuplicates() {
        if (A_Clipboard = "")
            return

        lines := StrSplit(A_Clipboard, "`n")
        uniqueLines := Map()

        for line in lines {
            uniqueLines[line] := true
        }

        A_Clipboard := ""
        for line, _ in uniqueLines {
            A_Clipboard .= line . "`n"
        }
        A_Clipboard := RTrim(A_Clipboard, "`n")

        TrayTip("Cleaned", "Duplicate lines removed", "Icon Info")
    }

    /**
     * Removes empty lines
     * @returns {void}
     */
    static RemoveEmptyLines() {
        if (A_Clipboard = "")
            return

        lines := StrSplit(A_Clipboard, "`n")
        nonEmptyLines := []

        for line in lines {
            if (Trim(line) != "")
                nonEmptyLines.Push(line)
        }

        A_Clipboard := ""
        for line in nonEmptyLines {
            A_Clipboard .= line . "`n"
        }
        A_Clipboard := RTrim(A_Clipboard, "`n")

        TrayTip("Cleaned", "Empty lines removed", "Icon Info")
    }

    /**
     * Reverses line order
     * @returns {void}
     */
    static ReverseLines() {
        if (A_Clipboard = "")
            return

        lines := StrSplit(A_Clipboard, "`n")
        reversedLines := []

        Loop lines.Length {
            reversedLines.Push(lines[lines.Length - A_Index + 1])
        }

        A_Clipboard := ""
        for line in reversedLines {
            A_Clipboard .= line . "`n"
        }
        A_Clipboard := RTrim(A_Clipboard, "`n")

        TrayTip("Reversed", "Line order reversed", "Icon Info")
    }

    /**
     * Shuffles lines randomly
     * @returns {void}
     */
    static ShuffleLines() {
        if (A_Clipboard = "")
            return

        lines := StrSplit(A_Clipboard, "`n")

        ; Fisher-Yates shuffle
        Loop lines.Length - 1 {
            i := lines.Length - A_Index + 1
            j := Random(1, i)
            temp := lines[i]
            lines[i] := lines[j]
            lines[j] := temp
        }

        A_Clipboard := ""
        for line in lines {
            A_Clipboard .= line . "`n"
        }
        A_Clipboard := RTrim(A_Clipboard, "`n")

        TrayTip("Shuffled", "Lines shuffled randomly", "Icon Info")
    }
}

; Line manipulation hotkeys
^!+s:: LineProcessor.SortLines(false)          ; Sort ascending
^!+d:: LineProcessor.RemoveDuplicates()        ; Remove duplicates
^!+b:: LineProcessor.RemoveEmptyLines()        ; Remove empty lines
^!+r:: LineProcessor.ReverseLines()            ; Reverse lines
^!+f:: LineProcessor.ShuffleLines()            ; Shuffle lines

; ============================================================================
; Example 5: Quote and Bracket Handling
; ============================================================================

/**
 * Demonstrates adding and removing quotes/brackets from clipboard content.
 * 
 * @class QuoteBracketHandler
 * @description Handles quotes and brackets in clipboard
 */

class QuoteBracketHandler {

    /**
     * Adds quotes to each line
     * @param {String} quoteType - Type of quotes ("double", "single", "backtick")
     * @returns {void}
     */
    static AddQuotes(quoteType := "double") {
        if (A_Clipboard = "")
            return

        quote := ""
        switch quoteType {
            case "double": quote := '"'
            case "single": quote := "'"
            case "backtick": quote := "``"
            default: quote := '"'
        }

        lines := StrSplit(A_Clipboard, "`n")
        quotedLines := []

        for line in lines {
            quotedLines.Push(quote . line . quote)
        }

        A_Clipboard := ""
        for line in quotedLines {
            A_Clipboard .= line . "`n"
        }
        A_Clipboard := RTrim(A_Clipboard, "`n")

        TrayTip("Quoted", "Quotes added to each line", "Icon Info")
    }

    /**
     * Removes quotes from each line
     * @returns {void}
     */
    static RemoveQuotes() {
        if (A_Clipboard = "")
            return

        lines := StrSplit(A_Clipboard, "`n")
        unquotedLines := []

        for line in lines {
            ; Remove leading and trailing quotes
            processed := Trim(line)
            if (SubStr(processed, 1, 1) = '"' && SubStr(processed, -1) = '"')
                processed := SubStr(processed, 2, StrLen(processed) - 2)
            else if (SubStr(processed, 1, 1) = "'" && SubStr(processed, -1) = "'")
                processed := SubStr(processed, 2, StrLen(processed) - 2)
            else if (SubStr(processed, 1, 1) = "``" && SubStr(processed, -1) = "``")
                processed := SubStr(processed, 2, StrLen(processed) - 2)

            unquotedLines.Push(processed)
        }

        A_Clipboard := ""
        for line in unquotedLines {
            A_Clipboard .= line . "`n"
        }
        A_Clipboard := RTrim(A_Clipboard, "`n")

        TrayTip("Unquoted", "Quotes removed from each line", "Icon Info")
    }

    /**
     * Wraps text in brackets
     * @param {String} bracketType - Type of brackets ("square", "curly", "angle", "paren")
     * @returns {void}
     */
    static WrapInBrackets(bracketType := "square") {
        if (A_Clipboard = "")
            return

        openBracket := ""
        closeBracket := ""

        switch bracketType {
            case "square": openBracket := "[", closeBracket := "]"
            case "curly": openBracket := "{", closeBracket := "}"
            case "angle": openBracket := "<", closeBracket := ">"
            case "paren": openBracket := "(", closeBracket := ")"
            default: openBracket := "[", closeBracket := "]"
        }

        A_Clipboard := openBracket . A_Clipboard . closeBracket
        TrayTip("Wrapped", "Text wrapped in brackets", "Icon Info")
    }
}

; Quote and bracket hotkeys
^!q:: QuoteBracketHandler.AddQuotes("double")         ; Add double quotes
^!+q:: QuoteBracketHandler.RemoveQuotes()             ; Remove quotes
^![:: QuoteBracketHandler.WrapInBrackets("square")    ; Wrap in []

; ============================================================================
; Example 6: Code Formatting
; ============================================================================

/**
 * Demonstrates code-specific formatting operations.
 * 
 * @class CodeFormatter
 * @description Formats code snippets in clipboard
 */

class CodeFormatter {

    /**
     * Converts to camelCase
     * @returns {void}
     */
    static ToCamelCase() {
        if (A_Clipboard = "")
            return

        text := Trim(A_Clipboard)
        ; Split by spaces, underscores, hyphens
        parts := StrSplit(RegExReplace(text, "[_\s-]+", " "), " ")

        result := StrLower(parts[1])
        Loop parts.Length - 1 {
            part := parts[A_Index + 1]
            result .= StrUpper(SubStr(part, 1, 1)) . StrLower(SubStr(part, 2))
        }

        A_Clipboard := result
        TrayTip("Formatted", "Converted to camelCase", "Icon Info")
    }

    /**
     * Converts to snake_case
     * @returns {void}
     */
    static ToSnakeCase() {
        if (A_Clipboard = "")
            return

        text := Trim(A_Clipboard)
        ; Replace spaces and hyphens with underscores
        text := StrReplace(text, " ", "_")
        text := StrReplace(text, "-", "_")
        text := StrLower(text)

        ; Handle camelCase
        text := RegExReplace(text, "([a-z])([A-Z])", "$1_$2")
        text := StrLower(text)

        A_Clipboard := text
        TrayTip("Formatted", "Converted to snake_case", "Icon Info")
    }

    /**
     * Converts to kebab-case
     * @returns {void}
     */
    static ToKebabCase() {
        if (A_Clipboard = "")
            return

        text := Trim(A_Clipboard)
        ; Replace spaces and underscores with hyphens
        text := StrReplace(text, " ", "-")
        text := StrReplace(text, "_", "-")
        text := StrLower(text)

        ; Handle camelCase
        text := RegExReplace(text, "([a-z])([A-Z])", "$1-$2")
        text := StrLower(text)

        A_Clipboard := text
        TrayTip("Formatted", "Converted to kebab-case", "Icon Info")
    }
}

; Code formatting hotkeys
^!+1:: CodeFormatter.ToCamelCase()
^!+2:: CodeFormatter.ToSnakeCase()
^!+3:: CodeFormatter.ToKebabCase()

; ============================================================================
; Example 7: Advanced Text Processors
; ============================================================================

/**
 * Advanced text processing utilities combining multiple operations.
 * 
 * @class AdvancedTextProcessor
 * @description Complex text processing operations
 */

class AdvancedTextProcessor {

    /**
     * Creates a CSV from clipboard lines
     * @returns {void}
     */
    static ConvertToCSV() {
        if (A_Clipboard = "")
            return

        lines := StrSplit(A_Clipboard, "`n")
        csvLines := []

        for line in lines {
            ; Escape quotes and wrap in quotes
            processed := StrReplace(line, '"', '""')
            csvLines.Push('"' . processed . '"')
        }

        A_Clipboard := ""
        for line in csvLines {
            A_Clipboard .= line . "`n"
        }
        A_Clipboard := RTrim(A_Clipboard, "`n")

        TrayTip("Converted", "Lines converted to CSV format", "Icon Info")
    }

    /**
     * Creates a markdown list from clipboard lines
     * @param {String} listType - "bullet" or "numbered"
     * @returns {void}
     */
    static ConvertToMarkdownList(listType := "bullet") {
        if (A_Clipboard = "")
            return

        lines := StrSplit(A_Clipboard, "`n")
        mdLines := []

        for index, line in lines {
            trimmedLine := Trim(line)
            if (trimmedLine = "")
                continue

            if (listType = "bullet") {
                mdLines.Push("- " . trimmedLine)
            } else {
                mdLines.Push(index . ". " . trimmedLine)
            }
        }

        A_Clipboard := ""
        for line in mdLines {
            A_Clipboard .= line . "`n"
        }
        A_Clipboard := RTrim(A_Clipboard, "`n")

        TrayTip("Converted", "Converted to markdown list", "Icon Info")
    }
}

; ============================================================================
; HELP AND INFORMATION
; ============================================================================

F12:: {
    helpText := "
    (
    ╔════════════════════════════════════════════════════════════════╗
    ║         CLIPBOARD TEXT MANIPULATION - HOTKEYS                  ║
    ╠════════════════════════════════════════════════════════════════╣
    ║ TEXT FORMATTING:                                               ║
    ║   Ctrl+Alt+Shift+I    Add indentation (4 spaces)               ║
    ║   Ctrl+Alt+Shift+U    Remove indentation                       ║
    ║   Ctrl+Alt+Shift+W    Wrap text at 80 characters               ║
    ║   Ctrl+Alt+Shift+C    Center text                              ║
    ║                                                                ║
    ║ FIND & REPLACE:                                                ║
    ║   Ctrl+H              Show find and replace dialog             ║
    ║                                                                ║
    ║ EXTRACTION:                                                    ║
    ║   Ctrl+Alt+Shift+E    Extract URLs                             ║
    ║   Ctrl+Alt+Shift+M    Extract emails                           ║
    ║                                                                ║
    ║ LINE OPERATIONS:                                               ║
    ║   Ctrl+Alt+Shift+S    Sort lines ascending                     ║
    ║   Ctrl+Alt+Shift+D    Remove duplicate lines                   ║
    ║   Ctrl+Alt+Shift+B    Remove empty lines                       ║
    ║   Ctrl+Alt+Shift+R    Reverse line order                       ║
    ║   Ctrl+Alt+Shift+F    Shuffle lines                            ║
    ║                                                                ║
    ║ QUOTES & BRACKETS:                                             ║
    ║   Ctrl+Alt+Q          Add double quotes to lines               ║
    ║   Ctrl+Alt+Shift+Q    Remove quotes                            ║
    ║   Ctrl+Alt+[          Wrap in square brackets                  ║
    ║                                                                ║
    ║ CODE FORMATTING:                                               ║
    ║   Ctrl+Alt+Shift+1    Convert to camelCase                     ║
    ║   Ctrl+Alt+Shift+2    Convert to snake_case                    ║
    ║   Ctrl+Alt+Shift+3    Convert to kebab-case                    ║
    ║                                                                ║
    ║ F12                   Show this help                           ║
    ╚════════════════════════════════════════════════════════════════╝
    )"

    MsgBox(helpText, "Text Manipulation Help", "Icon Info")
}
