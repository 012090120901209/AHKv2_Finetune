#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 Registry Delete Examples - Part 2
 * ============================================================================
 * 
 * This file demonstrates advanced registry deletion scenarios including
 * batch cleanup, pattern matching, and registry maintenance.
 * 
 * @description Advanced registry deletion techniques
 * @author AHK v2 Examples Collection
 * @version 1.0.0
 * @date 2024-01-15
 */

; ============================================================================
; EXAMPLE 1: Pattern-Based Deletion
; ============================================================================

/**
 * @class PatternDelete
 * @description Deletes registry values matching patterns
 */
class PatternDelete {
    /**
     * @method DeleteByPattern
     * @description Deletes values matching a pattern
     * @param {String} keyPath - Registry key path
     * @param {String} pattern - Pattern to match (supports * wildcard)
     * @returns {Map} Deletion result
     */
    static DeleteByPattern(keyPath, pattern) {
        result := Map(
            "scanned", 0,
            "matched", 0,
            "deleted", 0,
            "failed", 0,
            "details", []
        )

        ; Convert pattern to regex
        regexPattern := StrReplace(pattern, "*", ".*")
        regexPattern := "^" . regexPattern . "$"

        try {
            Loop Reg, keyPath, "V"
            {
                valueName := A_LoopRegName
                result["scanned"]++

                ; Check if matches pattern
                if (RegExMatch(valueName, regexPattern)) {
                    result["matched"]++

                    try {
                        RegDelete keyPath, valueName
                        result["deleted"]++
                        result["details"].Push(Map(
                            "name", valueName,
                            "status", "Deleted"
                        ))
                    } catch Error as err {
                        result["failed"]++
                        result["details"].Push(Map(
                            "name", valueName,
                            "status", "Failed",
                            "error", err.Message
                        ))
                    }
                }
            }
        }

        return result
    }

    /**
     * @method GetReport
     * @description Formats deletion report
     */
    static GetReport(result) {
        report := "Pattern-Based Deletion Report:`n"
        report .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
        report .= "Scanned: " . result["scanned"] . "`n"
        report .= "Matched: " . result["matched"] . "`n"
        report .= "Deleted: " . result["deleted"] . "`n"
        report .= "Failed: " . result["failed"] . "`n`n"

        if (result["details"].Length > 0) {
            report .= "Details:`n"
            for detail in result["details"] {
                status := detail["status"] = "Deleted" ? "✓" : "✗"
                report .= status . " " . detail["name"] . "`n"
            }
        }

        return report
    }
}

/**
 * @function Example1_PatternDeletion
 * @description Demonstrates pattern-based deletion
 * @returns {void}
 */
Example1_PatternDeletion() {
    MsgBox "=== Example 1: Pattern-Based Deletion ===`n`n" .
        "Deleting values matching patterns..."

    testKey := "HKCU\Software\AHKv2Examples\PatternTest"

    ; Create test values
    try {
        RegWrite "Value", "REG_SZ", testKey, "Temp_File1"
        RegWrite "Value", "REG_SZ", testKey, "Temp_File2"
        RegWrite "Value", "REG_SZ", testKey, "Temp_Cache1"
        RegWrite "Value", "REG_SZ", testKey, "Keep_Setting1"
        RegWrite "Value", "REG_SZ", testKey, "Keep_Setting2"
        RegWrite "Value", "REG_SZ", testKey, "Cache_Data"
    }

    ; Delete all "Temp_*" entries
    result := PatternDelete.DeleteByPattern(testKey, "Temp_*")
    report := PatternDelete.GetReport(result)

    MsgBox report, "Pattern Deletion Results"
}

; ============================================================================
; EXAMPLE 2: Batch Cleanup Operations
; ============================================================================

/**
 * @class BatchCleanup
 * @description Performs batch cleanup operations
 */
class BatchCleanup {
    cleanupLog := []

