#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Symbolic Expressions - Expression trees and symbolic computation
; Demonstrates DSL creation and expression manipulation

; =============================================================================
; 1. Symbolic Expression Base
; =============================================================================

class Sym {
    ; Factory methods
    static Num(n) => SymNum(n)
    static Var(name) => SymVar(name)
    static Add(a, b) => SymBinOp(Sym._wrap(a), "+", Sym._wrap(b))
    static Sub(a, b) => SymBinOp(Sym._wrap(a), "-", Sym._wrap(b))
    static Mul(a, b) => SymBinOp(Sym._wrap(a), "*", Sym._wrap(b))
    static Div(a, b) => SymBinOp(Sym._wrap(a), "/", Sym._wrap(b))
    static Pow(a, b) => SymBinOp(Sym._wrap(a), "^", Sym._wrap(b))
    static Neg(a) => SymUnaryOp("-", Sym._wrap(a))

    static _wrap(x) => x is Sym ? x : SymNum(x)

    ; Operator overloading
    __Add(other) => Sym.Add(this, other)
    __Sub(other) => Sym.Sub(this, other)
    __Mul(other) => Sym.Mul(this, other)
    __Div(other) => Sym.Div(this, other)
    __Pow(other) => Sym.Pow(this, other)
    __Neg() => Sym.Neg(this)

    ; Abstract methods
    Eval(vars := Map()) => 0
    ToString() => ""
    Simplify() => this
    Derivative(varName) => SymNum(0)
    Substitute(varName, expr) => this
}

; =============================================================================
; 2. Numeric Literal
; =============================================================================

class SymNum extends Sym {
    __New(value) => this.value := value

    Eval(vars := Map()) => this.value
    ToString() => String(this.value)
    Simplify() => this
    Derivative(varName) => SymNum(0)
    Substitute(varName, expr) => this
}

; =============================================================================
; 3. Variable
; =============================================================================

class SymVar extends Sym {
    __New(name) => this.name := name

    Eval(vars := Map()) => vars.Get(this.name, 0)
    ToString() => this.name
    Simplify() => this

    Derivative(varName) {
        return this.name = varName ? SymNum(1) : SymNum(0)
    }

    Substitute(varName, expr) {
        return this.name = varName ? expr : this
    }
}

; =============================================================================
; 4. Binary Operation
; =============================================================================

class SymBinOp extends Sym {
    __New(left, op, right) {
        this.left := left
        this.op := op
        this.right := right
    }

    Eval(vars := Map()) {
        l := this.left.Eval(vars)
        r := this.right.Eval(vars)

        switch this.op {
            case "+": return l + r
            case "-": return l - r
            case "*": return l * r
            case "/": return l / r
            case "^": return l ** r
        }
    }

    ToString() {
        return "(" this.left.ToString() " " this.op " " this.right.ToString() ")"
    }

    Simplify() {
        left := this.left.Simplify()
        right := this.right.Simplify()

        ; Numeric simplification
        if left is SymNum && right is SymNum {
            return SymNum(SymBinOp(left, this.op, right).Eval())
        }

        ; Identity rules
        switch this.op {
            case "+":
                if left is SymNum && left.value = 0
                    return right
                if right is SymNum && right.value = 0
                    return left
            case "-":
                if right is SymNum && right.value = 0
                    return left
            case "*":
                if left is SymNum && left.value = 0
                    return SymNum(0)
                if right is SymNum && right.value = 0
                    return SymNum(0)
                if left is SymNum && left.value = 1
                    return right
                if right is SymNum && right.value = 1
                    return left
            case "/":
                if right is SymNum && right.value = 1
                    return left
            case "^":
                if right is SymNum && right.value = 0
                    return SymNum(1)
                if right is SymNum && right.value = 1
                    return left
        }

        return SymBinOp(left, this.op, right)
    }

