#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * __Enum Meta-Function - Range Iterator
 * 
 * Demonstrates custom enumeration with the __Enum meta-function.
 * Creates a Range function similar to Python's range().
 * 
 * Source: AHK_Notes/Concepts/CustomEnumeratorsIterators.md
 */

; Example 1: Simple Range (1 to 10)
MsgBox("Example 1: Range(1, 10)", , "T2")
result1 := []
for n in Range(1, 10)
    result1.Push(n)

MsgBox("Results: " result1.Length " numbers`n"
    . "First 5: " result1[1] ", " result1[2] ", " result1[3] ", "
    . result1[4] ", " result1[5], , "T5")

; Example 2: Reverse Range (10 to 1)
MsgBox("Example 2: Range(10, 1, -1)", , "T2")
result2 := []
for n in Range(10, 1, -1)
    result2.Push(n)

MsgBox("Reverse Results: " result2.Length " numbers`n"
    . "First 5: " result2[1] ", " result2[2] ", " result2[3] ", "
    . result2[4] ", " result2[5], , "T5")

; Example 3: Range with Custom Step
MsgBox("Example 3: Range(0, 20, 3)", , "T2")
result3 := []
for n in Range(0, 20, 3)
    result3.Push(n)

MsgBox("Step 3 Results: " result3.Length " numbers`n"
    . "Values: " result3[1] ", " result3[2] ", " result3[3] ", "
    . result3[4] ", " result3[5] ", " result3[6] ", " result3[7], , "T5")

/**
 * Range Function
 * 
 * Returns an enumerator that yields numbers in a range.
 * 
 * @param Start - Starting value
 * @param Stop - Ending value (inclusive)
 * @param Step - Increment (default 1, can be negative)
 * @return Enumerator function
 */
Range(Start, Stop, Step := 1) {
    ; Return a closure that implements the enumerator
    return (&n) => (
        n := Start,
        Start += Step,
        Step > 0 ? n <= Stop : n >= Stop
    )
}

/*
* Key Concepts:
*
* 1. __Enum Meta-Function:
*    - Called automatically by 'for' loops
*    - Returns an enumerator function
*    - Enumerator controls iteration
*
* 2. Enumerator Function:
*    - Takes output variables by reference (&n)
*    - Returns 1 to continue, 0 to stop
*    - Sets output variable(s) each iteration
*
* 3. Range Implementation:
*    Start = current value
*    Step = increment/decrement
*    Stop = end condition
*    Returns closure with captured state
*
* 4. Closure State:
*    - Start, Stop, Step captured in closure
*    - State persists across iterations
*    - Each Range() call creates new state
*
* 5. Iteration Flow:
*
*    for n in Range(1, 5):
*
*    1. for calls Range(1, 5).__Enum(1)
*    2. Range returns enumerator function
*    3. for calls enumerator(&n)
*    4. Enumerator sets n = 1, returns 1
*    5. Loop body executes with n = 1
*    6. for calls enumerator(&n) again
*    7. Enumerator sets n = 2, returns 1
*    8. Continues until n > 5
*    9. Enumerator returns 0, loop ends
*
* 6. Comparison with Other Languages:
*
*    Python:
*    for i in range(1, 10):
*
*    JavaScript:
*    for (let i of Array.from({length: 10}, (_, i) => i + 1))
*
*    AHK v2:
*    for i in Range(1, 10)
*
* 7. Use Cases:
*    - Numeric loops without arrays
*    - Memory-efficient iteration
*    - Custom step sizes
*    - Reverse iteration
*    - Infinite sequences (with care)
*
* 8. Benefits:
*    ✅ No array allocation
*    ✅ Memory efficient
*    ✅ Clean syntax
*    ✅ Flexible (any start/stop/step)
*    ✅ Lazy evaluation
*
* 9. Advanced Example - Infinite Range:
*
*    InfiniteRange(Start, Step := 1) {
    *        return (&n) => (n := Start, Start += Step, 1)
    *    }
    *
    *    ; Use with break to avoid infinite loop
    *    for n in InfiniteRange(1) {
        *        if (n > 10)
        *            break
        *        MsgBox(n)
        *    }
*/

