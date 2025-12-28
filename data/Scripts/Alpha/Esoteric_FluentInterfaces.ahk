#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Fluent Interfaces - Method chaining and builder patterns
; Demonstrates fluent API design in AHK v2

; =============================================================================
; 1. Fluent Query Builder (LINQ-style)
; =============================================================================

class Query {
    __New(source) {
        this.source := source is Array ? source : [source]
        this.operations := []
    }

    static From(source) => Query(source)

    Where(predicate) {
        this.operations.Push({ type: "where", fn: predicate })
        return this
    }

    Select(transform) {
        this.operations.Push({ type: "select", fn: transform })
        return this
    }

    OrderBy(keyFn, desc := false) {
        this.operations.Push({ type: "orderBy", fn: keyFn, desc: desc })
        return this
    }

    Take(count) {
        this.operations.Push({ type: "take", count: count })
        return this
    }

    Skip(count) {
        this.operations.Push({ type: "skip", count: count })
        return this
    }

    Distinct() {
        this.operations.Push({ type: "distinct" })
        return this
    }

    GroupBy(keyFn) {
        this.operations.Push({ type: "groupBy", fn: keyFn })
        return this
    }

    ; Terminal operations
    ToArray() {
        result := this.source.Clone()

        for op in this.operations {
            switch op.type {
                case "where":
                    result := this._filter(result, op.fn)
                case "select":
                    result := this._map(result, op.fn)
                case "orderBy":
                    result := this._sort(result, op.fn, op.desc)
                case "take":
                    result := this._take(result, op.count)
                case "skip":
                    result := this._skip(result, op.count)
                case "distinct":
                    result := this._distinct(result)
                case "groupBy":
                    result := this._groupBy(result, op.fn)
            }
        }

        return result
    }

    First(default := "") {
        arr := this.ToArray()
        return arr.Length > 0 ? arr[1] : default
    }

    Count() => this.ToArray().Length

    Sum(keyFn := (x) => x) {
        total := 0
        for item in this.ToArray()
            total += keyFn(item)
        return total
    }

    Average(keyFn := (x) => x) {
        arr := this.ToArray()
        return arr.Length > 0 ? this.Sum(keyFn) / arr.Length : 0
    }

    ; Helper methods
    _filter(arr, fn) {
        result := []
        for item in arr
            if fn(item)
                result.Push(item)
        return result
    }

    _map(arr, fn) {
        result := []
        for item in arr
            result.Push(fn(item))
        return result
    }

    _sort(arr, keyFn, desc) {
        ; Simple bubble sort for demo
        result := arr.Clone()
        n := result.Length
        Loop n - 1 {
            i := A_Index
            Loop n - i {
                j := A_Index
                a := keyFn(result[j])
                b := keyFn(result[j + 1])
                shouldSwap := desc ? a < b : a > b
                if shouldSwap {
                    temp := result[j]
                    result[j] := result[j + 1]
                    result[j + 1] := temp
                }
            }
        }
        return result
    }

    _take(arr, count) {
        result := []
        Loop Min(count, arr.Length)
            result.Push(arr[A_Index])
        return result
    }

    _skip(arr, count) {
        result := []
        Loop arr.Length - count
            result.Push(arr[A_Index + count])
        return result
    }

    _distinct(arr) {
        seen := Map()
        result := []
        for item in arr {
            key := String(item)
            if !seen.Has(key) {
                seen[key] := true
                result.Push(item)
            }
        }
        return result
    }

    _groupBy(arr, keyFn) {
        groups := Map()
        for item in arr {
            key := keyFn(item)
            if !groups.Has(key)
                groups[key] := []
            groups[key].Push(item)
        }

        ; Convert to array of {key, items}
        result := []
        for key, items in groups
            result.Push({ key: key, items: items })
        return result
    }
}

; =============================================================================
; 2. Fluent String Builder
; =============================================================================

class StringBuilder {
    __New() {
        this.parts := []
    }

    static Create() => StringBuilder()

    Append(str) {
        this.parts.Push(str)
        return this
    }

    AppendLine(str := "") {
        this.parts.Push(str "`n")
        return this
    }

    AppendFormat(format, args*) {
        this.parts.Push(Format(format, args*))
        return this
    }

    Prepend(str) {
        this.parts.InsertAt(1, str)
        return this
    }

    Repeat(str, count) {
        Loop count
            this.parts.Push(str)
        return this
    }

    If(condition, thenStr, elseStr := "") {
        this.parts.Push(condition ? thenStr : elseStr)
        return this
    }

    When(condition, callback) {
        if condition
            callback(this)
        return this
    }

