#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric String DSL - Domain Specific Languages for string processing
; Demonstrates parser combinators and template engines in AHK v2

; =============================================================================
; 1. Parser Combinators
; =============================================================================

class Parser {
    ; Run parser on input
    Parse(input) => this._parse({ input: input, pos: 1 })

    ; Abstract parse method
    _parse(state) => { success: false, value: "", state: state }

    ; Combinators
    Then(next) => SequenceParser([this, next])
    Or(other) => ChoiceParser([this, other])
    Many() => ManyParser(this)
    Many1() => Many1Parser(this)
    Optional() => OptionalParser(this)
    Map(fn) => MapParser(this, fn)
    Skip() => MapParser(this, (*) => "")
}

; Match exact string
class StringParser extends Parser {
    __New(str) => this.str := str

    _parse(state) {
        len := StrLen(this.str)
        if SubStr(state.input, state.pos, len) = this.str {
            return {
                success: true,
                value: this.str,
                state: { input: state.input, pos: state.pos + len }
            }
        }
        return { success: false, value: "", state: state }
    }
}

; Match regex
class RegexParser extends Parser {
    __New(pattern) => this.pattern := pattern

    _parse(state) {
        remaining := SubStr(state.input, state.pos)
        if RegExMatch(remaining, "^" this.pattern, &m) {
            return {
                success: true,
                value: m[0],
                state: { input: state.input, pos: state.pos + StrLen(m[0]) }
            }
        }
        return { success: false, value: "", state: state }
    }
}

; Sequence of parsers
class SequenceParser extends Parser {
    __New(parsers) => this.parsers := parsers

    _parse(state) {
        results := []
        currentState := state

        for parser in this.parsers {
            result := parser._parse(currentState)
            if !result.success
                return { success: false, value: "", state: state }

            if result.value != ""
                results.Push(result.value)
            currentState := result.state
        }

        return { success: true, value: results, state: currentState }
    }
}

; Choice between parsers
class ChoiceParser extends Parser {
    __New(parsers) => this.parsers := parsers

    _parse(state) {
        for parser in this.parsers {
            result := parser._parse(state)
            if result.success
                return result
        }
        return { success: false, value: "", state: state }
    }
}

; Zero or more
class ManyParser extends Parser {
    __New(parser) => this.parser := parser

    _parse(state) {
        results := []
        currentState := state

        loop {
            result := this.parser._parse(currentState)
            if !result.success
                break
            results.Push(result.value)
            currentState := result.state
        }

        return { success: true, value: results, state: currentState }
    }
}

; One or more
class Many1Parser extends Parser {
    __New(parser) => this.parser := parser

    _parse(state) {
        first := this.parser._parse(state)
        if !first.success
            return { success: false, value: "", state: state }

        results := [first.value]
        currentState := first.state

        loop {
            result := this.parser._parse(currentState)
            if !result.success
                break
            results.Push(result.value)
            currentState := result.state
        }

        return { success: true, value: results, state: currentState }
    }
}

; Optional
class OptionalParser extends Parser {
    __New(parser) => this.parser := parser

    _parse(state) {
        result := this.parser._parse(state)
        if result.success
            return result
        return { success: true, value: "", state: state }
    }
}

; Transform result
class MapParser extends Parser {
    __New(parser, fn) {
        this.parser := parser
        this.fn := fn
    }

    _parse(state) {
        result := this.parser._parse(state)
        if !result.success
            return result
        return {
            success: true,
            value: this.fn(result.value),
            state: result.state
        }
    }
}

; Helper constructors
Str(s) => StringParser(s)
Regex(p) => RegexParser(p)
Seq(parsers*) => SequenceParser(parsers)
Alt(parsers*) => ChoiceParser(parsers)

; =============================================================================
; 2. Simple Template Engine
; =============================================================================

class Template {
    __New(templateStr) {
        this.template := templateStr
        this.compiled := this._compile(templateStr)
    }