    Derivative(varName) {
        switch this.op {
            case "+":
                ; (f + g)' = f' + g'
                return Sym.Add(
                    this.left.Derivative(varName),
                    this.right.Derivative(varName)
                ).Simplify()

            case "-":
                ; (f - g)' = f' - g'
                return Sym.Sub(
                    this.left.Derivative(varName),
                    this.right.Derivative(varName)
                ).Simplify()

            case "*":
                ; (f * g)' = f' * g + f * g'
                return Sym.Add(
                    Sym.Mul(this.left.Derivative(varName), this.right),
                    Sym.Mul(this.left, this.right.Derivative(varName))
                ).Simplify()

            case "/":
                ; (f / g)' = (f' * g - f * g') / g^2
                return Sym.Div(
                    Sym.Sub(
                        Sym.Mul(this.left.Derivative(varName), this.right),
                        Sym.Mul(this.left, this.right.Derivative(varName))
                    ),
                    Sym.Pow(this.right, 2)
                ).Simplify()

            case "^":
                ; Power rule (assuming exponent is constant)
                if this.right is SymNum {
                    n := this.right.value
                    return Sym.Mul(
                        Sym.Mul(SymNum(n), Sym.Pow(this.left, n - 1)),
                        this.left.Derivative(varName)
                    ).Simplify()
                }
        }

        return SymNum(0)
    }

    Substitute(varName, expr) {
        return SymBinOp(
            this.left.Substitute(varName, expr),
            this.op,
            this.right.Substitute(varName, expr)
        )
    }
}

; =============================================================================
; 5. Unary Operation
; =============================================================================

class SymUnaryOp extends Sym {
    __New(op, operand) {
        this.op := op
        this.operand := operand
    }

    Eval(vars := Map()) {
        v := this.operand.Eval(vars)
        switch this.op {
            case "-": return -v
        }
    }

    ToString() => this.op this.operand.ToString()

    Simplify() {
        operand := this.operand.Simplify()

        if operand is SymNum {
            return SymNum(SymUnaryOp(this.op, operand).Eval())
        }

        ; Double negation
        if this.op = "-" && operand is SymUnaryOp && operand.op = "-"
            return operand.operand

        return SymUnaryOp(this.op, operand)
    }

    Derivative(varName) {
        if this.op = "-"
            return Sym.Neg(this.operand.Derivative(varName)).Simplify()
        return SymNum(0)
    }

    Substitute(varName, expr) {
        return SymUnaryOp(this.op, this.operand.Substitute(varName, expr))
    }
}

; =============================================================================
; 6. Expression Parser
; =============================================================================

class ExprParser {
    static Parse(input) {
        parser := ExprParser()
        parser.input := input
        parser.pos := 1
        return parser._parseExpr()
    }

    _parseExpr() => this._parseAddSub()

    _parseAddSub() {
        left := this._parseMulDiv()

        loop {
            this._skipWhitespace()
            ch := this._peek()

            if ch = "+" || ch = "-" {
                this._advance()
                right := this._parseMulDiv()
                left := ch = "+" ? Sym.Add(left, right) : Sym.Sub(left, right)
            } else {
                break
            }
        }

        return left
    }

    _parseMulDiv() {
        left := this._parsePower()

        loop {
            this._skipWhitespace()
            ch := this._peek()

            if ch = "*" || ch = "/" {
                this._advance()
                right := this._parsePower()
                left := ch = "*" ? Sym.Mul(left, right) : Sym.Div(left, right)
            } else {
                break
            }
        }

        return left
    }

    _parsePower() {
        base := this._parseUnary()

        this._skipWhitespace()
        if this._peek() = "^" {
            this._advance()
            exp := this._parsePower()  ; Right associative
            return Sym.Pow(base, exp)
        }

        return base
    }

    _parseUnary() {
        this._skipWhitespace()

        if this._peek() = "-" {
            this._advance()
            return Sym.Neg(this._parseUnary())
        }

        return this._parseAtom()
    }

    _parseAtom() {
        this._skipWhitespace()
        ch := this._peek()

        ; Parenthesized expression
        if ch = "(" {
            this._advance()
            expr := this._parseExpr()
            this._expect(")")
            return expr
        }

        ; Number
        if IsDigit(ch) || ch = "." {
            return this._parseNumber()
        }

        ; Variable
        if IsAlpha(ch) || ch = "_" {
            return this._parseVariable()
        }

        throw Error("Unexpected character: " ch)
    }

    _parseNumber() {
        start := this.pos
        while this.pos <= StrLen(this.input) {
            ch := SubStr(this.input, this.pos, 1)
            if !IsDigit(ch) && ch != "."
                break
            this.pos++
        }
        return SymNum(Number(SubStr(this.input, start, this.pos - start)))
    }

