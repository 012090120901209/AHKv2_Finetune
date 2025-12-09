#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Lazy Evaluation - Deferred computation and infinite sequences
; Demonstrates lazy patterns for efficient memory and computation in AHK v2

; =============================================================================
; 1. Basic Lazy Value (Thunk)
; =============================================================================

class Lazy {
    __New(thunk) {
        this._thunk := thunk
        this._evaluated := false
        this._value := ""
    }
    
    ; Force evaluation
    Value {
        get {
            if !this._evaluated {
                this._value := this._thunk()
                this._evaluated := true
            }
            return this._value
        }
    }
    
    ; Check without forcing
    IsEvaluated => this._evaluated
    
    ; Map without forcing
    Map(fn) => Lazy(() => fn(this.Value))
    
    ; FlatMap for chaining
    FlatMap(fn) => Lazy(() => fn(this.Value).Value)
}

; Helper constructor
LazyVal(thunk) => Lazy(thunk)

; =============================================================================
; 2. Lazy Sequence (Infinite)
; =============================================================================

class LazySeq {
    __New(head, tailThunk) {
        this._head := head
        this._tailThunk := tailThunk
        this._tailEvaluated := false
        this._tail := ""
    }
    
    ; Static constructors
    static Empty() => {isEmpty: true}
    
    static Cons(head, tail) => LazySeq(head, () => tail)
    
    static From(fn, state := 0) {
        ; Infinite sequence from generator
        return LazySeq(fn(state), () => LazySeq.From(fn, state + 1))
    }
    
    static Range(start, end := unset, step := 1) {
        if !IsSet(end)
            return LazySeq.From((i) => start + i * step)  ; Infinite
        
        if start > end && step > 0
            return LazySeq.Empty()
        if start < end && step < 0
            return LazySeq.Empty()
        if start = end
            return LazySeq(start, () => LazySeq.Empty())
        
        return LazySeq(start, () => LazySeq.Range(start + step, end, step))
    }
    
    static Repeat(value) => LazySeq(value, () => LazySeq.Repeat(value))
    
    static Cycle(arr) {
        iterate(idx) {
            return LazySeq(arr[idx], () => iterate(Mod(idx, arr.Length) + 1))
        }
        return iterate(1)
    }
    
    ; Properties
    IsEmpty => this.HasOwnProp("isEmpty") && this.isEmpty
    
    Head => this._head
    
    Tail {
        get {
            if !this._tailEvaluated {
                this._tail := this._tailThunk()
                this._tailEvaluated := true
            }
            return this._tail
        }
    }
    
    ; Take n elements
    Take(n) {
        if n <= 0 || this.IsEmpty
            return []
        
        result := [this.Head]
        current := this.Tail
        
        loop n - 1 {
            if current.IsEmpty
                break
            result.Push(current.Head)
            current := current.Tail
        }
        
        return result
    }
    
    ; Drop n elements
    Drop(n) {
        current := this
        loop n {
            if current.IsEmpty
                return current
            current := current.Tail
        }
        return current
    }
    
    ; Map (lazy)
    Map(fn) {
        if this.IsEmpty
            return LazySeq.Empty()
        return LazySeq(fn(this.Head), () => this.Tail.Map(fn))
    }
    
    ; Filter (lazy)
    Filter(pred) {
        if this.IsEmpty
            return LazySeq.Empty()
        
        if pred(this.Head)
            return LazySeq(this.Head, () => this.Tail.Filter(pred))
        
        return this.Tail.Filter(pred)
    }
    
    ; TakeWhile (lazy)
    TakeWhile(pred) {
        if this.IsEmpty || !pred(this.Head)
            return LazySeq.Empty()
        return LazySeq(this.Head, () => this.Tail.TakeWhile(pred))
    }
    
    ; DropWhile (lazy but forces until condition fails)
    DropWhile(pred) {
        current := this
        while !current.IsEmpty && pred(current.Head)
            current := current.Tail
        return current
    }
    
    ; Zip with another lazy sequence
    Zip(other) {
        if this.IsEmpty || other.IsEmpty
            return LazySeq.Empty()
        return LazySeq([this.Head, other.Head], () => this.Tail.Zip(other.Tail))
    }
    
    ; Fold (forces entire sequence up to n elements)
    Fold(initial, fn, maxElements := 1000) {
        acc := initial
        current := this
        count := 0
        
        while !current.IsEmpty && count < maxElements {
            acc := fn(acc, current.Head)
            current := current.Tail
            count++
        }
        
        return acc
    }
}

