#Requires AutoHotkey v2.0

/**
* BuiltIn_FileSetAttrib_20.ahk
*
* DESCRIPTION:
* Bulk attribute operations and mass file management
*
* FEATURES:
* - Bulk attribute modification
* - Batch file processing
* - Mass protection/unprotection
* - Recursive attribute setting
* - Bulk organization operations
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/FileSetAttrib.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - FileSetAttrib() with file patterns
* - Bulk file operations
* - Recursive directory processing
* - Error handling in batch operations
* - Progress tracking
*
* LEARNING POINTS:
* 1. Process multiple files efficiently
* 2. Use file patterns with FileSetAttrib()
* 3. Handle errors in bulk operations
* 4. Track progress of batch operations
* 5. Implement rollback capabilities
* 6. Optimize bulk processing
*/

; ============================================================
; Example 1: Bulk Attribute Setting with Pattern
; ============================================================

/**
* Set attributes for all matching files
*
* @param {String} pattern - File pattern
* @param {String} attributes - Attributes to set
* @returns {Object} - Operation result
*/
BulkSetAttributes(pattern, attributes) {
    result := {
        processed: 0,
        success: 0,
        failed: 0,
        files: []
    }

    Loop Files, pattern, "F" {
        result.processed++
        try {
            FileSetAttrib(attributes, A_LoopFilePath)
            result.success++
            result.files.Push({
                name: A_LoopFileName,
                path: A_LoopFilePath,
                status: "success"
            })
        } catch Error as err {
            result.failed++
            result.files.Push({
                name: A_LoopFileName,
                path: A_LoopFilePath,
                status: "failed",
                error: err.Message
            })
        }
    }

    return result
}

; Create test files
testDir := A_ScriptDir "\BulkTest"
DirCreate(testDir)

Loop 5 {
    file := testDir "\file" A_Index ".txt"
    FileAppend("Content " A_Index, file)
}

; Bulk set read-only
bulkResult := BulkSetAttributes(testDir "\*.txt", "+R")

output := "BULK ATTRIBUTE SETTING:`n`n"
output .= "Pattern: *.txt`n"
output .= "Operation: +R (Add Read-Only)`n`n"
output .= "Processed: " bulkResult.processed "`n"
output .= "Success: " bulkResult.success " ✓`n"
output .= "Failed: " bulkResult.failed " ✗`n`n"

if (bulkResult.success > 0) {
    output .= "Successfully Modified:`n"
    for file in bulkResult.files {
        if (file.status = "success")
        output .= "  • " file.name "`n"
    }
}

MsgBox(output, "Bulk Operation", "Icon!")

; Clean up read-only
FileSetAttrib("-R", testDir "\*.txt")

; ============================================================
; Example 2: Recursive Bulk Operations
; ============================================================

/**
* Set attributes recursively in directory tree
*
* @param {String} dirPath - Root directory
* @param {String} pattern - File pattern
* @param {String} attributes - Attributes to set
* @returns {Object} - Operation result
*/
RecursiveBulkSet(dirPath, pattern, attributes) {
    result := {
        processed: 0,
        success: 0,
        failed: 0,
        directories: []
    }

    if (!DirExist(dirPath))
    return result

    ; Process files recursively
    Loop Files, dirPath "\" pattern, "FR" {
        result.processed++
        try {
            FileSetAttrib(attributes, A_LoopFilePath)
            result.success++

            ; Track which directories were processed
            SplitPath(A_LoopFilePath, , &fileDir)
            if (!ArrayContains(result.directories, fileDir))
            result.directories.Push(fileDir)
        } catch {
            result.failed++
        }
    }

    return result
}

ArrayContains(arr, value) {
    for item in arr {
        if (item = value)
        return true
    }
    return false
}

; Create subdirectories with files
DirCreate(testDir "\Sub1")
DirCreate(testDir "\Sub2")

Loop 2 {
    FileAppend("Sub1 file", testDir "\Sub1\file" A_Index ".txt")
    FileAppend("Sub2 file", testDir "\Sub2\file" A_Index ".txt")
}

; Recursive operation
recursiveResult := RecursiveBulkSet(testDir, "*.txt", "+H")

output := "RECURSIVE BULK OPERATION:`n`n"
output .= "Root: " testDir "`n"
output .= "Pattern: *.txt`n"
output .= "Operation: +H (Add Hidden)`n`n"
output .= "Files Processed: " recursiveResult.processed "`n"
output .= "Success: " recursiveResult.success "`n"
output .= "Directories Affected: " recursiveResult.directories.Length

MsgBox(output, "Recursive Operation", "Icon!")

FileSetAttrib("-H", testDir "\*.txt", "R")

; ============================================================
; Example 3: Batch Protection System
; ============================================================

/**
* Protect multiple files with rollback capability
*/
class BatchProtection {
    __New() {
        this.changes := []
    }

