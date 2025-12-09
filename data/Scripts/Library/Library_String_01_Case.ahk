#Requires AutoHotkey v2.0

; Library: Descolada/AHK-v2-libraries/String.ahk
; Function: String case conversion utilities
; Category: String Manipulation
; Use Case: Text formatting, data normalization

; Example: String case transformations
; Note: Enhanced version available in Descolada/AHK-v2-libraries

DemoStringCase() {
    text := "hello WORLD from AutoHotkey"

    ; Built-in v2 methods
    result := "Original: " text "`n`n"
    result .= "StrUpper: " StrUpper(text) "`n"
    result .= "StrLower: " StrLower(text) "`n"
    result .= "StrTitle: " StrTitle(text) "`n`n"

    ; With String library (enhanced):
    ; #Include <String>
    result .= "Enhanced with String library:`n"
    result .= "- text.ToSnakeCase() → 'hello_world_from_autohotkey'`n"
    result .= "- text.ToCamelCase() → 'helloWorldFromAutohotkey'`n"
    result .= "- text.ToPascalCase() → 'HelloWorldFromAutohotkey'`n"
    result .= "- text.ToKebabCase() → 'hello-world-from-autohotkey'`n`n"

    result .= "Other utilities:`n"
    result .= "- text.Wrap(width, indent)`n"
    result .= "- text.LineCount()`n"
    result .= "- text.SplitPath() ; File path components"

    MsgBox(result, "String Case Demo")
}

; Helper: Title case (first letter of each word capitalized)
StrTitle(str) {
    ; Simple title case implementation
    words := StrSplit(str, " ")
    result := []

    for word in words {
        if (word != "") {
            first := SubStr(word, 1, 1)
            rest := SubStr(word, 2)
            result.Push(StrUpper(first) . StrLower(rest))
        }
    }

    return StrJoin(result, " ")
}

; Helper: Join array with delimiter
StrJoin(arr, delimiter := "") {
    str := ""
    for i, val in arr {
        str .= val
        if (i < arr.Length)
        str .= delimiter
    }
    return str
}

; Run demonstration
DemoStringCase()
