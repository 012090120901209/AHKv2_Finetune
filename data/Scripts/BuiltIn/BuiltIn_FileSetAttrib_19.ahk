#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_FileSetAttrib_19.ahk
 * 
 * DESCRIPTION:
 * Attribute-based file organization and management
 * 
 * FEATURES:
 * - Organize files by attributes
 * - Archive file management
 * - Attribute-based sorting
 * - File categorization
 * - Automated organization
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/FileSetAttrib.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - FileSetAttrib() for organization
 * - Archive bit management
 * - Attribute-based workflows
 * - File classification
 * - Automated organization
 * 
 * LEARNING POINTS:
 * 1. Use attributes for file organization
 * 2. Implement archive bit workflows
 * 3. Categorize files by attributes
 * 4. Automate organization tasks
 * 5. Create attribute-based systems
 * 6. Manage file collections
 */

; ============================================================
; Example 1: Mark Files for Backup (Archive Bit)
; ============================================================

/**
 * Mark file as needing backup (set archive bit)
 * 
 * @param {String} filePath - File to mark
 * @returns {Boolean} - Success
 */
MarkForBackup(filePath) {
    if (!FileExist(filePath))
        return false

    try {
        FileSetAttrib("+A", filePath)
        return true
    } catch {
        return false
    }
}

/**
 * Clear backup mark (clear archive bit)
 * 
 * @param {String} filePath - File to unmark
 * @returns {Boolean} - Success
 */
ClearBackupMark(filePath) {
    if (!FileExist(filePath))
        return false

    try {
        FileSetAttrib("-A", filePath)
        return true
    } catch {
        return false
    }
}

; Create test files
testDir := A_ScriptDir "\OrgTest"
DirCreate(testDir)

Loop 3 {
    file := testDir "\file" A_Index ".txt"
    FileAppend("Content " A_Index, file)
}

; Mark for backup
marked := 0
Loop Files, testDir "\*.txt", "F" {
    if (MarkForBackup(A_LoopFilePath))
        marked++
}

output := "BACKUP MARKING:`n`n"
output .= "Files Marked: " marked "`n`n"
output .= "Files with Archive Bit:`n"

Loop Files, testDir "\*.txt", "F" {
    attrs := FileGetAttrib(A_LoopFilePath)
    hasArchive := InStr(attrs, "A") ? "YES ✓" : "NO ✗"
    output .= "  " A_LoopFileName ": " hasArchive "`n"
}

MsgBox(output, "Backup Marking", "Icon!")

; ============================================================
; Example 2: Organize Files by Status
; ============================================================

/**
 * Set file status using attributes
 * 
 * @param {String} filePath - File to classify
 * @param {String} status - Status (draft/final/archived)
 * @returns {Boolean} - Success
 */
SetFileStatus(filePath, status) {
    if (!FileExist(filePath))
        return false

    try {
        switch status {
            case "draft":
                ; Normal file, no special attributes
                FileSetAttrib("^N", filePath)
            case "final":
                ; Read-only to prevent changes
                FileSetAttrib("+R", filePath)
            case "archived":
                ; Hidden and read-only
                FileSetAttrib("+RH", filePath)
            default:
                return false
        }
        return true
    } catch {
        return false
    }
}

/**
 * Get file status from attributes
 * 
 * @param {String} filePath - File to check
 * @returns {String} - Status
 */
GetFileStatus(filePath) {
    if (!FileExist(filePath))
        return "not found"

    attrs := FileGetAttrib(filePath)

    if (InStr(attrs, "R") && InStr(attrs, "H"))
        return "archived"
    else if (InStr(attrs, "R"))
        return "final"
    else
        return "draft"
}

; Set different statuses
files := []
Loop Files, testDir "\*.txt", "F"
    files.Push(A_LoopFilePath)

SetFileStatus(files[1], "draft")
SetFileStatus(files[2], "final")
SetFileStatus(files[3], "archived")

output := "FILE STATUS ORGANIZATION:`n`n"
for file in files {
    SplitPath(file, &name)
    status := GetFileStatus(file)
    attrs := FileGetAttrib(file)
    output .= name ":`n"
    output .= "  Status: " status "`n"
    output .= "  Attributes: " attrs "`n`n"
}

