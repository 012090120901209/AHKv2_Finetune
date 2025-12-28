#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * 50 Short Examples - Descolada's Basic Libraries
 * 
 * Array, String, Map, and Misc utilities
 * Library: https://github.com/Descolada/AHK-v2-libraries
 * 
 * To use these libraries:
 * #Include <Array>
 * #Include <String>
 * #Include <Map>
 * #Include <Misc>
 */

; ═══════════════════════════════════════════════════════════════════════════
; ARRAY EXAMPLES (1-20)
; ═══════════════════════════════════════════════════════════════════════════

/**
 * Example 1: Array.Slice() - Get portion of array
 */
Example1() {
    arr := [10, 20, 30, 40, 50]
    sliced := arr.Slice(2, 4)  ; Get elements 2 through 4
    MsgBox("Original: " ArrayToString(arr) "`nSliced (2-4): " ArrayToString(sliced))
}

/**
 * Example 2: Array.Swap() - Swap two elements
 */
Example2() {
    arr := ["A", "B", "C", "D"]
    arr.Swap(1, 4)  ; Swap first and last
    MsgBox("After swapping 1st and 4th: " ArrayToString(arr))
}

/**
 * Example 3: Array.Map() - Transform each element
 */
Example3() {
    numbers := [1, 2, 3, 4, 5]
    squared := numbers.Map((x) => x * x)
    MsgBox("Original: " ArrayToString(numbers) "`nSquared: " ArrayToString(squared))
}

/**
 * Example 4: Array.Filter() - Keep only matching elements
 */
Example4() {
    numbers := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    evens := numbers.Filter((x) => Mod(x, 2) = 0)
    MsgBox("All numbers: " ArrayToString(numbers) "`nEven numbers: " ArrayToString(evens))
}

/**
 * Example 5: Array.Reduce() - Combine all elements
 */
Example5() {
    numbers := [1, 2, 3, 4, 5]
    sum := numbers.Reduce((a, b) => a + b)
    product := numbers.Reduce((a, b) => a * b)
    MsgBox("Numbers: " ArrayToString(numbers) "`nSum: " sum "`nProduct: " product)
}

/**
 * Example 6: Array.IndexOf() - Find element position
 */
Example6() {
    fruits := ["apple", "banana", "orange", "banana", "grape"]
    index := fruits.IndexOf("banana")
    MsgBox("Fruits: " ArrayToString(fruits) "`n'banana' found at index: " index)
}

/**
 * Example 7: Array.Find() - Find with condition
 */
Example7() {
    numbers := [5, 12, 8, 130, 44]
    index := numbers.Find((x) => x > 10, &match)
    MsgBox("First number > 10: " match " at index " index)
}

/**
 * Example 8: Array.Reverse() - Reverse array
 */
Example8() {
    arr := [1, 2, 3, 4, 5]
    arr.Reverse()
    MsgBox("Reversed: " ArrayToString(arr))
}

/**
 * Example 9: Array.Count() - Count occurrences
 */
Example9() {
    arr := ["red", "blue", "red", "green", "red"]
    count := arr.Count("red")
    MsgBox("Array: " ArrayToString(arr) "`nCount of 'red': " count)
}

/**
 * Example 10: Array.Sort() - Sort array
 */
Example10() {
    arr := [5, 2, 8, 1, 9]
    arr.Sort()
    MsgBox("Sorted: " ArrayToString(arr))
}

/**
 * Example 11: Array.Shuffle() - Randomize array
 */
Example11() {
    arr := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    arr.Shuffle()
    MsgBox("Shuffled: " ArrayToString(arr))
}

/**
 * Example 12: Array.Unique() - Remove duplicates
 */
Example12() {
    arr := [1, 2, 2, 3, 3, 3, 4, 5, 5]
    unique := arr.Unique()
    MsgBox("Original: " ArrayToString(arr) "`nUnique: " ArrayToString(unique))
}

/**
 * Example 13: Array.Join() - Join to string
 */
Example13() {
    words := ["Hello", "World", "from", "AHK"]
    sentence := words.Join(" ")
    csv := words.Join(", ")
    MsgBox("Words: " ArrayToString(words) "`nSentence: " sentence "`nCSV: " csv)
}

