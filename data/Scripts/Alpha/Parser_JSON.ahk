#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; JSON Parser - Complete JSON parsing and stringification
; Demonstrates recursive descent parsing

class JSON {
    ; Parse JSON string to AHK object
    static Parse(str) {
        parser := JSONParser(str)
        return parser.Parse()
    }

    ; Stringify AHK object to JSON
    static Stringify(obj, indent := "") {
        return this._stringify(obj, indent, "")
    }

    static _stringify(obj, indent, currentIndent) {
        if obj = ""
            return "null"

        if obj is Number
            return String(obj)

        if obj is String {
            ; Escape special characters
            escaped := obj
            escaped := StrReplace(escaped, "\", "\\")
            escaped := StrReplace(escaped, '"', '\"')
            escaped := StrReplace(escaped, "`n", "\n")
            escaped := StrReplace(escaped, "`r", "\r")
            escaped := StrReplace(escaped, "`t", "\t")
            return '"' escaped '"'
        }

        if obj is Array {
            if !obj.Length
                return "[]"

            items := []
            newIndent := indent ? currentIndent indent : ""

            for item in obj
                items.Push(this._stringify(item, indent, newIndent))

            if indent {
                sep := ",`n" newIndent
                return "[`n" newIndent this._join(items, sep) "`n" currentIndent "]"
            }
            return "[" this._join(items, ",") "]"
        }

        if obj is Map || IsObject(obj) {
            entries := []
            newIndent := indent ? currentIndent indent : ""

            ; Handle both Map and object
            if obj is Map {
                for key, value in obj
                    entries.Push('"' key '":' (indent ? " " : "") this._stringify(value, indent, newIndent))
            } else {
                for key, value in obj.OwnProps()
                    entries.Push('"' key '":' (indent ? " " : "") this._stringify(value, indent, newIndent))
            }

            if !entries.Length
                return "{}"

            if indent {
                sep := ",`n" newIndent
                return "{`n" newIndent this._join(entries, sep) "`n" currentIndent "}"
            }
            return "{" this._join(entries, ",") "}"
        }

        ; Boolean
        if obj = true || obj = 1 && Type(obj) = "Integer" && String(obj) = "1"
            return "true"
        if obj = false || obj = 0 && Type(obj) = "Integer" && String(obj) = "0"
            return "false"

        return "null"
    }

    static _join(arr, sep) {
        result := ""
        for i, item in arr
            result .= (i > 1 ? sep : "") item
        return result
    }
}

class JSONParser {
    __New(str) {
        this.str := str
        this.pos := 1
        this.len := StrLen(str)
    }

    Parse() {
        this.SkipWhitespace()
        value := this.ParseValue()
        this.SkipWhitespace()

        if this.pos <= this.len
            throw Error("Unexpected character at position " this.pos)

        return value
    }

    ParseValue() {
        this.SkipWhitespace()
        char := this.Peek()

        switch {
            case char = '"':
                return this.ParseString()
            case char = '{':
                return this.ParseObject()
            case char = '[':
                return this.ParseArray()
            case char = 't' || char = 'f':
                return this.ParseBoolean()
            case char = 'n':
                return this.ParseNull()
            case RegExMatch(char, "[\d\-]"):
                return this.ParseNumber()
            default:
                throw Error("Unexpected character: " char " at position " this.pos)
        }
    }

    ParseString() {
        this.Expect('"')
        result := ""

        while this.pos <= this.len {
            char := this.Advance()

            if char = '"'
                return result

            if char = '\' {
                escaped := this.Advance()
                switch escaped {
                    case 'n': result .= "`n"
                    case 'r': result .= "`r"
                    case 't': result .= "`t"
                    case '"': result .= '"'
                    case '\': result .= '\'
                    case '/': result .= '/'
                    case 'u':
                        ; Unicode escape
                        hex := SubStr(this.str, this.pos, 4)
                        this.pos += 4
                        result .= Chr("0x" hex)
                    default:
                        result .= escaped
                }
            } else {
                result .= char
            }
        }

        throw Error("Unterminated string")
    }