; =============================================================================
; 3. Memoized Recursion
; =============================================================================

class MemoizedRec {
    __New(fn) {
        this.cache := Map()
        this.fn := fn
    }
    
    Call(n) {
        if !this.cache.Has(n)
            this.cache[n] := this.fn(this, n)
        return this.cache[n]
    }
}

; Memoized fibonacci
MemoFib := MemoizedRec((self, n) => n <= 1 ? n : self.Call(n-1) + self.Call(n-2))

; =============================================================================
; 4. Lazy Property Pattern
; =============================================================================

class LazyProperties {
    __New() {
        this._cache := Map()
        this._initializers := Map()
    }
    
    ; Define lazy property
    DefineLazy(name, initializer) {
        this._initializers[name] := initializer
        this.DefineProp(name, {
            Get: (self) => self._getLazy(name)
        })
    }
    
    _getLazy(name) {
        if !this._cache.Has(name) {
            if this._initializers.Has(name)
                this._cache[name] := this._initializers[name]()
        }
        return this._cache.Get(name, "")
    }
    
    ; Invalidate cached value
    Invalidate(name) {
        if this._cache.Has(name)
            this._cache.Delete(name)
    }
}

; =============================================================================
; 5. Lazy Data Structures
; =============================================================================

; Lazy tree (potentially infinite)
class LazyTree {
    __New(value, childrenThunk := "") {
        this._value := value
        this._childrenThunk := childrenThunk || (() => [])
        this._childrenEvaluated := false
        this._children := []
    }
    
    Value => this._value
    
    Children {
        get {
            if !this._childrenEvaluated {
                this._children := this._childrenThunk()
                this._childrenEvaluated := true
            }
            return this._children
        }
    }
    
    ; Breadth-first traversal with depth limit
    BFS(maxDepth := 10) {
        result := []
        queue := [{node: this, depth: 0}]
        
        while queue.Length > 0 {
            item := queue.RemoveAt(1)
            result.Push(item.node.Value)
            
            if item.depth < maxDepth {
                for child in item.node.Children
                    queue.Push({node: child, depth: item.depth + 1})
            }
        }
        
        return result
    }
}

; =============================================================================
; 6. Generator-like Pattern
; =============================================================================

class Generator {
    __New(genFn) {
        this._genFn := genFn
        this._yielded := []
        this._done := false
        this._state := Map()
    }
    
    ; Yield value (called from generator function)
    Yield(value) {
        this._yielded.Push(value)
    }
    
    ; Get next value
    Next() {
        if this._yielded.Length > 0
            return {value: this._yielded.RemoveAt(1), done: false}
        
        if this._done
            return {done: true}
        
        try {
            this._genFn(this, this._state)
        } catch Error {
            this._done := true
        }
        
        if this._yielded.Length > 0
            return {value: this._yielded.RemoveAt(1), done: false}
        
        this._done := true
        return {done: true}
    }
    
    ; Collect all (up to limit)
    ToArray(limit := 1000) {
        result := []
        loop limit {
            n := this.Next()
            if n.done
                break
            result.Push(n.value)
        }
        return result
    }
}

; =============================================================================
; 7. Lazy String Operations
; =============================================================================

class LazyString {
    __New(parts) {
        this._parts := parts  ; Array of strings or thunks
        this._evaluated := ""
        this._isEvaluated := false
    }
    
    ; Lazy concatenation
    Concat(other) {
        newParts := []
        for p in this._parts
            newParts.Push(p)
        
        if other is LazyString {
            for p in other._parts
                newParts.Push(p)
        } else {
            newParts.Push(other)
        }
        
        return LazyString(newParts)
    }
    
    ; Force evaluation
    ToString() {
        if !this._isEvaluated {
            result := ""
            for part in this._parts {
                if part is Func
                    result .= part()
                else
                    result .= part
            }
            this._evaluated := result
            this._isEvaluated := true
        }
        return this._evaluated
    }
    
    ; Map each part lazily
    Map(fn) {
        newParts := []
        for part in this._parts {
            if part is Func
                newParts.Push(() => fn(part()))
            else
                newParts.Push(() => fn(part))
        }
        return LazyString(newParts)
    }
    
    Length {
        get => StrLen(this.ToString())
    }
}

; =============================================================================
; 8. Demand-Driven Computation
; =============================================================================

class DemandCache {
    __New() {
        this._computations := Map()
        this._values := Map()
        this._dependencies := Map()
    }
    
