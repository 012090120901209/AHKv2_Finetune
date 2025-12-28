#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Base64 and URL Encoding Utilities
 * 
 * Demonstrates encoding and decoding text using Base64 and URL encoding
 * for data transmission and storage.
 * 
 * Source: xypha/AHK-v2-scripts - Showcase.ahk
 * Inspired by: https://github.com/xypha/AHK-v2-scripts
 */

MsgBox("Encoding Utilities Demo`n`n"
    . "Functions:`n"
    . "- Base64 Encode/Decode`n"
    . "- URL Encode/Decode`n`n"
    . "Running demonstrations...", , "T3")

; Example 1: Base64 encoding
text1 := "Hello, World! 你好世界"
encoded1 := Base64_Encode(text1)
decoded1 := Base64_Decode(encoded1)

MsgBox("Base64 Encoding:`n`n"
    . "Original: " text1 "`n`n"
    . "Encoded: " encoded1 "`n`n"
    . "Decoded: " decoded1 "`n`n"
    . "Match: " (text1 == decoded1 ? "✓" : "✗"), , "T8")

; Example 2: Base64 with binary-safe text
text2 := "Special chars: !@#$%^&*()_+-=[]{}|;:',.<>?/~"
encoded2 := Base64_Encode(text2)
decoded2 := Base64_Decode(encoded2)

MsgBox("Base64 - Special Characters:`n`n"
    . "Original: " text2 "`n`n"
    . "Encoded: " encoded2 "`n`n"
    . "Decoded: " decoded2, , "T8")

; Example 3: URL encoding
url := "https://example.com/search?q=AutoHotkey v2&lang=en"
encodedURL := URL_Encode(url)
decodedURL := URL_Decode(encodedURL)

MsgBox("URL Encoding:`n`n"
    . "Original: " url "`n`n"
    . "Encoded: " encodedURL "`n`n"
    . "Decoded: " decodedURL, , "T8")

; Example 4: URL encoding with special characters
query := "search term with spaces & symbols!"
encodedQuery := URL_Encode(query)
decodedQuery := URL_Decode(encodedQuery)

MsgBox("URL Encoding - Query String:`n`n"
    . "Original: " query "`n`n"
    . "Encoded: " encodedQuery "`n`n"
    . "Decoded: " decodedQuery, , "T8")

/**
 * Base64_Encode - Encode text to Base64
 * @param {string} text - Text to encode
 * @return {string} Base64-encoded string
 */
Base64_Encode(text) {
    ; Convert string to binary
    bufSize := StrPut(text, "UTF-8")
    buf := Buffer(bufSize)
    StrPut(text, buf, "UTF-8")

    ; Calculate required size for Base64
    DllCall("crypt32\CryptBinaryToStringW",
        "Ptr", buf,
        "UInt", bufSize - 1,
        "UInt", 0x40000001,  ; CRYPT_STRING_BASE64 | CRYPT_STRING_NOCRLF
        "Ptr", 0,
        "UInt*", &outSize := 0)

    ; Encode to Base64
    outBuf := Buffer(outSize * 2)
    DllCall("crypt32\CryptBinaryToStringW",
        "Ptr", buf,
        "UInt", bufSize - 1,
        "UInt", 0x40000001,
        "Ptr", outBuf,
        "UInt*", &outSize)

    return StrGet(outBuf, "UTF-16")
}

/**
 * Base64_Decode - Decode Base64 to text
 * @param {string} base64 - Base64 string
 * @return {string} Decoded text
 */
Base64_Decode(base64) {
    ; Calculate required size
    DllCall("crypt32\CryptStringToBinaryW",
        "Str", base64,
        "UInt", 0,
        "UInt", 0x1,  ; CRYPT_STRING_BASE64
        "Ptr", 0,
        "UInt*", &outSize := 0,
        "Ptr", 0,
        "Ptr", 0)

    ; Decode from Base64
    outBuf := Buffer(outSize)
    DllCall("crypt32\CryptStringToBinaryW",
        "Str", base64,
        "UInt", 0,
        "UInt", 0x1,
        "Ptr", outBuf,
        "UInt*", &outSize,
        "Ptr", 0,
        "Ptr", 0)

    return StrGet(outBuf, outSize, "UTF-8")
}

