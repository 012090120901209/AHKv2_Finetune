#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Array.RemoveAt() - Filtering and Selection
 * ============================================================================
 *
 * Demonstrates using RemoveAt() to filter arrays based on various criteria.
 * Important: When removing multiple elements, iterate backwards to avoid
 * index shifting issues.
 *
 * @description Array filtering techniques using Array.RemoveAt()
 * @author AutoHotkey v2 Documentation
 * @version 1.0.0
 * @date 2025-01-16
 */

; Example 1: Filter by Value
Example1_FilterByValue() {
    OutputDebug("=== Example 1: Filter by Value ===`n")

    numbers := [1, 5, 10, 15, 20, 25, 30]
    threshold := 15

    OutputDebug("Initial: " FormatArray(numbers) "`n")
    OutputDebug("Removing values > " threshold "`n")

    index := numbers.Length
    while (index >= 1) {
        if (numbers[index] > threshold) {
            numbers.RemoveAt(index)
        }
        index--
    }

    OutputDebug("Result: " FormatArray(numbers) "`n`n")
}

; Example 2: Filter by Type
Example2_FilterByType() {
    OutputDebug("=== Example 2: Filter by Type ===`n")

    mixed := [1, "text", 3.14, true, "hello", 42, false, "world"]
    OutputDebug("Initial (" mixed.Length " items): Mixed types`n")

    ; Remove all strings
    OutputDebug("Removing all strings:`n")
    index := mixed.Length
    while (index >= 1) {
        if (Type(mixed[index]) = "String") {
            removed := mixed.RemoveAt(index)
            OutputDebug("  Removed: '" removed "'`n")
        }
        index--
    }

    OutputDebug("Remaining: " mixed.Length " items (non-strings)`n`n")
}

; Example 3: Filter by Object Property
Example3_FilterByProperty() {
    OutputDebug("=== Example 3: Filter by Object Property ===`n")

    users := [
        {name: "Alice", active: true, age: 30},
        {name: "Bob", active: false, age: 25},
        {name: "Charlie", active: true, age: 35},
        {name: "David", active: false, age: 28}
    ]

    OutputDebug("Total users: " users.Length "`n")

    ; Remove inactive users
    OutputDebug("Removing inactive users:`n")
    index := users.Length
    while (index >= 1) {
        if (!users[index].active) {
            removed := users.RemoveAt(index)
            OutputDebug("  Removed: " removed.name " (inactive)`n")
        }
        index--
    }

    OutputDebug("Active users remaining: " users.Length "`n`n")
}

; Example 4: Range Filtering
Example4_RangeFiltering() {
    OutputDebug("=== Example 4: Range Filtering ===`n")

    scores := [45, 67, 89, 34, 92, 56, 78, 23, 91, 88]
    minScore := 60
    maxScore := 90

    OutputDebug("Initial scores: " FormatArray(scores) "`n")
    OutputDebug("Keeping only scores between " minScore " and " maxScore "`n")

    index := scores.Length
    while (index >= 1) {
        score := scores[index]
        if (score < minScore || score > maxScore) {
            scores.RemoveAt(index)
        }
        index--
    }

    OutputDebug("Filtered scores: " FormatArray(scores) "`n`n")
}

; Example 5: Pattern Matching Filter
Example5_PatternFiltering() {
    OutputDebug("=== Example 5: Pattern Matching ===`n")

    files := ["document.txt", "image.jpg", "script.ahk", "data.txt", "photo.jpg", "config.ini"]
    pattern := "txt"

    OutputDebug("Files: " FormatArray(files) "`n")
    OutputDebug("Removing files containing '" pattern "':`n")

    index := files.Length
    while (index >= 1) {
        if (InStr(files[index], pattern)) {
            removed := files.RemoveAt(index)
            OutputDebug("  Removed: " removed "`n")
        }
        index--
    }

    OutputDebug("Remaining: " FormatArray(files) "`n`n")
}

; Example 6: Multi-Condition Filtering
Example6_MultiConditionFilter() {
    OutputDebug("=== Example 6: Multi-Condition Filtering ===`n")

    products := [
        {name: "Laptop", price: 1200, inStock: true, category: "Electronics"},
        {name: "Mouse", price: 25, inStock: false, category: "Electronics"},
        {name: "Desk", price: 300, inStock: true, category: "Furniture"},
        {name: "Chair", price: 150, inStock: true, category: "Furniture"},
        {name: "Monitor", price: 400, inStock: false, category: "Electronics"}
    ]

    OutputDebug("Total products: " products.Length "`n")
    OutputDebug("Removing: Out of stock OR price > $500`n")

    index := products.Length
    while (index >= 1) {
        product := products[index]
        if (!product.inStock || product.price > 500) {
            removed := products.RemoveAt(index)
            reason := !removed.inStock ? "out of stock" : "price > $500"
            OutputDebug("  Removed " removed.name " (" reason ")`n")
        }
        index--
    }

    OutputDebug("Products remaining: " products.Length "`n`n")
}

; Example 7: Custom Filter Function
Example7_CustomFilter() {
    OutputDebug("=== Example 7: Custom Filter Function ===`n")

    data := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

    OutputDebug("Initial: " FormatArray(data) "`n")

    ; Filter 1: Remove even numbers
    FilterArray(data, IsEven)
    OutputDebug("After removing evens: " FormatArray(data) "`n")

    ; New dataset
    data2 := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    ; Filter 2: Remove numbers not divisible by 3
    FilterArray(data2, NotDivisibleBy3)
    OutputDebug("After keeping only multiples of 3: " FormatArray(data2) "`n")

    ; Filter objects
    people := [
        {name: "Alice", age: 25},
        {name: "Bob", age: 17},
        {name: "Charlie", age: 30},
        {name: "David", age: 16}
    ]

    OutputDebug("`nPeople: " people.Length "`n")
    FilterArray(people, IsMinor)
    OutputDebug("After removing minors: " people.Length " people`n`n")
}

; Filter Predicate Functions
IsEven(value) => Mod(value, 2) = 0
NotDivisibleBy3(value) => Mod(value, 3) != 0
IsMinor(person) => person.age < 18

; Generic Filter Function
FilterArray(arr, predicateFunc) {
    index := arr.Length
    while (index >= 1) {
        if (predicateFunc(arr[index])) {
            arr.RemoveAt(index)
        }
        index--
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
    OutputDebug("Array.RemoveAt() - Filtering Examples`n")
    OutputDebug(String.Repeat("=", 80) "`n`n")

    Example1_FilterByValue()
    Example2_FilterByType()
    Example3_FilterByProperty()
    Example4_RangeFiltering()
    Example5_PatternFiltering()
    Example6_MultiConditionFilter()
    Example7_CustomFilter()

    OutputDebug(String.Repeat("=", 80) "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(String.Repeat("=", 80) "`n")

    MsgBox("Array.RemoveAt() filtering examples completed!`nCheck DebugView for output.",
           "Examples Complete", "Icon!")
}

Main()
