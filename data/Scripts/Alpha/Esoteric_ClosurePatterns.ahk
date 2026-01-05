#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Closure Patterns - Advanced closure techniques and gotchas
; Demonstrates closure capture, state management, and common pitfalls

; =============================================================================
; 1. Basic Closure State Capture
; =============================================================================

CreateCounter(start := 0) {
    count := start

    return {
        increment: () => ++count,
        decrement: () => --count,
        value: () => count,
        reset: () => count := start
    }
}

; =============================================================================
; 2. The Loop Closure Gotcha
; =============================================================================

class ClosureGotcha {
    ; WRONG: All closures share the same variable
    static CreateFunctionsWrong() {
        funcs := []
        Loop 5 {
            i := A_Index
            funcs.Push(() => i)  ; All return 5!
        }
        return funcs
    }

    ; RIGHT: Use IIFE (Immediately Invoked Function Expression)
    static CreateFunctionsIIFE() {
        funcs := []
        Loop 5 {
            funcs.Push(((n) => () => n)(A_Index))
        }
        return funcs
    }

    ; RIGHT: Use .Bind() to create new scope
    static CreateFunctionsBind() {
        funcs := []
        ReturnValue(n) => n
        Loop 5
            funcs.Push(ReturnValue.Bind(A_Index))
        return funcs
    }

    ; RIGHT: Use local variable in separate function
    static CreateFunctionsHelper() {
        funcs := []
        Loop 5
            funcs.Push(ClosureGotcha._makeFunc(A_Index))
        return funcs
    }

    static _makeFunc(n) => () => n
}

; =============================================================================
; 3. Closure-based Private State (Module Pattern)
; =============================================================================

CreateModule() {
    ; Private state
    _privateData := Map()
    _secretKey := Random(1000, 9999)

    ; Private method
    _validate(key) => key = _secretKey

    ; Return public interface
    return {
        set: (key, value) => _privateData[key] := value,
        get: (key) => _privateData.Get(key, ""),
        has: (key) => _privateData.Has(key),
        ; Secured method
        getSecret: (key) => _validate(key) ? "Secret data!" : "Access denied",
        ; Reveal key once (for demo)
        revealKeyOnce: () => (
            k := _secretKey,
            _secretKey := 0,  ; Invalidate after reveal
            k
        )
    }
}

; =============================================================================
; 4. Memoization with Closures
; =============================================================================

Memoize(fn) {
    cache := Map()

    return (args*) => (
        key := _argsToKey(args),
        cache.Has(key)
            ? cache[key]
        : cache[key] := fn(args*)
    )

    _argsToKey(args) {
        parts := []
        for arg in args
            parts.Push(Type(arg) ":" String(arg))
        return parts.Length ? JoinArr(parts, "|") : "_empty"
    }
}

JoinArr(arr, sep) {
    r := ""
    for i, v in arr
        r .= (i > 1 ? sep : "") v
    return r
}

; =============================================================================
; 5. Partial Application with Closures
; =============================================================================

Partial(fn, boundArgs*) {
    return (args*) => _PartialImpl(fn, boundArgs, args)
}

_PartialImpl(fn, boundArgs, args) {
    allArgs := []
    for arg in boundArgs
        allArgs.Push(arg)
    for arg in args
        allArgs.Push(arg)
    return fn(allArgs*)
}

; Curry implementation
Curry(fn, arity) {
    collected := []

    Collector(arg) {
        collected.Push(arg)

        if collected.Length >= arity {
            result := fn(collected*)
            collected := []
            return result
        }

        return Collector
    }

    return Collector
}

; =============================================================================
; 6. Event System with Closures
; =============================================================================

CreateEventEmitter() {
    handlers := Map()

    return {
        on: (event, handler) => _EventOn(event, handler, handlers),
        emit: (event, data*) => _EventEmit(event, data, handlers),
        once: (event, handler) => _EventOnce(event, handler, handlers)
    }
}

_EventOn(event, handler, handlers) {
    handlers.Has(event) || handlers[event] := []
    handlers[event].Push(handler)
    return () => _EventOff(event, handler, handlers)
}

_EventEmit(event, data, handlers) {
    if handlers.Has(event) {
        for h in handlers[event]
            h(data*)
    }
}

_EventOnce(event, handler, handlers) {
    wrapper := ""
    wrapper := (data*) => (
        handler(data*),
        _EventOff(event, wrapper, handlers)
    )
    handlers.Has(event) || handlers[event] := []
    handlers[event].Push(wrapper)
}

_EventOff(event, handler, handlers) {
    if handlers.Has(event) {
        newHandlers := []
        for h in handlers[event]
            if h != handler
                newHandlers.Push(h)
        handlers[event] := newHandlers
    }
}

; =============================================================================
; 7. Closure-based Generators
; =============================================================================

