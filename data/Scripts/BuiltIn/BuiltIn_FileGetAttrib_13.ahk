#Requires AutoHotkey v2.0

/**
 * BuiltIn_FileGetAttrib_13.ahk
 * 
 * DESCRIPTION:
 * Basic usage of FileGetAttrib() to read file attributes
 * 
 * FEATURES:
 * - Read file attributes
 * - Check read-only status
 * - Detect hidden files
 * - Identify system files
 * - Check archive bit
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/FileGetAttrib.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - FileGetAttrib() function
 * - Attribute string parsing
 * - InStr() for attribute checking
 * - File attribute detection
 * - Attribute validation
 * 
 * LEARNING POINTS:
 * 1. FileGetAttrib() returns attribute string
 * 2. Attributes: R=ReadOnly, A=Archive, S=System, H=Hidden, N=Normal, D=Directory
 * 3. Use InStr() to check for specific attributes
 * 4. Can check multiple attributes at once
 * 5. Essential for file management and security
 * 6. Attributes control file behavior
 */

; ============================================================
; Example 1: Basic Attribute Retrieval
; ============================================================

; Create test file
testFile := A_ScriptDir "\attrib_test.txt"
FileAppend("Test content for attributes", testFile)

; Get attributes
attributes := FileGetAttrib(testFile)

output := "BASIC FILE ATTRIBUTES:`n`n"
output .= "File: attrib_test.txt`n"
output .= "Attributes: " attributes "`n`n"

; Parse individual attributes
output .= "Individual Attributes:`n"
output .= "  Read-Only (R): " (InStr(attributes, "R") ? "Yes" : "No") "`n"
output .= "  Archive (A): " (InStr(attributes, "A") ? "Yes" : "No") "`n"
output .= "  System (S): " (InStr(attributes, "S") ? "Yes" : "No") "`n"
output .= "  Hidden (H): " (InStr(attributes, "H") ? "Yes" : "No") "`n"
output .= "  Normal (N): " (InStr(attributes, "N") ? "Yes" : "No") "`n"
output .= "  Directory (D): " (InStr(attributes, "D") ? "Yes" : "No")

MsgBox(output, "File Attributes", "Icon!")

; ============================================================
; Example 2: Check Read-Only Status
; ============================================================

/**
 * Check if file is read-only
 * 
 * @param {String} filePath - File to check
 * @returns {Boolean} - True if read-only
 */
IsReadOnly(filePath) {
    if (!FileExist(filePath))
        return false

    attributes := FileGetAttrib(filePath)
    return InStr(attributes, "R") ? true : false
}

; Test read-only check
isReadOnly := IsReadOnly(testFile)

output := "READ-ONLY CHECK:`n`n"
output .= "File: attrib_test.txt`n"
output .= "Read-Only: " (isReadOnly ? "YES" : "NO") "`n`n"

; Make file read-only and check again
FileSetAttrib("+R", testFile)
isReadOnlyAfter := IsReadOnly(testFile)

output .= "After setting +R:`n"
output .= "Read-Only: " (isReadOnlyAfter ? "YES ✓" : "NO ✗")

MsgBox(output, "Read-Only Status", "Icon!")

; Remove read-only for cleanup
FileSetAttrib("-R", testFile)

; ============================================================
; Example 3: Detect Hidden Files
; ============================================================

/**
 * Check if file is hidden
 * 
 * @param {String} filePath - File to check
 * @returns {Boolean} - True if hidden
 */
IsHidden(filePath) {
    if (!FileExist(filePath))
        return false

    attributes := FileGetAttrib(filePath)
    return InStr(attributes, "H") ? true : false
}

/**
 * Find all hidden files in directory
 * 
 * @param {String} dirPath - Directory to search
 * @returns {Array} - Hidden files found
 */
FindHiddenFiles(dirPath) {
    hiddenFiles := []

    if (!DirExist(dirPath))
        return hiddenFiles

    Loop Files, dirPath "\*.*", "FH" {  ; H flag includes hidden files
        if (IsHidden(A_LoopFilePath)) {
            hiddenFiles.Push({
                name: A_LoopFileName,
                path: A_LoopFilePath
            })
        }
    }

    return hiddenFiles
}

; Create hidden test file
hiddenFile := A_ScriptDir "\hidden_test.txt"
FileAppend("Hidden content", hiddenFile)
FileSetAttrib("+H", hiddenFile)

