#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Prototype Extension - Array Methods
 *
 * Demonstrates extending built-in Array with custom methods.
 * Adds Contains, Sum, First, Last, and Join methods.
 *
 * Source: AHK_Notes/Snippets/extending-builtin-objects.md
 */

; Define Array prototype extensions
Array.Prototype.DefineProp("Contains", {Call: array_contains})
Array.Prototype.DefineProp("Sum", {Call: array_sum})
Array.Prototype.DefineProp("First", {Call: (arr) => arr.Length ? arr[1] : ""})
Array.Prototype.DefineProp("Last", {Call: (arr) => arr.Length ? arr[arr.Length] : ""})
Array.Prototype.DefineProp("Join", {Call: array_join})

; Test array methods
myArray := [1, 2, 3, 4, 5]

MsgBox("Array: [1,2,3,4,5]`n`n"
     . "Contains(3): " myArray.Contains(3) "`n"
     . "Sum(): " myArray.Sum() "`n"
     . "First(): " myArray.First() "`n"
     . "Last(): " myArray.Last() "`n"
     . "Join(' - '): " myArray.Join(" - "), , "T5")

strArray := ["apple", "banana", "CHERRY"]
MsgBox("String array: ['apple', 'banana', 'CHERRY']`n`n"
     . "Contains('cherry', casesense=0): " strArray.Contains("cherry", 0) "`n"
     . "Contains('CHERRY', casesense=1): " strArray.Contains("CHERRY", 1), , "T5")

/**
 * Array.Contains Implementation
 * @param {array} arr - The array
 * @param {any} search - Value to find
 * @param {int} casesense - Case sensitive (0=no, 1=yes)
 * @return {int} Index if found, 0 if not
 */
array_contains(arr, search, casesense := 0) {
    for index, value in arr {
        if !IsSet(value)
            continue
        else if (value == search)  ; Exact match
            return index
        else if (value = search && !casesense)  ; Case-insensitive
            return index
    }
    return 0
}

/**
 * Array.Sum Implementation
 * @return {number} Sum of numeric values
 */
array_sum(arr) {
    total := 0
    for value in arr {
        if IsNumber(value)
            total += value
    }
    return total
}

/**
 * Array.Join Implementation
 * @param {string} delimiter - Separator between elements
 * @return {string} Joined string
 */
array_join(arr, delimiter := ",") {
    result := ""
    for index, value in arr {
        result .= value (index < arr.Length ? delimiter : "")
    }
    return result
}

/*
 * Key Concepts:
 *
 * 1. Prototype Extension:
 *    Array.Prototype.DefineProp("Name", {Call: func})
 *    Available on ALL array instances
 *
 * 2. Method Signature:
 *    func(arr, param1, param2)
 *    First param is always the array instance
 *
 * 3. Benefits:
 *    ✅ Natural syntax: arr.Contains(x)
 *    ✅ Available everywhere
 *    ✅ Chainable with built-in methods
 *
 * 4. Use Cases:
 *    - Add missing functionality
 *    - Domain-specific operations
 *    - Utility methods
 */
