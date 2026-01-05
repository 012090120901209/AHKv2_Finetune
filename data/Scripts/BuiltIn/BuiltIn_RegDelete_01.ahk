#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 Registry Delete Examples - Part 1
 * ============================================================================
 * 
 * This file demonstrates comprehensive usage of the RegDelete and RegDeleteKey
 * functions in AutoHotkey v2, including deleting values, deleting keys, and
 * cleanup operations.
 * 
 * @description Examples of deleting Windows Registry values and keys
 * @author AHK v2 Examples Collection
 * @version 1.0.0
 * @date 2024-01-15
 */

; ============================================================================
; EXAMPLE 1: Basic Registry Value Deletion
; ============================================================================

/**
 * @function Example1_BasicRegDelete
 * @description Demonstrates basic registry value deletion
 * @returns {void}
 */
Example1_BasicRegDelete() {
    MsgBox "=== Example 1: Basic Registry Deletion ===`n`n" .
        "Creating and then deleting registry values..."

    testKey := "HKCU\Software\AHKv2Examples\DeleteTest"

    ; Create some test values
    try {
        RegWrite "Test Value 1", "REG_SZ", testKey, "Value1"
        RegWrite "Test Value 2", "REG_SZ", testKey, "Value2"
        RegWrite 42, "REG_DWORD", testKey, "Number1"
        RegWrite 100, "REG_DWORD", testKey, "Number2"

        MsgBox "Created 4 test values", "Values Created"

        ; Delete individual values
        RegDelete testKey, "Value1"
        RegDelete testKey, "Number1"

        MsgBox "Deleted Value1 and Number1", "Values Deleted"

        ; Verify remaining values
        result := "Remaining Values:`n"
        result .= "━━━━━━━━━━━━━━━━`n"

        try {
            val2 := RegRead(testKey, "Value2")
            result .= "Value2: " . val2 . "`n"
        }

        try {
            num2 := RegRead(testKey, "Number2")
            result .= "Number2: " . num2 . "`n"
        }

        MsgBox result, "Verification"

    } catch Error as err {
        MsgBox "Error: " . err.Message, "Error"
    }
}

; ============================================================================
; EXAMPLE 2: Safe Registry Deletion with Verification
; ============================================================================

/**
 * @class SafeRegDelete
 * @description Safely deletes registry values with verification
 */
class SafeRegDelete {
    /**
     * @method DeleteValue
     * @description Safely deletes a registry value
     * @param {String} keyPath - Registry key path
     * @param {String} valueName - Value name to delete
     * @param {Boolean} backup - Create backup before deletion
     * @returns {Map} Deletion result
     */
    static DeleteValue(keyPath, valueName, backup := true) {
        result := Map(
            "success", false,
            "existed", false,
            "backed up", false,
            "error", ""
        )

        ; Check if value exists
        try {
            oldValue := RegRead(keyPath, valueName)
            result["existed"] := true

            ; Create backup if requested
            if (backup) {
                backupKey := keyPath . "_Backup"
                try {
                    RegWrite oldValue, "REG_SZ", backupKey, valueName
                    result["backed up"] := true
                } catch {
                    ; Backup failed, continue anyway
                }
            }

            ; Delete the value
            RegDelete keyPath, valueName
            result["success"] := true

        } catch Error as err {
            result["error"] := err.Message
        }

        return result
    }

    /**
     * @method DeleteMultipleValues
     * @description Deletes multiple registry values
     * @param {String} keyPath - Registry key path
     * @param {Array} valueNames - Array of value names to delete
     * @returns {Map} Deletion results
     */
    static DeleteMultipleValues(keyPath, valueNames) {
        results := Map(
            "total", valueNames.Length,
            "deleted", 0,
            "failed", 0,
            "details", []
        )

        for valueName in valueNames {
            result := this.DeleteValue(keyPath, valueName, false)

            if (result["success"]) {
                results["deleted"]++
            } else {
                results["failed"]++
            }

            results["details"].Push(Map(
                "name", valueName,
                "success", result["success"],
                "error", result["error"]
            ))
        }

        return results
    }
}

