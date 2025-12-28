#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric VarRef Patterns - Pass-by-reference and pointer-like operations
; Demonstrates advanced reference manipulation in AHK v2

; =============================================================================
; 1. Basic VarRef - Pass by Reference
; =============================================================================

; Simple swap using VarRef
Swap(&a, &b) {
    temp := a
    a := b
    b := temp
}

; Increment by reference
Inc(&value, amount := 1) => value += amount

; Multiple returns via reference
ParseCoords(input, &x, &y) {
    parts := StrSplit(input, ",")
    x := Integer(Trim(parts[1]))
    y := Integer(Trim(parts[2]))
    return true
}

; =============================================================================
; 2. VarRef as First-Class Values
; =============================================================================

; Store reference in variable
CreateRef(&var) => &var

; Dereference stored reference
Deref(ref) => %ref%

; Modify through stored reference
ModifyRef(ref, newValue) {
    %ref% := newValue
}

; Reference to array element doesn't work directly - need wrapper
class RefCell {
    __New(value := "") => this.value := value

    Get() => this.value
    Set(&v) => this.value := v

    ; Allow using as VarRef target
    __Item {
        get => this.value
        set => this.value := value
    }
}

; =============================================================================
; 3. Output Parameters Pattern
; =============================================================================

; Try-parse pattern
TryParseInt(str, &outValue) {
    try {
        outValue := Integer(str)
        return true
    }
    return false
}

; Multiple output parameters
Divide(dividend, divisor, &quotient, &remainder) {
    if divisor = 0
        return false
    quotient := dividend // divisor
    remainder := Mod(dividend, divisor)
    return true
}

; Optional output parameter using default
GetOrCreate(map, key, &existed := false) {
    existed := map.Has(key)
    if !existed
        map[key] := Map()
    return map[key]
}

; =============================================================================
; 4. Reference Binding and Closures
; =============================================================================

; Closure captures by value by default
MakeCounter() {
    count := 0
    return () => ++count
}

; Explicit reference sharing between closures
MakeLinkedCounters() {
    shared := { value: 0 }  ; Object reference shared

    return {
        inc: () => ++shared.value,
        dec: () => --shared.value,
        get: () => shared.value
    }
}

; Reference binding in event handlers
BindToRef(&var) {
    return (newValue) => var := newValue
}

; =============================================================================
; 5. Reference Collections
; =============================================================================

; Track multiple variables by reference
class RefTracker {
    __New() {
        this.refs := []
        this.names := []
    }

    ; Store a reference with a name
    Track(name, &var) {
        this.refs.Push(&var)
        this.names.Push(name)
    }

    ; Update all tracked refs
    SetAll(value) {
        for ref in this.refs
            %ref% := value
    }

    ; Get snapshot of all values
    Snapshot() {
        result := Map()
        for i, ref in this.refs
            result[this.names[i]] := %ref%
        return result
    }

    ; Apply function to all refs
    MapInPlace(fn) {
        for ref in this.refs
            %ref% := fn(%ref%)
    }
}

; =============================================================================
; 6. Two-Way Binding Pattern
; =============================================================================

class TwoWayBinding {
    __New(&source) {
        this.sourceRef := &source
        this.targets := []
        this.transforms := []
    }

    ; Bind target with optional transform
    Bind(&target, transform := (v) => v, inverse := (v) => v) {
        this.targets.Push({ ref: &target, transform: transform, inverse: inverse })
        target := transform(%this.sourceRef%)  ; Initial sync
        return this
    }

    ; Update source and propagate to all targets
    Update(value) {
        %this.sourceRef% := value
        for binding in this.targets
            %binding.ref% := binding.transform(value)
    }

    ; Sync back from target to source (by index)
    SyncBack(targetIndex) {
        binding := this.targets[targetIndex]
        newValue := binding.inverse(%binding.ref%)
        this.Update(newValue)
    }
}

; =============================================================================
; 7. Lazy Reference Wrapper
; =============================================================================

class LazyRef {
    __New(initializer) {
        this._init := initializer
        this._hasValue := false
        this._value := ""
    }

