#Requires AutoHotkey v2.0

/**
 * BuiltIn_StrGet_02_Encoding.ahk
 * 
 * DESCRIPTION:
 * Advanced string reading with different text encodings using StrGet.
 * Covers UTF-8, UTF-16, ANSI, and encoding conversion scenarios.
 * 
 * FEATURES:
 * - UTF-16 (wide character) reading
 * - UTF-8 string reading
 * - ANSI/CP0 encoding
 * - Code page specifications
 * - Encoding detection and conversion
 * - International character handling
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - StrGet, Encodings
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - StrGet with encoding parameter
 * - UTF-16 vs UTF-8 comparisons
 * - Code page handling (CP0, CP1252, etc.)
 * - Binary string data interpretation
 * - Multi-byte character reading
 * 
 * LEARNING POINTS:
 * 1. Different encodings use different byte sequences
 * 2. UTF-16 uses 2 bytes per character (BMP)
 * 3. UTF-8 uses 1-4 bytes per character
 * 4. Encoding must match how data was written
 * 5. Windows API typically uses UTF-16
 */

; ================================================================================================
; EXAMPLE 1: UTF-16 vs UTF-8 Reading
; ================================================================================================

Example1_EncodingComparison() {
    str := "Hello, 世界!"

    ; Write as UTF-16
    utf16Buf := Buffer(StrPut(str, "UTF-16") * 2)
    StrPut(str, utf16Buf, "UTF-16")

    ; Write as UTF-8
    utf8Buf := Buffer(StrPut(str, "UTF-8"))
    StrPut(str, utf8Buf, "UTF-8")

    ; Read back
    utf16Str := StrGet(utf16Buf, "UTF-16")
    utf8Str := StrGet(utf8Buf, "UTF-8")

    ; Display results
    result := "UTF-16 vs UTF-8 Encoding:`n`n"
    result .= "Original: '" . str . "'`n`n"

    result .= "UTF-16:`n"
    result .= "  Buffer Size: " . utf16Buf.Size . " bytes`n"
    result .= "  Read String: '" . utf16Str . "'`n`n"

    result .= "UTF-8:`n"
    result .= "  Buffer Size: " . utf8Buf.Size . " bytes`n"
    result .= "  Read String: '" . utf8Str . "'`n`n"

    result .= "Both encodings preserve: " . (utf16Str = utf8Str ? "Yes ✓" : "No")

    MsgBox(result, "Example 1: Encoding Comparison", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: International Characters
; ================================================================================================

Example2_InternationalChars() {
    ; Various international strings
    strings := [{
        text: "English: Hello", encoding: "UTF-8" }, {
            text: "Japanese: こんにちは", encoding: "UTF-8" }, {
                text: "Russian: Привет", encoding: "UTF-8" }, {
                    text: "Arabic: مرحبا", encoding: "UTF-8" }, {
                        text: "Chinese: 你好", encoding: "UTF-8"
                    }
    ]

    ; Write and read each string
    results := []
    loop strings.Length {
        str := strings[A_Index].text
        enc := strings[A_Index].encoding

        buf := Buffer(StrPut(str, enc) * 2)
        StrPut(str, buf, enc)
        readStr := StrGet(buf, enc)

        results.Push({
            original: str,
            read: readStr,
            size: buf.Size,
            match: str = readStr
        })
    }

    ; Display results
    result := "International Character Handling:`n`n"

    loop results.Length {
        r := results[A_Index]
        result .= "Test " . A_Index . ":`n"
        result .= "  String: '" . r.original . "'`n"
        result .= "  Size: " . r.size . " bytes`n"
        result .= "  Match: " . (r.match ? "✓" : "✗") . "`n"
        if A_Index < results.Length
            result .= "`n"
    }

    MsgBox(result, "Example 2: International Characters", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Mixed Encoding Buffer
; ================================================================================================

Example3_MixedEncoding() {
    ; Create buffer with UTF-16 string
    str1 := "First String"
    buf1 := Buffer(StrPut(str1, "UTF-16") * 2)
    StrPut(str1, buf1, "UTF-16")

    ; Create buffer with UTF-8 string
    str2 := "Second String"
    buf2 := Buffer(StrPut(str2, "UTF-8"))
    StrPut(str2, buf2, "UTF-8")

    ; Try reading with correct and incorrect encodings
    utf16Correct := StrGet(buf1, "UTF-16")
    utf16Wrong := StrGet(buf1, "UTF-8")

    utf8Correct := StrGet(buf2, "UTF-8")
    utf8Wrong := StrGet(buf2, "UTF-16")

    ; Display results
    result := "Mixed Encoding Reading:`n`n"

    result .= "UTF-16 Buffer ('" . str1 . "'):`n"
    result .= "  Read as UTF-16: '" . utf16Correct . "' ✓`n"
    result .= "  Read as UTF-8: '" . utf16Wrong . "' (garbled)`n`n"

    result .= "UTF-8 Buffer ('" . str2 . "'):`n"
    result .= "  Read as UTF-8: '" . utf8Correct . "' ✓`n"
    result .= "  Read as UTF-16: '" . utf8Wrong . "' (garbled)`n`n"

    result .= "Key Point: Encoding must match!"

    MsgBox(result, "Example 3: Mixed Encoding", "Icon!")
}

; ================================================================================================
; EXAMPLE 4: Code Page Reading
; ================================================================================================

Example4_CodePages() {
    ; Create string with extended ASCII
    str := "Café résumé"

    ; Write as different code pages
    bufUTF8 := Buffer(StrPut(str, "UTF-8"))
    bufCP1252 := Buffer(StrPut(str, "CP1252"))

    StrPut(str, bufUTF8, "UTF-8")
    StrPut(str, bufCP1252, "CP1252")

    ; Read back
    strUTF8 := StrGet(bufUTF8, "UTF-8")
    strCP1252 := StrGet(bufCP1252, "CP1252")

    ; Display results
    result := "Code Page Reading:`n`n"
    result .= "Original: '" . str . "'`n`n"

    result .= "UTF-8:`n"
    result .= "  Size: " . bufUTF8.Size . " bytes`n"
    result .= "  Read: '" . strUTF8 . "'`n`n"

    result .= "CP1252 (Western European):`n"
    result .= "  Size: " . bufCP1252.Size . " bytes`n"
    result .= "  Read: '" . strCP1252 . "'"

    MsgBox(result, "Example 4: Code Page Reading", "Icon!")
}

; ================================================================================================
; EXAMPLE 5: Byte Order Mark (BOM) Handling
; ================================================================================================

Example5_BOMHandling() {
    str := "Test String"

    ; UTF-8 with BOM
    utf8BOMBuf := Buffer(3 + StrPut(str, "UTF-8"))
    NumPut("UChar", 0xEF, utf8BOMBuf, 0)
    NumPut("UChar", 0xBB, utf8BOMBuf, 1)
    NumPut("UChar", 0xBF, utf8BOMBuf, 2)
    StrPut(str, utf8BOMBuf.Ptr + 3, "UTF-8")

    ; Read with and without BOM offset
    withBOM := StrGet(utf8BOMBuf, "UTF-8")
    withoutBOM := StrGet(utf8BOMBuf.Ptr + 3, "UTF-8")

    ; Display results
    result := "BOM Handling:`n`n"
    result .= "Original: '" . str . "'`n`n"

    result .= "Reading with BOM:`n"
    result .= "  Result: '" . withBOM . "'`n"
    result .= "  (May include BOM character)`n`n"

    result .= "Reading after BOM (offset +3):`n"
    result .= "  Result: '" . withoutBOM . "'`n"
    result .= "  Match: " . (str = withoutBOM ? "✓" : "✗")

    MsgBox(result, "Example 5: BOM Handling", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
                    (
                    StrGet Encoding Examples

                    1. UTF-16 vs UTF-8 Comparison
                    2. International Character Handling
                    3. Mixed Encoding Reading
                    4. Code Page Reading
                    5. Byte Order Mark (BOM) Handling

                    Select an example (1-5) or press Cancel to exit:
                    )"

    choice := InputBox(menu, "StrGet Encoding Examples", "w450 h300")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_EncodingComparison()
        case "2": Example2_InternationalChars()
        case "3": Example3_MixedEncoding()
        case "4": Example4_CodePages()
        case "5": Example5_BOMHandling()
        default: MsgBox("Invalid selection. Please choose 1-5.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()
