#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * AHK v2 Standard Library Examples - Part 2: String & Text Operations
 *
 * Built-in string manipulation functions
 * Documentation: https://www.autohotkey.com/docs/v2/
 */

; ═══════════════════════════════════════════════════════════════════════════
; STRING MANIPULATION (Examples 1-20)
; ═══════════════════════════════════════════════════════════════════════════

/**
 * Example 1: StrLen() - Get string length
 */
StrLenExample() {
    text := "Hello World"
    length := StrLen(text)
    MsgBox("Text: '" text "'`nLength: " length " characters")
}

/**
 * Example 2: SubStr() - Extract substring
 */
SubStrExample() {
    text := "AutoHotkey v2.0"

    sub1 := SubStr(text, 1, 10)  ; First 10 chars
    sub2 := SubStr(text, 12)     ; From position 12 to end
    sub3 := SubStr(text, -3)     ; Last 3 chars

    MsgBox("Original: " text
        . "`nFirst 10: " sub1
        . "`nFrom 12: " sub2
        . "`nLast 3: " sub3)
}

/**
 * Example 3: InStr() - Find substring position
 */
InStrExample() {
    email := "user@example.com"

    posAt := InStr(email, "@")
    posDot := InStr(email, ".")
    posNotFound := InStr(email, "xyz")

    MsgBox("Email: " email
        . "`nPosition of '@': " posAt
        . "`nPosition of '.': " posDot
        . "`nPosition of 'xyz': " posNotFound " (not found)")
}

/**
 * Example 4: StrReplace() - Replace text
 */
StrReplaceExample() {
    text := "The quick brown fox"

    replaced1 := StrReplace(text, "fox", "dog")
    replaced2 := StrReplace(text, "quick", "slow", , &count)

    MsgBox("Original: " text
        . "`nReplace fox: " replaced1
        . "`nReplace quick: " replaced2
        . "`nReplacements made: " count)
}

/**
 * Example 5: StrSplit() - Split string into array
 */
StrSplitExample() {
    csv := "apple,banana,orange,grape"

    parts := StrSplit(csv, ",")

    output := "Original: " csv "`n`nParts:`n"
    for index, value in parts
        output .= index ". " value "`n"

    MsgBox(output)
}

/**
 * Example 6: StrUpper() and StrLower() - Change case
 */
StrCaseExample() {
    text := "Hello World"

    upper := StrUpper(text)
    lower := StrLower(text)
    title := StrTitle(text)

    MsgBox("Original: " text
        . "`nUpper: " upper
        . "`nLower: " lower
        . "`nTitle: " title)
}

/**
 * Example 7: Trim(), LTrim(), RTrim() - Remove whitespace
 */
TrimExample() {
    text := "   Hello World   "

    trimmed := Trim(text)
    ltrimmed := LTrim(text)
    rtrimmed := RTrim(text)

    MsgBox("Original: '" text "'`n"
        . "Trim: '" trimmed "'`n"
        . "LTrim: '" ltrimmed "'`n"
        . "RTrim: '" rtrimmed "'")
}

/**
 * Example 8: RegExMatch() - Pattern matching
 */
RegExMatchExample() {
    email := "contact@example.com"

    if RegExMatch(email, "(.+)@(.+\..+)", &match) {
        MsgBox("Email: " email
            . "`nUsername: " match[1]
            . "`nDomain: " match[2])
    }
}

/**
 * Example 9: RegExReplace() - Pattern replacement
 */
RegExReplaceExample() {
    phone := "123-456-7890"

    ; Remove dashes
    cleaned := RegExReplace(phone, "-", "")

    ; Format differently
    formatted := RegExReplace(phone, "(\d{3})-(\d{3})-(\d{4})", "($1) $2-$3")

    MsgBox("Original: " phone
        . "`nNo dashes: " cleaned
        . "`nReformatted: " formatted)
}

/**
 * Example 10: Format() - String formatting
 */
FormatExample() {
    name := "Alice"
    age := 30
    salary := 75000.50

    formatted := Format("Name: {1}`nAge: {2}`nSalary: ${3:.2f}", name, age, salary)

    MsgBox(formatted)
}

/**
 * Example 11: StrCompare() - Compare strings
 */
StrCompareExample() {
    str1 := "apple"
    str2 := "Apple"
    str3 := "banana"

    ; Case-sensitive comparison
    result1 := StrCompare(str1, str2)  ; != 0 (different)
    result2 := StrCompare(str1, str2, false)  ; Case-insensitive, = 0 (same)
    result3 := StrCompare(str1, str3)  ; < 0 (str1 comes before str3)

    MsgBox("'apple' vs 'Apple' (sensitive): " result1
        . "`n'apple' vs 'Apple' (insensitive): " result2
        . "`n'apple' vs 'banana': " result3)
}

/**
 * Example 12: Sort() - Sort strings
 */