    /**
     * @method AddCleanupTask
     * @description Adds a cleanup task
     * @param {String} keyPath - Registry key path
     * @param {String} valueName - Value name (empty for entire key)
     * @param {String} type - "value" or "key"
     */
    AddCleanupTask(keyPath, valueName := "", type := "value") {
        this.cleanupLog.Push(Map(
            "keyPath", keyPath,
            "valueName", valueName,
            "type", type,
            "status", "Pending"
        ))
    }

    /**
     * @method ExecuteCleanup
     * @description Executes all cleanup tasks
     * @returns {Map} Execution result
     */
    ExecuteCleanup() {
        result := Map(
            "total", this.cleanupLog.Length,
            "completed", 0,
            "failed", 0
        )

        for task in this.cleanupLog {
            try {
                if (task["type"] = "value") {
                    RegDelete task["keyPath"], task["valueName"]
                } else if (task["type"] = "key") {
                    RegDeleteKey task["keyPath"]
                }

                task["status"] := "Completed"
                result["completed"]++

            } catch Error as err {
                task["status"] := "Failed"
                task["error"] := err.Message
                result["failed"]++
            }
        }

        return result
    }

    /**
     * @method GetCleanupReport
     * @description Gets cleanup report
     */
    GetCleanupReport() {
        report := "Batch Cleanup Report:`n"
        report .= "━━━━━━━━━━━━━━━━━━━━`n`n"

        for task in this.cleanupLog {
            status := task["status"] = "Completed" ? "✓" : "✗"
            report .= status . " " . task["type"] . ": " . task["keyPath"]

            if (task["valueName"] != "")
                report .= "\" . task["valueName"]

            report .= "`n"

            if (task.Has("error"))
                report .= "  Error: " . task["error"] . "`n"
        }

        return report
    }
}

/**
 * @function Example2_BatchCleanup
 * @description Demonstrates batch cleanup operations
 * @returns {void}
 */
Example2_BatchCleanup() {
    MsgBox "=== Example 2: Batch Cleanup ===`n`n" .
        "Performing batch cleanup operations..."

    testKey := "HKCU\Software\AHKv2Examples\BatchCleanupTest"

    ; Create test data
    try {
        RegWrite "Value", "REG_SZ", testKey, "Item1"
        RegWrite "Value", "REG_SZ", testKey, "Item2"
        RegWrite "Value", "REG_SZ", testKey . "\SubKey1", "SubItem1"
        RegWrite "Value", "REG_SZ", testKey . "\SubKey2", "SubItem2"
    }

    ; Setup batch cleanup
    cleanup := BatchCleanup()
    cleanup.AddCleanupTask(testKey, "Item1", "value")
    cleanup.AddCleanupTask(testKey, "Item2", "value")
    cleanup.AddCleanupTask(testKey . "\SubKey1", "", "key")

    ; Execute
    result := cleanup.ExecuteCleanup()
    report := cleanup.GetCleanupReport()

    MsgBox "Completed: " . result["completed"] . "/" . result["total"] . "`n`n" . report,
        "Batch Cleanup Results"
}

; ============================================================================
; EXAMPLE 3: Orphaned Entry Cleanup
; ============================================================================

/**
 * @function Example3_OrphanedCleanup
 * @description Finds and cleans up orphaned registry entries
 * @returns {void}
 */
