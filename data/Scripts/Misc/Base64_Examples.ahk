#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Base64 Encoding/Decoding Examples - thqby/ahk2_lib
*
* Practical examples for Base64 encoding and decoding
* Library: https://github.com/thqby/ahk2_lib/blob/master/Base64.ahk
*
* To use these examples:
* ; #Include <Base64>
*/

; Provide a minimal Base64 helper when the library is not included.
if !IsSet(Base64) {
    class Base64 {
        static Encode(text, encoding := "UTF-8") {
            byteCount := StrPut(text, encoding)
            buffer := Buffer(byteCount)
            StrPut(text, buffer, encoding)
            dataLen := byteCount - (encoding = "UTF-16" ? 2 : 1)  ; drop null terminator

            outLen := 0
            DllCall("Crypt32\\CryptBinaryToString", "ptr", buffer.Ptr, "uint", dataLen, "uint", 0x1, "ptr", 0, "uint*", outLen)
            outBuf := Buffer(outLen * 2, 0)
            DllCall("Crypt32\\CryptBinaryToString", "ptr", buffer.Ptr, "uint", dataLen, "uint", 0x1, "ptr", outBuf.Ptr, "uint*", outLen)
            return StrGet(outBuf, outLen)
        }

        static Decode(encoded) {
            bytes := 0
            if !DllCall("Crypt32\\CryptStringToBinary", "str", encoded, "uint", 0, "uint", 0x1, "ptr", 0, "uint*", bytes, "ptr", 0, "ptr", 0)
                throw Error("Invalid Base64 string.")

            out := Buffer(bytes, 0)
            if !DllCall("Crypt32\\CryptStringToBinary", "str", encoded, "uint", 0, "uint", 0x1, "ptr", out.Ptr, "uint*", bytes, "ptr", 0, "ptr", 0)
                throw Error("Invalid Base64 string.")
            return out
        }
    }
}

/**
* Example 1: Basic String Encoding
*/
BasicStringEncodingExample() {
    text := "Hello, World! This is a test message."

    ; Encode string to Base64
    encoded := Base64.Encode(text)

    MsgBox("Original Text:`n" text "`n`nBase64 Encoded:`n" encoded)
}

/**
* Example 2: Basic String Decoding
*/
BasicStringDecodingExample() {
    ; Base64 encoded string
    encoded := "SGVsbG8sIFdvcmxkISBUaGlzIGlzIGEgdGVzdCBtZXNzYWdlLg=="

    ; Decode Base64 to string
    decoded := StrGet(Base64.Decode(encoded), "UTF-8")

    MsgBox("Base64 String:`n" encoded "`n`nDecoded Text:`n" decoded)
}

/**
* Example 3: Encode/Decode UTF-8 Text
*/
UTF8EncodingExample() {
    ; UTF-8 text with special characters
    text := "Hello 世界! Привет мир! مرحبا بالعالم"

    ; Encode to Base64
    encoded := Base64.Encode(text)

    ; Decode back to UTF-8
    buffer := Base64.Decode(encoded)
    decoded := StrGet(buffer, "UTF-8")

    output := "Original UTF-8 Text:`n" text "`n`n"
    output .= "Base64 Encoded:`n" encoded "`n`n"
    output .= "Decoded Text:`n" decoded "`n`n"
    output .= "Match: " (text = decoded ? "✓ Yes" : "✗ No")

    MsgBox(output)
}

/**
* Example 4: Encode Binary File
*/
EncodeBinaryFileExample() {
    ; Create a small test file
    testFile := A_ScriptDir "\test_binary.dat"
    testData := "Binary data: " Chr(0) Chr(255) Chr(127) Chr(1) Chr(254)

    ; Write test data
    file := FileOpen(testFile, "w")
    file.Write(testData)
    file.Close()

    ; Read file as binary
    file := FileOpen(testFile, "r")
    fileSize := file.Length
    buffer := Buffer(fileSize)
    file.RawRead(buffer, fileSize)
    file.Close()

    ; Encode to Base64
    encoded := Base64.Encode(buffer)

    output := "File: " testFile "`n"
    output .= "Size: " fileSize " bytes`n`n"
    output .= "Base64 Encoded:`n" encoded "`n`n"
    output .= "You can now transmit this binary data as text!"

    MsgBox(output)

    ; Cleanup
    FileDelete(testFile)
}

/**
* Example 5: Decode Base64 to File
*/
DecodeToFileExample() {
    ; Base64 encoded data (small image or binary data)
    encoded := "VGhpcyBpcyBhIHRlc3QgZmlsZSB3aXRoIGJpbmFyeSBkYXRhIQ=="

    ; Decode
    buffer := Base64.Decode(encoded)

    ; Write to file
    outputFile := A_ScriptDir "\decoded_file.dat"
    file := FileOpen(outputFile, "w")
    file.RawWrite(buffer)
    file.Close()

    MsgBox("Base64 data decoded and saved to:`n" outputFile "`n`nSize: " buffer.Size " bytes")

    ; Cleanup
    FileDelete(outputFile)
}

