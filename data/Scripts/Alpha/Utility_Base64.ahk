#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Base64 Encoding/Decoding
; Demonstrates binary-to-text encoding

class Base64 {
    static chars := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

    static Encode(str) {
        result := ""
        bytes := []
        
        ; Convert string to byte array
        Loop StrLen(str)
            bytes.Push(Ord(SubStr(str, A_Index, 1)))
        
        ; Process in groups of 3 bytes
        i := 1
        while i <= bytes.Length {
            b1 := bytes[i]
            b2 := i + 1 <= bytes.Length ? bytes[i + 1] : 0
            b3 := i + 2 <= bytes.Length ? bytes[i + 2] : 0
            
            ; Convert 3 bytes to 4 base64 characters
            c1 := (b1 >> 2) + 1
            c2 := (((b1 & 3) << 4) | (b2 >> 4)) + 1
            c3 := (((b2 & 15) << 2) | (b3 >> 6)) + 1
            c4 := (b3 & 63) + 1
            
            result .= SubStr(this.chars, c1, 1)
            result .= SubStr(this.chars, c2, 1)
            result .= i + 1 <= bytes.Length ? SubStr(this.chars, c3, 1) : "="
            result .= i + 2 <= bytes.Length ? SubStr(this.chars, c4, 1) : "="
            
            i += 3
        }
        
        return result
    }

    static Decode(str) {
        result := ""
        str := StrReplace(str, "=", "")
        
        ; Build lookup table
        lookup := Map()
        Loop StrLen(this.chars)
            lookup[SubStr(this.chars, A_Index, 1)] := A_Index - 1
        
        ; Process in groups of 4 characters
        i := 1
        while i <= StrLen(str) {
            c1 := lookup[SubStr(str, i, 1)]
            c2 := i + 1 <= StrLen(str) ? lookup[SubStr(str, i + 1, 1)] : 0
            c3 := i + 2 <= StrLen(str) ? lookup[SubStr(str, i + 2, 1)] : 0
            c4 := i + 3 <= StrLen(str) ? lookup[SubStr(str, i + 3, 1)] : 0
            
            ; Convert 4 base64 characters to 3 bytes
            b1 := (c1 << 2) | (c2 >> 4)
            b2 := ((c2 & 15) << 4) | (c3 >> 2)
            b3 := ((c3 & 3) << 6) | c4
            
            result .= Chr(b1)
            if i + 2 <= StrLen(str)
                result .= Chr(b2)
            if i + 3 <= StrLen(str)
                result .= Chr(b3)
            
            i += 4
        }
        
        return result
    }
    
    static EncodeURL(str) {
        ; URL-safe Base64 (RFC 4648)
        result := this.Encode(str)
        result := StrReplace(result, "+", "-")
        result := StrReplace(result, "/", "_")
        result := RTrim(result, "=")
        return result
    }
    
    static DecodeURL(str) {
        str := StrReplace(str, "-", "+")
        str := StrReplace(str, "_", "/")
        ; Add padding
        while Mod(StrLen(str), 4)
            str .= "="
        return this.Decode(str)
    }
}

; Demo
testStrings := [
    "Hello, World!",
    "AutoHotkey v2",
    "Base64 encoding test",
    "Special chars: !@#$%"
]

result := "Base64 Encoding/Decoding:`n`n"

for str in testStrings {
    encoded := Base64.Encode(str)
    decoded := Base64.Decode(encoded)
    
    result .= "Original: " str "`n"
    result .= "Encoded:  " encoded "`n"
    result .= "Decoded:  " decoded "`n"
    result .= "Match: " (str = decoded) "`n`n"
}

MsgBox(result)

; URL-safe encoding
result := "URL-Safe Base64:`n`n"
testStr := "Hello+World/Test=123"

encoded := Base64.EncodeURL(testStr)
decoded := Base64.DecodeURL(encoded)

result .= "Original: " testStr "`n"
result .= "Standard: " Base64.Encode(testStr) "`n"
result .= "URL-safe: " encoded "`n"
result .= "Decoded:  " decoded

MsgBox(result)