SortExample() {
    list := "banana`napple`ngrape`ncherry"

    sorted := Sort(list)
    sortedReverse := Sort(list, "R")  ; Reverse
    sortedNumeric := Sort("10`n2`n30`n5", "N")  ; Numeric

    MsgBox("Original:`n" list
        . "`n`nSorted:`n" sorted
        . "`n`nReverse:`n" sortedReverse
        . "`n`nNumeric:`n" sortedNumeric)
}

/**
 * Example 13: Chr() and Ord() - Character conversions
 */
ChrOrdExample() {
    ; Ord() - Get character code
    code := Ord("A")

    ; Chr() - Get character from code
    char := Chr(65)

    MsgBox("Ord('A') = " code
        . "`nChr(65) = '" char "'")
}

/**
 * Example 14: StrPut() and StrGet() - Encoding
 */
StrPutGetExample() {
    text := "Hello 世界"

    ; StrPut - Write to buffer
    buf := Buffer(StrPut(text, "UTF-8"))
    StrPut(text, buf, "UTF-8")

    ; StrGet - Read from buffer
    retrieved := StrGet(buf, "UTF-8")

    MsgBox("Original: " text
        . "`nBuffer size: " buf.Size
        . "`nRetrieved: " retrieved)
}

/**
 * Example 15: VerCompare() - Version comparison
 */
VerCompareExample() {
    ver1 := "2.0.1"
    ver2 := "2.0.10"

    result := VerCompare(ver1, ver2)

    MsgBox("Version 1: " ver1
        . "`nVersion 2: " ver2
        . "`nComparison: " (result < 0 ? "v1 < v2" : result > 0 ? "v1 > v2" : "Equal"))
}

/**
 * Example 16: FormatTime() - Format timestamps
 */
FormatTimeExample() {
    timestamp := A_Now

    format1 := FormatTime(timestamp, "yyyy-MM-dd")
    format2 := FormatTime(timestamp, "HH:mm:ss")
    format3 := FormatTime(timestamp, "LongDate")
    format4 := FormatTime(timestamp, "ShortDate")

    MsgBox("Timestamp: " timestamp
        . "`n`nDate: " format1
        . "`nTime: " format2
        . "`nLong: " format3
        . "`nShort: " format4)
}

/**
 * Example 17: DateAdd() - Date arithmetic
 */
DateAddExample() {
    today := A_Now

    tomorrow := DateAdd(today, 1, "Days")
    nextWeek := DateAdd(today, 7, "Days")
    nextMonth := DateAdd(today, 1, "Months")

    MsgBox("Today: " FormatTime(today, "yyyy-MM-dd")
        . "`nTomorrow: " FormatTime(tomorrow, "yyyy-MM-dd")
        . "`nNext week: " FormatTime(nextWeek, "yyyy-MM-dd")
        . "`nNext month: " FormatTime(nextMonth, "yyyy-MM-dd"))
}

/**
 * Example 18: DateDiff() - Calculate date difference
 */
DateDiffExample() {
    date1 := "20240101"
    date2 := "20241231"

    diffDays := DateDiff(date2, date1, "Days")
    diffWeeks := DateDiff(date2, date1, "Weeks")
    diffMonths := DateDiff(date2, date1, "Months")

    MsgBox("From: " date1
        . "`nTo: " date2
        . "`n`nDifference:`n"
        . diffDays " days`n"
        . diffWeeks " weeks`n"
        . diffMonths " months")
}

/**
 * Example 19: StrPtr() - Get string pointer
 */
StrPtrExample() {
    text := "Hello"
    ptr := StrPtr(text)

    MsgBox("String: " text
        . "`nPointer: " ptr
        . "`n`nUseful for DllCall and API functions")
}

/**
 * Example 20: String concatenation techniques
 */
ConcatenationExample() {
    ; Method 1: Dot operator
    result1 := "Hello" . " " . "World"

    ; Method 2: Variable substitution
    word1 := "Hello"
    word2 := "World"
    result2 := word1 " " word2

    ; Method 3: Format
    result3 := Format("{1} {2}", word1, word2)

    MsgBox("Method 1 (dot): " result1
        . "`nMethod 2 (substitution): " result2
        . "`nMethod 3 (Format): " result3)
}

; Menu
MsgBox("AHK v2 Standard Library - String & Text (Part 2)`n`n"
    . "STRING BASICS (1-10):`n"
    . "1. StrLen   2. SubStr   3. InStr   4. StrReplace   5. StrSplit`n"
    . "6. StrUpper/Lower   7. Trim   8. RegExMatch   9. RegExReplace   10. Format`n`n"
    . "ADVANCED (11-20):`n"
    . "11. StrCompare   12. Sort   13. Chr/Ord   14. StrPut/Get   15. VerCompare`n"
    . "16. FormatTime   17. DateAdd   18. DateDiff   19. StrPtr   20. Concatenation`n`n"
    . "Call any example function to run!")

; Uncomment to test:
; SubStrExample()
; StrSplitExample()
; RegExMatchExample()
; FormatTimeExample()
