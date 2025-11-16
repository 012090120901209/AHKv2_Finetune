#Requires AutoHotkey v2.0
/**
 * BuiltIn_FileSetAttrib_18.ahk
 *
 * DESCRIPTION:
 * File protection and security using attributes
 *
 * FEATURES:
 * - Lock files for protection
 * - Create write-protected files
 * - Implement file security
 * - Protect against deletion
 * - Secure sensitive files
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/FileSetAttrib.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - FileSetAttrib() for security
 * - Read-only protection
 * - Attribute-based access control
 * - File locking mechanisms
 * - Security implementations
 *
 * LEARNING POINTS:
 * 1. Use read-only to prevent modifications
 * 2. Combine attributes for better protection
 * 3. Implement file locking systems
 * 4. Protect against accidental deletion
 * 5. Create tamper-resistant files
 * 6. Build security layers
 */

; ============================================================
; Example 1: Lock File (Read-Only Protection)
; ============================================================

/**
 * Lock file to prevent modification
 *
 * @param {String} filePath - File to lock
 * @returns {Object} - Lock result
 */
LockFile(filePath) {
    result := {
        success: false,
        message: ""
    }

    if (!FileExist(filePath)) {
        result.message := "File not found"
        return result
    }

    try {
        FileSetAttrib("+R", filePath)
        result.success := true
        result.message := "File locked successfully"
    } catch Error as err {
        result.message := "Lock failed: " err.Message
    }

    return result
}

/**
 * Unlock file to allow modification
 *
 * @param {String} filePath - File to unlock
 * @returns {Object} - Unlock result
 */
UnlockFile(filePath) {
    result := {
        success: false,
        message: ""
    }

    if (!FileExist(filePath)) {
        result.message := "File not found"
        return result
    }

    try {
        FileSetAttrib("-R", filePath)
        result.success := true
        result.message := "File unlocked successfully"
    } catch Error as err {
        result.message := "Unlock failed: " err.Message
    }

    return result
}

; Create and test lock
testFile := A_ScriptDir "\locked_test.txt"
FileAppend("Protected content", testFile)

lockResult := LockFile(testFile)

output := "FILE LOCKING:`n`n"
output .= "File: locked_test.txt`n"
output .= "Lock Status: " (lockResult.success ? "LOCKED ✓" : "FAILED ✗") "`n"
output .= "Message: " lockResult.message "`n`n"
output .= "Current Attributes: " FileGetAttrib(testFile)

MsgBox(output, "Lock File", lockResult.success ? "Icon!" : "IconX")

; Unlock for cleanup
UnlockFile(testFile)

; ============================================================
; Example 2: Multi-Layer Protection
; ============================================================

/**
 * Apply multi-layer protection to file
 *
 * @param {String} filePath - File to protect
 * @param {Integer} level - Protection level (1-3)
 * @returns {Object} - Protection result
 */
ApplyProtection(filePath, level := 2) {
    result := {
        success: false,
        level: 0,
        attributes: "",
        description: ""
    }

    if (!FileExist(filePath)) {
        result.description := "File not found"
        return result
    }

    try {
        switch level {
            case 1:  ; Basic - Read-only
                FileSetAttrib("+R", filePath)
                result.description := "Basic protection (Read-only)"
            case 2:  ; Medium - Read-only + Hidden
                FileSetAttrib("+RH", filePath)
                result.description := "Medium protection (Read-only + Hidden)"
            case 3:  ; High - Read-only + Hidden + System
                FileSetAttrib("+RHS", filePath)
                result.description := "High protection (Read-only + Hidden + System)"
            default:
                result.description := "Invalid protection level"
                return result
        }

        result.success := true
        result.level := level
        result.attributes := FileGetAttrib(filePath)
    } catch Error as err {
        result.description := "Protection failed: " err.Message
    }

    return result
}

; Test protection levels
Loop 3 {
    level := A_Index
    file := A_ScriptDir "\protected_L" level ".txt"
    FileAppend("Content level " level, file)

    protection := ApplyProtection(file, level)

    MsgBox("PROTECTION LEVEL " level "`n`n"
         . "Success: " (protection.success ? "YES" : "NO") "`n"
         . "Attributes: " protection.attributes "`n"
         . "Description: " protection.description,
         "Level " level " Protection", protection.success ? "Icon!" : "IconX")

    ; Clean up
    FileSetAttrib("-RHS", file)
    FileDelete(file)
}

; ============================================================
; Example 3: Secure File Creation
; ============================================================

/**
 * Create file with immediate protection
 *
 * @param {String} filePath - Path for new file
 * @param {String} content - File content
 * @param {Boolean} protect - Apply protection immediately
 * @returns {Object} - Creation result
 */
CreateSecureFile(filePath, content, protect := true) {
    result := {
        success: false,
        protected: false,
        message: ""
    }

    try {
        ; Create file
        FileAppend(content, filePath)

        ; Apply protection if requested
        if (protect) {
            FileSetAttrib("+R", filePath)
            result.protected := true
        }

        result.success := true
        result.message := protect ? "File created and protected" : "File created (not protected)"
    } catch Error as err {
        result.message := "Failed: " err.Message
    }

    return result
}

; Create secure file
secureFile := A_ScriptDir "\secure.txt"
createResult := CreateSecureFile(secureFile, "Sensitive data", true)

output := "SECURE FILE CREATION:`n`n"
output .= "File: secure.txt`n"
output .= "Created: " (createResult.success ? "YES ✓" : "NO ✗") "`n"
output .= "Protected: " (createResult.protected ? "YES ✓" : "NO ✗") "`n"
output .= "Message: " createResult.message "`n`n"
output .= "Attributes: " FileGetAttrib(secureFile)