    Join(arr, sep := "") {
        for i, item in arr
            this.parts.Push((i > 1 ? sep : "") item)
        return this
    }

    Pad(length, char := " ", right := false) {
        str := this.ToString()
        padding := ""
        Loop Max(0, length - StrLen(str))
            padding .= char

        this.parts := right ? [str, padding] : [padding, str]
        return this
    }

    Trim() {
        this.parts := [Trim(this.ToString())]
        return this
    }

    Replace(search, replace) {
        this.parts := [StrReplace(this.ToString(), search, replace)]
        return this
    }

    ToUpper() {
        this.parts := [StrUpper(this.ToString())]
        return this
    }

    ToLower() {
        this.parts := [StrLower(this.ToString())]
        return this
    }

    Clear() {
        this.parts := []
        return this
    }

    ToString() {
        result := ""
        for part in this.parts
            result .= part
        return result
    }

    Length => StrLen(this.ToString())
}

; =============================================================================
; 3. Fluent HTTP Request Builder
; =============================================================================

class HttpRequest {
    __New() {
        this._method := "GET"
        this._url := ""
        this._headers := Map()
        this._body := ""
        this._timeout := 30
    }

    static Create() => HttpRequest()

    Get(url) {
        this._method := "GET"
        this._url := url
        return this
    }

    Post(url) {
        this._method := "POST"
        this._url := url
        return this
    }

    Put(url) {
        this._method := "PUT"
        this._url := url
        return this
    }

    Delete(url) {
        this._method := "DELETE"
        this._url := url
        return this
    }

    Header(name, value) {
        this._headers[name] := value
        return this
    }

    ContentType(type) {
        this._headers["Content-Type"] := type
        return this
    }

    Accept(type) {
        this._headers["Accept"] := type
        return this
    }

    Authorization(type, token) {
        this._headers["Authorization"] := type " " token
        return this
    }

    Bearer(token) => this.Authorization("Bearer", token)

    Body(data) {
        this._body := data
        return this
    }

    Json(obj) {
        ; Simplified JSON serialization
        this._body := this._toJson(obj)
        this._headers["Content-Type"] := "application/json"
        return this
    }

    Timeout(seconds) {
        this._timeout := seconds
        return this
    }

    ; Build request description (actual HTTP would need ComObject)
    Build() {
        return Map(
            "method", this._method,
            "url", this._url,
            "headers", this._headers.Clone(),
            "body", this._body,
            "timeout", this._timeout
        )
    }

    ToString() {
        lines := [this._method " " this._url]
        for name, value in this._headers
            lines.Push(name ": " value)
        if this._body
            lines.Push("", this._body)

        result := ""
        for line in lines
            result .= line "`n"
        return result
    }

    _toJson(obj) {
        if obj is Map {
            parts := []
            for k, v in obj
                parts.Push('"' k '": ' this._toJson(v))
            return "{" this._joinArr(parts, ", ") "}"
        }
        if obj is Array {
            parts := []
            for v in obj
                parts.Push(this._toJson(v))
            return "[" this._joinArr(parts, ", ") "]"
        }
        if obj is String
            return '"' obj '"'
        return String(obj)
    }

    _joinArr(arr, sep) {
        r := ""
        for i, v in arr
            r .= (i > 1 ? sep : "") v
        return r
    }
}

; =============================================================================
; 4. Fluent Assertion Builder (Testing)
; =============================================================================

class Assert {
    __New(value, description := "") {
        this.value := value
        this.description := description
        this.negated := false
    }

    static That(value, description := "") => Assert(value, description)

    Not {
        get {
            this.negated := !this.negated
            return this
        }
    }

    Equals(expected) {
        result := this.value = expected
        if this.negated
            result := !result

        if !result
            throw Error("Assertion failed: " this._msg("equal", expected))
        return this
    }

    IsTrue() {
        result := !!this.value
        if this.negated
            result := !result

        if !result
            throw Error("Assertion failed: " this._msg("be true"))
        return this
    }

    IsFalse() {
        result := !this.value
        if this.negated
            result := !result

        if !result
            throw Error("Assertion failed: " this._msg("be false"))
        return this
    }

    IsNull() {
        result := this.value = ""
        if this.negated
            result := !result

        if !result
            throw Error("Assertion failed: " this._msg("be null/empty"))
        return this
    }

    Contains(item) {
        if this.value is String
            result := InStr(this.value, item)
        else if this.value is Array
            result := this._arrayContains(this.value, item)
        else
            result := false

        if this.negated
            result := !result

        if !result
            throw Error("Assertion failed: " this._msg("contain", item))
        return this
    }

