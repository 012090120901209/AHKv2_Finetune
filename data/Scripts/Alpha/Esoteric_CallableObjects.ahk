#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Callable Objects - Objects that behave like functions
; Demonstrates the Call protocol and duck-typed callable patterns

; =============================================================================
; 1. Basic Callable Object
; =============================================================================

class Adder {
    __New(amount) => this.amount := amount

    ; The Call method makes this object callable
    Call(value) => value + this.amount
}

; =============================================================================
; 2. Callable with State (Closure-like)
; =============================================================================

class Counter {
    __New(start := 0) => this.count := start

    ; Each call increments and returns
    Call() => ++this.count

    ; Reset
    Reset() => this.count := 0
}

; =============================================================================
; 3. Memoized Callable
; =============================================================================

class Memoize {
    __New(fn) {
        this.fn := fn
        this.cache := Map()
    }

    Call(args*) {
        ; Create cache key from arguments
        key := this._makeKey(args)

        if this.cache.Has(key)
            return this.cache[key]

        result := this.fn(args*)
        this.cache[key] := result
        return result
    }

    _makeKey(args) {
        parts := []
        for arg in args
            parts.Push(Type(arg) ":" String(arg))
        return parts.Length ? parts.Join("|") : "_empty_"
    }

    ClearCache() => this.cache := Map()
    CacheSize => this.cache.Count
}

; Helper for array join
Array.Prototype.Join := (this, sep := ",") => _ArrayJoin(this, sep)

_ArrayJoin(arr, sep) {
    result := ""
    for i, v in arr
        result .= (i > 1 ? sep : "") v
    return result
}

; =============================================================================
; 4. Partial Application Callable
; =============================================================================

class Partial {
    __New(fn, boundArgs*) {
        this.fn := fn
        this.boundArgs := boundArgs
    }

    Call(args*) {
        allArgs := []
        for arg in this.boundArgs
            allArgs.Push(arg)
        for arg in args
            allArgs.Push(arg)
        return this.fn(allArgs*)
    }
}

; =============================================================================
; 5. Curried Callable
; =============================================================================

class Curry {
    __New(fn, arity) {
        this.fn := fn
        this.arity := arity
        this.args := []
    }

    Call(arg) {
        ; Create new curry with additional argument
        newCurry := Curry(this.fn, this.arity)
        newCurry.args := this.args.Clone()
        newCurry.args.Push(arg)

        ; If we have enough arguments, execute
        if newCurry.args.Length >= this.arity
            return this.fn(newCurry.args*)

        return newCurry
    }
}

; =============================================================================
; 6. Debounced Callable
; =============================================================================

class Debounce {
    __New(fn, delayMs) {
        this.fn := fn
        this.delay := delayMs
        this.timer := ""
        this.lastArgs := []
    }

    Call(args*) {
        this.lastArgs := args

        ; Cancel existing timer
        if this.timer
            SetTimer(this.timer, 0)

        ; Create new timer
        this.timer := this._createCallback()
        SetTimer(this.timer, -this.delay)
    }

    _createCallback() {
        fn := this.fn
        args := this.lastArgs
        return () => fn(args*)
    }

    Cancel() {
        if this.timer {
            SetTimer(this.timer, 0)
            this.timer := ""
        }
    }
}

; =============================================================================
; 7. Throttled Callable
; =============================================================================

class Throttle {
    __New(fn, intervalMs) {
        this.fn := fn
        this.interval := intervalMs
        this.lastCall := 0
        this.pending := false
        this.lastArgs := []
    }

    Call(args*) {
        now := A_TickCount

        if now - this.lastCall >= this.interval {
            this.lastCall := now
            return this.fn(args*)
        }

        ; Queue for later
        this.lastArgs := args
        if !this.pending {
            this.pending := true
            remaining := this.interval - (now - this.lastCall)
            SetTimer(this._createCallback(), -remaining)
        }
    }

    _createCallback() {
        return () => (
            this.pending := false,
            this.lastCall := A_TickCount,
            this.fn(this.lastArgs*)
        )
    }
}

; =============================================================================
; 8. Pipeline Callable
; =============================================================================

class Pipeline {
    __New(fns*) {
        this.functions := fns
    }

