#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Array.RemoveAt() - Basic Usage Examples
 * ============================================================================
 * 
 * The RemoveAt() method removes element(s) at the specified index and returns
 * the removed value(s). Elements after the removed position shift down.
 * 
 * Syntax: value := array.RemoveAt(index [, length])
 * 
 * @description Comprehensive examples demonstrating basic RemoveAt() operations
 * @author AutoHotkey v2 Documentation
 * @version 1.0.0
 * @date 2025-01-16
 */

; Example 1: Single Element Removal
Example1_SingleRemoval() {
    OutputDebug("=== Example 1: Single Element Removal ===`n")

    fruits := ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
    OutputDebug("Initial: " FormatArray(fruits) "`n")

    removed := fruits.RemoveAt(3)
    OutputDebug("Removed at index 3: " removed "`n")
    OutputDebug("After removal: " FormatArray(fruits) "`n")

    removed := fruits.RemoveAt(1)
    OutputDebug("`nRemoved at index 1: " removed "`n")
    OutputDebug("After removal: " FormatArray(fruits) "`n`n")
}

; Example 2: Multiple Element Removal
Example2_MultipleRemoval() {
    OutputDebug("=== Example 2: Multiple Element Removal ===`n")

    numbers := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    OutputDebug("Initial: " FormatArray(numbers) "`n")

    numbers.RemoveAt(3, 3)  ; Remove 3 elements starting at index 3
    OutputDebug("After RemoveAt(3, 3): " FormatArray(numbers) "`n")

    numbers.RemoveAt(5, 2)  ; Remove 2 elements starting at index 5
    OutputDebug("After RemoveAt(5, 2): " FormatArray(numbers) "`n`n")
}

; Example 3: Remove from Different Positions
Example3_PositionRemoval() {
    OutputDebug("=== Example 3: Position-Based Removal ===`n")

    items := ["A", "B", "C", "D", "E", "F"]
    OutputDebug("Initial: " FormatArray(items) "`n")

    ; Remove from beginning
    items.RemoveAt(1)
    OutputDebug("Remove first: " FormatArray(items) "`n")

    ; Remove from end
    items.RemoveAt(items.Length)
    OutputDebug("Remove last: " FormatArray(items) "`n")

    ; Remove from middle
    items.RemoveAt(2)
    OutputDebug("Remove middle: " FormatArray(items) "`n`n")
}

; Example 4: Return Value Usage
Example4_ReturnValue() {
    OutputDebug("=== Example 4: Using Returned Values ===`n")

    stack := ["Task1", "Task2", "Task3", "Task4"]
    OutputDebug("Task stack: " FormatArray(stack) "`n`n")

    ; Remove and use value
    currentTask := stack.RemoveAt(1)
    OutputDebug("Processing: " currentTask "`n")
    OutputDebug("Remaining: " FormatArray(stack) "`n")

    ; Chain operations
    while (stack.Length > 0) {
        task := stack.RemoveAt(1)
        OutputDebug("Processing: " task " | Remaining: " stack.Length "`n")
    }
    OutputDebug("`n")
}

; Example 5: Conditional Removal
Example5_ConditionalRemoval() {
    OutputDebug("=== Example 5: Conditional Removal ===`n")

    numbers := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    OutputDebug("Initial: " FormatArray(numbers) "`n")

    ; Remove even numbers (iterate backwards to avoid index issues)
    index := numbers.Length
    while (index >= 1) {
        if (Mod(numbers[index], 2) = 0) {
            removed := numbers.RemoveAt(index)
            OutputDebug("Removed even number: " removed "`n")
        }
        index--
    }

    OutputDebug("After removing evens: " FormatArray(numbers) "`n`n")
}

; Example 6: Safe Removal with Validation
Example6_SafeRemoval() {
    OutputDebug("=== Example 6: Safe Removal ===`n")

    data := ["Item1", "Item2", "Item3"]
    OutputDebug("Initial: " FormatArray(data) "`n")

    ; Safe removal function
    indexToRemove := 2
    if (indexToRemove >= 1 && indexToRemove <= data.Length) {
        removed := data.RemoveAt(indexToRemove)
        OutputDebug("Removed: " removed "`n")
    } else {
        OutputDebug("Invalid index: " indexToRemove "`n")
    }

    ; Try invalid index
    indexToRemove := 10
    if (indexToRemove >= 1 && indexToRemove <= data.Length) {
        data.RemoveAt(indexToRemove)
    } else {
        OutputDebug("Cannot remove - index " indexToRemove " out of bounds`n")
    }

    OutputDebug("Final: " FormatArray(data) "`n`n")
}

; Example 7: Practical Use Cases
Example7_PracticalUseCases() {
    OutputDebug("=== Example 7: Practical Use Cases ===`n")

    ; Use Case 1: Remove completed tasks
    tasks := [{
        name: "Task 1", done: true }, {
            name: "Task 2", done: false }, {
                name: "Task 3", done: true }, {
                    name: "Task 4", done: false
                }
    ]

    OutputDebug("Removing completed tasks:`n")
    index := tasks.Length
    while (index >= 1) {
        if (tasks[index].done) {
            removed := tasks.RemoveAt(index)
            OutputDebug("  Removed: " removed.name "`n")
        }
        index--
    }

    OutputDebug("Remaining tasks: " tasks.Length "`n")

    ; Use Case 2: Remove duplicates
    values := [1, 2, 3, 2, 4, 3, 5, 1]
    OutputDebug("`nOriginal with duplicates: " FormatArray(values) "`n")

    seen := Map()
    index := values.Length
    while (index >= 1) {
        if (seen.Has(values[index])) {
            values.RemoveAt(index)
        } else {
            seen[values[index]] := true
        }
        index--
    }

    OutputDebug("After removing duplicates: " FormatArray(values) "`n")

    ; Use Case 3: Remove items by value
    inventory := ["Sword", "Shield", "Potion", "Bow", "Potion"]
    itemToRemove := "Potion"

    OutputDebug("`nInventory: " FormatArray(inventory) "`n")
    OutputDebug("Removing all '" itemToRemove "' items:`n")

    index := inventory.Length
    removed Count := 0
    while (index >= 1) {
        if (inventory[index] = itemToRemove) {
            inventory.RemoveAt(index)
            removedCount++
        }
        index--
    }

    OutputDebug("Removed " removedCount " items`n")
    OutputDebug("Final inventory: " FormatArray(inventory) "`n`n")
}

; Helper Functions
FormatArray(arr) {
    if (arr.Length = 0)
        return "[]"

    result := "["
    for index, value in arr {
        if (index > 1)
            result .= ", "

        valueType := Type(value)
        if (valueType = "String")
            result .= '"' value '"'
        else if (valueType = "Integer" || valueType = "Float")
            result .= value
        else if (valueType = "Object")
            result .= "{Object}"
        else
            result .= valueType
    }
    result .= "]"

    return result
}

Main() {
    OutputDebug("`n" String.Repeat("=", 80) "`n")
    OutputDebug("Array.RemoveAt() - Basic Usage Examples`n")
    OutputDebug(String.Repeat("=", 80) "`n`n")

    Example1_SingleRemoval()
    Example2_MultipleRemoval()
    Example3_PositionRemoval()
    Example4_ReturnValue()
    Example5_ConditionalRemoval()
    Example6_SafeRemoval()
    Example7_PracticalUseCases()

    OutputDebug(String.Repeat("=", 80) "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(String.Repeat("=", 80) "`n")

    MsgBox("Array.RemoveAt() examples completed!`nCheck DebugView for output.",
        "Examples Complete", "Icon!")
}

Main()
