#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Expression Parser - Recursive descent parser for math expressions
; Demonstrates lexer/parser pattern

class ExpressionParser {
    __New() {
        this.pos := 1
        this.tokens := []
    }

    ; Tokenize input string
    Tokenize(expr) {
        this.tokens := []
        this.pos := 1
        i := 1

        while i <= StrLen(expr) {
            char := SubStr(expr, i, 1)

            ; Skip whitespace
            if char = " " || char = "`t" {
                i++
                continue
            }

            ; Numbers (including decimals)
            if RegExMatch(SubStr(expr, i), "^(\d+\.?\d*)", &match) {
                this.tokens.Push(Map("type", "NUMBER", "value", Number(match[1])))
                i += StrLen(match[1])
                continue
            }

            ; Operators and parentheses
            if InStr("+-*/^()", char) {
                this.tokens.Push(Map("type", char, "value", char))
                i++
                continue
            }

            ; Functions (sin, cos, sqrt, etc.)
            if RegExMatch(SubStr(expr, i), "^([a-zA-Z]+)", &match) {
                this.tokens.Push(Map("type", "FUNC", "value", match[1]))
                i += StrLen(match[1])
                continue
            }

            throw Error("Unexpected character: " char " at position " i)
        }

        this.tokens.Push(Map("type", "EOF", "value", ""))
        return this.tokens
    }

    ; Parse and evaluate expression
    Parse(expr) {
        this.Tokenize(expr)
        this.pos := 1
        return this.ParseExpression()
    }

    ; Expression: Term ((+|-) Term)*
    ParseExpression() {
        left := this.ParseTerm()

        while this.Current()["type"] = "+" || this.Current()["type"] = "-" {
            op := this.Current()["type"]
            this.Advance()
            right := this.ParseTerm()
            left := op = "+" ? left + right : left - right
        }

        return left
    }

    ; Term: Power ((*|/) Power)*
    ParseTerm() {
        left := this.ParsePower()

        while this.Current()["type"] = "*" || this.Current()["type"] = "/" {
            op := this.Current()["type"]
            this.Advance()
            right := this.ParsePower()
            left := op = "*" ? left * right : left / right
        }

        return left
    }

    ; Power: Unary (^ Unary)?
    ParsePower() {
        left := this.ParseUnary()

        if this.Current()["type"] = "^" {
            this.Advance()
            right := this.ParsePower()  ; Right associative
            left := left ** right
        }

        return left
    }

    ; Unary: (-|+)? Factor
    ParseUnary() {
        if this.Current()["type"] = "-" {
            this.Advance()
            return -this.ParseFactor()
        }
        if this.Current()["type"] = "+" {
            this.Advance()
            return this.ParseFactor()
        }
        return this.ParseFactor()
    }

    ; Factor: NUMBER | FUNC(Expression) | (Expression)
    ParseFactor() {
        token := this.Current()

        if token["type"] = "NUMBER" {
            this.Advance()
            return token["value"]
        }

        if token["type"] = "FUNC" {
            funcName := StrLower(token["value"])
            this.Advance()
            this.Expect("(")
            arg := this.ParseExpression()
            this.Expect(")")
            
            return this.EvalFunction(funcName, arg)
        }

        if token["type"] = "(" {
            this.Advance()
            result := this.ParseExpression()
            this.Expect(")")
            return result
        }

        throw Error("Unexpected token: " token["type"])
    }

    EvalFunction(name, arg) {
        switch name {
            case "sin": return Sin(arg)
            case "cos": return Cos(arg)
            case "tan": return Tan(arg)
            case "sqrt": return Sqrt(arg)
            case "abs": return Abs(arg)
            case "ln": return Ln(arg)
            case "log": return Log(arg)
            case "exp": return Exp(arg)
            case "floor": return Floor(arg)
            case "ceil": return Ceil(arg)
            case "round": return Round(arg)
            default: throw Error("Unknown function: " name)
        }
    }

    Current() => this.tokens[this.pos]
    
    Advance() => this.pos++

    Expect(type) {
        if this.Current()["type"] != type
            throw Error("Expected " type " but got " this.Current()["type"])
        this.Advance()
    }
}

; Simple calculator wrapper
Calc(expr) {
    parser := ExpressionParser()
    return parser.Parse(expr)
}

; Demo - Basic expressions
expressions := [
    "2 + 3",
    "10 - 4 * 2",
    "(10 - 4) * 2",
    "2 ^ 3 ^ 2",      ; Right associative: 2^9 = 512
    "sqrt(16) + 2",
    "sin(0) + cos(0)",
    "-5 + 3",
    "2 * (3 + 4)",
    "10 / 2 / 2"
]

result := "Expression Parser Demo:`n`n"
for expr in expressions {
    try {
        value := Calc(expr)
        result .= Format("{} = {}`n", expr, Round(value, 6))
    } catch Error as e {
        result .= Format("{} = Error: {}`n", expr, e.Message)
    }
}

MsgBox(result)

; Demo - Complex expressions
complexExprs := [
    "sqrt(3^2 + 4^2)",           ; Pythagorean: 5
    "2 * 3.14159 * 5",           ; Circle circumference
    "exp(ln(10))",               ; Should be 10
    "(1 + sqrt(5)) / 2",         ; Golden ratio
    "abs(-10) + floor(3.7)"      ; 10 + 3 = 13
]

result := "Complex Expressions:`n`n"
for expr in complexExprs {
    try {
        value := Calc(expr)
        result .= Format("{}`n  = {}`n`n", expr, Round(value, 6))
    } catch Error as e {
        result .= Format("{}`n  Error: {}`n`n", expr, e.Message)
    }
}

MsgBox(result)

; Demo - Tokenization
parser := ExpressionParser()
tokens := parser.Tokenize("2 * (3 + sqrt(4))")

result := "Tokenization Demo:`n`n"
result .= "Expression: 2 * (3 + sqrt(4))`n`n"
result .= "Tokens:`n"

for tok in tokens
    result .= Format("  {}: {}`n", tok["type"], tok["value"])

MsgBox(result)
