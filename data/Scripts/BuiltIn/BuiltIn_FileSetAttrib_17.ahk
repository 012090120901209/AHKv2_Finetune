#Requires AutoHotkey v2.0

/**
* BuiltIn_FileSetAttrib_17.ahk
*
* DESCRIPTION:
* Basic usage of FileSetAttrib() to modify file attributes
*
* FEATURES:
* - Set read-only attribute
* - Set hidden attribute
* - Set archive bit
* - Remove attributes
* - Toggle attributes
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/FileSetAttrib.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - FileSetAttrib() function
* - Adding attributes (+)
* - Removing attributes (-)
* - Setting exact attributes (^)
* - Toggling attributes
*
* LEARNING POINTS:
* 1. FileSetAttrib() modifies file attributes
* 2. Use + to add, - to remove, ^ to set exactly
* 3. Can combine multiple attributes (e.g., "+RH")
* 4. Changes persist until modified again
* 5. Requires appropriate permissions
* 6. Essential for file protection and organization
*/

; ============================================================
; Example 1: Add Read-Only Attribute
; ============================================================

; Create test file
testFile := A_ScriptDir "\setattrib_test.txt"
FileAppend("Test content", testFile)

; Get initial attributes
beforeAttrs := FileGetAttrib(testFile)

; Set read-only
FileSetAttrib("+R", testFile)

; Get new attributes
afterAttrs := FileGetAttrib(testFile)

output := "ADD READ-ONLY ATTRIBUTE:`n`n"
output .= "Before: " beforeAttrs "`n"
output .= "After: " afterAttrs "`n`n"
output .= "File is now read-only and protected from modification"

MsgBox(output, "Set Read-Only", "Icon!")

; Remove read-only for next examples
FileSetAttrib("-R", testFile)

; ============================================================
; Example 2: Remove Attributes
; ============================================================

; Set multiple attributes first
FileSetAttrib("+RH", testFile)
beforeAttrs := FileGetAttrib(testFile)

; Remove read-only but keep hidden
FileSetAttrib("-R", testFile)
afterAttrs := FileGetAttrib(testFile)

output := "REMOVE ATTRIBUTE:`n`n"
output .= "Before: " beforeAttrs " (Read-Only + Hidden)`n"
output .= "After: " afterAttrs " (Hidden only)`n`n"
output .= "Read-only removed, file is now modifiable"

MsgBox(output, "Remove Attribute", "Icon!")

FileSetAttrib("-H", testFile)  ; Clean up

; ============================================================
; Example 3: Set Multiple Attributes
; ============================================================

/**
* Set multiple attributes at once
*
* @param {String} filePath - File to modify
* @param {String} attributes - Attributes to set
* @returns {Object} - Operation result
*/
SetMultipleAttributes(filePath, attributes) {
    result := {
        success: false,
        before: "",
        after: "",
        message: ""
    }

    if (!FileExist(filePath)) {
        result.message := "File not found"
        return result
    }

    result.before := FileGetAttrib(filePath)

    try {
        FileSetAttrib(attributes, filePath)
        result.after := FileGetAttrib(filePath)
        result.success := true
        result.message := "Attributes set successfully"
    } catch Error as err {
        result.message := "Failed: " err.Message
    }

    return result
}

; Set read-only and hidden
setResult := SetMultipleAttributes(testFile, "+RH")

output := "SET MULTIPLE ATTRIBUTES:`n`n"
output .= "Operation: +RH (Add Read-Only and Hidden)`n`n"
output .= "Before: " setResult.before "`n"
output .= "After: " setResult.after "`n`n"
output .= "Status: " (setResult.success ? "SUCCESS ✓" : "FAILED ✗") "`n"
output .= "Message: " setResult.message

MsgBox(output, "Multiple Attributes", setResult.success ? "Icon!" : "IconX")

FileSetAttrib("-RH", testFile)  ; Clean up

; ============================================================
; Example 4: Toggle Attribute
; ============================================================

/**
* Toggle an attribute on/off
*
* @param {String} filePath - File to modify
* @param {String} attribute - Attribute to toggle (single character)
* @returns {Boolean} - New state (true if now set)
*/
ToggleAttribute(filePath, attribute) {
    if (!FileExist(filePath))
    return false

    currentAttrs := FileGetAttrib(filePath)
    hasAttr := InStr(currentAttrs, attribute)

    if (hasAttr)
    FileSetAttrib("-" attribute, filePath)
    else
    FileSetAttrib("+" attribute, filePath)

    return !hasAttr
}

; Toggle read-only
before1 := FileGetAttrib(testFile)
isSetAfter1 := ToggleAttribute(testFile, "R")
after1 := FileGetAttrib(testFile)

isSetAfter2 := ToggleAttribute(testFile, "R")
after2 := FileGetAttrib(testFile)

output := "TOGGLE ATTRIBUTE:`n`n"
output .= "Initial: " before1 "`n"
output .= "After Toggle 1: " after1 " (R is " (isSetAfter1 ? "ON" : "OFF") ")`n"
output .= "After Toggle 2: " after2 " (R is " (isSetAfter2 ? "ON" : "OFF") ")`n`n"
output .= "Toggling switches attribute on/off"

