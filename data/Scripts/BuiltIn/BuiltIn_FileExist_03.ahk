#Requires AutoHotkey v2.0

/**
 * BuiltIn_FileExist_03.ahk
 * 
 * DESCRIPTION:
 * Conditional processing examples using FileExist() for workflow control
 * 
 * FEATURES:
 * - Conditional workflow execution
 * - File dependency checking
 * - Batch file validation
 * - Pre-execution validation
 * - Dynamic path resolution
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/FileExist.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - FileExist() in conditional logic
 * - Guard clauses and early returns
 * - Dependency validation
 * - Error prevention patterns
 * - Array and Map for tracking
 * 
 * LEARNING POINTS:
 * 1. Use FileExist() to prevent runtime errors
 * 2. Validate dependencies before processing
 * 3. Implement guard clauses for robustness
 * 4. Chain file existence checks for workflows
 * 5. Build conditional processing pipelines
 * 6. Track file states in collections
 */

; ============================================================
; Example 1: Conditional File Processing Pipeline
; ============================================================

/**
 * Process file through multiple stages with validation
 * 
 * @param {String} inputFile - Input file path
 * @param {String} outputFile - Output file path
 * @returns {Object} - Processing result
 */
ProcessFilePipeline(inputFile, outputFile) {
    result := {
        success: false,
        stage: "",
        message: ""
    }

    ; Stage 1: Validate input exists
    result.stage := "Input Validation"
    if (!FileExist(inputFile)) {
        result.message := "Input file does not exist: " inputFile
        return result
    }

    if (InStr(FileExist(inputFile), "D")) {
        result.message := "Input is a directory, not a file"
        return result
    }

    ; Stage 2: Validate output directory
    result.stage := "Output Validation"
    SplitPath(outputFile, , &outputDir)

    if (!FileExist(outputDir)) {
        try {
            DirCreate(outputDir)
        } catch Error as err {
            result.message := "Cannot create output directory: " err.Message
            return result
        }
    }

    ; Stage 3: Check if output file already exists
    result.stage := "Overwrite Check"
    if (FileExist(outputFile) && !InStr(FileExist(outputFile), "D")) {
        ; File exists, could prompt user or backup
        backupFile := outputFile ".backup"
        try {
            FileCopy(outputFile, backupFile, true)
        } catch {
            result.message := "Cannot create backup of existing output file"
            return result
        }
    }

    ; Stage 4: Process file
    result.stage := "Processing"
    try {
        content := FileRead(inputFile)
        ; Transform content (example: uppercase)
        transformed := StrUpper(content)
        FileDelete(outputFile)
        FileAppend(transformed, outputFile)

        result.success := true
        result.message := "Processing completed successfully"
        return result
    } catch Error as err {
        result.message := "Processing failed: " err.Message
        return result
    }
}

; Create test input file
inputPath := A_ScriptDir "\input.txt"
outputPath := A_ScriptDir "\output\processed.txt"

FileAppend("test content for processing", inputPath)

; Run pipeline
pipelineResult := ProcessFilePipeline(inputPath, outputPath)

output := "FILE PROCESSING PIPELINE:`n`n"
output .= "Input: " inputPath "`n"
output .= "Output: " outputPath "`n`n"
output .= "Stage: " pipelineResult.stage "`n"
output .= "Status: " (pipelineResult.success ? "SUCCESS ✓" : "FAILED ✗") "`n"
output .= "Message: " pipelineResult.message

MsgBox(output, "Pipeline Result", pipelineResult.success ? "Icon!" : "IconX")

; ============================================================
; Example 2: Dependency Checker
; ============================================================

/**
 * Check if all file dependencies are met before execution
 * 
 * @param {Map} dependencies - Map of dependency name to file path
 * @returns {Object} - Dependency check result
 */
CheckDependencies(dependencies) {
    result := {
        allMet: true,
        met: [],
        missing: [],
        invalid: []
    }

    for name, path in dependencies {
        if (!FileExist(path)) {
            result.missing.Push({ name: name, path: path })
            result.allMet := false
        } else if (InStr(FileExist(path), "D")) {
            result.invalid.Push({ name: name, path: path, reason: "Is a directory" })
            result.allMet := false
        } else {
            result.met.Push({ name: name, path: path })
        }
    }

    return result
}