    ; Get or compute value
    Value {
        get {
            if !this._hasValue {
                this._value := this._init()
                this._hasValue := true
            }
            return this._value
        }
        set {
            this._value := value
            this._hasValue := true
        }
    }

    ; Force recomputation on next access
    Invalidate() {
        this._hasValue := false
    }

    ; Check without forcing computation
    HasValue => this._hasValue
}

; =============================================================================
; 8. Reference-Based State Machine
; =============================================================================

class RefStateMachine {
    __New(&stateVar) {
        this.stateRef := &stateVar
        this.transitions := Map()
        this.onEnter := Map()
        this.onExit := Map()
    }

    ; Define valid transition
    Allow(from, to, &via := unset) {
        if !this.transitions.Has(from)
            this.transitions[from] := Map()

        handler := IsSet(via) ? () => %via%() : () => true
        this.transitions[from][to] := handler
        return this
    }

    ; Register enter callback
    OnEnter(state, callback) {
        this.onEnter[state] := callback
        return this
    }

    ; Register exit callback
    OnExit(state, callback) {
        this.onExit[state] := callback
        return this
    }

    ; Attempt transition
    TransitionTo(newState) {
        current := %this.stateRef%

        if !this.transitions.Has(current)
            return false
        if !this.transitions[current].Has(newState)
            return false

        handler := this.transitions[current][newState]
        if !handler()
            return false

        ; Exit current
        if this.onExit.Has(current)
            this.onExit[current]()

        ; Transition
        %this.stateRef% := newState

        ; Enter new
        if this.onEnter.Has(newState)
            this.onEnter[newState]()

        return true
    }

    Current => %this.stateRef%
}

; =============================================================================
; Demo
; =============================================================================

; Basic VarRef
a := 10
b := 20
MsgBox("VarRef Swap:`n`nBefore: a=" a ", b=" b)
Swap(&a, &b)
MsgBox("After: a=" a ", b=" b)

; Inc by reference
counter := 0
Inc(&counter)
Inc(&counter, 5)
MsgBox("Inc by Ref:`n`ncounter = " counter)

; Parse with output params
str := "123, 456"
ParseCoords(str, &px, &py)
MsgBox("ParseCoords:`n`nInput: '" str "'`nx=" px ", y=" py)

; Reference as first-class
x := 100
ref := CreateRef(&x)
MsgBox("First-class Ref:`n`nx = " x "`nDeref(ref) = " Deref(ref))
ModifyRef(ref, 999)
MsgBox("After ModifyRef: x = " x)

; TryParse pattern
if TryParseInt("42", &parsedValue)
    MsgBox("TryParse Success: " parsedValue)

; Divide with multiple outs
if Divide(17, 5, &q, &r)
    MsgBox("Divide(17, 5):`n`nQuotient: " q "`nRemainder: " r)

; Linked counters (shared state)
counters := MakeLinkedCounters()
counters.inc()
counters.inc()
counters.dec()
MsgBox("Linked Counters:`n`nValue after ++, ++, --: " counters.get())

; RefTracker
tracker := RefTracker()
v1 := 1
v2 := 2
v3 := 3
tracker.Track("v1", &v1)
tracker.Track("v2", &v2)
tracker.Track("v3", &v3)

tracker.MapInPlace((x) => x * 10)
MsgBox("RefTracker MapInPlace (*10):`n`nv1=" v1 ", v2=" v2 ", v3=" v3)

; LazyRef
expensive := LazyRef(() => (Sleep(100), "computed after 100ms"))
MsgBox("LazyRef:`n`nHasValue before: " expensive.HasValue "`nValue: " expensive.Value "`nHasValue after: " expensive.HasValue)

; State Machine
state := "idle"
sm := RefStateMachine(&state)
sm.Allow("idle", "loading")
    .Allow("loading", "ready")
    .Allow("loading", "error")
    .Allow("ready", "idle")
    .Allow("error", "idle")
    .OnEnter("loading", () => MsgBox("Entering loading state..."))
    .OnEnter("ready", () => MsgBox("Ready!"))

sm.TransitionTo("loading")
sm.TransitionTo("ready")
MsgBox("State Machine:`n`nFinal state: " state)