/**
 * @function Example2_SafeDeletion
 * @description Demonstrates safe registry deletion
 * @returns {void}
 */
Example2_SafeDeletion() {
    MsgBox "=== Example 2: Safe Deletion ===`n`n" .
        "Demonstrating safe deletion with backup..."

    testKey := "HKCU\Software\AHKv2Examples\SafeDeleteTest"

    ; Create test values
    try {
        RegWrite "Important Value", "REG_SZ", testKey, "ImportantSetting"
        RegWrite "Temp Value", "REG_SZ", testKey, "TempSetting"
    }

    ; Safe delete with backup
    result := SafeRegDelete.DeleteValue(testKey, "ImportantSetting", true)

    report := "Deletion Report:`n"
    report .= "━━━━━━━━━━━━━━━━`n"
    report .= "Value Existed: " . (result["existed"] ? "Yes" : "No") . "`n"
    report .= "Backed Up: " . (result["backed up"] ? "Yes" : "No") . "`n"
    report .= "Deleted: " . (result["success"] ? "Yes" : "No") . "`n"

    if (result["error"] != "")
        report .= "Error: " . result["error"] . "`n"

    MsgBox report, "Safe Deletion"
}

; ============================================================================
; EXAMPLE 3: Registry Key Deletion
; ============================================================================

/**
 * @function Example3_KeyDeletion
 * @description Demonstrates deleting entire registry keys
 * @returns {void}
 */
Example3_KeyDeletion() {
    MsgBox "=== Example 3: Key Deletion ===`n`n" .
        "Deleting entire registry keys..."

    baseKey := "HKCU\Software\AHKv2Examples\KeyDeleteTest"

    ; Create a key structure
    try {
        ; Main key with values
        RegWrite "Main Value 1", "REG_SZ", baseKey, "Value1"
        RegWrite "Main Value 2", "REG_SZ", baseKey, "Value2"

        ; Subkey 1
        subKey1 := baseKey . "\SubKey1"
        RegWrite "Sub Value 1", "REG_SZ", subKey1, "SubValue1"

        ; Subkey 2
        subKey2 := baseKey . "\SubKey2"
        RegWrite "Sub Value 2", "REG_SZ", subKey2, "SubValue2"

        MsgBox "Created key structure with subkeys", "Keys Created"

        ; Delete a subkey
        try {
            RegDeleteKey subKey1
            MsgBox "Deleted SubKey1", "Subkey Deleted"
        } catch Error as err {
            MsgBox "Error deleting SubKey1: " . err.Message, "Error"
        }

        ; Try to delete main key (will fail if has subkeys)
        try {
            RegDeleteKey baseKey
            MsgBox "Deleted main key", "Key Deleted"
        } catch Error as err {
            MsgBox "Cannot delete main key (has subkeys):`n" . err.Message, "Info"
        }

    } catch Error as err {
        MsgBox "Error: " . err.Message, "Error"
    }
}

; ============================================================================
; EXAMPLE 4: Recursive Key Deletion
; ============================================================================

/**
 * @class RecursiveDelete
 * @description Recursively deletes registry keys and subkeys
 */
