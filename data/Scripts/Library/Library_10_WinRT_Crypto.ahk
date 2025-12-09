#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* WinRT - Cryptography and Security
*
* Demonstrates using Windows.Security.Cryptography for hashing,
* random number generation, and encoding operations.
*
* Library: https://github.com/Lexikos/winrt.ahk
*/

MsgBox("WinRT - Cryptography Example`n`n"
. "Demonstrates Windows Runtime crypto APIs`n"
. "Requires: winrt.ahk and Windows 10+", , "T3")

/*
; Uncomment to run (requires winrt.ahk):

#Include <winrt.ahk>

; Get cryptography classes
CryptographicBuffer := WinRT('Windows.Security.Cryptography.CryptographicBuffer')
HashAlgorithmProvider := WinRT('Windows.Security.Cryptography.Core.HashAlgorithmProvider')

; Example 1: SHA256 Hashing
MsgBox("Example 1: SHA256 hash...", , "T2")

text := "Hello, World!"

; Convert string to buffer
buffer := CryptographicBuffer.ConvertStringToBinary(text, 0)  ; 0 = Utf8

; Create SHA256 provider
sha256 := HashAlgorithmProvider.OpenAlgorithm("SHA256")

; Compute hash
hashBuffer := sha256.HashData(buffer)
hashHex := CryptographicBuffer.EncodeToHexString(hashBuffer)

MsgBox("SHA256 Hash:`n`n"
. "Text: " text "`n`n"
. "Hash: " hashHex, , "T5")

; Example 2: Different hash algorithms
MsgBox("Example 2: Multiple hash algorithms...", , "T2")

algorithms := ["MD5", "SHA1", "SHA256", "SHA384", "SHA512"]
testText := "AutoHotkey"
testBuffer := CryptographicBuffer.ConvertStringToBinary(testText, 0)

result := "Hashes for '" testText "':`n`n"

for algo in algorithms {
    provider := HashAlgorithmProvider.OpenAlgorithm(algo)
    hash := provider.HashData(testBuffer)
    hashHex := CryptographicBuffer.EncodeToHexString(hash)
    result .= algo ": " SubStr(hashHex, 1, 32) "...`n"
}

MsgBox(result, , "T8")

; Example 3: Cryptographically secure random
MsgBox("Example 3: Secure random generation...", , "T2")

; Generate 16 random bytes
randomBuffer := CryptographicBuffer.GenerateRandom(16)
randomHex := CryptographicBuffer.EncodeToHexString(randomBuffer)

; Generate 32 random bytes for key
keyBuffer := CryptographicBuffer.GenerateRandom(32)
keyHex := CryptographicBuffer.EncodeToHexString(keyBuffer)

MsgBox("Secure Random Data:`n`n"
. "16 bytes: " randomHex "`n`n"
. "32 bytes (key): " keyHex, , "T5")

; Example 4: Base64 encoding/decoding
MsgBox("Example 4: Base64 encoding...", , "T2")

originalText := "This is a test message"
inputBuffer := CryptographicBuffer.ConvertStringToBinary(originalText, 0)

; Encode to Base64
base64 := CryptographicBuffer.EncodeToBase64String(inputBuffer)

; Decode from Base64
decodedBuffer := CryptographicBuffer.DecodeFromBase64String(base64)
decodedText := CryptographicBuffer.ConvertBinaryToString(0, decodedBuffer)

MsgBox("Base64 Encoding:`n`n"
. "Original: " originalText "`n`n"
. "Base64: " base64 "`n`n"
. "Decoded: " decodedText, , "T5")

; Example 5: Hex encoding
MsgBox("Example 5: Hexadecimal encoding...", , "T2")

message := "Secret"
msgBuffer := CryptographicBuffer.ConvertStringToBinary(message, 0)

; Encode to hex
hexString := CryptographicBuffer.EncodeToHexString(msgBuffer)

; Decode from hex
decodedBuffer := CryptographicBuffer.DecodeFromHexString(hexString)
decodedMsg := CryptographicBuffer.ConvertBinaryToString(0, decodedBuffer)

MsgBox("Hexadecimal Encoding:`n`n"
. "Original: " message "`n"
. "Hex: " hexString "`n"
. "Decoded: " decodedMsg, , "T5")

; Example 6: Random password generation
MsgBox("Example 6: Random password generation...", , "T2")

GeneratePassword(length) {
    chars := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()"
    randomBytes := CryptographicBuffer.GenerateRandom(length)

    password := ""
    Loop length {
        ; Get random byte
        byteBuffer := CryptographicBuffer.CreateFromByteArray([randomBytes.GetByte(A_Index - 1)])
        byteValue := randomBytes.GetByte(A_Index - 1)

        ; Map to character
        charIndex := Mod(byteValue, StrLen(chars)) + 1
        password .= SubStr(chars, charIndex, 1)
    }

    return password
}

pass1 := GeneratePassword(16)
pass2 := GeneratePassword(20)
pass3 := GeneratePassword(24)

MsgBox("Secure Passwords:`n`n"
. "16 chars: " pass1 "`n"
. "20 chars: " pass2 "`n"
. "24 chars: " pass3, , "T5")

; Example 7: Compare buffers (timing-safe)
MsgBox("Example 7: Secure buffer comparison...", , "T2")

data1 := "password123"
data2 := "password123"
data3 := "Password123"

buffer1 := CryptographicBuffer.ConvertStringToBinary(data1, 0)
buffer2 := CryptographicBuffer.ConvertStringToBinary(data2, 0)
buffer3 := CryptographicBuffer.ConvertStringToBinary(data3, 0)

compare12 := CryptographicBuffer.Compare(buffer1, buffer2)
compare13 := CryptographicBuffer.Compare(buffer1, buffer3)

MsgBox("Buffer Comparison:`n`n"
. "'" data1 "' == '" data2 "': " (compare12 ? "True" : "False") "`n"
. "'" data1 "' == '" data3 "': " (compare13 ? "True" : "False"), , "T5")
*/

