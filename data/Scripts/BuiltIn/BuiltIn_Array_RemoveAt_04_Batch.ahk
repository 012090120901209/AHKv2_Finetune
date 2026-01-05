#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * Array.RemoveAt() - Batch Removal Operations
 * ============================================================================
 * 
 * Demonstrates efficient batch removal patterns, including removing multiple
 * elements at once and optimizing removal operations for performance.
 * 
 * @description Batch removal techniques using Array.RemoveAt()
 * @author AutoHotkey v2 Documentation
 * @version 1.0.0
 * @date 2025-01-16
 */

; Example 1: Remove Multiple Consecutive Elements
Example1_ConsecutiveRemoval() {
    OutputDebug("=== Example 1: Remove Consecutive Elements ===`n")

    data := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    OutputDebug("Initial: " FormatArray(data) "`n")

    ; Remove 3 elements starting at index 4
    data.RemoveAt(4, 3)
    OutputDebug("After RemoveAt(4, 3): " FormatArray(data) "`n")

    ; Remove 2 elements starting at index 2
    data.RemoveAt(2, 2)
    OutputDebug("After RemoveAt(2, 2): " FormatArray(data) "`n`n")
}

; Example 2: Remove by Index List
Example2_RemoveByIndexList() {
    OutputDebug("=== Example 2: Remove by Index List ===`n")

    items := ["A", "B", "C", "D", "E", "F", "G", "H"]
    indicesToRemove := [2, 4, 6]  ; Remove B, D, F

    OutputDebug("Initial: " FormatArray(items) "`n")
    OutputDebug("Removing indices: " FormatArray(indicesToRemove) "`n")

    ; Sort indices in descending order to remove from end first
    SortDescending(indicesToRemove)

    for index in indicesToRemove {
        removed := items.RemoveAt(index)
        OutputDebug("  Removed: " removed " at index " index "`n")
    }

    OutputDebug("Result: " FormatArray(items) "`n`n")
}

; Example 3: Remove Every Nth Element
Example3_RemoveEveryNth() {
    OutputDebug("=== Example 3: Remove Every Nth Element ===`n")

    numbers := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    n := 3

    OutputDebug("Initial: " FormatArray(numbers) "`n")
    OutputDebug("Removing every " n "rd element:`n")

    index := numbers.Length
    count := 0

    while (index >= 1) {
        count++
        if (Mod(count, n) = 0) {
            removed := numbers.RemoveAt(index)
            OutputDebug("  Removed: " removed "`n")
        }
        index--
    }

    OutputDebug("Result: " FormatArray(numbers) "`n`n")
}

; Example 4: Bulk Cleanup Operation
Example4_BulkCleanup() {
    OutputDebug("=== Example 4: Bulk Cleanup ===`n")

    cache := []

    ; Populate cache
    Loop 20 {
        cache.Push({
            id: A_Index,
            value: "Data" A_Index,
            keep: Mod(A_Index, 3) != 0
        })
    }

    OutputDebug("Cache size: " cache.Length "`n")

    ; Bulk remove items marked for deletion
    index := cache.Length
    removedCount := 0

    while (index >= 1) {
        if (!cache[index].keep) {
            cache.RemoveAt(index)
            removedCount++
        }
        index--
    }

    OutputDebug("Removed: " removedCount " items`n")
    OutputDebug("Remaining: " cache.Length " items`n`n")
}

; Example 5: Remove Range of Elements
Example5_RemoveRange() {
    OutputDebug("=== Example 5: Remove Range ===`n")

    data := [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    OutputDebug("Initial: " FormatArray(data) "`n")

    ; Define range
    rangeStart := 3
    rangeEnd := 7
    rangeLength := rangeEnd - rangeStart + 1

    OutputDebug("Removing range [" rangeStart ", " rangeEnd "]:`n")

    ; Remove the range
    Loop rangeLength {
        if (rangeStart <= data.Length) {
            removed := data.RemoveAt(rangeStart)
            OutputDebug("  Removed: " removed "`n")
        }
    }

    OutputDebug("Result: " FormatArray(data) "`n`n")
}

; Example 6: Batch Remove by Criteria
Example6_BatchRemoveByCriteria() {
    OutputDebug("=== Example 6: Batch Remove by Criteria ===`n")

    products := [{
        name: "Laptop", price: 1200, category: "Electronics", stock: 5 }, {
            name: "Mouse", price: 25, category: "Electronics", stock: 0 }, {
                name: "Desk", price: 300, category: "Furniture", stock: 3 }, {
                    name: "Chair", price: 150, category: "Furniture", stock: 0 }, {
                        name: "Monitor", price: 400, category: "Electronics", stock: 2 }, {
                            name: "Keyboard", price: 75, category: "Electronics", stock: 0
                        }
    ]

    OutputDebug("Total products: " products.Length "`n")

    ; Remove all out-of-stock electronics
    OutputDebug("Removing out-of-stock electronics:`n")

    index := products.Length
    while (index >= 1) {
        product := products[index]
        if (product.category = "Electronics" && product.stock = 0) {
            removed := products.RemoveAt(index)
            OutputDebug("  Removed: " removed.name "`n")
        }
        index--
    }

    OutputDebug("Products remaining: " products.Length "`n`n")
}

; Example 7: Progressive Batch Removal
Example7_ProgressiveBatchRemoval() {
    OutputDebug("=== Example 7: Progressive Batch Removal ===`n")

    tasks := []

    ; Create large task list
    Loop 50 {
        tasks.Push({
            id: A_Index,
            priority: Mod(A_Index, 5) + 1,
            status: (Mod(A_Index, 3) = 0 ? "complete" : "pending")
        })
    }

    OutputDebug("Total tasks: " tasks.Length "`n")

    ; Remove in batches
    batchSize := 5
    batches := 0

    OutputDebug("Removing completed tasks in batches of " batchSize ":`n")

    Loop {
        removed := 0
        index := tasks.Length

        ; Remove up to batchSize items
        while (index >= 1 && removed < batchSize) {
            if (tasks[index].status = "complete") {
                tasks.RemoveAt(index)
                removed++
            }
            index--
        }

        if (removed = 0) {
            break
        }

        batches++
        OutputDebug("  Batch " batches ": Removed " removed " tasks | Remaining: " tasks.Length "`n")
    }

    OutputDebug("`nTotal batches: " batches "`n")
    OutputDebug("Final task count: " tasks.Length "`n`n")
}

; Helper Functions
SortDescending(arr) {
    ; Simple bubble sort in descending order
    n := arr.Length

    Loop n - 1 {
        i := A_Index
        Loop n - i {
            j := A_Index
            if (arr[j] < arr[j + 1]) {
                temp := arr[j]
                arr[j] := arr[j + 1]
                arr[j + 1] := temp
            }
        }
    }
}

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
        else
            result .= valueType
    }
    result .= "]"

    return result
}

Main() {
    OutputDebug("`n" String.Repeat("=", 80) "`n")
    OutputDebug("Array.RemoveAt() - Batch Removal Examples`n")
    OutputDebug(String.Repeat("=", 80) "`n`n")

    Example1_ConsecutiveRemoval()
    Example2_RemoveByIndexList()
    Example3_RemoveEveryNth()
    Example4_BulkCleanup()
    Example5_RemoveRange()
    Example6_BatchRemoveByCriteria()
    Example7_ProgressiveBatchRemoval()

    OutputDebug(String.Repeat("=", 80) "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(String.Repeat("=", 80) "`n")

    MsgBox("Array.RemoveAt() batch removal examples completed!`nCheck DebugView for output.",
        "Examples Complete", "Icon!")
}

Main()