class RecursiveDelete {
    /**
     * @method DeleteKeyRecursive
     * @description Recursively deletes a registry key and all subkeys
     * @param {String} keyPath - Registry key path to delete
     * @returns {Map} Deletion result
     */
    static DeleteKeyRecursive(keyPath) {
        result := Map(
            "success", false,
            "keysDeleted", 0,
            "errors", []
        )

        try {
            ; First, delete all subkeys recursively
            Loop Reg, keyPath, "K"
            {
                subKeyPath := keyPath . "\" . A_LoopRegName

                ; Recursive call
                subResult := this.DeleteKeyRecursive(subKeyPath)
                result["keysDeleted"] += subResult["keysDeleted"]

                ; Collect errors
                for error in subResult["errors"] {
                    result["errors"].Push(error)
                }
            }

            ; Then delete the key itself
            try {
                RegDeleteKey keyPath
                result["keysDeleted"]++
                result["success"] := true
            } catch Error as err {
                result["errors"].Push(Map(
                    "key", keyPath,
                    "error", err.Message
                ))
            }

        } catch {
            ; Key doesn't exist or inaccessible
        }

        return result
    }

    /**
     * @method GetDeleteReport
     * @description Formats deletion result into report
     * @param {Map} result - Deletion result
     * @returns {String} Formatted report
     */
    static GetDeleteReport(result) {
        report := "Recursive Deletion Report:`n"
        report .= "━━━━━━━━━━━━━━━━━━━━━━━━`n"
        report .= "Keys Deleted: " . result["keysDeleted"] . "`n"
        report .= "Status: " . (result["success"] ? "✓ Success" : "✗ Failed") . "`n"

        if (result["errors"].Length > 0) {
            report .= "`nErrors (" . result["errors"].Length . "):`n"
            for error in result["errors"] {
                report .= "  • " . error["key"] . "`n"
                report .= "    " . error["error"] . "`n"
            }
        }

        return report
    }
}

/**
 * @function Example4_RecursiveDeletion
 * @description Demonstrates recursive key deletion
 * @returns {void}
 */
Example4_RecursiveDeletion() {
    MsgBox "=== Example 4: Recursive Deletion ===`n`n" .
        "Creating and recursively deleting key structure..."

    baseKey := "HKCU\Software\AHKv2Examples\RecursiveDeleteTest"

    ; Create nested structure
    try {
        RegWrite "Value", "REG_SZ", baseKey, "RootValue"
        RegWrite "Value", "REG_SZ", baseKey . "\Level1", "L1Value"
        RegWrite "Value", "REG_SZ", baseKey . "\Level1\Level2", "L2Value"
        RegWrite "Value", "REG_SZ", baseKey . "\Level1\Level2\Level3", "L3Value"

        MsgBox "Created nested key structure (3 levels deep)", "Structure Created"

        ; Recursively delete
        result := RecursiveDelete.DeleteKeyRecursive(baseKey)
        report := RecursiveDelete.GetDeleteReport(result)

        MsgBox report, "Recursive Deletion Complete"

    } catch Error as err {
        MsgBox "Error: " . err.Message, "Error"
    }
}

; ============================================================================
; EXAMPLE 5: Conditional Deletion Based on Value
; ============================================================================

/**
 * @function Example5_ConditionalDeletion
 * @description Deletes registry values based on conditions
 * @returns {void}
 */
Example5_ConditionalDeletion() {
    MsgBox "=== Example 5: Conditional Deletion ===`n`n" .
        "Deleting values based on conditions..."

    testKey := "HKCU\Software\AHKv2Examples\ConditionalDelete"

    ; Create test values
    try {
        RegWrite "Keep This", "REG_SZ", testKey, "KeepValue1"
        RegWrite "Temp_Data", "REG_SZ", testKey, "TempValue1"
        RegWrite "Temp_Cache", "REG_SZ", testKey, "TempValue2"
        RegWrite "Important", "REG_SZ", testKey, "KeepValue2"
        RegWrite 0, "REG_DWORD", testKey, "Disabled1"
        RegWrite 1, "REG_DWORD", testKey, "Enabled1"
        RegWrite 0, "REG_DWORD", testKey, "Disabled2"
    }

    deleted := []

    ; Delete values starting with "Temp_"
    try {
        Loop Reg, testKey, "V"
        {
            valueName := A_LoopRegName
            if (SubStr(valueName, 1, 5) = "Temp_") {
                try {
                    RegDelete testKey, valueName
                    deleted.Push(valueName . " (Temp prefix)")
                }
            }
        }
    }

    ; Delete DWORD values that are 0
    try {
        Loop Reg, testKey, "V"
        {
            valueName := A_LoopRegName
            try {
                value := RegRead(testKey, valueName)
                if (value is Integer && value = 0) {
                    RegDelete testKey, valueName
                    deleted.Push(valueName . " (Value = 0)")
                }
            }
        }
    }

    ; Build report
    result := "Conditional Deletion Results:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
    result .= "Deleted " . deleted.Length . " values:`n`n"

    for item in deleted {
        result .= "  • " . item . "`n"
    }

    MsgBox result, "Conditional Deletion"
}