/**
 * Example 14: Array.Flat() - Flatten nested array
 */
Example14() {
    nested := [1, [2, 3], [4, [5, 6]]]
    flat := nested.Flat()
    MsgBox("Nested: " ArrayToString(nested) "`nFlattened: " ArrayToString(flat))
}

/**
 * Example 15: Array.Extend() - Combine arrays
 */
Example15() {
    arr1 := [1, 2, 3]
    arr2 := [4, 5]
    arr3 := [6, 7, 8]
    arr1.Extend(arr2, arr3)
    MsgBox("Extended array: " ArrayToString(arr1))
}

/**
 * Example 16: Array.ForEach() - Execute on each element
 */
Example16() {
    numbers := [1, 2, 3, 4, 5]
    output := ""
    numbers.ForEach((v, i) => output .= "Index " i ": " v "`n")
    MsgBox("ForEach output:`n" output)
}

/**
 * Example 17: Chain Array methods
 */
Example17() {
    result := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        .Filter((x) => x > 5)
        .Map((x) => x * 2)
    MsgBox("Numbers > 5, doubled: " ArrayToString(result))
}

/**
 * Example 18: Array with objects - Sort by property
 */
Example18() {
    people := [{
        name: "Alice", age: 30 }, {
            name: "Bob", age: 25 }, {
                name: "Charlie", age: 35
            }
    ]
    people.Sort((a, b) => a.age - b.age)
    output := ""
    for person in people
        output .= person.name " (" person.age ")`n"
    MsgBox("Sorted by age:`n" output)
}

/**
 * Example 19: Get min and max with Reduce
 */
Example19() {
    numbers := [23, 5, 67, 12, 89, 34]
    min := numbers.Reduce((a, b) => a < b ? a : b)
    max := numbers.Reduce((a, b) => a > b ? a : b)
    MsgBox("Numbers: " ArrayToString(numbers) "`nMin: " min "`nMax: " max)
}

/**
 * Example 20: Array slicing with step
 */
Example20() {
    arr := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    everyOther := arr.Slice(1, 10, 2)  ; Every other element
    MsgBox("Original: " ArrayToString(arr) "`nEvery other: " ArrayToString(everyOther))
}

; ═══════════════════════════════════════════════════════════════════════════
; STRING EXAMPLES (21-35)
; ═══════════════════════════════════════════════════════════════════════════

/**
 * Example 21: String.ToUpper/ToLower/ToTitle
 */
Example21() {
    text := "hello world"
    MsgBox("Original: " text "`nUpper: " text.ToUpper() "`nLower: " text.ToLower() "`nTitle: " text.ToTitle())
}

/**
 * Example 22: String.Split() - Split into array
 */
Example22() {
    text := "apple,banana,orange,grape"
    parts := text.Split(",")
    MsgBox("Original: " text "`nParts: " ArrayToString(parts))
}

/**
 * Example 23: String.Replace() - Replace text
 */
Example23() {
    text := "The quick brown fox"
    replaced := text.Replace("fox", "dog")
    MsgBox("Original: " text "`nReplaced: " replaced)
}

/**
 * Example 24: String.Trim() - Remove whitespace
 */
Example24() {
    text := "   Hello World   "
    MsgBox("Original: '" text "'`nTrimmed: '" text.Trim() "'`nLTrim: '" text.LTrim() "'`nRTrim: '" text.RTrim() "'")
}

/**
 * Example 25: String.Contains() - Check if contains
 */
Example25() {
    email := "user@example.com"
    hasAt := email.Contains("@")
    hasDomain := email.Contains(".com")
    MsgBox("Email: " email "`nContains @: " hasAt "`nContains .com: " hasDomain)
}

/**
 * Example 26: String.Count() - Count occurrences
 */
Example26() {
    text := "Mississippi"
    count := text.Count("s")
    countI := text.Count("i")
    MsgBox("Text: " text "`nCount 's': " count "`nCount 'i': " countI)
}

/**
 * Example 27: String.Reverse() - Reverse string
 */
Example27() {
    text := "Hello"
    reversed := text.Reverse()
    MsgBox("Original: " text "`nReversed: " reversed)
}