    HasLength(expected) {
        actual := this.value is String ? StrLen(this.value) : this.value.Length
        result := actual = expected

        if this.negated
            result := !result

        if !result
            throw Error("Assertion failed: " this._msg("have length", expected))
        return this
    }

    IsGreaterThan(expected) {
        result := this.value > expected
        if this.negated
            result := !result

        if !result
            throw Error("Assertion failed: " this._msg("be greater than", expected))
        return this
    }

    IsLessThan(expected) {
        result := this.value < expected
        if this.negated
            result := !result

        if !result
            throw Error("Assertion failed: " this._msg("be less than", expected))
        return this
    }

    _arrayContains(arr, item) {
        for v in arr
            if v = item
                return true
        return false
    }

    _msg(verb, expected := "") {
        msg := "Expected "
        if this.description
            msg .= this.description " "
        msg .= "to " (this.negated ? "not " : "") verb
        if expected != ""
            msg .= " " String(expected)
        msg .= ", but got " String(this.value)
        return msg
    }
}

; =============================================================================
; 5. Fluent Configuration Builder
; =============================================================================

class Config {
    __New() {
        this._data := Map()
        this._path := []
    }

    static Create() => Config()

    Section(name) {
        this._path.Push(name)
        if !this._data.Has(name)
            this._data[name] := Map()
        return this
    }

    EndSection() {
        if this._path.Length > 0
            this._path.Pop()
        return this
    }

    Set(key, value) {
        target := this._getTarget()
        target[key] := value
        return this
    }

    SetIf(condition, key, value) {
        if condition
            this.Set(key, value)
        return this
    }

    SetDefault(key, value) {
        target := this._getTarget()
        if !target.Has(key)
            target[key] := value
        return this
    }

    Merge(data) {
        target := this._getTarget()
        for k, v in data
            target[k] := v
        return this
    }

    _getTarget() {
        target := this._data
        for segment in this._path
            target := target[segment]
        return target
    }

    Get(path) {
        parts := StrSplit(path, ".")
        target := this._data

        for part in parts {
            if target is Map && target.Has(part)
                target := target[part]
            else
                return ""
        }

        return target
    }

    ToMap() => this._data.Clone()
}

; =============================================================================
; Demo
; =============================================================================

; Query builder
people := [{ name: "Alice", age: 30, city: "NYC" }, { name: "Bob", age: 25, city: "LA" }, { name: "Charlie", age: 35, city: "NYC" }, { name: "Diana", age: 28, city: "LA" }, { name: "Eve", age: 32, city: "NYC" }
]

result := Query.From(people)
    .Where((p) => p.age > 26)
    .OrderBy((p) => p.age)
    .Select((p) => p.name)
    .ToArray()

MsgBox("Query Builder:`n"
    . "People over 26, sorted by age:`n"
    . JoinArr(result, ", "))

avgAge := Query.From(people)
    .Where((p) => p.city = "NYC")
    .Average((p) => p.age)

MsgBox("Average age in NYC: " Round(avgAge, 1))

; String builder
greeting := StringBuilder.Create()
    .Append("Hello")
    .If(true, ", ")
    .Append("World")
    .AppendLine("!")
    .AppendFormat("Today is {1}", FormatTime(, "dddd"))
    .ToString()

MsgBox("StringBuilder:`n" greeting)

; HTTP request builder
request := HttpRequest.Create()
    .Post("https://api.example.com/users")
    .ContentType("application/json")
    .Accept("application/json")
    .Bearer("abc123token")
    .Header("X-Request-ID", "req-001")
    .Json(Map("name", "Alice", "email", "alice@test.com"))
    .Timeout(60)

MsgBox("HTTP Request Builder:`n`n" request.ToString())

; Assertion builder
try {
    Assert.That(5, "five").IsGreaterThan(3).IsLessThan(10)
    Assert.That("hello", "greeting").Contains("ell").HasLength(5)
    Assert.That([1, 2, 3], "array").Contains(2).Not.Contains(5)
    MsgBox("All assertions passed!")
} catch Error as e {
    MsgBox("Assertion failed: " e.Message)
}

; Config builder
config := Config.Create()
    .Section("database")
    .Set("host", "localhost")
    .Set("port", 5432)
    .Set("name", "myapp")
    .EndSection()
    .Section("server")
    .Set("port", 8080)
    .SetDefault("timeout", 30)
    .EndSection()

MsgBox("Config Builder:`n"
    . "DB Host: " config.Get("database.host") "`n"
    . "DB Port: " config.Get("database.port") "`n"
    . "Server Port: " config.Get("server.port"))

; Helper
JoinArr(arr, sep) {
    r := ""
    for i, v in arr
        r .= (i > 1 ? sep : "") String(v)
    return r
}
