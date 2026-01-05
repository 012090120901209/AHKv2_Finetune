#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

/**
 * Module Tier 3 Example 02: Using the Helpers Bundle
 * 
 * This example demonstrates:
 * - Importing bundle modules
 * - Multiple ways to access bundled functionality
 * - Benefits of module bundles
 * - API convenience patterns
 * 
 * USAGE: Run this file directly
 * 
 * @requires Module_Tier3_01_Helpers_Bundle.ahk
 * @requires Module_Tier2_01_StringHelpers_Module.ahk
 * @requires Module_Tier2_04_ArrayHelpers_Module.ahk
 * @requires Module_Tier1_01_MathHelpers_Module.ahk
 */


Import Helpers

; ============================================================
; Approach 1: Using HelpersReady() Bundle
; ============================================================

H := Helpers.HelpersReady()

; Use bundled helpers with clean syntax
text := "hello world from autohotkey"
formatted := H.String.Title(text)

numbers := [1, 2, 3, 4, 5, 6, 7, 8, 9]
chunks := H.Array.Chunk(numbers, 3)
total := H.Array.Sum(numbers)

MsgBox("Using HelpersReady() Bundle:`n`n"
    . "String: " formatted "`n"
    . "Chunks: " chunks.Length "`n"
    . "Sum: " total "`n`n"
    . "Math 5²: " H.Math.Square(5),
    "Bundle Approach 1", "Icon!")

; ============================================================
; Approach 2: Using QuickHelpers() for Common Operations
; ============================================================

Q := Helpers.QuickHelpers()

; Most common operations in one place
result := ""
result .= "Title: " Q.Title("quick helpers example") "`n"
result .= "Snake: " Q.Snake("Quick Helpers Example") "`n"
result .= "Join: " Q.Join([1, 2, 3], "-") "`n"
result .= "Unique: " Q.Unique([1, 2, 2, 3, 3, 3]).Length " items`n"
result .= "5 × 7 = " Q.Multiply(5, 7)

MsgBox(result, "QuickHelpers Bundle", "Icon!")

; ============================================================
; Approach 3: Direct Sub-module Access
; ============================================================

; Access sub-modules directly through bundle
title := Helpers.StringHelpers.ToTitleCase("direct access")
joined := Helpers.ArrayHelpers.Join([1, 2, 3], ", ")
squared := Helpers.MathHelpers.Square(8)

MsgBox("Direct Sub-module Access:`n`n"
    . "Title: " title "`n"
    . "Joined: " joined "`n"
    . "Squared: " squared,
    "Direct Access", "Icon!")

; ============================================================
; Approach 4: Module Info
; ============================================================

info := Helpers.GetModuleInfo()

infoText := "MODULE INFORMATION`n`n"
infoText .= "Name: " info.name "`n"
infoText .= "Version: " info.version "`n"
infoText .= "Description: " info.description "`n`n"
infoText .= "Sub-modules:`n"

for submodule in info.submodules
    infoText .= "  • " submodule "`n"

MsgBox(infoText, "Module Info", "Icon!")

; ============================================================
; Practical Example: Data Processor using Bundle
; ============================================================

class DataProcessor {
    helpers := ""

    __New() {
        ; Get bundle on initialization
        global Helpers
        this.helpers := Helpers.HelpersReady()
    }

    ProcessData(rawText) {
        ; Clean and split text
        text := this.helpers.String.Clean(rawText)
        words := StrSplit(text, " ")

        ; Array operations
        unique := this.helpers.Array.Unique(words)
        chunks := this.helpers.Array.Chunk(unique, 3)

        ; Format words
        formatted := []
        for word in unique
            formatted.Push(this.helpers.String.Title(word))

        return {
            original: rawText,
            cleaned: text,
            wordCount: words.Length,
            uniqueCount: unique.Length,
            chunks: chunks.Length,
            formatted: this.helpers.Array.Join(formatted, " | ")
        }
    }

    ProcessNumbers(numbers) {
        ; Multiple array/math operations
        unique := this.helpers.Array.Unique(numbers)
        sorted := unique.Clone()  ; TODO: add Sort to helpers

        return {
            count: numbers.Length,
            unique: unique.Length,
            sum: this.helpers.Array.Sum(unique),
            min: this.helpers.Array.Min(unique),
            max: this.helpers.Array.Max(unique),
            first: this.helpers.Array.First(unique),
            last: this.helpers.Array.Last(unique)
        }
    }
}

processor := DataProcessor()

; Process text data
textResult := processor.ProcessData("the quick brown fox jumps over the lazy dog the quick fox")

MsgBox("Text Processing with Bundle:`n`n"
    . "Words: " textResult.wordCount "`n"
    . "Unique: " textResult.uniqueCount "`n"
    . "Chunks: " textResult.chunks "`n`n"
    . "Formatted: " textResult.formatted,
    "Text Processor", "Icon!")

; Process number data
numberResult := processor.ProcessNumbers([5, 2, 8, 2, 9, 1, 8, 5])

MsgBox("Number Processing with Bundle:`n`n"
    . "Total: " numberResult.count "`n"
    . "Unique: " numberResult.unique "`n"
    . "Sum: " numberResult.sum "`n"
    . "Range: " numberResult.min " to " numberResult.max "`n"
    . "First: " numberResult.first ", Last: " numberResult.last,
    "Number Processor", "Icon!")

; ============================================================
; Benefits of Bundle Modules
; ============================================================

benefits := "
(
BUNDLE MODULE BENEFITS:

1. SINGLE IMPORT
✓ Import Helpers
✗ Import StringHelpers, ArrayHelpers, MathHelpers

2. ORGANIZED API
✓ H.String.Title() - Clear categorization
✓ H.Array.Chunk() - Grouped by domain
✓ H.Math.Square() - Intuitive structure

3. EASY DISCOVERY
✓ H. → Shows all categories (String, Array, Math)
✓ H.String. → Shows all string methods
✓ Auto-complete friendly

4. FLEXIBILITY
✓ Use full bundle: HelpersReady()
✓ Use quick access: QuickHelpers()
✓ Use direct: Helpers.StringHelpers.Function()

5. VERSIONING
✓ Bundle version manages all sub-modules
✓ Compatible versions guaranteed
✓ GetModuleInfo() provides metadata

6. MAINTAINABILITY
✓ Add new helpers to bundle easily
✓ Deprecate old ones gracefully
✓ Central documentation point

WHEN TO CREATE BUNDLES:

→ Related functionality across modules
→ Common usage patterns
→ Want to provide unified API
→ Multiple small modules that go together
→ Building a library/framework
)"

MsgBox(benefits, "Bundle Module Benefits", "Icon!")

; ============================================================
; Comparison: Bundle vs Individual Imports
; ============================================================

comparisonCode := '
(
; WITHOUT BUNDLE (verbose)
Import StringHelpers
Import ArrayHelpers
Import MathHelpers

result := StringHelpers.ToTitleCase("text")
chunks := ArrayHelpers.Chunk([1,2,3], 2)
squared := MathHelpers.Square(5)

---

; WITH BUNDLE (concise)
Import Helpers
H := Helpers.HelpersReady()

result := H.String.Title("text")
chunks := H.Array.Chunk([1,2,3], 2)
squared := H.Math.Square(5)

---

; BENEFIT:
- 1 import instead of 3
- Organized namespaces
- Clearer categorization
- Easier to use
)'

MsgBox(comparisonCode, "Bundle vs Individual", "Icon!")
