#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * FileRead - Advanced Encoding and Character Set Handling
 * ============================================================================
 * 
 * Demonstrates advanced encoding operations including:
 * - Multiple character encoding formats
 * - BOM (Byte Order Mark) detection
 * - Encoding conversion
 * - Multi-language text support
 * - Binary vs text mode reading
 * 
 * @description Advanced encoding examples for FileRead function
 * @author AutoHotkey Foundation
 * @version 1.0.0
 * @see https://www.autohotkey.com/docs/v2/lib/FileRead.htm
 */

; ============================================================================
; Example 1: UTF-8 with BOM vs without BOM
; ============================================================================

Example1_UTF8_BOM() {
    withBOM := A_Temp "\utf8_with_bom.txt"
    withoutBOM := A_Temp "\utf8_without_bom.txt"

    ; Sample text with special characters
    testText := "Hello World! 你好世界! こんにちは! مرحبا بالعالم!"

    try {
        ; Write UTF-8 with BOM (default for FileAppend)
        FileDelete(withBOM)
        FileAppend(testText, withBOM, "UTF-8")

        ; Write UTF-8 without BOM
        FileDelete(withoutBOM)
        FileAppend(testText, withoutBOM, "UTF-8-RAW")

        ; Read both files
        contentBOM := FileRead(withBOM, "UTF-8")
        contentRaw := FileRead(withoutBOM, "UTF-8")

        ; Display results
        output := "UTF-8 Encoding Comparison:`n`n"
        output .= "With BOM: " contentBOM "`n`n"
        output .= "Without BOM: " contentRaw "`n`n"

        ; Check file sizes
        sizeBOM := FileGetSize(withBOM)
        sizeRaw := FileGetSize(withoutBOM)

        output .= "File Size with BOM: " sizeBOM " bytes`n"
        output .= "File Size without BOM: " sizeRaw " bytes`n"
        output .= "BOM adds: " (sizeBOM - sizeRaw) " bytes"

        MsgBox(output, "UTF-8 BOM Comparison")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(withBOM)
        FileDelete(withoutBOM)
    }
}

; ============================================================================
; Example 2: Multi-Encoding Support
; ============================================================================

