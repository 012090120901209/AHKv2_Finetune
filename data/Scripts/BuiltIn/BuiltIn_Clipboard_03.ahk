#Requires AutoHotkey v2.0
#Include .\JSON.ahk .\JSON.ahk

/**
* ============================================================================
* AutoHotkey v2 - A_Clipboard Format Detection
* ============================================================================
*
* This file demonstrates format detection and content analysis of clipboard
* data in AutoHotkey v2, including detecting file paths, URLs, JSON, CSV,
* HTML, and various other data formats.
*
* @file BuiltIn_Clipboard_03.ahk
* @version 2.0.0
* @author AHK v2 Examples Collection
* @date 2024-11-16
*
* TABLE OF CONTENTS:
* ──────────────────────────────────────────────────────────────────────────
* 1. Basic Format Detection
* 2. File Path Detection and Validation
* 3. URL and Email Detection
* 4. Structured Data Detection (JSON, XML, CSV)
* 5. Code and Markup Detection
* 6. Number and Date Detection
* 7. Comprehensive Clipboard Analyzer
*
* EXAMPLES SUMMARY:
* ──────────────────────────────────────────────────────────────────────────
* - Detecting clipboard content type
* - Identifying file paths and validating them
* - Detecting URLs, emails, and network addresses
* - Recognizing JSON, XML, CSV, and other structured data
* - Identifying programming languages and markup
* - Detecting numeric data and date formats
* - Building a comprehensive clipboard analyzer
*
* ============================================================================
*/

; ============================================================================
; Example 1: Basic Format Detection
; ============================================================================

/**
* Demonstrates basic clipboard format detection.
*
* @class BasicFormatDetector
* @description Detects basic clipboard content characteristics
*/

class BasicFormatDetector {

    /**
    * Checks if clipboard is empty
    * @returns {Boolean}
    */
    static IsEmpty() {
        return A_Clipboard = ""
    }

    /**
    * Checks if clipboard contains only whitespace
    * @returns {Boolean}
    */
    static IsWhitespace() {
        return Trim(A_Clipboard) = ""
    }

    /**
    * Checks if clipboard contains single line
    * @returns {Boolean}
    */
    static IsSingleLine() {
        return !InStr(A_Clipboard, "`n")
    }

    /**
    * Checks if clipboard contains multiple lines
    * @returns {Boolean}
    */
    static IsMultiLine() {
        return InStr(A_Clipboard, "`n")
    }

    /**
    * Gets clipboard statistics
    * @returns {Map}
    */
    static GetStats() {
        stats := Map()
        stats["isEmpty"] := this.IsEmpty()
        stats["isWhitespace"] := this.IsWhitespace()
        stats["length"] := StrLen(A_Clipboard)
        stats["lines"] := StrSplit(A_Clipboard, "`n").Length
        stats["words"] := this.CountWords()
        stats["chars"] := StrLen(A_Clipboard)
        return stats
    }

    /**
    * Counts words in clipboard
    * @returns {Integer}
    */
    static CountWords() {
        if (A_Clipboard = "")
        return 0

        wordCount := 0
        Loop Parse, A_Clipboard, " `t`n`r" {
            if (A_LoopField != "")
            wordCount++
        }
        return wordCount
    }
}

; Show basic clipboard info
F1:: {
    if (BasicFormatDetector.IsEmpty()) {
        MsgBox("Clipboard is empty!", "Format Info", "Icon Info")
        return
    }

    stats := BasicFormatDetector.GetStats()
    info := "Clipboard Statistics:`n`n"
    info .= "Characters: " . stats["chars"] . "`n"
    info .= "Words: " . stats["words"] . "`n"
    info .= "Lines: " . stats["lines"] . "`n"
    info .= "Type: " . (stats["lines"] > 1 ? "Multi-line" : "Single-line")

    MsgBox(info, "Clipboard Format Info", "Icon Info")
}

; ============================================================================
; Example 2: File Path Detection and Validation
; ============================================================================

