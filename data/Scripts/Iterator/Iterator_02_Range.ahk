#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Range Iterator - Memory-Efficient Sequences
*
* Demonstrates creating a Range iterator that generates numeric sequences
* without storing values in memory, using closure-based iterators.
*
* Source: AHK_Notes/Snippets/Range.md
*/

; Test 1: Basic ascending range
MsgBox("Range(1, 5) - Ascending:", , "T1")
result := ""
for n in Range(1, 5)
result .= n " "
MsgBox("Values: " result, "Ascending Range", "T3")

; Test 2: Range with step
MsgBox("Range(0, 10, 2) - Even numbers:", , "T1")
result := ""
for n in Range(0, 10, 2)
result .= n " "
MsgBox("Values: " result, "Step Range", "T3")

; Test 3: Descending range
MsgBox("Range(10, 1, -1) - Descending:", , "T1")
result := ""
for n in Range(10, 1, -1)
result .= n " "
MsgBox("Values: " result, "Descending Range", "T3")

; Test 4: Range in array operations
MsgBox("Building array from Range(1, 5):", , "T1")
numbers := []
for n in Range(1, 5)
numbers.Push(n * n)  ; Square each number
MsgBox("Squared: [" Join(numbers) "]", "Array Building", "T3")

; Test 5: Large range (memory efficient)
MsgBox("Range(1, 1000000) - Sum first 100:", , "T1")
sum := 0
count := 0
for n in Range(1, 1000000) {
    sum += n
    if (++count >= 100)
    break
}
MsgBox("Sum of first 100: " sum, "Large Range", "T3")

/**
* Range - Generate numeric sequence iterator
* @param {int} start - Starting value
* @param {int} stop - Ending value (inclusive)
* @param {int} step - Step increment (default: 1)
* @return {func} Iterator function
*/
Range(start, stop, step := 1) {
    ; Return closure that maintains state
    return (&n) => (
    n := start,
    start += step,
    step > 0 ? n <= stop : n >= stop
    )
}

/**
* RangeWithCount - Range that also provides index
* @param {int} start - Starting value
* @param {int} stop - Ending value
* @param {int} step - Step increment
* @return {func} Iterator function with index
*/
RangeWithCount(start, stop, step := 1) {
    index := 0
    return (&n, &i) => (
    n := start,
    i := ++index,
    start += step,
    step > 0 ? n <= stop : n >= stop
    )
}

/**
* Join - Helper to join array
*/
Join(arr, delimiter := ", ") {
    result := ""
    for index, value in arr {
        result .= value (index < arr.Length ? delimiter : "")
    }
    return result
}

/*
* Key Concepts:
*
* 1. Iterator Pattern:
*    for n in Range(1, 10)
*    No array created
*    Values generated on demand
*
* 2. Range Implementation:
*    Range(start, stop, step) {
    *        return (&n) => (
    *            n := start,
    *            start += step,
    *            condition
    *        )
    *    }
    *
    * 3. Closure Mechanics:
    *    Captures start, stop, step
    *    Maintains state between calls
    *    Each call updates and returns next value
    *
    * 4. Output Variable:
    *    (&n) - Pass by reference
    *    Iterator assigns current value to n
    *    Returns boolean to continue/stop
    *
    * 5. Direction Handling:
    *    step > 0 ? n <= stop : n >= stop
    *    Ascending: <=
    *    Descending: >=
    *
    * 6. Memory Efficiency:
    *    Range(1, 1000000) - No memory used
    *    Array [1..1000000] - ~4MB+ memory
    *    Perfect for large sequences
    *
    * 7. Use Cases:
    *    ✅ Large numeric sequences
    *    ✅ Memory-constrained loops
    *    ✅ Lazy evaluation
    *    ✅ Infinite sequences (with break)
    *
    * 8. Comparison with Array:
    *    arr := [1,2,3,4,5]  ; Stores in memory
    *    for n in Range(1,5) ; No storage
    *
    * 9. Advanced Patterns:
    *    ; Skip every other
    *    for n in Range(1, 100, 2)
    *
    *    ; Countdown
    *    for n in Range(10, 1, -1)
    *
    *    ; Large range with early exit
    *    for n in Range(1, 999999)
    *        if (condition) break
    *
    * 10. Limitations:
    *     ⚠ Integer only (no floats)
    *     ⚠ Step = 0 causes infinite loop
    *     ⚠ No random access (arr[5])
    *     ⚠ Can't reuse (consumes iterator)
    *
    * 11. Benefits:
    *     ✅ O(1) memory regardless of size
    *     ✅ Lazy evaluation
    *     ✅ Functional programming style
    *     ✅ Clean syntax
    */