; Define dependencies
deps := Map()
deps["Config File"] := A_ScriptDir "\config.ini"
deps["Data File"] := A_ScriptDir "\data.csv"
deps["Template"] := A_ScriptDir "\template.txt"

; Create some dependencies
FileAppend("[Settings]", A_ScriptDir "\config.ini")
FileAppend("data1,data2", A_ScriptDir "\data.csv")

; Check dependencies
depResult := CheckDependencies(deps)

output := "DEPENDENCY CHECK:`n`n"
output .= "Status: " (depResult.allMet ? "ALL MET ✓" : "INCOMPLETE ✗") "`n`n"

if (depResult.met.Length > 0) {
    output .= "MET (" depResult.met.Length "):`n"
    for dep in depResult.met
        output .= "  ✓ " dep.name ": " dep.path "`n"
}

if (depResult.missing.Length > 0) {
    output .= "`nMISSING (" depResult.missing.Length "):`n"
    for dep in depResult.missing
        output .= "  ✗ " dep.name ": " dep.path "`n"
}

if (depResult.invalid.Length > 0) {
    output .= "`nINVALID (" depResult.invalid.Length "):`n"
    for dep in depResult.invalid
        output .= "  ⚠ " dep.name ": " dep.reason "`n"
}

MsgBox(output, "Dependencies", depResult.allMet ? "Icon!" : "IconX")

; ============================================================
; Example 3: Batch File Validator
; ============================================================

/**
 * Validate batch of files meet criteria
 * 
 * @param {Array} fileList - Array of file paths
 * @param {Object} criteria - Validation criteria
 * @returns {Object} - Validation result
 */
ValidateBatch(fileList, criteria := "") {
    if (!criteria)
        criteria := { requireAll: true, allowDirectories: false }

    result := {
        valid: true,
        totalFiles: fileList.Length,
        validated: 0,
        failed: []
    }

    for filePath in fileList {
        ; Check existence
        if (!FileExist(filePath)) {
            result.failed.Push({
                file: filePath,
                reason: "File does not exist"
            })
            result.valid := false
            continue
        }

        ; Check if directory (if not allowed)
        if (!criteria.allowDirectories && InStr(FileExist(filePath), "D")) {
            result.failed.Push({
                file: filePath,
                reason: "Is a directory (directories not allowed)"
            })
            result.valid := false
            continue
        }

        result.validated++
    }

    ; Check if all required
    if (criteria.requireAll && result.validated != result.totalFiles)
        result.valid := false

    return result
}

; Test batch validation
batchFiles := [
    A_ScriptDir "\config.ini",
    A_ScriptDir "\data.csv",
    A_ScriptDir "\missing.txt",
    A_ScriptDir "\output"  ; This is a directory
]

batchResult := ValidateBatch(batchFiles, { requireAll: true, allowDirectories: false })

output := "BATCH VALIDATION:`n`n"
output .= "Total Files: " batchResult.totalFiles "`n"
output .= "Validated: " batchResult.validated "`n"
output .= "Failed: " batchResult.failed.Length "`n"
output .= "Status: " (batchResult.valid ? "VALID ✓" : "INVALID ✗") "`n`n"

if (batchResult.failed.Length > 0) {
    output .= "FAILURES:`n"
    for failure in batchResult.failed
        output .= "  ✗ " failure.file "`n    " failure.reason "`n"
}

MsgBox(output, "Batch Validation", batchResult.valid ? "Icon!" : "IconX")

; ============================================================
; Example 4: Smart File Selector
; ============================================================

/**
 * Select first available file from alternatives
 * 
 * @param {Array} alternatives - Array of file paths to try
 * @returns {String} - First existing file path or empty string
 */
SelectFirstAvailable(alternatives) {
    for filePath in alternatives {
        if (FileExist(filePath) && !InStr(FileExist(filePath), "D"))
            return filePath
    }
    return ""
}

/**
 * Load configuration from first available source
 * 
 * @returns {Object} - Configuration object
 */