Example3_OrphanedCleanup() {
    MsgBox "=== Example 3: Orphaned Entry Cleanup ===`n`n" .
        "Finding and cleaning orphaned entries..."

    baseKey := "HKCU\Software\AHKv2Examples\OrphanedTest"

    ; Create entries with file references
    try {
        RegWrite "C:\NonExistent\file1.txt", "REG_SZ", baseKey, "File1"
        RegWrite "C:\Windows\notepad.exe", "REG_SZ", baseKey, "File2"
        RegWrite "C:\FakeFolder\app.exe", "REG_SZ", baseKey, "File3"
    }

    orphaned := []
    valid := []

    ; Check each entry
    try {
        Loop Reg, baseKey, "V"
        {
            valueName := A_LoopRegName
            try {
                filePath := RegRead(baseKey, valueName)

                ; Check if file exists
                if (FileExist(filePath)) {
                    valid.Push(valueName)
                } else {
                    orphaned.Push(valueName)
                    ; Delete orphaned entry
                    RegDelete baseKey, valueName
                }
            }
        }
    }

    result := "Orphaned Entry Cleanup:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━`n"
    result .= "Valid Entries: " . valid.Length . "`n"
    result .= "Orphaned (Deleted): " . orphaned.Length . "`n`n"

    if (orphaned.Length > 0) {
        result .= "Deleted Orphaned Entries:`n"
        for entry in orphaned {
            result .= "  • " . entry . "`n"
        }
    }

    MsgBox result, "Cleanup Complete"
}

; ============================================================================
; EXAMPLE 4: Cache Expiration Cleanup
; ============================================================================

/**
 * @class CacheExpiration
 * @description Manages cache expiration and cleanup
 */
class CacheExpiration {
    cacheKey := ""

    __New(cacheKey) {
        this.cacheKey := cacheKey
    }

    /**
     * @method CleanExpiredCache
     * @description Removes expired cache entries
     * @returns {Map} Cleanup result
     */
    CleanExpiredCache() {
        result := Map(
            "scanned", 0,
            "expired", 0,
            "active", 0
        )

        try {
            Loop Reg, this.cacheKey, "K"
            {
                result["scanned"]++
                entryKey := this.cacheKey . "\" . A_LoopRegName

                try {
                    expiresAt := RegRead(entryKey, "ExpiresAt")

                    ; Check if expired
                    if (A_Now > expiresAt) {
                        ; Expired, delete it
                        try {
                            RegDeleteKey entryKey
                            result["expired"]++
                        }
                    } else {
                        result["active"]++
                    }
                } catch {
                    ; No expiration time, keep it
                    result["active"]++
                }
            }
        }

        return result
    }

    /**
     * @method CleanBySize
     * @description Removes oldest entries to maintain size limit
     * @param {Integer} maxEntries - Maximum number of entries
     * @returns {Integer} Number of entries removed
     */
    CleanBySize(maxEntries) {
        entries := []

        ; Collect all entries with timestamps
        try {
            Loop Reg, this.cacheKey, "K"
            {
                entryKey := this.cacheKey . "\" . A_LoopRegName

                try {
                    timestamp := RegRead(entryKey, "CreatedAt")
                    entries.Push(Map(
                        "key", entryKey,
                        "name", A_LoopRegName,
                        "timestamp", timestamp
                    ))
                } catch {
                    ; No timestamp, add with current time
                    entries.Push(Map(
                        "key", entryKey,
                        "name", A_LoopRegName,
                        "timestamp", A_Now
                    ))
                }
            }
        }

        ; If under limit, nothing to do
        if (entries.Length <= maxEntries)
            return 0

        ; Sort by timestamp (oldest first)
        this.SortByTimestamp(&entries)

        ; Delete oldest entries
        deleteCount := entries.Length - maxEntries
        deleted := 0

        for i, entry in entries {
            if (i > deleteCount)
                break

            try {
                RegDeleteKey entry["key"]
                deleted++
            }
        }

        return deleted
    }

    /**
     * @method SortByTimestamp
     * @description Sorts entries by timestamp
     */
    SortByTimestamp(&entries) {
        ; Simple bubble sort
        n := entries.Length
        Loop n {
            swapped := false
            Loop n - A_Index {
                if (entries[A_Index]["timestamp"] > entries[A_Index + 1]["timestamp"]) {
                    temp := entries[A_Index]
                    entries[A_Index] := entries[A_Index + 1]
                    entries[A_Index + 1] := temp
                    swapped := true
                }
            }
            if (!swapped)
                break
        }
    }
}

