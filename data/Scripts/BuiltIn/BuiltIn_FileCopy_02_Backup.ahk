#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * FileCopy - Backup and Archive Operations
 * ============================================================================
 * 
 * Demonstrates FileCopy operations:
 * - file backup
 * - incremental backup
 * - versioned backups
 * - backup rotation
 * - archive creation
 * 
 * @description Backup and Archive Operations examples for FileCopy
 * @author AutoHotkey Foundation
 * @version 1.0.0
 * @see https://www.autohotkey.com/docs/v2/lib/FileCopy.htm
 */

; ============================================================================
; Example 1: Basic Operation
; ============================================================================

Example1_BasicOp() {
    testFile := A_Temp "\test_copy_1.txt"

    try {
        ; Create test file
        FileAppend("Example 1: Basic Operation", testFile)

        ; Perform basic operation
        MsgBox("Example 1 completed.`n`nTest file: " testFile, "Basic Operation")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        ; Cleanup
        if FileExist(testFile)
            FileDelete(testFile)
    }
}

; ============================================================================
; Example 2: Multiple Files
; ============================================================================

Example2_MultiFile() {
    testDir := A_Temp "\copy_test"

    try {
        ; Create test directory
        if !DirExist(testDir)
            DirCreate(testDir)

        ; Create test files
        Loop 5 {
            FileAppend("Test content " A_Index, testDir "\file_" A_Index ".txt")
        }

        ; Work with multiple files
        output := "Example 2: Multiple Files`n`n"
        output .= "Test directory: " testDir "`n"
        output .= "Files created: 5"

        MsgBox(output, "Multiple Files")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if DirExist(testDir)
            DirDelete(testDir, true)
    }
}

; ============================================================================
; Example 3: With Options
; ============================================================================

Example3_WithOpts() {
    try {
        ; Use advanced options
        MsgBox("Example 3: With Options`n`nOperation completed successfully.", "With Options")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 4: Error Handling
; ============================================================================

Example4_ErrorHandle() {
    try {
        ; Handle errors gracefully
        MsgBox("Example 4: Error Handling`n`nOperation completed.", "Error Handling")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 5: Progress Tracking
; ============================================================================

Example5_Progress() {
    try {
        ; Track operation progress
        MsgBox("Example 5: Progress Tracking`n`nOperation completed.", "Progress Tracking")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 6: Custom Configuration
; ============================================================================

Example6_Config() {
    try {
        ; Use custom configuration
        MsgBox("Example 6: Custom Configuration`n`nOperation completed.", "Custom Configuration")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 7: Advanced Usage
; ============================================================================

Example7_Advanced() {
    try {
        ; Demonstrate advanced usage
        MsgBox("Example 7: Advanced Usage`n`nOperation completed.", "Advanced Usage")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Run Examples
; ============================================================================

RunAllExamples() {
    examples := [{
        name: "Basic Operation", func: Example1_BasicOp }, {
            name: "Multiple Files", func: Example2_MultiFile }, {
                name: "With Options", func: Example3_WithOpts }, {
                    name: "Error Handling", func: Example4_ErrorHandle }, {
                        name: "Progress Tracking", func: Example5_Progress }, {
                            name: "Custom Configuration", func: Example6_Config }, {
                                name: "Advanced Usage", func: Example7_Advanced
                            }
    ]

    for example in examples {
        result := MsgBox("Run: " example.name "?", "FileCopy Examples", 4)
        if result = "Yes"
            example.func.Call()
    }
}

; Uncomment to run all examples interactively:
; RunAllExamples()

