#Requires AutoHotkey v2.1-alpha.17
/**
 * Module Tier 2 Example 02: Selective Imports Demo
 *
 * This example demonstrates:
 * - Importing only specific functions from a module
 * - Benefits of selective imports (cleaner code)
 * - Direct function calls without namespace
 * - Choosing only needed functionality
 *
 * USAGE: Run this file directly
 *
 * @requires Module_Tier2_01_StringHelpers_Module.ahk
 */

#SingleInstance Force

; ============================================================
; Selective Import Syntax
; ============================================================

; Import ONLY the functions we need
Import { ToTitleCase, ToSnakeCase, ToCamelCase } from StringHelpers

; ============================================================
; Example 1: Direct Usage (No Namespace Needed)
; ============================================================

input := "hello world from autohotkey"

; Use functions directly - no "StringHelpers." prefix needed!
title := ToTitleCase(input)
snake := ToSnakeCase(input)
camel := ToCamelCase(input)

MsgBox("Input: " input "`n`n"
     . "Title Case: " title "`n"
     . "snake_case: " snake "`n"
     . "camelCase: " camel,
     "Selective Imports - Direct Usage", "Icon!")

; ============================================================
; Example 2: Import Only What You Need
; ============================================================

; Let's say we only need case conversion functions
; We don't need Truncate, Reverse, PadLeft, etc.
; Selective imports keep our code clean!

processText(text) {
    ; All three functions imported, ready to use
    return {
        title: ToTitleCase(text),
        snake: ToSnakeCase(text),
        camel: ToCamelCase(text)
    }
}

result := processText("make this beautiful")

MsgBox("Processed Text:`n`n"
     . "Title: " result.title "`n"
     . "Snake: " result.snake "`n"
     . "Camel: " result.camel,
     "Function Usage", "Icon!")

; ============================================================
; Example 3: Multiple Conversions
; ============================================================

testCases := [
    "hello world",
    "AutoHotkey is awesome",
    "module system rocks",
    "selective imports rule"
]

output := "Case Conversions:`n`n"

for text in testCases {
    output .= "Input: " text "`n"
    output .= "→ Title: " ToTitleCase(text) "`n"
    output .= "→ Snake: " ToSnakeCase(text) "`n"
    output .= "→ Camel: " ToCamelCase(text) "`n`n"
}

MsgBox(output, "Batch Processing", "Icon!")

; ============================================================
; Example 4: Practical Use Case - Code Generator
; ============================================================

class CodeGenerator {
    GenerateVariable(name, value) {
        ; Convert name to camelCase for variable
        varName := ToCamelCase(name)
        return varName " := " value
    }

    GenerateFunction(name) {
        ; Convert name to PascalCase... wait, we didn't import it!
        ; We can only use: ToTitleCase, ToSnakeCase, ToCamelCase

        ; Let's use ToCamelCase and capitalize first letter manually
        funcName := ToTitleCase(name)  ; Convert to title case
        funcName := StrReplace(funcName, " ", "")  ; Remove spaces
        return funcName "() {`n    ; Implementation`n}"
    }

    GenerateConstant(name, value) {
        ; Use SCREAMING_SNAKE_CASE... but we didn't import it!
        ; Let's use ToSnakeCase and convert to upper
        constName := ToSnakeCase(name)
        constName := StrUpper(constName)
        return constName " := " value
    }
}

gen := CodeGenerator()

code := ""
code .= gen.GenerateVariable("user name", '"John"') "`n"
code .= gen.GenerateVariable("user age", "30") "`n`n"
code .= gen.GenerateFunction("get user info") "`n`n"
code .= gen.GenerateConstant("max retry count", "3") "`n"

MsgBox(code, "Code Generator Example", "Icon!")

; ============================================================
; Example 5: Benefits of Selective Imports
; ============================================================

benefitsText := "
(
Benefits of Selective Imports:

✓ Cleaner Code
  - No namespace prefix needed
  - Functions look like native functions

✓ Explicit Dependencies
  - Clear what functions are used
  - Easy to see module dependencies

✓ Smaller Footprint
  - Import only what you need
  - Clearer intent

✓ No Name Pollution
  - Only imported functions in scope
  - Reduces chance of conflicts

In this script, we imported:
  - ToTitleCase
  - ToSnakeCase
  - ToCamelCase

We did NOT import:
  - Truncate, Reverse, PadLeft
  - Capitalize, WordCount
  - StartsWith, EndsWith
  - And 15+ other functions

This keeps our code focused!
)"

MsgBox(benefitsText, "Selective Import Benefits", "Icon!")

; ============================================================
; Note: What We Cannot Do
; ============================================================

; This would cause an error because we didn't import it:
; truncated := Truncate("Hello World", 5)  ; ❌ Error!

; This would also fail:
; reversed := Reverse("Hello")  ; ❌ Error!

; To use those, we would need to either:
; 1. Add them to our selective import list:
;    Import { ToTitleCase, ToSnakeCase, ToCamelCase, Truncate, Reverse } from StringHelpers
;
; 2. Or import the entire module:
;    Import StringHelpers
;    result := StringHelpers.Truncate("Hello", 5)