; ============================================================================
; EXAMPLE 6: Cleanup Old Entries by Date
; ============================================================================

/**
 * @class DateBasedCleanup
 * @description Cleans up old registry entries based on timestamps
 */
class DateBasedCleanup {
    /**
     * @method CleanupOldEntries
     * @description Deletes entries older than specified days
     * @param {String} keyPath - Registry key path
     * @param {Integer} daysOld - Age threshold in days
     * @returns {Map} Cleanup result
     */
    static CleanupOldEntries(keyPath, daysOld) {
        result := Map(
            "scanned", 0,
            "deleted", 0,
            "kept", 0,
            "errors", []
        )

        ; Calculate cutoff date
        cutoffDate := A_Now
        cutoffDate := DateAdd(cutoffDate, -daysOld, "Days")

        try {
            Loop Reg, keyPath, "K"
            {
                result["scanned"]++
                subKeyPath := keyPath . "\" . A_LoopRegName

                try {
                    ; Try to read timestamp
                    timestamp := RegRead(subKeyPath, "Timestamp")

                    if (timestamp < cutoffDate) {
                        ; Old entry, delete it
                        try {
                            RegDeleteKey subKeyPath
                            result["deleted"]++
                        } catch Error as err {
                            result["errors"].Push(Map(
                                "key", subKeyPath,
                                "error", err.Message
                            ))
                        }
                    } else {
                        result["kept"]++
                    }
                } catch {
                    ; No timestamp, keep it
                    result["kept"]++
                }
            }
        }

        return result
    }
}

/**
 * @function Example6_DateCleanup
 * @description Demonstrates date-based cleanup
 * @returns {void}
 */
Example6_DateCleanup() {
    MsgBox "=== Example 6: Date-Based Cleanup ===`n`n" .
        "Cleaning up old entries..."

    baseKey := "HKCU\Software\AHKv2Examples\DateCleanup"

    ; Create test entries with timestamps
    try {
        ; Old entry (30 days ago)
        oldDate := A_Now
        oldDate := DateAdd(oldDate, -30, "Days")
        RegWrite oldDate, "REG_SZ", baseKey . "\OldEntry", "Timestamp"
        RegWrite "Old Data", "REG_SZ", baseKey . "\OldEntry", "Data"

        ; Recent entry (5 days ago)
        recentDate := A_Now
        recentDate := DateAdd(recentDate, -5, "Days")
        RegWrite recentDate, "REG_SZ", baseKey . "\RecentEntry", "Timestamp"
        RegWrite "Recent Data", "REG_SZ", baseKey . "\RecentEntry", "Data"

        ; Current entry
        RegWrite A_Now, "REG_SZ", baseKey . "\CurrentEntry", "Timestamp"
        RegWrite "Current Data", "REG_SZ", baseKey . "\CurrentEntry", "Data"
    }

    ; Cleanup entries older than 7 days
    result := DateBasedCleanup.CleanupOldEntries(baseKey, 7)

    report := "Cleanup Results:`n"
    report .= "━━━━━━━━━━━━━━━━`n"
    report .= "Scanned: " . result["scanned"] . "`n"
    report .= "Deleted: " . result["deleted"] . "`n"
    report .= "Kept: " . result["kept"] . "`n"

    if (result["errors"].Length > 0)
        report .= "Errors: " . result["errors"].Length . "`n"

    MsgBox report, "Cleanup Complete"
}