Example2_MultiEncoding() {
    baseFile := A_Temp "\encoding_test_"

    ; Define test encodings
    encodings := [
        "UTF-8",
        "UTF-16",
        "CP1252",     ; Western European
        "CP1251",     ; Cyrillic
        "CP932",      ; Japanese Shift-JIS
        "CP936"       ; Simplified Chinese GBK
    ]

    ; Test strings for different languages
    testStrings := Map(
        "UTF-8", "English: Hello! French: Bonjour! Spanish: ¡Hola!",
        "UTF-16", "Greek: Γειά σου! Russian: Привет! Arabic: مرحبا",
        "CP1252", "German: Größe, Price: €100",
        "CP1251", "Russian: Привет Мир!",
        "CP932", "Japanese: こんにちは世界",
        "CP936", "Chinese: 你好世界"
    )

    results := Map()

    try {
        ; Write and read with each encoding
        for encoding in encodings {
            fileName := baseFile . encoding . ".txt"

            ; Get appropriate test string
            testText := testStrings.Has(encoding) ? testStrings[encoding] : "Test: " encoding

            try {
                ; Write with encoding
                FileDelete(fileName)
                FileAppend(testText, fileName, encoding)

                ; Read back with same encoding
                content := FileRead(fileName, encoding)

                ; Verify content matches
                match := (content = testText) ? "✓ Match" : "✗ Mismatch"

                results[encoding] := Map(
                    "success", true,
                    "content", content,
                    "size", FileGetSize(fileName),
                    "match", match
                )

                FileDelete(fileName)

            } catch as err {
                results[encoding] := Map(
                    "success", false,
                    "error", err.Message
                )
            }
        }

        ; Display results
        output := "Multi-Encoding Test Results:`n`n"

        for encoding, result in results {
            output .= encoding ":`n"

            if result["success"] {
                output .= "  Status: " result["match"] "`n"
                output .= "  Size: " result["size"] " bytes`n"
                output .= "  Content: " SubStr(result["content"], 1, 40)
                if StrLen(result["content"]) > 40
                    output .= "..."
                output .= "`n`n"
            } else {
                output .= "  Error: " result["error"] "`n`n"
            }
        }

        MsgBox(output, "Multi-Encoding Support")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 3: Encoding Detection and Auto-Conversion
; ============================================================================

Example3_EncodingDetection() {
    testFile := A_Temp "\test_detect.txt"

    ; Create files with different encodings
    encodings := ["UTF-8", "UTF-16", "CP1252"]
    testContent := "Testing encoding detection: Ñoño, Größe, €100"

    try {
        for encoding in encodings {
            ; Write with specific encoding
            FileDelete(testFile)
            FileAppend(testContent, testFile, encoding)

            ; Try to detect and read
            detected := DetectEncoding(testFile)

            ; Read with detected encoding
            content := FileRead(testFile, detected.encoding)

            ; Display results
            output := "Original Encoding: " encoding "`n"
            output .= "Detected Encoding: " detected.encoding "`n"
            output .= "Confidence: " detected.confidence "`n"
            output .= "BOM Found: " (detected.bom ? "Yes" : "No") "`n`n"
            output .= "Content: " content

            MsgBox(output, "Encoding Detection - " encoding)
        }

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(testFile)
    }

    ; Encoding detection function
    DetectEncoding(filePath) {
        ; Read first few bytes to check for BOM
        file := FileOpen(filePath, "r")

        if !file
            throw Error("Cannot open file")

        ; Read first 4 bytes
        bom := file.RawRead(Buffer(4), 4)
        file.Close()

        ; Check for BOM signatures
        bomData := FileRead(filePath, "RAW")

        result := Map(
            "encoding", "UTF-8",  ; Default
            "bom", false,
            "confidence", "Low"
        )

        ; Check UTF-8 BOM (EF BB BF)
        if (bom >= 3) {
            b := Buffer(4)
            file := FileOpen(filePath, "r")
            file.RawRead(b, 3)
            file.Close()

            if (NumGet(b, 0, "UChar") = 0xEF &&
                NumGet(b, 1, "UChar") = 0xBB &&
                NumGet(b, 2, "UChar") = 0xBF) {
                result["encoding"] := "UTF-8"
                result["bom"] := true
                result["confidence"] := "High"
                return result
            }
        }

        ; Check UTF-16 LE BOM (FF FE)
        if (bom >= 2) {
            file := FileOpen(filePath, "r")
            b := Buffer(2)
            file.RawRead(b, 2)
            file.Close()

            if (NumGet(b, 0, "UChar") = 0xFF &&
                NumGet(b, 1, "UChar") = 0xFE) {
                result["encoding"] := "UTF-16"
                result["bom"] := true
                result["confidence"] := "High"
                return result
            }
        }

        ; No BOM found, use heuristics
        result["confidence"] := "Medium"
        return result
    }
}

; ============================================================================
; Example 4: Reading Multi-Language Configuration Files
; ============================================================================

Example4_MultiLanguageConfig() {
    configFile := A_Temp "\multilang_config.txt"

    ; Create multi-language configuration
    configContent := "
    (
    [English]
    title=Welcome
    message=Hello, World!

    [Spanish]
    title=Bienvenido
    message=¡Hola, Mundo!

    [French]
    title=Bienvenue
    message=Bonjour, le monde!

    [German]
    title=Willkommen
    message=Hallo, Welt! Größe: €100

    [Russian]
    title=Добро пожаловать
    message=Привет, мир!

    [Japanese]
    title=ようこそ
    message=こんにちは、世界！

    [Chinese]
    title=欢迎
    message=你好，世界！

    [Arabic]
    title=أهلا بك
    message=مرحبا بالعالم!
    )"

    try {
        ; Write with UTF-8 encoding to support all characters
        FileAppend(configContent, configFile, "UTF-8")

        ; Read with UTF-8
        content := FileRead(configFile, "UTF-8")

        ; Parse and display
        languages := ParseMultiLangConfig(content)

        ; Display all languages
        output := "Multi-Language Configuration:`n`n"

        for lang, data in languages {
            output .= lang ":`n"
            output .= "  Title: " data["title"] "`n"
            output .= "  Message: " data["message"] "`n`n"
        }

        MsgBox(output, "Multi-Language Support")

        ; Test specific language retrieval
        if languages.Has("Japanese") {
            japanese := languages["Japanese"]
            MsgBox("日本語テスト:`n`n" .
                "Title: " japanese["title"] "`n" .
                "Message: " japanese["message"],
                "Japanese Text")
        }

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(configFile)
    }

    ; Parse multi-language config
    ParseMultiLangConfig(content) {
        config := Map()
        currentLang := ""

        for line in StrSplit(content, "`n", "`r") {
            line := Trim(line)

            if !line
                continue

            ; Check for language section
            if RegExMatch(line, "^\[(.*)\]$", &match) {
                currentLang := match[1]
                config[currentLang] := Map()
            }
            ; Check for key=value pair
            else if RegExMatch(line, "^([^=]+)=(.*)$", &match) && currentLang {
                key := Trim(match[1])
                value := Trim(match[2])
                config[currentLang][key] := value
            }
        }

        return config
    }
}

; ============================================================================
; Example 5: Binary File Reading vs Text Mode
; ============================================================================

Example5_BinaryVsText() {
    textFile := A_Temp "\text_mode.txt"
    binaryFile := A_Temp "\binary_mode.bin"

    try {
        ; Create text file with line endings
        textContent := "Line 1`r`nLine 2`r`nLine 3"
        FileAppend(textContent, textFile, "UTF-8")

        ; Create binary file
        file := FileOpen(binaryFile, "w")
        file.Write("Binary")
        file.Write(Chr(0))  ; Null byte
        file.Write("Data")
        file.Write(Chr(255))  ; High byte value
        file.Close()

        ; Read text file normally
        textRead := FileRead(textFile, "UTF-8")

        ; Read text file as binary
        textBinary := FileRead(textFile, "RAW")

        ; Read binary file
        binaryRead := FileRead(binaryFile, "RAW")

        ; Display comparison
        output := "Text Mode vs Binary Mode:`n`n"
        output .= "Text File (Text Mode):`n"
        output .= "  Content: " StrReplace(textRead, "`r`n", "\r\n") "`n"
        output .= "  Length: " StrLen(textRead) " chars`n`n"

        output .= "Text File (Binary Mode):`n"
        output .= "  Size: " StrLen(textBinary) " bytes`n`n"

        output .= "Binary File:`n"
        output .= "  Size: " StrLen(binaryRead) " bytes`n"
        output .= "  Contains null bytes: Yes`n"

        MsgBox(output, "Binary vs Text Reading")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(textFile)
        FileDelete(binaryFile)
    }
}

; ============================================================================
; Example 6: Reading Files with Different Line Endings
; ============================================================================

Example6_LineEndings() {
    baseFile := A_Temp "\line_endings_"

    ; Test different line ending styles
    endings := Map(
        "Windows", "`r`n",
        "Unix", "`n",
        "Mac", "`r"
    )

    content := ["Line 1", "Line 2", "Line 3"]

    try {
        for style, ending in endings {
            fileName := baseFile . style . ".txt"

            ; Create file with specific line endings
            fileContent := ""
            for index, line in content {
                fileContent .= line
                if index < content.Length
                    fileContent .= ending
            }

            FileAppend(fileContent, fileName, "UTF-8")

            ; Read and analyze
            readContent := FileRead(fileName, "UTF-8")

            ; Count different line ending types
            crlfCount := StrLen(readContent) - StrLen(StrReplace(readContent, "`r`n", ""))
            lfCount := StrLen(readContent) - StrLen(StrReplace(readContent, "`n", ""))
            crCount := StrLen(readContent) - StrLen(StrReplace(readContent, "`r", ""))

            ; Display results
            output := "File Type: " style "`n`n"
            output .= "Content:`n" readContent "`n`n"
            output .= "Line Analysis:`n"
            output .= "  CRLF (\\r\\n): " (crlfCount / 2) "`n"
            output .= "  LF (\\n): " (lfCount - crlfCount / 2) "`n"
            output .= "  CR (\\r): " (crCount - crlfCount / 2) "`n"

            ; Split by lines
            lines := StrSplit(readContent, "`n", "`r")
            output .= "`nLines extracted: " lines.Length

            MsgBox(output, style . " Line Endings")

            FileDelete(fileName)
        }

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 7: Encoding Conversion Utility
; ============================================================================

Example7_EncodingConversion() {
    sourceFile := A_Temp "\source_encoding.txt"
    targetFile := A_Temp "\target_encoding.txt"

    ; Sample text
    testText := "Conversion Test: English, Español, Français, Deutsch (€100), 日本語, 中文"

    try {
        ; Write in UTF-16
        FileAppend(testText, sourceFile, "UTF-16")

        ; Read and convert
        result := ConvertFileEncoding(sourceFile, targetFile, "UTF-16", "UTF-8")

        if result.success {
            ; Verify conversion
            sourceContent := FileRead(sourceFile, "UTF-16")
            targetContent := FileRead(targetFile, "UTF-8")

            output := "Encoding Conversion Results:`n`n"
            output .= "Source Format: UTF-16`n"
            output .= "Target Format: UTF-8`n`n"
            output .= "Source Size: " FileGetSize(sourceFile) " bytes`n"
            output .= "Target Size: " FileGetSize(targetFile) " bytes`n`n"
            output .= "Content Match: " (sourceContent = targetContent ? "Yes" : "No") "`n`n"
            output .= "Content:`n" targetContent

            MsgBox(output, "Encoding Conversion")
        } else {
            MsgBox("Conversion failed: " result.error, "Error", 16)
        }

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(sourceFile)
        FileDelete(targetFile)
    }

    ; Encoding conversion function
    ConvertFileEncoding(source, target, sourceEnc, targetEnc) {
        try {
            ; Read with source encoding
            content := FileRead(source, sourceEnc)

            ; Write with target encoding
            FileDelete(target)
            FileAppend(content, target, targetEnc)

            return Map("success", true)

        } catch as err {
            return Map("success", false, "error", err.Message)
        }
    }
}

; ============================================================================
; Run Examples
; ============================================================================

; Uncomment to run individual examples:
; Example1_UTF8_BOM()
; Example2_MultiEncoding()
; Example3_EncodingDetection()
; Example4_MultiLanguageConfig()
; Example5_BinaryVsText()
; Example6_LineEndings()
; Example7_EncodingConversion()

; Run all examples
RunAllExamples() {
    examples := [{
        name: "UTF-8 BOM Comparison", func: Example1_UTF8_BOM }, {
            name: "Multi-Encoding Support", func: Example2_MultiEncoding }, {
                name: "Encoding Detection", func: Example3_EncodingDetection }, {
                    name: "Multi-Language Config", func: Example4_MultiLanguageConfig }, {
                        name: "Binary vs Text Mode", func: Example5_BinaryVsText }, {
                            name: "Line Endings", func: Example6_LineEndings }, {
                                name: "Encoding Conversion", func: Example7_EncodingConversion
                            }
    ]

    for example in examples {
        result := MsgBox("Run: " example.name "?", "FileRead Encoding Examples", 4)
        if result = "Yes"
            example.func.Call()
    }
}

; Uncomment to run all examples interactively:
; RunAllExamples()

