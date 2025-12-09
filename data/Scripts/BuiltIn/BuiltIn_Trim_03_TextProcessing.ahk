#Requires AutoHotkey v2.0

/**
* BuiltIn_Trim_03_TextProcessing.ahk
*
* DESCRIPTION:
* Advanced text processing using Trim functions for prefixes, suffixes, and formatting
*
* FEATURES:
* - Remove prefixes and suffixes
* - Clean formatted text (markdown, HTML)
* - Normalize text spacing and indentation
* - Process code and documentation
* - Remove decorative elements
* - Strip file extensions and paths
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/Trim.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - Trim() with multiple character sets
* - Advanced string manipulation
* - Text normalization techniques
* - Pattern-based cleaning
* - Custom text processors
*
* LEARNING POINTS:
* 1. Trim can remove specific prefixes and suffixes
* 2. Useful for cleaning formatted text
* 3. Essential for text normalization
* 4. Can process code and documentation
* 5. Combine with other string functions for powerful cleaning
* 6. Important for text parsing and extraction
*/

; ============================================================
; Example 1: Remove Common Prefixes and Suffixes
; ============================================================

/**
* Remove common text prefixes and suffixes
*/

/**
* Remove prefix from string
*
* @param {String} text - Input text
* @param {String} prefix - Prefix to remove
* @returns {String} - Text without prefix
*/
RemovePrefix(text, prefix) {
    if (SubStr(text, 1, StrLen(prefix)) = prefix)
    return SubStr(text, StrLen(prefix) + 1)
    return text
}

/**
* Remove suffix from string
*
* @param {String} text - Input text
* @param {String} suffix - Suffix to remove
* @returns {String} - Text without suffix
*/
RemoveSuffix(text, suffix) {
    suffixLen := StrLen(suffix)
    if (SubStr(text, -suffixLen + 1) = suffix)
    return SubStr(text, 1, StrLen(text) - suffixLen)
    return text
}

