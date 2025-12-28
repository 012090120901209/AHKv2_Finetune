#Requires AutoHotkey v2.0

/**
 * BuiltIn_StrPut_02_Encoding.ahk
 * 
 * DESCRIPTION:
 * Advanced string writing with different text encodings using StrPut.
 * Covers UTF-8, UTF-16, ANSI, and encoding conversion scenarios.
 * 
 * FEATURES:
 * - UTF-16 (wide character) writing
 * - UTF-8 string writing
 * - ANSI/CP0 encoding
 * - Code page specifications
 * - Encoding conversion
 * - International character handling
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - StrPut, Encodings
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - StrPut with encoding parameter
 * - UTF-16 vs UTF-8 size differences
 * - Code page writing (CP0, CP1252, etc.)
 * - Binary string data creation
 * - Multi-byte character writing
 * 
 * LEARNING POINTS:
 * 1. Different encodings produce different byte sequences
 * 2. UTF-16 uses 2 bytes per character (BMP)
 * 3. UTF-8 uses 1-4 bytes per character
 * 4. Choose encoding based on target system
 * 5. Buffer size varies by encoding
 */

; ================================================================================================
; EXAMPLE 1: UTF-16 vs UTF-8 Writing
; ================================================================================================

Example1_EncodingComparison() {
    str := "Hello, 世界! 🎉"

    ; Calculate sizes for both encodings
    utf16Size := StrPut(str, "UTF-16") * 2
    utf8Size := StrPut(str, "UTF-8")

    ; Write in both encodings
    utf16Buf := Buffer(utf16Size)
    utf8Buf := Buffer(utf8Size)

    StrPut(str, utf16Buf, "UTF-16")
    StrPut(str, utf8Buf, "UTF-8")

    ; Read back
    utf16Str := StrGet(utf16Buf, "UTF-16")
    utf8Str := StrGet(utf8Buf, "UTF-8")

    ; Display results
    result := "UTF-16 vs UTF-8 Writing:`n`n"
    result .= "Original: '" . str . "'`n"
    result .= "Length: " . StrLen(str) . " characters`n`n"

    result .= "UTF-16:`n"
    result .= "  Buffer Size: " . utf16Size . " bytes`n"
    result .= "  Read Back: '" . utf16Str . "'`n`n"

    result .= "UTF-8:`n"
    result .= "  Buffer Size: " . utf8Size . " bytes`n"
    result .= "  Read Back: '" . utf8Str . "'`n`n"

    result .= "Size Ratio: " . Round(utf16Size / utf8Size, 2) . ":1"

    MsgBox(result, "Example 1: Encoding Comparison", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: International Characters
; ================================================================================================

Example2_InternationalChars() {
    strings := [{
        text: "English: Hello", lang: "English" }, {
            text: "Japanese: こんにちは", lang: "Japanese" }, {
                text: "Russian: Привет", lang: "Russian" }, {
                    text: "Arabic: مرحبا", lang: "Arabic" }, {
                        text: "Chinese: 你好", lang: "Chinese"
                    }
    ]

    results := []
    loop strings.Length {
        str := strings[A_Index].text

        utf16Size := StrPut(str, "UTF-16") * 2
        utf8Size := StrPut(str, "UTF-8")

        utf16Buf := Buffer(utf16Size)
        utf8Buf := Buffer(utf8Size)

        StrPut(str, utf16Buf, "UTF-16")
        StrPut(str, utf8Buf, "UTF-8")

        results.Push({
            lang: strings[A_Index].lang,
            text: str,
            utf16Size: utf16Size,
            utf8Size: utf8Size
        })
    }

    ; Display results
    result := "International Character Writing:`n`n"

    loop results.Length {
        r := results[A_Index]
        result .= r.lang . ":`n"
        result .= "  Text: '" . r.text . "'`n"
        result .= "  UTF-16: " . r.utf16Size . " bytes`n"
        result .= "  UTF-8: " . r.utf8Size . " bytes`n"
        if A_Index < results.Length
            result .= "`n"
    }

    MsgBox(result, "Example 2: International Characters", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Code Page Writing
; ================================================================================================

Example3_CodePages() {
    str := "Café résumé"

    ; Write in different encodings
    bufUTF16 := Buffer(StrPut(str, "UTF-16") * 2)
    bufUTF8 := Buffer(StrPut(str, "UTF-8"))
    bufCP1252 := Buffer(StrPut(str, "CP1252"))

    StrPut(str, bufUTF16, "UTF-16")
    StrPut(str, bufUTF8, "UTF-8")
    StrPut(str, bufCP1252, "CP1252")

    ; Read back
    strUTF16 := StrGet(bufUTF16, "UTF-16")
    strUTF8 := StrGet(bufUTF8, "UTF-8")
    strCP1252 := StrGet(bufCP1252, "CP1252")

    ; Display results
    result := "Code Page Writing:`n`n"
    result .= "Original: '" . str . "'`n`n"

    result .= "UTF-16:`n"
    result .= "  Size: " . bufUTF16.Size . " bytes`n"
    result .= "  Read: '" . strUTF16 . "'`n`n"

    result .= "UTF-8:`n"
    result .= "  Size: " . bufUTF8.Size . " bytes`n"
    result .= "  Read: '" . strUTF8 . "'`n`n"

    result .= "CP1252:`n"
    result .= "  Size: " . bufCP1252.Size . " bytes`n"
    result .= "  Read: '" . strCP1252 . "'"

    MsgBox(result, "Example 3: Code Page Writing", "Icon!")
}

; ================================================================================================
; EXAMPLE 4: Encoding Conversion
; ================================================================================================

Example4_EncodingConversion() {
    str := "Test: 测试"

    ; Write as UTF-8
    utf8Buf := Buffer(StrPut(str, "UTF-8"))
    StrPut(str, utf8Buf, "UTF-8")

    ; Read as UTF-8 and write as UTF-16
    tempStr := StrGet(utf8Buf, "UTF-8")
    utf16Buf := Buffer(StrPut(tempStr, "UTF-16") * 2)
    StrPut(tempStr, utf16Buf, "UTF-16")

    ; Verify final result
    finalStr := StrGet(utf16Buf, "UTF-16")

    ; Display results
    result := "Encoding Conversion:`n`n"
    result .= "Original: '" . str . "'`n`n"

    result .= "Step 1: Write as UTF-8`n"
    result .= "  Size: " . utf8Buf.Size . " bytes`n`n"

    result .= "Step 2: Convert to UTF-16`n"
    result .= "  Size: " . utf16Buf.Size . " bytes`n`n"

    result .= "Final Result: '" . finalStr . "'`n"
    result .= "Match: " . (str = finalStr ? "Yes ✓" : "No")

    MsgBox(result, "Example 4: Encoding Conversion", "Icon!")
}

; ================================================================================================
; EXAMPLE 5: Multi-Language String Storage
; ================================================================================================

Example5_MultiLanguageStorage() {

    ; Create multi-encoding storage
    mls := MultiLangString()
    testStr := "Hello, 世界! 🌍"

    mls.Add(testStr, "UTF-16")
    mls.Add(testStr, "UTF-8")
    mls.Add(testStr, "CP0")

    ; Get info
    info := mls.GetInfo()

    ; Display results
    result := "Multi-Language String Storage:`n`n"
    result .= "Original: '" . testStr . "'`n`n"

    result .= "Stored Encodings:`n"
    for entry in info {
        result .= "  " . entry.encoding . ":`n"
        result .= "    Size: " . entry.size . " bytes`n"
        result .= "    Verified: " . (entry.verified ? "✓" : "✗") . "`n"
    }

    MsgBox(result, "Example 5: Multi-Language Storage", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
                    (
                    StrPut Encoding Examples

                    1. UTF-16 vs UTF-8 Writing
                    2. International Character Writing
                    3. Code Page Writing
                    4. Encoding Conversion
                    5. Multi-Language String Storage

                    Select an example (1-5) or press Cancel to exit:
                    )"

    choice := InputBox(menu, "StrPut Encoding Examples", "w450 h300")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_EncodingComparison()
        case "2": Example2_InternationalChars()
        case "3": Example3_CodePages()
        case "4": Example4_EncodingConversion()
        case "5": Example5_MultiLanguageStorage()
        default: MsgBox("Invalid selection. Please choose 1-5.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()

; Moved class MultiLangString from nested scope
class MultiLangString {
    __New() {
        this.encodings := Map()
    }

    Add(str, encoding) {
        size := encoding = "UTF-16"
            ? StrPut(str, encoding) * 2
            : StrPut(str, encoding)

        buf := Buffer(size)
        StrPut(str, buf, encoding)

        this.encodings[encoding] := {
            buffer: buf,
            size: size,
            string: str
        }
    }

    GetInfo() {
        info := []
        for enc, data in this.encodings {
            info.Push({
                encoding: enc,
                size: data.size,
                verified: StrGet(data.buffer, enc) = data.string
            })
        }
        return info
    }
}