/**
* Example 6: Email Attachment Encoding
* Simulates how email attachments are encoded
*/
EmailAttachmentExample() {
    ; Create simulated attachment data
    attachmentName := "document.txt"
    attachmentContent := "This is an important document.`nIt has multiple lines.`nAnd needs to be sent via email."

    ; Encode attachment
    encoded := Base64.Encode(attachmentContent)

    ; Create MIME-style email part
    mimeData := ""
    mimeData .= "Content-Type: text/plain; name=`"" attachmentName "`"`n"
    mimeData .= "Content-Transfer-Encoding: base64`n"
    mimeData .= "Content-Disposition: attachment; filename=`"" attachmentName "`"`n`n"
    mimeData .= encoded

    output := "Email Attachment (MIME Format):`n`n"
    output .= mimeData "`n`n"
    output .= "This is how attachments are encoded in emails!"

    MsgBox(output)
}

/**
* Example 7: URL-Safe Base64
* Useful for URLs and filenames
*/
URLSafeBase64Example() {
    text := "https://example.com/api?param=value&token=abc123"

    ; Encode to Base64
    encoded := Base64.Encode(text)

    ; Make URL-safe (replace + with - and / with _)
    urlSafe := StrReplace(encoded, "+", "-")
    urlSafe := StrReplace(urlSafe, "/", "_")
    urlSafe := RTrim(urlSafe, "=")  ; Remove padding

    output := "Original URL:`n" text "`n`n"
    output .= "Standard Base64:`n" encoded "`n`n"
    output .= "URL-Safe Base64:`n" urlSafe "`n`n"
    output .= "Can be safely used in URLs and filenames!"

    MsgBox(output)
}

/**
* Example 8: Encode Credentials (Basic Auth)
*/
BasicAuthExample() {
    username := "admin"
    password := "secretP@ssw0rd"

    ; Create credentials string
    credentials := username ":" password

    ; Encode for HTTP Basic Authentication
    encoded := Base64.Encode(credentials)

    ; Create Authorization header
    authHeader := "Authorization: Basic " encoded

    output := "HTTP Basic Authentication:`n`n"
    output .= "Username: " username "`n"
    output .= "Password: " password "`n`n"
    output .= "Credentials: " credentials "`n`n"
    output .= "Base64 Encoded:`n" encoded "`n`n"
    output .= "HTTP Header:`n" authHeader "`n`n"
    output .= "Note: This is for demonstration only.`nUse HTTPS in production!"

    MsgBox(output)
}

/**
* Example 9: Data URI Scheme
* Embed small images/files in HTML/CSS
*/
DataURIExample() {
    ; Create small SVG image
    svgContent := '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100"><circle cx="50" cy="50" r="40" fill="red"/></svg>'

    ; Encode to Base64
    encoded := Base64.Encode(svgContent)

    ; Create Data URI
    dataURI := "data:image/svg+xml;base64," encoded

    output := "SVG Content:`n" svgContent "`n`n"
    output .= "Base64 Encoded:`n" encoded "`n`n"
    output .= "Data URI (use in HTML img src):`n" dataURI "`n`n"
    output .= "Example HTML:`n<img src=`"" dataURI "`" />"

    MsgBox(output)
}

/**
* Example 10: Secure Token Generation
*/
SecureTokenExample() {
    ; Generate random token data
    GenerateRandomBytes(size) {
        buffer := Buffer(size)
        Loop size {
            NumPut("UChar", Random(0, 255), buffer, A_Index - 1)
        }
        return buffer
    }

    ; Create session token
    CreateSessionToken() {
        timestamp := A_Now
        randomBytes := GenerateRandomBytes(16)

        ; Combine timestamp and random data
        tokenData := timestamp
        Loop 16 {
            tokenData .= Chr(NumGet(randomBytes, A_Index - 1, "UChar"))
        }

        ; Encode to Base64
        token := Base64.Encode(tokenData)

        ; Remove padding and make URL-safe
        token := StrReplace(token, "+", "-")
        token := StrReplace(token, "/", "_")
        token := RTrim(token, "=")

        return token
    }

    ; Generate multiple tokens
    output := "Secure Session Tokens:`n`n"

    Loop 5 {
        token := CreateSessionToken()
        output .= "Token " A_Index ": " token "`n"
    }

    output .= "`nThese tokens can be used for:`n"
    output .= "- Session management`n"
    output .= "- API keys`n"
    output .= "- CSRF protection`n"
    output .= "- Download links"

    MsgBox(output)
}

; Display menu
; MsgBox("Base64 Library Examples Loaded`n`n"
;     . "Available Examples:`n`n"
;     . "1. BasicStringEncodingExample() - Encode text to Base64`n"
;     . "2. BasicStringDecodingExample() - Decode Base64 to text`n"
;     . "3. UTF8EncodingExample() - Handle UTF-8 characters`n"
;     . "4. EncodeBinaryFileExample() - Encode binary files`n"
;     . "5. DecodeToFileExample() - Decode to file`n"
;     . "6. EmailAttachmentExample() - MIME encoding`n"
;     . "7. URLSafeBase64Example() - URL-safe encoding`n"
;     . "8. BasicAuthExample() - HTTP Basic Auth`n"
;     . "9. DataURIExample() - Embed in HTML`n"
;     . "10. SecureTokenExample() - Generate tokens`n`n"
;     . "Uncomment any function call below to run")
ExitApp

; Uncomment to run examples:
; BasicStringEncodingExample()
; BasicStringDecodingExample()
; UTF8EncodingExample()
; EncodeBinaryFileExample()
; DecodeToFileExample()
; EmailAttachmentExample()
; URLSafeBase64Example()
; BasicAuthExample()
; DataURIExample()
; SecureTokenExample()