LoadConfiguration() {
    configSources := [
        A_ScriptDir "\config.local.ini",     ; Local override
        A_ScriptDir "\config.user.ini",      ; User config
        A_ScriptDir "\config.ini",           ; Default config
        A_AppData "\MyApp\config.ini"        ; Fallback
    ]

    selectedConfig := SelectFirstAvailable(configSources)

    if (!selectedConfig) {
        return {
            success: false,
            message: "No configuration file found",
            source: ""
        }
    }

    try {
        content := FileRead(selectedConfig)
        return {
            success: true,
            message: "Configuration loaded",
            source: selectedConfig,
            content: content
        }
    } catch Error as err {
        return {
            success: false,
            message: "Failed to read config: " err.Message,
            source: selectedConfig
        }
    }
}

; Test smart selector
configResult := LoadConfiguration()

output := "CONFIGURATION LOADER:`n`n"
output .= "Status: " (configResult.success ? "LOADED ✓" : "FAILED ✗") "`n"
output .= "Source: " (configResult.source ? configResult.source : "None") "`n"
output .= "Message: " configResult.message

MsgBox(output, "Config Loader", configResult.success ? "Icon!" : "IconX")

; ============================================================
; Example 5: Conditional Backup System
; ============================================================

/**
 * Create backup only if conditions are met
 * 
 * @param {String} filePath - File to backup
 * @param {Object} options - Backup options
 * @returns {Object} - Backup result
 */
