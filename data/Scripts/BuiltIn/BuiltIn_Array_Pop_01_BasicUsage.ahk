#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Array.Pop() - Basic Usage Examples
 * ============================================================================
 * 
 * The Pop() method removes and returns the last element from an array.
 * If the array is empty, an error is thrown.
 * 
 * Syntax: value := array.Pop()
 * 
 * @description Comprehensive examples demonstrating basic Pop() operations
 * @author AutoHotkey v2 Documentation
 * @version 1.0.0
 * @date 2025-01-16
 */

; ============================================================================
; Example 1: Single Element Pop
; ============================================================================
; Demonstrates removing individual elements from array end
Example1_SingleElementPop() {
    OutputDebug("=== Example 1: Single Element Pop ===`n")

    ; Create array with elements
    fruits := ["Apple", "Banana", "Cherry", "Date"]
    OutputDebug("Initial array: " FormatArray(fruits) "`n")
    OutputDebug("Initial length: " fruits.Length "`n`n")

    ; Pop one element
    lastFruit := fruits.Pop()
    OutputDebug("Popped element: " lastFruit "`n")
    OutputDebug("Array after pop: " FormatArray(fruits) "`n")
    OutputDebug("New length: " fruits.Length "`n`n")

    ; Pop another element
    lastFruit := fruits.Pop()
    OutputDebug("Popped element: " lastFruit "`n")
    OutputDebug("Array after pop: " FormatArray(fruits) "`n")
    OutputDebug("New length: " fruits.Length "`n`n")

    ; Use popped value
    OutputDebug("Using popped value: " lastFruit " is a great fruit!`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 2: Pop All Elements
; ============================================================================
; Remove all elements using Pop() in a loop
Example2_PopAllElements() {
    OutputDebug("=== Example 2: Pop All Elements ===`n")

    numbers := [10, 20, 30, 40, 50]
    OutputDebug("Starting array: " FormatArray(numbers) "`n")
    OutputDebug("Starting length: " numbers.Length "`n`n")

    ; Pop all elements
    OutputDebug("Popping all elements:`n")
    while (numbers.Length > 0) {
        value := numbers.Pop()
        OutputDebug("  Popped: " value " | Remaining length: " numbers.Length "`n")
    }

    OutputDebug("`nFinal array: " FormatArray(numbers) "`n")
    OutputDebug("Final length: " numbers.Length "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 3: Pop with Different Data Types
; ============================================================================
; Pop various data types from arrays
Example3_DifferentDataTypes() {
    OutputDebug("=== Example 3: Different Data Types ===`n")

    ; Array with mixed types
    mixed := ["String", 42, 3.14, true, { key: "value" }, [1, 2, 3]]
    OutputDebug("Initial array length: " mixed.Length "`n`n")

    ; Pop and identify types
    Loop 6 {
        if (mixed.Length = 0) {
            break
        }

        value := mixed.Pop()
        valueType := Type(value)

        OutputDebug("Popped: " valueType " | Remaining: " mixed.Length "`n")

        ; Display value based on type
        if (valueType = "String") {
            OutputDebug("  String value: '" value "'`n")
        } else if (valueType = "Integer" || valueType = "Float") {
            OutputDebug("  Numeric value: " value "`n")
        } else if (valueType = "Integer" && (value = 0 || value = 1)) {
            OutputDebug("  Boolean value: " (value ? "true" : "false") "`n")
        } else if (valueType = "Object") {
            OutputDebug("  Object popped`n")
        } else if (valueType = "Array") {
            OutputDebug("  Array popped (length: " value.Length ")`n")
        }
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 4: Return Value Usage
; ============================================================================
; Using the returned value from Pop()
Example4_ReturnValueUsage() {
    OutputDebug("=== Example 4: Return Value Usage ===`n")

    tasks := ["Task 1", "Task 2", "Task 3", "Task 4", "Task 5"]
    OutputDebug("Task queue: " FormatArray(tasks) "`n`n")

    ; Process tasks (LIFO - Last In, First Out)
    OutputDebug("Processing tasks:`n")
    Loop 3 {
        currentTask := tasks.Pop()
        OutputDebug("  Processing: " currentTask "`n")
        OutputDebug("  Tasks remaining: " tasks.Length "`n")
    }

    ; Use popped value in conditional
    OutputDebug("`nConditional pop:`n")
    if (tasks.Length > 0) {
        nextTask := tasks.Pop()
        OutputDebug("  Next task: " nextTask "`n")

        if (InStr(nextTask, "2")) {
            OutputDebug("  Task contains '2'!`n")
        }
    }

    ; Store popped values
    completedTasks := []
    while (tasks.Length > 0) {
        completedTasks.Push(tasks.Pop())
    }

    OutputDebug("`nCompleted tasks: " FormatArray(completedTasks) "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 5: Error Handling with Pop
; ============================================================================
; Handle errors when popping from empty array
Example5_ErrorHandling() {
    OutputDebug("=== Example 5: Error Handling ===`n")

    items := ["Item 1", "Item 2"]
    OutputDebug("Initial items: " FormatArray(items) "`n`n")

    ; Safe pop with length check
    OutputDebug("Safe pop with length check:`n")
    while (items.Length > 0) {
        item := items.Pop()
        OutputDebug("  Popped: " item "`n")
    }

    ; Try to pop from empty array
    OutputDebug("`nAttempting to pop from empty array:`n")
    try {
        item := items.Pop()
        OutputDebug("  This won't execute`n")
    } catch as err {
        OutputDebug("  Error caught: " err.Message "`n")
    }

    ; Safe pop function
    OutputDebug("`nUsing safe pop function:`n")
    emptyArray := []
    result := SafePop(emptyArray)

    if (result.HasOwnProp("success") && result.success) {
        OutputDebug("  Value: " result.value "`n")
    } else {
        OutputDebug("  " result.error "`n")
    }

    ; With data
    dataArray := [1, 2, 3]
    result := SafePop(dataArray)

    if (result.success) {
        OutputDebug("  Successfully popped: " result.value "`n")
        OutputDebug("  Array now has " dataArray.Length " elements`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 6: Pop in Data Processing
; ============================================================================
; Use Pop() for processing data in reverse order
Example6_DataProcessing() {
    OutputDebug("=== Example 6: Data Processing ===`n")

    ; Processing log entries (most recent first)
    logEntries := [{
        time: "10:00", message: "App started" }, {
            time: "10:05", message: "User logged in" }, {
                time: "10:10", message: "Data loaded" }, {
                    time: "10:15", message: "Processing complete" }, {
                        time: "10:20", message: "User logged out"
                    }
    ]

    OutputDebug("Log entries (total: " logEntries.Length "):`n")
    OutputDebug("Processing most recent entries:`n`n")

    ; Process last 3 entries
    processCount := Min(3, logEntries.Length)
    Loop processCount {
        entry := logEntries.Pop()
        OutputDebug("  [" entry.time "] " entry.message "`n")
    }

    OutputDebug("`nRemaining entries: " logEntries.Length "`n")

    ; Build reversed array using pop
    source := [1, 2, 3, 4, 5]
    reversed := []

    OutputDebug("`nReversing array using Pop:`n")
    OutputDebug("Original: " FormatArray(source) "`n")

    while (source.Length > 0) {
        reversed.Push(source.Pop())
    }

    OutputDebug("Reversed: " FormatArray(reversed) "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 7: Practical Use Cases
; ============================================================================
; Real-world scenarios using Pop()
Example7_PracticalUseCases() {
    OutputDebug("=== Example 7: Practical Use Cases ===`n")

    ; Use Case 1: Processing download queue
    OutputDebug("Use Case 1: Download Queue Processing`n")
    downloadQueue := [{
        file: "document.pdf", size: 1024 }, {
            file: "image.jpg", size: 2048 }, {
                file: "video.mp4", size: 10240
            }
    ]

    OutputDebug("Processing downloads (LIFO):`n")
    while (downloadQueue.Length > 0) {
        download := downloadQueue.Pop()
        OutputDebug("  Downloading: " download.file
            " (" download.size " KB)`n")
    }

    ; Use Case 2: Cleanup temporary files
    OutputDebug("`nUse Case 2: Cleanup Temporary Files`n")
    tempFiles := ["temp1.tmp", "cache2.tmp", "backup3.tmp"]

    OutputDebug("Cleaning up " tempFiles.Length " temporary files:`n")
    deletedCount := 0
    failedFiles := []

    while (tempFiles.Length > 0) {
        fileName := tempFiles.Pop()

        ; Simulate deletion
        if (Mod(deletedCount, 2) = 0) {  ; Simulate success/failure
            OutputDebug("  Deleted: " fileName "`n")
            deletedCount++
        } else {
            OutputDebug("  Failed: " fileName "`n")
            failedFiles.Push(fileName)
        }
    }

    OutputDebug("Successfully deleted: " deletedCount " files`n")
    OutputDebug("Failed: " failedFiles.Length " files`n")

    ; Use Case 3: Token processing
    OutputDebug("`nUse Case 3: Token Processing`n")
    tokens := ["END", "world", "+", "Hello"]

    OutputDebug("Processing tokens in reverse:`n")
    result := ""

    while (tokens.Length > 0) {
        token := tokens.Pop()

        if (token = "+") {
            OutputDebug("  Operator: " token "`n")
        } else if (token = "END") {
            OutputDebug("  End marker reached`n")
            break
        } else {
            result .= token " "
            OutputDebug("  Token: " token "`n")
        }
    }

    OutputDebug("Final result: " Trim(result) "`n")

    OutputDebug("`n")
}

; ============================================================================
; Helper Functions
; ============================================================================

/**
 * Safely pops an element from array
 * @param {Array} arr - The array to pop from
 * @returns {Object} Result object with success flag and value/error
 */
SafePop(arr) {
    if (arr.Length = 0) {
        return { success: false, error: "Cannot pop from empty array" }
    }

    return { success: true, value: arr.Pop() }
}

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
    OutputDebug("Array.Pop() - Basic Usage Examples`n")
    OutputDebug(String.Repeat("=", 80) "`n`n")

    ; Run all examples
    Example1_SingleElementPop()
    Example2_PopAllElements()
    Example3_DifferentDataTypes()
    Example4_ReturnValueUsage()
    Example5_ErrorHandling()
    Example6_DataProcessing()
    Example7_PracticalUseCases()

    OutputDebug(String.Repeat("=", 80) "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(String.Repeat("=", 80) "`n")

    MsgBox("Array.Pop() examples completed!`nCheck DebugView for output.",
        "Examples Complete", "Icon!")
}

; Run the examples
Main()