    ; Register computation with dependencies
    Register(name, deps, compute) {
        this._computations[name] := compute
        this._dependencies[name] := deps
    }
    
    ; Get value (computes on demand)
    Get(name) {
        if this._values.Has(name)
            return this._values[name]
        
        if !this._computations.Has(name)
            throw Error("Unknown computation: " name)
        
        ; Compute dependencies first
        deps := this._dependencies[name]
        depValues := []
        for dep in deps
            depValues.Push(this.Get(dep))
        
        ; Compute and cache
        value := this._computations[name](depValues*)
        this._values[name] := value
        return value
    }
    
    ; Invalidate (cascade to dependents)
    Invalidate(name) {
        this._values.Delete(name)
        
        ; Invalidate anything that depends on this
        for n, deps in this._dependencies {
            for dep in deps {
                if dep = name
                    this.Invalidate(n)
            }
        }
    }
}

; =============================================================================
; Demo
; =============================================================================

; Basic lazy value
expensiveCalc := LazyVal(() => (Sleep(100), "computed!"))
MsgBox("Lazy Value:`n`nEvaluated before access: " expensiveCalc.IsEvaluated "`nValue: " expensiveCalc.Value "`nEvaluated after: " expensiveCalc.IsEvaluated)

; Infinite sequence
naturals := LazySeq.Range(1)  ; 1, 2, 3, ...
first10 := naturals.Take(10)
MsgBox("Infinite Natural Numbers:`n`nFirst 10: " _ArrayJoin(first10, ", "))

; Fibonacci sequence (lazy)
GenFib(a := 0, b := 1) => LazySeq(a, () => GenFib(b, a + b))
fibs := GenFib()
first15Fib := fibs.Take(15)
MsgBox("Lazy Fibonacci:`n`nFirst 15: " _ArrayJoin(first15Fib, ", "))

; Prime sieve (lazy)
Sieve(seq) {
    if seq.IsEmpty
        return seq
    p := seq.Head
    return LazySeq(p, () => Sieve(seq.Tail.Filter((n) => Mod(n, p) != 0)))
}
primes := Sieve(LazySeq.Range(2))
first20Primes := primes.Take(20)
MsgBox("Lazy Sieve of Eratosthenes:`n`nFirst 20 primes: " _ArrayJoin(first20Primes, ", "))

; Map and filter on infinite sequence
squares := naturals.Map((n) => n * n)
evenSquares := squares.Filter((n) => Mod(n, 2) = 0)
first10EvenSquares := evenSquares.Take(10)
MsgBox("Lazy Map/Filter:`n`nFirst 10 even squares: " _ArrayJoin(first10EvenSquares, ", "))

; Zip two sequences
letters := LazySeq.Cycle(["a", "b", "c"])
zipped := naturals.Zip(letters).Take(10)
zippedStr := ""
for pair in zipped
    zippedStr .= "(" pair[1] "," pair[2] ") "
MsgBox("Lazy Zip:`n`n" zippedStr)

; Memoized fibonacci
MsgBox("Memoized Fib(40): " MemoFib.Call(40))

; Lazy properties
class ExpensiveObject extends LazyProperties {
    __New() {
        super.__New()
        this.DefineLazy("config", () => (Sleep(50), {loaded: true}))
        this.DefineLazy("data", () => (Sleep(50), [1, 2, 3, 4, 5]))
    }
}

obj := ExpensiveObject()
MsgBox("Lazy Properties:`n`nAccessing config: " obj.config.loaded "`nAccessing data length: " obj.data.Length)

; Demand-driven computation
dc := DemandCache()
dc.Register("a", [], () => 10)
dc.Register("b", [], () => 20)
dc.Register("sum", ["a", "b"], (a, b) => a + b)
dc.Register("doubled", ["sum"], (s) => s * 2)
MsgBox("Demand Cache:`n`ndoubled = " dc.Get("doubled"))

; Generator pattern
Counter(gen, state) {
    if !state.Has("n")
        state["n"] := 0
    state["n"]++
    gen.Yield(state["n"])
}

counterGen := Generator(Counter)
MsgBox("Generator:`n`nFirst 5: " _ArrayJoin(counterGen.ToArray(5), ", "))

; Lazy string
ls := LazyString(["Hello", () => " from ", "Lazy", () => "String"])
MsgBox("Lazy String: " ls.ToString())

_ArrayJoin(arr, sep) {
    result := ""
    for i, v in arr
        result .= (i > 1 ? sep : "") . String(v)
    return result
}
