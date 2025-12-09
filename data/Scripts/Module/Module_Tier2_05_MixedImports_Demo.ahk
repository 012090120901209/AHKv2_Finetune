#Requires AutoHotkey v2.1-alpha.17

/**
* Module Tier 2 Example 05: Mixed Imports Demo
*
* This example demonstrates:
* - Using both module namespace AND selective imports
* - When to use each approach
* - Calling setup functions
* - Combining import strategies
*
* USAGE: Run this file directly
*
* @requires Module_Tier2_01_StringHelpers_Module.ahk
* @requires Module_Tier2_04_ArrayHelpers_Module.ahk
*/

#SingleInstance Force

; ============================================================
; Mixed Import Strategy
; ============================================================

; Import entire StringHelpers module (many functions, namespace is clear)
Import StringHelpers

; Import specific ArrayHelpers functions (only need a few)
Import {
    Join as JoinArray,
    Chunk,
    Unique,
    Flatten
} from ArrayHelpers

; Initialize ArrayHelpers (important for prototype extensions!)
ArrayHelpers.EnsureArrayHelpers()

; ============================================================
; Example 1: Using Both Approaches
; ============================================================

; Use StringHelpers with namespace (clear origin)
text := "  hello   world   from   autohotkey  "
cleaned := StringHelpers.CollapseWhitespace(text)
title := StringHelpers.ToTitleCase(cleaned)

MsgBox("String Operations (namespace):`n`n"
. "Original: '" text "'`n"
. "Cleaned: '" cleaned "'`n"
. "Title: '" title "'",
"StringHelpers Namespace", "Icon!")

; Use ArrayHelpers without namespace (selective import)
numbers := [1, 2, 3, 4, 5, 6, 7, 8, 9]
chunks := Chunk(numbers, 3)

chunksText := "Chunks:`n"
for chunkIndex, chunk in chunks
chunksText .= "Chunk " chunkIndex ": " JoinArray(chunk, ", ") "`n"

MsgBox(chunksText, "ArrayHelpers Direct", "Icon!")

; ============================================================
; Example 2: When to Use Each Approach
; ============================================================

useNamespace := "
(
Use MODULE NAMESPACE when:

✓ Using many functions from module
StringHelpers.ToTitleCase(...)
StringHelpers.ToSnakeCase(...)
StringHelpers.CollapseWhitespace(...)
→ Namespace makes origin clear

✓ Function names might conflict
StringHelpers.Join()  vs  ArrayHelpers.Join()
→ Namespace prevents confusion

✓ Module is well-known
Math.Add(), Math.Multiply()
→ Clear and expected pattern
)"

useSelective := "
(
Use SELECTIVE IMPORTS when:

✓ Only need 1-3 functions
Import { Chunk, Unique } from ArrayHelpers
→ Cleaner, more focused

✓ Function names are unique/clear
Import { Truncate } from StringHelpers
→ No ambiguity

✓ Want shorter syntax
Chunk(arr, 3)  vs  ArrayHelpers.Chunk(arr, 3)
→ Less typing, clearer code
)"

MsgBox(useNamespace "`n`n" useSelective, "When to Use Each", "Icon!")

; ============================================================
; Example 3: Practical Use Case - Data Processing
; ============================================================

class DataProcessor {
    ProcessUsers(rawData) {
        ; Using StringHelpers with namespace
        lines := StrSplit(rawData, "`n", "`r")

        users := []

        for line in lines {
            line := StringHelpers.CollapseWhitespace(line)
            if line = ""
            continue

            parts := StrSplit(line, ",")
            if parts.Length < 3
            continue

            user := {
                name: StringHelpers.ToTitleCase(parts[1]),
                email: StrLower(parts[2]),
                role: StringHelpers.ToCamelCase(parts[3])
            }

            users.Push(user)
        }

        return users
    }

    ProcessNumbers(data) {
        ; Using ArrayHelpers selective imports
        flat := Flatten(data)    ; Flatten nested arrays
        unique := Unique(flat)   ; Remove duplicates

        return {
            chunks: Chunk(unique, 5),
            summary: JoinArray(unique, ", ")
        }
    }
}

processor := DataProcessor()

; Process user data
rawUserData := "
(
john doe, john@email.com, site admin
jane smith, jane@email.com, content editor
bob jones, bob@email.com, user manager
)"