MsgBox(output, "Status Organization", "Icon!")

; ============================================================
; Example 3: Attribute-Based File Tagging
; ============================================================

/**
 * Tag files with attribute combinations
 */
class FileTag {
    static Important := "+R"
    static Private := "+RH"
    static Temporary := "+A"
    static System := "+S"

    static ApplyTag(filePath, tagName) {
        if (!FileExist(filePath))
            return false

        try {
            switch tagName {
                case "Important":
                    FileSetAttrib(this.Important, filePath)
                case "Private":
                    FileSetAttrib(this.Private, filePath)
                case "Temporary":
                    FileSetAttrib(this.Temporary, filePath)
                default:
                    return false
            }
            return true
        } catch {
            return false
        }
    }

    static GetTags(filePath) {
        if (!FileExist(filePath))
            return []

        attrs := FileGetAttrib(filePath)
        tags := []

        if (InStr(attrs, "R") && InStr(attrs, "H"))
            tags.Push("Private")
        else if (InStr(attrs, "R"))
            tags.Push("Important")

        if (InStr(attrs, "A"))
            tags.Push("Temporary")

        if (InStr(attrs, "S"))
            tags.Push("System")

        return tags
    }
}

; Tag files
FileTag.ApplyTag(files[1], "Important")
FileTag.ApplyTag(files[2], "Private")
FileTag.ApplyTag(files[3], "Temporary")

output := "FILE TAGGING SYSTEM:`n`n"
for file in files {
    SplitPath(file, &name)
    tags := FileTag.GetTags(file)
    output .= name ":`n  Tags: "
    if (tags.Length > 0) {
        for tag in tags
            output .= tag (A_Index < tags.Length ? ", " : "")
    } else {
        output .= "None"
    }
    output .= "`n`n"
}

MsgBox(output, "File Tagging", "Icon!")

; ============================================================
; Example 4: Hide Temporary Files
; ============================================================

/**
 * Hide all temporary files in directory
 * 
 * @param {String} dirPath - Directory to process
 * @param {String} pattern - File pattern (e.g., "*.tmp")
 * @returns {Object} - Operation result
 */
HideTemporaryFiles(dirPath, pattern := "*.tmp") {
    result := {
        processed: 0,
        hidden: 0,
        failed: 0
    }

    if (!DirExist(dirPath))
        return result

    Loop Files, dirPath "\" pattern, "F" {
        result.processed++
        try {
            FileSetAttrib("+H", A_LoopFilePath)
            result.hidden++
        } catch {
            result.failed++
        }
    }

    return result
}

; Create temporary files
Loop 3 {
    file := testDir "\temp" A_Index ".tmp"
    FileAppend("Temp content", file)
}

; Hide them
hideResult := HideTemporaryFiles(testDir, "*.tmp")

output := "HIDE TEMPORARY FILES:`n`n"
output .= "Files Processed: " hideResult.processed "`n"
output .= "Successfully Hidden: " hideResult.hidden "`n"
output .= "Failed: " hideResult.failed "`n`n"

output .= "Verification:`n"
Loop Files, testDir "\*.tmp", "FH" {
    attrs := FileGetAttrib(A_LoopFilePath)
    output .= "  " A_LoopFileName ": " (InStr(attrs, "H") ? "HIDDEN ✓" : "VISIBLE ✗") "`n"
}

MsgBox(output, "Hide Temporary", "Icon!")

; ============================================================
; Example 5: Finalize Documents
; ============================================================

/**
 * Finalize document (make read-only, clear archive bit)
 * 
 * @param {String} filePath - Document to finalize
 * @returns {Object} - Finalization result
 */
FinalizeDocument(filePath) {
    result := {
        success: false,
        message: "",
        before: "",
        after: ""
    }

    if (!FileExist(filePath)) {
        result.message := "File not found"
        return result
    }

    result.before := FileGetAttrib(filePath)

    try {
        ; Make read-only and clear archive bit
        FileSetAttrib("+R-A", filePath)

        result.after := FileGetAttrib(filePath)
        result.success := true
        result.message := "Document finalized successfully"
    } catch Error as err {
        result.message := "Finalization failed: " err.Message
    }

    return result
}