    _compile(str) {
        parts := []
        pos := 1

        while pos <= StrLen(str) {
            ; Look for {{ expression }}
            if SubStr(str, pos, 2) = "{{" {
                endPos := InStr(str, "}}", , pos)
                if endPos {
                    expr := Trim(SubStr(str, pos + 2, endPos - pos - 2))
                    parts.Push({ type: "expr", value: expr })
                    pos := endPos + 2
                    continue
                }
            }

            ; Look for {% control %}
            if SubStr(str, pos, 2) = "{%" {
                endPos := InStr(str, "%}", , pos)
                if endPos {
                    ctrl := Trim(SubStr(str, pos + 2, endPos - pos - 2))
                    parts.Push({ type: "control", value: ctrl })
                    pos := endPos + 2
                    continue
                }
            }

            ; Regular text until next tag
            nextTag := this._findNextTag(str, pos)
            textEnd := nextTag > 0 ? nextTag : StrLen(str) + 1
            text := SubStr(str, pos, textEnd - pos)
            if text != ""
                parts.Push({ type: "text", value: text })
            pos := textEnd
        }

        return parts
    }

    _findNextTag(str, from) {
        expr := InStr(str, "{{", , from)
        ctrl := InStr(str, "{%", , from)

        if expr && ctrl
            return Min(expr, ctrl)
        return expr ? expr : ctrl
    }

    Render(context := Map()) {
        output := ""
        stack := []
        skipUntil := ""

        for part in this.compiled {
            ; Handle skip mode (for false if blocks)
            if skipUntil != "" {
                if part.type = "control" && this._matchesEnd(part.value, skipUntil)
                    skipUntil := ""
                continue
            }

            switch part.type {
                case "text":
                    output .= part.value

                case "expr":
                    output .= String(this._evalExpr(part.value, context))

                case "control":
                    output .= this._evalControl(part.value, context, &skipUntil, stack)
            }
        }

        return output
    }

    _evalExpr(expr, context) {
        ; Handle simple property access: obj.prop
        if InStr(expr, ".") {
            parts := StrSplit(expr, ".")
            value := context
            for part in parts {
                if value is Map
                    value := value.Get(part, "")
                else if IsObject(value) && value.HasOwnProp(part)
                    value := value.%part%
                else
                    return ""
            }
            return value
        }

        ; Handle filters: value | filter
        if InStr(expr, "|") {
            parts := StrSplit(expr, "|")
            value := this._evalExpr(Trim(parts[1]), context)
            filter := Trim(parts[2])
            return this._applyFilter(value, filter)
        }

        ; Simple lookup
        if context is Map
            return context.Get(expr, "")
        if context.HasOwnProp(expr)
            return context.%expr%
        return ""
    }

    _applyFilter(value, filter) {
        switch filter {
            case "upper": return StrUpper(value)
            case "lower": return StrLower(value)
            case "trim": return Trim(value)
            case "length": return IsObject(value) ? value.Length : StrLen(value)
            case "reverse": return this._reverse(value)
            default: return value
        }
    }

    _reverse(s) {
        result := ""
        loop StrLen(s)
            result := SubStr(s, A_Index, 1) . result
        return result
    }

    _evalControl(ctrl, context, &skipUntil, stack) {
        ; if condition
        if SubStr(ctrl, 1, 3) = "if " {
            condition := SubStr(ctrl, 4)
            value := this._evalExpr(condition, context)
            if !value || value = "" || value = 0 {
                skipUntil := "endif"
            }
            stack.Push("if")
            return ""
        }

        ; endif
        if ctrl = "endif" {
            if stack.Length > 0
                stack.Pop()
            return ""
        }

        ; for item in collection
        if SubStr(ctrl, 1, 4) = "for " {
            ; Parse: for item in collection
            if RegExMatch(ctrl, "for\s+(\w+)\s+in\s+(\w+)", &m) {
                ; Note: Full for loop would need block parsing
                ; This is simplified
                stack.Push({ type: "for", var: m[1], collection: m[2] })
            }
            return ""
        }

        ; endfor
        if ctrl = "endfor" {
            if stack.Length > 0
                stack.Pop()
            return ""
        }

        return ""
    }

