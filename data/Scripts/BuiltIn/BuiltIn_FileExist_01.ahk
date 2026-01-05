#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_FileExist_01.ahk
 * 
 * DESCRIPTION:
 * Basic usage examples of FileExist() function to check file and directory existence
 * 
 * FEATURES:
 * - Check if files exist
 * - Check if directories exist
 * - Distinguish between files and folders
 * - Get file attributes during check
 * - Safe file operations with validation
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/FileExist.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - FileExist() function
 * - Attribute string parsing
 * - Conditional processing
 * - Error prevention through validation
 * - Path handling
 * 
 * LEARNING POINTS:
 * 1. FileExist() returns attribute string if file/folder exists, empty string otherwise
 * 2. Can distinguish between files (no "D") and directories ("D" in attributes)
 * 3. Returns various attributes: D=Directory, A=Archive, R=ReadOnly, H=Hidden, S=System
 * 4. Essential for preventing errors when working with files
 * 5. Works with relative and absolute paths
 * 6. Can check wildcards but returns attributes of first match
 */

; ============================================================
; Example 1: Basic File Existence Check
; ============================================================

; Create a test file for demonstration
testFile := A_ScriptDir "\test_file.txt"
FileAppend("Sample content", testFile)

; Check if file exists
if (FileExist(testFile)) {
    MsgBox("File exists: " testFile "`n"
        . "Attributes: " FileExist(testFile),
        "File Exists", "Icon!")
} else {
    MsgBox("File does not exist: " testFile, "File Not Found", "IconX")
}

; ============================================================
; Example 2: Distinguishing Files from Directories
; ============================================================

/**
 * Check if a path is a file (not a directory)
 * 
 * @param {String} path - Path to check
 * @returns {Boolean} - True if path is a file, false otherwise
 */
IsFile(path) {
    attrs := FileExist(path)
    ; File exists and does NOT have Directory attribute
    return attrs && !InStr(attrs, "D")
}

/**
 * Check if a path is a directory
 * 
 * @param {String} path - Path to check
 * @returns {Boolean} - True if path is a directory, false otherwise
 */
IsDirectory(path) {
    attrs := FileExist(path)
    ; Directory attribute present
    return InStr(attrs, "D") ? true : false
}

; Test both functions
testPaths := [
    A_ScriptDir "\test_file.txt",
    A_ScriptDir,
    A_WinDir "\System32",
    "C:\NonExistent\File.txt"
]

output := "Path Type Detection:`n`n"
for path in testPaths {
    if (IsFile(path))
        output .= "FILE: " path "`n"
    else if (IsDirectory(path))
        output .= "DIRECTORY: " path "`n"
    else
        output .= "NOT FOUND: " path "`n"
}

MsgBox(output, "File vs Directory", "Icon!")

; ============================================================
; Example 3: Safe File Reading with Validation
; ============================================================

/**
 * Safely read a file with existence validation
 * 
 * @param {String} filePath - Path to file
 * @returns {String} - File contents or error message
 */
SafeFileRead(filePath) {
    if (!FileExist(filePath)) {
        return "ERROR: File does not exist: " filePath
    }

    if (IsDirectory(filePath)) {
        return "ERROR: Path is a directory, not a file: " filePath
    }

    try {
        return FileRead(filePath)
    } catch Error as err {
        return "ERROR: Failed to read file: " err.Message
    }
}

; Create test file with content
testContent := "This is test content`nLine 2`nLine 3"
FileDelete(testFile)  ; Delete if exists
FileAppend(testContent, testFile)

; Test safe reading
result := SafeFileRead(testFile)
MsgBox("File: " testFile "`n`n"
    . "Content:`n" result,
    "Safe File Reading", "Icon!")

; Test with non-existent file
result := SafeFileRead("C:\NonExistent\File.txt")
MsgBox(result, "Non-Existent File Test", "Icon!")

; ============================================================
; Example 4: Checking Multiple Files
; ============================================================

/**
 * Check existence of multiple files and generate report
 * 
 * @param {Array} fileList - Array of file paths
 * @returns {Object} - Object with exists and missing arrays
 */
CheckMultipleFiles(fileList) {
    result := { exists: [], missing: [] }

    for filePath in fileList {
        if (FileExist(filePath))
            result.exists.Push(filePath)
        else
            result.missing.Push(filePath)
    }

    return result
}

; Create multiple test files
testFiles := []
Loop 3 {
    file := A_ScriptDir "\testfile_" A_Index ".txt"
    FileAppend("Test " A_Index, file)
    testFiles.Push(file)
}

; Add some non-existent files
testFiles.Push(A_ScriptDir "\nonexistent1.txt")
testFiles.Push(A_ScriptDir "\nonexistent2.txt")

; Check all files
checkResult := CheckMultipleFiles(testFiles)

output := "FILE EXISTENCE CHECK REPORT:`n`n"
output .= "EXISTS (" checkResult.exists.Length "):`n"
for file in checkResult.exists
    output .= "  ✓ " file "`n"

output .= "`nMISSING (" checkResult.missing.Length "):`n"
for file in checkResult.missing
    output .= "  ✗ " file "`n"

MsgBox(output, "Multiple File Check", "Icon!")

; ============================================================
; Example 5: Attribute Detection
; ============================================================

/**
 * Get detailed file attributes
 * 
 * @param {String} path - Path to check
 * @returns {String} - Formatted attribute information
 */
