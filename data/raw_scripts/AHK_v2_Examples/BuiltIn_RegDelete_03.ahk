#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 Registry Delete Examples - Part 3
 * ============================================================================
 *
 * This file demonstrates comprehensive registry cleanup strategies including
 * safe deletion, rollback capabilities, and automated cleanup workflows.
 *
 * @description Registry cleanup and safe deletion strategies
 * @author AHK v2 Examples Collection
 * @version 1.0.0
 * @date 2024-01-15
 */

; ============================================================================
; EXAMPLE 1: Safe Deletion with Undo
; ============================================================================

/**
 * @class UndoableDelete
 * @description Performs deletions with undo capability
 */
class UndoableDelete {
    undoStack := []
    maxUndoLevels := 10

    /**
     * @method DeleteWithUndo
     * @description Deletes a value and saves for undo
     * @param {String} keyPath - Registry key path
     * @param {String} valueName - Value name
     * @returns {Boolean} Success status
     */
    DeleteWithUndo(keyPath, valueName) {
        try {
            ; Save current value
            value := RegRead(keyPath, valueName)

            ; Delete it
            RegDelete keyPath, valueName

            ; Add to undo stack
            this.undoStack.Push(Map(
                "keyPath", keyPath,
                "valueName", valueName,
                "value", value,
                "timestamp", A_Now
            ))

            ; Maintain max undo levels
            while (this.undoStack.Length > this.maxUndoLevels) {
                this.undoStack.RemoveAt(1)
            }

            return true
        } catch {
            return false
        }
    }

    /**
     * @method Undo
     * @description Undoes the last deletion
     * @returns {Boolean} Success status
     */
    Undo() {
        if (this.undoStack.Length = 0)
            return false

        try {
            ; Pop last operation
            lastOp := this.undoStack.Pop()

            ; Restore value
            RegWrite lastOp["value"], "REG_SZ", lastOp["keyPath"], lastOp["valueName"]

            return true
        } catch {
            return false
        }
    }

    /**
     * @method CanUndo
     * @description Checks if undo is available
     * @returns {Boolean} Can undo status
     */
    CanUndo() {
        return this.undoStack.Length > 0
    }

    /**
     * @method GetUndoInfo
     * @description Gets information about available undos
     * @returns {String} Undo information
     */
    GetUndoInfo() {
        if (this.undoStack.Length = 0)
            return "No undo history available"

        info := "Undo History (" . this.undoStack.Length . " operations):`n"
        info .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

        for op in this.undoStack {
            info .= op["valueName"] . " at " . op["timestamp"] . "`n"
        }

        return info
    }
}

/**
 * @function Example1_UndoableDeletion
 * @description Demonstrates undoable deletion
 * @returns {void}
 */
Example1_UndoableDeletion() {
    MsgBox "=== Example 1: Undoable Deletion ===`n`n" .
           "Testing deletion with undo capability..."

    testKey := "HKCU\Software\AHKv2Examples\UndoTest"
    undo := UndoableDelete()

    ; Create test data
    try {
        RegWrite "Important Data 1", "REG_SZ", testKey, "Value1"
        RegWrite "Important Data 2", "REG_SZ", testKey, "Value2"
    }

    ; Delete with undo
    undo.DeleteWithUndo(testKey, "Value1")
    MsgBox "Deleted Value1", "Deleted"

    ; Show undo info
    info := undo.GetUndoInfo()
    MsgBox info, "Undo Available"

    ; Undo the deletion
    if (undo.Undo()) {
        MsgBox "Successfully restored Value1", "Undo Complete"
    }
}

; ============================================================================
; EXAMPLE 2: Transactional Deletion
; ============================================================================

/**
 * @class TransactionalDelete
 * @description Performs transactional deletions with rollback
 */
class TransactionalDelete {
    transaction := []
    backup := Map()

    /**
     * @method BeginTransaction
     * @description Begins a deletion transaction
     */
    BeginTransaction() {
        this.transaction := []
        this.backup := Map()
    }