CreateGenerator(generatorFn) {
    state := { done: false, value: "" }
    iterator := generatorFn(
        (v) => (state.value := v, true),
        () => state.done := true
    )

    return {
        next: () => _GeneratorNext(state, iterator)
    }
}

_GeneratorNext(state, iterator) {
    if state.done
        return { done: true, value: "" }
    iterator()
    return { done: state.done, value: state.value }
}

; Range generator
RangeGenerator(start, end) {
    return CreateGenerator((yield, done) => _RangeGen(start, end, yield, done))
}

_RangeGen(start, end, yield, done) {
    current := start
    return () => current <= end ? yield(current++) : done()
}

; =============================================================================
; 8. Closure for Lazy Evaluation
; =============================================================================

Lazy(computeFn) {
    computed := false
    value := ""

    return () => _LazyEval(computed, value, computeFn)
}

_LazyEval(&computed, &value, computeFn) {
    if computed
        return value
    computed := true
    value := computeFn()
    return value
}

; Lazy sequence
LazySeq(items) {
    transformations := []

    return {
        map: (fn) => (transformations.Push({ type: "map", fn: fn }), this),
        filter: (fn) => (transformations.Push({ type: "filter", fn: fn }), this),
        toArray: () => _LazySeqToArray(items, transformations)
    }
}

_LazySeqToArray(items, transformations) {
    result := []
    for item in items {
        val := item
        skip := false

        for t in transformations {
            if t.type = "filter" {
                if !t.fn(val) {
                    skip := true
                    break
                }
            } else if t.type = "map" {
                val := t.fn(val)
            }
        }

        if !skip
            result.Push(val)
    }
    return result
}

; =============================================================================
; 9. Closure-based State Machine
; =============================================================================

CreateStateMachine(initialState, transitions) {
    currentState := initialState
    listeners := []

    return {
        getState: () => currentState,
        transition: (event) => _StateMachineTransition(currentState, event, transitions, listeners),
        onTransition: (callback) => listeners.Push(callback),
        canTransition: (event) => transitions.Has(currentState ":" event)
    }
}

_StateMachineTransition(&currentState, event, transitions, listeners) {
    key := currentState ":" event
    if transitions.Has(key) {
        oldState := currentState
        currentState := transitions[key]
        for listener in listeners
            listener(oldState, event, currentState)
        return currentState
    }
    return currentState
}

; =============================================================================
; Demo
; =============================================================================

; Counter
counter := CreateCounter(10)
MsgBox("Counter:`n"
    . "Initial: " counter.value() "`n"
    . "After ++: " counter.increment() "`n"
    . "After ++: " counter.increment() "`n"
    . "After --: " counter.decrement() "`n"
    . "After reset: " (counter.reset(), counter.value()))

; Loop closure gotcha
wrong := ClosureGotcha.CreateFunctionsWrong()
right := ClosureGotcha.CreateFunctionsIIFE()
MsgBox("Loop Closure Gotcha:`n`n"
    . "WRONG (all same): " wrong[1]() ", " wrong[2]() ", " wrong[3]() "`n"
    . "RIGHT (different): " right[1]() ", " right[2]() ", " right[3]())

; Module pattern
mod := CreateModule()
mod.set("name", "Alice")
mod.set("age", 30)
key := mod.revealKeyOnce()
MsgBox("Module Pattern:`n`n"
    . "Get name: " mod.get("name") "`n"
    . "Get age: " mod.get("age") "`n"
    . "Has name: " mod.has("name") "`n"
    . "Secret (wrong key): " mod.getSecret(0000) "`n"
    . "Secret (right key): " mod.getSecret(key))

; Memoized fibonacci
slowFib(n) => n <= 1 ? n : slowFib(n - 1) + slowFib(n - 2)
; Note: Memoize doesn't work recursively without self-reference
; This is for demonstration of the pattern
MsgBox("Memoization Pattern demonstrated (see code)")

; Partial application
add := (a, b, c) => a + b + c
add10 := Partial(add, 10)
MsgBox("Partial Application:`n"
    . "add(10, 5, 3) = " add(10, 5, 3) "`n"
    . "add10(5, 3) = " add10(5, 3))

; State machine
trafficLight := CreateStateMachine("red", Map(
    "red:timer", "green",
    "green:timer", "yellow",
    "yellow:timer", "red"
))

states := [trafficLight.getState()]
Loop 5 {
    trafficLight.transition("timer")
    states.Push(trafficLight.getState())
}
MsgBox("State Machine (Traffic Light):`n" JoinArr(states, " -> "))

; Lazy evaluation
lazyValue := Lazy(() => (Sleep(100), "Computed!"))
MsgBox("Lazy Evaluation:`n"
    . "First call (slow): " lazyValue() "`n"
    . "Second call (cached): " lazyValue())