MsgBox(output, "Secure Creation", createResult.success ? "Icon!" : "IconX")

; Clean up
FileSetAttrib("-R", secureFile)
FileDelete(secureFile)

; ============================================================
; Example 4: Temporary Unlock for Modification
; ============================================================

/**
 * Temporarily unlock file, modify, then re-lock
 *
 * @param {String} filePath - File to modify
 * @param {String} content - Content to append
 * @returns {Object} - Operation result
 */
ModifyProtectedFile(filePath, content) {
    result := {
        success: false,
        wasProtected: false,
        message: ""
    }

    if (!FileExist(filePath)) {
        result.message := "File not found"
        return result
    }

    ; Check if protected
    attrs := FileGetAttrib(filePath)
    result.wasProtected := InStr(attrs, "R") ? true : false

    try {
        ; Unlock if needed
        if (result.wasProtected)
            FileSetAttrib("-R", filePath)

        ; Modify
        FileAppend(content, filePath)

        ; Re-lock if was protected
        if (result.wasProtected)
            FileSetAttrib("+R", filePath)

        result.success := true
        result.message := "File modified successfully"
    } catch Error as err {
        ; Try to restore protection even if modify failed
        if (result.wasProtected)
            FileSetAttrib("+R", filePath)

        result.message := "Modification failed: " err.Message
    }

    return result
}

; Test protected modification
protectedFile := A_ScriptDir "\temp_unlock.txt"
FileAppend("Original content", protectedFile)
FileSetAttrib("+R", protectedFile)

modifyResult := ModifyProtectedFile(protectedFile, "`nAppended content")

output := "TEMPORARY UNLOCK:`n`n"
output .= "File: temp_unlock.txt`n"
output .= "Was Protected: " (modifyResult.wasProtected ? "YES" : "NO") "`n"
output .= "Modified: " (modifyResult.success ? "YES ✓" : "NO ✗") "`n"
output .= "Message: " modifyResult.message "`n`n"
output .= "Final Attributes: " FileGetAttrib(protectedFile) "`n"
output .= "(File is re-locked after modification)"

MsgBox(output, "Temporary Unlock", modifyResult.success ? "Icon!" : "IconX")

; Clean up
FileSetAttrib("-R", protectedFile)
FileDelete(protectedFile)

; ============================================================
; Example 5: Protection Status Check
; ============================================================

/**
 * Check protection status of file
 *
 * @param {String} filePath - File to check
 * @returns {Object} - Protection status
 */
GetProtectionStatus(filePath) {
    status := {
        exists: false,
        protected: false,
        hidden: false,
        system: false,
        level: "None",
        canModify: true
    }

    if (!FileExist(filePath))
        return status

    status.exists := true
    attrs := FileGetAttrib(filePath)

    status.protected := InStr(attrs, "R") ? true : false
    status.hidden := InStr(attrs, "H") ? true : false
    status.system := InStr(attrs, "S") ? true : false

    ; Determine protection level
    if (status.system)
        status.level := "Critical (System)"
    else if (status.protected && status.hidden)
        status.level := "High (Protected + Hidden)"
    else if (status.protected)
        status.level := "Medium (Protected)"
    else if (status.hidden)
        status.level := "Low (Hidden)"
    else
        status.level := "None"

    status.canModify := !status.protected

    return status
}

; Check status
checkFile := A_ScriptDir "\status_check.txt"
FileAppend("Content", checkFile)
FileSetAttrib("+RH", checkFile)

status := GetProtectionStatus(checkFile)

output := "PROTECTION STATUS:`n`n"
output .= "File: status_check.txt`n"
output .= "Exists: " (status.exists ? "YES" : "NO") "`n"
output .= "Protected: " (status.protected ? "YES" : "NO") "`n"
output .= "Hidden: " (status.hidden ? "YES" : "NO") "`n"
output .= "System: " (status.system ? "YES" : "NO") "`n`n"
output .= "Protection Level: " status.level "`n"
output .= "Can Modify: " (status.canModify ? "YES" : "NO")

MsgBox(output, "Protection Status", "Icon!")

; Clean up
FileSetAttrib("-RH", checkFile)
FileDelete(checkFile)

; ============================================================
; Reference Information
; ============================================================

info := "
(
FILE PROTECTION WITH ATTRIBUTES:

Protection Levels:

1. Basic Protection:
   FileSetAttrib('+R', file)
   • Read-only
   • Prevents modifications
   • Easy to bypass

2. Medium Protection:
   FileSetAttrib('+RH', file)
   • Read-only + Hidden
   • Not visible in normal view
   • Moderate security

3. High Protection:
   FileSetAttrib('+RHS', file)
   • Read-only + Hidden + System
   • Maximum attribute protection
   • Requires admin to modify

Protection Strategies:

Lock/Unlock Pattern:
  ; Temporary unlock for modification
  FileSetAttrib('-R', file)
  FileAppend(data, file)
  FileSetAttrib('+R', file)

Secure Creation:
  FileAppend(content, file)
  FileSetAttrib('+R', file)

Status Checking:
  attrs := FileGetAttrib(file)
  if (InStr(attrs, 'R'))
      ; File is protected

Best Practices:
• Always re-lock after modification
• Check protection before operations
• Log protection changes
• Use appropriate level for sensitivity
• Document protection requirements
• Test protection effectiveness
• Implement proper error handling

Limitations:
• Not encryption (data is readable)
• Can be bypassed with permissions
• Only prevents casual modifications
• Consider OS-level encryption for sensitive data
)"

MsgBox(info, "Protection Reference", "Icon!")

; Cleanup
FileDelete(testFile)