/*
* Key Concepts:
*
* 1. CryptographicBuffer:
*    Convert between strings and binary
*    Encoding/decoding (Base64, Hex)
*    Generate random data
*    Compare buffers securely
*
* 2. Hash Algorithms:
*    MD5 - Legacy, not secure
*    SHA1 - Legacy, deprecated
*    SHA256 - Secure, recommended
*    SHA384 - More secure
*    SHA512 - Most secure
*
* 3. String to Binary:
*    ConvertStringToBinary(text, encoding)
*    0 = Utf8
*    1 = Utf16LE
*    2 = Utf16BE
*
* 4. Binary to String:
*    ConvertBinaryToString(encoding, buffer)
*    Same encoding values as above
*
* 5. Encoding Methods:
*    EncodeToBase64String(buffer)
*    DecodeFromBase64String(string)
*    EncodeToHexString(buffer)
*    DecodeFromHexString(string)
*
* 6. Random Generation:
*    GenerateRandom(length)
*    Cryptographically secure
*    Use for keys, tokens, passwords
*
* 7. Buffer Comparison:
*    Compare(buffer1, buffer2)
*    Timing-safe comparison
*    Prevents timing attacks
*
* 8. Use Cases:
*    ✅ Password hashing
*    ✅ Token generation
*    ✅ Data integrity (checksums)
*    ✅ Secure random IDs
*    ✅ API key generation
*
* 9. Best Practices:
*    ✅ Use SHA256+ for hashing
*    ✅ Use GenerateRandom for security
*    ✅ Never use MD5 for security
*    ✅ Use Compare for password checks
*    ✅ Store hashes, not passwords
*
* 10. Advantages over .NET:
*     ✅ Windows 10+ native
*     ✅ No .NET Framework needed
*     ✅ Modern API design
*     ✅ Async support built-in
*
* 11. Security Notes:
*     ⚠ Hashing != Encryption
*     ⚠ Hashes are one-way
*     ⚠ Use salt for passwords
*     ⚠ Don't roll your own crypto
*
* 12. Related APIs:
*     SymmetricKeyAlgorithmProvider - AES
*     AsymmetricKeyAlgorithmProvider - RSA
*     MacAlgorithmProvider - HMAC
*     KeyDerivationAlgorithmProvider - PBKDF2
*/
