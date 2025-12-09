#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; UUID Generator - Universally Unique Identifier
; Demonstrates random ID generation and validation

class UUID {
    static Generate() {
        hex := "0123456789abcdef"
        uuid := ""

        Loop 36 {
            if A_Index = 9 || A_Index = 14 || A_Index = 19 || A_Index = 24
                uuid .= "-"
            else if A_Index = 15
                uuid .= "4"  ; Version 4
            else if A_Index = 20
                uuid .= SubStr(hex, (Random(0, 3) | 8) + 1, 1)  ; Variant
            else
                uuid .= SubStr(hex, Random(1, 16), 1)
        }

        return uuid
    }

    static IsValid(uuid) {
        return RegExMatch(uuid, "^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$")
    }
    
    static Parse(uuid) {
        if !this.IsValid(uuid)
            return ""
        
        parts := StrSplit(uuid, "-")
        return Map(
            "timeLow", parts[1],
            "timeMid", parts[2],
            "timeHiAndVersion", parts[3],
            "clockSeq", parts[4],
            "node", parts[5],
            "version", 4
        )
    }
}

; Slug Generator - URL-friendly strings
class Slug {
    static Generate(text, separator := "-") {
        text := StrLower(text)
        text := RegExReplace(text, "[^\w\s-]", "")
        text := RegExReplace(text, "[\s_]+", separator)
        text := RegExReplace(text, separator "{2,}", separator)
        text := Trim(text, separator)
        return text
    }

    static Unique(text, existing := "") {
        base := this.Generate(text)

        if !existing || !existing.Length
            return base

        slug := base
        counter := 1

        while this.Contains(existing, slug) {
            counter++
            slug := base "-" counter
        }

        return slug
    }

    static Contains(arr, value) {
        for item in arr
            if item = value
                return true
        return false
    }
}

; Demo - UUID
uuids := []
Loop 5
    uuids.Push(UUID.Generate())

result := "Generated UUIDs:`n"
for id in uuids
    result .= id " (valid: " UUID.IsValid(id) ")`n"

MsgBox(result)

; Demo - Slugs
titles := [
    "Hello World!",
    "How to Build a REST API",
    "C++ vs Python: A Comparison",
    "  Multiple   Spaces   Test  "
]

existing := []
result := "Generated Slugs:`n"
for title in titles {
    s := Slug.Unique(title, existing)
    existing.Push(s)
    result .= '"' title '" -> ' s "`n"
}

; Duplicate title test
s := Slug.Unique("Hello World!", existing)
existing.Push(s)
result .= '"Hello World!" (duplicate) -> ' s "`n"

MsgBox(result)