/**
 * URL_Encode - Encode URL/URI components
 * @param {string} text - Text to encode
 * @return {string} URL-encoded string
 */
URL_Encode(text) {
    result := ""

    Loop Parse, text {
        char := A_LoopField
        code := Ord(char)

        ; Unreserved characters (don't encode)
        if (RegExMatch(char, "[A-Za-z0-9-_.~]")) {
            result .= char
        }
        ; Encode everything else
        else {
            ; Convert to UTF-8 bytes and encode each
            bytes := Buffer(4)
            len := StrPut(char, bytes, "UTF-8") - 1

            Loop len {
                byte := NumGet(bytes, A_Index - 1, "UChar")
                result .= Format("%{:02X}", byte)
            }
        }
    }

    return result
}

/**
 * URL_Decode - Decode URL/URI components
 * @param {string} text - URL-encoded text
 * @return {string} Decoded text
 */
URL_Decode(text) {
    ; Replace + with space
    text := StrReplace(text, "+", " ")

    result := ""
    i := 1

    while (i <= StrLen(text)) {
        char := SubStr(text, i, 1)

        if (char == "%") {
            ; Get hex code
            hex := SubStr(text, i + 1, 2)

            ; Convert hex to decimal
            code := Format("0x{:s}", hex)

            ; Convert to character
            result .= Chr(code)
            i += 3
        } else {
            result .= char
            i++
        }
    }

    return result
}

/*
* Key Concepts:
*
* 1. Base64 Encoding:
*    Binary-to-text encoding
*    A-Z, a-z, 0-9, +, /
*    Padding with =
*    25% size increase
*
* 2. Base64 Use Cases:
*    ✅ Email attachments
*    ✅ Data URLs
*    ✅ API tokens
*    ✅ Embedded images
*    ✅ Binary data in JSON/XML
*
* 3. URL Encoding:
*    Percent encoding (%20 for space)
*    Safe for URLs
*    Unreserved: A-Z, a-z, 0-9, -, _, ., ~
*
* 4. URL Use Cases:
*    ✅ Query parameters
*    ✅ Form data
*    ✅ API requests
*    ✅ File paths in URLs
*
* 5. Windows API:
*    CryptBinaryToStringW - Encode Base64
*    CryptStringToBinaryW - Decode Base64
*    Built into Windows
*
* 6. UTF-8 Handling:
*    StrPut/StrGet for encoding
*    Multi-byte characters
*    Unicode support
*
* 7. Character Encoding:
*    Format("%{:02X}", byte) - Hex format
*    Chr(code) - Code to character
*    Ord(char) - Character to code
*
* 8. Best Practices:
*    ✅ Use UTF-8 encoding
*    ✅ Handle multi-byte chars
*    ✅ Validate input
*    ✅ Error checking
*
* 9. Common Mistakes:
*    ⚠ Forgetting encoding type
*    ⚠ Not handling UTF-8
*    ⚠ Double encoding
*    ⚠ Wrong URL encode scope
*
* 10. Real-World Examples:
*     API Authentication:
*     auth := Base64_Encode("user:pass")
*     header := "Authorization: Basic " auth
*
*     Search Query:
*     q := URL_Encode("AutoHotkey v2")
*     url := "https://google.com/search?q=" q
*
* 11. Performance:
*     Base64: Fast (Windows API)
*     URL: Loop-based (acceptable)
*     Cache if encoding repeatedly
*
* 12. Enhancements:
*     - File encoding/decoding
*     - Clipboard integration
*     - Batch processing
*     - Progress feedback
*/