users := processor.ProcessUsers(rawUserData)

userOutput := "Processed Users:`n`n"
for user in users {
    userOutput .= "Name:  " user.name "`n"
    userOutput .= "Email: " user.email "`n"
    userOutput .= "Role:  " user.role "`n`n"
}

MsgBox(userOutput, "User Data Processing", "Icon!")

; Process number data
rawNumbers := [
[1, 2, 3],
[4, 5],
[6, 7, 8, 9],
[1, 2]  ; duplicates
]

numberResult := processor.ProcessNumbers(rawNumbers)

MsgBox("Number Processing:`n`n"
. "Summary: " numberResult.summary "`n`n"
. "Chunks: " numberResult.chunks.Length,
"Number Data Processing", "Icon!")

; ============================================================
; Example 4: Using Prototype Extensions
; ============================================================

; Thanks to ArrayHelpers.EnsureArrayHelpers(), we have prototype methods!

data := ["apple", "banana", "cherry", "date"]

; Use Map (added by ArrayHelpers setup)
uppercased := data.Map((item, index) => StringHelpers.ToUpper(item))

; Use Filter (added by ArrayHelpers setup)
filtered := data.Filter((item, index) => StrLen(item) > 5)

; Use ForEach (added by ArrayHelpers setup)
output := "Items:`n"
data.ForEach((item, index) => {
    global output
    output .= index ". " item "`n"
})

MsgBox(output "`n"
. "Uppercased: " uppercased.Join(", ") "`n"
. "Long items: " filtered.Join(", "),
"Prototype Methods", "Icon!")

; ============================================================
; Example 5: Combining Both for Complex Operations
; ============================================================

class TextAnalyzer {
    AnalyzeText(text) {
        ; Use StringHelpers extensively (namespace)
        text := StringHelpers.CollapseWhitespace(text)
        words := StrSplit(text, " ")

        ; Use ArrayHelpers selectively
        uniqueWords := Unique(words)

        ; Combine both
        analysis := {
            original: text,
            wordCount: words.Length,
            uniqueCount: uniqueWords.Length,
            title: StringHelpers.ToTitleCase(text),
            snake: StringHelpers.ToSnakeCase(text),
            chunks: Chunk(words, 3)
        }

        return analysis
    }

    FormatAnalysis(analysis) {
        report := ""
        report .= "TEXT ANALYSIS`n"
        report .= StringHelpers.Repeat("=", 40) "`n`n"

        report .= "Original: " StringHelpers.Truncate(analysis.original, 40) "`n"
        report .= "Words: " analysis.wordCount "`n"
        report .= "Unique: " analysis.uniqueCount "`n`n"

        report .= "Formats:`n"
        report .= "  Title: " analysis.title "`n"
        report .= "  Snake: " analysis.snake "`n`n"

        report .= "Word Chunks:`n"
        for chunkIndex, chunk in analysis.chunks
        report .= "  " chunkIndex ": " JoinArray(chunk, " ") "`n"

        return report
    }
}

analyzer := TextAnalyzer()

sampleText := "the quick brown fox jumps over the lazy dog the fox is quick"
analysis := analyzer.AnalyzeText(sampleText)
report := analyzer.FormatAnalysis(analysis)

MsgBox(report, "Complex Text Analysis", "Icon!")

; ============================================================
; Summary
; ============================================================

summary := "
(
MIXED IMPORT STRATEGY:

In this script we used:

✓ Import StringHelpers
→ Namespace for many functions
→ Clear origin: StringHelpers.ToTitleCase()

✓ Import { Join, Chunk, Unique, Flatten } from ArrayHelpers
→ Selective for only needed functions
→ Direct use: Chunk(), Unique()

BENEFITS:

1. Clarity
- StringHelpers prefix shows string operations
- Direct function calls for simple array ops

2. Flexibility
- Choose right import style for each module
- Not locked into one approach

3. Maintainability
- Easy to see what's from where
- Can switch strategies later

4. Performance
- Import only what you need
- But use namespaces when needed

BEST PRACTICE:
Use the import style that makes your code
most readable and maintainable for YOUR context.
)"

MsgBox(summary, "Mixed Imports Summary", "Icon!")