    _matchesEnd(ctrl, expected) {
        switch expected {
            case "endif": return ctrl = "endif"
            case "endfor": return ctrl = "endfor"
        }
        return false
    }
}

; =============================================================================
; 3. String Interpolation
; =============================================================================

class Interpolator {
    ; Ruby-style interpolation: "Hello #{name}!"
    static Ruby(template, context) {
        result := template

        for key, value in context {
            result := StrReplace(result, "#{" key "}", String(value))
        }

        return result
    }

    ; Python f-string style: f"Hello {name}!"
    static FString(template, context) {
        result := template
        pos := 1

        while pos <= StrLen(result) {
            start := InStr(result, "{", , pos)
            if !start
                break

            endPos := InStr(result, "}", , start)
            if !endPos
                break

            expr := SubStr(result, start + 1, endPos - start - 1)
            value := Interpolator._resolve(expr, context)

            result := SubStr(result, 1, start - 1) . String(value) . SubStr(result, endPos + 1)
            pos := start + StrLen(String(value))
        }

        return result
    }

    static _resolve(expr, context) {
        ; Handle format spec: {value:spec}
        if InStr(expr, ":") {
            parts := StrSplit(expr, ":")
            value := Interpolator._lookup(parts[1], context)
            return Interpolator._format(value, parts[2])
        }

        return Interpolator._lookup(expr, context)
    }

    static _lookup(key, context) {
        if context is Map
            return context.Get(key, "")
        if context.HasOwnProp(key)
            return context.%key%
        return ""
    }

    static _format(value, spec) {
        ; Width formatting: {value:10} right-align, {value:<10} left-align
        if RegExMatch(spec, "^(<)?(\d+)$", &m) {
            width := Integer(m[2])
            str := String(value)
            if StrLen(str) >= width
                return str

            padding := ""
            loop width - StrLen(str)
                padding .= " "

            return m[1] = "<" ? str . padding : padding . str
        }

        ; Decimal places: {value:.2f}
        if RegExMatch(spec, "^\.(\d+)f$", &m) {
            return Format("{:." m[1] "f}", value)
        }

        return String(value)
    }
}

; =============================================================================
; 4. Grammar Builder (BNF-like)
; =============================================================================

class Grammar {
    __New() {
        this.rules := Map()
    }

    ; Define a rule
    Rule(name, parser) {
        this.rules[name] := parser
        return this
    }

    ; Reference a rule by name
    Ref(name) {
        return RefParser(this, name)
    }

    ; Parse with a rule
    Parse(ruleName, input) {
        if !this.rules.Has(ruleName)
            throw Error("Unknown rule: " ruleName)

        return this.rules[ruleName].Parse(input)
    }
}

class RefParser extends Parser {
    __New(grammar, ruleName) {
        this.grammar := grammar
        this.ruleName := ruleName
    }

    _parse(state) {
        rule := this.grammar.rules[this.ruleName]
        return rule._parse(state)
    }
}

; =============================================================================
; 5. SQL-like Query DSL
; =============================================================================

class QueryBuilder {
    __New(data := []) {
        this._data := data
        this._filters := []
        this._orderBy := ""
        this._orderDir := "asc"
        this._limit := 0
        this._offset := 0
        this._select := []
    }

    From(data) {
        this._data := data
        return this
    }

    Select(fields*) {
        this._select := fields
        return this
    }

    Where(predicate) {
        this._filters.Push(predicate)
        return this
    }

    WhereEq(field, value) {
        return this.Where((item) => item.%field% = value)
    }

    WhereLike(field, pattern) {
        return this.Where((item) => InStr(item.%field%, pattern))
    }

    WhereGt(field, value) {
        return this.Where((item) => item.%field% > value)
    }

    WhereLt(field, value) {
        return this.Where((item) => item.%field% < value)
    }

    OrderBy(field, direction := "asc") {
        this._orderBy := field
        this._orderDir := direction
        return this
    }

    Limit(n) {
        this._limit := n
        return this
    }

    Offset(n) {
        this._offset := n
        return this
    }