/**
* Demonstrates file path detection and validation.
*
* @class FilePathDetector
* @description Detects and validates file paths in clipboard
*/

class FilePathDetector {

    /**
    * Checks if clipboard contains a Windows file path
    * @returns {Boolean}
    */
    static IsFilePath() {
        if (A_Clipboard = "")
        return false

        ; Check for drive letter pattern or UNC path
        return RegExMatch(A_Clipboard, "^[A-Za-z]:\\")
        || RegExMatch(A_Clipboard, "^\\\\")
    }

    /**
    * Checks if clipboard contains a valid existing file path
    * @returns {Boolean}
    */
    static IsValidFilePath() {
        if (!this.IsFilePath())
        return false

        return FileExist(Trim(A_Clipboard)) != ""
    }

    /**
    * Extracts all file paths from clipboard
    * @returns {Array}
    */
    static ExtractFilePaths() {
        paths := []

        ; Pattern for Windows paths
        pattern := "([A-Za-z]:\\[^\s\r\n]+|\\\\[^\s\r\n]+)"

        pos := 1
        while (RegExMatch(A_Clipboard, pattern, &match, pos)) {
            paths.Push(match[1])
            pos := match.Pos + match.Len
        }

        return paths
    }

    /**
    * Validates multiple file paths
    * @param {Array} paths - Array of paths to validate
    * @returns {Map} Results with valid/invalid paths
    */
    static ValidatePaths(paths) {
        result := Map()
        result["valid"] := []
        result["invalid"] := []

        for path in paths {
            if (FileExist(Trim(path)))
            result["valid"].Push(path)
            else
            result["invalid"].Push(path)
        }

        return result
    }

    /**
    * Gets file path information
    * @param {String} path - File path
    * @returns {Map}
    */
    static GetPathInfo(path) {
        info := Map()
        info["exists"] := FileExist(path) != ""
        info["isDir"] := InStr(FileExist(path), "D") > 0
        info["isFile"] := FileExist(path) && !InStr(FileExist(path), "D")

        if (info["exists"]) {
            SplitPath(path, &name, &dir, &ext, &nameNoExt)
            info["name"] := name
            info["directory"] := dir
            info["extension"] := ext
            info["nameNoExt"] := nameNoExt
        }

        return info
    }
}

; Detect and analyze file paths
F2:: {
    if (!FilePathDetector.IsFilePath()) {
        MsgBox("Clipboard does not contain a file path!",
        "Path Detector", "Icon Info")
        return
    }

    paths := FilePathDetector.ExtractFilePaths()
    validation := FilePathDetector.ValidatePaths(paths)

    info := "File Path Analysis:`n`n"
    info .= "Total paths found: " . paths.Length . "`n`n"

    if (validation["valid"].Length > 0) {
        info .= "Valid paths (" . validation["valid"].Length . "):`n"
        for path in validation["valid"] {
            pathInfo := FilePathDetector.GetPathInfo(path)
            info .= "  • " . path
            info .= " [" . (pathInfo["isDir"] ? "DIR" : "FILE") . "]`n"
        }
    }

    if (validation["invalid"].Length > 0) {
        info .= "`nInvalid paths (" . validation["invalid"].Length . "):`n"
        for path in validation["invalid"] {
            info .= "  • " . path . "`n"
        }
    }

    MsgBox(info, "File Path Analysis", "Icon Info")
}

; ============================================================================
; Example 3: URL and Email Detection
; ============================================================================

/**
* Demonstrates URL and email detection.
*
* @class NetworkDetector
* @description Detects URLs, emails, and network addresses
*/

class NetworkDetector {

    /**
    * Checks if clipboard contains a URL
    * @returns {Boolean}
    */
    static IsURL() {
        return RegExMatch(A_Clipboard, "i)^https?://")
    }

    /**
    * Checks if clipboard contains an email address
    * @returns {Boolean}
    */
    static IsEmail() {
        return RegExMatch(A_Clipboard, "i)^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$")
    }

