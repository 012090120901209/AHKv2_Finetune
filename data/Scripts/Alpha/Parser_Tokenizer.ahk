#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Tokenizer - Lexical analysis for text parsing
; Demonstrates token-based text processing

class Tokenizer {
    class Token {
        __New(type, value, line := 1, column := 1) {
            this.type := type
            this.value := value
            this.line := line
            this.column := column
        }
        
        ToString() => this.type "(" this.value ")"
    }

    __New(rules := "") {
        this.rules := rules ?? this.DefaultRules()
        this.text := ""
        this.pos := 1
        this.line := 1
        this.column := 1
    }

    DefaultRules() {
        return [
            Map("type", "WHITESPACE", "pattern", "^\s+", "skip", true),
            Map("type", "NUMBER", "pattern", "^\d+(\.\d+)?"),
            Map("type", "STRING", "pattern", '^"[^"]*"'),
            Map("type", "IDENTIFIER", "pattern", "^[a-zA-Z_][a-zA-Z0-9_]*"),
            Map("type", "OPERATOR", "pattern", "^[+\-*/=<>!&|]+"),
            Map("type", "PUNCTUATION", "pattern", "^[(){}[\],;:]"),
        ]
    }

    Tokenize(text) {
        this.text := text
        this.pos := 1
        this.line := 1
        this.column := 1
        tokens := []

        while this.pos <= StrLen(this.text) {
            token := this.NextToken()
            if token
                tokens.Push(token)
        }

        return tokens
    }

    NextToken() {
        if this.pos > StrLen(this.text)
            return ""

        remaining := SubStr(this.text, this.pos)

        for rule in this.rules {
            if RegExMatch(remaining, rule["pattern"], &match) {
                value := match[0]
                token := Tokenizer.Token(
                    rule["type"],
                    value,
                    this.line,
                    this.column
                )

                ; Update position
                this.pos += StrLen(value)
                
                ; Track line/column
                Loop StrLen(value) {
                    char := SubStr(value, A_Index, 1)
                    if char = "`n" {
                        this.line++
                        this.column := 1
                    } else {
                        this.column++
                    }
                }

                ; Skip if marked
                if rule.Has("skip") && rule["skip"]
                    return this.NextToken()

                return token
            }
        }

        ; Unknown character - skip it
        this.pos++
        this.column++
        return this.NextToken()
    }
}

; Expression Tokenizer - For math expressions
class ExprTokenizer extends Tokenizer {
    __New() {
        super.__New([
            Map("type", "WHITESPACE", "pattern", "^\s+", "skip", true),
            Map("type", "NUMBER", "pattern", "^\d+(\.\d+)?"),
            Map("type", "PLUS", "pattern", "^\+"),
            Map("type", "MINUS", "pattern", "^-"),
            Map("type", "MULTIPLY", "pattern", "^\*"),
            Map("type", "DIVIDE", "pattern", "^/"),
            Map("type", "POWER", "pattern", "^\^"),
            Map("type", "LPAREN", "pattern", "^\("),
            Map("type", "RPAREN", "pattern", "^\)"),
            Map("type", "IDENTIFIER", "pattern", "^[a-zA-Z_][a-zA-Z0-9_]*")
        ])
    }
}

; Demo - General tokenizer
code := '
(
function calculate(x, y) {
    result := x + y * 2;
    return result;
}
)'

myTokenizer := Tokenizer()
tokens := myTokenizer.Tokenize(code)

result := "Code Tokens:`n"
for token in tokens
    result .= token.line ":" token.column " " token.ToString() "`n"

MsgBox(result)

; Demo - Expression tokenizer
expr := "3 + 4 * (2 - 1) ^ 2"
myExprTokenizer := ExprTokenizer()
tokens := myExprTokenizer.Tokenize(expr)

result := "Expression: " expr "`n`nTokens:`n"
for token in tokens
    result .= token.ToString() " "

MsgBox(result)

; Demo - Custom tokenizer for key=value pairs
configTokenizer := Tokenizer([
    Map("type", "WHITESPACE", "pattern", "^\s+", "skip", true),
    Map("type", "COMMENT", "pattern", "^#[^`n]*", "skip", true),
    Map("type", "KEY", "pattern", "^[a-zA-Z_][a-zA-Z0-9_]*(?==)"),
    Map("type", "EQUALS", "pattern", "^="),
    Map("type", "VALUE", "pattern", "^[^`n#]+")
])

configText := "
(
# Config file
host=localhost
port=8080
debug=true
)"

tokens := configTokenizer.Tokenize(configText)

result := "Config Tokens:`n"
for token in tokens
    result .= token.ToString() "`n"

MsgBox(result)
