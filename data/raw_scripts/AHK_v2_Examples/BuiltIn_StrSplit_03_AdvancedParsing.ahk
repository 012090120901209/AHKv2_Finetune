#Requires AutoHotkey v2.0
/**
 * BuiltIn_StrSplit_03_AdvancedParsing.ahk
 *
 * DESCRIPTION:
 * Advanced parsing techniques using StrSplit() with multi-character delimiters,
 * max splits, and complex token extraction
 *
 * FEATURES:
 * - Multi-character delimiter handling
 * - MaxParts parameter to limit splits
 * - Parse file paths into components
 * - Command-line argument parsing
 * - Extract tokens from formatted text
 * - URL parsing and query string handling
 * - Log file parsing
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - StrSplit()
 * Advanced parsing patterns and techniques
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - StrSplit() with MaxParts parameter
 * - Multi-character delimiter workarounds
 * - Complex string parsing strategies
 * - Regular expression alternatives
 * - Path and URL manipulation
 *
 * LEARNING POINTS:
 * 1. MaxParts parameter limits number of array elements
 * 2. StrSplit treats each character as delimiter (no multi-char)
 * 3. Multi-char delimiters need workaround with StrReplace
 * 4. Path parsing requires careful delimiter handling
 * 5. Command-line args often use space and quote delimiters
 * 6. Token extraction combines multiple parsing techniques
 * 7. OmitChars parameter helps clean results
 */

; ============================================================
; Example 1: MaxParts Parameter - Limit Splits
; ============================================================

/**
 * Demonstrate MaxParts parameter to limit array size
 * Useful when you only need first N parts
 */
text := "one,two,three,four,five,six,seven"

split2 := StrSplit(text, ",", , 2)  ; Only first 2 parts
split3 := StrSplit(text, ",", , 3)  ; Only first 3 parts
splitAll := StrSplit(text, ",")     ; All parts

output := "Original: " text "`n`n"

output .= "MaxParts = 2 (" split2.Length " elements):`n"
for index, item in split2 {
    output .= index ". " item "`n"
}

output .= "`nMaxParts = 3 (" split3.Length " elements):`n"
for index, item in split3 {
    output .= index ". " item "`n"
}

output .= "`nNo MaxParts (" splitAll.Length " elements):`n"
for index, item in splitAll {
    output .= index ". " item "`n"
}

output .= "`nNote: Remaining text stays in last element"

MsgBox(output, "MaxParts Parameter", "Icon!")

; ============================================================
; Example 2: Parse Key-Value with MaxParts
; ============================================================

/**
 * Parse key=value pairs where value might contain delimiter
 * MaxParts ensures only first = is used as delimiter
 */
ParseKeyValue(line, delimiter := "=") {
    parts := StrSplit(line, delimiter, , 2)

    if (parts.Length < 2)
        return Map("key", line, "value", "")

    return Map(
        "key", Trim(parts[1]),
        "value", Trim(parts[2])
    )
}

; Test cases where value contains =
testLines := [
    "username=john_doe",
    "password=secret=123=abc",
    "formula=a+b=c",
    "url=https://example.com?param=value"
]

output := "KEY-VALUE PARSING (MaxParts=2):`n`n"

for line in testLines {
    parsed := ParseKeyValue(line)
    output .= "Line: " line "`n"
    output .= "  Key: '" parsed["key"] "'`n"
    output .= "  Value: '" parsed["value"] "'`n`n"
}

MsgBox(output, "Key-Value with MaxParts", "Icon!")

; ============================================================
; Example 3: Multi-Character Delimiter Workaround
; ============================================================

/**
 * StrSplit treats each character as separate delimiter
 * To use multi-character delimiter, replace it first
 *
 * @param {String} text - Text to split
 * @param {String} delimiter - Multi-character delimiter
 * @returns {Array} - Split array
 */
SplitByMultiChar(text, delimiter) {
    ; Use a unique placeholder
    placeholder := Chr(0x1F)  ; Unit Separator (unlikely in normal text)

    ; Replace multi-char delimiter with placeholder
    modified := StrReplace(text, delimiter, placeholder)

    ; Split by placeholder
    parts := StrSplit(modified, placeholder)

    return parts
}

; Test with multi-character delimiters
text1 := "apple::orange::banana::grape"
parts1 := SplitByMultiChar(text1, "::")

text2 := "part1 AND part2 AND part3 AND part4"
parts2 := SplitByMultiChar(text2, " AND ")

text3 := "Alice<->Bob<->Charlie<->David"
parts3 := SplitByMultiChar(text3, "<->")

