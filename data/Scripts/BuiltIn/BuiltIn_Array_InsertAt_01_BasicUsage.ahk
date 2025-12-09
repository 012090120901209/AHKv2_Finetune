#Requires AutoHotkey v2.0

/**
* ============================================================================
* Array.InsertAt() - Basic Usage Examples
* ============================================================================
*
* The InsertAt() method inserts one or more values at the specified index.
* Existing elements at and after that position are shifted to higher indices.
*
* Syntax: array.InsertAt(index, value1, value2, ..., valueN)
*
* @description Comprehensive examples demonstrating basic InsertAt() operations
* @author AutoHotkey v2 Documentation
* @version 1.0.0
* @date 2025-01-16
*/

; ============================================================================
; Example 1: Single Element Insertion
; ============================================================================
; Insert individual elements at specific positions
Example1_SingleInsertion() {
    OutputDebug("=== Example 1: Single Element Insertion ===`n")

    fruits := ["Apple", "Cherry", "Date"]
    OutputDebug("Initial: " FormatArray(fruits) "`n")

    ; Insert at index 2 (between Apple and Cherry)
    fruits.InsertAt(2, "Banana")
    OutputDebug("After InsertAt(2, 'Banana'): " FormatArray(fruits) "`n")

    ; Insert at beginning (index 1)
    fruits.InsertAt(1, "Apricot")
    OutputDebug("After InsertAt(1, 'Apricot'): " FormatArray(fruits) "`n")

    ; Insert at end
    fruits.InsertAt(fruits.Length + 1, "Elderberry")
    OutputDebug("After InsertAt(end, 'Elderberry'): " FormatArray(fruits) "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 2: Multiple Element Insertion
; ============================================================================
; Insert multiple values in one call
Example2_MultipleInsertion() {
    OutputDebug("=== Example 2: Multiple Element Insertion ===`n")

    numbers := [1, 5, 6]
    OutputDebug("Initial: " FormatArray(numbers) "`n")

    ; Insert multiple elements at once
    numbers.InsertAt(2, 2, 3, 4)
    OutputDebug("After InsertAt(2, 2, 3, 4): " FormatArray(numbers) "`n")

    ; Insert at beginning
    colors := ["Yellow", "Green"]
    OutputDebug("`nInitial colors: " FormatArray(colors) "`n")

    colors.InsertAt(1, "Red", "Orange")
    OutputDebug("After InsertAt(1, 'Red', 'Orange'): " FormatArray(colors) "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 3: Position-Based Insertion
; ============================================================================
; Understanding index positions
Example3_PositionBasedInsertion() {
    OutputDebug("=== Example 3: Position-Based Insertion ===`n")

    items := ["A", "D"]
    OutputDebug("Start: " FormatArray(items) "`n")

    ; Insert B at position 2
    items.InsertAt(2, "B")
    OutputDebug("After inserting B at 2: " FormatArray(items) "`n")

    ; Insert C at position 3
    items.InsertAt(3, "C")
    OutputDebug("After inserting C at 3: " FormatArray(items) "`n")

    ; Insert at various positions
    sequence := [10, 40, 50]
    OutputDebug("`nInitial sequence: " FormatArray(sequence) "`n")

    sequence.InsertAt(2, 20)
    OutputDebug("Inserted 20 at position 2: " FormatArray(sequence) "`n")

    sequence.InsertAt(3, 30)
    OutputDebug("Inserted 30 at position 3: " FormatArray(sequence) "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 4: Different Data Types
; ============================================================================
; Insert various data types
Example4_DifferentDataTypes() {
    OutputDebug("=== Example 4: Different Data Types ===`n")

    mixed := ["First"]
    OutputDebug("Initial: " FormatArray(mixed) "`n")

    ; Insert number
    mixed.InsertAt(2, 42)
    OutputDebug("After inserting number: Length = " mixed.Length "`n")

    ; Insert boolean
    mixed.InsertAt(3, true)
    OutputDebug("After inserting boolean: Length = " mixed.Length "`n")

    ; Insert object
    mixed.InsertAt(4, {key: "value", num: 100})
    OutputDebug("After inserting object: Length = " mixed.Length "`n")

    ; Insert array
    mixed.InsertAt(5, [1, 2, 3])
    OutputDebug("After inserting array: Length = " mixed.Length "`n")

    OutputDebug("Final length: " mixed.Length "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 5: Building Ordered Lists
; ============================================================================
; Maintain order while inserting
Example5_OrderedInsertion() {
    OutputDebug("=== Example 5: Building Ordered Lists ===`n")

    ; Create sorted array and maintain order
    sorted := [10, 30, 50]
    OutputDebug("Sorted array: " FormatArray(sorted) "`n")

    ; Insert 20 to maintain order
    InsertSorted(sorted, 20)
    OutputDebug("After inserting 20: " FormatArray(sorted) "`n")

    ; Insert 40
    InsertSorted(sorted, 40)
    OutputDebug("After inserting 40: " FormatArray(sorted) "`n")

    ; Insert 5
    InsertSorted(sorted, 5)
    OutputDebug("After inserting 5: " FormatArray(sorted) "`n")

    ; Insert 60
    InsertSorted(sorted, 60)
    OutputDebug("After inserting 60: " FormatArray(sorted) "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 6: Insert with Validation
; ============================================================================
; Validate before insertion
Example6_ValidatedInsertion() {
    OutputDebug("=== Example 6: Validated Insertion ===`n")

    positiveNumbers := [5, 10, 15]
    OutputDebug("Initial positive numbers: " FormatArray(positiveNumbers) "`n")

    ; Try to insert valid number
    valueToInsert := 12
    if (valueToInsert > 0) {
        position := FindInsertPosition(positiveNumbers, valueToInsert)
        positiveNumbers.InsertAt(position, valueToInsert)
        OutputDebug("Inserted " valueToInsert " at position " position "`n")
        OutputDebug("Result: " FormatArray(positiveNumbers) "`n")
    }

    ; Try to insert negative (validation fail)
    invalidValue := -5
    if (invalidValue > 0) {
        positiveNumbers.InsertAt(1, invalidValue)
    } else {
        OutputDebug("`nCannot insert " invalidValue " (must be positive)`n")
    }


    OutputDebug("`n")
}

; ============================================================================
; Example 7: Practical Use Cases
; ============================================================================
; Real-world insertion scenarios
Example7_PracticalUseCases() {
    OutputDebug("=== Example 7: Practical Use Cases ===`n")

    ; Use Case 1: Insert priority item in task list
    tasks := [
    {
        name: "Task 1", priority: 3},
        {
            name: "Task 3", priority: 1
        }
        ]

        OutputDebug("Initial tasks: " tasks.Length "`n")
        for task in tasks {
            OutputDebug("  - " task.name " (Priority: " task.priority ")`n")
        }

        ; Insert medium priority task
        newTask := {name: "Task 2", priority: 2}
        position := FindTaskPosition(tasks, newTask.priority)
        tasks.InsertAt(position, newTask)

        OutputDebug("`nAfter inserting Task 2:`n")
        for task in tasks {
            OutputDebug("  - " task.name " (Priority: " task.priority ")`n")
        }

        ; Use Case 2: Insert timestamp in log
        logEntries := [
        {
            time: 1000, message: "Start"},
            {
                time: 3000, message: "End"
            }
            ]

            OutputDebug("`nLog entries: " logEntries.Length "`n")

            newEntry := {time: 2000, message: "Middle"}
            logPosition := FindLogPosition(logEntries, newEntry.time)
            logEntries.InsertAt(logPosition, newEntry)

            OutputDebug("After inserting middle entry:`n")
            for entry in logEntries {
                OutputDebug("  - " entry.message " (" entry.time ")`n")
            }
            OutputDebug("`n")
        }

        /**
        * Find position for task based on priority (higher priority = lower number = earlier position)
        * @param {Array} tasks - Task array
        * @param {Integer} priority - Priority level
        * @returns {Integer} Insert position
        */
        FindTaskPosition(tasks, priority) {
            position := 1

            for task in tasks {
                if (priority > task.priority) {  ; Higher priority number = lower priority
                break
            }
            position++
        }

        return position
    }

    /**
    * Find position for log entry based on timestamp
    * @param {Array} log - Log entries
    * @param {Integer} timestamp - Entry timestamp
    * @returns {Integer} Insert position
    */
    FindLogPosition(log, timestamp) {
        position := 1

        for entry in log {
            if (timestamp < entry.time) {
                break
            }
            position++
        }

        return position
    }

    /**
    * Formats an array for display
    */
    FormatArray(arr) {
        if (arr.Length = 0) {
            return "[]"
        }

        result := "["
        for index, value in arr {
            if (index > 1) {
                result .= ", "
            }

            valueType := Type(value)
            if (valueType = "String") {
                result .= '"' value '"'
            } else if (valueType = "Integer" || valueType = "Float") {
                result .= value
            } else if (valueType = "Array") {
                result .= "[Array]"
            } else if (valueType = "Object") {
                result .= "{Object}"
            } else {
                result .= valueType
            }
        }
        result .= "]"

        return result
    }

    ; ============================================================================
    ; Main Execution
    ; ============================================================================

    Main() {
        ; Clear debug output
        OutputDebug("`n" String.Repeat("=", 80) "`n")
        OutputDebug("Array.InsertAt() - Basic Usage Examples`n")
        OutputDebug(String.Repeat("=", 80) "`n`n")

        ; Run all examples
        Example1_SingleInsertion()
        Example2_MultipleInsertion()
        Example3_PositionBasedInsertion()
        Example4_DifferentDataTypes()
        Example5_OrderedInsertion()
        Example6_ValidatedInsertion()
        Example7_PracticalUseCases()

        OutputDebug(String.Repeat("=", 80) "`n")
        OutputDebug("All examples completed!`n")
        OutputDebug(String.Repeat("=", 80) "`n")

        ; MsgBox("Array.InsertAt() examples completed!`nCheck DebugView for output.",
        ;        "Examples Complete", "Icon!")
        ExitApp
    }

    ; Run the examples
    Main()
