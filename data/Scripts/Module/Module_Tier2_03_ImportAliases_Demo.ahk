#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

/**
 * Module Tier 2 Example 03: Import Aliases Demo
 * 
 * This example demonstrates:
 * - Aliasing imported functions
 * - Avoiding name collisions
 * - Creating more readable APIs
 * - Renaming for clarity
 * 
 * USAGE: Run this file directly
 * 
 * @requires Module_Tier2_01_StringHelpers_Module.ahk
 */


; ============================================================
; Import with Aliases
; ============================================================

; Rename functions for clarity or to avoid conflicts
Import {
    ToTitleCase as Title,
    ToSnakeCase as Snake,
    ToCamelCase as Camel,
    ToPascalCase as Pascal,
    ToKebabCase as Kebab,
    Capitalize as Cap
} from StringHelpers

; ============================================================
; Example 1: Shorter, Cleaner Names
; ============================================================

text := "hello world from autohotkey"

; Much cleaner with short aliases!
result := ""
result .= "Title:  " Title(text) "`n"
result .= "Snake:  " Snake(text) "`n"
result .= "Camel:  " Camel(text) "`n"
result .= "Pascal: " Pascal(text) "`n"
result .= "Kebab:  " Kebab(text) "`n"
result .= "Cap:    " Cap(text) "`n"

MsgBox(result, "Import Aliases - Shorter Names", "Icon!")
    ; ============================================================
    ; Example 2: Avoiding Name Collisions
    ; ============================================================

    ; Imagine we have multiple modules with similar function names
    ; (We'll simulate this with a local function)

    ; Local Contains function (conflicts with StringHelpers.Contains)
    Contains (array, value) {
    for item in array {
        if item = value
            return true
    }
    return false
}

; Import StringHelpers.Contains with alias to avoid conflict
Import { Contains as StringContains } from StringHelpers

; Now we can use both!
myArray := [1, 2, 3, 4, 5]
hasNumber := Contains (myArray, 3)  ; Our local function

myText := "Hello World"
hasWord := StringContains(myText, "World")  ; Imported function

MsgBox("Array contains 3: " (hasNumber ? "Yes" : "No") "`n"
    . "Text contains 'World': " (hasWord ? "Yes" : "No"),
    "Avoiding Name Collisions", "Icon!")

; ============================================================
; Example 3: Domain-Specific Aliases
; ============================================================

; For a URL slug generator, rename for clarity
Import {
    ToKebabCase as MakeSlug,
    ToSnakeCase as MakeId,
    ToCamelCase as MakeVar
} from StringHelpers

class BlogPost {
    title := ""
    slug := ""
    id := ""

    __New(title) {
        this.title := title
        this.slug := MakeSlug(title)        ; Clear what this does!
        this.id := MakeId(title)            ; Clear database ID format
    }

    GetURL() {
        return "https://example.com/blog/" this.slug
    }
}

post := BlogPost("My First Blog Post")

MsgBox("Blog Post:`n`n"
    . "Title: " post.title "`n"
    . "Slug:  " post.slug "`n"
    . "ID:    " post.id "`n`n"
    . "URL: " post.GetURL(),
    "Domain-Specific Aliases", "Icon!")

; ============================================================
; Example 4: Multiple Modules, Same Function Name
; ============================================================

; Simulate having multiple helper modules
class ArrayHelpers {
    static Join(arr, sep := ", ") {
        result := ""
        for index, value in arr
            result .= value (index < arr.Length ? sep : "")
        return result
    }
}

; Import StringHelpers.Join with alias
Import { Join as JoinString } from StringHelpers

; Now we have:
; - ArrayHelpers.Join (for arrays)
; - JoinString (for string arrays, imported with alias)

words := ["Hello", "World", "From", "AHK"]

; Use array join
arrayResult := ArrayHelpers.Join(words, " ")

; Use string join (imported)
stringResult := JoinString(words, " | ")

MsgBox("Words: " ArrayHelpers.Join(words, ", ") "`n`n"
    . "Array Join:  " arrayResult "`n"
    . "String Join: " stringResult,
    "Multiple Modules", "Icon!")

; ============================================================
; Example 5: Chaining with Aliases
; ============================================================

; Shorter aliases make chaining more readable
Import {
    Truncate as Cut,
    PadLeft as LeftPad,
    PadRight as RightPad
} from StringHelpers

FormatLabel(text, width := 20) {
    text := Cut(text, width)      ; Truncate if too long
    text := RightPad(text, width) ; Pad to exact width
    return "[" text "]"
}

labels := []
labels.Push(FormatLabel("Short"))
labels.Push(FormatLabel("Medium Length Text"))
labels.Push(FormatLabel("This is a very long text that will be truncated"))

output := "Formatted Labels:`n`n"
for label in labels
    output .= label "`n"

MsgBox(output, "Chaining with Aliases", "Icon!")

; ============================================================
; Example 6: Alias Patterns
; ============================================================

aliasPatterns := "
(
Common Alias Patterns:

1. SHORTENING
ToTitleCase as Title
ToCamelCase as Camel
→ Makes code more concise

2. CLARIFYING
Contains as StringContains
Join as JoinString
→ Avoids ambiguity

3. DOMAIN-SPECIFIC
ToKebabCase as MakeSlug
ToSnakeCase as MakeId
→ Matches your domain language

4. AVOIDING CONFLICTS
Contains as StrContains
Join as JoinStr
→ Prevents name collisions

5. READABILITY
Truncate as Cut
PadLeft as LeftPad
→ Easier to understand

Best Practice:
- Use aliases when they improve clarity
- Don't alias just to save typing
- Keep names meaningful
- Be consistent across your project
)"

MsgBox(aliasPatterns, "Alias Patterns Guide", "Icon!")

; ============================================================
; Example 7: Practical Use Case - Form Validator
; ============================================================

Import {
    Truncate as Limit,
    CollapseWhitespace as Clean,
    StartsWith as Begins,
    EndsWith as Ends
} from StringHelpers

class FormValidator {
    ValidateUsername(username) {
        username := Clean(username)  ; Clean whitespace
        username := Limit(username, 20)  ; Max 20 chars

        errors := []

        if StrLen(username) < 3
            errors.Push("Username must be at least 3 characters")

        if !RegExMatch(username, "^[a-zA-Z0-9_]+$")
            errors.Push("Username can only contain letters, numbers, and underscores")

        if Begins(username, "_")
            errors.Push("Username cannot start with underscore")

        if Ends(username, "_")
            errors.Push("Username cannot end with underscore")

        return {
            isValid: errors.Length = 0,
            username: username,
            errors: errors
        }
    }
}

validator := FormValidator()

; Test valid username
result1 := validator.ValidateUsername("  john_doe123  ")
MsgBox("Username: '" result1.username "' → "
    . (result1.isValid ? "✓ Valid" : "✗ Invalid"),
    "Valid Username", "Icon!")

; Test invalid username
result2 := validator.ValidateUsername("_invalid_username_that_is_way_too_long_")
if !result2.isValid {
    errMsg := "Username: '" result2.username "' → ✗ Invalid`n`nErrors:`n"
    for error in result2.errors
        errMsg .= "• " error "`n"
    MsgBox(errMsg, "Invalid Username", "Icon!")
}
