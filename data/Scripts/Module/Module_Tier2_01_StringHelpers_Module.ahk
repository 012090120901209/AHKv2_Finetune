#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

/**
 * Module Tier 2 Example 01: String Helpers Module
 * 
 * This example demonstrates:
 * - Creating a utility module with many exported functions
 * - Preparing module for selective imports
 * - String manipulation helpers
 * - Clean API design
 * 
 * @module StringHelpers
 */

#Module StringHelpers

/**
 * Remove extra whitespace and trim
 * @param text {String} - Input text
 * @returns {String} - Cleaned text
 */
Export CollapseWhitespace(text) {
    if text = ""
        return ""
    cleaned := RegExReplace(text, "\s+", " ")
    return Trim(cleaned)
}

/**
 * Convert to Title Case (First Letter Of Each Word Capitalized)
 * @param text {String} - Input text
 * @returns {String} - Title cased text
 */
Export ToTitleCase(text) {
    text := CollapseWhitespace(text)
    if text = ""
        return ""

    words := StrSplit(text, " ")
    for index, word in words {
        if word = ""
            continue
        words[index] := Format("{1:U}{2:L}", SubStr(word, 1, 1), SubStr(word, 2))
    }

    result := ""
    for index, word in words {
        result .= word (index < words.Length ? " " : "")
    }
    return result
}

/**
 * Convert to camelCase (firstWordLowercase, RestTitleCase)
 * @param text {String} - Input text
 * @returns {String} - camelCase text
 */
Export ToCamelCase(text) {
    text := ToTitleCase(text)
    text := StrReplace(text, " ", "")
    if text = ""
        return ""
    return Format("{1:L}{2}", SubStr(text, 1, 1), SubStr(text, 2))
}

/**
 * Convert to PascalCase (Every Word Capitalized, No Spaces)
 * @param text {String} - Input text
 * @returns {String} - PascalCase text
 */
Export ToPascalCase(text) {
    text := ToTitleCase(text)
    return StrReplace(text, " ", "")
}

/**
 * Convert to snake_case (all lowercase, underscores)
 * @param text {String} - Input text
 * @returns {String} - snake_case text
 */
Export ToSnakeCase(text) {
    text := CollapseWhitespace(text)
    text := StrLower(text)
    return StrReplace(text, " ", "_")
}

/**
 * Convert to SCREAMING_SNAKE_CASE (all uppercase, underscores)
 * @param text {String} - Input text
 * @returns {String} - SCREAMING_SNAKE_CASE text
 */
Export ToScreamingSnakeCase(text) {
    text := CollapseWhitespace(text)
    text := StrUpper(text)
    return StrReplace(text, " ", "_")
}

/**
 * Convert to kebab-case (all lowercase, dashes)
 * @param text {String} - Input text
 * @returns {String} - kebab-case text
 */
Export ToKebabCase(text) {
    text := CollapseWhitespace(text)
    text := StrLower(text)
    return StrReplace(text, " ", "-")
}

/**
 * Capitalize first letter only
 * @param text {String} - Input text
 * @returns {String} - Capitalized text
 */
Export Capitalize(text) {
    if text = ""
        return ""
    return Format("{1:U}{2:L}", SubStr(text, 1, 1), SubStr(text, 2))
}

/**
 * Reverse string
 * @param text {String} - Input text
 * @returns {String} - Reversed text
 */
Export Reverse(text) {
    result := ""
    Loop Parse, text
        result := A_LoopField result
    return result
}

/**
 * Truncate string to max length with suffix
 * @param text {String} - Input text
 * @param maxLen {Number} - Maximum length
 * @param suffix {String} - Suffix to add (default: "...")
 * @returns {String} - Truncated text
 */
Export Truncate(text, maxLen, suffix := "...") {
    if StrLen(text) <= maxLen
        return text
    return SubStr(text, 1, maxLen - StrLen(suffix)) suffix
}

/**
 * Repeat string n times
 * @param text {String} - Input text
 * @param count {Number} - Repetition count
 * @returns {String} - Repeated text
 */
Export Repeat(text, count) {
    result := ""
    Loop count
        result .= text
    return result
}

/**
 * Pad string to length with character
 * @param text {String} - Input text
 * @param length {Number} - Target length
 * @param char {String} - Padding character (default: " ")
 * @returns {String} - Padded text
 */
Export PadLeft(text, length, char := " ") {
    padLen := length - StrLen(text)
    if padLen <= 0
        return text
    return Repeat(char, padLen) text
}

/**
 * Pad string on right
 * @param text {String} - Input text
 * @param length {Number} - Target length
 * @param char {String} - Padding character (default: " ")
 * @returns {String} - Padded text
 */
Export PadRight(text, length, char := " ") {
    padLen := length - StrLen(text)
    if padLen <= 0
        return text
    return text Repeat(char, padLen)
}

/**
 * Count word occurrences
 * @param text {String} - Input text
 * @returns {Number} - Word count
 */
Export WordCount(text) {
    text := CollapseWhitespace(text)
    if text = ""
        return 0
    return StrSplit(text, " ").Length
}

/**
 * Check if string starts with substring
 * @param text {String} - Input text
 * @param prefix {String} - Prefix to check
 * @returns {Boolean} - True if starts with prefix
 */
Export StartsWith(text, prefix) {
    return SubStr(text, 1, StrLen(prefix)) = prefix
}

/**
 * Check if string ends with substring
 * @param text {String} - Input text
 * @param suffix {String} - Suffix to check
 * @returns {Boolean} - True if ends with suffix
 */
Export EndsWith(text, suffix) {
    suffixLen := StrLen(suffix)
    return SubStr(text, -suffixLen + 1) = suffix
}

/**
 * Check if string contains substring (case-sensitive)
 * @param text {String} - Input text
 * @param search {String} - String to search for
 * @returns {Boolean} - True if contains
 */
Export Contains (text, search) {
    return InStr(text, search) > 0
}

/**
 * Count substring occurrences
 * @param text {String} - Input text
 * @param search {String} - Substring to count
 * @returns {Number} - Occurrence count
 */
Export CountOccurrences(text, search) {
    if search = ""
        return 0

    count := 0
    pos := 1

    Loop {
        pos := InStr(text, search, , pos)
        if !pos
            break
        count++
        pos += StrLen(search)
    }

    return count
}

/**
 * Remove all occurrences of substring
 * @param text {String} - Input text
 * @param remove {String} - Substring to remove
 * @returns {String} - Cleaned text
 */
Export Remove(text, remove) {
    return StrReplace(text, remove, "")
}

/**
 * Replace all occurrences
 * @param text {String} - Input text
 * @param search {String} - String to search for
 * @param replace {String} - Replacement string
 * @returns {String} - Modified text
 */
Export ReplaceAll(text, search, replace) {
    return StrReplace(text, search, replace)
}

/**
 * Split string into lines
 * @param text {String} - Input text
 * @returns {Array} - Array of lines
 */
Export SplitLines(text) {
    return StrSplit(text, "`n", "`r")
}

/**
 * Join array with separator
 * @param arr {Array} - Array of strings
 * @param sep {String} - Separator (default: "")
 * @returns {String} - Joined string
 */
Export Join(arr, sep := "") {
    result := ""
    for index, value in arr
        result .= value (index < arr.Length ? sep : "")
    return result
}