    Call(value) {
        result := value
        for fn in this.functions
            result := fn(result)
        return result
    }

    ; Add more functions to pipeline
    Then(fn) {
        newFns := []
        for f in this.functions
            newFns.Push(f)
        newFns.Push(fn)
        return Pipeline(newFns*)
    }
}

; =============================================================================
; 9. Retry Callable
; =============================================================================

class Retry {
    __New(fn, maxAttempts := 3, delayMs := 100) {
        this.fn := fn
        this.maxAttempts := maxAttempts
        this.delay := delayMs
    }

    Call(args*) {
        lastError := ""

        Loop this.maxAttempts {
            try {
                return this.fn(args*)
            } catch Error as e {
                lastError := e
                if A_Index < this.maxAttempts
                    Sleep(this.delay * A_Index)  ; Exponential backoff
            }
        }

        throw Error("Retry failed after " this.maxAttempts " attempts: " lastError.Message)
    }
}

; =============================================================================
; 10. Tap Callable (Side effects without changing value)
; =============================================================================

class Tap {
    __New(fn) => this.fn := fn

    Call(value) {
        this.fn(value)
        return value  ; Pass through unchanged
    }
}

; =============================================================================
; 11. Conditional Callable
; =============================================================================

class When {
    __New(condition, thenFn, elseFn := "") {
        this.condition := condition
        this.thenFn := thenFn
        this.elseFn := elseFn
    }

    Call(value) {
        if this.condition(value)
            return this.thenFn(value)
        else if this.elseFn
            return this.elseFn(value)
        return value
    }
}

; =============================================================================
; 12. Once Callable (Execute only once)
; =============================================================================

class Once {
    __New(fn) {
        this.fn := fn
        this.called := false
        this.result := ""
    }

    Call(args*) {
        if !this.called {
            this.called := true
            this.result := this.fn(args*)
        }
        return this.result
    }

    Reset() {
        this.called := false
        this.result := ""
    }
}

; =============================================================================
; Demo
; =============================================================================

; Basic callable
add5 := Adder(5)
MsgBox("Adder(5):`n"
    . "add5(10) = " add5(10) "`n"
    . "add5(20) = " add5(20))

; Counter
ctr := Counter()
MsgBox("Counter:`n"
    . "call 1: " ctr() "`n"
    . "call 2: " ctr() "`n"
    . "call 3: " ctr())

; Memoization
expensiveFib := Memoize((n) => n <= 1 ? n : expensiveFib(n - 1) + expensiveFib(n - 2))
start := A_TickCount
result := expensiveFib(30)
elapsed := A_TickCount - start
MsgBox("Memoized Fibonacci(30):`n"
    . "Result: " result "`n"
    . "Time: " elapsed "ms`n"
    . "Cache size: " expensiveFib.CacheSize)

; Partial application
multiply := (a, b, c) => a * b * c
multiplyBy2 := Partial(multiply, 2)
MsgBox("Partial Application:`n"
    . "multiply(2, 3, 4) = " multiply(2, 3, 4) "`n"
    . "multiplyBy2(3, 4) = " multiplyBy2(3, 4))

; Currying
curriedAdd := Curry((a, b, c) => a + b + c, 3)
MsgBox("Currying:`n"
    . "curriedAdd(1)(2)(3) = " curriedAdd(1)(2)(3))

; Pipeline
double := (x) => x * 2
addTen := (x) => x + 10
stringify := (x) => "Result: " x

pipelineFunc := Pipeline(double, addTen, stringify)
MsgBox("Pipeline:`n"
    . "pipelineFunc(5) = " pipelineFunc(5) "`n"
    . "(5 * 2 + 10 = 20)")

; Once
initOnce := Once(() => (MsgBox("Initializing..."), "initialized"))
MsgBox("Once Callable:`n"
    . "First: " initOnce() "`n"
    . "Second: " initOnce() "`n"
    . "(Only shows init message once)")

; Conditional
isEven := (n) => Mod(n, 2) = 0
doubleIfEven := When(isEven, (n) => n * 2, (n) => n)
MsgBox("Conditional Callable:`n"
    . "doubleIfEven(4) = " doubleIfEven(4) "`n"
    . "doubleIfEven(5) = " doubleIfEven(5))