; Find hidden files
hidden := FindHiddenFiles(A_ScriptDir)

output := "HIDDEN FILES DETECTION:`n`n"
output .= "Directory: " A_ScriptDir "`n"
output .= "Hidden Files Found: " hidden.Length "`n`n"

if (hidden.Length > 0) {
    output .= "Files:`n"
    for file in hidden
        output .= "  • " file.name "`n"
}

MsgBox(output, "Hidden Files", "Icon!")

; Remove hidden attribute for cleanup
FileSetAttrib("-H", hiddenFile)

; ============================================================
; Example 4: System File Detection
; ============================================================

/**
 * Check if file is a system file
 * 
 * @param {String} filePath - File to check
 * @returns {Boolean} - True if system file
 */
IsSystemFile(filePath) {
    if (!FileExist(filePath))
        return false

    attributes := FileGetAttrib(filePath)
    return InStr(attributes, "S") ? true : false
}

/**
 * Check file safety based on attributes
 * 
 * @param {String} filePath - File to check
 * @returns {Object} - Safety assessment
 */
AssessFileSafety(filePath) {
    result := {
        safe: true,
        warnings: []
    }

    if (!FileExist(filePath)) {
        result.safe := false
        result.warnings.Push("File does not exist")
        return result
    }

    attributes := FileGetAttrib(filePath)

    ; Check for system file
    if (InStr(attributes, "S")) {
        result.safe := false
        result.warnings.Push("System file - do not modify")
    }

    ; Check for read-only
    if (InStr(attributes, "R")) {
        result.warnings.Push("Read-only - cannot be modified without permission")
    }

    ; Check for hidden
    if (InStr(attributes, "H")) {
        result.warnings.Push("Hidden file - may be system-related")
    }

    return result
}

; Assess file safety
safety := AssessFileSafety(testFile)

output := "FILE SAFETY ASSESSMENT:`n`n"
output .= "File: attrib_test.txt`n"
output .= "Safe to Modify: " (safety.safe ? "YES ✓" : "NO ✗") "`n`n"

if (safety.warnings.Length > 0) {
    output .= "Warnings:`n"
    for warning in safety.warnings
        output .= "  • " warning "`n"
}

MsgBox(output, "Safety Check", safety.safe ? "Icon!" : "IconX")

; ============================================================
; Example 5: Archive Bit Checking
; ============================================================

/**
 * Check if file has archive bit set
 * 
 * @param {String} filePath - File to check
 * @returns {Boolean} - True if archive bit set
 */
HasArchiveBit(filePath) {
    if (!FileExist(filePath))
        return false

    attributes := FileGetAttrib(filePath)
    return InStr(attributes, "A") ? true : false
}

/**
 * Find files ready for backup (archive bit set)
 * 
 * @param {String} dirPath - Directory to search
 * @returns {Array} - Files ready for backup
 */
FindFilesForBackup(dirPath) {
    backupList := []

    if (!DirExist(dirPath))
        return backupList

    Loop Files, dirPath "\*.*", "F" {
        if (HasArchiveBit(A_LoopFilePath)) {
            backupList.Push({
                name: A_LoopFileName,
                path: A_LoopFilePath,
                size: A_LoopFileSize
            })
        }
    }

    return backupList
}

; Find files with archive bit
backupFiles := FindFilesForBackup(A_ScriptDir)

output := "ARCHIVE BIT CHECK:`n`n"
output .= "Files with Archive Bit: " backupFiles.Length "`n`n"

if (backupFiles.Length > 0) {
    output .= "Ready for Backup:`n"
    count := Min(5, backupFiles.Length)
    Loop count
        output .= "  • " backupFiles[A_Index].name "`n"

    if (backupFiles.Length > 5)
        output .= "  ... and " (backupFiles.Length - 5) " more"
}

MsgBox(output, "Archive Bit", "Icon!")

; ============================================================
; Example 6: Complete Attribute Analysis
; ============================================================

/**
 * Get detailed attribute information
 * 
 * @param {String} filePath - File to analyze
 * @returns {Object} - Detailed attribute info
 */