    /**
    * Checks if clipboard contains an IP address
    * @returns {Boolean}
    */
    static IsIPAddress() {
        return RegExMatch(A_Clipboard, "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$")
    }

    /**
    * Extracts domain from URL
    * @param {String} url - URL to parse
    * @returns {String}
    */
    static ExtractDomain(url) {
        if (RegExMatch(url, "i)https?://([^/]+)", &match))
        return match[1]
        return ""
    }

    /**
    * Validates URL format
    * @param {String} url - URL to validate
    * @returns {Boolean}
    */
    static ValidateURL(url) {
        ; Basic URL validation
        return RegExMatch(url, "i)^https?://[^\s]+\.[^\s]+$")
    }

    /**
    * Gets URL information
    * @param {String} url - URL to analyze
    * @returns {Map}
    */
    static GetURLInfo(url) {
        info := Map()
        info["isValid"] := this.ValidateURL(url)

        if (RegExMatch(url, "i)^(https?)://([^/]+)(.*)", &match)) {
            info["protocol"] := match[1]
            info["domain"] := match[2]
            info["path"] := match[3]
            info["isSecure"] := match[1] = "https"
        }

        return info
    }
}

; Analyze URL/Email
F3:: {
    text := Trim(A_Clipboard)

    if (NetworkDetector.IsURL()) {
        urlInfo := NetworkDetector.GetURLInfo(text)
        info := "URL Analysis:`n`n"
        info .= "Protocol: " . urlInfo["protocol"] . "`n"
        info .= "Domain: " . urlInfo["domain"] . "`n"
        info .= "Path: " . urlInfo["path"] . "`n"
        info .= "Secure: " . (urlInfo["isSecure"] ? "Yes (HTTPS)" : "No (HTTP)")

        MsgBox(info, "URL Analysis", "Icon Info")
    }
    else if (NetworkDetector.IsEmail()) {
        MsgBox("Valid email address detected:`n`n" . text,
        "Email Analysis", "Icon Info")
    }
    else if (NetworkDetector.IsIPAddress()) {
        MsgBox("IP address detected:`n`n" . text,
        "IP Analysis", "Icon Info")
    }
    else {
        MsgBox("Clipboard does not contain a recognized network address!",
        "Network Detector", "Icon Warn")
    }
}

; ============================================================================
; Example 4: Structured Data Detection (JSON, XML, CSV)
; ============================================================================

/**
* Demonstrates structured data format detection.
*
* @class StructuredDataDetector
* @description Detects JSON, XML, CSV, and other structured formats
*/

class StructuredDataDetector {

    /**
    * Checks if clipboard contains JSON
    * @returns {Boolean}
    */
    static IsJSON() {
        text := Trim(A_Clipboard)
        ; Basic JSON detection
        return (SubStr(text, 1, 1) = "{" && SubStr(text, -1) = "}")
        || (SubStr(text, 1, 1) = "[" && SubStr(text, -1) = "]")
    }

    /**
    * Validates JSON syntax
    * @returns {Boolean}
    */
    static ValidateJSON() {
        if (!this.IsJSON())
        return false

        try {
            parsed := Jxon_Load(&A_Clipboard)
            return true
        } catch {
            return false
        }
    }

    /**
    * Checks if clipboard contains XML
    * @returns {Boolean}
    */
    static IsXML() {
        text := Trim(A_Clipboard)
        return RegExMatch(text, "i)^\s*<[?!]?[a-z]")
    }

    /**
    * Checks if clipboard contains CSV
    * @returns {Boolean}
    */
    static IsCSV() {
        if (!BasicFormatDetector.IsMultiLine())
        return false

        lines := StrSplit(A_Clipboard, "`n")
        if (lines.Length < 2)
        return false

        ; Check if lines have consistent comma count
        firstLineCommas := 0
        Loop Parse, lines[1], "," {
            firstLineCommas++
        }

        for index, line in lines {
            if (index = 1)
            continue

            lineCommas := 0
            Loop Parse, line, "," {
                lineCommas++
            }

            if (lineCommas != firstLineCommas)
            return false
        }

        return true
    }