/**
 * @function Example4_CacheCleanup
 * @description Demonstrates cache expiration cleanup
 * @returns {void}
 */
Example4_CacheCleanup() {
    MsgBox "=== Example 4: Cache Expiration Cleanup ===`n`n" .
        "Cleaning up expired cache entries..."

    cacheKey := "HKCU\Software\AHKv2Examples\CacheTest"

    ; Create cache entries
    try {
        ; Expired entry
        expiredDate := DateAdd(A_Now, -1, "Days")
        RegWrite expiredDate, "REG_SZ", cacheKey . "\Entry1", "ExpiresAt"
        RegWrite "Old Data", "REG_SZ", cacheKey . "\Entry1", "Data"

        ; Active entry
        futureDate := DateAdd(A_Now, 7, "Days")
        RegWrite futureDate, "REG_SZ", cacheKey . "\Entry2", "ExpiresAt"
        RegWrite "Current Data", "REG_SZ", cacheKey . "\Entry2", "Data"
    }

    ; Clean expired cache
    cache := CacheExpiration(cacheKey)
    result := cache.CleanExpiredCache()

    report := "Cache Cleanup Results:`n"
    report .= "━━━━━━━━━━━━━━━━━━━━`n"
    report .= "Scanned: " . result["scanned"] . "`n"
    report .= "Expired (Deleted): " . result["expired"] . "`n"
    report .= "Active (Kept): " . result["active"] . "`n"

    MsgBox report, "Cache Cleanup"
}

; ============================================================================
; EXAMPLE 5: Duplicate Entry Removal
; ============================================================================

/**
 * @function Example5_DuplicateRemoval
 * @description Removes duplicate registry entries
 * @returns {void}
 */
Example5_DuplicateRemoval() {
    MsgBox "=== Example 5: Duplicate Entry Removal ===`n`n" .
        "Finding and removing duplicate entries..."

    testKey := "HKCU\Software\AHKv2Examples\DuplicateTest"

    ; Create entries with duplicates
    try {
        RegWrite "Value A", "REG_SZ", testKey, "Entry1"
        RegWrite "Value A", "REG_SZ", testKey, "Entry2"  ; Duplicate
        RegWrite "Value B", "REG_SZ", testKey, "Entry3"
        RegWrite "Value A", "REG_SZ", testKey, "Entry4"  ; Duplicate
        RegWrite "Value C", "REG_SZ", testKey, "Entry5"
    }

    ; Find duplicates
    valueMap := Map()
    duplicates := []

    try {
        Loop Reg, testKey, "V"
        {
            valueName := A_LoopRegName
            try {
                value := RegRead(testKey, valueName)

                if (valueMap.Has(value)) {
                    ; Duplicate found
                    duplicates.Push(valueName)
                    RegDelete testKey, valueName
                } else {
                    valueMap[value] := valueName
                }
            }
        }
    }

    result := "Duplicate Removal Results:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━`n"
    result .= "Unique Values: " . valueMap.Count . "`n"
    result .= "Duplicates Removed: " . duplicates.Length . "`n`n"

    if (duplicates.Length > 0) {
        result .= "Removed Entries:`n"
        for entry in duplicates {
            result .= "  • " . entry . "`n"
        }
    }

    MsgBox result, "Duplicate Removal"
}

; ============================================================================
; EXAMPLE 6: Selective Cleanup by Data Type
; ============================================================================

/**
 * @function Example6_TypeBasedCleanup
 * @description Cleans up entries based on data type
 * @returns {void}
 */