    _parseVariable() {
        start := this.pos
        while this.pos <= StrLen(this.input) {
            ch := SubStr(this.input, this.pos, 1)
            if !IsAlnum(ch) && ch != "_"
                break
            this.pos++
        }
        return SymVar(SubStr(this.input, start, this.pos - start))
    }

    _peek() => this.pos <= StrLen(this.input) ? SubStr(this.input, this.pos, 1) : ""
    _advance() => this.pos++

    _expect(ch) {
        this._skipWhitespace()
        if this._peek() != ch
            throw Error("Expected '" ch "' at position " this.pos)
        this._advance()
    }

    _skipWhitespace() {
        while this._peek() = " " || this._peek() = "`t"
            this._advance()
    }
}

IsDigit(ch) => ch >= "0" && ch <= "9"
IsAlpha(ch) => (ch >= "a" && ch <= "z") || (ch >= "A" && ch <= "Z")
IsAlnum(ch) => IsDigit(ch) || IsAlpha(ch)

; =============================================================================
; 7. Expression Compiler
; =============================================================================

class ExprCompiler {
    ; Compile expression to AHK function
    static Compile(expr, varNames*) {
        body := ExprCompiler._generate(expr)

        ; Build function signature
        params := ""
        for i, name in varNames
            params .= (i > 1 ? ", " : "") name

        ; Return a function that evaluates the expression
        ; Note: In real AHK, we'd use different approach since no eval()
        ; This returns a wrapper that uses Eval
        return (args*) => (
            vars := Map(),
            (for i, name in varNames
                vars[name] := args[i]),
            expr.Eval(vars)
        )
    }

    static _generate(expr) {
        if expr is SymNum
            return String(expr.value)

        if expr is SymVar
            return expr.name

        if expr is SymUnaryOp
            return "(" expr.op ExprCompiler._generate(expr.operand) ")"

        if expr is SymBinOp {
            op := expr.op = "^" ? "**" : expr.op
            return "(" ExprCompiler._generate(expr.left) " " op " " ExprCompiler._generate(expr.right) ")"
        }

        return "0"
    }
}

; =============================================================================
; Demo
; =============================================================================

; Create symbolic expression using operators
x := Sym.Var("x")
y := Sym.Var("y")

; Expression: (x + 2) * (y - 1)
expr1 := (x + 2) * (y - 1)
MsgBox("Symbolic Expression:`n`n"
    . "Expression: " expr1.ToString() "`n"
    . "Eval(x=3, y=5): " expr1.Eval(Map("x", 3, "y", 5)))

; Derivative
expr2 := x * x + Sym.Num(2) * x + Sym.Num(1)  ; x² + 2x + 1
deriv := expr2.Derivative("x")
MsgBox("Derivative:`n`n"
    . "f(x) = " expr2.ToString() "`n"
    . "f'(x) = " deriv.ToString())

; Parse and evaluate
parsed := ExprParser.Parse("(x + 2) * 3 - y")
MsgBox("Parsed Expression:`n`n"
    . "Input: '(x + 2) * 3 - y'`n"
    . "Parsed: " parsed.ToString() "`n"
    . "Eval(x=4, y=1): " parsed.Eval(Map("x", 4, "y", 1)))

; Simplification
unsimplified := Sym.Add(Sym.Mul(x, 1), Sym.Mul(0, y))
simplified := unsimplified.Simplify()
MsgBox("Simplification:`n`n"
    . "Original: " unsimplified.ToString() "`n"
    . "Simplified: " simplified.ToString())

; Substitution
expr3 := x * x + x
substituted := expr3.Substitute("x", Sym.Add(y, 1))
MsgBox("Substitution:`n`n"
    . "Original: " expr3.ToString() "`n"
    . "x → (y + 1): " substituted.ToString())

; Compile to function
quadratic := x * x + Sym.Num(2) * x + Sym.Num(1)
compiled := ExprCompiler.Compile(quadratic, "x")
MsgBox("Compiled Function:`n`n"
    . "f(x) = " quadratic.ToString() "`n"
    . "f(3) = " compiled(3) "`n"
    . "f(5) = " compiled(5))

; Complex expression with power rule derivative
poly := Sym.Pow(x, 3) + Sym.Num(2) * Sym.Pow(x, 2) + x
polyDeriv := poly.Derivative("x")
MsgBox("Power Rule Derivative:`n`n"
    . "f(x) = " poly.ToString() "`n"
    . "f'(x) = " polyDeriv.ToString())