    ProtectFiles(files) {
        result := {
            success: 0,
            failed: 0
        }

        for filePath in files {
            if (!FileExist(filePath))
            continue

            ; Store original attributes for rollback
            originalAttrs := FileGetAttrib(filePath)

            try {
                FileSetAttrib("+R", filePath)
                result.success++

                this.changes.Push({
                    path: filePath,
                    original: originalAttrs,
                    current: FileGetAttrib(filePath)
                })
            } catch {
                result.failed++
            }
        }

        return result
    }

    Rollback() {
        rolled := 0

        for change in this.changes {
            try {
                FileSetAttrib("^" change.original, change.path)
                rolled++
            }
        }

        this.changes := []
        return rolled
    }

    GetReport() {
        report := "PROTECTION CHANGES:`n`n"
        report .= "Files Modified: " this.changes.Length "`n`n"

        for change in this.changes {
            SplitPath(change.path, &name)
            report .= name ":`n"
            report .= "  Before: " change.original "`n"
            report .= "  After: " change.current "`n`n"
        }

        return report
    }
}

; Test batch protection
fileList := []
Loop Files, testDir "\*.txt", "FR"
fileList.Push(A_LoopFilePath)

batchProt := BatchProtection()
protResult := batchProt.ProtectFiles(fileList)

MsgBox("BATCH PROTECTION:`n`n"
. "Files Protected: " protResult.success "`n"
. "Failed: " protResult.failed "`n`n"
. batchProt.GetReport(),
"Batch Protection", "Icon!")

; Rollback
rolled := batchProt.Rollback()
MsgBox("ROLLBACK COMPLETE:`n`n"
. "Files Restored: " rolled,
"Rollback", "Icon!")

; ============================================================
; Example 4: Progress Tracking for Bulk Operations
; ============================================================

/**
* Bulk operation with progress tracking
*
* @param {String} dirPath - Directory to process
* @param {String} attributes - Attributes to set
* @param {Function} progressCallback - Progress callback function
* @returns {Object} - Operation result
*/
BulkSetWithProgress(dirPath, attributes, progressCallback := "") {
    result := {
        total: 0,
        processed: 0,
        success: 0,
        failed: 0
    }

    if (!DirExist(dirPath))
    return result

    ; Count files first
    Loop Files, dirPath "\*.*", "FR"
    result.total++

    ; Process files
    Loop Files, dirPath "\*.*", "FR" {
        result.processed++

        try {
            FileSetAttrib(attributes, A_LoopFilePath)
            result.success++
        } catch {
            result.failed++
        }

        ; Call progress callback
        if (progressCallback) {
            percent := Round((result.processed / result.total) * 100)
            progressCallback(percent, result.processed, result.total)
        }
    }

    return result
}

; Progress callback function
ShowProgress(percent, current, total) {
    ; In real application, would update GUI progress bar
    ; For demo, we'll just track it
    global lastProgress := percent
}

; Run with progress tracking
progressResult := BulkSetWithProgress(testDir, "+A", ShowProgress)

output := "BULK OPERATION WITH PROGRESS:`n`n"
output .= "Total Files: " progressResult.total "`n"
output .= "Processed: " progressResult.processed "`n"
output .= "Success: " progressResult.success "`n"
output .= "Failed: " progressResult.failed "`n"
output .= "Progress: 100%"

MsgBox(output, "Progress Tracking", "Icon!")

; ============================================================
; Example 5: Conditional Bulk Operations
; ============================================================

/**
* Apply attributes based on conditions
*
* @param {String} dirPath - Directory to process
* @param {Function} condition - Condition function
* @param {String} attributes - Attributes if condition true
* @returns {Object} - Operation result
*/
ConditionalBulkSet(dirPath, condition, attributes) {
    result := {
        scanned: 0,
        matched: 0,
        modified: 0,
        skipped: 0
    }

    if (!DirExist(dirPath))
    return result

    Loop Files, dirPath "\*.*", "FR" {
        result.scanned++

        if (condition(A_LoopFilePath, A_LoopFileSize, FileGetTime(A_LoopFilePath, "M"))) {
            result.matched++
            try {
                FileSetAttrib(attributes, A_LoopFilePath)
                result.modified++
            }
        } else {
            result.skipped++
        }
    }

    return result
}

; Condition: Files larger than 100 bytes
LargeFileCondition(path, size, time) {
    return size > 100
}

; Apply to large files only
condResult := ConditionalBulkSet(testDir, LargeFileCondition, "+R")

output := "CONDITIONAL BULK OPERATION:`n`n"
output .= "Condition: File size > 100 bytes`n`n"
output .= "Files Scanned: " condResult.scanned "`n"
output .= "Matched Condition: " condResult.matched "`n"
output .= "Modified: " condResult.modified "`n"
output .= "Skipped: " condResult.skipped

MsgBox(output, "Conditional Bulk", "Icon!")

FileSetAttrib("-R", testDir "\*.*", "R")

; ============================================================
; Example 6: Bulk Attribute Verification
; ============================================================

