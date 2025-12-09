#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Chainable Iterator Implementation
*
* Demonstrates functional programming with chainable iterator operations.
* Enables lazy evaluation and fluent API for data processing.
*
* Source: AHK_Notes/Snippets/ChainableIterator.md
*/

; Extend Array prototype with iterator methods
for method in itb.Prototype.OwnProps()
Array.Prototype.DefineProp(method, {Call: itb.Prototype.%method%})

; Example 1: Array Chaining
MsgBox("Example 1: Array Chaining`n`n"
. "Original: [1,2,3,4,5,6,7,8,9,10]`n"
. "Operations: drop(2) → filter(even) → transform(*10) → take(3)", , "T5")

myArray := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

result := []
for value in myArray.drop(2).filter(x => Mod(x, 2) = 0).transform(x => x * 10).take(3)
result.Push(value)

MsgBox("Results: " result[1] ", " result[2] ", " result[3] "`n`n"
. "Expected: 40, 60, 80", , "T5")

; Example 2: Custom Iterable (Fibonacci)
MsgBox("Example 2: Fibonacci Sequence`n`n"
. "Using custom iterable with chainable operations.`n"
. "Taking first 10 numbers.", , "T5")

fibonacciSequence := {
    __Enum: (arity) {
        a := 0, b := 1
        return &v (next := a + b, a := b, b := next, v := a, 1)
    }
}

fibonacci := enm(fibonacciSequence, x => x)
fibResult := []
for value in fibonacci.take(10)
fibResult.Push(value)

MsgBox("First 10 Fibonacci: " fibResult.Length " numbers`n"
. "First 5: " fibResult[1] ", " fibResult[2] ", " fibResult[3] ", "
. fibResult[4] ", " fibResult[5], , "T5")

/**
* itb (Iterable Base) Class
*
* Provides chainable operations for iterables
*/
class itb {
    /**
    * Drop the first 'count' elements
    */
    drop(count) {
        return enm(this, (i := 0, f => (p*) => (++i <= count ? f(p*) : 0)))
    }

    /**
    * Filter elements by predicate function
    */
    filter(fn) {
        return enm(this, (f => (p*) => (fn(p*[1]) ? f(p*) : this.__Enum(1)(p*) ? 1 : 0)))
    }

    /**
    * Limit to first 'count' elements
    */
    take(count) {
        return enm(this, (i := 0, f => (p*) => (++i > count ? 0 : f(p*))))
    }

    /**
    * Transform (map) each element
    */
    transform(fn) {
        return enm(this, (f => (p*) => (r := f(p*), r ? (p*[1] := fn(p*[1])) : 0, r)))
    }
}

/**
* enm (Enumerator Wrapper) Class
*
* Wraps enumerables and applies transformations
*/
class enm extends itb {
    __New(ebl, enmw, atyx?) {
        this.ebl := ebl
        this.enmw := enmw
        this.atyx := atyx ?? (x => x)
    }

    __Enum(aty) {
        t := this
        t.aty := aty
        return t.enmw.call(t.ebl.__Enum(t.atyx.call(aty)))
    }
}

/*
* Key Concepts:
*
* 1. Lazy Evaluation:
*    - Operations don't execute immediately
*    - Elements processed one at a time
*    - No intermediate collections created
*    - More efficient for large datasets
*
* 2. Chainable Operations:
*
*    drop(n) - Skip first n elements
*    filter(fn) - Keep elements matching predicate
*    transform(fn) - Map/transform each element
*    take(n) - Limit to first n elements
*
* 3. Method Chaining:
*    array.drop(2)           // Returns enm wrapper
*         .filter(fn)        // Returns enm wrapper
*         .transform(fn)     // Returns enm wrapper
*         .take(3)           // Returns enm wrapper
*         // Loop triggers actual iteration
*
* 4. Benefits:
*    ✅ Readable, fluent syntax
*    ✅ Memory efficient (no intermediate arrays)
*    ✅ Composable operations
*    ✅ Works with any iterable
*    ✅ Short-circuits with take()
*
* 5. Performance:
*    - Better for large datasets
*    - Single pass through data
*    - Early termination with take()
*    - Small overhead for small datasets
*
* 6. Comparison:
*
*    Without Chaining (Eager):
*    temp1 := []
*    for v in arr
*        if (v > 2) temp1.Push(v)
*    temp2 := []
*    for v in temp1
*        if (Mod(v, 2) = 0) temp2.Push(v)
*    result := []
*    for v in temp2
*        result.Push(v * 10)
*
*    With Chaining (Lazy):
*    for v in arr.drop(2).filter(x => Mod(x, 2) = 0).transform(x => x * 10)
*        result.Push(v)
*
* 7. Use Cases:
*    - Data pipeline processing
*    - Filtering and transforming collections
*    - Functional-style programming
*    - Stream processing
*/