    /**
    * Gets CSV information
    * @returns {Map}
    */
    static GetCSVInfo() {
        if (!this.IsCSV())
        return Map()

        info := Map()
        lines := StrSplit(A_Clipboard, "`n")

        info["rows"] := lines.Length
        info["columns"] := StrSplit(lines[1], ",").Length
        info["hasHeader"] := true  ; Assume first row is header

        return info
    }

    /**
    * Checks if clipboard contains HTML
    * @returns {Boolean}
    */
    static IsHTML() {
        text := StrLower(Trim(A_Clipboard))
        return InStr(text, "<html") || InStr(text, "<!doctype html")
        || RegExMatch(text, "< (div|p|span|table|body|head)")
    }

    /**
    * Checks if clipboard contains Markdown
    * @returns {Boolean}
    */
    static IsMarkdown() {
        text := A_Clipboard
        ; Check for common Markdown patterns
        return RegExMatch(text, "^#+\s")              ; Headers
        || RegExMatch(text, "^\*\s")              ; Bullet lists
        || RegExMatch(text, "^\d+\.\s")           ; Numbered lists
        || InStr(text, "```")                      ; Code blocks
        || RegExMatch(text, "\[.*\]\(.*\)")       ; Links
    }
}

; Detect structured data format
F4:: {
    if (BasicFormatDetector.IsEmpty()) {
        MsgBox("Clipboard is empty!", "Format Detector", "Icon Warn")
        return
    }

    formats := []

    if (StructuredDataDetector.IsJSON())
    formats.Push("JSON")

    if (StructuredDataDetector.IsXML())
    formats.Push("XML")

    if (StructuredDataDetector.IsHTML())
    formats.Push("HTML")

    if (StructuredDataDetector.IsCSV()) {
        csvInfo := StructuredDataDetector.GetCSVInfo()
        formats.Push("CSV (" . csvInfo["rows"] . " rows, " . csvInfo["columns"] . " columns)")
    }

    if (StructuredDataDetector.IsMarkdown())
    formats.Push("Markdown")

    if (formats.Length = 0) {
        MsgBox("No structured data format detected.`n`nContent appears to be plain text.",
        "Format Detector", "Icon Info")
    } else {
        info := "Detected Format(s):`n`n"
        for format in formats {
            info .= "• " . format . "`n"
        }

        MsgBox(info, "Structured Data Detected", "Icon Info")
    }
}

; ============================================================================
; Example 5: Code and Markup Detection
; ============================================================================

/**
* Demonstrates code and markup language detection.
*
* @class CodeDetector
* @description Detects programming languages and code snippets
*/

class CodeDetector {

    /**
    * Detects programming language
    * @returns {String}
    */
    static DetectLanguage() {
        text := A_Clipboard

        ; Check for common language patterns
        if (RegExMatch(text, "i)\bfunction\s+\w+\s*\(") && InStr(text, "{"))
        return "JavaScript"

        if (RegExMatch(text, "i)\bdef\s+\w+\s*\(") || RegExMatch(text, "i)\bimport\s+\w+"))
        return "Python"

        if (RegExMatch(text, "i)\bpublic\s+(class|interface|void)") || InStr(text, "System.out"))
        return "Java"

        if (RegExMatch(text, "i)#include\s*<") || RegExMatch(text, "i)\bint\s+main\s*\("))
        return "C/C++"

        if (RegExMatch(text, "i)\bnamespace\s+\w+") || RegExMatch(text, "i)\busing\s+System"))
        return "C#"

        if (RegExMatch(text, "i)\b(SELECT|INSERT|UPDATE|DELETE)\s+"))
        return "SQL"

        if (RegExMatch(text, "i)^#Requires AutoHotkey") || RegExMatch(text, "::"))
        return "AutoHotkey"

        if (InStr(text, "<?php"))
        return "PHP"

        if (RegExMatch(text, "i)\bpackage\s+main") || RegExMatch(text, "i)\bfunc\s+"))
        return "Go"

        return "Unknown"
    }

