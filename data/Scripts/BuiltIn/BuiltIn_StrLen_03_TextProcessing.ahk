#Requires AutoHotkey v2.0

/**
* BuiltIn_StrLen_03_TextProcessing.ahk
*
* DESCRIPTION:
* Advanced text processing using StrLen() for analysis and manipulation
*
* FEATURES:
* - Text statistics and analysis
* - Word count estimation
* - Reading time calculation
* - Text formatting and alignment
*
* SOURCE:
* AutoHotkey v2 Documentation - StrLen()
*
* KEY V2 FEATURES DEMONSTRATED:
* - StrLen() in complex algorithms
* - Loop Parse for character iteration
* - String formatting with alignment
* - Class-based text analyzers
*
* LEARNING POINTS:
* 1. StrLen() enables sophisticated text analysis
* 2. Combine with parsing for detailed statistics
* 3. Use for formatting and alignment calculations
* 4. Essential for text-based UI elements
*/

; ============================================================
; Example 1: Text Statistics Analyzer
; ============================================================

/**
* Comprehensive text statistics
*/
class TextAnalyzer {
    /**
    * Analyze text and return statistics
    *
    * @param {String} text - Text to analyze
    * @returns {Map} - Statistics
    */
    static Analyze(text) {
        stats := Map()

        ; Basic counts
        stats["totalChars"] := StrLen(text)
        stats["totalCharsNoSpaces"] := StrLen(StrReplace(text, " ", ""))

        ; Count different character types
        letters := 0
        digits := 0
        spaces := 0
        punctuation := 0
        other := 0

        Loop Parse, text {
            char := A_LoopField

            if (char = " ")
            spaces++
            else if (RegExMatch(char, "[A-Za-z]"))
            letters++
            else if (RegExMatch(char, "\d"))
            digits++
            else if (RegExMatch(char, "[.,!?;:'`"-]"))
            punctuation++
            else
            other++
        }

        stats["letters"] := letters
        stats["digits"] := digits
        stats["spaces"] := spaces
        stats["punctuation"] := punctuation
        stats["other"] := other

        ; Estimate word count (approximate)
        stats["words"] := this.EstimateWords(text)

        ; Estimate sentences
        stats["sentences"] := this.EstimateSentences(text)

        return stats
    }

    /**
    * Estimate word count
    */
    static EstimateWords(text) {
        ; Simple estimation: split by spaces
        if (StrLen(text) = 0)
        return 0

        trimmed := Trim(text)
        if (StrLen(trimmed) = 0)
        return 0

        words := StrSplit(trimmed, " ")
        return words.Length
    }

    /**
    * Estimate sentence count
    */
    static EstimateSentences(text) {
        count := 0
        Loop Parse, text {
            if (InStr(".!?", A_LoopField))
            count++
        }
        return count > 0 ? count : 1
    }

    /**
    * Format statistics for display
    */
    static FormatStats(stats) {
        output := "TEXT STATISTICS:`n`n"
        output .= "Total Characters: " stats["totalChars"] "`n"
        output .= "Characters (no spaces): " stats["totalCharsNoSpaces"] "`n"
        output .= "Letters: " stats["letters"] "`n"
        output .= "Digits: " stats["digits"] "`n"
        output .= "Spaces: " stats["spaces"] "`n"
        output .= "Punctuation: " stats["punctuation"] "`n"
        output .= "Other: " stats["other"] "`n"
        output .= "`nEstimated Words: " stats["words"] "`n"
        output .= "Estimated Sentences: " stats["sentences"] "`n"

        ; Calculate reading time (average 200 words per minute)
        readingTime := Ceil(stats["words"] / 200)
        output .= "`nEstimated Reading Time: " readingTime " minute(s)"

        return output
    }
}

; Test text
sampleText := "
(
AutoHotkey is a free, open-source scripting language for Windows that allows users to easily create small to complex scripts for all kinds of tasks such as: form fillers, auto-clicking, macros, etc.

The language is designed for rapid prototyping and development. Version 2.0 brings many improvements including better Unicode support, objects, and modern syntax.
)"

stats := TextAnalyzer.Analyze(sampleText)
MsgBox(TextAnalyzer.FormatStats(stats), "Text Analysis", "Icon!")

; ============================================================
; Example 2: Text Alignment and Padding
; ============================================================

/**
* Pad text to specified width
*
* @param {String} text - Text to pad
* @param {Integer} width - Target width
* @param {String} align - Alignment (left, right, center)
* @param {String} padChar - Padding character
* @returns {String} - Padded text
*/
PadText(text, width, align := "left", padChar := " ") {
    currentLength := StrLen(text)

    if (currentLength >= width)
    return text

    padding := width - currentLength

    if (align = "left") {
        return text . StrRepeat(padChar, padding)
    } else if (align = "right") {
        return StrRepeat(padChar, padding) . text
    } else if (align = "center") {
        leftPad := Floor(padding / 2)
        rightPad := padding - leftPad
        return StrRepeat(padChar, leftPad) . text . StrRepeat(padChar, rightPad)
    }

    return text
}

/**
* Repeat string n times
*/
StrRepeat(str, count) {
    result := ""
    Loop count
    result .= str
    return result
}

; Create aligned table
header1 := PadText("Name", 20, "left")
header2 := PadText("Age", 10, "right")
header3 := PadText("City", 15, "left")

row1 := PadText("John Doe", 20, "left") . PadText("30", 10, "right") . PadText("New York", 15, "left")
row2 := PadText("Jane Smith", 20, "left") . PadText("25", 10, "right") . PadText("Los Angeles", 15, "left")
row3 := PadText("Bob Johnson", 20, "left") . PadText("35", 10, "right") . PadText("Chicago", 15, "left")

separator := StrRepeat("-", 45)

table := header1 . header2 . header3 . "`n"
. separator . "`n"
. row1 . "`n"
. row2 . "`n"
. row3

MsgBox(table, "Aligned Table", "Icon!")

; ============================================================
; Example 3: Progress Bar Generator
; ============================================================

/**
* Create text-based progress bar
*
* @param {Number} percentage - Progress (0-100)
* @param {Integer} width - Bar width in characters
* @returns {String} - Progress bar
*/
CreateProgressBar(percentage, width := 30) {
    percentage := Max(0, Min(100, percentage))  ; Clamp to 0-100

    filledLength := Round((percentage / 100) * width)
    emptyLength := width - filledLength

    bar := "["
    . StrRepeat("█", filledLength)
    . StrRepeat("░", emptyLength)
    . "] "
    . Format("{:.1f}", percentage) "%"

    return bar
}

; Show different progress levels
output := "PROGRESS BARS:`n`n"
output .= "  0%: " CreateProgressBar(0) "`n"
output .= " 25%: " CreateProgressBar(25) "`n"
output .= " 50%: " CreateProgressBar(50) "`n"
output .= " 75%: " CreateProgressBar(75) "`n"
output .= "100%: " CreateProgressBar(100) "`n"
output .= "`nCustom width (50 chars):`n"
output .= " 60%: " CreateProgressBar(60, 50)

MsgBox(output, "Text Progress Bars", "Icon!")

; ============================================================
; Example 4: Column Width Calculator
; ============================================================

/**
* Calculate optimal column widths for data
*
* @param {Array} data - 2D array of data
* @returns {Array} - Array of column widths
*/
CalculateColumnWidths(data) {
    if (data.Length = 0)
    return []

    ; Get number of columns from first row
    columnCount := data[1].Length
    widths := []

    ; Initialize widths
    Loop columnCount
    widths.Push(0)

    ; Find maximum width for each column
    for row in data {
        for colIndex, value in row {
            length := StrLen(String(value))
            if (length > widths[colIndex])
            widths[colIndex] := length
        }
    }

    return widths
}

/**
* Format data as aligned table
*
* @param {Array} data - 2D array
* @returns {String} - Formatted table
*/
FormatTable(data) {
    widths := CalculateColumnWidths(data)
    output := ""

    for rowIndex, row in data {
        line := ""
        for colIndex, value in row {
            line .= PadText(String(value), widths[colIndex] + 2, "left")
        }
        output .= line . "`n"

        ; Add separator after header
        if (rowIndex = 1) {
            totalWidth := 0
            for width in widths
            totalWidth += width + 2
            output .= StrRepeat("-", totalWidth) . "`n"
        }
    }

    return output
}

; Sample data
tableData := [
["Product", "Price", "Qty", "Total"],
["Widget", "10.50", "100", "1050.00"],
["Gadget", "25.99", "50", "1299.50"],
["Tool", "5.25", "200", "1050.00"]
]

MsgBox(FormatTable(tableData), "Auto-Sized Table", "Icon!")

; ============================================================
; Example 5: Text Wrapper
; ============================================================

/**
* Wrap text to specified line width
*
* @param {String} text - Text to wrap
* @param {Integer} lineWidth - Maximum line width
* @returns {String} - Wrapped text
*/
WrapText(text, lineWidth := 60) {
    words := StrSplit(text, " ")
    lines := []
    currentLine := ""

    for word in words {
        testLine := currentLine = "" ? word : currentLine . " " . word

        if (StrLen(testLine) <= lineWidth) {
            currentLine := testLine
        } else {
            if (currentLine != "")
            lines.Push(currentLine)
            currentLine := word
        }
    }

    if (currentLine != "")
    lines.Push(currentLine)

    result := ""
    for line in lines
    result .= line . "`n"

    return RTrim(result, "`n")
}

longText := "This is a very long paragraph that needs to be wrapped to fit within a specified line width. The text will be automatically broken into multiple lines at word boundaries to ensure readability and proper formatting."

MsgBox("Original (single line):`n"
. longText "`n`n"
. "Wrapped to 40 characters:`n"
. WrapText(longText, 40) "`n`n"
. "Wrapped to 30 characters:`n"
. WrapText(longText, 30),
"Text Wrapping", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
ADVANCED STRLEN() APPLICATIONS:

Text Analysis:
• Character counting and classification
• Word/sentence estimation
• Reading time calculation
• Content statistics

Text Formatting:
• Column alignment
• Padding and spacing
• Progress bars
• Table formatting

Text Manipulation:
• Line wrapping
• Truncation
• Width calculation
• Layout planning

Performance Tips:
• Cache StrLen() results when used repeatedly
• Use for loop termination conditions
• Combine with SubStr() for efficient parsing
• Consider Unicode normalization if needed

Real-World Uses:
✓ Report generation
✓ Console output formatting
✓ Data table display
✓ File size formatting
✓ UI text fitting
✓ Log formatting
✓ Export formatting
)"

MsgBox(info, "Advanced StrLen() Reference", "Icon!")
