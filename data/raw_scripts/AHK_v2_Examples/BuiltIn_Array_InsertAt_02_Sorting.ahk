#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Array.InsertAt() - Sorted Insertion Patterns
 * ============================================================================
 *
 * Demonstrates maintaining sorted order using InsertAt(). Critical for
 * implementing sorted data structures, binary search trees, and ordered lists.
 *
 * @description Sorted insertion techniques using Array.InsertAt()
 * @author AutoHotkey v2 Documentation
 * @version 1.0.0
 * @date 2025-01-16
 */

; Example 1: Maintaining Numeric Sort
Example1_NumericSort() {
    OutputDebug("=== Example 1: Maintaining Numeric Sort ===`n")

    sorted := [10, 30, 50, 70, 90]
    valuesToInsert := [25, 60, 5, 95, 40]

    OutputDebug("Initial sorted array: " FormatArray(sorted) "`n`n")

    for value in valuesToInsert {
        pos := BinarySearchInsert(sorted, value)
        sorted.InsertAt(pos, value)
        OutputDebug("Inserted " value " at position " pos ": " FormatArray(sorted) "`n")
    }
    OutputDebug("`n")
}

; Example 2: Alphabetical Sorting
Example2_AlphabeticalSort() {
    OutputDebug("=== Example 2: Alphabetical Sorting ===`n")

    names := ["Alice", "Charlie", "Eve"]
    newNames := ["Bob", "David", "Aaron", "Frank"]

    OutputDebug("Initial names: " FormatArray(names) "`n`n")

    for name in newNames {
        pos := FindAlphaPosition(names, name)
        names.InsertAt(pos, name)
        OutputDebug("Inserted '" name "' at position " pos ": " FormatArray(names) "`n")
    }
    OutputDebug("`n")
}

; Example 3: Custom Object Sorting
Example3_ObjectSorting() {
    OutputDebug("=== Example 3: Custom Object Sorting ===`n")

    products := [
        {name: "Laptop", price: 1000},
        {name: "Phone", price: 500},
        {name: "Tablet", price: 800}
    ]

    OutputDebug("Products sorted by price:`n")
    ShowProducts(products)

    newProduct := {name: "Monitor", price: 300}
    pos := FindProductPosition(products, newProduct)
    products.InsertAt(pos, newProduct)

    OutputDebug("`nAfter inserting Monitor ($300):`n")
    ShowProducts(products)

    anotherProduct := {name: "Keyboard", price: 150}
    pos := FindProductPosition(products, anotherProduct)
    products.InsertAt(pos, anotherProduct)

    OutputDebug("`nAfter inserting Keyboard ($150):`n")
    ShowProducts(products)
    OutputDebug("`n")
}

; Example 4: Multi-Key Sorting
Example4_MultiKeySort() {
    OutputDebug("=== Example 4: Multi-Key Sorting ===`n")

    students := [
        {grade: "A", name: "Alice", score: 95},
        {grade: "A", name: "Charlie", score: 92},
        {grade: "B", name: "Bob", score: 85}
    ]

    OutputDebug("Students sorted by grade, then score:`n")
    ShowStudents(students)

    newStudent := {grade: "A", name: "Dave", score: 94}
    pos := FindStudentPosition(students, newStudent)
    students.InsertAt(pos, newStudent)

    OutputDebug("`nAfter adding Dave (A, 94):`n")
    ShowStudents(students)
    OutputDebug("`n")
}

; Example 5: Priority-Based Insertion
Example5_PriorityInsertion() {
    OutputDebug("=== Example 5: Priority-Based Insertion ===`n")

    queue := [
        {task: "Critical Fix", priority: 1},
        {task: "Enhancement", priority: 3},
        {task: "Documentation", priority: 5}
    ]

    OutputDebug("Priority queue (1=highest):`n")
    ShowQueue(queue)

    tasks := [
        {task: "Urgent Bug", priority: 1},
        {task: "Refactoring", priority: 4},
        {task: "Testing", priority: 2}
    ]

    for task in tasks {
        pos := FindPriorityPosition(queue, task.priority)
        queue.InsertAt(pos, task)
        OutputDebug("`nInserted '" task.task "' (Priority " task.priority "):`n")
        ShowQueue(queue)
    }
    OutputDebug("`n")
}

