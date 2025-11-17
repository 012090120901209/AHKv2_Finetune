#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Array.Push() - Dynamic List Building
 * ============================================================================
 *
 * The Push() method is essential for building dynamic lists when the final
 * size is unknown. This file demonstrates various list-building patterns
 * commonly used in real-world applications.
 *
 * @description Advanced list building techniques using Push()
 * @author AutoHotkey v2 Documentation
 * @version 1.0.0
 * @date 2025-01-16
 */

; ============================================================================
; Example 1: Building Lists from File Operations
; ============================================================================
; Collecting file information into arrays
Example1_FileListBuilding() {
    OutputDebug("=== Example 1: File List Building ===`n")

    ; Build list of AHK files in a directory
    ahkFiles := []
    try {
        Loop Files, A_ScriptDir "\*.ahk" {
            fileInfo := {
                name: A_LoopFileName,
                path: A_LoopFilePath,
                size: A_LoopFileSize,
                modified: A_LoopFileTimeModified
            }
            ahkFiles.Push(fileInfo)
        }
        OutputDebug("Found " ahkFiles.Length " AHK files`n")
    } catch as err {
        OutputDebug("Error reading files: " err.Message "`n")
    }

    ; Build list of directories only
    directories := []
    try {
        Loop Files, A_ScriptDir "\*.*", "D" {
            directories.Push(A_LoopFileName)
        }
        OutputDebug("Found " directories.Length " directories`n")
    }

    ; Build filtered list by size
    largeFiles := []
    try {
        Loop Files, A_ScriptDir "\*.*", "R" {  ; Recursive
            if (A_LoopFileSize > 10000) {  ; Files larger than 10KB
                largeFiles.Push({
                    name: A_LoopFileName,
                    size: A_LoopFileSize,
                    folder: A_LoopFileDir
                })
            }
        }
        OutputDebug("Found " largeFiles.Length " large files`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 2: Building Lists from String Parsing
; ============================================================================
; Parse and build lists from text data
Example2_StringParsingLists() {
    OutputDebug("=== Example 2: String Parsing Lists ===`n")

    ; Parse CSV-like data
    csvData := "John,30,Engineer`nJane,28,Designer`nBob,35,Manager"
    people := []

    Loop Parse, csvData, "`n", "`r" {
        if (A_LoopField = "") {
            continue
        }

        parts := StrSplit(A_LoopField, ",")
        if (parts.Length >= 3) {
            person := {
                name: parts[1],
                age: Integer(parts[2]),
                role: parts[3]
            }
            people.Push(person)
        }
    }

    OutputDebug("Parsed " people.Length " people from CSV`n")
    for person in people {
        OutputDebug("  " person.name " (" person.age ") - " person.role "`n")
    }

    ; Build word list from sentence
    sentence := "The quick brown fox jumps over the lazy dog"
    words := []

    Loop Parse, sentence, " " {
        if (StrLen(A_LoopField) > 0) {
            words.Push(A_LoopField)
        }
    }

    OutputDebug("`nWords in sentence: " words.Length "`n")

    ; Extract numbers from text
    text := "Order #123 contains 45 items worth $67.89"
    numbers := []

    pos := 1
    while (pos := RegExMatch(text, "\d+\.?\d*", &match, pos)) {
        numbers.Push(match[0])
        pos += StrLen(match[0])
    }

    OutputDebug("Numbers found: " FormatArray(numbers) "`n")
    OutputDebug("`n")
}

; ============================================================================
; Example 3: Building Filtered and Transformed Lists
; ============================================================================
; Map and filter operations using Push()
Example3_FilteredLists() {
    OutputDebug("=== Example 3: Filtered and Transformed Lists ===`n")

    ; Source data
    products := [
        {name: "Laptop", price: 1200, category: "Electronics"},
        {name: "Mouse", price: 25, category: "Electronics"},
        {name: "Desk", price: 350, category: "Furniture"},
        {name: "Chair", price: 200, category: "Furniture"},
        {name: "Monitor", price: 300, category: "Electronics"}
    ]

    ; Filter: Get expensive items (>= $300)
    expensiveItems := []
    for product in products {
        if (product.price >= 300) {
            expensiveItems.Push(product)
        }
    }
    OutputDebug("Expensive items: " expensiveItems.Length "`n")

    ; Filter: Get electronics only
    electronics := []
    for product in products {
        if (product.category = "Electronics") {
            electronics.Push(product)
        }
    }
    OutputDebug("Electronics: " electronics.Length "`n")

    ; Transform: Extract just the names
    productNames := []
    for product in products {
        productNames.Push(product.name)
    }
    OutputDebug("Product names: " FormatArray(productNames) "`n")

    ; Transform: Calculate discounted prices
    discountedPrices := []
    for product in products {
        discountedPrices.Push({
            name: product.name,
            originalPrice: product.price,
            salePrice: Round(product.price * 0.9, 2)
        })
    }
    OutputDebug("Created " discountedPrices.Length " discounted items`n")

    ; Complex filter: Electronics under $500
    affordableElectronics := []
    for product in products {
        if (product.category = "Electronics" && product.price < 500) {
            affordableElectronics.Push(product.name)
        }
    }
    OutputDebug("Affordable electronics: " FormatArray(affordableElectronics) "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 4: Building Hierarchical Lists
; ============================================================================
; Create nested structures with Push()
Example4_HierarchicalLists() {
    OutputDebug("=== Example 4: Hierarchical Lists ===`n")

    ; Build a simple tree structure
    rootNode := {
        name: "Root",
        children: []
    }

    ; Add child nodes
    rootNode.children.Push({name: "Child 1", children: []})
    rootNode.children.Push({name: "Child 2", children: []})
    rootNode.children.Push({name: "Child 3", children: []})

    ; Add grandchildren to first child
    rootNode.children[1].children.Push({name: "Grandchild 1.1", children: []})
    rootNode.children[1].children.Push({name: "Grandchild 1.2", children: []})

    OutputDebug("Tree structure created:`n")
    OutputDebug("  Root has " rootNode.children.Length " children`n")
    OutputDebug("  Child 1 has " rootNode.children[1].children.Length " children`n")

    ; Build category hierarchy
    categories := []

    ; Electronics category
    electronicsCategory := {
        name: "Electronics",
        items: []
    }
    electronicsCategory.items.Push("Laptop")
    electronicsCategory.items.Push("Phone")
    electronicsCategory.items.Push("Tablet")
    categories.Push(electronicsCategory)

    ; Furniture category
    furnitureCategory := {
        name: "Furniture",
        items: []
    }
    furnitureCategory.items.Push("Desk")
    furnitureCategory.items.Push("Chair")
    categories.Push(furnitureCategory)

    OutputDebug("`nCategory hierarchy:`n")
    for category in categories {
        OutputDebug("  " category.name ": " category.items.Length " items`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 5: Building Lists with Aggregation
; ============================================================================
; Accumulate and aggregate data into lists
Example5_AggregationLists() {
    OutputDebug("=== Example 5: Aggregation Lists ===`n")

    ; Sales data
    salesData := [
        {month: "Jan", amount: 1000},
        {month: "Feb", amount: 1200},
        {month: "Mar", amount: 1100},
        {month: "Apr", amount: 1300},
        {month: "May", amount: 1500},
        {month: "Jun", amount: 1400}
    ]

    ; Build running total list
    runningTotals := []
    total := 0

    for sale in salesData {
        total += sale.amount
        runningTotals.Push({
            month: sale.month,
            monthlyAmount: sale.amount,
            runningTotal: total
        })
    }

    OutputDebug("Running totals:`n")
    for entry in runningTotals {
        OutputDebug("  " entry.month ": $" entry.monthlyAmount
                    " (Total: $" entry.runningTotal ")`n")
    }

    ; Build averages list (moving average)
    windowSize := 3
    movingAverages := []

    for index, sale in salesData {
        if (index >= windowSize) {
            sum := 0
            Loop windowSize {
                sum += salesData[index - (A_Index - 1)].amount
            }
            avg := Round(sum / windowSize, 2)
            movingAverages.Push({
                month: sale.month,
                average: avg
            })
        }
    }

    OutputDebug("`n3-month moving averages:`n")
    for entry in movingAverages {
        OutputDebug("  " entry.month ": $" entry.average "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 6: Building Lists from User Input Simulation
; ============================================================================
; Simulate collecting user input into lists
Example6_UserInputLists() {
    OutputDebug("=== Example 6: User Input Lists ===`n")

    ; Simulate form submissions
    formSubmissions := []

    ; Simulate 5 form submissions
    Loop 5 {
        submission := {
            id: A_Index,
            timestamp: A_Now,
            name: "User" A_Index,
            email: "user" A_Index "@example.com",
            message: "This is message #" A_Index
        }
        formSubmissions.Push(submission)
    }

    OutputDebug("Collected " formSubmissions.Length " form submissions`n")

    ; Build validation errors list
    validationErrors := []

    for submission in formSubmissions {
        ; Simulate validation
        if (Mod(submission.id, 2) = 0) {  ; Even IDs have errors
            validationErrors.Push({
                submissionId: submission.id,
                field: "email",
                error: "Invalid email format"
            })
        }
    }

    OutputDebug("Validation errors found: " validationErrors.Length "`n")

    ; Build search results simulation
    searchQuery := "test"
    searchResults := []

    ; Simulate finding matching items
    allItems := ["test1", "item2", "test3", "data4", "test5"]
    for item in allItems {
        if (InStr(item, searchQuery)) {
            searchResults.Push(item)
        }
    }

    OutputDebug("Search results for '" searchQuery "': " searchResults.Length "`n")
    OutputDebug("`n")
}

; ============================================================================
; Example 7: Building Lists with Deduplication
; ============================================================================
; Build unique lists by checking before pushing
Example7_DeduplicationLists() {
    OutputDebug("=== Example 7: Deduplication Lists ===`n")

    ; Source with duplicates
    sourceData := ["apple", "banana", "apple", "cherry", "banana", "date", "apple"]

    ; Build unique list (simple approach)
    uniqueItems := []
    for item in sourceData {
        isUnique := true
        for existing in uniqueItems {
            if (existing = item) {
                isUnique := false
                break
            }
        }
        if (isUnique) {
            uniqueItems.Push(item)
        }
    }

    OutputDebug("Original: " sourceData.Length " items`n")
    OutputDebug("Unique: " uniqueItems.Length " items`n")
    OutputDebug("Unique items: " FormatArray(uniqueItems) "`n")

    ; Build unique list using Map for faster lookup
    sourceNumbers := [1, 2, 3, 2, 4, 1, 5, 3, 6, 4, 7]
    uniqueNumbers := []
    seen := Map()

    for num in sourceNumbers {
        if (!seen.Has(num)) {
            uniqueNumbers.Push(num)
            seen[num] := true
        }
    }

    OutputDebug("`nOriginal numbers: " sourceNumbers.Length "`n")
    OutputDebug("Unique numbers: " uniqueNumbers.Length "`n")
    OutputDebug("Numbers: " FormatArray(uniqueNumbers) "`n")

    ; Build case-insensitive unique list
    mixedCase := ["Apple", "banana", "APPLE", "Banana", "cherry", "CHERRY"]
    caseInsensitiveUnique := []
    seenLower := Map()

    for item in mixedCase {
        lowerItem := StrLower(item)
        if (!seenLower.Has(lowerItem)) {
            caseInsensitiveUnique.Push(item)
            seenLower[lowerItem] := true
        }
    }

    OutputDebug("`nCase-insensitive unique:`n")
    OutputDebug("Original: " mixedCase.Length " | Unique: " caseInsensitiveUnique.Length "`n")
    OutputDebug("Items: " FormatArray(caseInsensitiveUnique) "`n")

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
    if (!IsObject(arr) || !arr.HasOwnProp("Length")) {
        return String(arr)
    }

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
    OutputDebug("Array.Push() - Dynamic List Building Examples`n")
    OutputDebug(String.Repeat("=", 80) "`n`n")

    ; Run all examples
    Example1_FileListBuilding()
    Example2_StringParsingLists()
    Example3_FilteredLists()
    Example4_HierarchicalLists()
    Example5_AggregationLists()
    Example6_UserInputLists()
    Example7_DeduplicationLists()

    OutputDebug(String.Repeat("=", 80) "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(String.Repeat("=", 80) "`n")

    MsgBox("Array.Push() list building examples completed!`nCheck DebugView for output.",
           "Examples Complete", "Icon!")
}

; Run the examples
Main()
