#Requires AutoHotkey v2.0

/**
* ============================================================================
* Array.RemoveAt() - Data Cleanup Operations
* ============================================================================
*
* Demonstrates using RemoveAt() for data cleanup, validation, and
* sanitization tasks. Essential for maintaining data quality.
*
* @description Data cleanup techniques using Array.RemoveAt()
* @author AutoHotkey v2 Documentation
* @version 1.0.0
* @date 2025-01-16
*/

; Example 1: Remove Empty Values
Example1_RemoveEmpties() {
    OutputDebug("=== Example 1: Remove Empty Values ===`n")

    data := ["Hello", "", "World", "", "", "Test", ""]
    OutputDebug("Initial (" data.Length " items): " FormatArray(data) "`n")

    index := data.Length
    removedCount := 0
    while (index >= 1) {
        if (data[index] = "") {
            data.RemoveAt(index)
            removedCount++
        }
        index--
    }

    OutputDebug("Removed " removedCount " empty values`n")
    OutputDebug("Result: " FormatArray(data) "`n`n")
}

; Example 2: Remove Null/Undefined Values
Example2_RemoveNulls() {
    OutputDebug("=== Example 2: Remove Null/Undefined Values ===`n")

    values := [1, unset, 3, "", unset, 5]

    OutputDebug("Initial array with " values.Length " slots`n")

    index := values.Length
    while (index >= 1) {
        try {
            value := values[index]
            if (value = "") {
                values.RemoveAt(index)
                OutputDebug("  Removed empty at index " index "`n")
            }
        } catch {
            values.RemoveAt(index)
            OutputDebug("  Removed unset at index " index "`n")
        }
        index--
    }

    OutputDebug("Cleaned array: " FormatArray(values) "`n`n")
}

; Example 3: Remove Invalid Email Addresses
Example3_RemoveInvalidEmails() {
    OutputDebug("=== Example 3: Remove Invalid Emails ===`n")

    emails := [
    "user@example.com",
    "invalid-email",
    "another@test.com",
    "bad@",
    "@missinguser.com",
    "good@domain.org"
    ]

    OutputDebug("Email list (" emails.Length " emails):`n")
    for email in emails
    OutputDebug("  " email "`n")

    OutputDebug("`nRemoving invalid emails:`n")
    index := emails.Length
    while (index >= 1) {
        if (!IsValidEmail(emails[index])) {
            removed := emails.RemoveAt(index)
            OutputDebug("  Removed: " removed "`n")
        }
        index--
    }

    OutputDebug("`nValid emails remaining: " emails.Length "`n`n")
}

; Example 4: Remove Duplicates
Example4_RemoveDuplicates() {
    OutputDebug("=== Example 4: Remove Duplicates ===`n")

    items := ["Apple", "Banana", "Apple", "Cherry", "Banana", "Date", "Apple"]
    OutputDebug("Original: " FormatArray(items) "`n")

    seen := Map()
    index := items.Length
    duplicatesRemoved := 0

    while (index >= 1) {
        item := items[index]
        if (seen.Has(item)) {
            items.RemoveAt(index)
            duplicatesRemoved++
        } else {
            seen[item] := true
        }
        index--
    }

    OutputDebug("Removed " duplicatesRemoved " duplicates`n")
    OutputDebug("Unique items: " FormatArray(items) "`n`n")
}

; Example 5: Remove Whitespace-Only Strings
Example5_RemoveWhitespace() {
    OutputDebug("=== Example 5: Remove Whitespace-Only Strings ===`n")

    lines := ["Hello", "   ", "World", "`t`t", "", "Test", "  `n  ", "Data"]
    OutputDebug("Initial lines: " lines.Length "`n")

    index := lines.Length
    while (index >= 1) {
        trimmed := Trim(lines[index])
        if (trimmed = "") {
            lines.RemoveAt(index)
            OutputDebug("  Removed whitespace-only at index " index "`n")
        }
        index--
    }

    OutputDebug("Lines with content: " lines.Length "`n")
    OutputDebug("Result: " FormatArray(lines) "`n`n")
}