; Example 6: Timestamp-Based Insertion
Example6_TimestampInsertion() {
    OutputDebug("=== Example 6: Timestamp-Based Insertion ===`n")

    events := [
        {time: 1000, event: "Start"},
        {time: 5000, event: "Finish"}
    ]

    OutputDebug("Timeline:`n")
    ShowTimeline(events)

    newEvents := [
        {time: 3000, event: "Checkpoint 1"},
        {time: 2000, event: "Initialize"},
        {time: 4000, event: "Checkpoint 2"}
    ]

    for evt in newEvents {
        pos := FindTimePosition(events, evt.time)
        events.InsertAt(pos, evt)
        OutputDebug("`nAdded " evt.event " at t=" evt.time ":`n")
        ShowTimeline(events)
    }
    OutputDebug("`n")
}

; Example 7: Duplicate Handling
Example7_DuplicateHandling() {
    OutputDebug("=== Example 7: Duplicate Handling ===`n")

    ; Allow duplicates
    allowDups := [1, 2, 4, 6, 8]
    OutputDebug("Allow duplicates: " FormatArray(allowDups) "`n")

    InsertSorted(allowDups, 4)
    OutputDebug("After inserting 4: " FormatArray(allowDups) "`n")

    ; Prevent duplicates
    noDups := [1, 2, 4, 6, 8]
    OutputDebug("`nPrevent duplicates: " FormatArray(noDups) "`n")

    if (!Contains(noDups, 4)) {
        InsertSorted(noDups, 4)
    } else {
        OutputDebug("Skipped inserting 4 (already exists)`n")
    }

    if (!Contains(noDups, 5)) {
        InsertSorted(noDups, 5)
        OutputDebug("Inserted 5: " FormatArray(noDups) "`n")
    }
    OutputDebug("`n")
}

; Helper Functions
BinarySearchInsert(arr, value) {
    left := 1, right := arr.Length + 1
    while (left < right) {
        mid := Floor((left + right) / 2)
        if (arr[mid] < value)
            left := mid + 1
        else
            right := mid
    }
    return left
}

FindAlphaPosition(arr, value) {
    pos := 1
    for item in arr {
        if (StrCompare(value, item) < 0)
            break
        pos++
    }
    return pos
}

FindProductPosition(products, newProduct) {
    pos := 1
    for product in products {
        if (newProduct.price < product.price)
            break
        pos++
    }
    return pos
}

FindStudentPosition(students, newStudent) {
    pos := 1
    for student in students {
        if (newStudent.grade < student.grade) {
            break
        }
        if (newStudent.grade = student.grade && newStudent.score > student.score) {
            break
        }
        pos++
    }
    return pos
}

FindPriorityPosition(queue, priority) {
    pos := 1
    for item in queue {
        if (priority < item.priority)
            break
        pos++
    }
    return pos
}

FindTimePosition(events, time) {
    pos := 1
    for event in events {
        if (time < event.time)
            break
        pos++
    }
    return pos
}

InsertSorted(arr, value) {
    pos := BinarySearchInsert(arr, value)
    arr.InsertAt(pos, value)
}

Contains(arr, value) {
    for item in arr
        if (item = value)
            return true
    return false
}

ShowProducts(products) {
    for product in products
        OutputDebug("  " product.name ": $" product.price "`n")
}

ShowStudents(students) {
    for student in students
        OutputDebug("  " student.name " - Grade: " student.grade " (Score: " student.score ")`n")
}

ShowQueue(queue) {
    for task in queue
        OutputDebug("  [P" task.priority "] " task.task "`n")
}

ShowTimeline(events) {
    for event in events
        OutputDebug("  t=" event.time ": " event.event "`n")
}

FormatArray(arr) {
    if (arr.Length = 0)
        return "[]"
    result := "["
    for index, value in arr {
        if (index > 1)
            result .= ", "
        result .= (Type(value) = "String" ? '"' value '"' : value)
    }
    return result "]"
}

Main() {
    OutputDebug("`n" String.Repeat("=", 80) "`n")
    OutputDebug("Array.InsertAt() - Sorted Insertion Examples`n")
    OutputDebug(String.Repeat("=", 80) "`n`n")

    Example1_NumericSort()
    Example2_AlphabeticalSort()
    Example3_ObjectSorting()
    Example4_MultiKeySort()
    Example5_PriorityInsertion()
    Example6_TimestampInsertion()
    Example7_DuplicateHandling()

    OutputDebug(String.Repeat("=", 80) "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(String.Repeat("=", 80) "`n")

    MsgBox("Array.InsertAt() sorting examples completed!`nCheck DebugView for output.",
           "Examples Complete", "Icon!")
}

Main()