    Execute() {
        result := []

        ; Apply filters
        for item in this._data {
            matches := true
            for filter in this._filters {
                if !filter(item) {
                    matches := false
                    break
                }
            }
            if matches
                result.Push(item)
        }

        ; Sort
        if this._orderBy {
            result := this._sort(result, this._orderBy, this._orderDir)
        }

        ; Offset
        if this._offset > 0 {
            newResult := []
            for i, item in result {
                if i > this._offset
                    newResult.Push(item)
            }
            result := newResult
        }

        ; Limit
        if this._limit > 0 && result.Length > this._limit {
            limited := []
            loop Min(this._limit, result.Length)
                limited.Push(result[A_Index])
            result := limited
        }

        ; Project fields
        if this._select.Length > 0 {
            projected := []
            for item in result {
                proj := {}
                for field in this._select
                    proj.%field% := item.%field%
                projected.Push(proj)
            }
            result := projected
        }

        return result
    }

    _sort(arr, field, dir) {
        ; Simple bubble sort
        n := arr.Length
        loop n - 1 {
            i := A_Index
            loop n - i {
                j := A_Index
                shouldSwap := dir = "asc"
                    ? arr[j].%field% > arr[j + 1].%field%
                    : arr[j].%field% < arr[j + 1].%field%

                if shouldSwap {
                    temp := arr[j]
                    arr[j] := arr[j + 1]
                    arr[j + 1] := temp
                }
            }
        }
        return arr
    }

    Count() => this.Execute().Length

    First() {
        result := this.Limit(1).Execute()
        return result.Length > 0 ? result[1] : ""
    }
}

; Helper to create query
Query(data := []) => QueryBuilder(data)

; =============================================================================
; Demo
; =============================================================================

; Parser combinators
number := Regex("\d+").Map((v) => Integer(v))
plus := Str("+").Skip()
times := Str("*").Skip()

; Simple expression: number + number
addExpr := Seq(number, plus, number).Map((v) => v[1] + v[2])

result := addExpr.Parse("10+25")
MsgBox("Parser Combinator:`n`n'10+25' parsed to: " result.value)

; Template engine
tmpl := Template("Hello, {{ name | upper }}!{% if premium %} Welcome back, VIP!{% endif %}")

context1 := Map("name", "alice", "premium", true)
context2 := Map("name", "bob", "premium", false)

MsgBox("Template Engine:`n`n"
    . "Premium user: " tmpl.Render(context1) "`n"
    . "Regular user: " tmpl.Render(context2))

; String interpolation
MsgBox("Ruby Interpolation:`n`n"
    . Interpolator.Ruby("Hello #{name}, you have #{count} messages!", Map("name", "World", "count", 5)))

MsgBox("F-String Interpolation:`n`n"
    . Interpolator.FString("Value: {value:>10}, Pi: {pi:.2f}", Map("value", "test", "pi", 3.14159)))

; Query DSL
users := [{ name: "Alice", age: 30, active: true }, { name: "Bob", age: 25, active: true }, { name: "Charlie", age: 35, active: false }, { name: "Diana", age: 28, active: true }
]

activeAdults := Query(users)
    .Where((u) => u.active)
    .WhereGt("age", 26)
    .OrderBy("age", "desc")
    .Select("name", "age")
    .Execute()

queryResult := ""
for user in activeAdults
    queryResult .= user.name . " (" . user.age . ")`n"

MsgBox("Query DSL:`n`nActive users over 26, sorted by age desc:`n`n" queryResult)

; Grammar builder
g := Grammar()

digit := Regex("[0-9]")
letter := Regex("[a-zA-Z]")

g.Rule("digit", digit)
g.Rule("letter", letter)
g.Rule("alphanum", Alt(g.Ref("digit"), g.Ref("letter")))
g.Rule("identifier", Seq(g.Ref("letter"), g.Ref("alphanum").Many()))

idResult := g.Parse("identifier", "myVar123")
MsgBox("Grammar Parser:`n`n'myVar123' parsed as identifier: "
    . (idResult.success ? "Success" : "Failed"))
