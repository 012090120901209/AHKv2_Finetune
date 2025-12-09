# AutoHotkey v2.1-Alpha Modern Programming Guide

> A comprehensive guide to cutting-edge AHK v2.1-alpha patterns, naming conventions, and advanced techniques for LLM training data.

**Version:** 2.1-alpha.17+
**Last Updated:** December 2025

---

## Table of Contents

1. [File & Code Naming Standards](#file--code-naming-standards)
2. [Modern Syntax Patterns](#modern-syntax-patterns)
3. [Prototype Extension Patterns](#prototype-extension-patterns)
4. [Functional Programming Patterns](#functional-programming-patterns)
5. [Advanced OOP Patterns](#advanced-oop-patterns)
6. [Property Descriptor Patterns](#property-descriptor-patterns)
7. [Low-Level & Performance Patterns](#low-level--performance-patterns)
8. [Best Practices Summary](#best-practices-summary)

---

## File & Code Naming Standards

### File Naming Convention

Files follow a consistent, task-centric naming pattern:

```
[Category]_[Feature]_[Detail].ahk
```

**Rules:**
- Use descriptive, task-centric stems: `Hotkey_Label_Chaining`, `Clipboard_Watcher`, `Gui_MenuInit`
- Avoid migration/bug-tracker language (`V1toV2`, `Issue_#123`, `StressTest`)
- Use CamelCase or snake_case consistently within a folder
- Suffix numerals only when variants exist (`Gui_MenuInit_01`, `_02`)
- Ensure numerals match documentation references

**Examples:**
```
BuiltIn_FileRead_01_BasicReading.ahk
String_StrReplace_ex01.ahk
GUI_MsgBox_ex01.ahk
OOP_Pattern_Observer.ahk
Hotkey_01_Basic_F1.ahk
Advanced_Stream_LazyEvaluation.ahk
```

### Function, Label & Variable Names

```ahk
; ✓ Good - Semantic, role-aligned names
InitGlobalState()
HandleHotkey()
ShowTooltip()
ProcessUserInput()

; ✗ Bad - Converter artifacts
V1toV2_GblCode_001()
test_func_123()
```

**Labels (when necessary):**
```ahk
; Use verbs or outcomes
StartLoop:
HandleEscape:
ProcessComplete:
```

### Comment Style

```ahk
; One-line summary at file start describing the automation pattern
; Demonstrates array manipulation with functional chaining

; Use bullets for multi-line explanations:
; - First point about behavior
; - Second point about edge cases
; - Third point about inputs

; Convert issue references to narrative context:
; Demonstrates menu parameter handling (addresses legacy edge case)
```

---

## Modern Syntax Patterns

### Required Directive

All modern scripts should start with:

```ahk
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force
```

### Fat Arrow Functions

```ahk
; Single expression - implicit return
Add := (a, b) => a + b
Square := (x) => x ** 2
Identity := (x) => x

; Multi-statement with block
Process := (data) => {
    result := Transform(data)
    return Validate(result)
}

; Property getters
class Config {
    static Debug => A_IsCompiled ? false : true
    static Version => "2.1.0"
}
```

### Optional Parameters with ??

```ahk
; Nullish coalescing for defaults
FormatOutput(text, prefix?, suffix?) {
    prefix := prefix ?? "["
    suffix := suffix ?? "]"
    return prefix . text . suffix
}

; Chained nullish coalescing
GetValue(primary?, fallback?, default := "none") {
    return primary ?? fallback ?? default
}
```

### Destructuring Patterns

```ahk
; Array destructuring via multiple assignment
[first, second, rest*] := SplitData(input)

; Object property extraction
ExtractCoords(point) {
    return [point.x, point.y]
}
```

### Modern Loop Patterns

```ahk
; For-each with index
for index, value in myArray {
    ProcessItem(value, index)
}

; For-each over Map
for key, val in myMap {
    OutputDebug(key . ": " . val)
}

; Range-based iteration (custom)
for n in Range(1, 10) {
    result += n
}
```

---

## Prototype Extension Patterns

### Direct Prototype Injection

The modern approach to extending built-in types:

```ahk
; Inject properties into String prototype
String.Prototype.DefineProp("Reversed", {
    Get: (this) => StrReverse(this)
})

String.Prototype.DefineProp("Words", {
    Get: (this) => StrSplit(Trim(this), " ")
})

String.Prototype.DefineProp("IsEmpty", {
    Get: (this) => this = ""
})

; Inject methods
String.Prototype.DefineProp("Contains", {
    Call: (this, needle) => InStr(this, needle) > 0
})

; Helper function
StrReverse(s) {
    r := ""
    Loop Parse s
        r := A_LoopField . r
    return r
}

; Usage
MsgBox("hello".Reversed)        ; "olleh"
MsgBox("hello world".Words[1])  ; "hello"
MsgBox("test".Contains("es"))   ; true
```

### Property Descriptor DSL

```ahk
class Prop {
    static Get(Fn) => {Get: Fn}
    static Set(Fn) => {Set: Fn}
    static GetSet(GetFn, SetFn) => {Get: GetFn, Set: SetFn}
    static Call(Fn) => {Call: Fn}
    static Value(Val) => {Value: Val}
    static Computed(Fn) => {Get: Fn}
    static Readonly(Val) => {Get: (*) => Val}
}

; Usage - clean property definitions
Array.Prototype.DefineProp("First", Prop.Get((this) => this.Length ? this[1] : ""))
Array.Prototype.DefineProp("Last", Prop.Get((this) => this.Length ? this[this.Length] : ""))
Array.Prototype.DefineProp("IsEmpty", Prop.Computed((this) => this.Length = 0))
```

### Extension Registry Pattern

```ahk
class Extensions {
    static Registry := Map()

    static Register(TargetName, ExtensionClass) {
        Target := %TargetName%

        for PropName in ExtensionClass.Prototype.OwnProps() {
            if PropName = "__Class"
                continue

            Desc := ExtensionClass.Prototype.GetOwnPropDesc(PropName)
            Target.Prototype.DefineProp(PropName, Desc)
        }

        Extensions.Registry[TargetName] := ExtensionClass
    }

    static Unregister(TargetName) {
        if !Extensions.Registry.Has(TargetName)
            return

        ExtensionClass := Extensions.Registry[TargetName]
        Target := %TargetName%

        for PropName in ExtensionClass.Prototype.OwnProps() {
            if PropName != "__Class"
                Target.Prototype.DeleteProp(PropName)
        }

        Extensions.Registry.Delete(TargetName)
    }
}

; Define extensions as clean classes
class StringExtensions {
    Reverse() {
        r := ""
        Loop Parse this
            r := A_LoopField . r
        return r
    }

    Words => StrSplit(Trim(this), " ")

    Shout() => StrUpper(this) . "!"
}

; Register
Extensions.Register("String", StringExtensions)

; Usage
MsgBox("hello".Shout())  ; "HELLO!"
```

---

## Functional Programming Patterns

### Array Functional Methods

```ahk
; Inject functional methods into Array
class ArrayFunctional {
    static Inject() {
        P := Array.Prototype

        ; Transformations
        P.DefineProp("Map", {Call: (this, fn) => ArrayFunctional._Map(this, fn)})
        P.DefineProp("Filter", {Call: (this, fn) => ArrayFunctional._Filter(this, fn)})
        P.DefineProp("Reduce", {Call: (this, fn, init?) => ArrayFunctional._Reduce(this, fn, init?)})
        P.DefineProp("FlatMap", {Call: (this, fn) => ArrayFunctional._FlatMap(this, fn)})

        ; Predicates
        P.DefineProp("Every", {Call: (this, fn) => ArrayFunctional._Every(this, fn)})
        P.DefineProp("Some", {Call: (this, fn) => ArrayFunctional._Some(this, fn)})
        P.DefineProp("Find", {Call: (this, fn) => ArrayFunctional._Find(this, fn)})

        ; Aggregations
        P.DefineProp("Sum", {Get: (this) => ArrayFunctional._Sum(this)})
        P.DefineProp("Min", {Get: (this) => ArrayFunctional._Min(this)})
        P.DefineProp("Max", {Get: (this) => ArrayFunctional._Max(this)})

        ; Utilities
        P.DefineProp("Join", {Call: (this, d?) => ArrayFunctional._Join(this, d ?? ",")})
        P.DefineProp("Unique", {Get: (this) => ArrayFunctional._Unique(this)})
        P.DefineProp("Reversed", {Get: (this) => ArrayFunctional._Reverse(this)})
    }

    static _Map(arr, fn) {
        r := []
        for i, v in arr
            r.Push(fn(v, i))
        return r
    }

    static _Filter(arr, fn) {
        r := []
        for i, v in arr
            if fn(v, i)
                r.Push(v)
        return r
    }

    static _Reduce(arr, fn, init?) {
        if !arr.Length
            return init ?? ""
        i := 1
        acc := IsSet(init) ? init : arr[i++]
        while i <= arr.Length {
            acc := fn(acc, arr[i], i)
            i++
        }
        return acc
    }

    static _FlatMap(arr, fn) {
        r := []
        for i, v in arr {
            result := fn(v, i)
            if result is Array
                r.Push(result*)
            else
                r.Push(result)
        }
        return r
    }

    static _Every(arr, fn) {
        for i, v in arr
            if !fn(v, i)
                return false
        return true
    }

    static _Some(arr, fn) {
        for i, v in arr
            if fn(v, i)
                return true
        return false
    }

    static _Find(arr, fn) {
        for i, v in arr
            if fn(v, i)
                return v
        return ""
    }

    static _Sum(arr) {
        t := 0
        for v in arr
            t += v ?? 0
        return t
    }

    static _Min(arr) {
        if !arr.Length
            return ""
        m := arr[1]
        for v in arr
            if v < m
                m := v
        return m
    }

    static _Max(arr) {
        if !arr.Length
            return ""
        m := arr[1]
        for v in arr
            if v > m
                m := v
        return m
    }

    static _Join(arr, d) {
        r := ""
        for i, v in arr
            r .= (i > 1 ? d : "") . v
        return r
    }

    static _Unique(arr) {
        seen := Map()
        r := []
        for v in arr {
            if !seen.Has(v) {
                seen[v] := true
                r.Push(v)
            }
        }
        return r
    }

    static _Reverse(arr) {
        r := []
        i := arr.Length
        while i >= 1
            r.Push(arr[i--])
        return r
    }
}

; Initialize
ArrayFunctional.Inject()

; Usage examples
numbers := [1, 2, 3, 4, 5]

doubled := numbers.Map((x) => x * 2)           ; [2, 4, 6, 8, 10]
evens := numbers.Filter((x) => Mod(x, 2) = 0)  ; [2, 4]
sum := numbers.Reduce((acc, x) => acc + x, 0)  ; 15
hasEven := numbers.Some((x) => Mod(x, 2) = 0)  ; true
allPositive := numbers.Every((x) => x > 0)    ; true
```

### Function Utilities

```ahk
class Fn {
    ; Identity and constants
    static Identity(x) => x
    static Constant(x) => (*) => x
    static Noop(*) => ""

    ; Composition
    static Compose(fns*) {
        return (x) {
            i := fns.Length
            while i >= 1
                x := fns[i--](x)
            return x
        }
    }

    static Pipe(fns*) {
        return (x) {
            for fn in fns
                x := fn(x)
            return x
        }
    }

    ; Higher-order utilities
    static Memoize(fn) {
        cache := Map()
        return (args*) {
            key := ""
            for a in args
                key .= "|" . String(a)
            if !cache.Has(key)
                cache[key] := fn(args*)
            return cache[key]
        }
    }

    static Debounce(fn, ms) {
        timer := 0
        return (args*) {
            if timer
                SetTimer(timer, 0)
            timer := fn.Bind(args*)
            SetTimer(timer, -ms)
        }
    }

    static Throttle(fn, ms) {
        lastCall := 0
        return (args*) {
            now := A_TickCount
            if now - lastCall >= ms {
                lastCall := now
                return fn(args*)
            }
        }
    }

    static Once(fn) {
        called := false
        result := ""
        return (args*) {
            if !called {
                called := true
                result := fn(args*)
            }
            return result
        }
    }

    ; Predicates
    static Negate(fn) => (args*) => !fn(args*)
    static Flip(fn) => (a, b) => fn(b, a)

    ; Comparators
    static Eq(a) => (b) => a = b
    static Gt(a) => (b) => b > a
    static Lt(a) => (b) => b < a
    static Gte(a) => (b) => b >= a
    static Lte(a) => (b) => b <= a

    ; Arithmetic
    static Add(a) => (b) => b + a
    static Sub(a) => (b) => b - a
    static Mul(a) => (b) => b * a
    static Div(a) => (b) => b / a
}

; Usage
doubled := Fn.Mul(2)
incremented := Fn.Add(1)
process := Fn.Pipe(doubled, incremented, Fn.Mul(3))
result := process(5)  ; ((5 * 2) + 1) * 3 = 33

; Memoized fibonacci
fib := Fn.Memoize((n) => n <= 1 ? n : fib(n - 1) + fib(n - 2))
```

### Stream/Lazy Evaluation

```ahk
class Stream {
    __New(source) {
        this._source := source is Array ? source : [source]
        this._ops := []
    }

    static Of(items*) => Stream(items)
    static Range(start, end, step := 1) {
        r := []
        i := start
        while (step > 0 ? i <= end : i >= end) {
            r.Push(i)
            i += step
        }
        return Stream(r)
    }

    Map(fn) {
        this._ops.Push({type: "map", fn: fn})
        return this
    }

    Filter(fn) {
        this._ops.Push({type: "filter", fn: fn})
        return this
    }

    Take(n) {
        this._ops.Push({type: "take", n: n})
        return this
    }

    Drop(n) {
        this._ops.Push({type: "drop", n: n})
        return this
    }

    Distinct() {
        this._ops.Push({type: "distinct"})
        return this
    }

    _Execute() {
        result := this._source.Clone()

        for op in this._ops {
            switch op.type {
                case "map":
                    newResult := []
                    for v in result
                        newResult.Push(op.fn(v))
                    result := newResult
                case "filter":
                    newResult := []
                    for v in result
                        if op.fn(v)
                            newResult.Push(v)
                    result := newResult
                case "take":
                    newResult := []
                    Loop Min(op.n, result.Length)
                        newResult.Push(result[A_Index])
                    result := newResult
                case "drop":
                    newResult := []
                    i := op.n + 1
                    while i <= result.Length
                        newResult.Push(result[i++])
                    result := newResult
                case "distinct":
                    seen := Map()
                    newResult := []
                    for v in result {
                        if !seen.Has(v) {
                            seen[v] := true
                            newResult.Push(v)
                        }
                    }
                    result := newResult
            }
        }
        return result
    }

    ; Terminal operations
    Collect() => this._Execute()
    ToArray() => this._Execute()

    ForEach(fn) {
        for v in this._Execute()
            fn(v)
    }

    Reduce(fn, init?) {
        arr := this._Execute()
        if !arr.Length
            return init ?? ""
        i := 1
        acc := IsSet(init) ? init : arr[i++]
        while i <= arr.Length {
            acc := fn(acc, arr[i], i)
            i++
        }
        return acc
    }

    Sum() => this.Reduce((a, b) => a + b, 0)
    Count() => this._Execute().Length
    First() => this._Execute()[1] ?? ""

    Join(d := ",") {
        arr := this._Execute()
        r := ""
        for i, v in arr
            r .= (i > 1 ? d : "") . v
        return r
    }
}

; Usage
result := Stream.Range(1, 100)
    .Filter((x) => Mod(x, 3) = 0)
    .Map((x) => x * 2)
    .Take(10)
    .Collect()
; [6, 12, 18, 24, 30, 36, 42, 48, 54, 60]
```

---

## Advanced OOP Patterns

### Dynamic Class Factory (v2.1-alpha.3+)

```ahk
CreateDynamicClass(BaseClass, Name, Members) {
    Cls := Class(BaseClass)
    Cls.Prototype.__Class := Name

    for PropName, Descriptor in Members {
        if Descriptor.HasOwnProp("Call")
            Cls.Prototype.DefineProp(PropName, Descriptor)
        else if Descriptor.HasOwnProp("Get") || Descriptor.HasOwnProp("Set")
            Cls.Prototype.DefineProp(PropName, Descriptor)
        else
            Cls.Prototype.DefineProp(PropName, {Value: Descriptor})
    }
    return Cls
}

; Create a custom String class
StringEx := CreateDynamicClass(String, "StringEx", Map(
    "Reverse", {Call: (this) => StrReverse(this)},
    "Words", {Get: (this) => StrSplit(this, " ")},
    "IsEmail", {Call: (this) => RegExMatch(this, "^\S+@\S+\.\S+$")}
))
```

### Prototype Injector

```ahk
class ProtoInjector {
    static Inject(TargetClass, SourceClass) {
        Proto := TargetClass.Prototype

        ; Inject instance members
        for PropName in SourceClass.Prototype.OwnProps() {
            if PropName = "__Class"
                continue

            Desc := SourceClass.Prototype.GetOwnPropDesc(PropName)
            Proto.DefineProp(PropName, Desc)
        }

        ; Inject static members
        for PropName in SourceClass.OwnProps() {
            if PropName ~= "^(Prototype|__Init)$"
                continue

            Desc := SourceClass.GetOwnPropDesc(PropName)
            TargetClass.DefineProp(PropName, Desc)
        }
    }
}
```

### Lazy Property with Memoization

```ahk
class LazyProp {
    static Create(Compute) {
        return {
            Get: (this) {
                if !this.HasOwnProp("__lazy_cache")
                    this.DefineProp("__lazy_cache", {Value: Map()})

                Key := ObjPtr(Compute)
                if !this.__lazy_cache.Has(Key)
                    this.__lazy_cache[Key] := Compute(this)

                return this.__lazy_cache[Key]
            }
        }
    }
}

; Usage - computed property that caches on first access
Array.Prototype.DefineProp("Sum", LazyProp.Create((arr) {
    total := 0
    for v in arr
        total += v ?? 0
    return total
}))
```

### Type-Safe Properties

```ahk
class TypedProp {
    static String(PropName, DefaultVal := "") {
        return TypedProp._Create(PropName, DefaultVal, (v) => v is String)
    }

    static Number(PropName, DefaultVal := 0) {
        return TypedProp._Create(PropName, DefaultVal, (v) => v is Number)
    }

    static Array(PropName) {
        return TypedProp._Create(PropName, [], (v) => v is Array)
    }

    static _Create(PropName, DefaultVal, Validator) {
        StorageKey := "_" . PropName
        return {
            Get: (this) => this.HasOwnProp(StorageKey) ? this.%StorageKey% : DefaultVal,
            Set: (this, value) {
                if !Validator(value)
                    throw TypeError("Invalid type for " . PropName)
                this.%StorageKey% := value
            }
        }
    }
}

; Usage
class User {
    static __New() {
        this.Prototype.DefineProp("Name", TypedProp.String("Name"))
        this.Prototype.DefineProp("Age", TypedProp.Number("Age"))
        this.Prototype.DefineProp("Tags", TypedProp.Array("Tags"))
    }
}
```

### Optional/Result Monads

```ahk
class Opt {
    __New(val?, hasVal := false) {
        this._val := val ?? ""
        this._has := hasVal
    }

    static Some(v) => Opt(v, true)
    static None() => Opt()
    static Of(v) => (v = "" || !IsSet(v)) ? Opt.None() : Opt.Some(v)

    IsSome => this._has
    IsNone => !this._has
    Value => this._has ? this._val : ""

    Get() => this._has ? this._val : (throw Error("Opt is None"))
    GetOr(d) => this._has ? this._val : d
    GetOrElse(fn) => this._has ? this._val : fn()

    Map(fn) => this._has ? Opt.Some(fn(this._val)) : Opt.None()
    FlatMap(fn) => this._has ? fn(this._val) : Opt.None()
    Filter(fn) => (this._has && fn(this._val)) ? this : Opt.None()

    Match(some, none) => this._has ? some(this._val) : none()
}

class Result {
    __New(val, err, ok := true) {
        this._val := val
        this._err := err
        this._ok := ok
    }

    static Ok(v) => Result(v, "", true)
    static Err(e) => Result("", e, false)
    static Try(fn, args*) {
        try
            return Result.Ok(fn(args*))
        catch as e
            return Result.Err(e)
    }

    IsOk => this._ok
    IsErr => !this._ok

    Get() => this._ok ? this._val : (throw this._err)
    GetOr(d) => this._ok ? this._val : d

    Map(fn) => this._ok ? Result.Ok(fn(this._val)) : this
    MapErr(fn) => this._ok ? this : Result.Err(fn(this._err))

    Match(ok, err) => this._ok ? ok(this._val) : err(this._err)
}

; Usage
result := Result.Try(() => FileRead("config.ini"))
    .Map((content) => StrSplit(content, "`n"))
    .GetOr(["default=true"])

maybeUser := Opt.Of(GetUserById(123))
    .Map((u) => u.name)
    .Filter((n) => StrLen(n) > 2)
    .GetOr("Anonymous")
```

### Pattern Matching

```ahk
class Match {
    __New(val) {
        this._val := val
        this._matched := false
        this._result := ""
    }

    static On(v) => Match(v)

    When(pred, fn) {
        if this._matched
            return this

        matched := false
        if pred is Func
            matched := pred(this._val)
        else
            matched := this._val = pred

        if matched {
            this._matched := true
            this._result := fn is Func ? fn(this._val) : fn
        }
        return this
    }

    WhenType(typeName, fn) {
        if this._matched
            return this

        if Type(this._val) = typeName {
            this._matched := true
            this._result := fn is Func ? fn(this._val) : fn
        }
        return this
    }

    WhenIn(vals, fn) {
        if this._matched
            return this

        for v in vals {
            if this._val = v {
                this._matched := true
                this._result := fn is Func ? fn(this._val) : fn
                break
            }
        }
        return this
    }

    Otherwise(fn) {
        if !this._matched
            this._result := fn is Func ? fn(this._val) : fn
        return this._result
    }
}

; Usage
grade := Match.On(85)
    .When((x) => x >= 90, "A")
    .When((x) => x >= 80, "B")
    .When((x) => x >= 70, "C")
    .When((x) => x >= 60, "D")
    .Otherwise("F")
; Result: "B"

response := Match.On(statusCode)
    .WhenIn([200, 201, 204], "Success")
    .WhenIn([400, 401, 403, 404], "Client Error")
    .WhenIn([500, 502, 503], "Server Error")
    .Otherwise("Unknown")
```

---

## Property Descriptor Patterns

### Complete Descriptor Reference

```ahk
; Value descriptor - simple property
obj.DefineProp("name", {Value: "default"})

; Getter only - computed/readonly
obj.DefineProp("computed", {
    Get: (this) => this.a + this.b
})

; Getter and Setter - controlled access
obj.DefineProp("validated", {
    Get: (this) => this._val,
    Set: (this, value) {
        if value < 0
            throw ValueError("Must be non-negative")
        this._val := value
    }
})

; Method descriptor
obj.DefineProp("method", {
    Call: (this, arg1, arg2) => this.process(arg1, arg2)
})
```

### Fluent Method Chaining

```ahk
class Chainable {
    static Wrap(TargetProto, MethodName) {
        Original := TargetProto.GetOwnPropDesc(MethodName)
        if !Original.HasOwnProp("Call")
            return

        OriginalCall := Original.Call

        TargetProto.DefineProp(MethodName, {
            Call: (this, args*) {
                OriginalCall(this, args*)
                return this  ; Always return this for chaining
            }
        })
    }

    static WrapAll(TargetProto, Methods*) {
        for MethodName in Methods
            Chainable.Wrap(TargetProto, MethodName)
    }
}

; Make array methods chainable
Chainable.WrapAll(Array.Prototype, "Push", "Pop", "InsertAt", "RemoveAt")
```

---

## Low-Level & Performance Patterns

### MCode Loading

```ahk
class MCode {
    static Cache := Map()

    static Load(code, argtypes := "") {
        if MCode.Cache.Has(code)
            return MCode.Cache[code]

        decoded := MCode._Decode(code)
        if !decoded.Size
            throw Error("Failed to decode MCode")

        ; Allocate executable memory
        mem := DllCall("VirtualAlloc", "Ptr", 0, "UPtr", decoded.Size,
                       "UInt", 0x3000, "UInt", 0x40, "Ptr")
        if !mem
            throw Error("Failed to allocate executable memory")

        ; Copy code to executable memory
        DllCall("RtlMoveMemory", "Ptr", mem, "Ptr", decoded, "UPtr", decoded.Size)

        MCode.Cache[code] := mem
        return mem
    }

    static _Decode(code) {
        code := RegExReplace(code, "\s+")
        if SubStr(code, 1, 2) = "0x"
            code := SubStr(code, 3)

        size := StrLen(code) // 2
        buf := Buffer(size)
        Loop size {
            byte := "0x" . SubStr(code, (A_Index - 1) * 2 + 1, 2)
            NumPut("UChar", Integer(byte), buf, A_Index - 1)
        }
        return buf
    }
}

; Usage - fast string hash
fastHash := MCode.Load("8B4424048B4C24088BD1C1EA0285D27406...")
hash := DllCall(fastHash, "Ptr", StrPtr("Hello"), "Int", 5, "Cdecl UInt")
```

### Memory Pool

```ahk
class MemoryPool {
    Blocks := []
    FreeList := []
    ItemSize := 0
    BlockSize := 0

    __New(itemSize, initialCount := 64) {
        this.ItemSize := itemSize
        this.BlockSize := itemSize * initialCount
        this._AllocBlock()
    }

    _AllocBlock() {
        block := DllCall("VirtualAlloc", "Ptr", 0, "UPtr", this.BlockSize,
                         "UInt", 0x3000, "UInt", 0x04, "Ptr")
        this.Blocks.Push(block)

        itemCount := this.BlockSize // this.ItemSize
        Loop itemCount {
            offset := (A_Index - 1) * this.ItemSize
            this.FreeList.Push(block + offset)
        }
    }

    Alloc() {
        if !this.FreeList.Length
            this._AllocBlock()
        return this.FreeList.Pop()
    }

    Free(ptr) {
        this.FreeList.Push(ptr)
    }

    Clear() {
        this.FreeList := []
        for block in this.Blocks
            DllCall("VirtualFree", "Ptr", block, "UPtr", 0, "UInt", 0x8000)
        this.Blocks := []
    }

    __Delete() {
        this.Clear()
    }
}
```

### Fast Path Iterations

```ahk
class FastPath {
    ; Optimized for JIT - uses while loops instead of for-each
    static ForEach(Arr, Fn) {
        Len := Arr.Length
        i := 0
        while ++i <= Len
            Fn(Arr[i], i)
    }

    static Map(Arr, Fn) {
        Len := Arr.Length
        Result := Array()
        Result.Length := Len
        i := 0
        while ++i <= Len
            Result[i] := Fn(Arr[i], i)
        return Result
    }

    static Reduce(Arr, Fn, Init := "") {
        Acc := Init
        Len := Arr.Length
        i := 0
        while ++i <= Len
            Acc := Fn(Acc, Arr[i], i)
        return Acc
    }

    static Filter(Arr, Fn) {
        Result := []
        Len := Arr.Length
        i := 0
        while ++i <= Len
            if Fn(Arr[i], i)
                Result.Push(Arr[i])
        return Result
    }
}
```

---

## Best Practices Summary

### Do's ✓

```ahk
; Use fat arrow for simple functions
Transform := (x) => x * 2

; Use nullish coalescing for defaults
value := input ?? "default"

; Use prototype extension for type augmentation
String.Prototype.DefineProp("IsEmpty", {Get: (this) => this = ""})

; Use descriptors for controlled properties
class Config {
    static Debug {
        get => A_IsCompiled ? false : true
    }
}

; Use meaningful names
ProcessUserInput()
ValidateEmailFormat()

; Chain methods fluently
result := data.Filter((x) => x > 0).Map((x) => x * 2).Sum
```

### Don'ts ✗

```ahk
; Don't use v1 syntax
; MsgBox, Hello  ; Wrong
MsgBox("Hello")  ; Correct

; Don't use legacy command syntax
; FileRead, content, file.txt  ; Wrong
content := FileRead("file.txt")  ; Correct

; Don't mix naming conventions in same file
; func_name() and FuncName() together

; Don't create converter artifacts
; V1toV2_Handler()  ; Wrong
ProcessHandler()   ; Correct

; Don't use magic numbers
; if status = 200  ; Unclear
static HTTP_OK := 200
if status = HTTP_OK  ; Clear
```

### Performance Tips

1. **Pre-allocate arrays** when size is known:
   ```ahk
   arr := Array()
   arr.Length := 1000
   ```

2. **Use while loops** for performance-critical code:
   ```ahk
   i := 0
   while ++i <= len
       ; faster than for-each
   ```

3. **Cache computed values** with lazy properties
4. **Use MCode** for computationally intensive operations
5. **Batch DOM/GUI operations** to minimize redraws

---

## Quick Reference Card

| Pattern | Syntax |
|---------|--------|
| Fat Arrow | `(x) => x * 2` |
| Nullish Coalesce | `value ?? default` |
| Prototype Extend | `Type.Prototype.DefineProp(name, desc)` |
| Getter | `{Get: (this) => ...}` |
| Setter | `{Set: (this, val) => ...}` |
| Method | `{Call: (this, args*) => ...}` |
| Optional Param | `fn(required, optional?) { optional := optional ?? default }` |
| Variadic | `fn(args*) { for a in args ... }` |
| Class Factory | `Class(BaseClass)` |
| Property Desc | `obj.GetOwnPropDesc(name)` |

---

## Version History

- **v2.1-alpha.17**: Latest stable alpha with Class() constructor
- **v2.1-alpha.3**: Introduced native Class() constructor
- **v2.0**: Initial v2 release

---

*This guide is maintained as training data for fine-tuning LLMs on modern AutoHotkey v2 patterns.*
