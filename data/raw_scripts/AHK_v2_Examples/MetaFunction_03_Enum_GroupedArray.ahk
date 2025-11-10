#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * __Enum Meta-Function - Grouped Array Iterator
 *
 * Demonstrates custom __Enum implementation that groups array elements
 * into batches. Useful for batch processing.
 *
 * Source: AHK_Notes/Concepts/CustomEnumeratorsIterators.md
 */

; Example: Process array in groups of 3
numbers := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

MsgBox("Original array: [1,2,3,4,5,6,7,8,9,10]`n`n"
     . "Processing in groups of 3...", , "T3")

for groupNum, group in GroupedArray(numbers, 3) {
    groupStr := ""
    for item in group
        groupStr .= (groupStr ? ", " : "") item

    MsgBox("Group " groupNum ": [" groupStr "]", , "T2")
}

/**
 * GroupedArray Class
 *
 * Wraps an array and provides grouped iteration.
 */
class GroupedArray {
    __New(array, groupSize) {
        this.array := array
        this.groupSize := groupSize
    }

    /**
     * __Enum Implementation
     *
     * @param arity - Number of loop variables (1 or 2)
     * @return Enumerator function
     */
    __Enum(arity) {
        i := 0
        array := this.array
        groupSize := this.groupSize
        totalGroups := Ceil(array.Length / groupSize)

        ; Return enumerator function
        return (vars*) => {
            ; Check if we've processed all groups
            if (++i > totalGroups)
                return 0

            ; Create the current group
            group := []
            startIdx := (i - 1) * groupSize + 1
            endIdx := Min(startIdx + groupSize - 1, array.Length)

            ; Fill the group
            Loop (endIdx - startIdx + 1)
                group.Push(array[startIdx + A_Index - 1])

            ; Set output variables based on arity
            vars[1] := i        ; Group number
            if (arity >= 2)
                vars[2] := group  ; Group array

            return 1  ; Continue iteration
        }
    }
}

/*
 * Key Concepts:
 *
 * 1. Arity Parameter:
 *    - arity = 1: for group in GroupedArray()
 *    - arity = 2: for groupNum, group in GroupedArray()
 *    - Determines number of output variables
 *
 * 2. Enumerator Function Signature:
 *    (vars*) => {
 *        vars[1] := firstValue
 *        vars[2] := secondValue
 *        return 1 or 0
 *    }
 *
 * 3. State Management:
 *    - i: Current group index
 *    - Captured in closure
 *    - Persists across iterations
 *    - Each loop gets independent state
 *
 * 4. Batch Processing Pattern:
 *    - Original: [1,2,3,4,5,6,7,8,9,10]
 *    - Group size 3
 *    - Result: [[1,2,3], [4,5,6], [7,8,9], [10]]
 *
 * 5. Use Cases:
 *
 *    Database Batch Inserts:
 *    records := [...1000 records...]
 *    for batch in GroupedArray(records, 100)
 *        InsertBatch(batch)  ; Insert 100 at a time
 *
 *    Paginated Display:
 *    items := [...many items...]
 *    for pageNum, pageItems in GroupedArray(items, 20)
 *        ShowPage(pageNum, pageItems)
 *
 *    Chunk Processing:
 *    data := [...large dataset...]
 *    for chunkNum, chunk in GroupedArray(data, 50)
 *        ProcessChunk(chunk)
 *
 * 6. Implementation Details:
 *
 *    totalGroups = Ceil(length / groupSize)
 *    - Ensures last group included even if partial
 *
 *    startIdx = (i-1) * groupSize + 1
 *    - Calculate start of current group
 *
 *    endIdx = Min(start + size - 1, length)
 *    - Handle partial last group
 *
 * 7. Memory Efficiency:
 *    - Creates groups on-demand
 *    - No upfront memory allocation
 *    - Lazy evaluation pattern
 *
 * 8. Extension Ideas:
 *
 *    Sliding Window:
 *    class SlidingWindow {
 *        __Enum(arity) {
 *            // Each group overlaps with previous
 *            // [1,2,3], [2,3,4], [3,4,5], ...
 *        }
 *    }
 *
 *    Paired Elements:
 *    class Pairs {
 *        __Enum(arity) {
 *            // [1,2], [3,4], [5,6], ...
 *        }
 *    }
 *
 * 9. Comparison with Manual Approach:
 *
 *    Manual:
 *    i := 1
 *    while (i <= arr.Length) {
 *        group := []
 *        Loop Min(3, arr.Length - i + 1)
 *            group.Push(arr[i++])
 *        ProcessGroup(group)
 *    }
 *
 *    With __Enum:
 *    for group in GroupedArray(arr, 3)
 *        ProcessGroup(group)
 *
 * 10. Benefits:
 *     ✅ Cleaner syntax
 *     ✅ Reusable across codebase
 *     ✅ Self-documenting intent
 *     ✅ Encapsulated logic
 *     ✅ Easy to test
 */
