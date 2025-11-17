#!/bin/bash
cd /home/user/AHKv2_Finetune/data/raw_scripts/AHK_v2_Examples

# Create FileGetAttrib_15
cat > "BuiltIn_FileGetAttrib_15.ahk" << 'EOF15'
#Requires AutoHotkey v2.0
/**
 * BuiltIn_FileGetAttrib_15.ahk
 *
 * DESCRIPTION:
 * Attribute-based file operations and validation
 *
 * FEATURES:
 * - Validate file attributes
 * - Attribute-based access control
 * - Permission checking
 * - Attribute validation rules
 * - Safety checks
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/FileGetAttrib.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - FileGetAttrib() for validation
 * - Attribute-based security
 * - Permission verification
 * - Safety assertions
 * - Access control checks
 *
 * LEARNING POINTS:
 * 1. Validate attributes before operations
 * 2. Implement attribute-based security
 * 3. Check permissions programmatically
 * 4. Enforce attribute requirements
 * 5. Prevent unauthorized modifications
 * 6. Create safety guards
 */

; Create test file
testFile := A_ScriptDir "\validation_test.txt"
FileAppend("Test content", testFile)

; ============================================================
; Example 1: Validate Write Permission
; ============================================================

/**
 * Check if file can be written to
 *
 * @param {String} filePath - File to check
 * @returns {Object} - Permission status
 */
ValidateWritePermission(filePath) {
    result := {
        canWrite: false,
        reason: ""
    }

    if (!FileExist(filePath)) {
        result.reason := "File does not exist"
        return result
    }

    attrs := FileGetAttrib(filePath)

    if (InStr(attrs, "R")) {
        result.reason := "File is read-only"
        return result
    }

    if (InStr(attrs, "S")) {
        result.reason := "File is system file"
        return result
    }

    result.canWrite := true
    result.reason := "File is writable"
    return result
}

writeCheck := ValidateWritePermission(testFile)

MsgBox("WRITE PERMISSION CHECK:`n`n"
     . "File: validation_test.txt`n"
     . "Can Write: " (writeCheck.canWrite ? "YES ✓" : "NO ✗") "`n"
     . "Reason: " writeCheck.reason,
     "Permission Check", writeCheck.canWrite ? "Icon!" : "IconX")

; ============================================================
; Example 2: Attribute-Based Access Control
; ============================================================

/**
 * Control access based on attributes
 *
 * @param {String} filePath - File to access
 * @param {String} operation - Operation type (read/write/delete)
 * @returns {Boolean} - Access granted
 */
CheckFileAccess(filePath, operation) {
    if (!FileExist(filePath))
        return false

    attrs := FileGetAttrib(filePath)

    switch operation {
        case "read":
            return true  ; Can always read
        case "write":
            return !InStr(attrs, "R")  ; Can write if not read-only
        case "delete":
            return !InStr(attrs, "R") && !InStr(attrs, "S")  ; Can delete if not RO or System
        default:
            return false
    }
}

operations := ["read", "write", "delete"]
output := "ACCESS CONTROL CHECK:`n`n"

for op in operations {
    allowed := CheckFileAccess(testFile, op)
    output .= StrUpper(op) ": " (allowed ? "ALLOWED ✓" : "DENIED ✗") "`n"
}

MsgBox(output, "Access Control", "Icon!")

; ============================================================
; Example 3: Safe File Modification
; ============================================================

/**
 * Safely modify file with attribute validation
 *
 * @param {String} filePath - File to modify
 * @param {String} content - Content to append
 * @returns {Object} - Operation result
 */
SafeModify(filePath, content) {
    result := {
        success: false,
        message: ""
    }

    if (!FileExist(filePath)) {
        result.message := "File not found"
        return result
    }

    attrs := FileGetAttrib(filePath)

    ; Safety checks
    if (InStr(attrs, "S")) {
        result.message := "Cannot modify system file"
        return result
    }

    if (InStr(attrs, "R")) {
        result.message := "File is read-only"
        return result
    }

    try {
        FileAppend(content, filePath)
        result.success := true
        result.message := "File modified successfully"
    } catch Error as err {
        result.message := "Modification failed: " err.Message
    }

    return result
}

modifyResult := SafeModify(testFile, "`nAppended line")

MsgBox("SAFE MODIFICATION:`n`n"
     . "Success: " (modifyResult.success ? "YES ✓" : "NO ✗") "`n"
     . "Message: " modifyResult.message,
     "Safe Modify", modifyResult.success ? "Icon!" : "IconX")

; ============================================================
; Example 4: Attribute Requirements Enforcement
; ============================================================

/**
 * Enforce attribute requirements
 *
 * @param {String} filePath - File to check
 * @param {Object} requirements - Required attributes
 * @returns {Object} - Compliance result
 */
EnforceAttributeRequirements(filePath, requirements) {
    result := {
        compliant: true,
        violations: []
    }

    if (!FileExist(filePath)) {
        result.compliant := false
        result.violations.Push("File does not exist")
        return result
    }

    attrs := FileGetAttrib(filePath)

    ; Check required attributes
    if (requirements.HasOwnProp("mustHave")) {
        Loop Parse, requirements.mustHave {
            if (!InStr(attrs, A_LoopField)) {
                result.compliant := false
                result.violations.Push("Missing required attribute: " A_LoopField)
            }
        }
    }

    ; Check forbidden attributes
    if (requirements.HasOwnProp("mustNotHave")) {
        Loop Parse, requirements.mustNotHave {
            if (InStr(attrs, A_LoopField)) {
                result.compliant := false
                result.violations.Push("Has forbidden attribute: " A_LoopField)
            }
        }
    }

    return result
}

requirements := {
    mustHave: "A",      ; Must have archive bit
    mustNotHave: "RS"   ; Must not be read-only or system
}

compliance := EnforceAttributeRequirements(testFile, requirements)

output := "ATTRIBUTE REQUIREMENTS:`n`n"
output .= "Compliant: " (compliance.compliant ? "YES ✓" : "NO ✗") "`n`n"

if (compliance.violations.Length > 0) {
    output .= "Violations:`n"
    for violation in compliance.violations
        output .= "  • " violation "`n"
}

MsgBox(output, "Compliance Check", compliance.compliant ? "Icon!" : "IconX")

; ============================================================
; Reference Information
; ============================================================

info := "
(
ATTRIBUTE-BASED VALIDATION:

Permission Checks:
• Read: Usually always allowed
• Write: Check for R (read-only)
• Delete: Check for R and S
• Execute: Check file type

Safety Guards:
  attrs := FileGetAttrib(file)
  if (InStr(attrs, 'S'))
      ; Don't modify system files
  if (InStr(attrs, 'R'))
      ; File is protected

Access Control Levels:
1. Public: No restrictions
2. Protected: Read-only set
3. System: System attribute set
4. Restricted: Multiple attributes

Best Practices:
• Always check before modifying
• Respect system files
• Validate permissions
• Log access attempts
• Handle denials gracefully
• Document requirements
• Test edge cases
)"

MsgBox(info, "Validation Reference", "Icon!")

; Cleanup
FileDelete(testFile)
EOF15

echo "Created BuiltIn_FileGetAttrib_15.ahk"