    /**
     * @method AddDeletion
     * @description Adds a deletion to the transaction
     * @param {String} keyPath - Registry key path
     * @param {String} valueName - Value name
     */
    AddDeletion(keyPath, valueName) {
        this.transaction.Push(Map(
            "keyPath", keyPath,
            "valueName", valueName
        ))
    }

    /**
     * @method Commit
     * @description Commits the transaction
     * @returns {Map} Result
     */
    Commit() {
        result := Map(
            "success", false,
            "deleted", 0,
            "failed", 0,
            "errors", []
        )

        ; Backup all values first
        for op in this.transaction {
            try {
                value := RegRead(op["keyPath"], op["valueName"])
                this.backup[op["keyPath"] . "\" . op["valueName"]] := value
            } catch {
                ; Value doesn't exist
            }
        }

        ; Try to delete all
        for op in this.transaction {
            try {
                RegDelete op["keyPath"], op["valueName"]
                result["deleted"]++
            } catch Error as err {
                result["failed"]++
                result["errors"].Push(err.Message)

                ; Rollback on any failure
                this.Rollback()
                return result
            }
        }

        result["success"] := true
        this.backup := Map()  ; Clear backup on success

        return result
    }

    /**
     * @method Rollback
     * @description Rolls back the transaction
     */
    Rollback() {
        for fullPath, value in this.backup {
            parts := StrSplit(fullPath, "\")
            valueName := parts.Pop()
            keyPath := ""
            for part in parts {
                keyPath .= (keyPath = "" ? "" : "\") . part
            }

            try {
                RegWrite value, "REG_SZ", keyPath, valueName
            }
        }
    }
}

/**
 * @function Example2_TransactionalDelete
 * @description Demonstrates transactional deletion
 * @returns {void}
 */
Example2_TransactionalDelete() {
    MsgBox "=== Example 2: Transactional Deletion ===`n`n" .
           "Testing all-or-nothing deletion..."

    testKey := "HKCU\Software\AHKv2Examples\TransactionTest"

    ; Create test data
    try {
        RegWrite "Data 1", "REG_SZ", testKey, "Val1"
        RegWrite "Data 2", "REG_SZ", testKey, "Val2"
        RegWrite "Data 3", "REG_SZ", testKey, "Val3"
    }

    ; Create and execute transaction
    trans := TransactionalDelete()
    trans.BeginTransaction()
    trans.AddDeletion(testKey, "Val1")
    trans.AddDeletion(testKey, "Val2")
    trans.AddDeletion(testKey, "Val3")

    result := trans.Commit()

    report := "Transaction Results:`n"
    report .= "━━━━━━━━━━━━━━━━━━━━`n"
    report .= "Deleted: " . result["deleted"] . "`n"
    report .= "Failed: " . result["failed"] . "`n"
    report .= "Status: " . (result["success"] ? "✓ Success" : "✗ Failed")

    MsgBox report, "Transaction Complete"
}

; ============================================================================
; EXAMPLE 3: Scheduled Cleanup Tasks
; ============================================================================

/**
 * @function Example3_ScheduledCleanup
 * @description Demonstrates scheduled cleanup configuration
 * @returns {void}
 */
Example3_ScheduledCleanup() {
    MsgBox "=== Example 3: Scheduled Cleanup ===`n`n" .
           "Configuring scheduled cleanup tasks..."

    schedKey := "HKCU\Software\AHKv2Examples\ScheduledCleanup"

    ; Configure cleanup schedule
    try {
        RegWrite 1, "REG_DWORD", schedKey, "Enabled"
        RegWrite "Daily", "REG_SZ", schedKey, "Frequency"
        RegWrite "02:00", "REG_SZ", schedKey, "RunTime"
        RegWrite 30, "REG_DWORD", schedKey, "DeleteOlderThanDays"
        RegWrite 1, "REG_DWORD", schedKey, "CleanTempFiles"
        RegWrite 1, "REG_DWORD", schedKey, "CleanCache"
        RegWrite 0, "REG_DWORD", schedKey, "CleanBackups"
    }

    result := "Scheduled Cleanup Configuration:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
    result .= "Status: Enabled`n"
    result .= "Frequency: Daily at 02:00`n"
    result .= "Delete files older than: 30 days`n"
    result .= "Clean temp files: Yes`n"
    result .= "Clean cache: Yes`n"
    result .= "Clean backups: No"

    MsgBox result, "Schedule Configured"
}

; ============================================================================
; EXAMPLE 4: Smart Cleanup Based on Size
; ============================================================================

/**
 * @function Example4_SizeBasedCleanup
 * @description Cleans up entries to maintain size limits
 * @returns {void}
 */
Example4_SizeBasedCleanup() {
    MsgBox "=== Example 4: Size-Based Cleanup ===`n`n" .
           "Cleaning up to maintain size limits..."

    testKey := "HKCU\Software\AHKv2Examples\SizeCleanupTest"

    ; Create test entries
    entriesCreated := 0
    try {
        Loop 20 {
            RegWrite "Data " . A_Index, "REG_SZ", testKey . "\Entry" . A_Index, "Data"
            RegWrite A_Now, "REG_SZ", testKey . "\Entry" . A_Index, "Created"
            entriesCreated++
        }
    }

    MsgBox "Created " . entriesCreated . " test entries", "Entries Created"

    ; Keep only 10 newest entries
    maxEntries := 10
    entries := []

    ; Collect all entries with timestamps
    try {
        Loop Reg, testKey, "K"
        {
            entryKey := testKey . "\" . A_LoopRegName
            try {
                created := RegRead(entryKey, "Created")
                entries.Push(Map("key", entryKey, "created", created, "name", A_LoopRegName))
            }
        }
    }

    ; Sort by timestamp (newest first)
    sorted := []
    for entry in entries {
        sorted.Push(entry)
    }

    ; Delete oldest entries
    deleted := 0
    if (sorted.Length > maxEntries) {
        entriesToDelete := sorted.Length - maxEntries
        for i in Range(entriesToDelete) {
            try {
                RegDeleteKey sorted[i]["key"]
                deleted++
            }
        }
    }

    result := "Size-Based Cleanup Results:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
    result .= "Initial Entries: " . entriesCreated . "`n"
    result .= "Max Allowed: " . maxEntries . "`n"
    result .= "Deleted: " . deleted . "`n"
    result .= "Remaining: " . (sorted.Length - deleted)

    MsgBox result, "Cleanup Complete"
}

; Helper function
Range(n) {
    arr := []
    Loop n {
        arr.Push(A_Index)
    }
    return arr
}

; ============================================================================
; EXAMPLE 5: Cleanup Verification and Reporting
; ============================================================================

/**
 * @class CleanupVerifier
 * @description Verifies cleanup operations
 */
class CleanupVerifier {
    /**
     * @method VerifyDeletion
     * @description Verifies that a value was deleted
     * @param {String} keyPath - Registry key path
     * @param {String} valueName - Value name
     * @returns {Map} Verification result
     */
    static VerifyDeletion(keyPath, valueName) {
        result := Map(
            "deleted", false,
            "verified", false
        )

        try {
            RegRead(keyPath, valueName)
            result["deleted"] := false
        } catch {
            result["deleted"] := true
            result["verified"] := true
        }

        return result
    }

    /**
     * @method GenerateReport
     * @description Generates cleanup report
     * @param {Array} deletions - List of deletions to verify
     * @returns {String} Verification report
     */
    static GenerateReport(deletions) {
        report := "Cleanup Verification Report:`n"
        report .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"

        verified := 0
        failed := 0

        for deletion in deletions {
            result := this.VerifyDeletion(deletion["keyPath"], deletion["valueName"])

            if (result["verified"]) {
                report .= "✓ Verified: " . deletion["valueName"] . "`n"
                verified++
            } else {
                report .= "✗ Still Exists: " . deletion["valueName"] . "`n"
                failed++
            }
        }

        report .= "`nSummary:`n"
        report .= "Verified: " . verified . "`n"
        report .= "Failed: " . failed

        return report
    }
}

/**
 * @function Example5_CleanupVerification
 * @description Demonstrates cleanup verification
 * @returns {void}
 */
Example5_CleanupVerification() {
    MsgBox "=== Example 5: Cleanup Verification ===`n`n" .
           "Verifying cleanup operations..."

    testKey := "HKCU\Software\AHKv2Examples\VerifyTest"

    ; Create and delete values
    deletions := []

    try {
        ; Create values
        RegWrite "Data 1", "REG_SZ", testKey, "Val1"
        RegWrite "Data 2", "REG_SZ", testKey, "Val2"

        ; Delete them
        RegDelete testKey, "Val1"
        deletions.Push(Map("keyPath", testKey, "valueName", "Val1"))

        RegDelete testKey, "Val2"
        deletions.Push(Map("keyPath", testKey, "valueName", "Val2"))
    }

    ; Verify deletions
    report := CleanupVerifier.GenerateReport(deletions)
    MsgBox report, "Verification Report"
}

; ============================================================================
; EXAMPLE 6: Cleanup Dry Run Mode
; ============================================================================

/**
 * @class DryRunCleanup
 * @description Simulates cleanup without actually deleting
 */
class DryRunCleanup {
    dryRun := true
    operations := []

    /**
     * @method SetDryRun
     * @description Enables or disables dry run mode
     */
    SetDryRun(enabled) {
        this.dryRun := enabled
        this.operations := []
    }

    /**
     * @method DeleteValue
     * @description Deletes or simulates deletion of a value
     * @param {String} keyPath - Registry key path
     * @param {String} valueName - Value name
     * @returns {Boolean} Success status
     */
    DeleteValue(keyPath, valueName) {
        this.operations.Push(Map(
            "type", "DeleteValue",
            "keyPath", keyPath,
            "valueName", valueName,
            "executed", !this.dryRun
        ))

        if (!this.dryRun) {
            try {
                RegDelete keyPath, valueName
                return true
            } catch {
                return false
            }
        }

        return true  ; Dry run always "succeeds"
    }

    /**
     * @method GetReport
     * @description Gets dry run report
     * @returns {String} Report
     */
    GetReport() {
        mode := this.dryRun ? "DRY RUN" : "LIVE"
        report := mode . " Mode Report:`n"
        report .= "━━━━━━━━━━━━━━━━━━━━`n`n"

        for op in this.operations {
            prefix := op["executed"] ? "DELETED:" : "WOULD DELETE:"
            report .= prefix . " " . op["keyPath"] . "\" . op["valueName"] . "`n"
        }

        return report
    }
}

/**
 * @function Example6_DryRun
 * @description Demonstrates dry run cleanup
 * @returns {void}
 */
Example6_DryRun() {
    MsgBox "=== Example 6: Dry Run Mode ===`n`n" .
           "Testing cleanup in dry run mode..."

    testKey := "HKCU\Software\AHKv2Examples\DryRunTest"
    cleanup := DryRunCleanup()

    ; Create test data
    try {
        RegWrite "Data 1", "REG_SZ", testKey, "Val1"
        RegWrite "Data 2", "REG_SZ", testKey, "Val2"
    }

    ; Enable dry run
    cleanup.SetDryRun(true)
    cleanup.DeleteValue(testKey, "Val1")
    cleanup.DeleteValue(testKey, "Val2")

    ; Show dry run report
    report := cleanup.GetReport()
    MsgBox report, "Dry Run Report"

    ; Now execute for real
    cleanup.SetDryRun(false)
    cleanup.DeleteValue(testKey, "Val1")
    cleanup.DeleteValue(testKey, "Val2")

    report := cleanup.GetReport()
    MsgBox report, "Live Execution Report"
}

; ============================================================================
; EXAMPLE 7: Comprehensive Cleanup Workflow
; ============================================================================

/**
 * @function Example7_ComprehensiveCleanup
 * @description Demonstrates complete cleanup workflow
 * @returns {void}
 */
Example7_ComprehensiveCleanup() {
    MsgBox "=== Example 7: Comprehensive Cleanup ===`n`n" .
           "Running comprehensive cleanup workflow..."

    baseKey := "HKCU\Software\AHKv2Examples\ComprehensiveCleanup"

    ; Create test structure
    try {
        ; Current data
        RegWrite "Current", "REG_SZ", baseKey . "\Current", "Data"

        ; Old data
        oldDate := DateAdd(A_Now, -60, "Days")
        RegWrite oldDate, "REG_SZ", baseKey . "\Old1", "Created"
        RegWrite "Old Data", "REG_SZ", baseKey . "\Old1", "Data"

        ; Temp data
        RegWrite "Temp", "REG_SZ", baseKey . "\Temp1", "Data"

        ; Cache data
        expiredDate := DateAdd(A_Now, -1, "Days")
        RegWrite expiredDate, "REG_SZ", baseKey . "\Cache1", "ExpiresAt"
    }

    results := Map(
        "oldEntries", 0,
        "tempEntries", 0,
        "expiredCache", 0
    )

    ; Clean old entries (>30 days)
    cutoff := DateAdd(A_Now, -30, "Days")
    try {
        Loop Reg, baseKey, "K"
        {
            subKey := baseKey . "\" . A_LoopRegName
            try {
                created := RegRead(subKey, "Created")
                if (created < cutoff) {
                    RegDeleteKey subKey
                    results["oldEntries"]++
                }
            }
        }
    }

    ; Clean temp entries
    try {
        Loop Reg, baseKey, "K"
        {
            if (InStr(A_LoopRegName, "Temp")) {
                RegDeleteKey baseKey . "\" . A_LoopRegName
                results["tempEntries"]++
            }
        }
    }

    ; Clean expired cache
    try {
        Loop Reg, baseKey, "K"
        {
            subKey := baseKey . "\" . A_LoopRegName
            try {
                expires := RegRead(subKey, "ExpiresAt")
                if (A_Now > expires) {
                    RegDeleteKey subKey
                    results["expiredCache"]++
                }
            }
        }
    }

    ; Generate report
    report := "Comprehensive Cleanup Results:`n"
    report .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
    report .= "Old Entries Removed: " . results["oldEntries"] . "`n"
    report .= "Temp Entries Removed: " . results["tempEntries"] . "`n"
    report .= "Expired Cache Removed: " . results["expiredCache"] . "`n`n"
    report .= "Total Cleaned: " . (results["oldEntries"] + results["tempEntries"] + results["expiredCache"])

    MsgBox report, "Cleanup Complete"
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMenu() {
    menu := "
    (
    AutoHotkey v2 - RegDelete Safe Cleanup
    ═══════════════════════════════════════

    1. Undoable Deletion
    2. Transactional Deletion
    3. Scheduled Cleanup
    4. Size-Based Cleanup
    5. Cleanup Verification
    6. Dry Run Mode
    7. Comprehensive Cleanup

    0. Exit

    Select an example (1-7):
    )"

    choice := InputBox(menu, "RegDelete Safe Cleanup").Value

    switch choice {
        case "1": Example1_UndoableDeletion()
        case "2": Example2_TransactionalDelete()
        case "3": Example3_ScheduledCleanup()
        case "4": Example4_SizeBasedCleanup()
        case "5": Example5_CleanupVerification()
        case "6": Example6_DryRun()
        case "7": Example7_ComprehensiveCleanup()
        case "0": ExitApp()
        default:
            MsgBox "Invalid selection!", "Error"
            return
    }

    ; Show menu again
    SetTimer(() => ShowMenu(), -1000)
}

; Start the menu
ShowMenu()
