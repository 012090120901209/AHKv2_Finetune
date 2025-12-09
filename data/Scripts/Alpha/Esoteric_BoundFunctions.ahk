#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Bound Functions - Function binding, partial application, and currying
; Demonstrates advanced function manipulation in AHK v2

; =============================================================================
; 1. Basic Binding with ObjBindMethod
; =============================================================================

class Calculator {
    __New(initialValue := 0) {
        this.value := initialValue
    }
    
    Add(n) {
        this.value += n
        return this
    }
    
    Multiply(n) {
        this.value *= n
        return this
    }
    
    GetValue() => this.value
}

; =============================================================================
; 2. Manual Binding Implementation
; =============================================================================

; Bind function to context (thisArg)
Bind(fn, thisArg, args*) {
    return (callArgs*) => fn.Call(thisArg, args*, callArgs*)
}

; Bind with placeholder support
PLACEHOLDER := {__isPlaceholder: true}

BindWithPlaceholders(fn, args*) {
    return (callArgs*) => (
        mergedArgs := [],
        callIndex := 1,
        (for arg in args {
            if IsObject(arg) && arg.HasOwnProp("__isPlaceholder")
                mergedArgs.Push(callArgs[callIndex++])
            else
                mergedArgs.Push(arg)
        }),
        ; Add remaining args
        (while callIndex <= callArgs.Length
            mergedArgs.Push(callArgs[callIndex++])),
        fn(mergedArgs*)
    )
}

; =============================================================================
; 3. Partial Application
; =============================================================================

; Apply arguments from the left
PartialLeft(fn, boundArgs*) {
    return (args*) => fn(boundArgs*, args*)
}

; Apply arguments from the right
PartialRight(fn, boundArgs*) {
    return (args*) => fn(args*, boundArgs*)
}

; Example functions
Add3(a, b, c) => a + b + c
Greet(greeting, name, punctuation) => greeting . ", " . name . punctuation

; =============================================================================
; 4. Currying
; =============================================================================

; Auto-curry based on function length (using closure to track)
Curry(fn, arity := 0) {
    ; Note: AHK doesn't expose fn.length, so we pass arity
    collected := []
    
    Curried(args*) {
        for arg in args
            collected.Push(arg)
        
        if collected.Length >= arity
            return fn(collected*)
        
        return Curried
    }
    
    return Curried
}

; Manual curry implementation for specific arities
Curry2(fn) => (a) => (b) => fn(a, b)
Curry3(fn) => (a) => (b) => (c) => fn(a, b, c)
Curry4(fn) => (a) => (b) => (c) => (d) => fn(a, b, c, d)

; Uncurry - flatten curried function
Uncurry2(fn) => (a, b) => fn(a)(b)
Uncurry3(fn) => (a, b, c) => fn(a)(b)(c)

; =============================================================================
; 5. Function Composition
; =============================================================================

; Compose right to left: (f ∘ g)(x) = f(g(x))
Compose(fns*) {
    return (x) => (
        result := x,
        (loop fns.Length
            result := fns[fns.Length - A_Index + 1](result)),
        result
    )
}

; Pipe left to right
Pipe(fns*) {
    return (x) => (
        result := x,
        (for fn in fns
            result := fn(result)),
        result
    )
}

; =============================================================================
; 6. Function Decorators
; =============================================================================

; Memoization decorator
Memoize(fn) {
    cache := Map()
    
    return (args*) => (
        key := _ArgsToKey(args),
        cache.Has(key) ? cache[key] : (cache[key] := fn(args*))
    )
}

_ArgsToKey(args) {
    parts := []
    for arg in args
        parts.Push(String(arg))
    return _JoinArr(parts, "|")
}

_JoinArr(arr, sep) {
    result := ""
    for i, v in arr
        result .= (i > 1 ? sep : "") . v
    return result
}

; Timing decorator
TimedCall(fn, &elapsed) {
    return (args*) => (
        start := A_TickCount,
        result := fn(args*),
        elapsed := A_TickCount - start,
        result
    )
}

; Once - only execute first time
Once(fn) {
    called := false
    cachedResult := ""
    
    return (args*) => (
        called ? cachedResult : (
            called := true,
            cachedResult := fn(args*)
        )
    )
}

; Debounce
Debounce(fn, delayMs) {
    timerId := 0
    
    return (args*) => (
        SetTimer((*) => 0, 0),  ; Clear any pending
        timerId := SetTimer((*) => fn(args*), -delayMs)
    )
}

; Throttle
Throttle(fn, intervalMs) {
    lastCall := 0
    
    return (args*) => (
        now := A_TickCount,
        (now - lastCall >= intervalMs) ? (
            lastCall := now,
            fn(args*)
        ) : ""
    )
}

; =============================================================================
; 7. Flip and Reverse Arguments
; =============================================================================

; Flip first two arguments
Flip(fn) => (a, b, rest*) => fn(b, a, rest*)

; Reverse all arguments
ReverseArgs(fn) {
    return (args*) => (
        reversed := [],
        (loop args.Length
            reversed.Push(args[args.Length - A_Index + 1])),
        fn(reversed*)
    )
}

; =============================================================================
; 8. Bound Method Collection
; =============================================================================