ConditionalBackup(filePath, options := "") {
    if (!options)
        options := { onlyIfExists: true, skipIfRecent: 0, createDir: true }

    result := {
        created: false,
        backupPath: "",
        message: ""
    }

    ; Check if file exists
    if (!FileExist(filePath)) {
        if (options.onlyIfExists) {
            result.message := "File does not exist (skipped)"
            return result
        } else {
            result.message := "File does not exist (error)"
            return result
        }
    }

    ; Check if directory (shouldn't backup directories this way)
    if (InStr(FileExist(filePath), "D")) {
        result.message := "Cannot backup directory as file"
        return result
    }

    ; Construct backup path
    SplitPath(filePath, &fileName, &fileDir, &fileExt, &fileNameNoExt)
    timestamp := FormatTime(, "yyyyMMdd_HHmmss")
    backupDir := fileDir "\backups"

    ; Create backup directory if needed
    if (options.createDir && !FileExist(backupDir)) {
        try {
            DirCreate(backupDir)
        } catch Error as err {
            result.message := "Cannot create backup directory: " err.Message
            return result
        }
    }

    backupPath := backupDir "\" fileNameNoExt "_" timestamp "." fileExt

    ; Create backup
    try {
        FileCopy(filePath, backupPath, false)
        result.created := true
        result.backupPath := backupPath
        result.message := "Backup created successfully"
    } catch Error as err {
        result.message := "Backup failed: " err.Message
    }

    return result
}

; Test conditional backup
backupResult := ConditionalBackup(A_ScriptDir "\config.ini")

output := "CONDITIONAL BACKUP:`n`n"
output .= "Source: " A_ScriptDir "\config.ini`n"
output .= "Created: " (backupResult.created ? "Yes ✓" : "No ✗") "`n"
output .= "Backup Path: " (backupResult.backupPath ? backupResult.backupPath : "N/A") "`n"
output .= "Message: " backupResult.message

MsgBox(output, "Backup System", backupResult.created ? "Icon!" : "IconX")

; ============================================================
; Example 6: Workflow Guard Clauses
; ============================================================

/**
 * Execute workflow with comprehensive validation guards
 * 
 * @param {Object} workflow - Workflow configuration
 * @returns {Object} - Execution result
 */
ExecuteWorkflow(workflow) {
    result := {
        executed: false,
        step: "",
        message: ""
    }

    ; Guard: Check input file
    result.step := "Input validation"
    if (!workflow.HasOwnProp("inputFile") || !workflow.inputFile) {
        result.message := "No input file specified"
        return result
    }

    if (!FileExist(workflow.inputFile)) {
        result.message := "Input file does not exist"
        return result
    }

    ; Guard: Check output path
    result.step := "Output validation"
    if (!workflow.HasOwnProp("outputFile") || !workflow.outputFile) {
        result.message := "No output file specified"
        return result
    }

    SplitPath(workflow.outputFile, , &outDir)
    if (outDir && !FileExist(outDir)) {
        result.message := "Output directory does not exist"
        return result
    }

    ; Guard: Check required tools/files
    result.step := "Dependency validation"
    if (workflow.HasOwnProp("requiredFiles")) {
        for reqFile in workflow.requiredFiles {
            if (!FileExist(reqFile)) {
                result.message := "Required file missing: " reqFile
                return result
            }
        }
    }

    ; All guards passed, execute workflow
    result.step := "Execution"
    try {
        content := FileRead(workflow.inputFile)
        ; Process content (example transformation)
        processed := "Processed: " content
        FileDelete(workflow.outputFile)
        FileAppend(processed, workflow.outputFile)

        result.executed := true
        result.message := "Workflow completed successfully"
        return result
    } catch Error as err {
        result.message := "Execution failed: " err.Message
        return result
    }
}

; Test workflow with guards
myWorkflow := {
    inputFile: A_ScriptDir "\data.csv",
    outputFile: A_ScriptDir "\output\result.txt",
    requiredFiles: [A_ScriptDir "\config.ini"]
}

workflowResult := ExecuteWorkflow(myWorkflow)

output := "WORKFLOW EXECUTION:`n`n"
output .= "Step: " workflowResult.step "`n"
output .= "Executed: " (workflowResult.executed ? "Yes ✓" : "No ✗") "`n"
output .= "Message: " workflowResult.message

MsgBox(output, "Workflow Guards", workflowResult.executed ? "Icon!" : "IconX")

; ============================================================
; Example 7: File Availability Monitor
; ============================================================

/**
 * Monitor file availability and execute when ready
 * 
 * @param {String} filePath - File to monitor
 * @param {Integer} timeout - Timeout in milliseconds
 * @returns {Boolean} - True if file became available
 */
WaitForFile(filePath, timeout := 5000) {
    startTime := A_TickCount

    Loop {
        if (FileExist(filePath) && !InStr(FileExist(filePath), "D"))
            return true

        if (A_TickCount - startTime >= timeout)
            return false

        Sleep(100)
    }
}

; Example: Wait for a file to appear
monitorPath := A_ScriptDir "\delayed_file.txt"

; Simulate delayed file creation in 2 seconds
SetTimer(() => FileAppend("Delayed content", monitorPath), -2000)

output := "Waiting for file to appear...`n"
output .= "File: " monitorPath "`n"
output .= "Timeout: 5 seconds`n`n"

MsgBox(output, "File Monitor", "Icon! T1")

; Wait for file
if (WaitForFile(monitorPath, 5000)) {
    MsgBox("File appeared! ✓`n"
        . "File: " monitorPath "`n"
        . "Attributes: " FileExist(monitorPath),
        "File Available", "Icon!")
} else {
    MsgBox("Timeout: File did not appear ✗",
        "File Not Available", "IconX")
}

; ============================================================
; Reference Information
; ============================================================

info := "
(
CONDITIONAL PROCESSING WITH FILEEXIST():

Guard Clauses Pattern:
function ProcessFile(path) {
    ; Guard: Check existence
    if (!FileExist(path))
    return {error: 'File not found'}

    ; Guard: Check type
    if (InStr(FileExist(path), 'D'))
    return {error: 'Path is directory'}

    ; Proceed with processing
    return DoProcessing(path)
}

Validation Patterns:

1. Pre-Execution Validation:
• Check all inputs exist
• Validate output paths
• Verify dependencies
• Confirm permissions

2. Dependency Chains:
• Check each dependency
• Fail fast on missing items
• Provide clear error messages
• Track validation state

3. Conditional Workflows:
• Validate before each stage
• Create checkpoints
• Allow graceful failures
• Maintain state information

Common Use Cases:
✓ Pipeline processing
✓ Batch operations
✓ Dependency management
✓ Backup systems
✓ File monitoring
✓ Workflow automation
✓ Error prevention

Best Practices:
• Validate early (fail fast)
• Use guard clauses for clarity
• Provide descriptive error messages
• Track validation state
• Allow recovery when possible
• Log validation failures
• Design for testability
)"

MsgBox(info, "Conditional Processing Reference", "Icon!")

; Cleanup
FileDelete(inputPath)
FileDelete(outputPath)
FileDelete(A_ScriptDir "\config.ini")
FileDelete(A_ScriptDir "\data.csv")
FileDelete(monitorPath)
try DirDelete(A_ScriptDir "\output", true)
try DirDelete(A_ScriptDir "\backups", true)