output := "MULTI-CHARACTER DELIMITERS:`n`n"

output .= "Delimiter: '::' (" parts1.Length " parts)`n"
output .= text1 "`n"
for index, part in parts1 {
    output .= index ". " part "`n"
}

output .= "`nDelimiter: ' AND ' (" parts2.Length " parts)`n"
output .= text2 "`n"
for index, part in parts2 {
    output .= index ". " part "`n"
}

output .= "`nDelimiter: '<->' (" parts3.Length " parts)`n"
output .= text3 "`n"
for index, part in parts3 {
    output .= index ". " part "`n"
}

MsgBox(output, "Multi-Character Delimiters", "Icon!")

; ============================================================
; Example 4: Parse File Paths
; ============================================================

/**
 * Parse file path into components
 * Works with Windows and Unix paths
 *
 * @param {String} path - File path
 * @returns {Object} - Map with path components
 */
ParsePath(path) {
    result := Map()
    result["original"] := path
    result["separator"] := InStr(path, "\") ? "\" : "/"

    ; Split by path separator
    parts := StrSplit(path, result["separator"])

    ; Remove empty parts
    cleanParts := []
    for part in parts {
        if (part != "")
            cleanParts.Push(part)
    }

    if (cleanParts.Length = 0) {
        result["drive"] := ""
        result["directory"] := ""
        result["filename"] := ""
        result["extension"] := ""
        return result
    }

    ; Drive (Windows only - first part ending with :)
    firstPart := cleanParts[1]
    if (InStr(firstPart, ":")) {
        result["drive"] := firstPart
        cleanParts.RemoveAt(1)
    } else {
        result["drive"] := ""
    }

    ; Filename is last part
    if (cleanParts.Length > 0) {
        filename := cleanParts[cleanParts.Length]
        result["filename"] := filename

        ; Extract extension
        dotPos := InStr(filename, ".", , -1)
        if (dotPos > 0) {
            result["extension"] := SubStr(filename, dotPos + 1)
            result["basename"] := SubStr(filename, 1, dotPos - 1)
        } else {
            result["extension"] := ""
            result["basename"] := filename
        }

        ; Directory is everything before filename
        cleanParts.RemoveAt(cleanParts.Length)
    }

    ; Join directory parts
    dirPath := ""
    for part in cleanParts {
        dirPath .= part result["separator"]
    }
    result["directory"] := dirPath

    return result
}

; Test various paths
paths := [
    "C:\Users\John\Documents\report.pdf",
    "/home/user/scripts/automation.ahk",
    "D:\Projects\MyApp\src\main.js",
    "/var/log/system.log",
    "README.md"
]

output := "FILE PATH PARSING:`n`n"

for path in paths {
    parsed := ParsePath(path)
    output .= "Path: " path "`n"
    if (parsed["drive"] != "")
        output .= "  Drive: " parsed["drive"] "`n"
    if (parsed["directory"] != "")
        output .= "  Directory: " parsed["directory"] "`n"
    output .= "  Filename: " parsed["filename"] "`n"
    if (parsed["basename"] != "")
        output .= "  Basename: " parsed["basename"] "`n"
    if (parsed["extension"] != "")
        output .= "  Extension: " parsed["extension"] "`n"
    output .= "`n"
}

MsgBox(output, "Path Parser", "Icon!")

; ============================================================
; Example 5: Command-Line Argument Parsing
; ============================================================

/**
 * Parse command-line style arguments
 * Handles flags, options with values, and positional args
 *
 * @param {String} commandLine - Command line string
 * @returns {Object} - Parsed arguments
 */
ParseCommandLine(commandLine) {
    result := Map()
    result["command"] := ""
    result["flags"] := []
    result["options"] := Map()
    result["args"] := []

    ; Simple split by spaces (doesn't handle quotes perfectly)
    parts := StrSplit(commandLine, " ", " `t")

    firstArg := true
    i := 1

    while (i <= parts.Length) {
        part := parts[i]

        if (part = "") {
            i++
            continue
        }

        if (firstArg) {
            result["command"] := part
            firstArg := false
        }
        else if (SubStr(part, 1, 2) = "--") {
            ; Long option
            optionName := SubStr(part, 3)

            ; Check if next part is value
            if (i < parts.Length && SubStr(parts[i + 1], 1, 1) != "-") {
                result["options"][optionName] := parts[i + 1]
                i++
            } else {
                result["flags"].Push(optionName)
            }
        }
        else if (SubStr(part, 1, 1) = "-") {
            ; Short flag
            flag := SubStr(part, 2)
            result["flags"].Push(flag)
        }
        else {
            ; Positional argument
            result["args"].Push(part)
        }

        i++
    }

    return result
}

; Test command lines
commands := [
    "myapp --verbose --output results.txt input.dat",
    "git commit -m message --author John",
    "convert image.png --resize 800x600 --quality 90 output.jpg"
]

output := "COMMAND-LINE PARSING:`n`n"

for cmdLine in commands {
    parsed := ParseCommandLine(cmdLine)
    output .= "Command: " cmdLine "`n"
    output .= "  Program: " parsed["command"] "`n"

    if (parsed["flags"].Length > 0) {
        output .= "  Flags: "
        for flag in parsed["flags"] {
            output .= flag " "
        }
        output .= "`n"
    }

    if (parsed["options"].Count > 0) {
        output .= "  Options:`n"
        for key, value in parsed["options"] {
            output .= "    --" key " = " value "`n"
        }
    }

    if (parsed["args"].Length > 0) {
        output .= "  Arguments:`n"
        for arg in parsed["args"] {
            output .= "    " arg "`n"
        }
    }

    output .= "`n"
}

MsgBox(output, "Command-Line Parser", "Icon!")

; ============================================================
; Example 6: URL and Query String Parsing
; ============================================================

/**
 * Parse URL into components
 *
 * @param {String} url - URL to parse
 * @returns {Object} - URL components
 */
ParseURL(url) {
    result := Map()
    result["original"] := url
    result["protocol"] := ""
    result["host"] := ""
    result["port"] := ""
    result["path"] := ""
    result["query"] := ""
    result["params"] := Map()

    ; Extract protocol
    protocolPos := InStr(url, "://")
    if (protocolPos > 0) {
        result["protocol"] := SubStr(url, 1, protocolPos - 1)
        url := SubStr(url, protocolPos + 3)
    }

    ; Extract query string
    queryPos := InStr(url, "?")
    if (queryPos > 0) {
        result["query"] := SubStr(url, queryPos + 1)
        url := SubStr(url, 1, queryPos - 1)

        ; Parse query parameters
        params := StrSplit(result["query"], "&")
        for param in params {
            parts := StrSplit(param, "=", , 2)
            if (parts.Length >= 2) {
                result["params"][parts[1]] := parts[2]
            }
        }
    }

    ; Extract path
    pathPos := InStr(url, "/")
    if (pathPos > 0) {
        result["path"] := SubStr(url, pathPos)
        url := SubStr(url, 1, pathPos - 1)
    }

    ; Extract port
    portPos := InStr(url, ":")
    if (portPos > 0) {
        result["port"] := SubStr(url, portPos + 1)
        result["host"] := SubStr(url, 1, portPos - 1)
    } else {
        result["host"] := url
    }

    return result
}

; Test URLs
urls := [
    "https://www.example.com/path/to/page",
    "http://localhost:8080/api/users?id=123&name=John",
    "ftp://files.company.com:21/documents/report.pdf?download=true"
]

output := "URL PARSING:`n`n"

for url in urls {
    parsed := ParseURL(url)
    output .= "URL: " url "`n"
    output .= "  Protocol: " parsed["protocol"] "`n"
    output .= "  Host: " parsed["host"] "`n"
    if (parsed["port"] != "")
        output .= "  Port: " parsed["port"] "`n"
    if (parsed["path"] != "")
        output .= "  Path: " parsed["path"] "`n"
    if (parsed["query"] != "")
        output .= "  Query: " parsed["query"] "`n"
    if (parsed["params"].Count > 0) {
        output .= "  Parameters:`n"
        for key, value in parsed["params"] {
            output .= "    " key " = " value "`n"
        }
    }
    output .= "`n"
}

MsgBox(output, "URL Parser", "Icon!")

; ============================================================
; Example 7: Log File Token Extraction
; ============================================================

/**
 * Parse structured log entries
 * Format: [TIMESTAMP] LEVEL: Message
 */
class LogParser {
    /**
     * Parse log entry
     *
     * @param {String} logLine - Log line to parse
     * @returns {Object} - Parsed log entry
     */
    static ParseLine(logLine) {
        entry := Map()
        entry["original"] := logLine
        entry["timestamp"] := ""
        entry["level"] := ""
        entry["message"] := ""

        ; Extract timestamp (between [ ])
        startBracket := InStr(logLine, "[")
        endBracket := InStr(logLine, "]")

        if (startBracket > 0 && endBracket > startBracket) {
            entry["timestamp"] := SubStr(logLine, startBracket + 1, endBracket - startBracket - 1)
            logLine := Trim(SubStr(logLine, endBracket + 1))
        }

        ; Extract level (before :)
        colonPos := InStr(logLine, ":")
        if (colonPos > 0) {
            entry["level"] := Trim(SubStr(logLine, 1, colonPos - 1))
            entry["message"] := Trim(SubStr(logLine, colonPos + 1))
        } else {
            entry["message"] := logLine
        }

        return entry
    }

    /**
     * Parse multiple log lines
     */
    static ParseLog(logData) {
        entries := []
        lines := StrSplit(logData, "`n", "`r")

        for line in lines {
            line := Trim(line)
            if (line = "")
                continue

            entries.Push(this.ParseLine(line))
        }

        return entries
    }

    /**
     * Filter logs by level
     */
    static FilterByLevel(entries, level) {
        filtered := []
        for entry in entries {
            if (entry["level"] = level)
                filtered.Push(entry)
        }
        return filtered
    }
}

; Sample log data
logData := "
(
[2024-01-15 10:23:45] INFO: Application started successfully
[2024-01-15 10:23:46] DEBUG: Loading configuration file
[2024-01-15 10:23:47] INFO: Configuration loaded
[2024-01-15 10:24:12] WARNING: High memory usage detected
[2024-01-15 10:25:33] ERROR: Database connection failed
[2024-01-15 10:25:34] INFO: Retrying connection
[2024-01-15 10:25:35] INFO: Connection established
)"

entries := LogParser.ParseLog(logData)

output := "LOG FILE PARSING:`n"
output .= "Total Entries: " entries.Length "`n`n"

; Display all entries
for entry in entries {
    output .= "[" entry["timestamp"] "] "
    output .= entry["level"] ": "
    output .= entry["message"] "`n"
}

; Count by level
levels := Map("INFO", 0, "DEBUG", 0, "WARNING", 0, "ERROR", 0)
for entry in entries {
    if (levels.Has(entry["level"]))
        levels[entry["level"]]++
}

output .= "`nSUMMARY BY LEVEL:`n"
for level, count in levels {
    if (count > 0)
        output .= level ": " count "`n"
}

; Show errors only
errors := LogParser.FilterByLevel(entries, "ERROR")
if (errors.Length > 0) {
    output .= "`nERRORS:`n"
    for entry in errors {
        output .= entry["timestamp"] " - " entry["message"] "`n"
    }
}

MsgBox(output, "Log Parser", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
ADVANCED STRSPLIT() TECHNIQUES:

MaxParts Parameter:
  parts := StrSplit(text, delimiter, omit, MaxParts)
  • Limits number of elements returned
  • Last element contains remaining text
  • Useful for key=value parsing
  • Example: StrSplit('a,b,c,d', ',', , 2) → ['a', 'b,c,d']

Multi-Character Delimiters:
  Problem: StrSplit treats each char as delimiter
  Solution: Replace before splitting

  SplitByMulti(text, delim) {
      placeholder := Chr(0x1F)
      text := StrReplace(text, delim, placeholder)
      return StrSplit(text, placeholder)
  }

Path Parsing Strategy:
  1. Detect separator (\ or /)
  2. Split by separator
  3. Extract drive (Windows)
  4. Get filename (last part)
  5. Extract extension (last dot)
  6. Join directory parts

Command-Line Parsing:
  • Split by spaces
  • Identify flags (-, --)
  • Pair options with values
  • Collect positional args
  • Handle quoted arguments

URL Parsing Strategy:
  1. Extract protocol (before ://)
  2. Extract query string (after ?)
  3. Extract path (after host)
  4. Extract port (after :)
  5. Parse query parameters

Token Extraction:
  • Combine InStr() and SubStr()
  • Use StrSplit for initial breakdown
  • Apply Trim() to clean results
  • Validate extracted data
  • Handle missing fields

Performance Tips:
  ✓ Use MaxParts when possible
  ✓ Minimize StrReplace calls
  ✓ Pre-calculate string lengths
  ✓ Cache split results if reused
  ✓ Use OmitChars for cleanup

Common Patterns:
  • Log parsing: Extract timestamp, level, message
  • Config files: Split key=value pairs
  • CSV/TSV: Split by comma/tab
  • URLs: Extract components
  • Paths: Get directory, filename, extension
  • Command lines: Parse flags and arguments

Best Practices:
  ✓ Validate input before parsing
  ✓ Handle edge cases (empty, malformed)
  ✓ Use appropriate delimiters
  ✓ Clean extracted data (Trim)
  ✓ Document expected format
  ✓ Test with various inputs
)"

MsgBox(info, "Advanced StrSplit() Reference", "Icon!")