    ParseNumber() {
        start := this.pos

        ; Optional minus
        if this.Peek() = '-'
            this.Advance()

        ; Integer part
        while RegExMatch(this.Peek(), "\d")
            this.Advance()

        ; Decimal part
        if this.Peek() = '.' {
            this.Advance()
            while RegExMatch(this.Peek(), "\d")
                this.Advance()
        }

        ; Exponent
        if this.Peek() = 'e' || this.Peek() = 'E' {
            this.Advance()
            if this.Peek() = '+' || this.Peek() = '-'
                this.Advance()
            while RegExMatch(this.Peek(), "\d")
                this.Advance()
        }

        return Number(SubStr(this.str, start, this.pos - start))
    }

    ParseObject() {
        this.Expect('{')
        this.SkipWhitespace()

        obj := Map()

        if this.Peek() = '}' {
            this.Advance()
            return obj
        }

        Loop {
            this.SkipWhitespace()
            key := this.ParseString()
            this.SkipWhitespace()
            this.Expect(':')
            this.SkipWhitespace()
            value := this.ParseValue()
            obj[key] := value
            this.SkipWhitespace()

            if this.Peek() = '}' {
                this.Advance()
                return obj
            }

            this.Expect(',')
        }
    }

    ParseArray() {
        this.Expect('[')
        this.SkipWhitespace()

        arr := []

        if this.Peek() = ']' {
            this.Advance()
            return arr
        }

        Loop {
            this.SkipWhitespace()
            arr.Push(this.ParseValue())
            this.SkipWhitespace()

            if this.Peek() = ']' {
                this.Advance()
                return arr
            }

            this.Expect(',')
        }
    }

    ParseBoolean() {
        if SubStr(this.str, this.pos, 4) = "true" {
            this.pos += 4
            return true
        }
        if SubStr(this.str, this.pos, 5) = "false" {
            this.pos += 5
            return false
        }
        throw Error("Invalid boolean at position " this.pos)
    }

    ParseNull() {
        if SubStr(this.str, this.pos, 4) = "null" {
            this.pos += 4
            return ""
        }
        throw Error("Invalid null at position " this.pos)
    }

    Peek() => this.pos <= this.len ? SubStr(this.str, this.pos, 1) : ""

    Advance() {
        char := this.Peek()
        this.pos++
        return char
    }

    Expect(char) {
        if this.Advance() != char
            throw Error("Expected '" char "' at position " (this.pos - 1))
    }

    SkipWhitespace() {
        while this.pos <= this.len && InStr(" `t`n`r", this.Peek())
            this.pos++
    }
}

; Demo - Parse JSON
jsonStr := '{"name": "Alice", "age": 30, "active": true, "scores": [95, 87, 92], "address": null}'

parsed := JSON.Parse(jsonStr)

result := "JSON Parse Demo:`n`n"
result .= "Input: " jsonStr "`n`n"
result .= "Parsed:`n"
result .= "  name: " parsed["name"] "`n"
result .= "  age: " parsed["age"] "`n"
result .= "  active: " parsed["active"] "`n"
result .= "  scores: "
for s in parsed["scores"]
    result .= s " "
result .= "`n"
result .= "  address: " (parsed["address"] = "" ? "null" : parsed["address"])

MsgBox(result)

; Demo - Stringify
obj := Map(
    "title", "Example",
    "count", 42,
    "enabled", true,
    "items", [1, 2, 3],
    "nested", Map("a", 1, "b", 2)
)

compact := JSON.Stringify(obj)
pretty := JSON.Stringify(obj, "  ")

result := "JSON Stringify Demo:`n`n"
result .= "Compact:`n" compact "`n`n"
result .= "Pretty:`n" pretty

MsgBox(result)

; Demo - Round trip
original := Map(
    "users", [
        Map("id", 1, "name", "Alice"),
        Map("id", 2, "name", "Bob")
    ],
    "meta", Map("total", 2, "page", 1)
)

jsonified := JSON.Stringify(original, "  ")
reparsed := JSON.Parse(jsonified)

result := "Round Trip Demo:`n`n"
result .= "JSON:`n" jsonified "`n`n"
result .= "Re-parsed users:`n"
for user in reparsed["users"]
    result .= "  " user["id"] ": " user["name"] "`n"

MsgBox(result)