; Test data
testStrings := [
{
    text: "Re: Meeting tomorrow", prefix: "Re: ", suffix: ""},
    {
        text: "FW: Important message", prefix: "FW: ", suffix: ""},
        {
            text: "filename.txt", prefix: "", suffix: ".txt"},
            {
                text: "backup_data.bak", prefix: "backup_", suffix: ".bak"},
                {
                    text: "[URGENT] Please respond", prefix: "[URGENT] ", suffix: ""
                }
                ]

                output := "PREFIX & SUFFIX REMOVAL:`n`n"
                for item in testStrings {
                    result := item.text

                    if (item.prefix != "")
                    result := RemovePrefix(result, item.prefix)

                    if (item.suffix != "")
                    result := RemoveSuffix(result, item.suffix)

                    output .= "Original: '" item.text "'`n"
                    output .= "Cleaned: '" result "'`n`n"
                }

                MsgBox(output, "Prefix/Suffix Removal", "Icon!")

                ; ============================================================
                ; Example 2: Clean Markdown Formatting
                ; ============================================================

                /**
                * Remove markdown formatting from text
                */

                /**
                * Clean markdown formatting characters
                *
                * @param {String} text - Markdown text
                * @returns {String} - Plain text
                */
                CleanMarkdown(text) {
                    ; Trim whitespace
                    text := Trim(text)

                    ; Remove heading markers
                    text := LTrim(text, "#")
                    text := Trim(text)

                    ; Remove bold/italic markers
                    text := Trim(text, "*_")

                    ; Remove list markers
                    text := LTrim(text, "-+")
                    text := Trim(text)

                    ; Remove quote markers
                    text := LTrim(text, ">")
                    text := Trim(text)

                    ; Remove code markers
                    text := Trim(text, "`")

                    return text
                }

                ; Test markdown strings
                markdownStrings := [
                "# Heading 1",
                "## Heading 2",
                "**Bold text**",
                "*Italic text*",
                "_Underlined_",
                "- List item",
                "+ Another item",
                "> Quoted text",
                "`code snippet`",
                "***Very important***"
                ]

                output := "MARKDOWN CLEANING:`n`n"
                for md in markdownStrings {
                    cleaned := CleanMarkdown(md)
                    output .= "Markdown: '" md "'`n"
                    output .= "Plain: '" cleaned "'`n`n"
                }

                MsgBox(output, "Markdown Cleaning", "Icon!")

                ; ============================================================
                ; Example 3: Normalize Code Indentation
                ; ============================================================

                /**
                * Normalize and clean code indentation
                */

                /**
                * Remove common indentation from code block
                *
                * @param {String} code - Code block
                * @returns {String} - Normalized code
                */
                NormalizeIndentation(code) {
                    lines := StrSplit(code, "`n")

                    ; Find minimum indentation (excluding empty lines)
                    minIndent := 999
                    for line in lines {
                        if (Trim(line) = "")  ; Skip empty lines
                        continue

                        ; Count leading spaces/tabs
                        indent := 0
                        Loop Parse, line {
                            if (A_LoopField = " " || A_LoopField = "`t")
                            indent++
                            else
                            break
                        }

                        if (indent < minIndent)
                        minIndent := indent
                    }

                    ; Remove common indentation
                    normalized := []
                    for line in lines {
                        if (Trim(line) = "") {
                            normalized.Push("")
                            continue
                        }

                        ; Remove minIndent characters
                        cleaned := SubStr(line, minIndent + 1)
                        normalized.Push(cleaned)
                    }

                    return JoinArray(normalized, "`n")
                }

                /**
                * Join array with delimiter
                */
                JoinArray(arr, delimiter := "") {
                    result := ""
                    for index, value in arr {
                        result .= value
                        if (index < arr.Length)
                        result .= delimiter
                    }
                    return result
                }

                ; Sample indented code
                indentedCode := "
                (
                if (condition) {
                    DoSomething()
                    DoMore()
                }
                )"

                normalized := NormalizeIndentation(indentedCode)

                MsgBox("INDENTATION NORMALIZATION:`n`n"
                . "Original (indented):`n"
                . indentedCode "`n`n"
                . "Normalized:`n"
                . normalized,
                "Code Normalization", "Icon!")

                ; ============================================================
                ; Example 4: Clean File Paths and Extensions
                ; ============================================================

                /**
                * Extract filename components and clean paths
                */

                /**
                * Get filename without extension
                */
                GetFilenameWithoutExt(path) {
                    ; Get filename from path
                    lastSlash := InStr(path, "\", , -1)
                    if (!lastSlash)
                    lastSlash := InStr(path, "/", , -1)

                    filename := (lastSlash) ? SubStr(path, lastSlash + 1) : path

                    ; Remove extension
                    lastDot := InStr(filename, ".", , -1)
                    if (lastDot > 0)
                    filename := SubStr(filename, 1, lastDot - 1)

                    return Trim(filename)
                }

                /**
                * Get file extension
                */
                GetFileExtension(path) {
                    lastDot := InStr(path, ".", , -1)
                    if (!lastDot)
                    return ""

                    ext := SubStr(path, lastDot + 1)
                    return Trim(ext)
                }

                /**
                * Get directory from path
                */
                GetDirectory(path) {
                    lastSlash := InStr(path, "\", , -1)
                    if (!lastSlash)
                    lastSlash := InStr(path, "/", , -1)

                    if (!lastSlash)
                    return ""

                    dir := SubStr(path, 1, lastSlash - 1)
                    return Trim(dir)
                }

                ; Test file paths
                testPaths := [
                "C:\Users\Documents\report.pdf",
                "D:\Projects\Code\script.ahk",
                "/home/user/data.csv",
                "simple_file.txt",
                "no_extension",
                "archive.tar.gz"
                ]

                output := "FILE PATH PROCESSING:`n`n"
                for path in testPaths {
                    filename := GetFilenameWithoutExt(path)
                    ext := GetFileExtension(path)
                    dir := GetDirectory(path)

                    output .= "Path: " path "`n"
                    output .= "  Directory: '" dir "'`n"
                    output .= "  Filename: '" filename "'`n"
                    output .= "  Extension: '" ext "'`n`n"
                }

                MsgBox(output, "Path Processing", "Icon!")

                ; ============================================================
                ; Example 5: Remove Decorative Text Elements
                ; ============================================================

                /**
                * Remove decorative borders and frames from text
                */

                /**
                * Clean text with decorative borders
                */
                CleanDecorativeText(text) {
                    ; Characters commonly used for decoration
                    decorChars := "═─│┌┐└┘├┤┬┴┼╔╗╚╝╠╣╦╩╬*#=+-_|"

                    ; Trim these characters
                    cleaned := Trim(text, decorChars . " `t")

                    return cleaned
                }

                /**
                * Extract content from boxed text
                */
                ExtractBoxedContent(boxedText) {
                    lines := StrSplit(boxedText, "`n")
                    content := []

                    for line in lines {
                        ; Skip completely decorative lines
                        cleaned := CleanDecorativeText(line)

                        if (cleaned != "")
                        content.Push(cleaned)
                    }

                    return JoinArray(content, "`n")
                }

                ; Sample decorated text
                decoratedText := "
                (
                ═══════════════════════════════
                │  Important Message           │
                │  Please read carefully        │
                ═══════════════════════════════
                )"

                boxedText := "
                (
                ┌─────────────────────────┐
                │ Title: System Alert     │
                │ Status: Warning         │
                │ Action: Review logs     │
                └─────────────────────────┘
                )"

                cleanedDecorated := ExtractBoxedContent(decoratedText)
                cleanedBoxed := ExtractBoxedContent(boxedText)

                MsgBox("DECORATIVE TEXT CLEANING:`n`n"
                . "Decorated Text:`n"
                . decoratedText "`n`n"
                . "Cleaned:`n"
                . cleanedDecorated "`n`n"
                . "Boxed Text:`n"
                . boxedText "`n`n"
                . "Cleaned:`n"
                . cleanedBoxed,
                "Decorative Text", "Icon!")

                ; ============================================================
                ; Example 6: Clean HTML Tags (Basic)
                ; ============================================================

                /**
                * Remove HTML tags from text (basic cleaning)
                */

                /**
                * Strip HTML tags
                *
                * @param {String} html - HTML text
                * @returns {String} - Plain text
                */
                StripHTMLTags(html) {
                    ; Remove tags using simple pattern
                    result := html

                    ; Remove tags
                    while (InStr(result, "<")) {
                        startPos := InStr(result, "<")
                        endPos := InStr(result, ">", , startPos)

                        if (!endPos)
                        break

                        ; Remove the tag
                        before := SubStr(result, 1, startPos - 1)
                        after := SubStr(result, endPos + 1)
                        result := before . after
                    }

                    ; Trim and normalize
                    result := Trim(result)

                    ; Normalize spaces
                    while InStr(result, "  ")
                    result := StrReplace(result, "  ", " ")

                    return result
                }

                /**
                * Decode common HTML entities
                */
                DecodeHTMLEntities(text) {
                    entities := Map(
                    "&nbsp;", " ",
                    "&lt;", "<",
                    "&gt;", ">",
                    "&amp;", "&",
                    "&quot;", '"',
                    "&#39;", "'"
                    )

                    for entity, char in entities {
                        text := StrReplace(text, entity)
                    }

                    return text
                }

                ; Test HTML strings
                htmlStrings := [
                "<p>This is a paragraph</p>",
                "<strong>Bold text</strong>",
                "<a href='link.html'>Click here</a>",
                "<div class='container'>Content</div>",
                "Text with &nbsp; entities &amp; symbols",
                "<h1>Heading</h1><p>Paragraph</p>"
                ]

                output := "HTML TAG REMOVAL:`n`n"
                for html in htmlStrings {
                    stripped := StripHTMLTags(html)
                    decoded := DecodeHTMLEntities(stripped)

                    output .= "HTML: " html "`n"
                    output .= "Stripped: '" stripped "'`n"
                    output .= "Decoded: '" decoded "'`n`n"
                }

                MsgBox(output, "HTML Cleaning", "Icon!")

                ; ============================================================
                ; Example 7: Advanced Text Processing System
                ; ============================================================

                /**
                * Comprehensive text processing class
                */
                class TextProcessor {
                    /**
                    * Remove all specified characters from string ends
                    */
                    static TrimChars(text, chars) {
                        return Trim(text, chars)
                    }

                    /**
                    * Remove specific prefix (case-sensitive)
                    */
                    static RemovePrefix(text, prefix) {
                        if (SubStr(text, 1, StrLen(prefix)) = prefix)
                        return SubStr(text, StrLen(prefix) + 1)
                        return text
                    }

                    /**
                    * Remove specific suffix (case-sensitive)
                    */
                    static RemoveSuffix(text, suffix) {
                        suffixLen := StrLen(suffix)
                        if (SubStr(text, -suffixLen + 1) = suffix)
                        return SubStr(text, 1, StrLen(text) - suffixLen)
                        return text
                    }

                    /**
                    * Remove multiple prefixes (first match)
                    */
                    static RemovePrefixes(text, prefixes) {
                        for prefix in prefixes {
                            if (SubStr(text, 1, StrLen(prefix)) = prefix)
                            return SubStr(text, StrLen(prefix) + 1)
                        }
                        return text
                    }

                    /**
                    * Remove multiple suffixes (first match)
                    */
                    static RemoveSuffixes(text, suffixes) {
                        for suffix in suffixes {
                            suffixLen := StrLen(suffix)
                            if (SubStr(text, -suffixLen + 1) = suffix)
                            return SubStr(text, 1, StrLen(text) - suffixLen)
                        }
                        return text
                    }

                    /**
                    * Normalize whitespace (trim ends, collapse internal)
                    */
                    static NormalizeWhitespace(text) {
                        text := Trim(text)
                        while InStr(text, "  ")
                        text := StrReplace(text, "  ", " ")
                        return text
                    }

                    /**
                    * Clean formatted text (remove common formatting)
                    */
                    static CleanFormatted(text) {
                        ; Remove common formatting chars
                        text := Trim(text, "*_#-+=~`|")
                        text := this.NormalizeWhitespace(text)
                        return text
                    }

                    /**
                    * Extract content between delimiters
                    */
                    static ExtractBetween(text, startDelim, endDelim) {
                        startPos := InStr(text, startDelim)
                        if (!startPos)
                        return ""

                        startPos += StrLen(startDelim)
                        endPos := InStr(text, endDelim, , startPos)
                        if (!endPos)
                        return ""

                        content := SubStr(text, startPos, endPos - startPos)
                        return Trim(content)
                    }

                    /**
                    * Remove all occurrences of pattern
                    */
                    static RemoveAll(text, pattern) {
                        return StrReplace(text, pattern, "")
                    }

                    /**
                    * Clean email subject line
                    */
                    static CleanEmailSubject(subject) {
                        ; Remove common prefixes
                        prefixes := ["Re: ", "RE: ", "Fw: ", "FW: ", "Fwd: "]
                        subject := this.RemovePrefixes(subject, prefixes)

                        ; Normalize whitespace
                        subject := this.NormalizeWhitespace(subject)

                        return subject
                    }

                    /**
                    * Clean list item
                    */
                    static CleanListItem(item) {
                        ; Remove list markers
                        markers := ["* ", "- ", "+ ", "• ", "○ ", "■ "]
                        item := this.RemovePrefixes(item, markers)

                        ; Remove numbering
                        item := RegExReplace(item, "^\d+\.\s*", "")

                        ; Normalize
                        item := this.NormalizeWhitespace(item)

                        return item
                    }
                }

                ; Test the text processing system
                output := "ADVANCED TEXT PROCESSING:`n`n"

                ; Test email subjects
                subjects := ["Re: Meeting tomorrow", "FW: Important update", "Fwd: Please review"]
                output .= "Email Subjects:`n"
                for subject in subjects {
                    cleaned := TextProcessor.CleanEmailSubject(subject)
                    output .= "  '" subject "' → '" cleaned "'`n"
                }
                output .= "`n"

                ; Test list items
                listItems := ["* First item", "1. Second item", "- Third item", "• Fourth item"]
                output .= "List Items:`n"
                for item in listItems {
                    cleaned := TextProcessor.CleanListItem(item)
                    output .= "  '" item "' → '" cleaned "'`n"
                }
                output .= "`n"

                ; Test formatted text
                formatted := ["**Bold**", "_Italic_", "# Heading", "===Title==="]
                output .= "Formatted Text:`n"
                for text in formatted {
                    cleaned := TextProcessor.CleanFormatted(text)
                    output .= "  '" text "' → '" cleaned "'`n"
                }
                output .= "`n"

                ; Test extraction
                testText := "The value is [IMPORTANT] and needs attention"
                extracted := TextProcessor.ExtractBetween(testText, "[", "]")
                output .= "Extract Between [ ]:`n"
                output .= "  Text: '" testText "'`n"
                output .= "  Extracted: '" extracted "'`n"

                MsgBox(output, "Text Processing System", "Icon!")

                ; ============================================================
                ; Reference Information
                ; ============================================================

                info := "
                (
                TEXT PROCESSING WITH TRIM FUNCTIONS:

                Advanced Trim Techniques:
                ═══════════════════════════════════

                1. Prefix Removal:
                if (SubStr(text, 1, StrLen(prefix)) = prefix)
                text := SubStr(text, StrLen(prefix) + 1)

                2. Suffix Removal:
                if (SubStr(text, -StrLen(suffix) + 1) = suffix)
                text := SubStr(text, 1, StrLen(text) - StrLen(suffix))

                3. Multiple Character Trimming:
                text := Trim(text, "*#=-_+")

                4. Trim and Normalize:
                text := Trim(text)
                while InStr(text, "  ")
                text := StrReplace(text, "  ", " ")

                Common Use Cases:
                ═══════════════════

                Markdown Cleaning:
                • Remove # for headings
                • Remove *_ for bold/italic
                • Remove - + for lists
                • Remove > for quotes
                • Remove ` for code

                HTML Processing:
                • Strip tags with regex/parsing
                • Decode entities
                • Normalize whitespace
                • Extract text content

                Code Processing:
                • Normalize indentation
                • Remove comments
                • Clean formatting
                • Extract code blocks

                File Operations:
                • Remove extensions
                • Extract filename
                • Clean paths
                • Normalize separators

                Email Processing:
                • Remove Re:/Fw: prefixes
                • Clean subjects
                • Normalize headers
                • Extract addresses

                Best Practices:
                ══════════════════
                ✓ Trim before and after operations
                ✓ Check for prefix/suffix before removing
                ✓ Normalize whitespace after cleaning
                ✓ Use case-insensitive matching when needed
                ✓ Chain operations for complex cleaning
                ✓ Preserve original for comparison
                ✓ Test with edge cases

                Performance Tips:
                ════════════════════
                • Trim early to reduce string length
                • Use LTrim/RTrim when appropriate
                • Avoid repeated string operations
                • Cache results when processing lists
                • Use RegEx for complex patterns

                Common Patterns:
                ══════════════════
                ; Remove prefix if present
                text := (SubStr(text, 1, 3) = "Re:") ? SubStr(text, 4) : text
                text := Trim(text)

                ; Remove suffix if present
                ext := ".txt"
                if (SubStr(text, -3) = ext)
                text := SubStr(text, 1, StrLen(text) - 4)

                ; Clean and normalize
                text := Trim(text, "[](){}<>")
                text := Trim(text)
                while InStr(text, "  ")
                text := StrReplace(text, "  ", " ")

                ; Extract between delimiters
                start := InStr(text, "[") + 1
                end := InStr(text, "]")
                content := Trim(SubStr(text, start, end - start))
                )"

                MsgBox(info, "Text Processing Reference", "Icon!")
