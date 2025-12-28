#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Array.Push() - Basic Usage Examples
 * ============================================================================
 * 
 * The Push() method adds one or more elements to the end of an array and
 * returns the new length of the array.
 * 
 * Syntax: array.Push(value1, value2, ..., valueN)
 * 
 * @description Comprehensive examples demonstrating basic Push() operations
 * @author AutoHotkey v2 Documentation
 * @version 1.0.0
 * @date 2025-01-16
 */

; ============================================================================
; Example 1: Single Element Push
; ============================================================================
; Demonstrates adding individual elements to an array
Example1_SingleElementPush() {
    OutputDebug("=== Example 1: Single Element Push ===`n")

    ; Create an empty array
    fruits := []
    OutputDebug("Initial array: " FormatArray(fruits) "`n")

    ; Push individual elements
    newLength := fruits.Push("Apple")
    OutputDebug("After Push('Apple'): " FormatArray(fruits) " | Length: " newLength "`n")

    newLength := fruits.Push("Banana")
    OutputDebug("After Push('Banana'): " FormatArray(fruits) " | Length: " newLength "`n")

    newLength := fruits.Push("Cherry")
    OutputDebug("After Push('Cherry'): " FormatArray(fruits) " | Length: " newLength "`n")

    ; Accessing pushed elements
    OutputDebug("First fruit: " fruits[1] "`n")
    OutputDebug("Last fruit: " fruits[fruits.Length] "`n")
    OutputDebug("`n")
}

; ============================================================================
; Example 2: Multiple Element Push
; ============================================================================
; Push accepts multiple values in a single call
Example2_MultipleElementPush() {
    OutputDebug("=== Example 2: Multiple Element Push ===`n")

    ; Start with some initial data
    numbers := [1, 2, 3]
    OutputDebug("Initial array: " FormatArray(numbers) "`n")

    ; Push multiple elements at once
    newLength := numbers.Push(4, 5, 6, 7, 8)
    OutputDebug("After Push(4, 5, 6, 7, 8): " FormatArray(numbers) " | Length: " newLength "`n")

    ; Can mix types
    mixed := ["text"]
    mixed.Push(42, true, { key: "value" }, [1, 2, 3])
    OutputDebug("Mixed types: " FormatArray(mixed) "`n")
    OutputDebug("`n")
}

; ============================================================================
; Example 3: Push with Different Data Types
; ============================================================================
; Demonstrates pushing various data types including objects and nested arrays
Example3_DifferentDataTypes() {
    OutputDebug("=== Example 3: Different Data Types ===`n")

    collection := []

    ; Push strings
    collection.Push("Hello World")
    OutputDebug("After string: " FormatArray(collection) "`n")

    ; Push numbers
    collection.Push(42, 3.14, -10)
    OutputDebug("After numbers: " FormatArray(collection) "`n")

    ; Push booleans
    collection.Push(true, false)
    OutputDebug("After booleans: " FormatArray(collection) "`n")

    ; Push objects
    person := { name: "John", age: 30 }
    collection.Push(person)
    OutputDebug("After object: Length = " collection.Length "`n")

    ; Push nested arrays
    nestedArray := [1, 2, [3, 4, [5, 6]]]
    collection.Push(nestedArray)
    OutputDebug("After nested array: Length = " collection.Length "`n")

    ; Push function references
    collection.Push(Example1_SingleElementPush)
    OutputDebug("Final length: " collection.Length "`n")
    OutputDebug("`n")
}

; ============================================================================
; Example 4: Building Arrays Dynamically in Loops
; ============================================================================
; Common pattern: accumulating values in loops
Example4_DynamicLoopBuilding() {
    OutputDebug("=== Example 4: Dynamic Loop Building ===`n")

    ; Build array of even numbers
    evenNumbers := []
    Loop 10 {
        if (Mod(A_Index, 2) = 0) {
            evenNumbers.Push(A_Index)
        }
    }
    OutputDebug("Even numbers: " FormatArray(evenNumbers) "`n")

    ; Build array of squares
    squares := []
    Loop 5 {
        squares.Push(A_Index * A_Index)
    }
    OutputDebug("Squares: " FormatArray(squares) "`n")

    ; Build array with loop values
    loopData := []
    Loop 3 {
        loopData.Push("Iteration " A_Index)
    }
    OutputDebug("Loop data: " FormatArray(loopData) "`n")

    ; Fibonacci sequence using Push
    fibonacci := [0, 1]
    Loop 8 {
        nextValue := fibonacci[fibonacci.Length - 1] + fibonacci[fibonacci.Length]
        fibonacci.Push(nextValue)
    }
    OutputDebug("Fibonacci: " FormatArray(fibonacci) "`n")
    OutputDebug("`n")
}