AnalyzeAttributes(filePath) {
    analysis := {
        exists: false,
        attributes: "",
        details: Map()
    }

    if (!FileExist(filePath))
        return analysis

    attrs := FileGetAttrib(filePath)
    analysis.exists := true
    analysis.attributes := attrs

    ; Detailed attribute analysis
    attributeInfo := Map(
        "R", { name: "Read-Only", description: "Cannot be modified or deleted", present: InStr(attrs, "R") },
        "A", { name: "Archive", description: "Modified since last backup", present: InStr(attrs, "A") },
        "S", { name: "System", description: "System file", present: InStr(attrs, "S") },
        "H", { name: "Hidden", description: "Hidden from normal view", present: InStr(attrs, "H") },
        "N", { name: "Normal", description: "No special attributes", present: InStr(attrs, "N") },
        "D", { name: "Directory", description: "Is a directory", present: InStr(attrs, "D") },
        "O", { name: "Offline", description: "Data not immediately available", present: InStr(attrs, "O") },
        "C", { name: "Compressed", description: "Compressed file", present: InStr(attrs, "C") }
    )

    analysis.details := attributeInfo
    return analysis
}

; Analyze file
analysis := AnalyzeAttributes(testFile)

if (analysis.exists) {
    output := "COMPLETE ATTRIBUTE ANALYSIS:`n`n"
    output .= "File: attrib_test.txt`n"
    output .= "Attributes: " analysis.attributes "`n`n"
    output .= "Detailed Breakdown:`n"

    for code, info in analysis.details {
        if (info.present) {
            output .= "  ✓ " info.name " (" code ")`n"
            output .= "    " info.description "`n"
        }
    }

    MsgBox(output, "Attribute Analysis", "Icon!")
}

; ============================================================
; Example 7: Batch Attribute Checking
; ============================================================

/**
 * Check attributes for multiple files
 * 
 * @param {Array} files - Files to check
 * @returns {Array} - Attribute information
 */
CheckBatchAttributes(files) {
    results := []

    for filePath in files {
        if (!FileExist(filePath))
            continue

        attributes := FileGetAttrib(filePath)
        SplitPath(filePath, &name)

        results.Push({
            name: name,
            path: filePath,
            attributes: attributes,
            isReadOnly: InStr(attributes, "R") ? true : false,
            isHidden: InStr(attributes, "H") ? true : false,
            isSystem: InStr(attributes, "S") ? true : false,
            hasArchive: InStr(attributes, "A") ? true : false
        })
    }

    return results
}

; Create test files
testFiles := []
Loop 3 {
    file := A_ScriptDir "\batch_test" A_Index ".txt"
    FileAppend("Content " A_Index, file)
    testFiles.Push(file)
}

; Set different attributes
FileSetAttrib("+R", testFiles[1])
FileSetAttrib("+H", testFiles[2])

; Check batch
batchResults := CheckBatchAttributes(testFiles)

output := "BATCH ATTRIBUTE CHECK:`n`n"
for item in batchResults {
    output .= item.name ":`n"
    output .= "  Attributes: " item.attributes "`n"
    output .= "  Read-Only: " (item.isReadOnly ? "Yes" : "No") "`n"
    output .= "  Hidden: " (item.isHidden ? "Yes" : "No") "`n`n"
}

MsgBox(output, "Batch Check", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
FILEGETATTRIB() FUNCTION REFERENCE:

Syntax:
AttributeString := FileGetAttrib(Filename)

Return Value:
String containing attribute characters

Attribute Characters:
R = ReadOnly (cannot modify/delete)
A = Archive (modified since backup)
S = System (system file)
H = Hidden (not shown normally)
N = Normal (no special attributes)
D = Directory (is a folder)
O = Offline (data offline)
C = Compressed (compressed)
T = Temporary (temporary file)
I = Not Content Indexed
E = Encrypted

Common Checks:
; Check read-only
if (InStr(FileGetAttrib(file), 'R'))
MsgBox('File is read-only')

; Check hidden
if (InStr(FileGetAttrib(file), 'H'))
MsgBox('File is hidden')

; Check multiple
attrs := FileGetAttrib(file)
if (InStr(attrs, 'R') && InStr(attrs, 'H'))
MsgBox('File is read-only AND hidden')

Use Cases:
✓ Security checks
✓ Backup systems
✓ File protection
✓ System file detection
✓ Hidden file management
✓ Permission validation

Best Practices:
• Check existence first
• Use InStr() for detection
• Understand attribute meanings
• Respect system files
• Cache attribute strings
• Document attribute requirements
)"

MsgBox(info, "FileGetAttrib() Reference", "Icon!")

; Cleanup
FileDelete(testFile)
FileDelete(hiddenFile)
Loop 3
    FileDelete(A_ScriptDir "\batch_test" A_Index ".txt")
