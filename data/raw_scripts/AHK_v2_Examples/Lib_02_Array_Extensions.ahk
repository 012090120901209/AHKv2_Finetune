#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Array Extensions - Functional Array Operations
 *
 * Demonstrates enhanced Array methods including Map, Filter,
 * Reduce, and other functional programming operations that
 * make array manipulation cleaner and more expressive.
 *
 * Source: nperovic-AHK-v2-Libraries/Lib/Array.ahk
 * Inspired by: https://github.com/nperovic/AHK-v2-Libraries
 */

#Include <Array>

MsgBox("Array Extensions Demo`n`n"
     . "Functional programming for arrays:`n"
     . "- Map (transform elements)`n"
     . "- Filter (keep matching)`n"
     . "- Reduce (combine to single value)`n"
     . "- Find, IndexOf, Shuffle, Flat`n"
     . "- Slice with step support", , "T5")

; ===============================================
; MAP - TRANSFORM EACH ELEMENT
; ===============================================

numbers := [1, 2, 3, 4, 5]

; Square each number
squared := numbers.Map((num) => num * num)
MsgBox("Map - Square each number:`n`n"
     . "Original: [" Join(numbers) "]`n"
     . "Squared:  [" Join(squared) "]", , "T4")

; Convert to strings with prefix
prefixed := numbers.Map((num) => "Item-" num)
MsgBox("Map - Add prefix:`n`n"
     . "Original: [" Join(numbers) "]`n"
     . "Prefixed: [" Join(prefixed, ", ") "]", , "T4")

; ===============================================
; FILTER - KEEP MATCHING ELEMENTS
; ===============================================

; Keep only even numbers
evens := numbers.Filter((num) => Mod(num, 2) == 0)
MsgBox("Filter - Even numbers only:`n`n"
     . "Original: [" Join(numbers) "]`n"
     . "Evens:    [" Join(evens) "]", , "T3")

; Keep numbers greater than 3
greaterThan3 := numbers.Filter((num) => num > 3)
MsgBox("Filter - Numbers > 3:`n`n"
     . "Original: [" Join(numbers) "]`n"
     . "Result:   [" Join(greaterThan3) "]", , "T3")

; ===============================================
; REDUCE - COMBINE TO SINGLE VALUE
; ===============================================

; Sum all numbers
sum := numbers.Reduce((acc, num) => acc + num, 0)
MsgBox("Reduce - Sum all numbers:`n`n"
     . "Array: [" Join(numbers) "]`n"
     . "Sum: " sum, , "T3")

; Product of all numbers
product := numbers.Reduce((acc, num) => acc * num, 1)
MsgBox("Reduce - Product of all numbers:`n`n"
     . "Array: [" Join(numbers) "]`n"
     . "Product: " product, , "T3")

; Find maximum
max := numbers.Reduce((acc, num) => num > acc ? num : acc, numbers[1])
MsgBox("Reduce - Find maximum:`n`n"
     . "Array: [" Join(numbers) "]`n"
     . "Max: " max, , "T3")

; ===============================================
; FIND AND INDEXOF
; ===============================================

names := ["Alice", "Bob", "Charlie", "David", "Eve"]

; Find index of element
bobIndex := names.IndexOf("Bob")
eveIndex := names.IndexOf("Eve")
MsgBox("IndexOf - Find element position:`n`n"
     . "Array: [" Join(names, ", ") "]`n`n"
     . "Index of 'Bob': " bobIndex "`n"
     . "Index of 'Eve': " eveIndex, , "T4")

; Find element matching condition
found := names.Find((name) => StrLen(name) > 5, &match)
MsgBox("Find - First name with length > 5:`n`n"
     . "Array: [" Join(names, ", ") "]`n`n"
     . "Found: " match "`n"
     . "At index: " found, , "T4")

; ===============================================
; SHUFFLE - RANDOMIZE ARRAY
; ===============================================

cards := ["A♠", "K♠", "Q♠", "J♠", "10♠"]
original := cards.Clone()
cards.Shuffle()

MsgBox("Shuffle - Randomize array:`n`n"
     . "Original: [" Join(original, ", ") "]`n"
     . "Shuffled: [" Join(cards, ", ") "]", , "T4")

; ===============================================
; FLAT - FLATTEN NESTED ARRAYS
; ===============================================

nested := [[1, 2], [3, 4], [5, 6]]
flattened := nested.Flat()

MsgBox("Flat - Flatten nested arrays:`n`n"
     . "Nested: [[1,2], [3,4], [5,6]]`n"
     . "Flat: [" Join(flattened) "]", , "T3")

; ===============================================
; SLICE - EXTRACT PORTION WITH STEP
; ===============================================

data := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