GetFileAttributes(path) {
    attrs := FileExist(path)

    if (!attrs)
        return "File/Directory does not exist"

    info := "Attributes: " attrs "`n`n"
    info .= "Type: " (InStr(attrs, "D") ? "Directory" : "File") "`n"
    info .= "Archive: " (InStr(attrs, "A") ? "Yes" : "No") "`n"
    info .= "Read-Only: " (InStr(attrs, "R") ? "Yes" : "No") "`n"
    info .= "Hidden: " (InStr(attrs, "H") ? "Yes" : "No") "`n"
    info .= "System: " (InStr(attrs, "S") ? "Yes" : "No") "`n"

    return info
}

; Test with different paths
MsgBox("PATH: " A_ScriptDir "`n`n"
    . GetFileAttributes(A_ScriptDir),
    "Directory Attributes", "Icon!")

MsgBox("PATH: " testFile "`n`n"
    . GetFileAttributes(testFile),
    "File Attributes", "Icon!")

; ============================================================
; Example 6: Configuration File Validator
; ============================================================

/**
 * Validate required configuration files exist
 * 
 * @param {Array} requiredFiles - Array of required file paths
 * @returns {Object} - Validation result with success and errors
 */
ValidateConfiguration(requiredFiles) {
    errors := []

    for filePath in requiredFiles {
        if (!FileExist(filePath)) {
            errors.Push("Missing required file: " filePath)
        } else if (IsDirectory(filePath)) {
            errors.Push("Expected file but found directory: " filePath)
        }
    }

    return {
        success: errors.Length = 0,
        errors: errors,
        message: errors.Length = 0
            ? "All required files present"
            : "Validation failed: " errors.Length " error(s)"
    }
}

; Create config files
configFiles := []
Loop 2 {
    file := A_ScriptDir "\config" A_Index ".ini"
    FileAppend("[Settings]`nValue=Test", file)
    configFiles.Push(file)
}
configFiles.Push(A_ScriptDir "\missing_config.ini")  ; This one doesn't exist

; Validate
validation := ValidateConfiguration(configFiles)

output := "CONFIGURATION VALIDATION:`n`n"
output .= "Status: " (validation.success ? "PASSED ✓" : "FAILED ✗") "`n"
output .= "Message: " validation.message "`n`n"

if (!validation.success) {
    output .= "Errors:`n"
    for error in validation.errors
        output .= "  • " error "`n"
}

MsgBox(output, "Config Validation", validation.success ? "Icon!" : "IconX")

; ============================================================
; Example 7: Smart File Processor
; ============================================================

/**
 * Process file only if it exists and meets criteria
 * 
 * @param {String} filePath - Path to file
 * @param {Function} processor - Function to process file content
 * @returns {Object} - Processing result
 */
SmartFileProcessor(filePath, processor) {
    ; Check existence
    if (!FileExist(filePath)) {
        return {
            success: false,
            error: "File does not exist"
        }
    }

    ; Check it's a file, not directory
    if (IsDirectory(filePath)) {
        return {
            success: false,
            error: "Path is a directory"
        }
    }

    ; Process file
    try {
        content := FileRead(filePath)
        result := processor(content)
        return {
            success: true,
            result: result
        }
    } catch Error as err {
        return {
            success: false,
            error: err.Message
        }
    }
}

; Example processor: Count lines
LineCounter(content) {
    lines := StrSplit(content, "`n")
    return "Line count: " lines.Length
}

; Test the smart processor
processingResult := SmartFileProcessor(testFile, LineCounter)

output := "SMART FILE PROCESSOR:`n`n"
output .= "File: " testFile "`n"
output .= "Status: " (processingResult.success ? "SUCCESS" : "FAILED") "`n"

if (processingResult.success)
    output .= "Result: " processingResult.result
else
    output .= "Error: " processingResult.error

MsgBox(output, "Smart Processor", processingResult.success ? "Icon!" : "IconX")

; ============================================================
; Cleanup
; ============================================================

; Clean up test files
FileDelete(testFile)
Loop 3
    FileDelete(A_ScriptDir "\testfile_" A_Index ".txt")
Loop 2
    FileDelete(A_ScriptDir "\config" A_Index ".ini")

; ============================================================
; Reference Information
; ============================================================

info := "
(
FILEEXIST() FUNCTION REFERENCE:

Syntax:
AttributeString := FileExist(FilePattern)

Parameters:
FilePattern - Path/pattern to check (supports wildcards)

Return Value:
String - Attribute string if exists, empty string if not

Attribute Characters:
D = Directory
A = Archive
R = ReadOnly
H = Hidden
S = System
N = Normal
O = Offline
C = Compressed

Key Points:
• Returns empty string "" if file/folder doesn't exist
• Returns attribute string if it exists (e.g., "A", "DA", "RAH")
• Check for "D" to distinguish directories from files
• Can be used directly in if statements (truthy/falsy)
• Works with wildcards (* and ?) but returns first match
• Case-insensitive on Windows

Common Use Cases:
✓ Validate files exist before processing
✓ Distinguish between files and directories
✓ Check file attributes
✓ Prevent file operation errors
✓ Configuration validation
✓ Conditional file operations

Best Practices:
• Always check existence before file operations
• Use IsDirectory helper for clarity
• Combine with try-catch for robust code
• Check specific attributes for special handling
)"

MsgBox(info, "FileExist() Reference", "Icon!")