/**
* Verify bulk attribute operation
*
* @param {String} dirPath - Directory to verify
* @param {String} expectedAttrib - Expected attribute
* @returns {Object} - Verification result
*/
VerifyBulkOperation(dirPath, expectedAttrib) {
    result := {
        total: 0,
        compliant: 0,
        nonCompliant: [],
        percentage: 0
    }

    if (!DirExist(dirPath))
    return result

    Loop Files, dirPath "\*.*", "FR" {
        result.total++
        attrs := FileGetAttrib(A_LoopFilePath)

        if (InStr(attrs, expectedAttrib)) {
            result.compliant++
        } else {
            result.nonCompliant.Push({
                name: A_LoopFileName,
                path: A_LoopFilePath,
                attributes: attrs
            })
        }
    }

    result.percentage := result.total > 0
    ? Round((result.compliant / result.total) * 100)
    : 0

    return result
}

; Set and verify
FileSetAttrib("+A", testDir "\*.*", "R")
verification := VerifyBulkOperation(testDir, "A")

output := "BULK OPERATION VERIFICATION:`n`n"
output .= "Expected Attribute: A (Archive)`n`n"
output .= "Total Files: " verification.total "`n"
output .= "Compliant: " verification.compliant "`n"
output .= "Non-Compliant: " verification.nonCompliant.Length "`n"
output .= "Success Rate: " verification.percentage "%`n`n"

if (verification.nonCompliant.Length > 0) {
    output .= "Non-Compliant Files:`n"
    for file in verification.nonCompliant
    output .= "  • " file.name " (" file.attributes ")`n"
}

MsgBox(output, "Verification", "Icon!")

; ============================================================
; Example 7: Optimized Bulk Processing
; ============================================================

/**
* Optimized bulk attribute setting
*
* @param {String} dirPath - Directory to process
* @param {String} attributes - Attributes to set
* @param {Object} options - Processing options
* @returns {Object} - Operation result
*/
OptimizedBulkSet(dirPath, attributes, options := "") {
    if (!options)
    options := {batchSize: 100, skipErrors: true, recurse: true}

    result := {
        processed: 0,
        success: 0,
        errors: []
    }

    if (!DirExist(dirPath))
    return result

    recurseFlag := options.recurse ? "FR" : "F"

    Loop Files, dirPath "\*.*", recurseFlag {
        result.processed++

        try {
            FileSetAttrib(attributes, A_LoopFilePath)
            result.success++
        } catch Error as err {
            if (!options.skipErrors)
            throw err

            result.errors.Push({
                file: A_LoopFileName,
                error: err.Message
            })
        }

        ; Batch processing (simulated)
        if (Mod(result.processed, options.batchSize) = 0) {
            ; In real application, could pause or update UI
            Sleep(10)
        }
    }

    return result
}

; Optimized bulk operation
optOptions := {
    batchSize: 50,
    skipErrors: true,
    recurse: true
}

optResult := OptimizedBulkSet(testDir, "-A", optOptions)

output := "OPTIMIZED BULK PROCESSING:`n`n"
output .= "Files Processed: " optResult.processed "`n"
output .= "Success: " optResult.success "`n"
output .= "Errors: " optResult.errors.Length "`n`n"
output .= "Operation completed with error handling"

MsgBox(output, "Optimized Bulk", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
BULK ATTRIBUTE OPERATIONS:

Bulk Operations Syntax:
; Using file pattern
FileSetAttrib('+R', 'C:\Folder\*.txt')

; Recursive with Loop Files
Loop Files, 'C:\Folder\*.*', 'FR' {
    FileSetAttrib('+R', A_LoopFilePath)
}

Best Practices:

1. Error Handling:
• Use try-catch in loops
• Track successes and failures
• Log errors for review
• Implement rollback if needed

2. Performance:
• Batch operations
• Use patterns when possible
• Consider progress updates
• Optimize loop logic

3. Safety:
• Validate paths first
• Test on small set first
• Store original states
• Implement undo/rollback
• Verify after operation

4. Progress Tracking:
• Count files first
• Update progress regularly
• Show current operation
• Estimate time remaining

Common Patterns:

Bulk Protect:
FileSetAttrib('+R', 'C:\Docs\*.doc*')

Bulk Hide:
Loop Files, path '\*.*', 'FR'
FileSetAttrib('+H', A_LoopFilePath)

Conditional Bulk:
Loop Files, path '\*.*', 'F' {
    if (A_LoopFileSize > 1000000)
    FileSetAttrib('+A', A_LoopFilePath)
}

With Verification:
FileSetAttrib('+R', pattern)
Loop Files, pattern
verify FileGetAttrib() includes 'R'

Performance Tips:
• Use FileSetAttrib() with patterns
• Minimize attribute checks
• Batch UI updates
• Handle errors efficiently
• Cache file lists if needed

Use Cases:
✓ Mass file protection
✓ Backup preparation
✓ Organization automation
✓ Security enforcement
✓ Archive management
✓ Cleanup operations
)"

MsgBox(info, "Bulk Operations Reference", "Icon!")

; Cleanup
DirDelete(testDir, true)