class MethodBinder {
    __New(target) {
        this.target := target
        this.boundMethods := Map()
    }
    
    ; Get or create bound method
    __Item[methodName] {
        get {
            if !this.boundMethods.Has(methodName) {
                if !HasMethod(this.target, methodName)
                    throw MethodError("Method not found: " methodName)
                this.boundMethods[methodName] := ObjBindMethod(this.target, methodName)
            }
            return this.boundMethods[methodName]
        }
    }
    
    ; Bind all methods at once
    BindAll(methodNames*) {
        for name in methodNames
            this[name]  ; Force bind
        return this
    }
}

; =============================================================================
; 9. Method Chaining via Binding
; =============================================================================

class ChainBuilder {
    __New(initialValue) {
        this.value := initialValue
        this.operations := []
    }
    
    ; Add operation to chain
    Then(fn) {
        this.operations.Push(fn)
        return this
    }
    
    ; Execute all operations
    Execute() {
        result := this.value
        for op in this.operations
            result := op(result)
        return result
    }
    
    ; Create bound chain from array of functions
    static FromFunctions(initial, fns*) {
        builder := ChainBuilder(initial)
        for fn in fns
            builder.Then(fn)
        return builder
    }
}

; =============================================================================
; 10. Continuation Passing Style (CPS)
; =============================================================================

; CPS transformed functions
AddCPS(a, b, cont) => cont(a + b)
MultiplyCPS(a, b, cont) => cont(a * b)

; Chain CPS operations
ChainCPS(operations*) {
    return (initial, finalCont) => (
        _RunCPS(initial, operations, 1, finalCont)
    )
}

_RunCPS(value, ops, index, finalCont) {
    if index > ops.Length {
        finalCont(value)
        return
    }
    ops[index](value, (result) => _RunCPS(result, ops, index + 1, finalCont))
}

; =============================================================================
; Demo
; =============================================================================

; Basic binding
calc := Calculator(10)
add5 := ObjBindMethod(calc, "Add", 5)
add5.Call()
MsgBox("Bound Method:`n`nCalc started at 10, add5() called`nResult: " calc.GetValue())

; Manual binding
calc2 := Calculator(0)
boundAdd := Bind(Calculator.Prototype.Add, calc2)
boundAdd(100)
MsgBox("Manual Bind:`n`nCalc2 + 100 = " calc2.GetValue())

; Partial application
add5Always := PartialLeft(Add3, 5)
MsgBox("Partial Left:`n`nadd5Always(10, 20) = " add5Always(10, 20))

greetHello := PartialLeft(Greet, "Hello")
greetExclaim := PartialRight(greetHello, "!")
MsgBox("Partial Combination:`n`n" greetExclaim("World"))

; Currying
curriedAdd := Curry3(Add3)
add5Curry := curriedAdd(5)
add5and10 := add5Curry(10)
MsgBox("Currying:`n`ncurriedAdd(5)(10)(15) = " add5and10(15))

; Composition
double := (x) => x * 2
addOne := (x) => x + 1
square := (x) => x * x

composed := Compose(square, addOne, double)  ; square(addOne(double(x)))
MsgBox("Composition:`n`n(square ∘ addOne ∘ double)(3) = " composed(3))

piped := Pipe(double, addOne, square)  ; square(addOne(double(x)))
MsgBox("Pipe (same result):`n`npipe(double, addOne, square)(3) = " piped(3))

; Memoization
slowFib(n) {
    if n <= 1
        return n
    return slowFib(n - 1) + slowFib(n - 2)
}

fastFib := Memoize(slowFib)
; Note: Memoize helps with repeated calls, not recursive structure
MsgBox("Memoized fib(10): " fastFib(10))

; Timed call
timedFib := TimedCall(slowFib, &time)
result := timedFib(20)
MsgBox("Timed Call:`n`nfib(20) = " result "`nTime: " time "ms")

; Once
initOnce := Once(() => (MsgBox("Initializing!"), "initialized"))
initOnce()  ; Shows message
initOnce()  ; Silent, returns cached
initOnce()  ; Silent, returns cached
MsgBox("Once was only called once")

; Flip
subtract := (a, b) => a - b
MsgBox("Flip:`n`nsubtract(10, 3) = " subtract(10, 3) "`nFlip(subtract)(10, 3) = " Flip(subtract)(10, 3))

; Method binder
calc3 := Calculator(50)
binder := MethodBinder(calc3).BindAll("Add", "Multiply", "GetValue")
binder["Add"](25)
binder["Multiply"](2)
MsgBox("Method Binder:`n`n50 + 25, then * 2 = " binder["GetValue"]())

; Chain builder
chain := ChainBuilder(5)
    .Then((x) => x * 2)
    .Then((x) => x + 10)
    .Then((x) => x ** 2)
MsgBox("Chain Builder:`n`n((5 * 2) + 10)² = " chain.Execute())

; CPS
ChainCPS(
    (x, cont) => AddCPS(x, 10, cont),
    (x, cont) => MultiplyCPS(x, 2, cont),
    (x, cont) => AddCPS(x, 5, cont)
)(5, (result) => MsgBox("CPS Chain:`n`n((5 + 10) * 2) + 5 = " result))