; Example 6: Remove Expired Items
Example6_RemoveExpired() {
    OutputDebug("=== Example 6: Remove Expired Items ===`n")

    currentTime := A_TickCount
    items := [
    {
        name: "Item1", expiry: currentTime - 1000},
        {
            name: "Item2", expiry: currentTime + 5000},
            {
                name: "Item3", expiry: currentTime - 500},
                {
                    name: "Item4", expiry: currentTime + 10000},
                    {
                        name: "Item5", expiry: currentTime - 2000
                    }
                    ]

                    OutputDebug("Total items: " items.Length "`n")
                    OutputDebug("Removing expired items:`n")

                    index := items.Length
                    while (index >= 1) {
                        if (items[index].expiry < currentTime) {
                            removed := items.RemoveAt(index)
                            OutputDebug("  Expired: " removed.name "`n")
                        }
                        index--
                    }

                    OutputDebug("Valid items remaining: " items.Length "`n`n")
                }

                ; Example 7: Comprehensive Data Sanitization
                Example7_DataSanitization() {
                    OutputDebug("=== Example 7: Comprehensive Data Sanitization ===`n")

                    rawData := [
                    {
                        id: 1, name: "Alice", email: "alice@test.com", age: 25},
                        {
                            id: 2, name: "", email: "invalid", age: -5},
                            {
                                id: 3, name: "Bob", email: "bob@example.com", age: 30},
                                {
                                    id: 4, name: "  ", email: "charlie@test.com", age: 0},
                                    {
                                        id: 5, name: "David", email: "david@domain.org", age: 150
                                    }
                                    ]

                                    OutputDebug("Raw data entries: " rawData.Length "`n")
                                    OutputDebug("Applying validation rules:`n")

                                    index := rawData.Length
                                    invalidCount := 0

                                    while (index >= 1) {
                                        record := rawData[index]
                                        isValid := true
                                        reason := ""

                                        ; Validation rules
                                        if (Trim(record.name) = "") {
                                            isValid := false
                                            reason := "empty name"
                                        } else if (!IsValidEmail(record.email)) {
                                            isValid := false
                                            reason := "invalid email"
                                        } else if (record.age < 1 || record.age > 120) {
                                            isValid := false
                                            reason := "invalid age"
                                        }

                                        if (!isValid) {
                                            rawData.RemoveAt(index)
                                            invalidCount++
                                            OutputDebug("  Removed ID " record.id ": " reason "`n")
                                        }

                                        index--
                                    }

                                    OutputDebug("`nRemoved " invalidCount " invalid records`n")
                                    OutputDebug("Valid records: " rawData.Length "`n")

                                    OutputDebug("Valid entries:`n")
                                    for record in rawData
                                    OutputDebug("  " record.name " - " record.email " (Age: " record.age ")`n")

                                    OutputDebug("`n")
                                }

                                ; Helper Functions
                                IsValidEmail(email) {
                                    return RegExMatch(email, "^[\w\.-]+@[\w\.-]+\.\w+$")
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
                                    OutputDebug("Array.RemoveAt() - Data Cleanup Examples`n")
                                    OutputDebug(String.Repeat("=", 80) "`n`n")

                                    Example1_RemoveEmpties()
                                    Example2_RemoveNulls()
                                    Example3_RemoveInvalidEmails()
                                    Example4_RemoveDuplicates()
                                    Example5_RemoveWhitespace()
                                    Example6_RemoveExpired()
                                    Example7_DataSanitization()

                                    OutputDebug(String.Repeat("=", 80) "`n")
                                    OutputDebug("All examples completed!`n")
                                    OutputDebug(String.Repeat("=", 80) "`n")

                                    MsgBox("Array.RemoveAt() cleanup examples completed!`nCheck DebugView for output.",
                                    "Examples Complete", "Icon!")
                                }

                                Main()