    /**
    * Checks if clipboard contains code
    * @returns {Boolean}
    */
    static IsCode() {
        text := A_Clipboard

        ; Check for common code indicators
        indicators := 0

        ; Check for braces
        if (InStr(text, "{") && InStr(text, "}"))
        indicators++

        ; Check for semicolons
        if (InStr(text, ";"))
        indicators++

        ; Check for function keyword
        if (RegExMatch(text, "i)\b(function|def|func|sub|public|private)\b"))
        indicators++

        ; Check for operators
        if (RegExMatch(text, "==|!=|<=|>=|&&|\|\|"))
        indicators++

        return indicators >= 2
    }

    /**
    * Gets code statistics
    * @returns {Map}
    */
    static GetCodeStats() {
        stats := Map()
        lines := StrSplit(A_Clipboard, "`n")

        stats["totalLines"] := lines.Length
        stats["codeLines"] := 0
        stats["commentLines"] := 0
        stats["emptyLines"] := 0

        for line in lines {
            trimmed := Trim(line)

            if (trimmed = "") {
                stats["emptyLines"]++
            }
            else if (RegExMatch(trimmed, "^(//|#|;|\*)")) {
                stats["commentLines"]++
            }
            else {
                stats["codeLines"]++
            }
        }

        return stats
    }
}

; Detect code language
F5:: {
    if (CodeDetector.IsCode()) {
        language := CodeDetector.DetectLanguage()
        stats := CodeDetector.GetCodeStats()

        info := "Code Analysis:`n`n"
        info .= "Detected Language: " . language . "`n`n"
        info .= "Statistics:`n"
        info .= "  Total Lines: " . stats["totalLines"] . "`n"
        info .= "  Code Lines: " . stats["codeLines"] . "`n"
        info .= "  Comment Lines: " . stats["commentLines"] . "`n"
        info .= "  Empty Lines: " . stats["emptyLines"]

        MsgBox(info, "Code Detector", "Icon Info")
    } else {
        MsgBox("Clipboard does not appear to contain code!",
        "Code Detector", "Icon Info")
    }
}

; ============================================================================
; Example 6: Number and Date Detection
; ============================================================================

/**
* Demonstrates number and date format detection.
*
* @class NumberDateDetector
* @description Detects numeric and date formats
*/

class NumberDateDetector {

    /**
    * Checks if clipboard contains a number
    * @returns {Boolean}
    */
    static IsNumber() {
        text := Trim(A_Clipboard)
        return IsNumber(text)
    }

    /**
    * Checks if clipboard contains a date
    * @returns {Boolean}
    */
    static IsDate() {
        text := Trim(A_Clipboard)

        ; Common date patterns
        patterns := [
        "\d{4}-\d{2}-\d{2}",           ; YYYY-MM-DD
        "\d{2}/\d{2}/\d{4}",           ; MM/DD/YYYY
        "\d{2}\.\d{2}\.\d{4}",         ; DD.MM.YYYY
        "\d{8}",                        ; YYYYMMDD
        ]

        for pattern in patterns {
            if (RegExMatch(text, "^" . pattern . "$"))
            return true
        }

        return false
    }

    /**
    * Detects number type
    * @param {String} num - Number to analyze
    * @returns {String}
    */
    static GetNumberType(num) {
        if (InStr(num, "."))
        return "Decimal"
        else if (num < 0)
        return "Negative Integer"
        else if (num = 0)
        return "Zero"
        else
        return "Positive Integer"
    }