MsgBox(output, "Toggle Attribute", "Icon!")

; ============================================================
; Example 5: Set Exact Attributes
; ============================================================

; Set exact attributes (replaces all existing)
before := FileGetAttrib(testFile)

FileSetAttrib("^R", testFile)  ; Set ONLY read-only, remove all others

after := FileGetAttrib(testFile)

output := "SET EXACT ATTRIBUTES:`n`n"
output .= "Before: " before "`n"
output .= "Operation: ^R (Set ONLY Read-Only)`n"
output .= "After: " after "`n`n"
output .= "Note: ^ sets exact attributes, removing others"

MsgBox(output, "Exact Attributes", "Icon!")

FileSetAttrib("-R", testFile)  ; Clean up

; ============================================================
; Example 6: Protect File
; ============================================================

/**
* Protect file from modification
*
* @param {String} filePath - File to protect
* @param {Boolean} protect - True to protect, false to unprotect
* @returns {Object} - Protection result
*/
ProtectFile(filePath, protect := true) {
    result := {
        success: false,
        protected: false,
        message: ""
    }

    if (!FileExist(filePath)) {
        result.message := "File not found"
        return result
    }

    try {
        if (protect) {
            FileSetAttrib("+R", filePath)
            result.protected := true
            result.message := "File is now protected (read-only)"
        } else {
            FileSetAttrib("-R", filePath)
            result.protected := false
            result.message := "File protection removed (writable)"
        }
        result.success := true
    } catch Error as err {
        result.message := "Failed: " err.Message
    }

    return result
}

; Protect file
protectResult := ProtectFile(testFile, true)

output := "FILE PROTECTION:`n`n"
output .= "File: setattrib_test.txt`n"
output .= "Protected: " (protectResult.protected ? "YES ✓" : "NO ✗") "`n"
output .= "Message: " protectResult.message "`n`n"
output .= "Attributes: " FileGetAttrib(testFile)

MsgBox(output, "Protect File", protectResult.success ? "Icon!" : "IconX")

; Unprotect for cleanup
ProtectFile(testFile, false)

; ============================================================
; Example 7: Hide/Unhide File
; ============================================================

/**
* Hide or unhide a file
*
* @param {String} filePath - File to modify
* @param {Boolean} hide - True to hide, false to unhide
* @returns {Boolean} - Success
*/
HideFile(filePath, hide := true) {
    if (!FileExist(filePath))
    return false

    try {
        if (hide)
        FileSetAttrib("+H", filePath)
        else
        FileSetAttrib("-H", filePath)
        return true
    } catch {
        return false
    }
}

; Test hide/unhide
hideSuccess := HideFile(testFile, true)
hiddenAttrs := FileGetAttrib(testFile)

unhideSuccess := HideFile(testFile, false)
visibleAttrs := FileGetAttrib(testFile)

output := "HIDE/UNHIDE FILE:`n`n"
output .= "Hide Operation: " (hideSuccess ? "SUCCESS" : "FAILED") "`n"
output .= "Hidden Attrs: " hiddenAttrs "`n`n"
output .= "Unhide Operation: " (unhideSuccess ? "SUCCESS" : "FAILED") "`n"
output .= "Visible Attrs: " visibleAttrs "`n`n"
output .= "File is now " (InStr(visibleAttrs, "H") ? "HIDDEN" : "VISIBLE")

MsgBox(output, "Hide/Unhide", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
FILESETATTRIB() FUNCTION REFERENCE:

Syntax:
FileSetAttrib(Attributes [, FilePattern])

Attribute Operators:
+ = Add attribute
- = Remove attribute
^ = Set exact attributes (remove others)

Common Attributes:
R = Read-Only
A = Archive
S = System
H = Hidden
N = Normal (remove all special)

Examples:
FileSetAttrib('+R', file)    ; Add read-only
FileSetAttrib('-R', file)    ; Remove read-only
FileSetAttrib('+RH', file)   ; Add R and H
FileSetAttrib('-RH', file)   ; Remove R and H
FileSetAttrib('^R', file)    ; Only R, remove others
FileSetAttrib('^N', file)    ; Remove all special

Common Patterns:
; Protect file
FileSetAttrib('+R', file)

; Hide file
FileSetAttrib('+H', file)

; Protect and hide
FileSetAttrib('+RH', file)

; Make normal (remove all)
FileSetAttrib('^N', file)

; Toggle read-only
attrs := FileGetAttrib(file)
if (InStr(attrs, 'R'))
FileSetAttrib('-R', file)
else
FileSetAttrib('+R', file)

Use Cases:
✓ Protect important files
✓ Hide sensitive files
✓ Mark files for backup
✓ Organize file collections
✓ Prevent accidental deletion
✓ Implement file security

Best Practices:
• Check file exists first
• Handle errors gracefully
• Document attribute changes
• Test before bulk operations
• Respect existing attributes
• Log modifications
• Provide undo capability
)"

MsgBox(info, "FileSetAttrib() Reference", "Icon!")

; Cleanup
FileDelete(testFile)