; ============================================================================
; Example 5: Return Value Usage
; ============================================================================
; The Push() method returns the new length of the array
Example5_ReturnValueUsage() {
    OutputDebug("=== Example 5: Return Value Usage ===`n")

    tasks := ["Task 1", "Task 2"]
    OutputDebug("Initial tasks: " FormatArray(tasks) "`n")

    ; Capture and use the return value
    currentLength := tasks.Push("Task 3")
    OutputDebug("Current length after push: " currentLength "`n")

    ; Use return value in conditional
    if (tasks.Push("Task 4") > 3) {
        OutputDebug("Array now has more than 3 elements!`n")
    }

    ; Chain operations using return value
    while (tasks.Length < 10) {
        newSize := tasks.Push("Task " (tasks.Length + 1))
        OutputDebug("Added task, new size: " newSize "`n")
    }

    OutputDebug("Final tasks count: " tasks.Length "`n")
    OutputDebug("`n")
}

; ============================================================================
; Example 6: Conditional Push Operations
; ============================================================================
; Push elements based on conditions
Example6_ConditionalPush() {
    OutputDebug("=== Example 6: Conditional Push ===`n")

    ; Filter and push pattern
    sourceData := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    validNumbers := []

    for num in sourceData {
        if (num > 5) {
            validNumbers.Push(num)
        }
    }
    OutputDebug("Numbers > 5: " FormatArray(validNumbers) "`n")

    ; Type-based filtering
    mixedData := [1, "text", true, 3.14, "hello", 42, false]
    numbersOnly := []
    stringsOnly := []

    for item in mixedData {
        if (Type(item) = "Integer" || Type(item) = "Float") {
            numbersOnly.Push(item)
        } else if (Type(item) = "String") {
            stringsOnly.Push(item)
        }
    }

    OutputDebug("Numbers only: " FormatArray(numbersOnly) "`n")
    OutputDebug("Strings only: " FormatArray(stringsOnly) "`n")

    ; Unique values only
    allValues := [1, 2, 3, 2, 4, 3, 5, 1]
    uniqueValues := []

    for value in allValues {
        isUnique := true
        for existing in uniqueValues {
            if (existing = value) {
                isUnique := false
                break
            }
        }
        if (isUnique) {
            uniqueValues.Push(value)
        }
    }

    OutputDebug("Unique values: " FormatArray(uniqueValues) "`n")
    OutputDebug("`n")
}

; ============================================================================
; Example 7: Practical Use Cases
; ============================================================================
; Real-world scenarios using Push()
Example7_PracticalUseCases() {
    OutputDebug("=== Example 7: Practical Use Cases ===`n")

    ; Use Case 1: Log collector
    logMessages := []
    logMessages.Push("[INFO] Application started")
    logMessages.Push("[DEBUG] Loading configuration")
    logMessages.Push("[INFO] Configuration loaded successfully")
    logMessages.Push("[ERROR] Failed to connect to database")

    OutputDebug("Log entries: " logMessages.Length "`n")
    for msg in logMessages {
        OutputDebug("  " msg "`n")
    }
    OutputDebug("`n")

    ; Use Case 2: File list builder
    fileList := []
    extensions := ["txt", "ahk", "ini"]

    for ext in extensions {
        fileList.Push("document." ext)
        fileList.Push("config." ext)
    }

    OutputDebug("Generated files: " FormatArray(fileList) "`n")

    ; Use Case 3: Configuration builder
    config := []
    config.Push({ setting: "theme", value: "dark" })
    config.Push({ setting: "language", value: "en" })
    config.Push({ setting: "autoSave", value: true })

    OutputDebug("Config entries: " config.Length "`n")
    for entry in config {
        OutputDebug("  " entry.setting ": " entry.value "`n")
    }

    ; Use Case 4: Window title collector
    windowTitles := []
    windowTitles.Push(WinGetTitle("A"))  ; Active window

    ; Simulate collecting multiple window titles
    windowTitles.Push("Untitled - Notepad")
    windowTitles.Push("AutoHotkey v2.0")
    windowTitles.Push("File Explorer")

    OutputDebug("`nWindow titles collected: " windowTitles.Length "`n")
    OutputDebug("`n")
}

; ============================================================================
; Helper Functions
; ============================================================================

/**
 * Formats an array for display
 * @param {Array} arr - The array to format
 * @returns {String} Formatted string representation
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
            result .= "[Array(" value.Length ")]"
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
    OutputDebug("Array.Push() - Basic Usage Examples`n")
    OutputDebug(String.Repeat("=", 80) "`n`n")

    ; Run all examples
    Example1_SingleElementPush()
    Example2_MultipleElementPush()
    Example3_DifferentDataTypes()
    Example4_DynamicLoopBuilding()
    Example5_ReturnValueUsage()
    Example6_ConditionalPush()
    Example7_PracticalUseCases()

    OutputDebug(String.Repeat("=", 80) "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(String.Repeat("=", 80) "`n")

    MsgBox("Array.Push() examples completed!`nCheck DebugView for output.",
        "Examples Complete", "Icon!")
}

; Run the examples
Main()
