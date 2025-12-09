#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; URL Parser - Parses and constructs URLs
; Demonstrates URI component handling

class URL {
    static Parse(url) {
        result := Map()

        ; Protocol
        if RegExMatch(url, "^([a-z]+)://", &m) {
            result["protocol"] := m[1]
            url := SubStr(url, StrLen(m[0]) + 1)
        }

        ; Hash/fragment
        hashPos := InStr(url, "#")
        if hashPos {
            result["hash"] := SubStr(url, hashPos + 1)
            url := SubStr(url, 1, hashPos - 1)
        }

        ; Query string
        queryPos := InStr(url, "?")
        if queryPos {
            result["search"] := SubStr(url, queryPos)
            result["query"] := SubStr(url, queryPos + 1)
            url := SubStr(url, 1, queryPos - 1)
        }

        ; Path
        slashPos := InStr(url, "/")
        if slashPos {
            result["pathname"] := SubStr(url, slashPos)
            url := SubStr(url, 1, slashPos - 1)
        } else {
            result["pathname"] := "/"
        }

        ; Auth (user:pass@)
        atPos := InStr(url, "@")
        if atPos {
            auth := SubStr(url, 1, atPos - 1)
            url := SubStr(url, atPos + 1)
            colonPos := InStr(auth, ":")
            if colonPos {
                result["username"] := SubStr(auth, 1, colonPos - 1)
                result["password"] := SubStr(auth, colonPos + 1)
            } else {
                result["username"] := auth
            }
        }

        ; Host and port
        colonPos := InStr(url, ":")
        if colonPos {
            result["hostname"] := SubStr(url, 1, colonPos - 1)
            result["port"] := SubStr(url, colonPos + 1)
        } else {
            result["hostname"] := url
        }
        
        result["host"] := result["hostname"] (result.Has("port") ? ":" result["port"] : "")

        return result
    }
    
    static Build(parts) {
        url := ""
        
        if parts.Has("protocol")
            url .= parts["protocol"] "://"
        
        if parts.Has("username") {
            url .= parts["username"]
            if parts.Has("password")
                url .= ":" parts["password"]
            url .= "@"
        }
        
        if parts.Has("hostname")
            url .= parts["hostname"]
        
        if parts.Has("port")
            url .= ":" parts["port"]
        
        if parts.Has("pathname")
            url .= parts["pathname"]
        
        if parts.Has("query")
            url .= "?" parts["query"]
        
        if parts.Has("hash")
            url .= "#" parts["hash"]
        
        return url
    }
}

; Query String utilities
class QueryString {
    static Parse(str) {
        result := Map()
        str := LTrim(str, "?")

        if str = ""
            return result

        for pair in StrSplit(str, "&") {
            parts := StrSplit(pair, "=", , 2)
            key := this.Decode(parts[1])
            value := parts.Length > 1 ? this.Decode(parts[2]) : ""
            result[key] := value
        }

        return result
    }

    static Stringify(data) {
        parts := []
        for key, value in data
            parts.Push(this.Encode(key) "=" this.Encode(String(value)))

        result := ""
        for i, part in parts
            result .= (i > 1 ? "&" : "") part
        return result
    }

    static Encode(str) {
        result := ""
        Loop StrLen(str) {
            char := SubStr(str, A_Index, 1)
            if RegExMatch(char, "[A-Za-z0-9_.~-]")
                result .= char
            else
                result .= "%" Format("{:02X}", Ord(char))
        }
        return result
    }

    static Decode(str) {
        while RegExMatch(str, "%([0-9A-Fa-f]{2})", &m)
            str := StrReplace(str, m[0], Chr(Integer("0x" m[1])))
        return str
    }
}

; Demo - URL parsing
testUrl := "https://user:pass@example.com:8080/path/to/page?foo=bar&baz=qux#section"
parsed := URL.Parse(testUrl)

result := "Parsed URL:`n"
for key, value in parsed
    result .= key ": " value "`n"

MsgBox(result)

; Query string
params := QueryString.Parse("name=John%20Doe&age=30&city=New+York")
result := "Query Params:`n"
for key, value in params
    result .= key " = " value "`n"

MsgBox(result)

; Build URL
newUrl := URL.Build(Map(
    "protocol", "https",
    "hostname", "api.example.com",
    "pathname", "/v1/users",
    "query", QueryString.Stringify(Map("page", 1, "limit", 10))
))

MsgBox("Built URL:`n" newUrl)