/**
 * Example 28: String.Repeat() - Repeat string
 */
Example28() {
    text := "Ha"
    repeated := text.Repeat(5)
    MsgBox("Repeat 'Ha' 5 times: " repeated)
}

/**
 * Example 29: String[n] - Access characters
 */
Example29() {
    text := "Hello"
    MsgBox("Text: " text "`nFirst char: " text[1] "`nLast char: " text[text.Length])
}

/**
 * Example 30: String[i,j] - Substring
 */
Example30() {
    text := "Hello World"
    sub := text[7, 11]  ; Characters 7 through 11
    MsgBox("Text: " text "`nSubstring [7,11]: " sub)
}

/**
 * Example 31: String.Insert() - Insert text
 */
Example31() {
    text := "Hello World"
    inserted := text.Insert(" Beautiful", 6)
    MsgBox("Original: " text "`nInserted: " inserted)
}

/**
 * Example 32: String.Find() - Find position
 */
Example32() {
    text := "The quick brown fox"
    pos := text.Find("brown")
    MsgBox("Text: " text "`n'brown' found at position: " pos)
}

/**
 * Example 33: String.RegExMatch() - Regex matching
 */
Example33() {
    email := "contact@example.com"
    if email.RegExMatch("(\w+)@(\w+\.\w+)", &match)
        MsgBox("Email: " email "`nUsername: " match[1] "`nDomain: " match[2])
}

/**
 * Example 34: String properties - IsDigit, IsAlpha, etc.
 */
Example34() {
    MsgBox("'123' IsDigit: " "123".IsDigit
        . "`n'ABC' IsAlpha: " "ABC".IsAlpha
        . "`n'ABC' IsUpper: " "ABC".IsUpper
        . "`n'abc' IsLower: " "abc".IsLower)
}

/**
 * Example 35: Delimeter.Concat() - Join with delimiter
 */
Example35() {
    sentence := ", ".Concat("apples", "bananas", "oranges")
    path := "\".Concat("C:", "Users", "Documents")
    MsgBox("Comma list: " sentence "`nPath: " path)
}

; ═══════════════════════════════════════════════════════════════════════════
; MAP EXAMPLES (36-43)
; ═══════════════════════════════════════════════════════════════════════════

/**
 * Example 36: Map.Keys and Map.Values
 */
Example36() {
    data := Map("name", "Alice", "age", 30, "city", "NYC")
    keys := data.Keys
    values := data.Values
    MsgBox("Keys: " ArrayToString(keys) "`nValues: " ArrayToString(values))
}

/**
 * Example 37: Map.Map() - Transform values
 */
Example37() {
    prices := Map("apple", 1.0, "banana", 0.5, "orange", 0.75)
    prices.Map((k, v) => v * 1.1)  ; Increase by 10%
    output := ""
    for key, value in prices
        output .= key ": $" Round(value, 2) "`n"
    MsgBox("Prices after 10% increase:`n" output)
}

/**
 * Example 38: Map.Filter() - Keep matching pairs
 */
Example38() {
    scores := Map("Alice", 85, "Bob", 92, "Charlie", 78, "Diana", 95)
    highScores := scores.Filter((k, v) => v >= 90)
    output := ""
    for name, score in highScores
        output .= name ": " score "`n"
    MsgBox("Scores >= 90:`n" output)
}

/**
 * Example 39: Map.ForEach() - Execute on each pair
 */
Example39() {
    inventory := Map("apples", 10, "bananas", 5, "oranges", 8)
    output := ""
    inventory.ForEach((value, key) => output .= key ": " value " units`n")
    MsgBox("Inventory:`n" output)
}

/**
 * Example 40: Map.Count() - Count value occurrences
 */
Example40() {
    votes := Map("Alice", "Red", "Bob", "Blue", "Charlie", "Red", "Diana", "Red")
    redCount := votes.Count("Red")
    MsgBox("Vote count for Red: " redCount)
}

/**
 * Example 41: Map.Merge() - Combine maps
 */
Example41() {
    map1 := Map("a", 1, "b", 2)
    map2 := Map("c", 3, "d", 4)
    map1.Merge(map2)
    output := ""
    for key, value in map1
        output .= key ": " value "`n"
    MsgBox("Merged map:`n" output)
}