; Create draft document
draftDoc := testDir "\document.txt"
FileAppend("Final version of document", draftDoc)
FileSetAttrib("+A", draftDoc)  ; Mark as modified

; Finalize it
finalizeResult := FinalizeDocument(draftDoc)

output := "DOCUMENT FINALIZATION:`n`n"
output .= "File: document.txt`n"
output .= "Before: " finalizeResult.before "`n"
output .= "After: " finalizeResult.after "`n`n"
output .= "Status: " (finalizeResult.success ? "FINALIZED ✓" : "FAILED ✗") "`n"
output .= "Message: " finalizeResult.message "`n`n"
output .= "Document is now read-only and ready for distribution"

MsgBox(output, "Finalize Document", finalizeResult.success ? "Icon!" : "IconX")

; ============================================================
; Example 6: Automated File Cleanup
; ============================================================

/**
 * Clean up files based on attributes
 * 
 * @param {String} dirPath - Directory to clean
 * @param {Object} criteria - Cleanup criteria
 * @returns {Object} - Cleanup result
 */
CleanupByAttributes(dirPath, criteria) {
    result := {
        scanned: 0,
        cleaned: 0,
        protected: 0
    }

    if (!DirExist(dirPath))
        return result

    Loop Files, dirPath "\*.*", "FH" {
        result.scanned++
        attrs := FileGetAttrib(A_LoopFilePath)

        ; Don't delete protected files
        if (InStr(attrs, "R")) {
            result.protected++
            continue
        }

        ; Delete if matches criteria
        shouldDelete := false

        if (criteria.HasOwnProp("hasAttribute") && InStr(attrs, criteria.hasAttribute))
            shouldDelete := true

        if (shouldDelete && criteria.HasOwnProp("extension")) {
            if (!InStr(A_LoopFilePath, criteria.extension))
                shouldDelete := false
        }

        if (shouldDelete) {
            try {
                FileDelete(A_LoopFilePath)
                result.cleaned++
            }
        }
    }

    return result
}

; Cleanup temporary files (not protected)
cleanupCriteria := {
    hasAttribute: "H",  ; Hidden files
    extension: ".tmp"   ; Only .tmp files
}

cleanupResult := CleanupByAttributes(testDir, cleanupCriteria)

output := "AUTOMATED CLEANUP:`n`n"
output .= "Files Scanned: " cleanupResult.scanned "`n"
output .= "Files Cleaned: " cleanupResult.cleaned "`n"
output .= "Protected (Skipped): " cleanupResult.protected "`n`n"
output .= "Protected files were not deleted"

MsgBox(output, "Cleanup", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
ATTRIBUTE-BASED ORGANIZATION:

Organization Strategies:

1. Status-Based:
Draft: Normal attributes
Final: +R (read-only)
Archived: +RH (hidden + read-only)

2. Tag-Based:
Important: +R
Private: +RH
Temporary: +A
System: +S

3. Workflow-Based:
New: +A (needs backup)
Processed: -A (backed up)
Protected: +R (finalized)

Archive Bit Usage:
; Mark for backup
FileSetAttrib('+A', file)

; Clear after backup
FileSetAttrib('-A', file)

; Check if needs backup
attrs := FileGetAttrib(file)
if (InStr(attrs, 'A'))
; Backup this file

Common Patterns:

Finalize Document:
FileSetAttrib('+R-A', file)

Hide Temporary:
FileSetAttrib('+H', file)

Protect Important:
FileSetAttrib('+R', file)

Archive Old:
FileSetAttrib('+RH', file)

Best Practices:
• Use consistent attribute schemes
• Document your organization system
• Automate routine organization
• Respect protected files
• Validate before bulk operations
• Provide status feedback
• Implement undo capability
• Log all changes

Use Cases:
✓ Document lifecycle management
✓ Backup systems
✓ File categorization
✓ Temporary file management
✓ Archive systems
✓ Workflow automation
)"

MsgBox(info, "Organization Reference", "Icon!")

; Cleanup
DirDelete(testDir, true)