    /**
    * Extracts all numbers from clipboard
    * @returns {Array}
    */
    static ExtractNumbers() {
        numbers := []
        pattern := "(-?\d+\.?\d*)"

        pos := 1
        while (RegExMatch(A_Clipboard, pattern, &match, pos)) {
            numbers.Push(match[1])
            pos := match.Pos + match.Len
        }

        return numbers
    }
}

; Analyze numbers/dates
F6:: {
    text := Trim(A_Clipboard)

    if (NumberDateDetector.IsNumber()) {
        numType := NumberDateDetector.GetNumberType(text)
        MsgBox("Number detected!`n`nType: " . numType . "`nValue: " . text,
        "Number Analysis", "Icon Info")
    }
    else if (NumberDateDetector.IsDate()) {
        MsgBox("Date detected!`n`nValue: " . text,
        "Date Analysis", "Icon Info")
    }
    else {
        numbers := NumberDateDetector.ExtractNumbers()
        if (numbers.Length > 0) {
            info := "Found " . numbers.Length . " number(s):`n`n"
            for num in numbers {
                info .= num . "`n"
            }
            MsgBox(info, "Numbers Found", "Icon Info")
        } else {
            MsgBox("No numbers or dates detected in clipboard!",
            "Number/Date Detector", "Icon Info")
        }
    }
}

; ============================================================================
; Example 7: Comprehensive Clipboard Analyzer
; ============================================================================

/**
* Comprehensive clipboard content analyzer.
*
* @class ClipboardAnalyzer
* @description Analyzes all aspects of clipboard content
*/

class ClipboardAnalyzer {

    /**
    * Performs comprehensive analysis
    * @returns {Map}
    */
    static Analyze() {
        analysis := Map()

        ; Basic stats
        analysis["isEmpty"] := BasicFormatDetector.IsEmpty()
        if (analysis["isEmpty"])
        return analysis

        analysis["stats"] := BasicFormatDetector.GetStats()

        ; Content types
        analysis["isFilePath"] := FilePathDetector.IsFilePath()
        analysis["isURL"] := NetworkDetector.IsURL()
        analysis["isEmail"] := NetworkDetector.IsEmail()
        analysis["isCode"] := CodeDetector.IsCode()
        analysis["isJSON"] := StructuredDataDetector.IsJSON()
        analysis["isXML"] := StructuredDataDetector.IsXML()
        analysis["isNumber"] := NumberDateDetector.IsNumber()
        analysis["isDate"] := NumberDateDetector.IsDate()

        return analysis
    }

    /**
    * Generates report string
    * @param {Map} analysis - Analysis results
    * @returns {String}
    */
    static GenerateReport(analysis) {
        if (analysis["isEmpty"])
        return "Clipboard is empty."

        report := "Clipboard Analysis Report`n"
        report .= "=========================`n`n"

        ; Stats
        stats := analysis["stats"]
        report .= "Statistics:`n"
        report .= "  Length: " . stats["length"] . " chars`n"
        report .= "  Words: " . stats["words"] . "`n"
        report .= "  Lines: " . stats["lines"] . "`n`n"

        ; Content Types
        report .= "Detected Content Types:`n"
        types := []

        if (analysis["isFilePath"])
        types.Push("File Path")
        if (analysis["isURL"])
        types.Push("URL")
        if (analysis["isEmail"])
        types.Push("Email")
        if (analysis["isCode"])
        types.Push("Code (" . CodeDetector.DetectLanguage() . ")")
        if (analysis["isJSON"])
        types.Push("JSON")
        if (analysis["isXML"])
        types.Push("XML")
        if (analysis["isNumber"])
        types.Push("Number")
        if (analysis["isDate"])
        types.Push("Date")

        if (types.Length = 0)
        report .= "  Plain Text`n"
        else {
            for type in types {
                report .= "  • " . type . "`n"
            }
        }

        return report
    }
}

; Run comprehensive analysis
F7:: {
    analysis := ClipboardAnalyzer.Analyze()
    report := ClipboardAnalyzer.GenerateReport(analysis)
    MsgBox(report, "Clipboard Analyzer", "Icon Info")
}