Example6_TypeBasedCleanup() {
    MsgBox "=== Example 6: Type-Based Cleanup ===`n`n" .
        "Cleaning entries by data type..."

    testKey := "HKCU\Software\AHKv2Examples\TypeCleanupTest"

    ; Create mixed type entries
    try {
        RegWrite "", "REG_SZ", testKey, "EmptyString1"
        RegWrite "", "REG_SZ", testKey, "EmptyString2"
        RegWrite "Valid", "REG_SZ", testKey, "ValidString"
        RegWrite 0, "REG_DWORD", testKey, "ZeroValue1"
        RegWrite 0, "REG_DWORD", testKey, "ZeroValue2"
        RegWrite 42, "REG_DWORD", testKey, "NonZeroValue"
    }

    emptyStrings := []
    zeroValues := []

    ; Clean up empty strings and zero values
    try {
        Loop Reg, testKey, "V"
        {
            valueName := A_LoopRegName
            try {
                value := RegRead(testKey, valueName)

                ; Check for empty string
                if (value is String && value = "") {
                    emptyStrings.Push(valueName)
                    RegDelete testKey, valueName
                }
                ; Check for zero integer
                else if (value is Integer && value = 0) {
                    zeroValues.Push(valueName)
                    RegDelete testKey, valueName
                }
            }
        }
    }

    result := "Type-Based Cleanup Results:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
    result .= "Empty Strings Removed: " . emptyStrings.Length . "`n"
    result .= "Zero Values Removed: " . zeroValues.Length . "`n"

    MsgBox result, "Type Cleanup"
}

; ============================================================================
; EXAMPLE 7: Registry Maintenance Scheduler
; ============================================================================

/**
 * @function Example7_MaintenanceScheduler
 * @description Demonstrates automated maintenance tasks
 * @returns {void}
 */
Example7_MaintenanceScheduler() {
    MsgBox "=== Example 7: Maintenance Scheduler ===`n`n" .
        "Configuring automated maintenance..."

    maintKey := "HKCU\Software\AHKv2Examples\Maintenance"

    ; Configure maintenance settings
    try {
        RegWrite 1, "REG_DWORD", maintKey, "AutoCleanup"
        RegWrite 7, "REG_DWORD", maintKey, "CleanupIntervalDays"
        RegWrite 30, "REG_DWORD", maintKey, "DeleteOlderThanDays"
        RegWrite 1000, "REG_DWORD", maintKey, "MaxCacheEntries"
        RegWrite A_Now, "REG_SZ", maintKey, "LastMaintenance"

        ; Maintenance task list
        RegWrite "ExpiredCache", "REG_SZ", maintKey . "\Tasks", "Task1"
        RegWrite "OrphanedEntries", "REG_SZ", maintKey . "\Tasks", "Task2"
        RegWrite "DuplicateValues", "REG_SZ", maintKey . "\Tasks", "Task3"
        RegWrite "OldBackups", "REG_SZ", maintKey . "\Tasks", "Task4"
    }

    result := "Maintenance Configuration:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
    result .= "Auto Cleanup: Enabled`n"
    result .= "Interval: Every 7 days`n"
    result .= "Delete Older Than: 30 days`n"
    result .= "Max Cache Entries: 1000`n`n"
    result .= "Scheduled Tasks:`n"
    result .= "  • Expired Cache`n"
    result .= "  • Orphaned Entries`n"
    result .= "  • Duplicate Values`n"
    result .= "  • Old Backups`n"

    MsgBox result, "Maintenance Configured"
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMenu() {
    menu := "
    (
    AutoHotkey v2 - RegDelete Advanced
    ═══════════════════════════════════

    1. Pattern-Based Deletion
    2. Batch Cleanup
    3. Orphaned Entry Cleanup
    4. Cache Expiration
    5. Duplicate Removal
    6. Type-Based Cleanup
    7. Maintenance Scheduler

    0. Exit

    Select an example (1-7):
    )"

    choice := InputBox(menu, "RegDelete Advanced").Value

    switch choice {
        case "1": Example1_PatternDeletion()
        case "2": Example2_BatchCleanup()
        case "3": Example3_OrphanedCleanup()
        case "4": Example4_CacheCleanup()
        case "5": Example5_DuplicateRemoval()
        case "6": Example6_TypeBasedCleanup()
        case "7": Example7_MaintenanceScheduler()
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