; ============================================================================
; EXAMPLE 7: Uninstall Cleanup
; ============================================================================

/**
 * @class UninstallCleanup
 * @description Performs comprehensive cleanup during uninstall
 */
class UninstallCleanup {
    appName := ""

    __New(appName) {
        this.appName := appName
    }

    /**
     * @method PerformCleanup
     * @description Performs complete uninstall cleanup
     * @returns {Map} Cleanup result
     */
    PerformCleanup() {
        result := Map(
            "success", false,
            "keysDeleted", 0,
            "valuesDeleted", 0,
            "errors", []
        )

        baseKey := "HKCU\Software\" . this.appName

        try {
            ; Delete main application key
            deleteResult := RecursiveDelete.DeleteKeyRecursive(baseKey)
            result["keysDeleted"] := deleteResult["keysDeleted"]

            ; Delete startup entry if exists
            try {
                RegDelete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run", this.appName
                result["valuesDeleted"]++
            } catch {
                ; Startup entry doesn't exist
            }

            ; Delete file associations if any
            try {
                RegDeleteKey "HKCU\Software\Classes\" . this.appName
                result["keysDeleted"]++
            } catch {
                ; No file associations
            }

            result["success"] := true

        } catch Error as err {
            result["errors"].Push(err.Message)
        }

        return result
    }
}

/**
 * @function Example7_UninstallCleanup
 * @description Demonstrates uninstall cleanup
 * @returns {void}
 */
Example7_UninstallCleanup() {
    MsgBox "=== Example 7: Uninstall Cleanup ===`n`n" .
        "Performing uninstall cleanup..."

    appName := "AHKv2Examples\TestApp"

    ; Create some registry entries to simulate an installed app
    try {
        RegWrite "1.0.0", "REG_SZ", "HKCU\Software\" . appName, "Version"
        RegWrite "C:\Program Files\TestApp", "REG_SZ", "HKCU\Software\" . appName, "InstallPath"
        RegWrite "Test App", "REG_SZ", "HKCU\Software\" . appName . "\Settings", "AppName"
    }

    ; Perform cleanup
    cleanup := UninstallCleanup(appName)
    result := cleanup.PerformCleanup()

    report := "Uninstall Cleanup Results:`n"
    report .= "━━━━━━━━━━━━━━━━━━━━━━━━━`n"
    report .= "Keys Deleted: " . result["keysDeleted"] . "`n"
    report .= "Values Deleted: " . result["valuesDeleted"] . "`n"
    report .= "Status: " . (result["success"] ? "✓ Success" : "✗ Failed") . "`n"

    if (result["errors"].Length > 0) {
        report .= "`nErrors:`n"
        for error in result["errors"] {
            report .= "  • " . error . "`n"
        }
    }

    MsgBox report, "Cleanup Complete"
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMenu() {
    menu := "
    (
    AutoHotkey v2 - RegDelete Examples
    ═══════════════════════════════════

    1. Basic Registry Deletion
    2. Safe Deletion (with backup)
    3. Key Deletion
    4. Recursive Deletion
    5. Conditional Deletion
    6. Date-Based Cleanup
    7. Uninstall Cleanup

    0. Exit

    Select an example (1-7):
    )"

    choice := InputBox(menu, "RegDelete Examples").Value

    switch choice {
        case "1": Example1_BasicRegDelete()
        case "2": Example2_SafeDeletion()
        case "3": Example3_KeyDeletion()
        case "4": Example4_RecursiveDeletion()
        case "5": Example5_ConditionalDeletion()
        case "6": Example6_DateCleanup()
        case "7": Example7_UninstallCleanup()
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