/**
 * Example 42: Map.Reduce() - Combine all values
 */
Example42() {
    expenses := Map("food", 50, "transport", 30, "entertainment", 20)
    total := expenses.Reduce((acc, val) => acc + val, 0)
    MsgBox("Total expenses: $" total)
}

/**
 * Example 43: Map.Find() - Find matching value
 */
Example43() {
    users := Map(1, "Alice", 2, "Bob", 3, "Charlie")
    key := users.Find((k, v) => v = "Bob", &match)
    MsgBox("Found 'Bob' at key: " key "`nValue: " match)
}

; ═══════════════════════════════════════════════════════════════════════════
; MISC UTILITIES (44-50)
; ═══════════════════════════════════════════════════════════════════════════

/**
 * Example 44: Range() - Generate number sequence
 */
Example44() {
    output := ""
    for n in Range(5)
        output .= n " "
    MsgBox("Range(5): " output)
}

/**
 * Example 45: Range with start and end
 */
Example45() {
    output := ""
    for n in Range(10, 15)
        output .= n " "
    MsgBox("Range(10, 15): " output)
}

/**
 * Example 46: Range with step
 */
Example46() {
    output := ""
    for n in Range(0, 20, 5)
        output .= n " "
    MsgBox("Range(0, 20, 5): " output)
}

/**
 * Example 47: Range.ToArray()
 */
Example47() {
    arr := Range(1, 10, 2).ToArray()
    MsgBox("Range(1, 10, 2) as array: " ArrayToString(arr))
}

/**
 * Example 48: Swap() - Swap variables
 */
Example48() {
    a := 10
    b := 20
    Swap(&a, &b)
    MsgBox("After swap: a = " a ", b = " b)
}

/**
 * Example 49: Combine Range with Array methods
 */
Example49() {
    sum := Range(1, 100).ToArray().Reduce((a, b) => a + b)
    MsgBox("Sum of 1 to 100: " sum)
}

/**
 * Example 50: Complex data transformation pipeline
 */
Example50() {
    ; Get even squares of numbers 1-10
    result := Range(1, 10).ToArray()
        .Filter((x) => Mod(x, 2) = 0)
        .Map((x) => x * x)

    MsgBox("Even numbers (1-10) squared: " ArrayToString(result))
}

; ═══════════════════════════════════════════════════════════════════════════
; HELPER FUNCTIONS
; ═══════════════════════════════════════════════════════════════════════════

ArrayToString(arr) {
    if arr.Length = 0
        return "[]"
    str := "["
    for value in arr
        str .= (Type(value) = "String" ? '"' value '"' : value) ", "
    return RTrim(str, ", ") "]"
}

; ═══════════════════════════════════════════════════════════════════════════
; MENU
; ═══════════════════════════════════════════════════════════════════════════

MsgBox("50 Descolada Library Examples Loaded!`n`n"
    . "ARRAY (1-20):`n"
    . "1. Slice   2. Swap   3. Map   4. Filter   5. Reduce`n"
    . "6. IndexOf   7. Find   8. Reverse   9. Count   10. Sort`n"
    . "11. Shuffle   12. Unique   13. Join   14. Flat   15. Extend`n"
    . "16. ForEach   17. Chain   18. Sort Objects   19. Min/Max   20. Step Slice`n`n"
    . "STRING (21-35):`n"
    . "21. Case   22. Split   23. Replace   24. Trim   25. Contains`n"
    . "26. Count   27. Reverse   28. Repeat   29. Index   30. Substring`n"
    . "31. Insert   32. Find   33. RegEx   34. Properties   35. Concat`n`n"
    . "MAP (36-43):`n"
    . "36. Keys/Values   37. Map   38. Filter   39. ForEach   40. Count`n"
    . "41. Merge   42. Reduce   43. Find`n`n"
    . "MISC (44-50):`n"
    . "44. Range   45. Range(start,end)   46. Range(step)   47. ToArray`n"
    . "48. Swap   49. Combine   50. Pipeline`n`n"
    . "Call any Example1() through Example50() to run!")

; Uncomment to run examples:
; Example1()
; Example3()
; Example5()
; Example17()
; Example21()
; Example50()