; Get first 5 elements
first5 := data.Slice(1, 5)
MsgBox("Slice - First 5 elements:`n`n"
     . "Original: [" Join(data) "]`n"
     . "First 5:  [" Join(first5) "]", , "T3")

; Get every other element
everyOther := data.Slice(1, 10, 2)  ; Start, end, step
MsgBox("Slice - Every other element:`n`n"
     . "Original:  [" Join(data) "]`n"
     . "Step of 2: [" Join(everyOther) "]", , "T3")

; ===============================================
; PRACTICAL EXAMPLE: DATA PROCESSING
; ===============================================

; Sample data: sales records
sales := [
    {product: "Widget", price: 25, quantity: 10},
    {product: "Gadget", price: 50, quantity: 5},
    {product: "Doohickey", price: 15, quantity: 20},
    {product: "Thingamajig", price: 75, quantity: 3}
]

; Calculate total revenue per product
revenues := sales.Map((item) => item.price * item.quantity)
revenueList := ""
for i, sale in sales
    revenueList .= sale.product ": $" revenues[i] "`n"

MsgBox("Practical Example - Sales Revenue:`n`n"
     . revenueList, , "T5")

; Filter high-value items (price > $20)
expensive := sales.Filter((item) => item.price > 20)
expensiveList := ""
for item in expensive
    expensiveList .= item.product " ($" item.price ")`n"

MsgBox("Filter - Products over $20:`n`n" expensiveList, , "T4")

; Calculate total revenue (reduce)
totalRevenue := revenues.Reduce((sum, rev) => sum + rev, 0)
MsgBox("Total Revenue: $" totalRevenue, "Sales Summary", "T3")

; ===============================================
; CHAINING OPERATIONS
; ===============================================

; Combine multiple operations
result := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    .Filter((n) => Mod(n, 2) == 0)    ; Keep evens: [2,4,6,8,10]
    .Map((n) => n * n)                 ; Square: [4,16,36,64,100]
    .Reduce((a, b) => a + b, 0)       ; Sum: 220

MsgBox("Chaining Operations:`n`n"
     . "Start: [1,2,3,4,5,6,7,8,9,10]`n"
     . "Filter evens: [2,4,6,8,10]`n"
     . "Square: [4,16,36,64,100]`n"
     . "Sum: " result, , "T5")

/**
 * Helper function to join array elements
 */
Join(arr, sep := ", ") {
    result := ""
    for item in arr
        result .= item sep
    return RTrim(result, sep)
}

/*
 * Key Concepts:
 *
 * 1. Map:
 *    arr.Map(func) - Transform each element
 *    Returns new array
 *    Doesn't modify original
 *
 * 2. Filter:
 *    arr.Filter(func) - Keep matching elements
 *    Predicate function returns true/false
 *    Returns filtered array
 *
 * 3. Reduce:
 *    arr.Reduce(func, initial) - Combine to single value
 *    Accumulator + current element
 *    Useful for sum, product, max, min
 *
 * 4. IndexOf:
 *    arr.IndexOf(value) - Find element position
 *    Returns index or 0 if not found
 *    1-based indexing
 *
 * 5. Find:
 *    arr.Find(predicate, &match) - Find with condition
 *    Returns index, sets match to element
 *    Stops at first match
 *
 * 6. Shuffle:
 *    arr.Shuffle() - Randomize in place
 *    Modifies original array
 *    Fisher-Yates algorithm
 *
 * 7. Flat:
 *    arr.Flat() - Flatten nested arrays
 *    One level of flattening
 *    Returns new array
 *
 * 8. Slice:
 *    arr.Slice(start, end, step)
 *    Extract portion with optional step
 *    Supports negative indices
 *
 * 9. Functional Programming:
 *    Cleaner, more expressive code
 *    Easier to read and maintain
 *    Composable operations
 *
 * 10. Immutability:
 *     Most methods return new arrays
 *     Original array unchanged (except Shuffle)
 *     Safe for concurrent operations
 *
 * 11. Lambda Functions:
 *     () => expression
 *     (param) => expression
 *     (a, b) => expression
 *
 * 12. Common Patterns:
 *     ✅ Data transformation
 *     ✅ Filtering lists
 *     ✅ Aggregation (sum, avg)
 *     ✅ Finding elements
 *     ✅ Sorting and shuffling
 *
 * 13. Performance:
 *     Map/Filter/Reduce are efficient
 *     Chaining creates intermediate arrays
 *     For huge arrays, consider traditional loops
 *
 * 14. Additional Methods:
 *     - Sort() - Custom sorting
 *     - Reverse() - Reverse order
 *     - Unique() - Remove duplicates
 *     - Zip() - Combine arrays
 *     - Partition() - Split by predicate
 */
